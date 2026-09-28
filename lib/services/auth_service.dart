import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// A simple error that carries a message safe to show to the user.
class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message;
}

/// Handles registration, login and logout using Firebase Authentication,
/// and saves the user's profile in Cloud Firestore (collection: `users`).
///
/// Your screens use a Student/Teacher ID (not an email), so we turn the ID
/// into a private, made-up email for Firebase Auth. The user never sees it.
///   Student ID 2021-001  ->  student.2021-001@utrivia.example.com
///   Teacher ID T-55      ->  faculty.t-55@utrivia.example.com
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  static const String _emailDomain = 'utrivia.example.com';

  /// Only letters, numbers, dashes and underscores are allowed in an ID.
  static final RegExp validIdPattern = RegExp(r'^[A-Za-z0-9_-]+$');

  static String buildEmail(
      {required bool isStudent, required String idNumber}) {
    final role = isStudent ? 'student' : 'faculty';
    return '$role.${idNumber.trim().toLowerCase()}@$_emailDomain';
  }

  // ---------------------------------------------------------------------------
  // REGISTER
  // ---------------------------------------------------------------------------
  /// Creates the Firebase account and saves the profile in Firestore.
  /// The user is signed out afterwards, because your app sends them to the
  /// Login page after registering.
  Future<void> register({
    required bool isStudent,
    required String idNumber,
    required String name,
    required String department,
    required String password,
  }) async {
    final email = buildEmail(isStudent: isStudent, idNumber: idNumber);

    // 1) Create the account in Firebase Authentication.
    late final User user;
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = credential.user!;
    } on FirebaseAuthException catch (e) {
      throw AuthException(_messageFor(e));
    }

    // 2) Save the profile in Firestore. New users start with 0 points.
    try {
      await user.updateDisplayName(name.trim());
      await _db.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'idNumber': idNumber.trim(),
        'role': isStudent ? 'student' : 'faculty',
        'name': name.trim(),
        'department': department,
        'points': 0,
        'quizzesCompleted': 0,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (_) {
      // Roll back so the ID is not left half-registered.
      try {
        await user.delete();
      } catch (_) {}
      throw AuthException('Could not save your account. Please try again.');
    }

    // 3) Sign out so the user logs in from the Login page.
    await _auth.signOut();
  }

  // ---------------------------------------------------------------------------
  // LOGIN
  // ---------------------------------------------------------------------------
  /// Signs in with the ID and password, then checks the name and department
  /// entered on the form against the saved profile.
  Future<void> login({
    required bool isStudent,
    required String idNumber,
    required String name,
    required String department,
    required String password,
  }) async {
    final email = buildEmail(isStudent: isStudent, idNumber: idNumber);

    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final snapshot =
          await _db.collection('users').doc(credential.user!.uid).get();
      final data = snapshot.data();

      if (data == null) {
        await _auth.signOut();
        throw AuthException(
            'Account profile not found. Please register again.');
      }

      // The form asks for name + department, so make sure they match.
      // (Delete this block if you only want ID + password to matter.)
      final nameMatches =
          _normalize(data['name'] as String? ?? '') == _normalize(name);
      final departmentMatches = data['department'] == department;
      if (!nameMatches || !departmentMatches) {
        await _auth.signOut();
        throw AuthException(
            'The name or department does not match this account.');
      }
    } on FirebaseAuthException catch (e) {
      throw AuthException(_messageFor(e));
    }
  }

  // ---------------------------------------------------------------------------
  // CHANGE PASSWORD (Settings > Security)
  // ---------------------------------------------------------------------------
  /// Re-checks the current password, then sets the new one.
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = _auth.currentUser;
    if (user == null || user.email == null) {
      throw AuthException('You are not logged in.');
    }

    try {
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        throw AuthException('Your current password is incorrect.');
      }
      throw AuthException(_messageFor(e));
    }
  }

  // ---------------------------------------------------------------------------
  // LOGOUT
  // ---------------------------------------------------------------------------
  Future<void> logout() => _auth.signOut();

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------
  String _normalize(String value) =>
      value.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');

  String _messageFor(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'This ID is already registered. Please log in instead.';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';
      case 'invalid-email':
        return 'Your ID can only contain letters, numbers, dashes or underscores.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect ID or password.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please wait a moment and try again.';
      case 'network-request-failed':
        return 'No internet connection. Please check your network.';
      case 'operation-not-allowed':
        return 'Email/Password sign-in is not enabled in the Firebase Console.';
      default:
        return 'Something went wrong (${e.code}). Please try again.';
    }
  }
}
