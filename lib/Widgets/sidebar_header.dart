import 'package:flutter/material.dart';
import 'package:telegraph/defaults.dart';

class SideBarHeader extends StatelessWidget {
  final String? photoUrl;
  final String? email;
  final String? name;

  const SideBarHeader({
    super.key,
    required this.photoUrl,
    required this.email,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: white,
      padding: EdgeInsets.only(
        top: 35 + MediaQuery.of(context).padding.top,
        bottom: 10,
        left: 20,
        right: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          userAvatar(),
          userName(),
          userEmail(),
        ],
      ),
    );
  }

  String? createName() {
    if (name == null || name == "") {
      List<String>? getName = email?.split('@');
      return getName!.first;
    } else {
      return name;
    }
  }

  dynamic profileImage() {
    if (photoUrl == null) {
      return const AssetImage("assets/images/flutter-symbol.png");
    } else {
      return NetworkImage(photoUrl!);
    }
  }

  Container userAvatar() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      child: CircleAvatar(
        radius: 50,
        backgroundColor: white,
        backgroundImage: profileImage(),
      ),
    );
  }

  Container userName() {
    return Container(
      margin: const EdgeInsets.only(bottom: 5.0),
      child: Text(
        createName()!,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: textbig,
        ),
      ),
    );
  }

  Text userEmail() {
    return Text(
      email!,
      style: const TextStyle(
        color: grey500,
        fontSize: textSmall,
      ),
    );
  }
}
