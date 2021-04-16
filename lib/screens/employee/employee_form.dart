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

class EmployeeForm extends StatefulWidget {
  final UserModel userModel;
  final String documentId;

  EmployeeForm({this.userModel, this.documentId});

  @override
  _EmployeeFormState createState() => _EmployeeFormState();
}

class _EmployeeFormState extends State<EmployeeForm> {
  String _selectedLocation;

  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('branches');

  String branchId = '';
  bool manager = false;
  var userModel = UserModel();

  var userController = Get.put(UserController());

  var fnNode = FocusNode();

  var lNode = FocusNode();

  var mnNode = FocusNode();

  var empNode = FocusNode();

  var employeeFirstNameController = TextEditingController();

  var employeeLastNameController = TextEditingController();

  var employeeMobileNumberController = TextEditingController();

  var employeeNumberController = TextEditingController();

  var _listDecoration = BoxDecoration(
      color: AppColors.textWhiteColor,
// borderRadius: BorderRadius.circular(12.0),
      border: Border.all(width: 1.5, color: AppColors.primaryColor),
      shape: BoxShape.rectangle);

  UserModel managerModel;

  @override
  void initState() {
    widget.userModel != null
        ? employeeFirstNameController.text = widget.userModel.firstName
        : '';
    widget.userModel != null
        ? employeeLastNameController.text = widget.userModel.lastName
        : '';
    widget.userModel != null
        ? employeeMobileNumberController.text = widget.userModel.phone
        : '';
    widget.userModel != null
        ? employeeNumberController.text = widget.userModel.employeeNumber
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
          ? S.of(context).edit_employee_text
          : S.of(context).new_employee_text,
      bodyContent: GetBuilder<UserController>(
        init: userController,
        initState: (child) {
          getBool();
        },
        builder: (_) {
          return Container(
            margin: EdgeInsets.only(
                top: 20.0, left: 15.0, right: 15.0, bottom: 10.0),
            alignment: Alignment.center,
            decoration: _listDecoration,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 4.0),
                  child: Textview2(
                    title: widget.userModel != null
                        ? S.of(context).edit_employee_text
                        : S.of(context).new_employee_text,
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
                                margin: EdgeInsets.only(top: 20.0),
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
                                  myController: employeeFirstNameController,
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
                                  myController: employeeLastNameController,
                                  focusNode: lNode,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 20.0),
                                child: FormInput3(
                                  enabled: widget.documentId!=null?false:true,
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
                                    RegExp("[0-9 +]"),
                                  ),
                                  obsecureText: false,
                                  maxLength: 50,
                                  myController: employeeMobileNumberController,
                                  focusNode: mnNode,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 20.0),
                                child: FormInput3(
                                  enabled:  widget.documentId!=null?false:true,
                                  textInputType: TextInputType.text,
                                  errorText: userController
                                      .validityEmployeeNumber.message,
                                  hint: S.of(context).employee_num_text,
                                  hintColor: AppColors.commoneadingtextColor,
                                  onSaved: (String value) {
                                    userController.checkEmployeeNumber(value);
                                    userController.updateUserBuilder();
                                  },
                                  formatter: FilteringTextInputFormatter.allow(
                                    RegExp("[A-Z a-z _ . @ 0-9]"),
                                  ),
                                  obsecureText: false,
                                  maxLength: 50,
                                  myController: employeeNumberController,
                                  focusNode: empNode,
                                ),
                              ),
                              manager
                                  ? StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('branches')
                                          .where('id', isEqualTo: branchId)
                                          .snapshots(),
                                      builder: (context,
                                          AsyncSnapshot<QuerySnapshot>
                                              snapshot) {
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
                                                    (DocumentSnapshot
                                                        document) {
                                                  return DropdownMenuItem<
                                                      String>(
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
                                      })
                                  : StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('branches')
                                          .snapshots(),
                                      builder: (context,
                                          AsyncSnapshot<QuerySnapshot>
                                              snapshot) {
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
                                                    (DocumentSnapshot
                                                        document) {
                                                  return DropdownMenuItem<
                                                      String>(
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
                                padding: EdgeInsets.only(top: 10.0, bottom: 30),
                                child: HeroButton(
                                  width: 140.0,
                                  height: 50.0,
                                  radius: 6.0,
                                  gradient: AppColors.primaryColor,
                                  title: widget.userModel != null
                                      ? S.of(context).Update_employee_text
                                      : S.of(context).add_employee_text,
                                  onPressed: () {
                                    widget.userModel != null
                                        ? updateEmployee(
                                            context, widget.documentId)
                                        : registerEmployee(context);
                                    // WidgetProperties.pop(context);
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
            ),
          );
        },
      ),
    );
  }

  DocumentReference documentReference =
      FirebaseFirestore.instance.collection('employees').doc();
  Future<void> registerEmployee(BuildContext buildContext) async {
    BranchModel branchModel;
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
    String fullName = employeeFirstNameController.text
            .replaceAll(' ', '')
            .trim()
            .toLowerCase() +
        employeeLastNameController.text
            .replaceAll(' ', '')
            .trim()
            .toLowerCase();
    String searchString = fullName + _selectedLocation;
    userModel.createdBy = sharedPreferences.getString("phoneNumber");
    userModel.createdAt = DateTime.now().toString();
    userModel.firstName = employeeFirstNameController.text;
    userModel.lastName = employeeLastNameController.text;
    userModel.phone = employeeMobileNumberController.text;
    userModel.branchName = branchModel.name;
    userModel.cityName = branchModel.branchAddress;
    userModel.employeeNumber = employeeNumberController.text;
    userModel.createdAt = DateTime.now().toString();
    userModel.createdBy = sharedPreferences.getString('phoneNumber');
    userModel.searchString = searchString;
    userModel.fcmToken = '';
    userModel.address = _selectedLocation;
    userModel.branchId = branchModel.id;
    userModel.id = id;
    //  userModel.branchId = branchModel.id;
    userModel.address = _selectedLocation;
    userModel.roleId = 'employee';
    var adminSanpshots =
        await FirebaseFirestore.instance.collection('admin').get();
    var managerSanpshots =
        await FirebaseFirestore.instance.collection('managers').get();
    var empSanpshots =
        await FirebaseFirestore.instance.collection('employees').get();

    if (userController.checkEmployeeFormValidation(userModel)) {
      // userController.addUser(userModel, buildContext, "employees");
      int adminCount = adminSanpshots.docs
          .where((element) =>
              element.get('phone').toString().trim().toLowerCase() == employeeMobileNumberController.text.toString().trim().toLowerCase())
          .toList()
          .length;
      int managerCount = managerSanpshots.docs
          .where((element) =>
              element.get('phone').toString().trim().toLowerCase() == employeeMobileNumberController.text.toString().trim().toLowerCase())
          .toList()
          .length;
      int empCount = empSanpshots.docs
          .where((element) =>
              element.get('phone').toString().trim().toLowerCase() == employeeMobileNumberController.text.toString().trim().toLowerCase())
          .toList()
          .length;
      int empNumber = empSanpshots.docs
          .where((element) =>
              element.get('employeeNumber').toString().trim().toLowerCase() ==
              employeeNumberController.text.trim().toLowerCase())
          .toList()
          .length;
      if (adminCount == 0 && managerCount == 0 && empCount == 0) {
        if (empNumber == 0) {
          FireStoreService().addUser(userModel, "employees", id);
          WidgetProperties.showToast(
              S.of(context).register_success, Colors.white, Colors.green);
          WidgetProperties.pop(buildContext);
        } else {
          WidgetProperties.showToast(
              'Employee number already exist.', Colors.white, Colors.red);
        }
      } else {
        WidgetProperties.showToast(
            S.of(context).already_exist, Colors.white, Colors.red);
      }
    } else {
      userController.updateUserBuilder();
    }
  }

  Future<void> updateEmployee(
      BuildContext buildContext, String documentId) async {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('employees').doc();
    BranchModel branchModel;
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
    String fullName = employeeFirstNameController.text
            .replaceAll(' ', '')
            .trim()
            .toLowerCase() +
        employeeLastNameController.text
            .replaceAll(' ', '')
            .trim()
            .toLowerCase();
    String searchString = fullName + _selectedLocation;
    userModel.createdBy = sharedPreferences.getString("phoneNumber");
    userModel.createdAt = DateTime.now().toString();
    userModel.firstName = employeeFirstNameController.text;
    userModel.lastName = employeeLastNameController.text;
    userModel.phone = employeeMobileNumberController.text;
    userModel.branchName = branchModel.name;
    userModel.cityName = branchModel.branchAddress;
    userModel.employeeNumber = employeeNumberController.text;
    userModel.createdAt = DateTime.now().toString();
    userModel.createdBy = sharedPreferences.getString('phoneNumber');
    userModel.searchString = fullName;
    userModel.id = widget.documentId;
    userModel.address = _selectedLocation;
    userModel.branchId = branchModel.id;
    //  userModel.branchId = branchModel.id;
    userModel.address = _selectedLocation;
    userModel.roleId = 'employee';
    if (userController.checkEmployeeFormValidation(userModel)) {
      var adminSanpshots =
          await FirebaseFirestore.instance.collection('admin').get();
      var managerSanpshots =
          await FirebaseFirestore.instance.collection('managers').get();
      var empSanpshots =
          await FirebaseFirestore.instance.collection('employees').get();
      int adminCount = adminSanpshots.docs
          .where((element) =>
              element.get('phone').toString().trim().toLowerCase() == employeeMobileNumberController.text.toString().trim().toLowerCase())
          .toList()
          .length;
      int managerCount = managerSanpshots.docs
          .where((element) =>
              element.get('phone').toString().trim().toLowerCase() == employeeMobileNumberController.text.toString().trim().toLowerCase())
          .toList()
          .length;
      int empCount = empSanpshots.docs
          .where((element) =>
              element.get('phone').toString().trim().toLowerCase() == employeeMobileNumberController.text.toString().trim().toLowerCase())
          .toList()
          .length;
      int empNumber = empSanpshots.docs
          .where((element) =>
              element.get('employeeNumber').toString().trim().toLowerCase() ==
              employeeNumberController.text.trim().toLowerCase())
          .toList()
          .length;
      if (userController.checkEmployeeFormValidation(userModel)) {
        // userController.addUser(userModel, buildContext, "employees");

        // if (adminCount == 0 && managerCount == 0 && empCount == 0) {
        //   if (empNumber == 0) {
            FireStoreService().updateUser(userModel, "employees", documentId);
            WidgetProperties.showToast(
                S.of(context).update_success, Colors.white, Colors.green);
            WidgetProperties.pop(buildContext);
        //   } else {
        //     WidgetProperties.showToast(
        //         'Employee number already exist.', Colors.white, Colors.red);
        //   }
        // } else {
        //   WidgetProperties.showToast(
        //      'Phone already exist', Colors.white, Colors.red);
        // }
      }
    } else {
      userController.updateUserBuilder();
    }
  }

  getBool() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String phone = '';
    setState(() {
      manager = prefs.getBool('manager');
      phone = prefs.getString("phoneNumber");
    });
    await FirebaseFirestore.instance
        .collection('managers')
        .where('phone', isEqualTo: phone)
        .get()
        .then((event) {
      if (event.docs.isNotEmpty) {
        managerModel = UserModel.fromMap(
            event.docs.single.data()); //if it is a single document
        setState(() {
          branchId = managerModel.branchId;
        });
      }
    }).catchError((e) => WidgetProperties.showToast(
            S.of(context).error, Colors.white, Colors.red));
  }
}
