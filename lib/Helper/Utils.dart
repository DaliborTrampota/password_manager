import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:password_manager/Helper/Types.dart';

void navigateTo(context, StatefulWidget page, {clear = false}) {
  if (clear) {
    Navigator.pushAndRemoveUntil(
        context, MaterialPageRoute(builder: (context) => page), (r) => false);
  } else {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }
}

String encryptPass(String masterPassword, String pass) {
  if (masterPassword.length < 32) {
    int count = 32 - masterPassword.length;
    for (var i = 0; i < count; i++) {
      masterPassword += ".";
    }
  }
  final key = encrypt.Key.fromUtf8(masterPassword);
  final plainText = pass;
  final iv = encrypt.IV.fromLength(16);

  final encrypter = encrypt.Encrypter(encrypt.AES(key));
  final e = encrypter.encrypt(plainText, iv: iv);

  return e.base64.toString();
}

String decryptPass(String masterPassword, String pass) {
  if (masterPassword.length < 32) {
    int count = 32 - masterPassword.length;
    for (var i = 0; i < count; i++) {
      masterPassword += ".";
    }
  }

  final iv = encrypt.IV.fromLength(16);
  final key = encrypt.Key.fromUtf8(masterPassword);

  try {
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final decrypted = encrypter.decrypt64(pass, iv: iv);

    return decrypted;
  } catch (err) {
    print(err);
    throw "Wrong Master Password";
  }
}

List<BiometricType>? biometrics;
bool? canCheckBiometrics;
LocalAuthentication auth = LocalAuthentication();

Future<void> initAuth() async {
  biometrics = await auth.getAvailableBiometrics();
  canCheckBiometrics = await auth.canCheckBiometrics;
}

Future<bool> authenticate() async {
  try {
    if (canCheckBiometrics == null) await initAuth();

    bool authenticated = await auth.authenticate(
      localizedReason: 'Login to reveal the password',
      options: const AuthenticationOptions(
        useErrorDialogs: true,
        stickyAuth: true,
      ),
    );
    return authenticated;
  } on PlatformException catch (err) {
    if (err.code == 'NotAvailable') {
      //no pin nor biometrics set?
      return true;
    }
    print(err);
    return false;
  }
}

Future<void> cancelAuthentication() async {
  await auth.stopAuthentication();
}

String? validatePassword(String? password, PasswordRequirements pr) {
  if (password == null || password.isEmpty) {
    return 'Please enter a password';
  }
  if (password.length < pr.minLength) {
    return 'Password is too short. Password should be at least ${pr.minLength} long.';
  }
  if (pr.requireNumber && !password.contains(RegExp(r"\d"))) {
    return 'Password has to include at least one number.';
  }
  if (pr.requireSpecialChar &&
      !password.contains(RegExp(PasswordRequirements.specialChars))) {
    return 'Password has to include at least one special character: ${PasswordRequirements.specialChars}';
  }
  if (pr.requireUpperCase && !password.contains(RegExp(r"[A-Z]"))) {
    return 'Password has to include at least one uppercase letter.';
  }
  return null;
}
