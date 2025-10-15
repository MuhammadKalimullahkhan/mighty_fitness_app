
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  AuthScreenState createState() => AuthScreenState();
}

class AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool _isLogin = true;

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      final authService = Provider.of<AuthService>(context, listen: false);

      if (_isLogin) {
        authService.signInWithEmailAndPassword(_email, _password);
      } else {
        authService.signUpWithEmailAndPassword(_email, _password);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  _isLogin ? 'Welcome Back' : 'Join EvolveFit',
                  style: GoogleFonts.poppins(
                    textStyle: theme.textTheme.headlineLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  _isLogin
                      ? 'Your journey continues here'
                      : 'Start your fitness journey today',
                  style: GoogleFonts.poppins(
                    textStyle: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        key: const ValueKey('email'),
                        validator: (value) {
                          if (value!.isEmpty || !value.contains('@')) {
                            return 'Please enter a valid email address.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _email = value!;
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration:
                            const InputDecoration(labelText: 'Email address'),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        key: const ValueKey('password'),
                        validator: (value) {
                          if (value!.isEmpty || value.length < 7) {
                            return 'Password must be at least 7 characters long.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _password = value!;
                        },
                        obscureText: true,
                        decoration: const InputDecoration(labelText: 'Password'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                if (authService.isLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ElevatedButton(
                        onPressed: _trySubmit,
                        style: theme.elevatedButtonTheme.style?.copyWith(
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(vertical: 16)),
                        ),
                        child: Text(
                          _isLogin ? 'Login' : 'Signup',
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _isLogin = !_isLogin;
                          });
                        },
                        child: Text(
                          _isLogin
                              ? 'Create new account'
                              : 'I already have an account',
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: theme.colorScheme.secondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Expanded(child: Divider(color: Colors.white54)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'OR',
                        style: GoogleFonts.poppins(
                            textStyle: const TextStyle(color: Colors.white54)),
                      ),
                    ),
                    const Expanded(child: Divider(color: Colors.white54)),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () => authService.signInWithGoogle(),
                  icon: const Icon(Icons.g_mobiledata, size: 28),
                  label: Text(
                    'Sign in with Google',
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: theme.primaryColor,
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
