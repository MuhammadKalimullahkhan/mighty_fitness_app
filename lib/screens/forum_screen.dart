
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../services/firestore_service.dart';
import '../services/auth_service.dart';
import '../models/forum_post.dart';

class ForumScreen extends StatefulWidget {
  const ForumScreen({super.key});

  @override
  _ForumScreenState createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  final _formKey = GlobalKey<FormState>();
  String _postContent = '';

  void _submitPost() {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
      final user = Provider.of<AuthService>(context, listen: false).user;
      Provider.of<FirestoreService>(context, listen: false).addForumPost(_postContent, user!.email ?? 'anonymous');
      _formKey.currentState!.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Community Forum')),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<List<ForumPost>>(
              stream: FirestoreService().getForumPosts(),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No posts yet!'));
                }
                final posts = snapshot.data!;
                return ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (ctx, index) => Card(
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(posts[index].content, style: Theme.of(context).textTheme.bodyLarge),
                          const SizedBox(height: 8),
                          Text(
                            'by ${posts[index].authorName} on ${posts[index].createdAt.toDate()}',
                             style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(labelText: 'New Post'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter some text.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _postContent = value!;
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.tealAccent),
                    onPressed: _submitPost,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
