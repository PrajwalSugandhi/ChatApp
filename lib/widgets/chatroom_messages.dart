import 'package:chatapp/widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatRoomMessages extends StatefulWidget {
  ChatRoomMessages({super.key});

  @override
  State<ChatRoomMessages> createState() => _ChatRoomMessagesState();
}

class _ChatRoomMessagesState extends State<ChatRoomMessages> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    final currentuser = FirebaseAuth.instance.currentUser!;

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chat')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (ctx, chatSnapshots) {
          if (chatSnapshots.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!chatSnapshots.hasData || chatSnapshots.data!.docs.isEmpty) {
            return const Center(
              child: Text('No messages found'),
            );
          }

          if (chatSnapshots.hasError) {
            return const Center(
              child: Text('Something went wrong. Please try again'),
            );
          }

          final loadedMessages = chatSnapshots.data!.docs;

          return ListView.builder(
              padding: EdgeInsets.only(bottom: 40, right: 13, left: 13),
              itemCount: loadedMessages.length,
              reverse: true,
              itemBuilder: (ctx, index) {
                final chatMessage = loadedMessages[index].data();
                final nextChatMessage = index + 1 < loadedMessages.length
                    ? loadedMessages[index + 1].data()
                    : null;
                final currentMessageUserId = chatMessage['userId'];
                final nextMessageUserId =
                    nextChatMessage != null ? nextChatMessage['userId'] : null;
                final nextUserIsSame =
                    nextMessageUserId == currentMessageUserId;
                final isMe = currentuser.uid == currentMessageUserId;
                // print(chatMessage);
                if (nextUserIsSame) {
                  return MessageBubble.next(
                      message: chatMessage['text'], isMe: isMe);
                } else {
                  return MessageBubble.first(
                      userImage: chatMessage['userImage'],
                      username: chatMessage['username'],
                      message: chatMessage['text'],
                      isMe: isMe);
                }
              });
        });
  }
}
