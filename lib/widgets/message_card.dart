import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/helper/dateformattor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../api/apis.dart';
import '../main.dart';
import '../models/message.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message});

  final Message message;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    bool isMe = APIs.user.uid == widget.message.fromId;
    return InkWell(child: isMe ? _greenMessage() : _blueMessage());
  }

  // sender
  Widget _blueMessage() {
    if (widget.message.read.isEmpty) {
      APIs.updateMessageReadStatus(widget.message);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.message.type == Type.image
                ? MediaQuery.of(context).size.width * .022
                : MediaQuery.of(context).size.width * .04),
            margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * .04,
                vertical: MediaQuery.of(context).size.height * .01),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 221, 245, 255),
                border: Border.all(color: Colors.lightBlue),
                //making borders curved
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20))),
            child: widget.message.type == Type.text
                ? Text(
                    widget.message.msg,
                    style: const TextStyle(fontSize: 15, color: Colors.black87),
                  )
                : ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    child: CachedNetworkImage(
                      imageUrl: widget.message.msg,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: SizedBox(height: 200, width: 200),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.image, size: 70),
                    ),
                  ),
          ),
        ),
        Padding(
          padding:
              EdgeInsets.only(right: MediaQuery.of(context).size.width * .04),
          child: Text(
            MyDateUtil.getFormattedTime(
                context: context, time: widget.message.sent),
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
        ),
      ],
    );
  }

  Widget _greenMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(width: MediaQuery.of(context).size.width * .04),
            Text(
              MyDateUtil.getFormattedTime(
                  context: context, time: widget.message.sent),
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
            const SizedBox(width: 2),
            widget.message.read.isNotEmpty
                ? Icon(Icons.done_all_rounded, color: Colors.blue, size: 20)
                : Icon(
                    Icons.done,
                    color: Colors.grey,
                    size: 20,
                  ),
          ],
        ),
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.message.type == Type.image
                ? MediaQuery.of(context).size.width * .022
                : MediaQuery.of(context).size.width * .04),
            margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * .04,
                vertical: MediaQuery.of(context).size.height * .01),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 218, 255, 176),
                border: Border.all(color: Colors.lightGreen),
                //making borders curved
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20))),
            child: widget.message.type == Type.text
                ? Text(
                    widget.message.msg,
                    style: const TextStyle(fontSize: 15, color: Colors.black87),
                  )
                : ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    child: CachedNetworkImage(
                      imageUrl: widget.message.msg,
                      placeholder: (context, url) => const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: SizedBox(height: 200, width: 200),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.image, size: 70),
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
