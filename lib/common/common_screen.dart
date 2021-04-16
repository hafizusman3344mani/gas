import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gas_station/common/app_logo.dart';
import 'package:gas_station/common/common_card.dart';
import 'package:gas_station/common/common_drawer.dart';
import 'package:gas_station/common/common_image.dart';
import 'package:gas_station/common/constants.dart';
import 'package:gas_station/employee/common_drawer_employee.dart';
import 'package:gas_station/manager/common_drawer_manager.dart';
import 'package:gas_station/screens/branches/branch_screen.dart';
import 'package:gas_station/screens/employee/employee_screen.dart';
import 'package:gas_station/screens/managers/manager_screen.dart';
import 'package:gas_station/screens/notifications/notification_screen.dart';
import 'package:gas_station/utils/my_behaviour.dart';
import 'package:gas_station/utils/widgetproperties.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommonScreen extends StatefulWidget {
  final Widget bodyContent;
  final String appBarTitle;

  const CommonScreen({this.bodyContent, this.appBarTitle});

  @override
  _CommonScreenState createState() => _CommonScreenState();
}

class _CommonScreenState extends State<CommonScreen> {
  bool admin = false;
  bool manager = false;
  bool employee = false;

  @override
  void initState() {
    getBool();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return manager
        ? CommonDrawerManager(
            bottomOverflow: true,
            title: widget.appBarTitle,
            widget: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: ScrollConfiguration(
                behavior: MyBehavior(),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * .31,
                        width: MediaQuery.of(context).size.width,
                        child: CommonImage(
                          imageUrl: Constants.BENZOL_1_IMAGE,
                          imageWidth: MediaQuery.of(context).size.width,
                          imageBoxFit: BoxFit.fill,
                        ),
                      ),
                      Container(
                        color: Colors.transparent,
                        height: MediaQuery.of(context).size.height * .56,
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Opacity(
                                opacity: 0.2,
                                child: Container(
                                    child: AppLogo(
                                  width: WidgetProperties.screenWidth(context) *
                                      .6,
                                  height:
                                      WidgetProperties.screenWidth(context) *
                                          .6,
                                )),
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * .56,
                                  child: widget.bodyContent),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        : admin
            ? CommonDrawer(
                bottomOverflow: true,
                title: widget.appBarTitle,
                widget: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: ScrollConfiguration(
                    behavior: MyBehavior(),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * .31,
                            width: MediaQuery.of(context).size.width,
                            child: CommonImage(
                              imageUrl: Constants.BENZOL_1_IMAGE,
                              imageWidth: MediaQuery.of(context).size.width,
                              imageBoxFit: BoxFit.fill,
                            ),
                          ),
                          Container(
                            color: Colors.transparent,
                            height: MediaQuery.of(context).size.height * .56,
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Opacity(
                                    opacity: 0.2,
                                    child: Container(
                                        child: AppLogo(
                                      width: WidgetProperties.screenWidth(
                                              context) *
                                          .6,
                                      height: WidgetProperties.screenWidth(
                                              context) *
                                          .6,
                                    )),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .56,
                                      child: widget.bodyContent),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : CommonDrawerEmployee(
                bottomOverflow: true,
                title: widget.appBarTitle,
                widget: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: ScrollConfiguration(
                    behavior: MyBehavior(),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * .31,
                            width: MediaQuery.of(context).size.width,
                            child: CommonImage(
                              imageUrl: Constants.BENZOL_1_IMAGE,
                              imageWidth: MediaQuery.of(context).size.width,
                              imageBoxFit: BoxFit.fill,
                            ),
                          ),
                          Container(
                            color: Colors.transparent,
                            height: MediaQuery.of(context).size.height * .56,
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Opacity(
                                    opacity: 0.2,
                                    child: Container(
                                        child: AppLogo(
                                      width: WidgetProperties.screenWidth(
                                              context) *
                                          .6,
                                      height: WidgetProperties.screenWidth(
                                              context) *
                                          .6,
                                    )),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .56,
                                      child: widget.bodyContent),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
  }

  getBool() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      admin = prefs.getBool('admin');
      manager = prefs.getBool('manager');
      employee = prefs.getBool('employee');
    });
  }
}
