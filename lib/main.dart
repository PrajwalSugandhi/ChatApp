import 'package:chatapp/firebase_options.dart';
import 'package:chatapp/screens/auth.dart';
import 'package:chatapp/screens/chatroom.dart';
import 'package:chatapp/screens/home_screen.dart';
import 'package:chatapp/screens/splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(ProviderScope(child: const App()));
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterChat',
      theme: ThemeData().copyWith(
        colorScheme: ColorScheme.fromSeed(
            // seedColor: const Color.fromARGB(255, 63, 17, 177)),
            seedColor: const Color.fromARGB(255, 17, 100, 154)),
      ),
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SplashScreen();
          }
          if (snapshot.hasData) {
            return HomeScreen();
          }
          return AuthScreen();
        },
      ),
    );
  }
}
