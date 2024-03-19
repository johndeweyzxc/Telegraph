import 'package:flutter/material.dart';

// Material color tool https://m2.material.io/resources/color
const deepPurple500 = Color(0xff673ab7);
const grey500 = Color(0xff9e9e9e);
const white = Color(0xffffffff);
const black = Color(0xff424242);
const lightBlue600 = Color(0xff039be5);

const double textbig = 20.0;
const double textSmall = 16.0;

// Width of the client screen
double widthScreen(context) {
  return MediaQuery.of(context).size.width;
}

// Height of the client screen
double heightScreen(context) {
  return MediaQuery.of(context).size.height;
}
