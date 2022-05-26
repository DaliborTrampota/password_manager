import 'package:flutter/material.dart';

import 'HomePage.dart';

import 'package:password_manager/Helper/Types.dart';
import 'package:password_manager/Helper/Utils.dart';
import 'package:password_manager/Helper/SecureStorage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool? isMasterPasswordSet;
  TextEditingController passContr = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  PasswordRequirements pr = PasswordRequirements(10, true, true, true);

  @override
  void initState() {
    super.initState();

    init();
  }

  Future init() async {
    bool hasPass = await SecureStorage.hasMasterPass();
    setState(() {
      isMasterPasswordSet = hasPass;
    });
  }

  validate(context) async {
    if (_formKey.currentState!.validate()) {
      if (isMasterPasswordSet == null) return;

      if (isMasterPasswordSet == true) {
        String masterPassword = await SecureStorage.getMasterPass();
        if (masterPassword != passContr.value.text) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Wrong password"),
          ));
          return;
        }
      } else {
        await SecureStorage.setMasterPass(passContr.value.text);
      }

      navigateTo(context, const HomePage(), clear: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(isMasterPasswordSet == true ? 'Unlock' : 'Create password',
                  style: const TextStyle(fontSize: 32)),
              TextFormField(
                controller: passContr,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 32),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    if (isMasterPasswordSet == true) {
                      return 'Please enter a password';
                    } else {
                      return "Please create a password";
                    }
                  }
                  return validatePassword(value, pr);
                },
              )
            ],
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () => validate(context),
        child: const Icon(Icons.login),
      ),
    );
  }
}
