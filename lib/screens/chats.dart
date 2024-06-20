import 'package:chatapp/screens/chatroom.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(top: 12, left: 10, right: 10),
      child: ListTile(
        onTap: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChatRoomScreen()));
        },
        title: Text('Chat Room', style: TextStyle(fontWeight: FontWeight.bold),),
        subtitle: Text('hi'),
        leading: CircleAvatar(
          radius: 23,
          backgroundImage: AssetImage(
            'assets/images/chatroom.png'
          ),
        ),
      ),
    );
  }
}
