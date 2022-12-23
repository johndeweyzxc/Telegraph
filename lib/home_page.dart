// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:telegraph/Auth/auth_instance.dart';
import 'package:telegraph/const_var.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String? name;
  late String? photoUrl;
  final User? user = AuthInstance().firebaseAuth.currentUser;

  AppBar appBar() {
    if (user?.displayName == null) {
      setState(() {
        List<String>? getName = user?.email?.split('@');
        name = getName?.first;
      });
    } else {
      setState(() {
        name = user?.displayName;
      });
    }

    if (user?.photoURL == null) {
      setState(() {
        photoUrl =
            "https://cdn-images-1.medium.com/max/1200/1*5-aoK8IBmXve5whBQM90GA.png";
      });
    } else {
      setState(() {
        photoUrl = user?.photoURL;
      });
    }

    return AppBar(
      backgroundColor: productColor,
      title: Container(
        width: widthScreen(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
            Text(
              "Welcome",
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      drawer: NavigationDrawer(
          photoUrl: photoUrl, userName: user?.email, name: name),
      body: const Center(child: Text("Hello")),
    );
  }
}

class NavigationDrawer extends StatelessWidget {
  final String? photoUrl;
  final String? userName;
  final String? name;

  const NavigationDrawer({
    super.key,
    required this.photoUrl,
    required this.userName,
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
            DrawerHeader(
              photoUrl: photoUrl,
              userName: userName,
              name: name,
            ),
            const DrawerItems(),
          ],
        ),
      ),
    );
  }
}

class DrawerHeader extends StatelessWidget {
  final String? photoUrl;
  final String? userName;
  final String? name;

  const DrawerHeader({
    super.key,
    required this.photoUrl,
    required this.userName,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: defaultWhite,
      padding: EdgeInsets.only(
        top: 24 + MediaQuery.of(context).padding.top,
        bottom: 10,
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: defaultWhite,
            backgroundImage: NetworkImage(photoUrl!),
          ),
          const SizedBox(
            height: 12,
          ),
          Text(name!),
          Text(userName!),
        ],
      ),
    );
  }
}

class DrawerItems extends StatelessWidget {
  const DrawerItems({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: defaultWhite,
      padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      child: Wrap(
        runSpacing: 5,
        children: [
          const Divider(
            color: defaultGrey,
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text("Home"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.message_outlined),
            title: const Text("Messages"),
            onTap: () {},
          ),
          const Divider(
            color: defaultBlack,
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text("About"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.policy),
            title: const Text("Privacy Policy"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.gavel),
            title: const Text("Terms of Use"),
            onTap: () {},
          ),
          const Divider(
            color: defaultBlack,
          ),
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text("Dark mode"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text("Settings"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.logout_outlined),
            title: const Text("Logout"),
            onTap: () {
              AuthInstance().signOut();
            },
          ),
        ],
      ),
    );
  }
}
