import 'package:chatapp/screens/chatroom.dart';
import 'package:chatapp/screens/chats.dart';
import 'package:chatapp/screens/profile_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _selectedPageIndex = 0;
  Widget _activepage = ChatScreen();


  void _selectPage(int index){
    setState(() {
      _selectedPageIndex = index;
    });

    if(index == 0){
      _activepage = ChatScreen();
    }
    else if(index == 1){
      _activepage = ProfileScreen();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        title: Text('Chat Hub' , style: TextStyle(color: Theme.of(context).colorScheme.primary),),
      ),
      body: _activepage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chats'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
