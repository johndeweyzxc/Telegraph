import 'package:telegraph/Auth/auth_instance.dart';

class EmailAuth {
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await AuthInstance()
        .firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await AuthInstance()
        .firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
  }
}
