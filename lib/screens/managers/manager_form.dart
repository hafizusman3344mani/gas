import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gas_station/common/common_screen.dart';
import 'package:gas_station/common/custom_button.dart';
import 'package:gas_station/common/custominput3.dart';
import 'package:gas_station/common/text_view.dart';
import 'package:gas_station/controllers/user_controller.dart';
import 'package:gas_station/db/db_service.dart';
import 'package:gas_station/generated/l10n.dart';
import 'package:gas_station/models/branch_model.dart';
import 'package:gas_station/models/user/user_model.dart';
import 'package:gas_station/utils/colors.dart';
import 'package:gas_station/utils/widgetproperties.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ManagerForm extends StatefulWidget {
  final UserModel userModel;
  final String documentId;

  ManagerForm({this.userModel, this.documentId});

  @override
  _ManagerFormState createState() => _ManagerFormState();
}

class _ManagerFormState extends State<ManagerForm> {
  String _selectedLocation;

  var userController = UserController();

  var userModel = UserModel();

  var fnNode = FocusNode();

  var lNode = FocusNode();

  var mnNode = FocusNode();

  var mNode = FocusNode();

  var managerFirstNameController = TextEditingController();

  var managerLastNameController = TextEditingController();

  var managerMobileNumberController = TextEditingController();

  var managerNumberController = TextEditingController();

  var _listDecoration = BoxDecoration(
      color: AppColors.textWhiteColor,
      // borderRadius: BorderRadius.circular(12.0),
      border: Border.all(width: 1.5, color: AppColors.primaryColor),
      shape: BoxShape.rectangle);

  String branchId = '';

