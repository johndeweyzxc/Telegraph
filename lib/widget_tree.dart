import 'package:flutter/material.dart';
import 'package:telegraph/Pages/login_page.dart';
import 'package:telegraph/Auth/auth_instance.dart';
import 'package:telegraph/Pages/messages.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthInstance().firebaseAuth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const MessagesPage();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
