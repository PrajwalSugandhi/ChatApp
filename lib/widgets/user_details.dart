import 'package:flutter/material.dart';

class UserDetail extends StatelessWidget {
  const UserDetail({super.key, required this.heading, required this.data, required this.iconData});
  final String heading;
  final String data;
  final IconData iconData;



  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        heading,
        style: TextStyle(
          fontSize: 12,
          color: Colors.black45,
        ),
      ),
      subtitle: Text(
        data,
        style: TextStyle(
          fontSize: 18,
        ),
      ),
      leading: Icon(iconData, color: Colors.black45,),
    );
  }
}
