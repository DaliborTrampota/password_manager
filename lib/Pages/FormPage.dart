import 'package:flutter/material.dart';
import 'package:password_manager/Pages/HomePage.dart';

import 'package:password_manager/Helper/Types.dart';
import 'package:password_manager/Helper/Utils.dart';
import 'package:password_manager/Helper/SecureStorage.dart';
import 'package:password_manager/Helper/Storage.dart';

PasswordRequirements pr = PasswordRequirements(8, true, true, true);

class FormPage extends StatefulWidget {
  late final FormMode mode;
  final AccountEntry? data;
  FormPage({Key? key, this.data}) : super(key: key) {
    //for readability. Could use data == null instead of mode == FormMode.create
    if (data == null) {
      mode = FormMode.create;
    } else {
      mode = FormMode.edit;
    }
  }

  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController siteContr = TextEditingController();
  TextEditingController usernameContr = TextEditingController();
  TextEditingController passwordContr = TextEditingController();
  late String encryptPassword;
  String decryptedPassword = "";

  void validate(context) async {
    if (!_formKey.currentState!.validate()) return;

    //could be moved into a separate function or copied into each if statement I chose not to for readability.
    AccountEntry data = AccountEntry(siteContr.text, usernameContr.text, passwordContr.text);
    data.password = encryptPass(encryptPassword, data.password);

    if (widget.mode == FormMode.create) {
      if (Storage.siteExists(siteContr.text)) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("You already have a site with that name saved!"),
        ));
        return;
      }

      await Storage.createSite(data);
    } else if (widget.mode == FormMode.edit) {
      await Storage.editSite(widget.data!.siteName, data);
    }

    _formKey.currentState?.reset();
    navigateTo(context, const HomePage(), clear: true);
  }

  @override
  void initState() {
    super.initState();

    init();
  }

  Future init() async {
    encryptPassword = await SecureStorage.getEncryptPass();

    if (widget.mode == FormMode.edit) {
      try {
        decryptedPassword = decryptPass(encryptPassword, widget.data!.password);
      } catch (err) {
        print(err);
      }

      siteContr.text = widget.data!.siteName;
      usernameContr.text = widget.data!.username;
      passwordContr.text = decryptedPassword;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData t = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(widget.mode == FormMode.create ? "New Account" : "Edit Account")),
      body: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: siteContr,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(10),
                  labelText: 'Site name or URL',
                  hintText: widget.data != null ? widget.data!.siteName : 'Google',
                  labelStyle: t.textTheme.labelMedium,
                ),
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
                  hintText: widget.data != null ? widget.data!.username : 'Dalibor',
                  labelStyle: t.textTheme.labelMedium,
                ),
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
                  hintText: decryptedPassword.isNotEmpty ? decryptedPassword : '******',
                  labelStyle: t.textTheme.labelMedium,
                ),
                obscureText: widget.mode != FormMode.edit,
                validator: (value) {
                  return validatePassword(value, pr);
                },
              )
            ],
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () => validate(context),
        child: const Icon(Icons.save),
      ),
    );
  }
}
