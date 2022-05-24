import 'package:flutter/material.dart';

void navigateTo(context, StatefulWidget page) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}
