import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  final String uid;

  ProfilePage({required this.uid});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  File? _imageFile;  // Store the picked image
  String _imageUrl = '';  // Store the image URL

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _fetchUserProfile();
  }

  // Fetch existing profile data
  Future<void> _fetchUserProfile() async {
    try {
      var userProfile = await _db.collection('users').doc(widget.uid).get();
      if (userProfile.exists) {
        _firstNameController.text = userProfile['firstName'] ?? '';
        _lastNameController.text = userProfile['lastName'] ?? '';
        _emailController.text = userProfile['email'] ?? '';
        _imageUrl = userProfile['profilePhotoUrl'] ?? '';  // Set the existing image URL if available
        setState(() {});
      }
    } catch (e) {
      print("Error fetching user profile: $e");
    }
  }

  // Pick an image from the gallery or camera
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // Upload the image to Firebase Storage and get the URL
  Future<String> _uploadImage() async {
    if (_imageFile == null) {
      return '';  // If no image selected, return empty string
    }

    try {
      // Generate a unique filename for the image
      String fileName = 'profile_pics/${widget.uid}_${DateTime.now().millisecondsSinceEpoch}';
      // Upload the image to Firebase Storage
      UploadTask uploadTask = _storage.ref(fileName).putFile(_imageFile!);
      TaskSnapshot snapshot = await uploadTask;
      // Get the URL of the uploaded image
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print("Error uploading image: $e");
      return '';
    }
  }

  // Update the user's profile in Firestore
  Future<void> _updateProfile() async {
    try {
      String imageUrl = await _uploadImage();  // Get the URL of the uploaded image (if any)

      await _db.collection('users').doc(widget.uid).set({
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
        'email': _emailController.text,
        'profilePhotoUrl': imageUrl,  // Save the image URL
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile updated successfully')));
    } catch (e) {
      print("Error updating profile: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile photo display and pick option
            CircleAvatar(
              radius: 50,
              backgroundImage: _imageUrl.isNotEmpty
                  ? NetworkImage(_imageUrl)  // Display existing photo if any
                  : (_imageFile != null ? FileImage(_imageFile!) : AssetImage('assets/default_profile.png')) as ImageProvider,
              child: InkWell(
                onTap: _pickImage,  // Allow the user to pick a new image
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Icon(Icons.camera_alt, color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _firstNameController,
              decoration: InputDecoration(labelText: 'First Name'),
            ),
            TextField(
              controller: _lastNameController,
              decoration: InputDecoration(labelText: 'Last Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateProfile,
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
