import 'package:flutter/material.dart';

import 'package:password_manager/Helper/Types.dart';
import 'package:password_manager/Helper/Utils.dart';
import 'package:password_manager/Pages/DetailPage.dart';

class AccountTile extends StatefulWidget {
  final AccountEntry data;
  final AccountEntryActionFunction onEdit;
  final AccountEntryActionFunction onRemove;

  const AccountTile({Key? key, required this.data, required this.onEdit, required this.onRemove}) : super(key: key);

  @override
  _AccountTileState createState() => _AccountTileState();
}

class _AccountTileState extends State<AccountTile> {
  @override
  Widget build(BuildContext context) {
    final ThemeData t = Theme.of(context);

    return ListTile(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
        tileColor: t.colorScheme.primary,
        title: Text(widget.data.siteName,
            style: t.brightness == Brightness.light ? t.textTheme.titleMedium!.copyWith(color: Colors.grey.shade300) : t.textTheme.titleMedium),
        onTap: () => navigateTo(context, DetailPage(data: widget.data)), //extract this as parameter?
        subtitle: Text(widget.data.username,
            style: t.brightness == Brightness.light ? t.textTheme.titleSmall!.copyWith(color: Colors.grey.shade300) : t.textTheme.titleSmall),
        trailing: Wrap(children: [
          IconButton(
            splashRadius: 16,
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.all(4),
            icon: Icon(Icons.delete, color: t.colorScheme.onPrimary),
            onPressed: () => widget.onRemove(widget.data, context),
          ),
          IconButton(
            splashRadius: 16,
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.all(4),
            icon: Icon(Icons.edit, color: t.colorScheme.onPrimary),
            onPressed: () => widget.onEdit(widget.data, context),
          ),
        ]));
  }
}
