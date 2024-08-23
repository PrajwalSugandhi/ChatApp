import 'package:chatapp/provider/display_feature.dart';
import 'package:chatapp/screens/chatroom.dart';
import 'package:chatapp/screens/splash.dart';
import 'package:chatapp/widgets/chat_user_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../API/apis.dart';
import '../models/chat_user.dart';

class ContactsScreen extends ConsumerStatefulWidget {
  ContactsScreen({super.key});

  ConsumerState<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends ConsumerState<ContactsScreen> {
  bool isSearching = false;

  @override
  Widget build(BuildContext context) {
    List<ChatUser> list = [];
    List<ChatUser> searchlist = ref.watch(SearchListProvider);
    isSearching = ref.watch(SearchingProvider);
    // print('hi');
    // print(searchlist);
    return StreamBuilder(
        stream: APIs.getMyUsersId(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return const Center(child: CircularProgressIndicator());

            case ConnectionState.active:
            case ConnectionState.done:
              return StreamBuilder(
                  stream: APIs.getAllUsers(
                      snapshot.data?.docs.map((user) => user.id).toList() ??
                          []),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return SplashScreen();
                      case ConnectionState.active:
                      case ConnectionState.done:
                        final data = snapshot.data?.docs;

                        list = data
                                ?.map((user) => ChatUser.fromJson(user.data()))
                                .toList() ??
                            [];
                        Future.microtask(() {
                          ref.read(fullListProvider.notifier).updateList(list);
                        });
                        if (list.isNotEmpty) {
                          return ListView.builder(
                            itemCount:
                                isSearching ? searchlist.length : list.length,
                            padding: EdgeInsets.only(
                                top: MediaQuery.sizeOf(context).height * 0.01),
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return ChatUserCard(
                                user: isSearching
                                    ? searchlist[index]
                                    : list[index],
                              );
                            },
                          );
                        } else {
                          return Center(
                            child: Text(
                              'No Connections Found!',
                              style: TextStyle(fontSize: 20),
                            ),
                          );
                        }
                    }
                  });
          }
        });
  }
}
