import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gas_station/common/models/validity_model.dart';
import 'package:gas_station/db/db_service.dart';
import 'package:gas_station/models/branch_model.dart';
import 'package:gas_station/models/user/user_model.dart';
import 'package:gas_station/models/user/user_validation.dart';
import 'package:gas_station/utils/widgetproperties.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  FireStoreService fireStoreService = FireStoreService();
  String verificationId;
  String phoneNumber;

  List<BranchModel> branchList;
  int employeeCount;
  BranchModel selectedBranch;

  AsyncSnapshot<QuerySnapshot> snapshot;

  var validityPhoneNumber = ValidityModel();
  var validityPassword = ValidityModel();
  var validityAddress = ValidityModel();
  var validityFirstName = ValidityModel();
  var validityLastName = ValidityModel();
  var validityOtpCode = ValidityModel();
  var validityEmployeeNumber = ValidityModel();
  var validityManagerNumber = ValidityModel();

  Future<void> upDateBranch(BranchModel branchModel) {
    this.selectedBranch = branchModel;
    update();
  }

  bool checkPhoneNumberValidation(UserModel userModel) {
    validityPhoneNumber = UserValidation.validatePhone(userModel.phone);
    if (validityPhoneNumber.valid) {
      return true;
    } else
      return false;
  }

  bool checkEmployeeFormValidation(UserModel userModel) {
    validityFirstName = UserValidation.validateFirstName(userModel.firstName);
    validityLastName = UserValidation.validateLastName(userModel.lastName);
    validityPhoneNumber = UserValidation.validatePhone(userModel.phone);
    validityEmployeeNumber =
        UserValidation.validateEmployeeNumber(userModel.employeeNumber);
    if (validityFirstName.valid &&
        validityLastName.valid &&
        validityPhoneNumber.valid &&
        validityEmployeeNumber.valid) {
      return true;
    } else
      return false;
  }

  bool checkManagerFormValidation(UserModel userModel) {
    validityFirstName = UserValidation.validateFirstName(userModel.firstName);
    validityLastName = UserValidation.validateLastName(userModel.lastName);
    validityPhoneNumber = UserValidation.validatePhone(userModel.phone);
    validityManagerNumber =
        UserValidation.validateManagerNumber(userModel.managerNumber);

    if (validityFirstName.valid &&
        validityLastName.valid &&
        validityPhoneNumber.valid &&
        validityManagerNumber.valid) {
      return true;
    } else
      return false;
  }

  bool checkOtpCodeValidation(UserModel userModel) {
    validityOtpCode = UserValidation.validateOtpCode(userModel.otpCode);
    if (validityOtpCode.valid) {
      return true;
    } else
      return false;
  }

  checkFirstName(String value) {
    validityFirstName = UserValidation.validateFirstName(value);
    // updateUserBuilder();
  }

  Future<void> checkLastName(String value) {
    validityLastName = UserValidation.validateLastName(value);
    // updateUserBuilder();
  }

  Future<void> checkPhoneNumber(String value) {
    validityPhoneNumber = UserValidation.validatePhone(value);
    // updateUserBuilder();
  }

  Future<void> checkEmployeeNumber(String value) {
    validityEmployeeNumber = UserValidation.validateEmployeeNumber(value);
    // updateUserBuilder();
  }

  Future<void> checkManagerNumber(String value) {
    validityManagerNumber = UserValidation.validateEmployeeNumber(value);
    // updateUserBuilder();
  }

  Future<void> checkOtpCode(String value) {
    validityOtpCode = UserValidation.validateOtpCode(value);
    // updateUserBuilder();
  }

  Future<void> updateUserBuilder() {
    update();
  }

  Future<void> addUser(
      UserModel userModel, BuildContext buildContext, String userType) async {
    updateUserBuilder();
    WidgetProperties.closeLoader();
  }

  loadData(String collectionName) {
    FirebaseFirestore.instance.collection(collectionName).snapshots();
    update();
  }

  Future<void> loginUser(
      String phone, BuildContext buildContext, Widget widget) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    WidgetProperties.showLoader();
    _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          UserCredential result = await _auth.signInWithCredential(credential);

          User user = result.user;
          WidgetProperties.closeLoader();
          if (user != null) {
            WidgetProperties.goToNextPageWithReplacement(buildContext, widget);
          } else {
            print("Error");
          }
        },
        verificationFailed: (FirebaseAuthException exception) {
          print(exception);
          WidgetProperties.closeLoader();
        },
        codeSent: (String verificationId, [int forceResendingToken]) {
          print(verificationId + forceResendingToken.toString());
          this.verificationId = verificationId;
          WidgetProperties.goToNextPageWithReplacement(buildContext, widget);
        },
        codeAutoRetrievalTimeout: (String id) {});
  }
}
