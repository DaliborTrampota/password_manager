import 'package:flutter/material.dart';
import 'package:password_manager/Components/AccountTile.dart';
import 'package:password_manager/Pages/DetailPage.dart';

import 'package:password_manager/Helper/Types.dart';
import 'package:password_manager/Helper/Utils.dart';
import 'package:password_manager/Helper/Storage.dart';
import 'package:password_manager/Pages/FormPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  final title = "Saved Passwords";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<AccountEntry> accounts = [];

  @override
  void initState() {
    super.initState();

    setState(() {
      accounts = Storage.getAccounts();
    });
  }

  void removeSite(AccountEntry data, context) async {
    await Storage.removeSite(data.siteName);
    setState(() {
      accounts = Storage.getAccounts();
    });
  }

  void editSite(AccountEntry data, context) async {
    bool authenticated = await authenticate();

    if (!authenticated) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Not authenticated")));
      return;
    }

    navigateTo(context, FormPage(data: data));
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
            return AccountTile(
              data: accounts[i],
              onEdit: editSite,
              onRemove: removeSite,
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => navigateTo(context, FormPage()),
        child: const Icon(Icons.add),
      ),
    );
  }
}
