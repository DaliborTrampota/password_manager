import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

import 'Types.dart';

class DetailPage extends StatefulWidget {
  final AccountEntry data;

  const DetailPage({Key? key, required this.data}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  String passwordText = "*****";
  bool isVisible = false;
  bool isAuthenticated = false;
  List<BiometricType>? _availableBiometrics;
  bool? _canCheckBiometrics;
  bool _isAuthenticating = false;

  final LocalAuthentication auth = LocalAuthentication();

  @override
  void initState() {
    super.initState();

    init();
  }

  Future<void> init() async {
    List<BiometricType>? biometrics = await auth.getAvailableBiometrics();
    bool canCheck = await auth.canCheckBiometrics;

    setState(() {
      _availableBiometrics = biometrics;
      _canCheckBiometrics = canCheck;
    });
  }

  Future<void> authenticate() async {
    try {
      setState(() => _isAuthenticating = true);

      bool authenticated = await auth.authenticate(
        localizedReason: 'Let OS determine authentication method',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
      setState(() {
        isAuthenticated = authenticated;
        _isAuthenticating = false;
      });
    } on PlatformException catch (e) {
      if (e.code == 'NotAvailable') {
        //no pin nor biometrics set?
        setState(() => {isAuthenticated = true, _isAuthenticating = false});
        return;
      }
      print(e);
      setState(() => _isAuthenticating = false);
      return;
    }
  }

  Future<void> _cancelAuthentication() async {
    await auth.stopAuthentication();
    setState(() => _isAuthenticating = false);
  }

  void togglePassword(context) async {
    if (!isAuthenticated) {
      await authenticate();

      if (!isAuthenticated) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Not authenticated"),
        ));
        return;
      }
    }

    setState(() {
      isVisible = !isVisible;
      passwordText = isVisible ? widget.data.password : '*****';
    });
  }

  void copy(text, context) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Copied into clipboard"),
    ));
  }

  @override
  Widget build(BuildContext context) {
    TextStyle fieldStyle = const TextStyle(fontSize: 28, color: Colors.white);
    TextStyle titleStyle = const TextStyle(fontSize: 32, color: Colors.white);

    var copyIcon = const Icon(Icons.copy, color: Colors.white);

    return Scaffold(
      appBar: AppBar(title: Text(widget.data.siteName)),
      body: Center(
        child: Column(children: [
          //Text(widget.data.siteName, style: fieldStyle),
          Container(
            margin:
                const EdgeInsets.only(top: 10, right: 10, left: 10, bottom: 5),
            height: 100,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.blue),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text("Username", style: titleStyle)),
                    Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(widget.data.username, style: fieldStyle)),
                  ],
                ),
                IconButton(
                    onPressed: () => copy(widget.data.username, context),
                    icon: copyIcon)
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            height: 100,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.blue),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text("Password", style: titleStyle)),
                    Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(passwordText, style: fieldStyle)),
                  ],
                ),
                IconButton(
                    onPressed: () => copy(widget.data.password, context),
                    icon: copyIcon)
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
