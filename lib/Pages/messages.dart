import 'package:flutter/material.dart';
import 'package:telegraph/const_var.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: productColor,
        title: const Text("Messages"),
      ),
    );
  }
}
