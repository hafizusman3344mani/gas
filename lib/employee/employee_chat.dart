import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:gas_station/common/chat.dart';
import 'package:gas_station/common/common_image.dart';
import 'package:gas_station/common/constants.dart';
import 'package:gas_station/common/custom_button.dart';
import 'package:gas_station/common/text_view.dart';
import 'package:gas_station/employee/employee_dashboard.dart';
import 'package:gas_station/employee/employee_notifications.dart';
import 'package:gas_station/generated/l10n.dart';
import 'package:gas_station/main.dart';
import 'package:gas_station/manager/manager_chat_screen.dart';

import 'package:gas_station/models/user/user_model.dart';
import 'package:gas_station/screens/authentication/signin_screen.dart';
import 'package:gas_station/utils/colors.dart';
import 'package:gas_station/utils/route_singleton.dart';
import 'package:gas_station/utils/widgetproperties.dart';
import 'package:get/get.dart';

import 'package:loading/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';


class EmployeeChatScreen extends StatefulWidget {
  @override
  State createState() => EmployeeChatScreenState();
}

class EmployeeChatScreenState extends State<EmployeeChatScreen> {
  CollectionReference ref;
  String currentUserId;
  UserModel employeeModel;
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  UserModel userModel;
  // int _limit = 2;
  // int _limitIncrement = 2;
  bool isLoading = false;

  var address = "";

  bool employee = false;

  @override
  void initState() {
    getNumber();
    getUserData();
    super.initState();
    ref = FirebaseFirestore.instance.collection('managers');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          S.of(context).chat,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: WillPopScope(
        onWillPop: () async {
          WidgetProperties.goToNextPageWithReplacement(
              context, EmployeeDashboard());
          return false;
        },
        child: Stack(
          children: <Widget>[
            // List
            Container(
              child: StreamBuilder<QuerySnapshot>(
                  stream:
                      ref.where('address', isEqualTo: address).snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        var documentId = snapshot.data.docs[index].id;
                        // print(id);
                        UserModel userModel =
                            UserModel.fromMap(snapshot.data.docs[index].data());

                        return buildItem(context, userModel, documentId);
                      },
                    );
                  }),
            ),

            // Loading
            Positioned(
              child: isLoading ? Loading() : Container(),
            )
          ],
        ),
      ),
    );
  }

  Widget buildItem(
      BuildContext context, UserModel userModel, String documentId) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.primaryColor,
        child: ListTile(
          title: Textview2(
            title: '${userModel.firstName ?? 'Not available'}',
            fontSize: 25,
            color: Colors.white,
          ),
          subtitle: Textview2(
            title: '${userModel.branchName} ${userModel.cityName}',
            color: Colors.grey,
          ),
          onTap: () {
            WidgetProperties.goToNextPage(
                context,
                Chat(
                  userModel: userModel,
                  peerId: documentId,
                  type: 'employee',
                ));
          },
        ),
      ),
    );
  }

  getNumber() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String phone = '';
    setState(() {
      employee = preferences.getBool('employee');
      phone = preferences.getString("phoneNumber");
    });

    await FirebaseFirestore.instance
        .collection('employees')
        .where('phone', isEqualTo: phone)
        .get()
        .then((event) {
      if (event.docs.isNotEmpty) {
        employeeModel = UserModel.fromMap(
            event.docs.single.data()); //if it is a single document
        setState(() {
          address = employeeModel.address;
        });
      }
    }).catchError((e) => print("error fetching data: $e"));
    setState(() {
      currentUserId = preferences.getString('currentUserId');
    });
  }

  getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String phone = sharedPreferences.getString('phoneNumber');
    String address = sharedPreferences.getString('address');
    await FirebaseFirestore.instance
        .collection('employees')
        .where('phone', isEqualTo: phone)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        userModel = UserModel.fromMap(value.docs.single.data());
        address = userModel.address;
        setState(() {

        }); //if it is a single document
      }
    });
  }
}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}
