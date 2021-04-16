import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gas_station/common/common_screen.dart';
import 'package:gas_station/controllers/user_controller.dart';
import 'package:gas_station/employee/common_card_employee.dart';
import 'package:gas_station/employee/employee_chat.dart';
import 'package:gas_station/employee/employee_notifications.dart';
import 'package:gas_station/generated/l10n.dart';
import 'package:gas_station/screens/notifications/notification_screen.dart';
import 'package:get/get.dart';

class EmployeeDashboard extends StatelessWidget {
  UserController userController = Get.put(UserController());
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: GetBuilder<UserController>(
        init: userController,
        builder: (_) {
          return CommonScreen(
              appBarTitle: S.of(context).employee_dashboard_text,
              bodyContent: SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height * .56,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        child: CommonCardEmployee(
                          nextScreen: EmployeeChatScreen(),
                          icon: Icons.chat,
                          title: S.of(context).chat_with,
                          text: S.of(context).manager_text,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        child: CommonCardEmployee(
                          nextScreen: EmployeeNotificationScreen(),
                          icon: Icons.notifications,
                          title: S.of(context).notification_list_text,
                          text: S.of(context).list,
                        ),
                      ),
                    ],
                  ),
                ),
              ));
        },
      ),
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
