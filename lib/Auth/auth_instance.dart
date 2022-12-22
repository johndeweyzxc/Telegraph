// ignore_for_file: depend_on_referenced_packages

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:telegraph/Auth/sign_in_google.dart';

class AuthInstance {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<void> signOut() async {
    if (await GoogleAuth().googleSignIn.isSignedIn()) {
      debugPrint("User is signed in!");
      await GoogleAuth().googleSignIn.signOut();
    }
    await AuthInstance().firebaseAuth.signOut();
  }
}
