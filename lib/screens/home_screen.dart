
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import './forum_screen.dart';
import './dashboard_screen.dart';
import '../widgets/assistant_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EvolveFit'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Provider.of<AuthService>(context, listen: false).signOut();
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ElevatedButton(
              child: const Text('Community Forum'),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const ForumScreen()));
              },
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              child: const Text('User Dashboard'),
              onPressed: () {
                 Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const DashboardScreen(title: 'User Dashboard')));
              },
            ),
             const SizedBox(height: 10),
            ElevatedButton(
              child: const Text('Trainer Dashboard'),
              onPressed: () {
                 Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const DashboardScreen(title: 'Trainer Dashboard')));
              },
            ),
             const SizedBox(height: 10),
            ElevatedButton(
              child: const Text('Admin Dashboard'),
              onPressed: () {
                 Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const DashboardScreen(title: 'Admin Dashboard')));
              },
            ),
            const Divider(height: 30, color: Colors.white54),
            const Expanded(child: AssistantWidget()),
          ],
        ),
      ),
    );
  }
}
