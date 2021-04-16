import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gas_station/common/common_screen.dart';
import 'package:gas_station/common/custom_button.dart';
import 'package:gas_station/common/custominput3.dart';
import 'package:gas_station/controllers/branch_controller.dart';
import 'package:gas_station/controllers/user_controller.dart';
import 'package:gas_station/db/db_service.dart';
import 'package:gas_station/generated/l10n.dart';
import 'package:gas_station/models/branch_model.dart';
import 'package:gas_station/models/city_model.dart';
import 'package:gas_station/utils/colors.dart';
import 'package:gas_station/utils/widgetproperties.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BranchForm extends StatefulWidget {
  final BranchModel branchModel;
  final String documentId;

  BranchForm({this.branchModel, this.documentId});
  @override
  _BranchFormState createState() => _BranchFormState();
}

class _BranchFormState extends State<BranchForm> {
  var branchController = Get.find<BranchController>();

  var branchNameController = TextEditingController();

  var branchAddressController = TextEditingController();

  String _selectedLocation;

  var branchModel = BranchModel();

  var _listDecoration = BoxDecoration(
      color: AppColors.textWhiteColor,
      borderRadius: BorderRadius.circular(12.0),
      border: Border.all(width: 1.5, color: AppColors.primaryColor),
      shape: BoxShape.rectangle);

  var ctNode1 = FocusNode();

