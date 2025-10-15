
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import './forum_screen.dart';
import './dashboard_screen.dart';
import '../widgets/assistant_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final List<Map<String, dynamic>> screens = [
      {
        'title': 'Community Forum',
        'icon': Icons.forum,
        'screen': const ForumScreen()
      },
      {
        'title': 'User Dashboard',
        'icon': Icons.dashboard,
        'screen': const DashboardScreen(title: 'User Dashboard')
      },
      {
        'title': 'Trainer Dashboard',
        'icon': Icons.fitness_center,
        'screen': const DashboardScreen(title: 'Trainer Dashboard')
      },
      {
        'title': 'Admin Dashboard',
        'icon': Icons.admin_panel_settings,
        'screen': const DashboardScreen(title: 'Admin Dashboard')
      },
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.primaryColor,
        elevation: 0,
        title: Text('EvolveFit',
            style: GoogleFonts.poppins(
              textStyle: theme.textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            )),
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white, size: 28),
            tooltip: 'Profile',
            onPressed: () {
              // TODO: Implement profile screen navigation
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white, size: 28),
            tooltip: 'Logout',
            onPressed: () {
              Provider.of<AuthService>(context, listen: false).signOut();
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Welcome Back!',
              style: GoogleFonts.poppins(
                textStyle: theme.textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'What would you like to do today?',
              style: GoogleFonts.poppins(
                textStyle: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white70,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                ),
                itemCount: screens.length,
                itemBuilder: (context, index) {
                  final item = screens[index];
                  return _buildDashboardCard(
                      context, item['title'], item['icon'], item['screen'], theme);
                },
              ),
            ),
            const Divider(height: 30, color: Colors.white54),
            const SizedBox(height: 10),
            Text(
              'AI Assistant',
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Expanded(child: AssistantWidget()),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard(BuildContext context, String title, IconData icon,
      Widget screen, ThemeData theme) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () =>
            Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => screen)),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, size: 42, color: theme.colorScheme.secondary),
              const SizedBox(height: 14),
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  textStyle: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
