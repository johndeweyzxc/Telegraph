import 'package:flutter/material.dart';
import 'package:telegraph/defaults.dart';

class PrivacyPolicyPages extends StatelessWidget {
  const PrivacyPolicyPages({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: deepPurple500,
        title: const Text("Privacy Policy"),
      ),
      body: const Center(
        child: Text(
          "This page is under development",
          style: TextStyle(color: grey500),
        ),
      ),
    );
  }
}
