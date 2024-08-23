import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod/riverpod.dart';

import '../models/chat_user.dart';

class FullListNotifier extends StateNotifier<List<ChatUser>> {
  FullListNotifier() : super([]);
  void updateList(List<ChatUser> list) {
    state = list;
  }
}

final fullListProvider =
    StateNotifierProvider<FullListNotifier, List<ChatUser>>(
        (ref) => FullListNotifier());

class searchListNotifier extends StateNotifier<List<ChatUser>> {
  searchListNotifier() : super([]);

  void updateList(List<ChatUser> list, String val) {
    // print(1);
    // print(state);
    // print(list);
    val = val.toLowerCase();
    for (var i in list) {
      if (i.name.toLowerCase().contains(val)) {
        // print(2);
        // print(state);
        state = [...state, i];
      }
    }
  }

  void clearList() {
    state = [];
  }
}

final SearchListProvider =
    StateNotifierProvider<searchListNotifier, List<ChatUser>>(
        (ref) => searchListNotifier());

class Searching extends StateNotifier<bool> {
  Searching() : super(false);
  void change() {
    state = !state;
  }
}

final SearchingProvider =
    StateNotifierProvider<Searching, bool>((ref) => Searching());

class PersonalInfo extends StateNotifier<ChatUser> {
  PersonalInfo() : super(ChatUser.defaultuser());

  void getData(ChatUser myself) {
    state = myself;
  }

  void removeData() {
    state = ChatUser.defaultuser();
  }
}

final PersonalInfoProvider =
    StateNotifierProvider<PersonalInfo, ChatUser>((ref) => PersonalInfo());
