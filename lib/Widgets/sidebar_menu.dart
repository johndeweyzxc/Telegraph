import 'package:flutter/material.dart';
import 'package:telegraph/Widgets/sidebar_header.dart';
import 'package:telegraph/Widgets/sidebar_items.dart';

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
    // The equivalent of the "smallestWidth" qualifier on Android.
    var shortestSide = MediaQuery.of(context).size.shortestSide;

    // Determine if we should use mobile layout or not, 600 here is
    // a common breakpoint for a typical 7-inch tablet.
    final bool useMobileLayout = shortestSide < 600;
    // Get 80% of the total width of screen
    double mobileMenu = .80 * MediaQuery.of(context).size.width;
    // Get 30% of the total width of screen
    double tabletMenu = .30 * MediaQuery.of(context).size.width;
    return OrientationBuilder(
      builder: (context, orientation) {
        bool isPortrait = orientation == Orientation.portrait;
        return SizedBox(
          width: useMobileLayout ? mobileMenu : tabletMenu,
          child: ListView(
            children: <Widget>[
              SideBarHeader(
                photoUrl: photoUrl,
                email: email,
                name: name,
              ),
              SideBarItems(
                context: context,
                isPortrait: isPortrait,
                mobileLayout: useMobileLayout,
              ),
            ],
          ),
        );
      },
    );
  }
}
