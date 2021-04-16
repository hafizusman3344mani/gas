import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gas_station/common/common_screen.dart';
import 'package:gas_station/common/custom_button.dart';
import 'package:gas_station/common/custominput.dart';
import 'package:gas_station/common/text_view.dart';
import 'package:gas_station/controllers/notification_controller.dart';
import 'package:gas_station/controllers/user_controller.dart';
import 'package:gas_station/employee/employee_dashboard.dart';
import 'package:gas_station/generated/l10n.dart';
import 'package:gas_station/manager/manager_dashboard.dart';
import 'package:gas_station/models/notification_model.dart';
import 'package:gas_station/models/user/user_model.dart';
import 'package:gas_station/screens/dashboard/dashboard.dart';
import 'package:gas_station/screens/notifications/notification_form.dart';
import 'package:gas_station/utils/colors.dart';
import 'package:gas_station/utils/my_behaviour.dart';
import 'package:gas_station/utils/widgetproperties.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  UserModel managerModel;
  UserModel adminModel;
  String adminPhone = '';
  String managerPhone = '';
  String token;

  var userSearchMobileTextController = TextEditingController();
  String searchKey = '';
  CollectionReference ref;
  bool admin = false;
  bool manager = false;
  bool employee = false;
  var notificationController = Get.put(NotificationController());

  var searchNode = FocusNode();

  var _textFormFieldDecoration = BoxDecoration(
      color: AppColors.textWhiteColor,
      border: Border.all(width: 1.5, color: AppColors.primaryColor),
      shape: BoxShape.rectangle);

  var _listDecoration = BoxDecoration(
      color: AppColors.textWhiteColor,
      borderRadius: BorderRadius.circular(12.0),
      border: Border.all(width: 1.5, color: AppColors.primaryColor),
      shape: BoxShape.rectangle);

  @override
  void initState() {
    getBool();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
          WidgetProperties.goToNextPageWithReplacement(context, Dashboard());
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
                        margin: EdgeInsets.only(top: 10.0),
                        child: HeroButton(
                          width: 140.0,
                          height: 30.0,
                          radius: 6.0,
                          gradient: AppColors.primaryColor,
                          title: S.of(context).create_new_notification_text,
                          onPressed: () {
                            WidgetProperties.goToNextPage(
                                context, NotificationForm());
                          },
                        ),
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
                                          isGreaterThanOrEqualTo: searchKey)
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
                                          stream: ref.snapshots(),
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
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(buildContext).push(
                                MaterialPageRoute(builder: (buildContext) {
                              return NotificationForm(
                                notificationModel: notificationModel,
                                documentId: documentId,
                              );
                            }));
                          },
                          child: Text(S.of(buildContext).edit_btn_text),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.lightBlueAccent, // background
                            onPrimary: Colors.white,
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red, // background
                            onPrimary: Colors.white,
                          ),
                          onPressed: () {
                           showDialog(buildContext, documentId);
                          },
                          child: Text(S.of(buildContext).delete_btn_text),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }

  getBool() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String branchId = prefs.getString('branchId');
    var document = await FirebaseFirestore.instance
        .collection('managers')
        .where('branchId', isEqualTo: branchId)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        managerModel = UserModel.fromMap(value.docs.first.data());
      }
    });
    await FirebaseFirestore.instance.collection('admin').get().then((value) {
      if (value.docs.isNotEmpty) {
        adminModel = UserModel.fromMap(value.docs.first.data());
      }
    });
    setState(() {
      adminPhone = adminModel.phone;
      managerPhone = managerModel.phone;
      admin = prefs.getBool('admin');
      manager = prefs.getBool('manager');
      employee = prefs.getBool('employee');
    });
  }
  Future<void> showDialog(BuildContext buildContext,String documentId) {
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
                      SizedBox(
                        height: 10,
                      ),
                      Textview2(
                        title: S.of(context).want_to_delete,
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
                                  ref.doc(documentId).delete().then((value) {
                                    WidgetProperties.showToast(
                                        S.of(buildContext).delete_success,
                                        Colors.white,
                                        Colors.red);
                                    WidgetProperties.pop(buildContext);
                                  });
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
}
