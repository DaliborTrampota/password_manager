import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:password_manager/Components/Bubble.dart';

import 'package:password_manager/Helper/SecureStorage.dart';
import 'package:password_manager/Helper/Types.dart';
import 'package:password_manager/Helper/Utils.dart';

class DetailPage extends StatefulWidget {
  final AccountEntry data;

  const DetailPage({Key? key, required this.data}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  String passwordText = "*****";
  String decodedPassword = "";
  bool isVisible = false;
  bool isAuthenticated = false;
  bool _isAuthenticating = false;

  Future<void> _authenticate() async {
    setState(() => _isAuthenticating = true);

    bool authenticated = await authenticate();

    setState(() {
      isAuthenticated = authenticated;
      _isAuthenticating = false;
    });
  }

  void togglePassword(context) async {
    if (!isAuthenticated) {
      await _authenticate();

      if (!isAuthenticated) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Not authenticated")));
        return;
      }

      String encryptPass = await SecureStorage.getEncryptPass();
      try {
        decodedPassword = decryptPass(encryptPass, widget.data.password);
      } catch (err) {
        print(err);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Wrong master password!")));
        return;
      }
    }

    setState(() {
      isVisible = !isVisible;
      passwordText = isVisible ? decodedPassword : '*****';
    });
  }

  void copy(text, context) {
    if (isAuthenticated) {
      Clipboard.setData(ClipboardData(text: text));

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Copied into clipboard")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Authenticate first by pressing the eye button")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData t = Theme.of(context);

    var copyIcon = Icon(Icons.copy, color: t.colorScheme.onPrimary);

    return Scaffold(
      appBar: AppBar(title: Text(widget.data.siteName)),
      body: Center(
        child: Column(children: [
          //Text(widget.data.siteName, style: fieldStyle),
          Container(
            margin: const EdgeInsets.only(top: 10, right: 10, left: 10, bottom: 5),
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: t.colorScheme.primary,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Bubble(title: 'Username', style: t.textTheme.titleLarge),
                    Bubble(title: widget.data.username, style: t.textTheme.titleMedium),
                  ],
                ),
                IconButton(onPressed: () => copy(widget.data.username, context), icon: copyIcon)
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: t.colorScheme.primary,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Bubble(title: 'Password', style: t.textTheme.titleLarge),
                    Bubble(title: passwordText, style: t.textTheme.titleMedium),
                  ],
                ),
                IconButton(onPressed: () => copy(decodedPassword, context), icon: copyIcon)
              ],
            ),
          ),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => togglePassword(context),
        child: const Icon(Icons.remove_red_eye_rounded),
      ),
    );
  }
}
