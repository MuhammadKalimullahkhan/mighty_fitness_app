
import 'package:cloud_firestore/cloud_firestore.dart';

class ForumPost {
  final String authorName;
  final String content;
  final Timestamp createdAt;

  ForumPost({
    required this.authorName,
    required this.content,
    required this.createdAt,
  });
}
