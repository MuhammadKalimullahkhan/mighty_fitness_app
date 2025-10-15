
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardScreen extends StatelessWidget {
  final String title;

  const DashboardScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(title,
            style: GoogleFonts.poppins(
                textStyle: theme.textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold))),
        backgroundColor: theme.primaryColor,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.construction,
                size: 80,
                color: theme.colorScheme.secondary,
              ),
              const SizedBox(height: 24),
              Text(
                'Under Construction',
                style: GoogleFonts.poppins(
                  textStyle: theme.textTheme.headlineSmall?.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'This page is currently being developed. Check back soon!',
                style: GoogleFonts.poppins(
                  textStyle: theme.textTheme.titleMedium
                      ?.copyWith(color: Colors.white70),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back),
                label: Text(
                  'Go Back',
                  style: GoogleFonts.poppins(),
                ),
                style: theme.elevatedButtonTheme.style,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
