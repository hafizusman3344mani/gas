import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  double height;
  double width;

  AppLogo({this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/icons/app_logo.png',
      width: width,
      height: height,
    );
  }
}
