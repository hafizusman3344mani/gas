import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gas_station/common/common_screen.dart';
import 'package:gas_station/common/custom_button.dart';
import 'package:gas_station/common/custominput.dart';
import 'package:gas_station/common/text_view.dart';
import 'package:gas_station/controllers/user_controller.dart';
import 'package:gas_station/generated/l10n.dart';
import 'package:gas_station/manager/manager_dashboard.dart';
import 'package:gas_station/models/user/user_model.dart';
import 'package:gas_station/screens/dashboard/dashboard.dart';
import 'package:gas_station/utils/colors.dart';
import 'package:gas_station/utils/my_behaviour.dart';
import 'package:gas_station/utils/widgetproperties.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'employee_form.dart';

class EmployeeScreen extends StatefulWidget {
  @override
  _EmployeeScreenState createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  CollectionReference ref;

  var userController = Get.find<UserController>();

  var userSearchMobileTextController = TextEditingController();

  String searchKey = '';
  UserModel managerModel;
  String branchId = '';
  var searchNode = FocusNode();
  bool manager = false;
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
        manager
            ? WidgetProperties.goToNextPageWithReplacement(
                context, ManagerDashboard())
            : WidgetProperties.goToNextPageWithReplacement(
                context, Dashboard());
        return false;
      },
      child: CommonScreen(
        appBarTitle: S.of(context).employees_text,
        bodyContent: GetBuilder<UserController>(
          initState: (child) {
            ref = FirebaseFirestore.instance.collection('employees');
          },
          init: userController,
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
                          title: S.of(context).add_new_employee_text,
                          onPressed: () {
                            WidgetProperties.goToNextPage(
                                context, EmployeeForm());
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
                                  textInputType: TextInputType.text,
                                  // errorText:
                                  // userController.validityPhoneNumber.message,
                                  hint: 'Search...',
                                  hintColor: AppColors.commoneadingtextColor,
                                  onSaved: (String value) {},
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
                                      .collection('employees')
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
                                          UserModel employee =
                                              UserModel.fromMap(snapshot
                                                  .data.docs[index]
                                                  .data());
                                          var documentId =
                                              snapshot.data.docs[index].id;
                                          print(snapshot.data.docs.length);
                                          return listWidget(
                                              context, employee, documentId);
                                        },
                                      );
                                    }
                                  }),
                            )
                          : Container(
                              height: MediaQuery.of(context).size.height * .4,
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
                                      title: S.of(context).employee_list_text,
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
                                      child: manager
                                          ? StreamBuilder<QuerySnapshot>(
                                              stream: ref
                                                  .where('branchId',
                                                      isEqualTo: branchId)
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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15.0,
                                                      title:
                                                          "No Employee  Found",
                                                    ),
                                                  );
                                                }
                                                return ListView.builder(
                                                  itemCount:
                                                      snapshot.data.docs.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    userController
                                                            .employeeCount =
                                                        snapshot
                                                            .data.docs.length;
                                                    var documentId = snapshot
                                                        .data.docs[index].id;
                                                    // print(id);
                                                    UserModel userModel =
                                                        UserModel.fromMap(
                                                            snapshot.data
                                                                .docs[index]
                                                                .data());

                                                    return listWidget(context,
                                                        userModel, documentId);
                                                  },
                                                );
                                              },
                                            )
                                          : StreamBuilder<QuerySnapshot>(
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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15.0,
                                                      title:
                                                          "No Employee  Found",
                                                    ),
                                                  );
                                                }
                                                return ListView.builder(
                                                  itemCount:
                                                      snapshot.data.docs.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    userController
                                                            .employeeCount =
                                                        snapshot
                                                            .data.docs.length;
                                                    var documentId = snapshot
                                                        .data.docs[index].id;
                                                    // print(id);
                                                    UserModel userModel =
                                                        UserModel.fromMap(
                                                            snapshot.data
                                                                .docs[index]
                                                                .data());

                                                    return listWidget(context,
                                                        userModel, documentId);
                                                  },
                                                );
                                              },
                                            ),
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
        ),
      ),
    );
  }

  Widget listWidget(
      BuildContext buildContext, UserModel userModel, String documentId) {
    return Container(
      //margin: EdgeInsets.all(10.0),
      child: TweenAnimationBuilder(
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
                          Icons.person,
                          size: 30.0,
                          color: AppColors.listColor,
                        ),
                        Textview2(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          title: userModel.firstName != null
                              ? userModel.firstName
                              : "James Bond",
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
                              return EmployeeForm(
                                userModel: userModel,
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
        tween: Tween<double>(begin: 0, end: 5),
        duration: Duration(milliseconds: 1000),
        curve: Curves.bounceInOut,
        builder: (BuildContext context, double _val, Widget child) {
          return Padding(
            padding: EdgeInsets.only(top: _val),
            child: child,
          );
        },
      ),
    );
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
    }).catchError((e) => print("error fetching data: $e"));
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
