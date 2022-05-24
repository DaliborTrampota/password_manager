import 'package:flutter/material.dart';
import 'package:password_manager/SecureStorage.dart';

import 'DetailPage.dart';
import 'Form.dart';
import 'Types.dart';
import 'Utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  final title = "Saved Passwords";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<AccountEntry> accounts = [];
  /*<Object>[];[
    AccountEntry('Google', 'dalibor', '12345'),
    AccountEntry('Gmail', 'pepa', '54321')
  ];*/

  @override
  void initState() {
    super.initState();

    init();
  }

  Future init() async {
    final accounts = await SecureStorage.getAccounts();

    setState(() {
      this.accounts = accounts;
    });
  }

  void removeSite(siteName) {
    SecureStorage.removeSite(siteName);
    setState(() {
      accounts = accounts.where((a) => a.siteName != siteName).toList();
    });
  }

  Widget render(AccountEntry data) {
    return ListTile(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        tileColor: Colors.blue,
        title: Text(data.siteName,
            style: const TextStyle(fontSize: 24, color: Colors.white)),
        onTap: () => navigateTo(context, DetailPage(data: data)),
        subtitle: Text(data.username,
            style: const TextStyle(fontSize: 18, color: Colors.white)),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.white),
          onPressed: () => removeSite(data.siteName),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: ListView.separated(
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(height: 5);
          },
          padding: const EdgeInsets.all(8.0),
          itemCount: accounts.length,
          itemBuilder: (context, i) {
            return render(accounts[i]);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => navigateTo(context, const FormPage()),
        child: const Icon(Icons.add),
      ),
    );
  }
}
