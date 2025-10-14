
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  User? _user;
  bool _isLoading = false;

  AuthService() {
    _auth.authStateChanges().listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  User? get user => _user;
  bool get isAuth => _user != null;
  bool get isLoading => _isLoading;

  Future<void> _showErrorDialog(BuildContext context, String message) async {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.code == 'user-not-found') {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.code == 'wrong-password') {
        errorMessage = 'Wrong password.';
      }
      // You can show a dialog or a snackbar here
    } catch (error) {
      // Handle other errors
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> signUpWithEmailAndPassword(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      _user = userCredential.user;
      if (_user != null) {
        await _db.collection('/artifacts/evolvefit/users/').doc(_user!.uid).collection('private').doc('profile').set({
          'uid': _user!.uid,
          'username': 'user_${_user!.uid.substring(0, 6)}',
          'role': 'user',
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    } on FirebaseAuthException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.code == 'email-already-in-use') {
        errorMessage = 'This email address is already in use.';
      } else if (error.code == 'weak-password') {
        errorMessage = 'The password is too weak.';
      }
       // You can show a dialog or a snackbar here
    } catch (error) {
       // Handle other errors
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> signInWithGoogle() async {
    _isLoading = true;
    notifyListeners();
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        _isLoading = false;
        notifyListeners();
        return; // The user canceled the sign-in
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );
      UserCredential userCredential = await _auth.signInWithCredential(credential);
      _user = userCredential.user;
      if (_user != null) {
         final userDoc = await _db.collection('/artifacts/evolvefit/users/').doc(_user!.uid).collection('private').doc('profile').get();
         if(!userDoc.exists){
            await _db.collection('/artifacts/evolvefit/users/').doc(_user!.uid).collection('private').doc('profile').set({
              'uid': _user!.uid,
              'username': googleUser.displayName ?? 'user_${_user!.uid.substring(0, 6)}',
              'role': 'user',
              'createdAt': FieldValue.serverTimestamp(),
            });
         }
      }
    } catch (error) {
      // Handle errors
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
