import 'package:chatapp/models/chat_user.dart';
import 'package:chatapp/widgets/user_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  var image;
  var emailID;
  var username;
  var abouts;
  late ChatUser userdetail;
  bool _showProgress = true;

  void getData() async {
    await FirebaseFirestore.instance
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((user) {
      userdetail = ChatUser.fromJson(user.data()!);
      setState(() {
        _showProgress = false;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: _showProgress == true
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(userdetail.image),
                      radius: 100,
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  UserDetail(
                      heading: 'Username',
                      data: userdetail.name,
                      iconData: Icons.person),
                  const SizedBox(
                    height: 10,
                  ),
                  UserDetail(
                      heading: 'Email ID',
                      data: userdetail.email,
                      iconData: Icons.email),
                  const SizedBox(
                    height: 10,
                  ),
                  UserDetail(
                      heading: 'About',
                      data: userdetail.about,
                      iconData: Icons.error),
                ],
              ),
            ),
    );
  }
}
