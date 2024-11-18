import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Function to create or update user profile
  Future<void> updateUserProfile(String uid, String name, String email) async {
    try {
      await _db.collection('users').doc(uid).set({
        'name': name,
        'email': email,
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true)); // Merge option ensures we only update fields, not overwrite
    } catch (e) {
      print("Error updating user profile: $e");
    }
  }

  // Function to fetch user profile
  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    try {
      DocumentSnapshot snapshot = await _db.collection('users').doc(uid).get();
      return snapshot.exists ? snapshot.data() as Map<String, dynamic> : null;
    } catch (e) {
      print("Error fetching user profile: $e");
      return null;
    }
  }

  // Function to create a message board (room)
  Future<void> createMessageBoard(String boardId, String name, String iconUrl) async {
    try {
      await _db.collection('messageBoards').doc(boardId).set({
        'name': name,
        'iconUrl': iconUrl,
        'createdAt': FieldValue.serverTimestamp(), // Timestamp of creation
      });
    } catch (e) {
      print("Error creating message board: $e");
    }
  }

  // Function to send a message to a room
  Future<void> addMessage(String roomId, String userId, String message) async {
    try {
      await _db.collection('messageBoards')
          .doc(roomId)
          .collection('messages')
          .add({
        'userId': userId,
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error adding message: $e");
    }
  }

  // Function to save a user (initial save)
  Future<void> saveUser({
    required String uid, 
    required String firstName, 
    required String lastName, 
    required String email, 
    required String role, 
    required DateTime registrationDate,
  }) async {
    try {
      await _db.collection('users').doc(uid).set({
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'role': role,
        'registration_datetime': registrationDate,
        'createdAt': FieldValue.serverTimestamp(), // Store the user's creation timestamp
      });
    } catch (e) {
      print("Error saving user: $e");
    }
}

  // Function to fetch messages for a room
  Future<List<Map<String, dynamic>>> getMessages(String roomId) async {
    try {
      QuerySnapshot snapshot = await _db.collection('messageBoards')
          .doc(roomId)
          .collection('messages')
          .orderBy('timestamp') // Ordering by timestamp for chronological order
          .get();

      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      print("Error fetching messages: $e");
      return [];
    }
  }
}
