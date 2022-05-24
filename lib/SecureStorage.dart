import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:password_manager/Types.dart';

class SecureStorage {
  static const _storage = FlutterSecureStorage();

  static const aOptions = AndroidOptions(encryptedSharedPreferences: true);
  static const iOptions = IOSOptions();

  static Future createEntry(AccountEntry data) async {
    await _storage.write(
        key: data.siteName,
        value: AccountEntry.serialize(data),
        iOptions: iOptions,
        aOptions: aOptions);
  }

  static Future<bool> siteExists(String name) async {
    var data =
        await _storage.read(key: name, aOptions: aOptions, iOptions: iOptions);
    return data == null ? false : true;
  }

  static Future<List<AccountEntry>> getAccounts() async {
    return _storage
        .readAll(aOptions: aOptions, iOptions: iOptions)
        .then((table) {
      List<AccountEntry> accounts = [];
      table.forEach((key, data) {
        accounts.add(AccountEntry.deserialize(data));
      });
      return accounts;
    });
  }

  static Future removeSite(String name) async {
    _storage.delete(key: name, aOptions: aOptions, iOptions: iOptions);
  }
}
