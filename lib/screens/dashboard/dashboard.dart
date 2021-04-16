import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gas_station/common/common_card.dart';
import 'package:gas_station/common/common_screen.dart';
import 'package:gas_station/controllers/user_controller.dart';
import 'package:gas_station/generated/l10n.dart';
import 'package:gas_station/screens/branches/branch_screen.dart';
import 'package:gas_station/screens/employee/employee_screen.dart';
import 'package:gas_station/screens/managers/manager_screen.dart';
import 'package:gas_station/screens/notifications/notification_screen.dart';
import 'package:get/get.dart';
import 'package:gas_station/utils/notification_singleton.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  var userController = Get.put(UserController());

  int totalEmp;
  int totalManagers;
  int totalBranches;
  @override
  void initState() {
   // NotificationSingleton.instance.messages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: GetBuilder<UserController>(
        init: userController,
        builder: (_) {
          return CommonScreen(
            appBarTitle: S.of(context).admin_dashboard_text,
            bodyContent: Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FutureBuilder(
                            future: FirebaseFirestore.instance
                                .collection('employees')
                                .get(),
                            builder: (context, snapshot) {
                              return CommonCard(
                                nextScreen: EmployeeScreen(),
                                icon: Icons.person,
                                title: S.of(context).employees_text,
                                count: snapshot.hasData
                                    ? snapshot.data.docs.length.toString()
                                    : '',
                              );
                            }),
                        FutureBuilder(
                            future: FirebaseFirestore.instance
                                .collection('managers')
                                .get(),
                            builder: (context, snapshot) {
                              return CommonCard(
                                nextScreen: ManagerScreen(),
                                icon: Icons.person,
                                title: S.of(context).managers_text,
                                count: snapshot.hasData
                                    ? snapshot.data.docs.length.toString()
                                    : '',
                              );
                            }),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.transparent,
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FutureBuilder(
                            future: FirebaseFirestore.instance
                                .collection('branches')
                                .get(),
                            builder: (context, snapshot) {
                              return CommonCard(
                                nextScreen: BranchScreen(),
                                icon: Icons.home,
                                title: S.of(context).branches_text,
                                count: snapshot.hasData
                                    ? snapshot.data.docs.length.toString()
                                    : '',
                              );
                            }),
                        FutureBuilder(
                            future: FirebaseFirestore.instance
                                .collection('notifications')
                                .get(),
                            builder: (context, snapshot) {
                              return CommonCard(
                                nextScreen: NotificationScreen(),
                                icon: Icons.notification_important,
                                title: S.of(context).notifications_text,
                                count: snapshot.hasData
                                    ? snapshot.data.docs.length.toString()
                                    : '',
                              );
                            }),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
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
