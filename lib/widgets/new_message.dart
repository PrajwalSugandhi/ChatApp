import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewMessage extends StatefulWidget {
  NewMessage({super.key});

  State<NewMessage> createState() {
    return _NewMessageState();
  }
}

class _NewMessageState extends State<NewMessage> {
  var _messageController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _messageController.dispose();
  }

  void _submitMessage() async {
    final enteredMessage = _messageController.text;
    _messageController.clear();
    if (enteredMessage.trim().isEmpty) {
      return;
    }
    FocusScope.of(context).unfocus();
    final user = FirebaseAuth.instance.currentUser!;

    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    FirebaseFirestore.instance.collection('chat').add({
      'text': enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'username': userData.data()!['username'],
      'userImage': userData.data()!['imageUrl'],
    });


  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
        padding: EdgeInsets.only(left: 15, right: 1, bottom: 14),
        child: Row(
          children: [
            Expanded(
                child: TextField(
              controller: _messageController,
              textCapitalization: TextCapitalization.sentences,
              enableSuggestions: true,
              decoration: InputDecoration(labelText: 'Message'),
            )),
            IconButton(
              onPressed: _submitMessage,
              icon: Icon(Icons.send),
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        ));
  }
}
