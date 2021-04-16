import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gas_station/common/app_logo.dart';
import 'package:gas_station/common/custom_button.dart';
import 'package:gas_station/common/custominput.dart';
import 'package:gas_station/common/text_view.dart';
import 'package:gas_station/controllers/user_controller.dart';
import 'package:gas_station/generated/l10n.dart';
import 'package:gas_station/models/user/user_model.dart';
import 'package:gas_station/utils/colors.dart';
import 'package:gas_station/utils/my_behaviour.dart';
import 'package:gas_station/utils/widgetproperties.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'otp_screen.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  var userController = Get.put(UserController());

  var userMobileNumberController = TextEditingController();

  var userModel = UserModel();

  String verifyId;
  String countryCode = '+92';

  var mnNode = FocusNode();
  FirebaseAuth _auth = FirebaseAuth.instance;
  var _selectedSubjectDecoration = BoxDecoration(
      color: AppColors.textWhiteColor,
      border: Border.all(width: 1.0, color: AppColors.primaryColor),
      shape: BoxShape.rectangle);

  bool admin = false;
  bool manager = false;
  bool employee = false;

  String _verificationId;

  var _phoneAuthCredential;

  int _code;

  var phone;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Textview2(
            title: "Sign in",
          ),
        ),
        backgroundColor: Colors.white,
        body: GetBuilder<UserController>(
          init: userController,
          initState: (child) {},
          builder: (_) {
            return ScrollConfiguration(
              behavior: MyBehavior(),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Hero(
                          tag: 'logo',
                          child: AppLogo(
                              width: WidgetProperties.screenWidth(context) * .5,
                              height: WidgetProperties.screenHeight(context) *
                                  .25)),
                      Form(
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.only(top: 85.0),
                              child: CountryListPick(
                                appBar: AppBar(
                                  backgroundColor: AppColors.primaryColor,
                                  title: Text('Pick your country'),
                                ),
                                theme: CountryTheme(
                                  isShowFlag: true,
                                  isShowTitle: true,
                                  isShowCode: true,
                                  isDownIcon: true,
                                  showEnglishName: false,
                                ),
                                initialSelection: '+92',
                                // or
                                // initialSelection: 'US'
                                onChanged: (CountryCode code) {
                                  setState(() {
                                    countryCode = code.dialCode;
                                  });
                                },
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10.0),
                              decoration: _selectedSubjectDecoration,
                              child: FormInput(
                                textInputType: TextInputType.number,
                                errorText:
                                    userController.validityPhoneNumber.message,
                                hint: '1234567890',
                                hintColor: AppColors.commoneadingtextColor,
                                onSaved: (value) {
                                  userController.checkPhoneNumber(value);
                                  userController.updateUserBuilder();
                                },
                                formatter: FilteringTextInputFormatter.allow(
                                  RegExp("[0-9 +]"),
                                ),
                                obsecureText: false,
                                maxLength: 50,
                                myController: userMobileNumberController,
                                focusNode: mnNode,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 25.0),
                              child: HeroButton(
                                width: WidgetProperties.screenWidth(context),
                                height: 50.0,
                                radius: 27.0,
                                gradient: AppColors.primaryColor,
                                title: S.of(context).signin_btn_text,
                                onPressed: () {
                                  checkPhoneNumber(context);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ));
  }

  Future<void> checkPhoneNumber(BuildContext buildContext) async {
    userModel.phone = userMobileNumberController.text;
    userController.phoneNumber = userMobileNumberController.text;
    WidgetProperties.showLoader();
    var adminSnapShot =
        await FirebaseFirestore.instance.collection('admin').get();
    var employeeSnapShot =
        await FirebaseFirestore.instance.collection('employees').get();
    var managerSnapShot =
        await FirebaseFirestore.instance.collection('managers').get();
    if (userController.checkPhoneNumberValidation(userModel)) {
      int adminCount = adminSnapShot.docs
          .where((element) =>
              element.get('phone').toString() ==
              countryCode + userMobileNumberController.text.trim())
          .toList()
          .length;
      int empCount = employeeSnapShot.docs
          .where((element) =>
              element.get('phone').toString() ==
              countryCode + userMobileNumberController.text.trim())
          .toList()
          .length;
      int managerCout = managerSnapShot.docs
          .where((element) =>
              element.get('phone').toString().trim() ==
              countryCode + userMobileNumberController.text.trim())
          .toList()
          .length;
      if (empCount != 0) {
        _submitPhoneNumber();
      } else if (managerCout != 0) {
        _submitPhoneNumber();
        // loginUser(
        //   countryCode + userMobileNumberController.text.trim(),
        //   buildContext,
        // );
      } else if (adminCount != 0) {
        _submitPhoneNumber();
      }
      else{
        WidgetProperties.closeLoader();
        WidgetProperties.showToast(
            S.of(context).number_not_exist, Colors.white, Colors.red);

      }
    } else {
      WidgetProperties.closeLoader();
      userController.updateUserBuilder();
    }
  }


  getBool() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      admin = prefs.getBool('admin');
      manager = prefs.getBool('manager');
      employee = prefs.getBool('employee');
    });
  }
  Future<void> _submitPhoneNumber() async {
    /// NOTE: Either append your phone number country code or add in the code itself
    /// Since I'm in India we use "+91 " as prefix `phoneNumber`
     phone =  countryCode + userMobileNumberController.text.trim();
    print(phone);

    /// The below functions are the callbacks, separated so as to make code more redable
    void verificationCompleted(AuthCredential phoneAuthCredential)async {

      UserCredential result =
          await _auth.signInWithCredential(phoneAuthCredential);

      User user = result.user;

      WidgetProperties.closeLoader();
      if (user != null) {
        WidgetProperties.goToNextPage(context,
            OtpScreen(verifyId: verifyId, phoneNumber: phone));
      } else {
        print("Error");
      }
    }

    void verificationFailed(FirebaseAuthException exception) {
      if (exception.code == "too-many-requests") {
        WidgetProperties.showToast(
            S.of(context).too_many_attempts, Colors.white, Colors.red);
      } else if (exception.code == "invalid-phone-number") {
        WidgetProperties.showToast(
            S.of(context).invalid_phone,
            Colors.white,
            Colors.red);
      }
      print(exception);
      WidgetProperties.closeLoader();
      
    }

    void codeSent(String verificationId, [int code]) {
      setState(() {
        verifyId = verificationId;
      });
      WidgetProperties.goToNextPageWithReplacement(
          context,
          OtpScreen(
            verifyId: verifyId,
            phoneNumber: phone,
          ));

    }

    void codeAutoRetrievalTimeout(String verificationId) {
      print('codeAutoRetrievalTimeout');

      print(verificationId);
    }

    await FirebaseAuth.instance.verifyPhoneNumber(
      /// Make sure to prefix with your country code
      phoneNumber: phone,

      /// `seconds` didn't work. The underlying implementation code only reads in `millisenconds`
      timeout: Duration(seconds: 60),

      /// If the SIM (with phoneNumber) is in the current device this function is called.
      /// This function gives `AuthCredential`. Moreover `login` function can be called from this callback
      /// When this function is called there is no need to enter the OTP, you can click on Login button to sigin directly as the device is now verified
      verificationCompleted: verificationCompleted,

      /// Called when the verification is failed
      verificationFailed: verificationFailed,

      /// This is called after the OTP is sent. Gives a `verificationId` and `code`
      codeSent: codeSent,

      /// After automatic code retrival `tmeout` this function is called
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    ); // All the callbacks are above
  }

  void _submitOTP() {
    /// get the `smsCode` from the user
    //String smsCode = _otpController.text.toString().trim();

    /// when used different phoneNumber other than the current (running) device
    /// we need to use OTP to get `phoneAuthCredential` which is inturn used to signIn/login
    this._phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: this._verificationId, smsCode: '');

// _login();
  }

}
