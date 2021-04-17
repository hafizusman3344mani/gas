import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gas_station/common/common_image.dart';
import 'package:gas_station/common/constants.dart';
import 'package:gas_station/common/custom_button.dart';
import 'package:gas_station/common/text_view.dart';
import 'package:gas_station/employee/employee_chat.dart';
import 'package:gas_station/employee/employee_dashboard.dart';
import 'package:gas_station/employee/employee_notifications.dart';
import 'package:gas_station/generated/l10n.dart';
import 'package:gas_station/main.dart';
import 'package:gas_station/models/user/user_model.dart';
import 'package:gas_station/screens/authentication/signin_screen.dart';
import 'package:gas_station/utils/colors.dart';
import 'package:gas_station/utils/route_singleton.dart';
import 'package:gas_station/utils/widgetproperties.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommonDrawerEmployee extends StatefulWidget {
  final Widget widget;
  final String title;
  final bool bottomOverflow;

  CommonDrawerEmployee({this.widget, this.title, this.bottomOverflow});

  @override
  _CommonDrawerEmployeeState createState() => _CommonDrawerEmployeeState();
}

class _CommonDrawerEmployeeState extends State<CommonDrawerEmployee> {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  UserModel userModel;

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: widget.bottomOverflow,
      appBar: AppBar(
        actions: <Widget>[
          // IconButton(
          //   icon: Icon(
          //     Icons.notifications_none,
          //     color: Colors.white,
          //   ),
          //   onPressed: () {
          //     // do something
          //   },
          // )
        ],
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        title: Text(
          widget.title,
          style: TextStyle(color: AppColors.textWhiteColor),
        ),
      ),
      backgroundColor: Colors.white,
      drawer: Drawer(
          key: _drawerKey,
          child: Column(
            children: [
              CommonImage(
                imageUrl: Constants.BENZOL_3_IMAGE,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 13.0, vertical: 10.0),
                alignment: Alignment.centerLeft,
                child: Textview2(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  title: userModel != null
                      ? "${userModel.firstName} ${userModel.lastName}"
                      : '',
                  color: AppColors.primaryColor,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 13.0),
                alignment: Alignment.centerLeft,
                child: Textview2(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  title: userModel != null
                      ? "${userModel.branchName} ${userModel.cityName}"
                      : '',
                  color: AppColors.primaryColor,
                ),
              ),
              ListTile(
                  onTap: () {
                    WidgetProperties.goToNextPageWithReplacement(
                        context, EmployeeDashboard());
                  },
                  title: Transform.translate(
                    offset: Offset(-16, 0),
                    child: Textview2(
                      title: S.of(context).dashboard_text,
                      color: AppColors.listTileTitleColor,
                      fontSize: 15.0,
                    ),
                  ),
                  leading: Icon(Icons.home)),
              ListTile(
                onTap: () {
                  WidgetProperties.goToNextPageWithReplacement(
                      context, EmployeeChatScreen());
                },
                title: Transform.translate(
                  offset: Offset(-16, 0),
                  child: Textview2(
                    title: S.of(context).chat,
                    color: AppColors.listTileTitleColor,
                    fontSize: 15.0,
                  ),
                ),
                leading: Icon(Icons.chat_bubble),
              ),
              ListTile(
                onTap: () {
                  WidgetProperties.goToNextPageWithReplacement(
                      context, EmployeeNotificationScreen());
                },
                title: Transform.translate(
                  offset: Offset(-16, 0),
                  child: Textview2(
                    title: S.of(context).notifications_text,
                    color: AppColors.listTileTitleColor,
                    fontSize: 15.0,
                  ),
                ),
                leading: Icon(Icons.notifications),
              ),
              ExpansionTile(
                leading: Icon(Icons.language),
                title: Transform.translate(
                  offset: Offset(-16, 0),
                  child: Textview2(
                    title:S.of(context).languages_text,
                    color: AppColors.listTileTitleColor,
                    fontSize: 15.0,
                  ),
                ),
                children: <Widget>[
                  ListTile(
                    onTap: () async {
                      await MyApp.setLocale(context, Locale('en'))
                          .then((value) => WidgetProperties.pop(context));
                      setState(() {});
                    },
                    title: Text(
                      'English',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                  ListTile(
                    onTap: () async {
                      await MyApp.setLocale(context, Locale('ar', 'AE'))
                          .then((value) => WidgetProperties.pop(context));
                      setState(() {});
                    },
                    title: Text(
                      'العربية',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
              ListTile(
                onTap: () {
                  RouteSingleton.instance.showLogoutDialog(context, RouteSingleton.instance.employee);
                },
                title: Transform.translate(
                  offset: Offset(-16, 0),
                  child: Textview2(
                    title: S.of(context).logout_text,
                    color: AppColors.listTileTitleColor,
                    fontSize: 15.0,
                  ),
                ),
                leading: Icon(Icons.logout),
              ),
            ],
          )),
      body: widget.widget,
    );
  }

  getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String phone = sharedPreferences.getString('phoneNumber');
    await FirebaseFirestore.instance
        .collection('employees')
        .where('phone', isEqualTo: phone)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        userModel = UserModel.fromMap(value.docs.single.data());
        setState(() {}); //if it is a single document
      }
    });
  }
}
