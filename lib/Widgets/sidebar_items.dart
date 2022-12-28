import 'package:flutter/material.dart';
import 'package:telegraph/const_var.dart';
import 'package:telegraph/Auth/auth_instance.dart';
import 'package:telegraph/Pages/about.dart';
import 'package:telegraph/Pages/messages.dart';
import 'package:telegraph/Pages/privacy_policy.dart';
import 'package:telegraph/Pages/bug_report.dart';
import 'package:telegraph/Pages/dark_mode.dart';

class SideBarItems extends StatelessWidget {
  final BuildContext context;
  const SideBarItems({super.key, required this.context});

  Future<dynamic> onTapVal(page) {
    Navigator.pop(context);
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
      color: white,
      padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      child: Wrap(
        runSpacing: 5,
        children: [
          const Divider(
            color: grey500,
          ),
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
          const Divider(
            color: black,
          ),
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
          const Divider(
            color: black,
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
