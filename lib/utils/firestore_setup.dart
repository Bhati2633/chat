import 'package:cloud_firestore/cloud_firestore.dart';


class FirestoreSetup {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Method to create the entire Firestore structure
  Future<void> createDatabase() async {
    // Define message boards
    final List<Map<String, dynamic>> messageBoards = [
      {
        'id': 'games',
        'name': 'Games',
        'iconUrl': 'assets/games.jpg',
      },
      {
        'id': 'business',
        'name': 'Business',
        'iconUrl': 'assets/business.jpg',
      },
      {
        'id': 'health',
        'name': 'Public Health',
        'iconUrl': 'assets/health.jpg',
      },
      {
        'id': 'study',
        'name': 'Study',
        'iconUrl': 'assets/study.jpg',
      },
    ];
    

    // General discussion template
    final Map<String, dynamic> generalDiscussion = {
      'content': 'Hello, world!',
      'iconUrl': 'https://example.com/icon.jpg',
      'name': 'General Discussion',
      'timestamp': FieldValue.serverTimestamp(),
      'userId': 'abcd1234',
      'userName': 'John Doe',
    };

    final FirestoreSetup firestoreSetup = FirestoreSetup();

    @override
    void initState() {
      super.initState();
      // Uncomment this line to create the database (run only once)
      // firestoreSetup.createDatabase();
    }

    // Populate message boards and subcollections
    for (final board in messageBoards) {
      final boardRef = _db.collection('messageBoards').doc(board['id']);

      // Add the message board document
      await boardRef.set({
        'name': board['name'],
        'iconUrl': board['iconUrl'],
      });

      // Add general discussion to the subcollection
      await boardRef.collection('general_discussion').add(generalDiscussion);
    }

    print('Firestore database setup is complete!');
  }
}
