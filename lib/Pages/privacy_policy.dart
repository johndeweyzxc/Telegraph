import 'package:flutter/material.dart';
import 'package:telegraph/const_var.dart';

class PrivacyPolicyPages extends StatelessWidget {
  const PrivacyPolicyPages({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: deepPurple500,
        title: const Text("Privacy Policy"),
      ),
    );
  }
}
