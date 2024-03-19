import 'package:flutter/material.dart';
import 'package:telegraph/defaults.dart';

class BugReport extends StatefulWidget {
  const BugReport({super.key});

  @override
  State<BugReport> createState() => _BugReportState();
}

class _BugReportState extends State<BugReport> {
  AppBar appBar = AppBar(
    backgroundColor: deepPurple500,
    title: const Text("Report a bug"),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: const Center(
        child: Text(
          "This page is under development",
          style: TextStyle(color: grey500),
        ),
      ),
    );
  }
}
