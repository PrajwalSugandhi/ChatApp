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

  void getData() async {
    final data = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    setState(() {
      emailID = data['email'];
      username = data['username'];
      image = data['imageUrl'];
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
    // print(emailID);

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: emailID == null ? Center(child: CircularProgressIndicator()) : Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(image),
                      radius: 100,
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  UserDetail(
                      heading: 'Username',
                      data: username,
                      iconData: Icons.person),
                  SizedBox(
                    height: 10,
                  ),
                  UserDetail(
                      heading: 'Email ID',
                      data: emailID,
                      iconData: Icons.email),
                  // SizedBox(height: 10,),
                  // UserDetail(heading: 'Username', data: 'Prajwal', iconData: Icons.person),
                ],
              ),
            ),
    );
  }
}
