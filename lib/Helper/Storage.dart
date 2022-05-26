import 'dart:io';

import 'package:hive_flutter/hive_flutter.dart';
import './Types.dart';

class Storage {
  static final Storage _storage = Storage._privateConstructor();
  static Box<AccountEntry>? accountBox;
  static bool initialized = false;

  static Future<Storage> create() async {
    if (initialized) return _storage;

    await Hive.initFlutter();
    Hive.registerAdapter(AccountEntryAdapter());
    accountBox = await Hive.openBox('accounts');

    initialized = true;
    return _storage;
  }

  Storage._privateConstructor();

  static createEntry(AccountEntry data) {
    accountBox!.put(data.siteName, data);
  }

  static bool siteExists(String name) {
    return accountBox?.containsKey(name) ?? false;
  }

  static List<AccountEntry> getAccounts() {
    return accountBox?.values.toList() ?? [];
  }

  static removeSite(String name) {
    accountBox!.delete(name);
  }

  static Future editSite(String name, AccountEntry newData) async {
    Storage.removeSite(name);
    Storage.createEntry(newData);
  }
}
