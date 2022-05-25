import 'package:flutter/material.dart';

import 'DetailPage.dart';
import 'CreateForm.dart';
import 'EditForm.dart';

import 'package:password_manager/Helper/Types.dart';
import 'package:password_manager/Helper/Utils.dart';
import 'package:password_manager/Helper/SecureStorage.dart';

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

  Widget renderTile(AccountEntry data) {
    return ListTile(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        tileColor: Colors.blue,
        title: Text(data.siteName,
            style: const TextStyle(fontSize: 24, color: Colors.white)),
        onTap: () => navigateTo(context, DetailPage(data: data)),
        subtitle: Text(data.username,
            style: const TextStyle(fontSize: 18, color: Colors.white)),
        trailing: Wrap(children: [
          IconButton(
            splashRadius: 16,
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.all(4),
            icon: const Icon(Icons.delete, color: Colors.white),
            onPressed: () => removeSite(data.siteName),
          ),
          IconButton(
            splashRadius: 16,
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.all(4),
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () => navigateTo(context, EditForm(data: data)),
          ),
        ]));
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
            return renderTile(accounts[i]);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => navigateTo(context, const CreateForm()),
        child: const Icon(Icons.add),
      ),
    );
  }
}
