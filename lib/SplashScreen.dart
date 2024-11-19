import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chat_screen.dart';  // Import ChatScreen
import 'profile.dart';  // Import Profile screen
import 'settings.dart';  // Import Settings screen
import 'login.dart';  // Import Login screen
import 'room_screen.dart';  // Import RoomScreen

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();

    Future.delayed(const Duration(seconds: 3), () {
      _checkAuthentication();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _checkAuthentication() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Navigate to the main page if authenticated
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MessageBoardScreen()),
      );
    } else {
      // Navigate to login screen if not authenticated
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black, // Solid dark background
        child: Center(
          child: FadeTransition(
            opacity: _animation,
            child: const Text(
              "Welcome to ChatBoard",
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Main Home Page with Message Boards
class MessageBoardScreen extends StatelessWidget {
  final List<Map<String, dynamic>> _messageBoards = [
    {'roomId': '1', 'name': 'Games', 'iconUrl': 'assets/games.jpg'},
    {'roomId': '2', 'name': 'Business', 'iconUrl': 'assets/business.jpg'},
    {'roomId': '3', 'name': 'Public Health', 'iconUrl': 'assets/health.jpg'},
    {'roomId': '4', 'name': 'Study', 'iconUrl': 'assets/study.jpg'},
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
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      drawer: Drawer(
        backgroundColor: Colors.black87,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.black),
              child: const Text(
                'Welcome User!',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ListTile(
              title: const Text('Profile', style: TextStyle(color: Colors.white)),
              onTap: () {
                final user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilePage(uid: user.uid)),
                  );
                }
              },
            ),
            ListTile(
              title: const Text('Settings', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: _messageBoards.length,
        itemBuilder: (context, index) {
          final board = _messageBoards[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RoomScreen(
                    roomId: board['roomId'],
                    roomName: board['name'],
                  ),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[850], // Darker color for rectangles
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Image.asset(
                    board['iconUrl'],
                    width: 180,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 26),
                  Expanded(
                    child: Text(
                      board['name'],
                      style: const TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () => _signOut(context),
        child: const Icon(Icons.logout),
      ),
      backgroundColor: Colors.black, // Dark background for the main screen
    );
  }
}
