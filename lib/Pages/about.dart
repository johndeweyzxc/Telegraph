import 'package:flutter/material.dart';
import 'package:telegraph/const_var.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: productColor,
        title: const Text("About"),
      ),
    );
  }
}
