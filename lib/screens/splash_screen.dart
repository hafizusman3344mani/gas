import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gas_station/common/app_logo.dart';
import 'package:gas_station/common/user_authentication.dart';
import 'package:gas_station/controllers/branch_controller.dart';
import 'package:gas_station/employee/employee_dashboard.dart';
import 'package:gas_station/manager/manager_dashboard.dart';
import 'package:gas_station/models/user/user_model.dart';
import 'package:gas_station/screens/dashboard/dashboard.dart';
import 'package:gas_station/user_choice.dart';
import 'package:gas_station/utils/widgetproperties.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'authentication/signin_screen.dart';

void main() => runApp(MaterialApp(
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    ));

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;

  String role = '';

  @override
  void initState() {
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    animation = Tween<double>(begin: 10, end: 210).animate(controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status != AnimationStatus.completed) {
          controller.forward();
        }
      });

    controller.forward();
    getBoolValuesSF();
    Get.put(BranchController());
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Center(
          child: Hero(
              tag: 'logo',
              child: AppLogo(width: animation.value, height: animation.value)),
        ),
      ),
    );
  }

  Future<void> getBoolValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    bool boolValue = prefs.getBool('boolValue');
    Timer(Duration(seconds: 4), () {
      ///WidgetProperties.goToNextPageWithReplacement(context, SignInScreen());
      if (boolValue == true)
        getData();
      else {
        WidgetProperties.goToNextPageWithAllReplacement(context, SignInScreen());
      }
    });
  }

  getData() async {
    UserModel userModel;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String phoneNumber = prefs.getString('phoneNumber');

    var adminSnapShot =
    await FirebaseFirestore.instance.collection('admin').get();
    var employeeSnapShot =
        await FirebaseFirestore.instance.collection('employees').get();
    var managerSnapShot =
        await FirebaseFirestore.instance.collection('managers').get();

    int adminCount = adminSnapShot.docs
        .where((element) => element.get('phone').toString() == phoneNumber)
        .toList()
        .length;
    int empCount = employeeSnapShot.docs
        .where((element) => element.get('phone').toString() == phoneNumber)
        .toList()
        .length;
    int managerCout = managerSnapShot.docs
        .where(
            (element) => element.get('phone').toString().trim() == phoneNumber)
        .toList()
        .length;

    if (empCount != 0) {
      var document = await FirebaseFirestore.instance
          .collection('employees')
          .where('phone', isEqualTo:phoneNumber )
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          userModel = UserModel.fromMap(value.docs.first.data());
        }
      });

      setState(() {
        role = 'employee';
        prefs.setString('currentUserId', userModel.id);
        prefs.setString('branchId', userModel.branchId);
        prefs.setBool('employee', true);
        prefs.setBool('manager', false);
        prefs.setBool('admin', false);
        prefs.setBool('boolValue', true);
        // prefs.setString("phoneNumber", widget.phoneNumber);
      });
    } else if (managerCout != 0) {
      var document = await FirebaseFirestore.instance
          .collection('managers')
          .where('phone', isEqualTo:phoneNumber )
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          userModel = UserModel.fromMap(value.docs.first.data());
        }
      });

      setState(() {
        role = 'manager';
        prefs.setString('currentUserId', userModel.id);
        prefs.setBool('manager', true);
        prefs.setBool('employee', false);
        prefs.setBool('admin', false);
        prefs.setBool('boolValue', true);
        // prefs.setString("phoneNumber", widget.phoneNumber);
      });
    } else if(adminCount!= 0) {
      var document = await FirebaseFirestore.instance
          .collection('admin')
          .where('phone', isEqualTo:phoneNumber )
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          userModel = UserModel.fromMap(value.docs.first.data());
        }
      });

      setState(() {
        role = 'admin';
      //  prefs.setString('currentUserId', userModel.id);
        prefs.setBool('admin', true);
        prefs.setBool('manager', false);
        prefs.setBool('employee', false);
        prefs.setBool('boolValue', true);
        // prefs.setString("phoneNumber", widget.phoneNumber);
      });
    }

    if (role == 'manager') {
      WidgetProperties.closeLoader();
      WidgetProperties.goToNextPageWithAllReplacement(
          context, ManagerDashboard());
    } else if (role == 'admin') {
      WidgetProperties.closeLoader();
      WidgetProperties.goToNextPageWithAllReplacement(context, Dashboard());
    } else if (role == 'employee') {
      WidgetProperties.closeLoader();
      WidgetProperties.goToNextPageWithAllReplacement(
          context, EmployeeDashboard());
    }
  }
}
