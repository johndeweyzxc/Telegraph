import 'package:flutter/material.dart';
import 'package:telegraph/const_var.dart';
import 'package:telegraph/Pages/Widgets/sidebar_header.dart';
import 'package:telegraph/Pages/Widgets/sidebar_items.dart';

class SideBarMenu extends StatelessWidget {
  final String? photoUrl;
  final String? email;
  final String? name;

  const SideBarMenu({
    super.key,
    required this.photoUrl,
    required this.email,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widthScreen(context) - 80.0,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SideBarHeader(
              photoUrl: photoUrl,
              email: email,
              name: name,
            ),
            SideBarItems(context: context),
          ],
        ),
      ),
    );
  }
}
