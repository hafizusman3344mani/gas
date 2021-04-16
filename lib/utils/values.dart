import 'package:flutter/cupertino.dart';

class AppValues {
  static final double topBackgroundRadius = 35.0;
  static final double commonBodyCardRadius = 26.0;
  static final double cardElevation = 6.0;
  static final double horizontalMargin = 30.0;
  static final double horizontalMarginForm = 10.0;
  static final double verticalMargin = 30.0;

  static final double commonSignupHeaderTopMagin = 40.0;
  static final double commonButtonHeight = 30.0;
  static final double commonButtonCornerRadius = 32.0;

  static final String fontFamily = 'Sans';

  static final int subjectListShowPerPageLimit = 8;
  static double inputFieldHeight = 55.0;

  static double commonBGHeight = 0.5;

  static sizedBox(double height) {
    SizedBox(
      height: height,
    );
  }

  static selectedSubjectDecoration(
      Color backgroundColor, BoxShape boxShape, Color borderColor) {
    BoxDecoration(
        color: backgroundColor,
        shape: boxShape,
        border: Border.all(color: borderColor));
  }
}
