import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gas_station/utils/route_singleton.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';


import 'colors.dart';
import 'loader.dart';

class WidgetProperties {
  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static showToast(String message, Color textColor, Color backgroundColor) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: backgroundColor,
      textColor: textColor,
    );
  }

  static void goToNextPage(BuildContext buildContext, Widget widget) {
    //Navigator.push(buildContext, RoutePage(builder: (buildContext) => widget));
    Navigator.push(
      buildContext,
      PageRouteBuilder(
        pageBuilder: (c, a1, a2) => FadeTransition(opacity: a1, child: widget),
        transitionsBuilder: (c, anim, a2, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: Duration(milliseconds: 100),
      ),
    );
  }


  static void pop(BuildContext buildContext) {
    //Navigator.push(buildContext, RoutePage(builder: (buildContext) => widget));
    Navigator.of(buildContext).pop();
  }

  static void goToNextPageWithReplacement(
      BuildContext buildContext, Widget widget) {
    Navigator.pushReplacement(
      buildContext,
      PageRouteBuilder(
        pageBuilder: (c, a1, a2) => FadeTransition(opacity: a1, child: widget),
        transitionsBuilder: (c, anim, a2, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: Duration(milliseconds: 100),
      ),
    );
  }

  static showLoader() {
//Get.dialog(Loader(),useRootNavigator: true,barrierDismissible: false,barrierColor: Colors.grey.withOpacity(0.2));
    Get.generalDialog(
      pageBuilder: (context, animation, secondaryAnimation) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Loader(),
        );
      },
    );
  }

  static void goToNextPageWithAllReplacement(
      BuildContext buildContext, Widget widget) {
    Navigator.pushAndRemoveUntil(
        buildContext,
        PageRouteBuilder(
          pageBuilder: (c, a1, a2) =>
              FadeTransition(opacity: a1, child: widget),
          transitionsBuilder: (c, anim, a2, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: Duration(milliseconds: 100),
        ),
        (Route<dynamic> route) => false);
  }

  static var textStyleInputFiled = TextStyle(
      height: 1,
      color: AppColors.commoneadingtextColor,
      fontWeight: FontWeight.w300,
      fontSize: 14.0);

  static Widget getDivider({Color color}) {
    return Divider(
      height: 1,
      color: color,
      thickness: 0.2,
    );
  }

  // static showLoader() {
  //   //Get.dialog(Loader(),useRootNavigator: true,barrierDismissible: false,barrierColor: Colors.grey.withOpacity(0.2));
  //   Get.generalDialog(
  //     pageBuilder: (context, animation, secondaryAnimation) {
  //       return WillPopScope(
  //         onWillPop: () async => false,
  //         child: Loader(),
  //       );
  //     },
  //   );
  // }

  static closeLoader() {
    Get.back(canPop: true);
  }

  static String utcTimeToString() {
    var dateUtc = DateTime.now().toUtc();
    var strToDateTime = DateTime.parse(dateUtc.toString());
    var newFormat = DateFormat("yyyy-MM-ddTHH:mm:00+00:00");
    String updatedDt = newFormat.format(strToDateTime);
    return updatedDt;
  }

  static String customUtcTimeToString() {
    var f = DateFormat('EEE, d MMM yyyy HH:mm:00 ');
    String date = f.format(DateTime.now()) + "GMT";
    return date;
  }
}
