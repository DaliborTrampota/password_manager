import 'dart:convert';
import 'package:crypto/crypto.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import './Types.dart';

class SecureStorage {
  static const _storage = FlutterSecureStorage();

  static const aOptions = AndroidOptions(encryptedSharedPreferences: true);
  static const iOptions = IOSOptions();

  static Future<String> getMasterPass() async {
    return await _storage.read(key: 'master', iOptions: iOptions, aOptions: aOptions) ?? '';
  }

  static Future<bool> compareMasterPassword(String password) async {
    Digest digest = sha256.convert(utf8.encode(password));
    String storedHash = await getMasterPass();
    return digest.toString() == storedHash;
  }

  static Future<bool> hasMasterPass() async {
    return await _storage.containsKey(key: 'master', iOptions: iOptions, aOptions: aOptions);
  }

  static setMasterPass(String password) async {
    Digest digest = sha256.convert(utf8.encode(password));
    await _storage.write(key: 'master', value: digest.toString(), iOptions: iOptions, aOptions: aOptions);
  }

  static saveEncryptPass(String password) async {
    await _storage.write(key: 'encoding', value: password, iOptions: iOptions, aOptions: aOptions);
  }

  static Future<String> getEncryptPass() async {
    return await _storage.read(key: 'encoding', iOptions: iOptions, aOptions: aOptions) ?? '';
  }
}
