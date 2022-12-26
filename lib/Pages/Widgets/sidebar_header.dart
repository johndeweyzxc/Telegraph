import 'package:flutter/material.dart';
import 'package:telegraph/const_var.dart';

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

  String? createName() {
    if (name == null || name == "") {
      List<String>? getName = email?.split('@');
      return getName!.first;
    } else {
      return name;
    }
  }

  String? defaultPhoto() {
    if (photoUrl == null) {
      return ("""https://cdn-images-1.medium.com/max
        /1200/1*5-aoK8IBmXve5whBQM90GA.png""");
    } else {
      return photoUrl;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: defaultWhite,
      padding: EdgeInsets.only(
        top: 35 + MediaQuery.of(context).padding.top,
        bottom: 10,
        left: 20,
        right: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: defaultWhite,
            backgroundImage: NetworkImage(defaultPhoto()!),
          ),
          const SizedBox(
            height: 12,
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 5.0),
            child: Text(
              createName()!,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: loginTextSizeBig,
              ),
            ),
          ),
          Text(
            email!,
            style: const TextStyle(
              color: defaultGrey,
              fontSize: logintTextSizeSmall,
            ),
          ),
        ],
      ),
    );
  }
}
