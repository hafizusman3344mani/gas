import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gas_station/manager/manager_chat_screen.dart';
import 'package:gas_station/manager/manager_dashboard.dart';
import 'package:gas_station/new.dart';
import 'package:gas_station/screens/dashboard/dashboard.dart';
import 'package:gas_station/utils/widgetproperties.dart';

class UserChoice extends StatefulWidget {
  @override
  _UserChoiceState createState() => _UserChoiceState();
}

class _UserChoiceState extends State<UserChoice> {
  TextEditingController mobile = TextEditingController();
  String role = '';
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: TextField(
                controller: mobile,
                decoration: InputDecoration(
                  hintText: 'Enter mobile number',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                WidgetProperties.goToNextPageWithReplacement(
                    context,
                    Testing(
                      mobile: mobile.text,
                    ));
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
