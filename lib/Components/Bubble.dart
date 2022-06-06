import 'package:flutter/material.dart';

class Bubble extends StatelessWidget {
  late final TextStyle? style;
  final String title;

  Bubble({Key? key, required this.title, this.style}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData t = Theme.of(context);
    style ??= t.textTheme.titleMedium;

    return Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Text(title, style: t.brightness == Brightness.light ? style!.copyWith(color: Colors.grey.shade300) : style));
  }
}
