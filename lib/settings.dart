import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Add logic to log out
              },
              child: Text('Log Out'),
            ),
            ElevatedButton(
              onPressed: () {
                // Add logic to change login information
              },
              child: Text('Change Login Information'),
            ),
          ],
        ),
      ),
    );
  }
}
