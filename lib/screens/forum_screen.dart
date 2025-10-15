
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../services/firestore_service.dart';
import '../services/auth_service.dart';
import '../models/forum_post.dart';

class ForumScreen extends StatefulWidget {
  const ForumScreen({super.key});

  @override
  ForumScreenState createState() => ForumScreenState();
}

class ForumScreenState extends State<ForumScreen> {
  final _formKey = GlobalKey<FormState>();
  final _contentController = TextEditingController();
  String _postContent = '';

  void _submitPost() {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
      final user = Provider.of<AuthService>(context, listen: false).user;
      Provider.of<FirestoreService>(context, listen: false)
          .addForumPost(_postContent, user!.email ?? 'anonymous');
      _contentController.clear();
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Community Forum',
            style: GoogleFonts.poppins(
                textStyle: theme.textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold))),
        backgroundColor: theme.primaryColor,
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<List<ForumPost>>(
              stream: Provider.of<FirestoreService>(context).getForumPosts(),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text('No posts yet. Be the first to share!',
                        style: GoogleFonts.poppins(
                            textStyle: theme.textTheme.titleMedium)),
                  );
                }
                final posts = snapshot.data!;
                return ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                  itemCount: posts.length,
                  itemBuilder: (ctx, index) {
                    final post = posts[index];
                    return Card(
                      margin:
                          const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(post.content,
                                style: GoogleFonts.poppins(
                                    textStyle: theme.textTheme.bodyLarge
                                        ?.copyWith(fontSize: 16))),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'by ${post.authorName}',
                                  style: GoogleFonts.poppins(
                                    textStyle: theme.textTheme.bodySmall?.copyWith(
                                        color: Colors.white70,
                                        fontStyle: FontStyle.italic),
                                  ),
                                ),
                                Text(
                                  DateFormat.yMMMd()
                                      .add_jm()
                                      .format(post.createdAt.toDate()),
                                  style: GoogleFonts.poppins(
                                    textStyle: theme.textTheme.bodySmall
                                        ?.copyWith(color: Colors.white70),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          _buildPostComposer(theme),
        ],
      ),
    );
  }

  Widget _buildPostComposer(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: theme.cardColor,
        boxShadow: const [
          BoxShadow(
              blurRadius: 10, color: Colors.black26, offset: Offset(0, -2)),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(
                  hintText: 'Share something with the community...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter some text.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _postContent = value!;
                },
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: _submitPost,
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(14),
              ),
              child: const Icon(Icons.send, size: 24),
            ),
          ],
        ),
      ),
    );
  }
}
