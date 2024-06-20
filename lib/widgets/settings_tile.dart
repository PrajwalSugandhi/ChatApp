import 'package:flutter/material.dart';

class SettingsTile extends StatelessWidget {
  SettingsTile(
      {super.key,
      required this.title,
      required this.iconName,
      required this.onTap});
  final String title;
  final IconData iconName;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        iconName,
        color: Theme.of(context).colorScheme.primary,
        size: 35,
      ),
      title: Text(
        title,
        style: TextStyle(
          // color: Theme.of(context).colorScheme.secondary,
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 25,
        ),
      ),
      onTap: onTap,
    );
  }
}
