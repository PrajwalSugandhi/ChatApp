import 'dart:developer';
import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../API/apis.dart';
import '../models/chat_user.dart';
import '../models/message.dart';
import '../widgets/message_card.dart';
import '../widgets/profile_image.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;

  ChatScreen({required this.user, super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Message> _list = [];

  final _textController = TextEditingController();

  bool _showEmoji = false, _isUploading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: _appBar(),
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: APIs.getAllMessages(widget.user),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return const SizedBox();

                    case ConnectionState.active:
                    case ConnectionState.done:
                      final data = snapshot.data?.docs;
                      _list = data
                              ?.map((e) => Message.fromJson(e.data()))
                              .toList() ??
                          [];

                      if (_list.isNotEmpty) {
                        return ListView.builder(
                            reverse: true,
                            itemCount: _list.length,
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * .01),
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return MessageCard(message: _list[index]);
                            });
                      } else {
                        return SizedBox();
                      }
                  }
                },
              ),
            ),
            if (_isUploading)
              const Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                      child: CircularProgressIndicator(strokeWidth: 2))),
            _chatInput(),
            if (_showEmoji)
              SizedBox(
                height: MediaQuery.of(context).size.height * .35,
                child: EmojiPicker(
                  textEditingController: _textController,
                  config: const Config(),
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget _appBar() {
    return SafeArea(
      child: InkWell(
          onTap: () {
            // print('hello');
          },
          child: StreamBuilder(
              stream: APIs.getUserInfo(widget.user),
              builder: (context, snapshot) {
                final data = snapshot.data?.docs;
                final list =
                    data?.map((e) => ChatUser.fromJson(e.data())).toList() ??
                        [];

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back,
                            color: Colors.black54)),
                    ProfileImage(
                      size: MediaQuery.of(context).size.height * .063,
                      url: widget.user.image,
                    ),
                    const SizedBox(width: 10),
                    Text(widget.user.name,
                        style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500)),
                  ],
                );
              })),
    );
  }

  Widget _chatInput() {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * .01,
          horizontal: MediaQuery.of(context).size.width * .025),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        setState(() => _showEmoji = !_showEmoji);
                      },
                      icon: const Icon(Icons.emoji_emotions,
                          color: Colors.blueAccent, size: 25)),
                  Expanded(
                      child: TextField(
                    controller: _textController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    onTap: () {
                      if (_showEmoji) setState(() => _showEmoji = !_showEmoji);
                    },
                    decoration: const InputDecoration(
                        hintText: 'Type Something...',
                        hintStyle: TextStyle(color: Colors.blueAccent),
                        border: InputBorder.none),
                  )),
                  IconButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();

                        final List<XFile> images =
                            await picker.pickMultiImage(imageQuality: 70);

                        for (var i in images) {
                          log('Image Path: ${i.path}');
                          setState(() => _isUploading = true);
                          await APIs.sendChatImage(widget.user, File(i.path));
                          setState(() => _isUploading = false);
                        }
                      },
                      icon: const Icon(Icons.image,
                          color: Colors.blueAccent, size: 26)),
                  IconButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();

                        final XFile? image = await picker.pickImage(
                            source: ImageSource.camera, imageQuality: 70);
                        if (image != null) {
                          log('Image Path: ${image.path}');
                          setState(() => _isUploading = true);

                          await APIs.sendChatImage(
                              widget.user, File(image.path));
                          setState(() => _isUploading = false);
                        }
                      },
                      icon: const Icon(Icons.camera_alt_rounded,
                          color: Colors.blueAccent, size: 26)),
                  SizedBox(width: MediaQuery.of(context).size.width * .02),
                ],
              ),
            ),
          ),
          MaterialButton(
            onPressed: () {
              if (_textController.text.isNotEmpty) {
                if (_list.isEmpty) {
                  APIs.sendFirstMessage(
                      widget.user, _textController.text, Type.text);
                } else {
                  APIs.sendMessage(
                      widget.user, _textController.text, Type.text);
                }
                _textController.text = '';
              }
            },
            minWidth: 0,
            padding:
                const EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 10),
            shape: const CircleBorder(),
            color: Colors.green,
            child: const Icon(Icons.send, color: Colors.white, size: 28),
          )
        ],
      ),
    );
  }
}
