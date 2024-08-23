import 'package:chatapp/widgets/chatroom_messages.dart';
import 'package:chatapp/widgets/new_message.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({super.key});

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  var isShowEmoji = false;
  var _messageController = TextEditingController();
  final focusNode = FocusNode();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _messageController.dispose();
  }

  void changeEmoji() {
    setState(() {
      if (!isShowEmoji) {
        FocusManager.instance.primaryFocus?.unfocus();
      } else {
        focusNode.requestFocus();
      }
      isShowEmoji = !isShowEmoji;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
            title: Text(
              'Chat Room',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 234, 248, 255),
          body: Column(
            children: [
              Expanded(child: ChatRoomMessages()),
              NewMessage(
                messageController: _messageController,
                changeEmoji: changeEmoji,
                isShowEmoji: isShowEmoji,
                focusNode: focusNode,
              ),
              if (isShowEmoji)
                EmojiPicker(
                  textEditingController: _messageController,
                  config: const Config(
                    height: 256,
                    emojiViewConfig: EmojiViewConfig(
                      columns: 9,
                      emojiSizeMax: 28 * 1.0,
                    ),
                  ),
                )
            ],
          )),
    );
  }
}
