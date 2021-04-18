import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gas_station/common/common_screen.dart';
import 'package:gas_station/common/custom_button.dart';
import 'package:gas_station/common/custominput3.dart';
import 'package:gas_station/common/text_view.dart';
import 'package:gas_station/controllers/notification_controller.dart';
import 'package:gas_station/db/db_service.dart';
import 'package:gas_station/generated/l10n.dart';
import 'package:gas_station/models/notification_model.dart';
import 'package:gas_station/models/user/user_model.dart';
import 'package:gas_station/utils/colors.dart';
import 'package:gas_station/utils/widgetproperties.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationForm extends StatefulWidget {
  final NotificationModel notificationModel;
  final String documentId;

  const NotificationForm({this.notificationModel, this.documentId});

  @override
  State<StatefulWidget> createState() {
    return _NotificationFormState();
  }
}

class _NotificationFormState extends State<NotificationForm> {
  String _selectedLocation;
  CollectionReference ref;
  bool manager= false;
  UserModel employeeModel;

  var notificationController = Get.put(NotificationController());

  var notificationNameNode = FocusNode();

  var notificationNameController = TextEditingController();

  var _listDecoration = BoxDecoration(
      color: AppColors.textWhiteColor,
      border: Border.all(width: 1.5, color: AppColors.primaryColor),
      shape: BoxShape.rectangle);

  String branchId = '';

