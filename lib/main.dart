import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'login.dart'; // Import login page
import 'splashscreen.dart'; // Import splash screen
import 'firebase_options.dart'; // Import Firebase options for initialization
import '../services/populate_firestore.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase with custom options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Message Board App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AuthenticationWrapper(),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Monitor authentication state
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while checking authentication state
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          // If user is signed in, show the SplashScreen (or HomePage)
          return SplashScreen();
        } else {
          // If user is not signed in, show the LoginPage
          return LoginPage();
        }
      },
    );
  }
}
