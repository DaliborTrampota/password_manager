import 'dart:convert';

class AccountEntry {
  String siteName;
  String username;
  String password;
  AccountEntry(this.siteName, this.username, this.password);

  factory AccountEntry.fromJson(Map<String, dynamic> jsonData) {
    return AccountEntry(
        jsonData['siteName'], jsonData['username'], jsonData['password']);
  }

  static Map<String, dynamic> toMap(AccountEntry data) => {
        'siteName': data.siteName,
        'username': data.username,
        'password': data.password
      };

  static String serialize(AccountEntry data) =>
      json.encode(AccountEntry.toMap(data));

  static AccountEntry deserialize(String json) =>
      AccountEntry.fromJson(jsonDecode(json));
}
