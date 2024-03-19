import 'package:flutter/material.dart';
import 'package:telegraph/defaults.dart';
import 'package:telegraph/Auth/auth_instance.dart';
import 'package:telegraph/Pages/about.dart';
import 'package:telegraph/Pages/messages.dart';
import 'package:telegraph/Pages/privacy_policy.dart';
import 'package:telegraph/Pages/bug_report.dart';
import 'package:telegraph/Pages/dark_mode.dart';

class SideBarItems extends StatelessWidget {
  final BuildContext context;
  final bool isPortrait;
  final bool mobileLayout;

  const SideBarItems({
    super.key,
    required this.context,
    required this.isPortrait,
    required this.mobileLayout,
  });

  @override
  Widget build(BuildContext context) {
    double? fullHeight;

    // Device orientation is in portrait
    if (isPortrait) {
      // Using mobile or tablet
      if (mobileLayout || !mobileLayout) {
        fullHeight = heightScreen(context);
      }
    }
    // Device orientation is in landscape
    else {
      if (mobileLayout) {
        fullHeight = null;
      } else {
        fullHeight = heightScreen(context);
      }
    }

    return Container(
      height: fullHeight,
      color: white,
      padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      child: Column(
        children: contents(),
      ),
    );
  }

  List<Widget> contents() {
    return [
      const Divider(color: grey500),
      ListTile(
        leading: const Icon(Icons.info_outline),
        title: const Text("About"),
        onTap: () {
          onTapVal(const AboutPage());
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
      const Divider(color: grey500),
      ListTile(
        leading: const Icon(Icons.bug_report_outlined),
        title: const Text("Bug Report"),
        onTap: () {
          onTapVal(const BugReport());
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
      const Divider(color: grey500),
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
    ];
  }

  Future<dynamic> onTapVal(page) {
    Navigator.pop(context);
    return Navigator.of(context).push(
      MaterialPageRoute(builder: (BuildContext context) {
        return page;
      }),
    );
  }
}
