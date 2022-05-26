import 'package:flutter/material.dart';
import 'package:password_manager/Helper/SecureStorage.dart';
import 'package:password_manager/Pages/HomePage.dart';

import 'package:password_manager/Helper/Types.dart';
import 'package:password_manager/Helper/Utils.dart';
import 'package:password_manager/Helper/Storage.dart';

PasswordRequirements pr = PasswordRequirements(8, true, true, true);

class EditForm extends StatefulWidget {
  const EditForm({Key? key, required this.data}) : super(key: key);

  final AccountEntry data;
  final title = "Edit Account";

  @override
  _EditFormState createState() => _EditFormState();
}

class _EditFormState extends State<EditForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController siteContr = TextEditingController();
  TextEditingController usernameContr = TextEditingController();
  TextEditingController passwordContr = TextEditingController();
  String masterPassword = '';

  void validate(context) async {
    if (_formKey.currentState!.validate()) {
      AccountEntry data =
          AccountEntry(siteContr.text, usernameContr.text, passwordContr.text);

      data.password = encryptPass(masterPassword, passwordContr.text);
      Storage.editSite(widget.data.siteName, data);
      _formKey.currentState?.reset();
      navigateTo(context, const HomePage(), clear: true);
    }
  }

  @override
  void initState() {
    super.initState();

    init();
  }

  Future init() async {
    masterPassword = await SecureStorage.getMasterPass();
    try {
      widget.data.password = decryptPass(masterPassword, widget.data.password);
    } catch (err) {
      print(err);
    }

    siteContr.text = widget.data.siteName;
    usernameContr.text = widget.data.username;
    passwordContr.text = widget.data.password;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData t = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: siteContr,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(10),
                    labelText: 'Site name or URL',
                    hintText: 'Google',
                    labelStyle: t.textTheme.labelMedium),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a site name or URL';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: usernameContr,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(10),
                    labelText: 'Username',
                    hintText: 'Dalibor',
                    labelStyle: t.textTheme.labelMedium),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a username';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: passwordContr,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(10),
                    labelText: 'Password',
                    hintText: '******',
                    labelStyle: t.textTheme.labelMedium),
                obscureText: true,
                validator: (value) {
                  return validatePassword(value, pr);
                },
              ),
            ],
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () => validate(context),
        child: const Icon(Icons.save),
      ),
    );
  }
}