  var ctNode2 = FocusNode();
  @override
  void initState() {
    widget.branchModel != null
        ? branchNameController.text = widget.branchModel.name
        : '';
    widget.branchModel != null
        ? _selectedLocation = widget.branchModel.branchAddress
        : null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CommonScreen(
      appBarTitle: widget.branchModel != null
          ? S.of(context).edit_branch_text
          : S.of(context).add_new_branch_text,
      bodyContent: Container(
        margin: EdgeInsets.only(left: 15.0, right: 15.0, top: 20, bottom: 20),
        decoration: _listDecoration,
        child: GetBuilder<BranchController>(
          initState: (child) {},
          builder: (_) {
            return Form(
              child: Container(
                margin: EdgeInsets.only(top: 20.0, left: 15.0, right: 15.0),
                child: Column(
                  children: [
                    FormInput3(
                      textInputType: TextInputType.text,
                      errorText: branchController.validityBranchName.message,
                      hint: widget.branchModel != null
                          ? S.of(context).edit_branch_text
                          : S.of(context).add_new_branch_text,
                      hintColor: AppColors.commoneadingtextColor,
                      onSaved: (String value) {
                        branchController.checkBranchName(value);
                        branchController.updateBranchBuilder();
                      },
                      formatter: FilteringTextInputFormatter.allow(
                        RegExp("^[\u0600-\u065F\u066A-\u06EF\u06FA-\u06FFa-zA-Z ]+[\u0600-\u065F\u066A-\u06EF\u06FA-\u06FFa-zA-Z-_ ]*"),
                      ),
                      obsecureText: false,
                      maxLength: 50,
                      myController: branchNameController,
                      focusNode: ctNode1,
                    ),
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('cities')
                            .snapshots(),
                        builder:
                            (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 10.0),
                              child: DropdownButton<String>(
                                  isExpanded: true,
                                  items: snapshot.data.docs
                                      .map((DocumentSnapshot document) {
                                    return DropdownMenuItem<String>(
                                      value: document.data()['name'],
                                      child: Text('${document.data()['name']}'),
                                    );
                                    // return document.data()['name'];
                                  }).toList(),
                                  hint: Text(S.of(context).select_city_text),
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
                      margin: EdgeInsets.only(top: 35.0),
                      child: HeroButton(
                        width: 170.0,
                        height: 45.0,
                        radius: 6.0,
                        gradient: AppColors.primaryColor,
                        title: widget.branchModel != null
                            ? S.of(context).update_branch_text
                            : S.of(context).add_new_branch_text,
                        onPressed: () {
                          widget.branchModel != null
                              ? updateBranch(context, widget.documentId)
                              : addBranch(context);
                        },
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> addBranch(BuildContext buildContext) async {
    CityModel cityModel;
    var document = await FirebaseFirestore.instance
        .collection('cities')
        .where('name', isEqualTo: _selectedLocation)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        cityModel = CityModel.fromMap(value.docs.first.data());
      }
    });

    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('branches').doc();
    var id = documentReference.id;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String phoneNumber = sharedPreferences.getString('phoneNumber');
    String searchString = (branchNameController.text + _selectedLocation)
        .trim()
        .replaceAll(' ', '')
        .toLowerCase();
    branchModel.createdBy = phoneNumber;
    branchModel.createdAt = DateTime.now().toString();
    branchModel.cityId = cityModel.id;
    branchModel.id = id;
    branchModel.name = branchNameController.text;
    branchModel.branchAddress = _selectedLocation;
    branchModel.searchString = searchString;
    branchModel.createdBy = Get.find<UserController>().phoneNumber;
    var branchDocSanpshots =
        await FirebaseFirestore.instance.collection('branches').get();
    if (branchController.checkBranchValidation(branchModel)) {
      int branchCount = branchDocSanpshots.docs
          .where((element) =>
              element
                  .get('searchString')
                  .toString()
                  .replaceAll(' ', '')
                  .trim()
                  .toLowerCase() ==
              searchString)
          .toList()
          .length;

      if (branchCount == 0) {
        FireStoreService().addBranch(branchModel, 'branches', id);
        WidgetProperties.showToast(
            S.of(context).add_success, Colors.white, Colors.green);
        WidgetProperties.pop(buildContext);
      } else {
        WidgetProperties.showToast(
            S.of(context).already_exist, Colors.white, Colors.red);
      }

      branchNameController.text = "";
      branchAddressController.text = "";
// WidgetProperties.goToNextPageWithReplacement(
// buildContext, OtpScreen());
// WidgetProperties.goToNextPageWithReplacement(
// buildContext, OtpScreen());
    } else {
      branchController.updateBranchBuilder();
    }
  }

  Future<void> updateBranch(BuildContext buildContext, String documentId)async {
    CityModel cityModel;
    var document = await FirebaseFirestore.instance
        .collection('cities')
        .where('name', isEqualTo: _selectedLocation)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        cityModel = CityModel.fromMap(value.docs.first.data());
      }
    });
    DocumentReference documentReference =
    FirebaseFirestore.instance.collection('branches').doc();
    var id = documentReference.id;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String phoneNumber = sharedPreferences.getString('phoneNumber');
    String searchString = (branchNameController.text + _selectedLocation)
        .trim()
        .replaceAll(' ', '')
        .toLowerCase();
    branchModel.createdBy = phoneNumber;
    branchModel.createdAt = DateTime.now().toString();
    branchModel.cityId = cityModel.id;
    branchModel.id = widget.documentId;
    branchModel.name = branchNameController.text;
    branchModel.branchAddress = _selectedLocation;
    branchModel.searchString = searchString;
    var branchDocSanpshots =
        await FirebaseFirestore.instance.collection('branches').get();
    if (branchController.checkBranchValidation(branchModel)) {

      int branchCount = branchDocSanpshots.docs
          .where((element) =>
      element
          .get('searchString')
          .toString()
          .replaceAll(' ', '')
          .trim()
          .toLowerCase() ==
          searchString)
          .toList()
          .length;
      if(branchCount==0){
        FireStoreService().updateBranch(branchModel, 'branches', documentId);

        WidgetProperties.showToast(
            S.of(context).update_success, Colors.white, Colors.green);

        branchNameController.text = "";
        branchAddressController.text = "";

        WidgetProperties.pop(buildContext);
      }
      else{
        WidgetProperties.showToast(
           S.of(context).already_exist, Colors.white, Colors.red);
        WidgetProperties.pop(buildContext);
      }

// WidgetProperties.goToNextPageWithReplacement(
// buildContext, OtpScreen());
// WidgetProperties.goToNextPageWithReplacement(
// buildContext, OtpScreen());
    } else {
      branchController.updateBranchBuilder();
    }
  }
}
