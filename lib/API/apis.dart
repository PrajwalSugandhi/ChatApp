import 'dart:developer';
import 'dart:io';

import 'package:chatapp/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/chat_user.dart';

class APIs {
  static FirebaseAuth get auth => FirebaseAuth.instance;

  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static FirebaseStorage storage = FirebaseStorage.instance;

  static User get user => auth.currentUser!;

  static late ChatUser me;

  static ChatUser me2 = ChatUser(
      id: user.uid,
      name: user.displayName.toString(),
      email: user.email.toString(),
      about: "Hey, I'm using We Chat!",
      image: user.photoURL.toString(),
      createdAt: '',
      isOnline: false,
      lastActive: '',
      pushToken: '');

  static Future<void> getSelfInfo() async {
    await firestore.collection('user').doc(user.uid).get().then((user) {
      if (!user.exists) {
        getSelfInfo();
      } else {
        me = ChatUser.fromJson(user.data()!);
      }
    });
  }


  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(ChatUser chatUser) {
    return firestore
        .collection('user')
        .where('id', isEqualTo: chatUser.id)
        .snapshots();
  }


  static Stream<QuerySnapshot<Map<String, dynamic>>> getMyUsersId() {
    return firestore
        .collection('user')
        .doc(user.uid)
        .collection('my_users')
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers(List<String> userIds) {


    return firestore
        .collection('user')
        .where('id',
        whereIn: userIds.isEmpty
            ? ['']
            : userIds)
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  static Future<void> createCloudUser(final username, final email, final image, final userCredentials) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final chatUser = ChatUser(
        id: user.uid,
        name: username,
        email: email,
        about: "Available",
        image: image,
        createdAt: time,
        isOnline: false,
        lastActive: time,
        pushToken: '');

    print('${chatUser.name}  ${chatUser.about}');
    return await firestore
        .collection('user')
        .doc(user.uid)
        .set(chatUser.toJson());
  }


  static String getConversationID(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';


  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(ChatUser user) {
    return firestore
        .collection('chats/${getConversationID(user.id)}/messages/')
        .orderBy('sent', descending: true)
        .snapshots();
  }


  static Future<void> sendFirstMessage(ChatUser chatUser, String msg, Type type) async {
    await firestore
        .collection('user')
        .doc(chatUser.id)
        .collection('my_users')
        .doc(user.uid)
        .set({}).then((value) => sendMessage(chatUser, msg, type));
  }

  static Future<void> sendMessage(ChatUser chatUser, String msg, Type type) async {
    //message sending time (also used as id)
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    //message to send
    final Message message = Message(
        toId: chatUser.id,
        msg: msg,
        read: '',
        type: type,
        fromId: user.uid,
        sent: time);

    final ref = firestore
        .collection('chats/${getConversationID(chatUser.id)}/messages/');
    await ref.doc(time).set(message.toJson());
  }

  static Future<void> updateMessageReadStatus(Message message) async {
    firestore
        .collection('chats/${getConversationID(message.fromId)}/messages/')
        .doc(message.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(ChatUser user) {
    return firestore
        .collection('chats/${getConversationID(user.id)}/messages/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  static Future<void> sendChatImage(ChatUser chatUser, File file) async {
    //getting image file extension
    final extension = file.path.split('.').last;

    //storage file ref with path
    final ref = storage.ref().child(
        'images/${getConversationID(chatUser.id)}/${DateTime.now().millisecondsSinceEpoch}.$extension');

    //uploading image
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$extension'))
        .then((p0) {
      log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });

    //updating image in firestore database
    final imageUrl = await ref.getDownloadURL();
    await sendMessage(chatUser, imageUrl, Type.image);
  }


  static Future<bool> addChatUser(String email) async {
    final data = await firestore
        .collection('user')
        .where('email', isEqualTo: email)
        .get();

    log('data: ${data.docs}');

    if (data.docs.isNotEmpty && data.docs.first.id != user.uid) {


      log('user exists: ${data.docs.first.data()}');

      firestore
          .collection('user')
          .doc(user.uid)
          .collection('my_users')
          .doc(data.docs.first.id)
          .set({});
      return true;
    } else {
      return false;
    }
  }

}
