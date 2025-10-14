
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/forum_post.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<ForumPost>> getForumPosts() {
    return _db.collection('/artifacts/evolvefit/public/data/forum').orderBy('createdAt', descending: true).snapshots().map((snapshot) => snapshot.docs.map((doc) => ForumPost(authorName: doc.data()['authorName'], content: doc.data()['content'], createdAt: doc.data()['createdAt'])).toList());
  }

  Future<void> addForumPost(String content, String authorName) {
    return _db.collection('/artifacts/evolvefit/public/data/forum').add({
      'content': content,
      'authorName': authorName,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateUsername(String uid, String username) {
    return _db.collection('/artifacts/evolvefit/users/').doc(uid).collection('private').doc('profile').update({'username': username});
  }
}
