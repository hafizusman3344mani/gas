import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gas_station/common/common_screen.dart';
import 'package:gas_station/common/custominput.dart';
import 'package:gas_station/common/text_view.dart';
import 'package:gas_station/controllers/notification_controller.dart';
import 'package:gas_station/db/db_service.dart';
import 'package:gas_station/employee/employee_dashboard.dart';
import 'package:gas_station/generated/l10n.dart';
import 'package:gas_station/models/notification_model.dart';
import 'package:gas_station/models/user/user_model.dart';
import 'package:gas_station/utils/colors.dart';
import 'package:gas_station/utils/my_behaviour.dart';
import 'package:gas_station/utils/route_singleton.dart';
import 'package:gas_station/utils/widgetproperties.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EmployeeNotificationScreen extends StatefulWidget {
  @override
  _EmployeeNotificationScreenState createState() =>
      _EmployeeNotificationScreenState();
}

class _EmployeeNotificationScreenState
    extends State<EmployeeNotificationScreen> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  UserModel managerModel;
  UserModel adminModel;
  UserModel userModel;
  String fcmToken = '';
  String empAddress = '';

  var userSearchMobileTextController = TextEditingController();
  String searchKey = '';
  CollectionReference ref;
  bool admin = false;
  bool manager = false;
  bool employee = false;
  var notificationController = Get.put(NotificationController());

  var searchNode = FocusNode();
  RemoteMessage _notification;
  int _messageCount = 0;
  var _textFormFieldDecoration = BoxDecoration(
      color: AppColors.textWhiteColor,
      border: Border.all(width: 1.5, color: AppColors.primaryColor),
      shape: BoxShape.rectangle);

  var _listDecoration = BoxDecoration(
      color: AppColors.textWhiteColor,
      borderRadius: BorderRadius.circular(12.0),
      border: Border.all(width: 1.5, color: AppColors.primaryColor),
      shape: BoxShape.rectangle);

  String token = '';

  String empName = '';

  @override
  void initState() {
    getBool();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        WidgetProperties.goToNextPageWithReplacement(
            context, EmployeeDashboard());
        return false;
      },
      child: CommonScreen(
        appBarTitle: S.of(context).notifications_text,
        bodyContent: GetBuilder<NotificationController>(
          init: notificationController,
          initState: (child) {
            ref = FirebaseFirestore.instance.collection("notifications");
          },
          builder: (_) {
            return ScrollConfiguration(
              behavior: MyBehavior(),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      Container(
                        width: 140.0,
                        height: 30.0,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 15, right: 15, top: 20),
                        child: Form(
                          child: Column(
                            children: [
                              Container(
                                decoration: _textFormFieldDecoration,
                                child: FormInput(
                                  icon: Icons.search,
                                  textInputType: TextInputType.number,
                                  // errorText:
                                  // userController.validityPhoneNumber.message,
                                  hint: 'Search...',
                                  hintColor: AppColors.commoneadingtextColor,
                                  onSaved: (String value) {
                                    // userController.checkPhoneNumber(value);
                                    // userController.updateUserBuilder();
                                  },
                                  onChanged: (value) {
                                    setState(() {
                                      searchKey = value
                                          .toString()
                                          .trim()
                                          .replaceAll(' ', '')
                                          .toLowerCase();
                                    });
                                  },
                                  formatter: FilteringTextInputFormatter.allow(
                                    RegExp("[A-Z a-z _ . @ 0-9]"),
                                  ),
                                  obsecureText: false,
                                  maxLength: 50,
                                  //myController: userMobileNumberController,
                                  //focusNode: ,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      searchKey.isNotEmpty
                          ? Container(
                              height: MediaQuery.of(context).size.height * .4,
                              child: StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('notifications')
                                      .where('searchString',
                                          isGreaterThanOrEqualTo:
                                              searchKey.trim().toLowerCase())
                                      .where('searchString',
                                          isLessThan: searchKey + 'z')
                                      .snapshots(),
                                  builder: (context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (!snapshot.hasData) {
                                      return Text('no data');
                                    } else {
                                      return ListView.builder(
                                        itemCount: snapshot.data.docs.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          NotificationModel notification =
                                              NotificationModel.fromMap(snapshot
                                                  .data.docs[index]
                                                  .data());
                                          var documentId =
                                              snapshot.data.docs[index].id;
                                          print(snapshot.data.docs.length);
                                          return listWidget(context, index,
                                              notification, documentId);
                                        },
                                      );
                                    }
                                  }),
                            )
                          : Container(
                              height: 270.0,
                              margin: EdgeInsets.only(
                                  top: 20.0,
                                  left: 15.0,
                                  right: 15.0,
                                  bottom: 20.0),
                              alignment: Alignment.center,
                              decoration: _listDecoration,
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 4.0),
                                    child: Textview2(
                                      title:
                                          S.of(context).notification_list_text,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                  Flexible(
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              3,
                                      child: StreamBuilder<QuerySnapshot>(
                                          stream: ref
                                              .where('address',
                                                  isEqualTo: empAddress)
                                              .snapshots(),
                                          builder: (context,
                                              AsyncSnapshot<QuerySnapshot>
                                                  snapshot) {
                                            if (!snapshot.hasData) {
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            } else if (snapshot
                                                    .data.docs.length ==
                                                0) {
                                              return Center(
                                                child: Textview2(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15.0,
                                                  title:
                                                      "No Notification  Found",
                                                ),
                                              );
                                            } else {
                                              return ListView.builder(
                                                physics:
                                                    BouncingScrollPhysics(),
                                                itemCount:
                                                    snapshot.data.docs.length,
                                                shrinkWrap: false,
                                                itemBuilder: (context, index) {
                                                  // userController.employeeCount =
                                                  //     snapshot.data.docs.length;
                                                  var documentId = snapshot
                                                      .data.docs[index].id;
                                                  print(documentId);
                                                  NotificationModel userModel =
                                                      NotificationModel.fromMap(
                                                          snapshot
                                                              .data.docs[index]
                                                              .data());

                                                  return listWidget(
                                                      context,
                                                      index,
                                                      userModel,
                                                      documentId);
                                                },
                                              );
                                            }
                                          }),
                                    ),
                                  )
                                ],
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget listWidget(BuildContext buildContext, int index,
      NotificationModel notificationModel, String documentId) {
    return GestureDetector(
      onTap: () async {
        sendPushMessage(token, notificationModel);
      },
      child: Container(
        margin: EdgeInsets.all(10.0),
        child: Material(
            elevation: 4.0,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            child: Container(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.notifications,
                          size: 30.0,
                          color: AppColors.listColor,
                        ),
                        Textview2(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          title: notificationModel.name,
                          color: AppColors.listColor,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }

  Future<void> sendPushMessage(
      String _token, NotificationModel notificationModel) async {
    // String _token = 'fNIdm69wR1-FJGB0xNpZ57:APA91bGBHGZjNHHPVMdEUWtNmKP9d6n2AxEBbJxXV_udXLXm8IQ469ksLqJcq9J4BseAfydYQf-QV3-vDa1jydDwdBJHO1YpB3rTlJ7XkflTx33uwCkCXjB2wJD6DQHRP3mq5O6mg_ZB';
    if (_token == null) {
      WidgetProperties.showToast(
          S.of(context).notification_not_sent_text, Colors.white, Colors.red);
      return;
    }

    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=' + RouteSingleton.instance.serverKey,
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': notificationModel.name ?? '',
              'title': 'Notification !' ?? '',
              'icon': '@mipmap/ic_launcher'
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'id': '1',
              'status': 'done',
            },
            'to': _token,
          },
        ),
      );

      addPushNotification(notificationModel);
    } catch (e) {
      WidgetProperties.showToast(
          S.of(context).something_wrong, Colors.white, Colors.red);
    }
  }

  getBool() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String phone = prefs.getString('phoneNumber');
    String branchId = prefs.getString('branchId');
    await FirebaseFirestore.instance
        .collection('managers')
        .where('branchId', isEqualTo: branchId)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        managerModel = UserModel.fromMap(value.docs.first.data());
        setState(() {
          token = managerModel.fcmToken;
        });
      }
    });
    await FirebaseFirestore.instance
        .collection('employees')
        .where('phone', isEqualTo: phone)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        userModel = UserModel.fromMap(value.docs.single.data());
        setState(() {
          empAddress = userModel.address;
          empName = userModel.firstName + ' ' + userModel.lastName;
        }); //if it is a single document
      }
    });
  }

  void addPushNotification(NotificationModel notificationModel) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    NotificationModel pushNotificationModel = NotificationModel();
    pushNotificationModel.id = notificationModel.id;
    pushNotificationModel.createdAt = DateTime.now().toString();
    pushNotificationModel.senderId = notificationModel.senderId;
    pushNotificationModel.receiverId = prefs.getString('phoneNumber');
    pushNotificationModel.sendDate = DateTime.now().toString();
    pushNotificationModel.createdBy = [notificationModel.senderId];
    pushNotificationModel.name = notificationModel.name;
    pushNotificationModel.address = notificationModel.address;
    pushNotificationModel.searchString = notificationModel.searchString;
    FireStoreService()
        .addNotification(pushNotificationModel, "pushnotifications")
        .then((value) {
      WidgetProperties.showToast(
          S.of(context).notification_sent, Colors.white, Colors.green);
    });
  }
}
