import 'package:flutter/material.dart';
import 'package:password_manager/Helper/Types.dart';

class FormField extends StatelessWidget {
  late final TextStyle? style;
  final String title;
  final String? hint;
  final TextEditingController? controller;
  final ValidateFunction validate;

  FormField({Key? key, required this.title, required this.validate, this.hint, this.controller, this.style}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData t = Theme.of(context);
    style ??= t.textTheme.titleMedium;

    return TextFormField(
        controller: controller,
        decoration: InputDecoration(contentPadding: const EdgeInsets.all(10), labelText: title, hintText: hint, labelStyle: t.textTheme.labelMedium),
        validator: validate);
  }
}
