// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:telegraph/const_var.dart';
import 'package:telegraph/Auth/auth_instance.dart';
import 'package:telegraph/Pages/Widgets/sidebar_menu.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final User? user = AuthInstance().firebaseAuth.currentUser;

  AppBar appBar() {
    return AppBar(
      backgroundColor: productColor,
      title: Container(
        width: widthScreen(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
            Text(
              "Welcome",
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      drawer: SideBarMenu(
          photoUrl: user?.photoURL,
          email: user?.email,
          name: user?.displayName),
      body: const Center(
        child: Text("Hello"),
      ),
    );
  }
}