  @override
  void initState() {
    widget.userModel != null
        ? managerFirstNameController.text = widget.userModel.firstName
        : '';
    widget.userModel != null
        ? managerLastNameController.text = widget.userModel.lastName
        : '';
    widget.userModel != null
        ? managerMobileNumberController.text = widget.userModel.phone
        : '';
    widget.userModel != null
        ? managerNumberController.text = widget.userModel.managerNumber
        : '';
    widget.userModel != null
        ? _selectedLocation = widget.userModel.address
        : null;

    print(widget.userModel != null ? widget.userModel.address : '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CommonScreen(
      appBarTitle: widget.userModel != null
          ? S.of(context).edit_manager_text
          : S.of(context).add_manager_text,
      bodyContent: Container(
        margin:
            EdgeInsets.only(top: 20.0, left: 15.0, right: 15.0, bottom: 10.0),
        alignment: Alignment.center,
        decoration: _listDecoration,
        child: GetBuilder<UserController>(
          id: 'manager',
          init: userController,
          initState: (child) {},
          builder: (_) {
            return Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 4.0),
                  child: Textview2(
                    title: widget.userModel != null
                        ? S.of(context).edit_manager_text
                        : S.of(context).new_manager_text,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
                Flexible(
                  child: Container(
                    // height: MediaQuery.of(context).size.height / 3,
                    child: Form(
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Container(
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 20),
                                child: FormInput3(
                                  textInputType: TextInputType.text,
                                  errorText:
                                      userController.validityFirstName.message,
                                  hint: S.of(context).first_name_text,
                                  hintColor: AppColors.commoneadingtextColor,
                                  onSaved: (String value) {
                                    userController.checkFirstName(value);
                                    userController.updateUserBuilder();
                                  },
                                  formatter: FilteringTextInputFormatter.allow(
                                    RegExp("^[\u0600-\u065F\u066A-\u06EF\u06FA-\u06FFa-zA-Z ]+[\u0600-\u065F\u066A-\u06EF\u06FA-\u06FFa-zA-Z-_ ]*"),
                                  ),
                                  obsecureText: false,
                                  maxLength: 50,
                                  myController: managerFirstNameController,
                                  focusNode: fnNode,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 20.0),
                                child: FormInput3(
                                  textInputType: TextInputType.text,
                                  errorText:
                                      userController.validityLastName.message,
                                  hint: S.of(context).last_name_text,
                                  hintColor: AppColors.commoneadingtextColor,
                                  onSaved: (String value) {
                                    userController.checkLastName(value);
                                    userController.updateUserBuilder();
                                  },
                                  formatter: FilteringTextInputFormatter.allow(
                                    RegExp("^[\u0600-\u065F\u066A-\u06EF\u06FA-\u06FFa-zA-Z ]+[\u0600-\u065F\u066A-\u06EF\u06FA-\u06FFa-zA-Z-_ ]*"),
                                  ),
                                  obsecureText: false,
                                  maxLength: 50,
                                  myController: managerLastNameController,
                                  focusNode: lNode,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 20.0),
                                child: FormInput3(
                                  enabled:  widget.documentId!=null?false:true,
                                  textInputType: TextInputType.phone,
                                  errorText: userController
                                      .validityPhoneNumber.message,
                                  hint: S.of(context).mobile_num_text,
                                  hintColor: AppColors.commoneadingtextColor,
                                  onSaved: (String value) {
                                    userController.checkPhoneNumber(value);
                                    userController.updateUserBuilder();
                                  },
                                  formatter: FilteringTextInputFormatter.allow(
                                    RegExp("[+0-9]"),
                                  ),
                                  obsecureText: false,
                                  maxLength: 50,
                                  myController: managerMobileNumberController,
                                  focusNode: mnNode,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 20.0),
                                child: FormInput3(
                                  enabled:  widget.documentId!=null?false:true,
                                  textInputType: TextInputType.text,
                                  errorText: userController
                                      .validityManagerNumber.message,
                                  hint: S.of(context).manager_num_text,
                                  hintColor: AppColors.commoneadingtextColor,
                                  onSaved: (String value) {
                                    userController.checkManagerNumber(value);
                                    userController.updateUserBuilder();
                                  },
                                  formatter: FilteringTextInputFormatter.allow(
                                    RegExp("[A-Z a-z _ . @ 0-9]"),
                                  ),
                                  obsecureText: false,
                                  maxLength: 50,
                                  myController: managerNumberController,
                                  focusNode: mNode,
                                ),
                              ),
                              StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('branches')
                                      .snapshots(),
                                  builder: (context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (!snapshot.hasData) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else {
                                      return Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        child: DropdownButton<String>(
                                            isExpanded: true,
                                            items: snapshot.data.docs.map(
                                                (DocumentSnapshot document) {
                                              return DropdownMenuItem<String>(
                                                value: document
                                                    .data()['searchString'],
                                                child: Container(
                                                  child: ListTile(
                                                    title: Text(
                                                        '${document.data()['name']}'),
                                                    trailing: Text(
                                                        '${document.data()['branchAddress']}'),
                                                  ),
                                                ),
                                              );
                                              // return document.data()['name'];
                                            }).toList(),
                                            hint: Text(S
                                                .of(context)
                                                .select_branch_text),
                                            value: _selectedLocation,
                                            onChanged: (newVal) {
                                              setState(() {
                                                _selectedLocation = newVal;
                                              });
                                            }),
                                      );
                                      ;
                                    }
                                  }),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.0),
                                child: HeroButton(
                                  width: 140.0,
                                  height: 50.0,
                                  radius: 6.0,
                                  gradient: AppColors.primaryColor,
                                  title: widget.userModel != null
                                      ? S.of(context).Update_manager_text
                                      : S.of(context).add_manager_text,
                                  onPressed: () {
                                    widget.userModel != null
                                        ? updateManager(
                                            context, widget.documentId)
                                        : registerManager(context);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> registerManager(BuildContext buildContext) async {

    userModel.firstName = managerFirstNameController.text;
    userModel.lastName = managerLastNameController.text;
    userModel.phone = managerMobileNumberController.text;
    userModel.managerNumber = managerNumberController.text;
    userModel.address = _selectedLocation;

    if (userController.checkManagerFormValidation(userModel)) {

    BranchModel branchModel;
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('managers').doc();
    var adminSanpshots =
    await FirebaseFirestore.instance.collection('admin').get();
    var managerSanpshots =
    await FirebaseFirestore.instance.collection('managers').get();
    var empSanpshots =
    await FirebaseFirestore.instance.collection('employees').get();
    await FirebaseFirestore.instance
        .collection('branches')
        .where('searchString', isEqualTo: _selectedLocation.toString())
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        branchModel = BranchModel.fromMap(
            value.docs.single.data()); //if it is a single document
      }
    });

    var id = documentReference.id;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String fullName = managerFirstNameController.text
            .replaceAll(' ', '')
            .trim()
            .toLowerCase() +
        managerLastNameController.text.replaceAll(' ', '').trim().toLowerCase();
    String searchString = fullName + _selectedLocation;
    await FirebaseFirestore.instance
        .collection('branches')
        .where('searchString', isEqualTo: _selectedLocation.toString())
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        branchModel = BranchModel.fromMap(
            value.docs.single.data()); //if it is a single document
      }
    });
    userModel.createdBy = sharedPreferences.getString("phoneNumber");
    userModel.createdAt = DateTime.now().toString();
    userModel.cityName = branchModel.branchAddress;
    userModel.branchName = branchModel.name;
    userModel.fcmToken = '';

    userModel.branchId = branchModel.id;

    userModel.roleId = 'manager';
    userModel.searchString = searchString;
    userModel.id = id;

    var docSanpshots =
        await FirebaseFirestore.instance.collection('managers').get();

      int adminCount = adminSanpshots.docs
          .where((element) =>
      element.get('phone').toString().trim().toLowerCase() == managerMobileNumberController.text.toString().trim().toLowerCase())
          .toList()
          .length;
      int managerCount = managerSanpshots.docs
          .where((element) =>
      element.get('phone').toString().trim().toLowerCase() == managerMobileNumberController.text.toString().trim().toLowerCase())
          .toList()
          .length;
      int empCount = empSanpshots.docs
          .where((element) =>
      element.get('phone').toString().trim().toLowerCase() == managerMobileNumberController.text.toString().trim().toLowerCase())
          .toList()
          .length;
      int managerNumber = managerSanpshots.docs
          .where((element) =>
      element.get('managerNumber').toString().trim().toLowerCase() ==
          managerNumberController.text.trim().toLowerCase())
          .toList()
          .length;

      if (adminCount == 0 && managerCount == 0 && empCount == 0) {
        if(managerNumber==0){
          FireStoreService().addUser(userModel, "managers", id);
          WidgetProperties.showToast(
              S.of(context).register_success, Colors.white, Colors.green);
          WidgetProperties.pop(buildContext);
        }
        else{
          WidgetProperties.showToast(
              'Manager number already exist', Colors.white, Colors.red);
        }


      } else {
        WidgetProperties.showToast(
            'Phone already exist', Colors.white, Colors.red);
      }
    } else {
      //this.userController.update(['manager']);
      setState(() {

      });
    }
  }

