import 'package:flutter/material.dart';

const productColor = Color.fromARGB(255, 99, 43, 255);
const defaultGrey = Color.fromARGB(167, 129, 129, 129);
const defaultWhite = Color.fromARGB(255, 255, 255, 255);
const defaultBlack = Color.fromARGB(146, 0, 0, 0);
const defaultBlue = Colors.blue;

// Login page constants
const double loginTextSizeBig = 20.0;
const double logintTextSizeSmall = 16.0;
const loginDefaultPadding = EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 0.0);
const loginSecondaryPadding = EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0);

double widthScreen(context) {
  return MediaQuery.of(context).size.width;
}

double heightScreen(context) {
  return MediaQuery.of(context).size.height;
}
