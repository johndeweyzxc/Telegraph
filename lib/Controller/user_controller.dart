import 'package:firebase_auth/firebase_auth.dart';
import 'package:telegraph/Auth/sign_in_email.dart';

class UserController {
  // Authenticate user
  Future<String?> signInEmailPassword(String email, String password) async {
    try {
      await EmailAuth()
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (error) {
      return error.message;
    }

    return 'Success';
  }

  // Create new account
  Future<String?> signUpEmailPassword(String email, String password) async {
    try {
      await EmailAuth()
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (error) {
      return error.message;
    }

    return 'Success';
  }
}
