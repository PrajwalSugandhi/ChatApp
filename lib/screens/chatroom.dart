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
      if(!isShowEmoji){
        FocusManager.instance.primaryFocus?.unfocus();
      }
      else{
        focusNode.requestFocus();
      }
      isShowEmoji = !isShowEmoji;

    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
            title: Text(
              'Chat Room',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                  },
                  icon: Icon(
                    Icons.exit_to_app,
                    color: Theme.of(context).colorScheme.primary,
                  ))
            ],
          ),
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
                  // onEmojiSelected: (Category category, Emoji emoji) {
                  //   // Do something when emoji is tapped (optional)
                  // },
                  // onBackspacePressed: () {
                  //   // Do something when the user taps the backspace button (optional)
                  //   // Set it to null to hide the Backspace-Button
                  // },
                  textEditingController:
                      _messageController, // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]
                  config: const Config(
                    height: 256,
                    // bgColor: const Color(0xFFF2F2F2),
                    // checkPlatformCompatibility: true,
                    emojiViewConfig: EmojiViewConfig(
                      columns: 9,
                      emojiSizeMax: 28 * 1.0,
                    ),
                    // swapCategoryAndBottomBar:  false,
                    // skinToneConfig: const SkinToneConfig(),
                    // categoryViewConfig: const CategoryViewConfig(),
                    // bottomActionBarConfig: const BottomActionBarConfig(),
                    // searchViewConfig: const SearchViewConfig(),
                  ),
                )
            ],
          )),
    );
  }
}
