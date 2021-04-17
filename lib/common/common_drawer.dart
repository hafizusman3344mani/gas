import 'package:firebase_auth_ui/firebase_auth_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gas_station/common/common_image.dart';
import 'package:gas_station/common/constants.dart';
import 'package:gas_station/common/custom_button.dart';
import 'package:gas_station/common/text_view.dart';
import 'package:gas_station/common/user_authentication.dart';
import 'package:gas_station/generated/l10n.dart';
import 'package:gas_station/screens/authentication/signin_screen.dart';
import 'package:gas_station/screens/branches/branch_screen.dart';
import 'package:gas_station/screens/dashboard/dashboard.dart';
import 'package:gas_station/screens/employee/employee_screen.dart';
import 'package:gas_station/screens/managers/manager_screen.dart';
import 'package:gas_station/screens/notifications/notification_screen.dart';
import 'package:gas_station/utils/colors.dart';
import 'package:gas_station/utils/my_behaviour.dart';
import 'package:gas_station/utils/route_singleton.dart';
import 'package:gas_station/utils/widgetproperties.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class CommonDrawer extends StatefulWidget {
  final Widget widget;
  final String title;
  final bool bottomOverflow;

  CommonDrawer({this.widget, this.title, this.bottomOverflow});

  @override
  _CommonDrawerState createState() => _CommonDrawerState();
}

class _CommonDrawerState extends State<CommonDrawer> {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    //RouteSingleton.instance.currentScreen = 1;
    return Scaffold(
      resizeToAvoidBottomInset: widget.bottomOverflow,
      appBar: AppBar(
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
            mainAxisAlignment: MainAxisAlignment.start,
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
                  title: S.of(context).admin_text,
                  color: AppColors.primaryColor,
                ),
              ),
              Expanded(
                child: ScrollConfiguration(
                  behavior: MyBehavior(),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ListTile(
                            onTap: () {
                              WidgetProperties.goToNextPageWithReplacement(
                                  context, Dashboard());
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
                                context, BranchScreen());
                          },
                          title: Transform.translate(
                            offset: Offset(-16, 0),
                            child: Textview2(
                              title: S.of(context).branches_text,
                              color: AppColors.listTileTitleColor,
                              fontSize: 15.0,
                            ),
                          ),
                          leading: Icon(Icons.home),
                        ),
                        ListTile(
                          onTap: () {
                            WidgetProperties.goToNextPageWithReplacement(
                                context, EmployeeScreen());
                          },
                          title: Transform.translate(
                            offset: Offset(-16, 0),
                            child: Textview2(
                              title: S.of(context).employees_text,
                              color: AppColors.listTileTitleColor,
                              fontSize: 15.0,
                            ),
                          ),
                          leading: Icon(Icons.person),
                        ),
                        ListTile(
                          onTap: () {
                            WidgetProperties.goToNextPageWithReplacement(
                                context, ManagerScreen());
                          },
                          title: Transform.translate(
                            offset: Offset(-16, 0),
                            child: Textview2(
                              title: S.of(context).managers_text,
                              color: AppColors.listTileTitleColor,
                              fontSize: 15.0,
                            ),
                          ),
                          leading: Icon(Icons.person),
                        ),
                        ListTile(
                          onTap: () {
                            WidgetProperties.goToNextPageWithReplacement(
                                context, NotificationScreen());
                          },
                          title: Transform.translate(
                            offset: Offset(-16, 0),
                            child: Textview2(
                              title: S.of(context).notifications_text,
                              color: AppColors.listTileTitleColor,
                              fontSize: 15.0,
                            ),
                          ),
                          leading: Icon(Icons.notification_important),
                        ),
                        ExpansionTile(
                          leading: Icon(Icons.language),
                          title: Transform.translate(
                            offset: Offset(-16, 0),
                            child: Textview2(
                              title: S.of(context).languages_text,
                              color: AppColors.listTileTitleColor,
                              fontSize: 15.0,
                            ),
                          ),
                          children: <Widget>[
                            ListTile(
                              onTap: () async {
                                await MyApp.setLocale(context, Locale('en'))
                                    .then((value) =>
                                        WidgetProperties.pop(context));
                                setState(() {});
                              },
                              title: Text(
                                'English',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                            ),
                            ListTile(
                              onTap: () async {
                                await MyApp.setLocale(
                                        context, Locale('ar', 'AE'))
                                    .then((value) =>
                                        WidgetProperties.pop(context));
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
                            RouteSingleton.instance.showLogoutDialog(context, RouteSingleton.instance.admin);
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
                        SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )),
      body: widget.widget,
    );
  }
}
