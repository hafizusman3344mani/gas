import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:gas_station/common/common_image.dart';
import 'package:gas_station/common/constants.dart';
import 'package:gas_station/common/custom_button.dart';
import 'package:gas_station/common/custominput3.dart';
import 'package:gas_station/common/text_view.dart';
import 'package:gas_station/controllers/user_controller.dart';
import 'package:gas_station/db/db_service.dart';
import 'package:gas_station/employee/employee_dashboard.dart';
import 'package:gas_station/generated/l10n.dart';
import 'package:gas_station/manager/manager_dashboard.dart';
import 'package:gas_station/models/user/user_model.dart';
import 'package:gas_station/screens/dashboard/dashboard.dart';
import 'package:gas_station/utils/colors.dart';
import 'package:gas_station/utils/my_behaviour.dart';
import 'package:gas_station/utils/widgetproperties.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpScreen extends StatefulWidget {
  final String verifyId;
  final String phoneNumber;

  OtpScreen({this.verifyId, this.phoneNumber});

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  var userController = Get.find<UserController>();

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String fcmToken = "";

  var userOtpCodeController = TextEditingController();
  bool isResendEnabled = false;
  SharedPreferences prefs;

  var otpNode = FocusNode();

  var userModel = UserModel();

  var _selectedSubjectDecoration = BoxDecoration(
      color: AppColors.dropdownBackgroundColor,
      border: Border.all(width: 0.5, color: Colors.black),
      shape: BoxShape.rectangle);

  String role = '';

  String verificationId;

  @override
  void initState() {
    verificationId = widget.verifyId;

    getFcm();
    Future.delayed(Duration.zero, () {
      resendTimeOut();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Textview2(
          title: 'OTP Verification',
        ),
        backgroundColor: AppColors.primaryColor,
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: GetBuilder<UserController>(
        initState: (child) async {
          prefs = await SharedPreferences.getInstance();
        },
        builder: (_) {
          return Form(
            autovalidateMode: AutovalidateMode.disabled,
            child: ScrollConfiguration(
              behavior: MyBehavior(),
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      CommonImage(
                        imageUrl: Constants.OTP_ICON,
                        imageWidth: WidgetProperties.screenWidth(context) * .5,
                        imageHeight:
                            WidgetProperties.screenHeight(context) * .25,
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 50.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Textview2(
                                title: S.of(context).enter_code_text,
                                fontSize: 15.0,
                                color: AppColors.enterCodeColor,
                                fontWeight: FontWeight.bold,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                padding: EdgeInsets.all(5.0),
                                child: Textview2(
                                  title: userController.phoneNumber != null
                                      ? userController.phoneNumber
                                      : "+966 00001111",
                                  fontSize: 15.0,
                                  color: AppColors.mobileNumberlineColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          )),
                      Container(
                        margin: EdgeInsets.only(top: 20.0),
                        child: FormInput3(
                          textInputType: TextInputType.number,
                          errorText: userController.validityOtpCode.message,
                          hintColor: AppColors.commoneadingtextColor,
                          onSaved: (String value) {
                            userController.checkOtpCode(value);
                            userController.updateUserBuilder();
                          },
                          formatter: FilteringTextInputFormatter.allow(
                            RegExp("[0-9]"),
                          ),
                          obsecureText: false,
                          maxLength: 50,
                          myController: userOtpCodeController,
                          focusNode: otpNode,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 25.0),
                        child: HeroButton(
                          width: WidgetProperties.screenWidth(context),
                          height: 50.0,
                          radius: 27.0,
                          gradient: AppColors.primaryColor,
                          title: S.of(context).verify_btn_text,
                          onPressed: () {
                            checkOtpCode(context);
                          },
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Textview2(
                                title: S.of(context).dont_receive_text,
                                fontSize: 15.0,
                                color: isResendEnabled
                                    ? AppColors.enterCodeColor
                                    : Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (isResendEnabled) {
                                    FirebaseAuth _auth = FirebaseAuth.instance;
                                    WidgetProperties.showLoader();
                                    _auth.verifyPhoneNumber(
                                        phoneNumber: widget.phoneNumber,
                                        timeout: Duration(seconds: 60),
                                        verificationCompleted:
                                            (PhoneAuthCredential
                                                credential) async {
                                          UserCredential result = await _auth
                                              .signInWithCredential(credential);

                                          WidgetProperties.closeLoader();
                                        },
                                        verificationFailed:
                                            (FirebaseAuthException exception) {
                                          WidgetProperties.closeLoader();
                                          resendTimeOut();
                                          if (exception.code ==
                                              "too-many-requests") {
                                            WidgetProperties.showToast(
                                                S.of(context).too_many_attempts,
                                                Colors.white,
                                                Colors.red);
                                          } else if (exception.code ==
                                              "invalid-phone-number") {
                                            WidgetProperties.showToast(
                                                S.of(context).invalid_phone,
                                                Colors.white,
                                                Colors.red);
                                          }
                                        },
                                        codeSent: (String verificationId,
                                            [int forceResendingToken]) {
                                          WidgetProperties.closeLoader();
                                          resendTimeOut();
                                          setState(() {
                                            verificationId = verificationId;
                                          });
                                        },
                                        codeAutoRetrievalTimeout:
                                            (String id) {});
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.all(5.0),
                                  child: Textview2(
                                    title: S.of(context).resend_text,
                                    fontSize: 15.0,
                                    color: isResendEnabled
                                        ? AppColors.mobileNumberlineColor
                                        : Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            ],
                          )),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> checkOtpCode(BuildContext buildContext) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    userModel.otpCode = userOtpCodeController.text;

    if (userController.checkOtpCodeValidation(userModel)) {
      WidgetProperties.showLoader();
      AuthCredential authCredential = PhoneAuthProvider.credential(
          verificationId: widget.verifyId, smsCode: userOtpCodeController.text);
      UserCredential userCredential =
          await _auth.signInWithCredential(authCredential).then((value) {
        User user = value.user;
        if (user != null) {
          userModel.phone = userController.phoneNumber;
          FireStoreService().addUserPhoneAuthentication(userModel, "users");
          // DBValues.instance.setUserValue(true);
          getData(widget.phoneNumber);
        } else {
          WidgetProperties.closeLoader();
          WidgetProperties.showToast(
              S.of(context).error, Colors.white, Colors.red);
        }
      }).catchError((error) {
        WidgetProperties.closeLoader();
        WidgetProperties.showToast(
            S.of(context).valid_otp, Colors.white, Colors.red);
      });
    } else {
      userController.updateUserBuilder();
    }
  }

  resendTimeOut() {
    isResendEnabled = false;

    Timer(
        Duration(
          seconds: 61,
        ), () {
      isResendEnabled = true;
    });
    setState(() {});
  }

  getData(String phoneNumber) async {
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
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (empCount != 0) {
      await FirebaseFirestore.instance
          .collection('employees')
          .where('phone', isEqualTo: widget.phoneNumber)
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          userModel = UserModel.fromMap(value.docs.first.data());
          FirebaseFirestore.instance
              .collection('employees')
              .doc(userModel.id)
              .update({
            'fcmToken': fcmToken,
            // 'id':userModel.id,
            // 'phone':userModel.phone
          });
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
        prefs.setString("phoneNumber", widget.phoneNumber);
      });
    } else if (managerCout != 0) {
      await FirebaseFirestore.instance
          .collection('managers')
          .where('phone', isEqualTo: widget.phoneNumber)
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          userModel = UserModel.fromMap(value.docs.first.data());
          FirebaseFirestore.instance
              .collection('managers')
              .doc(userModel.id)
              .update({
            'fcmToken': fcmToken,
            // 'id':userModel.id,
            // 'phone':userModel.phone
          });
        }
      });
      setState(() {
        role = 'manager';
        prefs.setString('currentUserId', userModel.id);
        prefs.setBool('manager', true);
        prefs.setBool('employee', false);
        prefs.setString('fcmToken', fcmToken);
        prefs.setBool('admin', false);
        prefs.setBool('boolValue', true);
        prefs.setString("phoneNumber", widget.phoneNumber);
      });
    } else if (adminCount != 0) {
      await FirebaseFirestore.instance
          .collection('admin')
          .where('phone', isEqualTo: widget.phoneNumber)
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          userModel = UserModel.fromMap(value.docs.first.data());
          FirebaseFirestore.instance
              .collection('admin')
              .doc(userModel.id)
              .update({
            'fcmToken': fcmToken,
            // 'id':userModel.id,
            // 'phone':userModel.phone
          });
        }
      });
      mounted
          ? setState(() {
              role = 'admin';
              prefs.setBool('admin', true);
              prefs.setString('fcmToken', fcmToken);
              prefs.setBool('manager', false);
              prefs.setBool('employee', false);
              prefs.setBool('boolValue', true);
              prefs.setString("phoneNumber", widget.phoneNumber);
            })
          : '';
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

  getFcm() async {
    var _firebaseMessaging = FirebaseMessaging.instance;
    fcmToken = await _firebaseMessaging.getToken();
    print(fcmToken);
  }
}
