import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// A friendly, user-facing error message.
class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message;
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Emits the user whenever they sign in, sign out, or update their profile.
  Stream<User?> get userChanges => _auth.userChanges();

  User? get currentUser => _auth.currentUser;

  /// Creates the account, saves the display name, and stores a profile document.
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = cred.user!;

      await user.updateDisplayName(name.trim());
      await user.reload();

      // If saving the profile fails, the account still exists and the
      // name is still saved in Firebase Auth, so we don't block the user.
      try {
        await _db.collection('users').doc(user.uid).set({
          'name': name.trim(),
          'email': email.trim(),
          'createdAt': FieldValue.serverTimestamp(),
        });
      } on FirebaseException catch (e) {
        debugPrint('Could not save user profile: ${e.code}');
      }
    } on FirebaseAuthException catch (e) {
      throw AuthException(_registerMessage(e.code));
    } catch (_) {
      throw AuthException('Something went wrong. Please try again.');
    }
  }

  /// One generic message for wrong email OR wrong password,
  /// so we never reveal which field was wrong.
  Future<void> login({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw AuthException(_loginMessage(e.code));
    } catch (_) {
      throw AuthException('Something went wrong. Please try again.');
    }
  }

  Future<void> logout() => _auth.signOut();

  String _registerMessage(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'An account with this email already exists.';
      case 'invalid-email':
        return 'Enter a valid email address.';
      case 'weak-password':
        return 'Password is too weak. Use at least 8 characters.';
      case 'network-request-failed':
        return 'No internet connection. Please try again.';
      default:
        return 'Could not create your account. Please try again.';
    }
  }

  String _loginMessage(String code) {
    switch (code) {
      case 'network-request-failed':
        return 'No internet connection. Please try again.';
      case 'too-many-requests':
        return 'Too many attempts. Please wait a moment and try again.';
      case 'user-disabled':
        return 'This account has been disabled.';
      default:
        return 'Incorrect email or password.';
    }
  }
}