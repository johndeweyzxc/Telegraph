import 'package:flutter/material.dart';
import 'package:telegraph/const_var.dart';

class EnableDarkModePage extends StatefulWidget {
  const EnableDarkModePage({super.key});

  @override
  State<EnableDarkModePage> createState() => _EnableDarkModePageState();
}

class _EnableDarkModePageState extends State<EnableDarkModePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: deepPurple500,
        title: const Text("Enable dark mode"),
      ),
    );
  }
}
