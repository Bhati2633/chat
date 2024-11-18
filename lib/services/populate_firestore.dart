import 'package:cloud_firestore/cloud_firestore.dart';


class PopulateFirestore {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Add a new message board
  Future<void> addMessageBoard(String id, String name, String iconUrl) async {
    final boardRef = _db.collection('messageBoards').doc(id);
    await boardRef.set({
      'name': name,
      'iconUrl': iconUrl,
    });
    print('Message board "$name" added.');
  }

  // Add a message to a specific message board's general discussion
  Future<void> addGeneralDiscussionMessage(String boardId, Map<String, dynamic> messageData) async {
    final discussionRef = _db.collection('messageBoards').doc(boardId).collection('general_discussion');
    await discussionRef.add(messageData);
    print('Message added to "$boardId" general discussion.');
  }

  // Example data for a new message
  Map<String, dynamic> createMessage(String content, String userId, String userName) {
    return {
      'content': content,
      'iconUrl': 'https://example.com/icon.jpg',
      'name': 'General Discussion',
      'timestamp': FieldValue.serverTimestamp(),
      'userId': userId,
      'userName': userName,
    };
  }
}
