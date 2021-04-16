import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gas_station/common/common_screen.dart';
import 'package:gas_station/common/custom_button.dart';
import 'package:gas_station/common/custominput3.dart';
import 'package:gas_station/common/text_view.dart';
import 'package:gas_station/controllers/city_controller.dart';
import 'package:gas_station/db/db_service.dart';
import 'package:gas_station/generated/l10n.dart';
import 'package:gas_station/models/city_model.dart';
import 'package:gas_station/utils/colors.dart';
import 'package:gas_station/utils/widgetproperties.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CityForm extends StatefulWidget {
  @override
  _CityFormState createState() => _CityFormState();
}

class _CityFormState extends State<CityForm> {
  var cityModel = CityModel();

  var cityController = Get.put(CityController());

  var cityTextController = TextEditingController();

  bool editPressed = false;
  var documentId;
  CollectionReference ref;

  var _listDecoration = BoxDecoration(
      color: AppColors.textWhiteColor,
      borderRadius: BorderRadius.circular(12.0),
      border: Border.all(width: 1.5, color: AppColors.primaryColor),
      shape: BoxShape.rectangle);

  var ctNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return CommonScreen(
        appBarTitle: S.of(context).branch_city,
        bodyContent: GetBuilder<CityController>(
          initState: (child) {
            ref = FirebaseFirestore.instance.collection('cities');
          },
          init: cityController,
          builder: (_) {
            return Column(
              children: [
                Form(
                  child: Container(
                    margin: EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0),
                    child: FormInput3(
                      textInputType: TextInputType.text,
                      errorText: cityController.validityCityName.message,
                      hint: S.of(context).enter_city,
                      hintColor: AppColors.commoneadingtextColor,
                      onSaved: (String value) {
                        cityController.checkCityName(value);
                        cityController.updateCityBuilder();
                      },
                      formatter: FilteringTextInputFormatter.allow(
                        RegExp("^[\u0600-\u065F\u066A-\u06EF\u06FA-\u06FFa-zA-Z ]+[\u0600-\u065F\u066A-\u06EF\u06FA-\u06FFa-zA-Z-_ ]*"),
                      ),
                      obsecureText: false,
                      maxLength: 50,
                      myController: cityTextController,
                      focusNode: ctNode,
                    ),
                  ),
                ),
                HeroButton(
                  width: 130.0,
                  height: 30.0,
                  radius: 6.0,
                  gradient: AppColors.primaryColor,
                  title: editPressed
                      ? S.of(context).edit_city_text
                      : S.of(context).add_city_text,
                  onPressed: () {
                    editPressed
                        ? updateCity(context, documentId)
                        : addCity(context);
                    // WidgetProperties.goToNextPageWithReplacement(
                    //     context, CityForm());
                  },
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(
                        top: 10.0, left: 15.0, right: 15.0, bottom: 10.0),
                    alignment: Alignment.center,
                    decoration: _listDecoration,
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 4.0),
                            child: Textview2(
                              title: S.of(context).city_list_text,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          Container(
                              height: MediaQuery.of(context).size.height / 3,
                              child: StreamBuilder<QuerySnapshot>(
                                  stream: ref.snapshots(),
                                  builder: (context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (!snapshot.hasData) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else if (snapshot.data.docs.length == 0) {
                                      return Center(
                                        child: Textview2(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15.0,
                                          title: "No City  Found",
                                        ),
                                      );
                                    }
                                    return ListView.builder(
                                      itemCount: snapshot.data.docs.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        documentId =
                                            snapshot.data.docs[index].id;

                                        CityModel cityModel = CityModel.fromMap(
                                            snapshot.data.docs[index].data());

                                        return listWidget(
                                            context, cityModel, documentId);
                                      },
                                    );
                                  }))
                        ],
                      ),
                    ),
                  ),
                )
              ],
            );
          },
        ));
  }

  Widget listWidget(
      BuildContext buildContext, CityModel cityModel, String documentId) {
    return Container(
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
                        Icons.home,
                        size: 30.0,
                        color: AppColors.listColor,
                      ),
                      Textview2(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        title: cityModel.name != null
                            ? cityModel.name
                            : "New York",
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
                          setState(() {
                            editPressed = true;
                            documentId = cityModel.id;
                            cityTextController.text = cityModel.name;
                          });
                        },
                        child: Text(S.of(context).edit_btn_text),
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
                        child: Text(S.of(context).delete_btn_text),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Future<void> addCity(BuildContext buildContext) async {
    DocumentReference documentReference = ref.doc();
    cityModel.name = cityTextController.text;
    var id = documentReference.id;
    //SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    cityModel.id = id;

    var docSanpshots = await ref.get();
    if (cityController.checkCityNameValidation(cityModel)) {
      int count = docSanpshots.docs
          .where((element) =>
              element.get('name').toString().toLowerCase() ==
              cityTextController.text.toLowerCase())
          .toList()
          .length;
      if (count == 0) {
        FireStoreService().addCity(cityModel, "cities",id).then((value) {
          WidgetProperties.showToast(
              S.of(context).add_success, Colors.white, Colors.green);
        });
      } else {
        WidgetProperties.showToast(
            S.of(context).already_exist, Colors.white, Colors.red);
      }

      cityTextController.text = "";
    } else {
      cityController.updateCityBuilder();
    }
  }

  Future<void> updateCity(BuildContext buildContext, String documentId) {
    cityModel.name = cityTextController.text;
    cityModel.id=documentId;

    if (cityController.checkCityNameValidation(cityModel)) {
      FireStoreService().updateCity(cityModel, "cities", documentId);

      WidgetProperties.showToast(
          S.of(context).update_success, Colors.white, Colors.green);
      editPressed = false;
      cityTextController.text = "";
    } else {
      cityController.updateCityBuilder();
    }
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
