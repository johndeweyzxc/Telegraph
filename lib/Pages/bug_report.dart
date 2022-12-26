import 'package:flutter/material.dart';

class BugReport extends StatefulWidget {
  const BugReport({super.key});

  @override
  State<BugReport> createState() => _BugReportState();
}

class _BugReportState extends State<BugReport> {
  AppBar appBar = AppBar(
    title: const Text("Report a bug"),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: const Center(child: Text("Report a bug")),
    );
  }
}
