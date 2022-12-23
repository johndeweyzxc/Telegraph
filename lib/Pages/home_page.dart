// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:telegraph/Auth/auth_instance.dart';
import 'package:telegraph/Pages/about.dart';
import 'package:telegraph/Pages/dark_mode.dart';
import 'package:telegraph/Pages/messages.dart';
import 'package:telegraph/Pages/privacy_policy.dart';
import 'package:telegraph/const_var.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final User? user = AuthInstance().firebaseAuth.currentUser;

  AppBar appBar() {
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
          photoUrl: user?.photoURL,
          email: user?.email,
          name: user?.displayName),
      body: const Center(
        child: Text("Hello"),
      ),
    );
  }
}

class NavigationDrawer extends StatelessWidget {
  final String? photoUrl;
  final String? email;
  final String? name;

  const NavigationDrawer({
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
            DrawerHeader(
              photoUrl: photoUrl,
              email: email,
              name: name,
            ),
            DrawerItems(context: context),
          ],
        ),
      ),
    );
  }
}

class DrawerHeader extends StatelessWidget {
  final String? photoUrl;
  final String? email;
  final String? name;

  const DrawerHeader({
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

class DrawerItems extends StatelessWidget {
  final BuildContext context;
  const DrawerItems({super.key, required this.context});

  Future<dynamic> onTapVal(page) {
    return Navigator.of(context).push(
      MaterialPageRoute(builder: (BuildContext context) {
        return page;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: heightScreen(context),
      color: defaultWhite,
      padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      child: Wrap(
        runSpacing: 5,
        children: [
          const Divider(
            color: defaultGrey,
          ),
          ListTile(
            leading: const Icon(
              Icons.home_outlined,
            ),
            title: const Text("Home"),
            onTap: () {
              onTapVal(const HomePage());
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.message_outlined,
            ),
            title: const Text("Messages"),
            onTap: () {
              onTapVal(const MessagesPage());
            },
          ),
          const Divider(
            color: defaultBlack,
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text("About"),
            onTap: () {
              onTapVal(const AboutPage());
            },
          ),
          ListTile(
            leading: const Icon(Icons.policy),
            title: const Text("Privacy Policy"),
            onTap: () {
              onTapVal(const PrivacyPolicyPages());
            },
          ),
          ListTile(
            leading: const Icon(Icons.gavel),
            title: const Text("Terms of Use"),
            onTap: () {
              onTapVal(const PrivacyPolicyPages());
            },
          ),
          const Divider(
            color: defaultBlack,
          ),
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text("Dark mode"),
            onTap: () {
              onTapVal(const EnableDarkModePage());
            },
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