  Future<void> updateManager(
      BuildContext buildContext, String documentId) async {
    BranchModel branchModel;
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('managers').doc();
    var id = widget.documentId;
    await FirebaseFirestore.instance
        .collection('branches')
        .where('searchString', isEqualTo: _selectedLocation.toString())
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        branchModel = BranchModel.fromMap(
            value.docs.single.data()); //if it is a single document
      }
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String fullName = managerFirstNameController.text
            .replaceAll(' ', '')
            .trim()
            .toLowerCase() +
        managerLastNameController.text.replaceAll(' ', '').trim().toLowerCase();
    String searchString = fullName + _selectedLocation;

    userModel.createdBy = sharedPreferences.getString("phoneNumber");
    userModel.createdAt = DateTime.now().toString();
    userModel.firstName = managerFirstNameController.text;
    userModel.lastName = managerLastNameController.text;
    userModel.phone = managerMobileNumberController.text;
    userModel.managerNumber = managerNumberController.text;
    userModel.branchName = branchModel.name;
    userModel.cityName = branchModel.branchAddress;
    userModel.branchId = branchModel.id;
    userModel.address = _selectedLocation;
    userModel.roleId = 'manager';
    userModel.searchString = searchString;
    userModel.id = widget.documentId;

    var adminSanpshots =
    await FirebaseFirestore.instance.collection('admin').get();
    var managerSanpshots =
    await FirebaseFirestore.instance.collection('managers').get();
    var empSanpshots =
    await FirebaseFirestore.instance.collection('employees').get();
    if (userController.checkManagerFormValidation(userModel)) {

      int adminCount = adminSanpshots.docs
          .where((element) =>
      element.get('phone').toString().trim().toLowerCase() == managerMobileNumberController.text.toString().trim().toLowerCase())
          .toList()
          .length;
      int managerCount = managerSanpshots.docs
          .where((element) =>
      element.get('phone').toString().trim().toLowerCase() == managerMobileNumberController.text.toString().trim().toLowerCase())
          .toList()
          .length;
      int empCount = empSanpshots.docs
          .where((element) =>
      element.get('phone').toString().trim().toLowerCase() == managerMobileNumberController.text.toString().trim().toLowerCase())
          .toList()
          .length;
      int managerNumber = managerSanpshots.docs
          .where((element) =>
      element.get('managerNumber').toString().trim().toLowerCase() ==
          managerNumberController.text.trim().toLowerCase())
          .toList()
          .length;
      // if (adminCount == 0 && managerCount == 0 && empCount == 0) {
      //   if(managerNumber==0){
          FireStoreService().updateUser(userModel, "managers", id);
          WidgetProperties.showToast(
              S.of(context).update_success, Colors.white, Colors.green);
          WidgetProperties.pop(buildContext);
      //   }
      //   else{
      //     WidgetProperties.showToast(
      //         'Manager number already exist', Colors.white, Colors.red);
      //   }
      //
      // } else {
      //   WidgetProperties.showToast(
      //       'Phone already exist', Colors.white, Colors.red);
      // }
    } else {
      //userController.update();
      setState(() {

      });
    }
  }
}
