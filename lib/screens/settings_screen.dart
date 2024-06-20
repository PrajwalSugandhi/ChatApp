import 'package:chatapp/screens/account_screen.dart';
import 'package:chatapp/widgets/settings_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final userid = FirebaseAuth.instance.currentUser!.uid;
  var image;

  void getImageURL() async {
    final storageref = FirebaseStorage.instance
        .ref()
        .child('user_images')
        .child('$userid.jpg');
    final String imageurl = await storageref.getDownloadURL();
    setState(() {
      image = imageurl;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getImageURL();
  }

  @override
  Widget build(BuildContext context) {
    // final String image = getImageURL();
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundImage: image == null
                ? AssetImage('assets/images/userloading.png')
                : NetworkImage(image) as ImageProvider,
            radius: 100,
          ),
          SizedBox(
            height: 60,
          ),
          SettingsTile(
            title: 'Account',
            iconName: Icons.person,
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => AccountScreen()));
            },
          ),
          Divider(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
          SizedBox(
            height: 30,
          ),
          SettingsTile(
            title: 'Theme',
            iconName: Icons.sunny,
            onTap: () {
              // Navigator.of(context).push(MaterialPageRoute(builder: (context) => ));
            },
          ),
          Divider(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
          SizedBox(
            height: 30,
          ),
          SettingsTile(
            title: 'Log Out',
            iconName: Icons.power_settings_new_outlined,
            onTap: () {
              FirebaseAuth.instance.signOut();
            },
          ),
          Divider(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          )
        ],
      ),
    ));
  }
}
