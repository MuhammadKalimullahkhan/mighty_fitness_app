
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import './screens/auth_screen.dart';
import './screens/home_screen.dart';
import './services/auth_service.dart';
import './services/firestore_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => AuthService(),
        ),
        Provider<FirestoreService>(
          create: (_) => FirestoreService(),
        ),
      ],
      child: Consumer<AuthService>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'EvolveFit',
          theme: ThemeData(
            useMaterial3: true,
            primaryColor: const Color(0xFF1A202C),
            colorScheme: ColorScheme.fromSwatch().copyWith(
              secondary: Colors.deepOrangeAccent,
              brightness: Brightness.dark,
            ),
            scaffoldBackgroundColor: const Color(0xFF1A202C),
            cardColor: const Color(0xFF2D3748),
            textTheme: const TextTheme(
              bodyLarge: TextStyle(color: Colors.white),
              bodyMedium: TextStyle(color: Colors.white70),
              titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, 
                backgroundColor: Colors.deepOrangeAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            inputDecorationTheme: const InputDecorationTheme(
              labelStyle: TextStyle(color: Colors.deepOrangeAccent),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.deepOrangeAccent),
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white70),
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),
          ),
          home: auth.isAuth
              ? const HomeScreen()
              : const AuthScreen(),
        ),
      ),
    );
  }
}
