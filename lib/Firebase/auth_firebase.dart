import 'package:firebase_auth/firebase_auth.dart';

class AuthFirebase {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // ================= LOGIN =================
  Future<void> loginUsingEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    } on FirebaseAuthException {
      rethrow; // 🔥 خلي الخطأ يطلع للـ UI
    } catch (e) {
      rethrow;
    }
  }

  // ================= SIGN UP =================
  Future<void> signupUsingUsernameEmailAndPassword({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final user = userCredential.user;
      if (user != null) {
        await user.updateDisplayName(username);
      }
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  // ================= LOGOUT =================
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  // ================= CURRENT USER =================
  User? get currentUser => _firebaseAuth.currentUser;
}
