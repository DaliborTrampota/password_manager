import 'package:flutter/material.dart';

void navigateTo(context, StatefulWidget page, {clear = false}) {
  if (clear) {
    Navigator.pushAndRemoveUntil(
        context, MaterialPageRoute(builder: (context) => page), (r) => false);
  } else {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }
}
