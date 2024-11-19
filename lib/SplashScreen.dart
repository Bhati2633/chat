import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart'; // Import ChatScreen
import 'profile.dart'; // Import Profile screen
import 'settings.dart'; // Import Settings screen
import 'login.dart'; // Import Login screen

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
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            'assets/splash_background.jpg', // Replace with your splash screen background image
            fit: BoxFit.cover,
          ),
          // Overlay with fading title
          Center(
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
        ],
      ),
    );
  }
}

// Main Home Page with Message Boards
class MessageBoardScreen extends StatelessWidget {
  final List<Map<String, dynamic>> _messageBoards = [
    {'name': 'Games', 'iconUrl': 'assets/games.jpg'},
    {'name': 'Business', 'iconUrl': 'assets/business.jpg'},
    {'name': 'Public Health', 'iconUrl': 'assets/health.jpg'},
    {'name': 'Study', 'iconUrl': 'assets/study.jpg'},
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.blue),
              child: const Text('Welcome User!', style: TextStyle(color: Colors.white)),
            ),
            ListTile(
              title: const Text('Profile'),
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
              title: const Text('Settings'),
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
                MaterialPageRoute(builder: (context) => ChatScreen(roomName: board['name'])),
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
