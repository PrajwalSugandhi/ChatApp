import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/API/apis.dart';
import 'package:chatapp/helper/dateformattor.dart';
import 'package:chatapp/models/chat_user.dart';
import 'package:chatapp/models/message.dart';
import 'package:chatapp/screens/chatroom.dart';
import 'package:chatapp/widgets/profile_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../screens/chat_screen.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;
  const ChatUserCard({required this.user, super.key});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  Message? _message;
  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.only(top: 12, left: 10, right: 10),
        child: StreamBuilder(
          stream: APIs.getLastMessage(widget.user),
          builder: (context, snapshot) {
            final data = snapshot.data?.docs;
            final list =
                data?.map((e) => Message.fromJson(e.data())).toList() ?? [];
            if (list.isNotEmpty) _message = list[0];

            return ListTile(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ChatScreen(
                          user: widget.user,
                        )));
              },

              leading: ProfileImage(
                  size: MediaQuery.of(context).size.height * .067,
                  url: widget.user.image),


              title: Text(widget.user.name),


              subtitle: _message != null
                  ? _message!.type == Type.image
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.photo,
                              size: 18,
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            Text('Photo')
                          ],
                        )
                      : Text(
                          _message!.msg,
                          maxLines: 1,
                        )
                  : Text(
                      widget.user.about,
                      maxLines: 1,
                    ),


              trailing: _message == null
                  ? null
                  : _message!.read.isEmpty && _message!.fromId != APIs.user.uid
                      ?

                      Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              MyDateUtil.getLastMessageTime(
                                  context: context, time: _message!.sent),
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 0, 230, 119)),
                            ),
                            const SizedBox(
                              width: 15,
                              height: 15,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 0, 230, 119),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                              ),
                            ),
                          ],
                        )
                      :

                      Text(
                          MyDateUtil.getLastMessageTime(
                              context: context, time: _message!.sent),
                          style: const TextStyle(color: Colors.black54),
                        ),
            );
          },
        )
        );
    ;
  }
}