  @override
  void initState() {
    widget.documentId != null
        ? _selectedLocation = widget.notificationModel.address
        : null;
    widget.documentId != null
        ? notificationNameController.text = widget.notificationModel.name
        : '';
    getBool();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CommonScreen(
      appBarTitle: widget.notificationModel != null
          ? S.of(context).edit_notification_text
          : S.of(context).new_notification_text,
      bodyContent: Container(
        margin:
            EdgeInsets.only(top: 20.0, left: 15.0, right: 15.0, bottom: 10.0),
        alignment: Alignment.center,
        decoration: _listDecoration,
        child: GetBuilder<NotificationController>(
          init: notificationController,
          initState: (child) {
            ref = FirebaseFirestore.instance.collection("notifications");
          },
          builder: (_) {
            return Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 4.0),
                  child: Textview2(
                    title: widget.notificationModel != null
                        ? S.of(context).edit_notification_text
                        : S.of(context).new_notification_text,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
                Container(
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
                                errorText: notificationController
                                    .validityNotificationName.message,
                                hint: S.of(context).notifications_name_text,
                                hintColor: AppColors.commoneadingtextColor,
                                onSaved: (value) {
                                  notificationController
                                      .checkNotificationName(value);
                                  notificationController
                                      .updateNotificationBuilder();
                                },
                                formatter: FilteringTextInputFormatter.allow(
                                  RegExp("^[\u0600-\u065F\u066A-\u06EF\u06FA-\u06FFa-zA-Z 0-9]+[\u0600-\u065F\u066A-\u06EF\u06FA-\u06FFa-zA-Z-_ 0-9]*"),
                                ),
                                obsecureText: false,
                                maxLength: 50,
                                myController: notificationNameController,
                                focusNode: notificationNameNode,
                              ),
                            ),
                           manager?StreamBuilder<QuerySnapshot>(
                               stream: FirebaseFirestore.instance
                                   .collection('branches')
                               .where('id',isEqualTo: branchId)
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
                                         items: snapshot.data.docs
                                             .map((DocumentSnapshot document) {
                                           branchId = document
                                               .data()['id']
                                               .toString();
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
                                         hint: Text(
                                             S.of(context).select_branch_text),
                                         value: _selectedLocation,
                                         onChanged: (newVal) {
                                           setState(() {
                                             _selectedLocation = newVal;
                                           });
                                         }),
                                   );
                                   ;
                                 }
                               }): StreamBuilder<QuerySnapshot>(
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
                                          items: snapshot.data.docs
                                              .map((DocumentSnapshot document) {
                                            branchId = document
                                                .data()['id']
                                                .toString();
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
                                          hint: Text(
                                              S.of(context).select_branch_text),
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
                            Container(
                              margin: EdgeInsets.only(top: 30.0),
                              child: HeroButton(
                                width: 180.0,
                                height: 37.0,
                                radius: 6.0,
                                gradient: AppColors.primaryColor,
                                title: widget.notificationModel != null
                                    ? S.of(context).update_notification_text
                                    : S.of(context).add_notification_text,
                                onPressed: () {
                                  widget.notificationModel != null
                                      ? updateNotification(
                                          context, widget.documentId)
                                      : addNotification(context);
                                  // WidgetProperties.goToNextPageWithReplacement(
                                  //     context, EmployeeForm());
                                },
                              ),
                            )
                          ],
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

  Future<void> addNotification(BuildContext buildContext) async {
    DocumentReference documentReference = ref.doc();
    var notificationModel = NotificationModel();
    var id = documentReference.id;
    String searchString = (notificationNameController.text + _selectedLocation)
        .trim()
        .replaceAll(' ', '')
        .toLowerCase();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    notificationModel.id = id;
    notificationModel.createdAt = DateTime.now().toString();
    notificationModel.senderId = sharedPreferences.getString("phoneNumber");
    notificationModel.sendDate = DateTime.now().toString();
    notificationModel.createdBy = [sharedPreferences.getString("phoneNumber")];
    notificationModel.name = notificationNameController.text;
    notificationModel.address = _selectedLocation;
    notificationModel.searchString = searchString;

    var docSanpshots = await ref.get();
    if (notificationController
        .checkNotificationNameValidation(notificationModel)) {
      int count = docSanpshots.docs
          .where((element) => element.get('searchString') == searchString)
          .toList()
          .length;
      if (count == 0) {
        FireStoreService().addNotification(notificationModel, "notifications");
        WidgetProperties.showToast(
            S.of(context).add_success, Colors.white, Colors.green);
        WidgetProperties.pop(buildContext);
      } else {
        WidgetProperties.showToast(
            S.of(context).already_exist, Colors.white, Colors.red);
      }
    } else {
      notificationController.updateNotificationBuilder();
    }
  }

  Future<void> updateNotification(
      BuildContext buildContext, String documentId) async {
    DocumentReference documentReference = ref.doc();
    var notificationModel = NotificationModel();
    var id = documentReference.id;
    String searchString = (notificationNameController.text + _selectedLocation)
        .trim()
        .replaceAll(' ', '')
        .toLowerCase();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    notificationModel.id = widget.documentId;
    notificationModel.createdAt = DateTime.now().toString();
    notificationModel.senderId = sharedPreferences.getString("phoneNumber");
    notificationModel.createdBy = [sharedPreferences.getString("phoneNumber")];
    notificationModel.sendDate = DateTime.now().toString();
    notificationModel.name = notificationNameController.text;
    notificationModel.address = _selectedLocation;
    notificationModel.searchString = searchString;

    var docSanpshots = await ref.get();
    if (notificationController
        .checkNotificationNameValidation(notificationModel)) {
      int count = docSanpshots.docs
          .where((element) => element.get('searchString') == searchString)
          .toList()
          .length;
      if (count == 0) {
        FireStoreService()
            .updateNotification(notificationModel, "notifications", documentId);
        WidgetProperties.showToast(S.of(context).update_success,
            Colors.white, Colors.green);
        WidgetProperties.pop(buildContext);
      } else {
        WidgetProperties.showToast(
            S.of(context).already_exist, Colors.white, Colors.red);
      }

      //
      // if (!userController.selectedBranch.isNullOrBlank)
      //   userModel.branchId = userController.selectedBranch.id ?? 0;
      // if (userModel.branchId.isNullOrBlank) {
      //   Fluttertoast.showToast(
      //     msg: "Please Enter Branch Name",
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.BOTTOM,
      //     backgroundColor: Colors.red,
      //     textColor: Colors.white,
      //   );
      // }

      // if (notificationController
      //     .checkNotificationNameValidation(notificationModel)) {
      //   FireStoreService()
      //       .updateNotification(notificationModel, "notifications", documentId);
      //   WidgetProperties.showToast(
      //       S.of(context).notification_updated_text, Colors.white, Colors.green);
      //   WidgetProperties.pop(buildContext);
      // } else {
      notificationController.updateNotificationBuilder();
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
        employeeModel = UserModel.fromMap(
            event.docs.single.data()); //if it is a single document
        setState(() {
          branchId = employeeModel.branchId;
        });
      }
    }).catchError((e) => WidgetProperties.showToast(
        S.of(context).error, Colors.white, Colors.red));
  }
}
