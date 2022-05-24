import 'package:flutter/material.dart';
import 'package:password_manager/HomePage.dart';
import 'package:password_manager/SecureStorage.dart';
import 'package:password_manager/Types.dart';
import 'package:password_manager/Utils.dart';

Map<String, dynamic> passwordRequirements = {
  "minLength": 8,
  "requireNumber": true,
  "requireSpecialChar": true,
  "requireUpperCase": true
};

class FormPage extends StatefulWidget {
  const FormPage({Key? key}) : super(key: key);

  final title = "New Account";

  @override
  _FormPageState createState() => _FormPageState();
}

final _formKey = GlobalKey<FormState>();
TextEditingController siteContr = TextEditingController();
TextEditingController usernameContr = TextEditingController();
TextEditingController passwordContr = TextEditingController();

class _FormPageState extends State<FormPage> {
  void validate(context) async {
    if (_formKey.currentState!.validate()) {
      bool siteExists = await SecureStorage.siteExists(siteContr.text);
      if (siteExists) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("You already have a site with that name saved!"),
        ));
        return;
      }
      AccountEntry data =
          AccountEntry(siteContr.text, usernameContr.text, passwordContr.text);
      await SecureStorage.createEntry(data);

      navigateTo(context, const HomePage());
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  if (value.length < passwordRequirements['minLength']) {
                    return 'Password is too short. Password should be at least ${passwordRequirements['minLength']} long.';
                  }
                  if (!value.contains(RegExp(r"\d")) &&
                      passwordRequirements['requireNumber']) {
                    return 'Password has to include at least one number.';
                  }
                  if (!value.contains(RegExp(r"[.,!?:*/\\]")) &&
                      passwordRequirements['requireSpecialChar']) {
                    return 'Password has to include at least one special character. Special characters are: .,!?:*/\\';
                  }
                  if (!value.contains(RegExp(r"[A-Z]")) &&
                      passwordRequirements['requireUpperCase']) {
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
