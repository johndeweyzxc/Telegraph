// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:telegraph/Auth/auth_instance.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final User? user = AuthInstance().firebaseAuth.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user?.email ?? 'user email'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            AuthInstance().signOut();
          },
          child: const Text("Log out"),
        ),
      ),
    );
  }
}
