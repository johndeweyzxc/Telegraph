import 'package:firebase_auth/firebase_auth.dart';
import 'package:telegraph/Auth/sign_in_google.dart';

class AuthInstance {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<void> signOut() async {
    if (await GoogleAuth().googleSignIn.isSignedIn()) {
      await GoogleAuth().googleSignIn.signOut();
    }
    await AuthInstance().firebaseAuth.signOut();
  }
}
