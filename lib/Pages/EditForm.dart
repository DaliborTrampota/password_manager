import 'package:flutter/material.dart';
import 'package:password_manager/Pages/HomePage.dart';

import 'package:password_manager/Helper/Types.dart';
import 'package:password_manager/Helper/Utils.dart';
import 'package:password_manager/Helper/SecureStorage.dart';

PasswordRequirements pr = PasswordRequirements(8, true, true, true);

class EditForm extends StatefulWidget {
  const EditForm({Key? key, required this.data}) : super(key: key);

  final AccountEntry data;
  final title = "New Account";

  @override
  _EditFormState createState() => _EditFormState();
}

class _EditFormState extends State<EditForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController siteContr = TextEditingController();
  TextEditingController usernameContr = TextEditingController();
  TextEditingController passwordContr = TextEditingController();

  void validate(context) async {
    if (_formKey.currentState!.validate()) {
      AccountEntry data =
          AccountEntry(siteContr.text, usernameContr.text, passwordContr.text);
      await SecureStorage.editSite(widget.data.siteName, data);
      _formKey.currentState?.reset();
      navigateTo(context, const HomePage(), clear: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    siteContr.text = widget.data.siteName;
    usernameContr.text = widget.data.username;
    passwordContr.text = widget.data.password;

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: siteContr,
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    labelText: 'Site name or URL',
                    hintText: 'Google',
                    labelStyle:
                        TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a site name or URL';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: usernameContr,
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    labelText: 'Username',
                    hintText: 'Dalibor',
                    labelStyle:
                        TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a username';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: passwordContr,
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    labelText: 'Password',
                    hintText: '******',
                    labelStyle:
                        TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  if (value.length < pr.minLength) {
                    return 'Password is too short. Password should be at least ${pr.minLength} long.';
                  }
                  if (pr.requireNumber && !value.contains(RegExp(r"\d"))) {
                    return 'Password has to include at least one number.';
                  }

                  if (pr.requireSpecialChar &&
                      !value.contains(
                          RegExp(PasswordRequirements.specialChars))) {
                    return 'Password has to include at least one special character: ${PasswordRequirements.specialChars}';
                  }
                  if (pr.requireUpperCase &&
                      !value.contains(RegExp(r"[A-Z]"))) {
                    return 'Password has to include at least one uppercase letter.';
                  }

                  return null;
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
