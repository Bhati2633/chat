import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firestore_service.dart';

class ProfilePage extends StatefulWidget {
  final String uid;

  ProfilePage({required this.uid});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirestoreService _firestoreService = FirestoreService();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    setState(() {
      _isLoading = true;
    });

    var userProfile = await _firestoreService.getUserProfile(widget.uid);
    if (userProfile != null) {
      _nameController.text = userProfile['name'];
      _emailController.text = userProfile['email'];
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _updateProfile() async {
    setState(() {
      _isLoading = true;
    });

    await _firestoreService.updateUserProfile(
      widget.uid,
      _nameController.text,
      _emailController.text,
    );

    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile updated!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Name', style: TextStyle(fontSize: 16)),
                  TextField(controller: _nameController),
                  SizedBox(height: 16),
                  Text('Email', style: TextStyle(fontSize: 16)),
                  TextField(controller: _emailController),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _updateProfile,
                    child: Text('Update Profile'),
                  ),
                ],
              ),
            ),
    );
  }
}
