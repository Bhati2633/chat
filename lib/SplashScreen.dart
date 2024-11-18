import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart'; // Import the login page
import 'firestore_service.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  List<Map<String, dynamic>> _messageBoards = [
    {
      'name': 'Games',
      'iconUrl': 'assets/games.jpg',
    },
    {
      'name': 'Business',
      'iconUrl': 'assets/business.jpg',
    },
    {
      'name': 'Public Health',
      'iconUrl': 'assets/health.jpg',
    },
    {
      'name': 'Study',
      'iconUrl': 'assets/study.jpg',
    },
  ];

  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select A Room'),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: _messageBoards.length,
        itemBuilder: (context, index) {
          final board = _messageBoards[index];
          return GestureDetector(
            onTap: () {
              // Navigate to a chat screen or perform actions specific to this room
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(roomName: board['name']),
                ),
              );
            },
            child: Card(
              margin: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Image.asset(
                    board['iconUrl'],
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    board['name'],
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _signOut(context),
        child: const Icon(Icons.logout),
      ),
    );
  }
}

// A placeholder ChatScreen widget
class ChatScreen extends StatelessWidget {
  final String roomName;

  ChatScreen({required this.roomName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(roomName),
      ),
      body: Center(
        child: Text('Welcome to the $roomName room!'),
      ),
    );
  }
}
