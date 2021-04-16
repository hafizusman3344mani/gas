import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gas_station/employee/employee_dashboard.dart';
import 'package:gas_station/manager/manager_chat_screen.dart';
import 'package:gas_station/manager/manager_dashboard.dart';
import 'package:gas_station/screens/dashboard/dashboard.dart';
import 'package:gas_station/utils/widgetproperties.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Testing extends StatefulWidget {
  final String mobile;

  const Testing({Key key, this.mobile}) : super(key: key);
  @override
  _TestingState createState() => _TestingState();
}

class _TestingState extends State<Testing> {
  String role = '';
  @override
  void initState() {
    getData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
    );
  }

  getData() async {
    var employeeSnapShot =
        await FirebaseFirestore.instance.collection('employees').get();
    var managerSnapShot =
        await FirebaseFirestore.instance.collection('managers').get();

    int empCout = employeeSnapShot.docs
        .where((element) => element.get('phone').toString() == widget.mobile)
        .toList()
        .length;
    int managerCout = managerSnapShot.docs
        .where((element) =>
            element.get('phone').toString().trim() == widget.mobile)
        .toList()
        .length;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (empCout != 0) {
      setState(() {
        role = 'employee';
        prefs.setBool('employee', true);
        prefs.setBool('manager', false);
        prefs.setBool('admin', false);
      });
    } else if (managerCout != 0) {
      setState(() {
        role = 'manager';
        prefs.setBool('manager', true);
        prefs.setBool('employee', false);
        prefs.setBool('admin', false);
      });
    } else {
      setState(() {
        role = 'admin';
        prefs.setBool('admin', true);
        prefs.setBool('manager', false);
        prefs.setBool('employee', false);
      });
    }

    if (role == 'manager') {
      WidgetProperties.goToNextPageWithAllReplacement(
          context, ManagerDashboard());
    } else if (role == 'admin') {
      WidgetProperties.goToNextPageWithAllReplacement(context, Dashboard());
    } else if (role == 'employee') {
      WidgetProperties.goToNextPageWithAllReplacement(context, EmployeeDashboard());
    }
  }
}
