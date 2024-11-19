import 'package:flutter/material.dart';

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
