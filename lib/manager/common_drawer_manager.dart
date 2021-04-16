import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth_ui/firebase_auth_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gas_station/common/common_image.dart';
import 'package:gas_station/common/constants.dart';
import 'package:gas_station/common/custom_button.dart';
import 'package:gas_station/common/text_view.dart';
import 'package:gas_station/generated/l10n.dart';
import 'package:gas_station/main.dart';
import 'package:gas_station/manager/manager_chat_screen.dart';
import 'package:gas_station/manager/all_notifications.dart';
import 'package:gas_station/manager/manager_dashboard.dart';
import 'package:gas_station/models/user/user_model.dart';
import 'package:gas_station/screens/authentication/signin_screen.dart';
import 'package:gas_station/screens/employee/employee_screen.dart';
import 'package:gas_station/manager/manager_notifications.dart';
import 'package:gas_station/utils/colors.dart';
import 'package:gas_station/utils/route_singleton.dart';
import 'package:gas_station/utils/widgetproperties.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommonDrawerManager extends StatefulWidget {
  final Widget widget;
  final String title;
  final bool bottomOverflow;

  CommonDrawerManager({this.widget, this.title, this.bottomOverflow});

  @override
  _CommonDrawerManagerState createState() => _CommonDrawerManagerState();
}

class _CommonDrawerManagerState extends State<CommonDrawerManager> {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
UserModel userModel;
@override
  void initState() {
    getUserData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: widget.bottomOverflow,
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.notifications_none,
              color: Colors.white,
            ),
            onPressed: () {
             WidgetProperties.goToNextPage(context, AllNotifications());
            },
          )
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
                  title: userModel!=null? "${userModel.firstName} ${userModel.lastName}":'',
                  color: AppColors.primaryColor,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 13.0),
                alignment: Alignment.centerLeft,
                child: Textview2(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  title:userModel!=null? "${userModel.branchName} ${userModel.cityName}":'',
                  color: AppColors.primaryColor,
                ),
              ),
              ListTile(
                  onTap: () {

                    WidgetProperties.goToNextPageWithReplacement(
                        context, ManagerDashboard());
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
                      context, ManagerChatScreen());
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
                  WidgetProperties.pop(context);
                  WidgetProperties.goToNextPage(
                      context, ManagerNotificationScreen());
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
                      await MyApp.setLocale(context, Locale('ar','AE'))
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
                  showDialog(context);
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

  Future<void> showDialog(BuildContext buildContext) {
    showGeneralDialog(
      barrierDismissible: true,
      barrierLabel: "",
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 400),
      context: buildContext,
      pageBuilder: (_, __, ___) {
        return Align(
          alignment: Alignment.center,
          child: Container(
            height: 100,
            child: SizedBox.expand(
                child: Container(
              child: Column(
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
                            gradient: Color(0xff4cae4d),
                            title: S.of(context).yes_btn_text,
                            onPressed: () {
                              logoutFromApplication(buildContext);
                            },
                          ),
                        ),
                        const Divider(
                          color: Colors.grey,
                          thickness: 0.60,
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20.0),
                          child: HeroButton(
                            height: 30.0,
                            width: 120,
                            radius: 32.0,
                            gradient: AppColors.formContinueButtomColor,
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
            )),
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

  Future<void> logoutFromApplication(BuildContext buildContext) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove('boolValue');
    await preferences.remove('manager');
    await preferences.remove('phoneNumber');
    await preferences.remove('currentUserId');
    await preferences.clear();
    WidgetProperties.goToNextPageWithAllReplacement(
        buildContext, SignInScreen());
  }

  getUserData()async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String phone = sharedPreferences.getString('phoneNumber');
    await FirebaseFirestore.instance
        .collection('managers')
        .where('phone', isEqualTo: phone)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        userModel = UserModel.fromMap(
            value.docs.single.data());
        setState(() {

        });//if it is a single document
      }
    });
  }

}
