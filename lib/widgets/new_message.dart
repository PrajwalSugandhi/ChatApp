import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class NewMessage extends StatefulWidget {
  final messageController;
  final Function() changeEmoji;
  var isShowEmoji;
  final focusNode;
  NewMessage(
      {required this.changeEmoji,required this.isShowEmoji, required this.messageController, super.key, required this.focusNode});

  State<NewMessage> createState() {
    return _NewMessageState();
  }
}

class _NewMessageState extends State<NewMessage> {
  void _submitMessage() async {
    final enteredMessage = widget.messageController.text;
    widget.messageController.clear();
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
      'text': enteredMessage.trim(),
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
        padding: EdgeInsets.only(top: 8, left: 6, right: 6, bottom: 10),
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(65),
                    right: Radius.circular(65),
                  ),
                  color: Theme.of(context).colorScheme.secondaryContainer,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                        onPressed: widget.changeEmoji,
                        icon: Icon(widget.isShowEmoji ? Icons.keyboard : Icons.emoji_emotions_outlined)),
                    Expanded(
                        child: TextField(
                      focusNode: widget.focusNode,
                      controller: widget.messageController,
                      onTap: (){
                        if(widget.isShowEmoji){
                          widget.changeEmoji();
                        }
                      },
                      textCapitalization: TextCapitalization.sentences,
                      enableSuggestions: true,
                      decoration: InputDecoration(
                          hintText: 'Type a message...',
                          hintStyle: TextStyle(
                            color: Colors.black26,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          )),
                    )),
                  ],
                ),
              ),
            ),
            SizedBox(width: 10),
            CircleAvatar(
              child: IconButton(
                onPressed: _submitMessage,
                icon: Icon(Icons.send),
                color: Theme.of(context).colorScheme.primary,
              ),
              radius: 31,
            ),
          ],
        ));
  }
}
