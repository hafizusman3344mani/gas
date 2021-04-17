import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gas_station/common/custom_button.dart';
import 'package:gas_station/common/text_view.dart';
import 'package:gas_station/generated/l10n.dart';
import 'package:gas_station/screens/authentication/signin_screen.dart';
import 'package:gas_station/utils/widgetproperties.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'colors.dart';

class RouteSingleton {

  String serverKey="AAAATUlmxbw:APA91bENLLTGxy9II9GHRu-GpDLfSwxLkUHT0nNqksORMZl2dRbZIgiHNjMUuaoG02kv2iXPbOJW4B5obDR0cKOqzP3bhnVQDezW0U_8VwJaUoIw_dpUWxsVqVNiCok6vduXzn3QsVaz";

  int currentScreen = 0;

  int employee = 1;
  int manager = 2;
  int admin = 3;

  RouteSingleton._privateConstructor();

  static final RouteSingleton _instance = RouteSingleton._privateConstructor();

  static RouteSingleton get instance => _instance;

  Future<void> showLogoutDialog(BuildContext context, int user) {
    showGeneralDialog(
      barrierDismissible: true,
      barrierLabel: "",
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 400),
      context: context,
      pageBuilder: (_, __, ___) {
        return Align(
          alignment: Alignment.center,
          child: Container(
            height: MediaQuery.of(context).size.height * .25,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Textview2(
                  title: S.of(context).want_to_logout,
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0,
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 20.0),
                        child: HeroButton(
                          height: 30.0,
                          width: 120,
                          radius: 32.0,
                          gradient: AppColors.primaryColor,
                          title: S.of(context).yes_btn_text,
                          onPressed: () {
                            logoutFromApplication(context, user);
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20.0),
                        child: HeroButton(
                          height: 30.0,
                          width: 120,
                          radius: 32.0,
                          gradient: AppColors.mobileNumberlineColor,
                          title: S.of(context).no_btn_text,
                          onPressed: () {
                            Get.back();
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            margin: EdgeInsets.only(bottom: 50, left: 12, right: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      },
    );
  }

  Future<void> logoutFromApplication(
      BuildContext buildContext, int user) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (user == employee) {
      await preferences.remove('employee');
      await preferences.remove('branchId');
    } else if (user == manager) {
      await preferences.remove('manager');
    } else if (user == admin) {
      await preferences.remove('admin');
    }
    await preferences.remove('currentUserId');
    await preferences.remove('boolValue');
    await preferences.remove('phoneNumber');
    await preferences.clear();
    WidgetProperties.goToNextPageWithAllReplacement(
        buildContext, SignInScreen());
  }
}
