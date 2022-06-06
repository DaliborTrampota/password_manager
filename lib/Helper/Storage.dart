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

  static Future<void> createEntry(AccountEntry data) async {
    return await accountBox!.put(data.siteName, data);
  }

  static bool siteExists(String name) {
    return accountBox?.containsKey(name) ?? false;
  }

  static List<AccountEntry> getAccounts() {
    return accountBox?.values.toList() ?? [];
  }

  static Future<void> removeSite(String name) async {
    return await accountBox!.delete(name);
  }

  static Future editSite(String name, AccountEntry newData) async {
    await Storage.removeSite(name);
    await Storage.createEntry(newData);
  }
}
