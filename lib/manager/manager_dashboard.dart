import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gas_station/controllers/user_controller.dart';
import 'package:gas_station/generated/l10n.dart';
import 'package:gas_station/screens/employee/employee_screen.dart';
import 'package:gas_station/manager/manager_chat_screen.dart';
import 'package:gas_station/manager/common_screen_manager.dart';
import 'package:gas_station/manager/common_card_manager.dart';
import 'package:gas_station/manager/manager_notifications.dart';
import 'package:get/get.dart';

class ManagerDashboard extends StatelessWidget {
  UserController userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: GetBuilder<UserController>(
          init: userController,
          builder: (_) {
            return CommonScreenManager(
              appBarTitle: S.of(context).manager_dashboard_text,
              bodyContent: Container(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 25.0),
                      child: CommonCardManager(
                        nextScreen: EmployeeScreen(),
                        icon: Icons.person,
                        title: S.of(context).employees_text,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 25.0),
                      child: CommonCardManager(
                        nextScreen: ManagerChatScreen(),
                        icon: Icons.chat,
                        title: S.of(context).chat,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 25.0),
                      child: CommonCardManager(
                        nextScreen: ManagerNotificationScreen(),
                        icon: Icons.notifications,
                        title: S.of(context).notifications_text,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Future<bool> _onWillPop() {
    return showDialog(
          context: Get.context,
          builder: (context) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to exit?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No'),
              ),
              TextButton(
                onPressed: () => exit(0),
                child: Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }
}
