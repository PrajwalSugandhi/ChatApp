import 'package:chatapp/API/apis.dart';
import 'package:chatapp/provider/display_feature.dart';
import 'package:chatapp/screens/chatroom.dart';
import 'package:chatapp/screens/contacts.dart';
import 'package:chatapp/screens/settings_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/chat_user.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  var _selectedPageIndex = 0;
  Widget _activepage = ContactsScreen();
  bool _isSearching = false;
  List<ChatUser> _searchList = [];
  late List<ChatUser> _list;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });

    if (index == 0) {
      _activepage = ContactsScreen();
    } else if (index == 1) {
      _activepage = SettingsScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(PersonalInfoProvider.notifier);
    _list = ref.watch(fullListProvider);
    _isSearching = ref.watch(SearchingProvider);
    return GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: PopScope(
          canPop: false,
          onPopInvoked: (_) {
            if (_isSearching) {
              ref.read(SearchingProvider.notifier).change();
              return;
            }
            Future.delayed(
                const Duration(milliseconds: 300), SystemNavigator.pop);
          },
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
              title: _isSearching
                  ? TextField(
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Name, Email, ...'),
                      autofocus: true,
                      style: const TextStyle(fontSize: 17, letterSpacing: 0.5),
                      onChanged: (val) {
                        ref.read(SearchListProvider.notifier).clearList();
                        ref
                            .read(SearchListProvider.notifier)
                            .updateList(_list, val);
                      },
                    )
                  : const Text('We Chat'),
              leading: _isSearching
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          ref.read(SearchingProvider.notifier).change();
                        });
                      },
                      icon: Icon(Icons.arrow_back))
                  : null,
              actions: [
                IconButton(
                    tooltip: 'Search',
                    onPressed: () =>
                        ref.read(SearchingProvider.notifier).change(),
                    icon: Icon(_isSearching
                        ? CupertinoIcons.clear_circled_solid
                        : CupertinoIcons.search)),
                if (!_isSearching)
                  IconButton(
                      tooltip: 'Add User',
                      padding: const EdgeInsets.only(right: 8),
                      onPressed: _addChatUserDialog,
                      icon: const Icon(CupertinoIcons.person_add, size: 25))
              ],
            ),
            body: _activepage,
            bottomNavigationBar: BottomNavigationBar(
              onTap: _selectPage,
              currentIndex: _selectedPageIndex,
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chats'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.menu), label: 'Settings'),
              ],
            ),
          ),
        ));
  }

  void _addChatUserDialog() {
    String email = '';

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              contentPadding: const EdgeInsets.only(
                  left: 24, right: 24, top: 20, bottom: 10),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              title: const Row(
                children: [
                  Icon(
                    Icons.person_add,
                    color: Colors.blue,
                    size: 28,
                  ),
                  Text('  Add User')
                ],
              ),
              content: TextFormField(
                maxLines: null,
                onChanged: (value) => email = value,
                decoration: const InputDecoration(
                    hintText: 'Email Id',
                    prefixIcon: Icon(Icons.email, color: Colors.blue),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)))),
              ),
              actions: [
                MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel',
                        style: TextStyle(color: Colors.blue, fontSize: 16))),
                MaterialButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      if (email.trim().isNotEmpty) {
                        await APIs.addChatUser(email).then((value) {
                          if (!value) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('User does not Exists!'),
                                backgroundColor: Colors.blue.withOpacity(.9),
                                behavior: SnackBarBehavior.floating));
                          }
                        });
                      }
                    },
                    child: const Text(
                      'Add',
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    ))
              ],
            ));
  }
}
