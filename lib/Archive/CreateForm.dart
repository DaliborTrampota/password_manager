import 'package:flutter/material.dart';
import 'package:password_manager/Pages/HomePage.dart';

import 'package:password_manager/Helper/Types.dart';
import 'package:password_manager/Helper/Utils.dart';
import 'package:password_manager/Helper/SecureStorage.dart';
import 'package:password_manager/Helper/Storage.dart';

PasswordRequirements pr = PasswordRequirements(8, true, true, true);

class CreateForm extends StatefulWidget {
  const CreateForm({Key? key}) : super(key: key);

  final title = "New Account";

  @override
  _CreateFormState createState() => _CreateFormState();
}

final _formKey = GlobalKey<FormState>();
TextEditingController siteContr = TextEditingController();
TextEditingController usernameContr = TextEditingController();
TextEditingController passwordContr = TextEditingController();

class _CreateFormState extends State<CreateForm> {
  void validate(context) async {
    if (_formKey.currentState!.validate()) {
      bool siteExists = Storage.siteExists(siteContr.text);
      if (siteExists) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("You already have a site with that name saved!"),
        ));
        return;
      }
      AccountEntry data = AccountEntry(siteContr.text, usernameContr.text, passwordContr.text);

      String masterPassword = await SecureStorage.getMasterPass();
      data.password = encryptPass(masterPassword, data.password);
      Storage.createEntry(data);

      _formKey.currentState?.reset();
      navigateTo(context, const HomePage(), clear: true);
    }
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
                    contentPadding: const EdgeInsets.all(10), labelText: 'Site name or URL', hintText: 'Google', labelStyle: t.textTheme.labelMedium),
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
                    contentPadding: const EdgeInsets.all(10), labelText: 'Username', hintText: 'Dalibor', labelStyle: t.textTheme.labelMedium),
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
                    contentPadding: const EdgeInsets.all(10), labelText: 'Password', hintText: '******', labelStyle: t.textTheme.labelMedium),
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
