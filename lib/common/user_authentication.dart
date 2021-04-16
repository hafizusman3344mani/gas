import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_ui/firebase_auth_ui.dart';
import 'package:firebase_auth_ui/providers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gas_station/new.dart';
import 'package:gas_station/utils/widgetproperties.dart';
import 'package:shared_preferences/shared_preferences.dart';




class UserAuthentication extends StatefulWidget {


  @override
  _UserAuthenticationState createState() => _UserAuthenticationState();
}

class _UserAuthenticationState extends State<UserAuthentication> {
  String error = "";
  String mobileNumber='';

  @override
  void initState() {
    _pressedLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:Text(''),
      ),
    );
  }


  void _pressedLogin()async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      FirebaseAuthUi.instance()
          .launchAuth([AuthProvider.phone()]).then((value) {
        setState(() {
          prefs.setString('phoneNumber', value.phoneNumber);
          error = "";
        });
        WidgetProperties.goToNextPageWithReplacement(context, Testing(mobile: value.phoneNumber,));
      }).catchError((e) {
        if (e is PlatformException) {
          setState(() {
            if (e.code == FirebaseAuthUi.kFirebaseError) {
              error = "User Cancelled Login";
            } else {
              error = e.message ?? "Link Error";
            }
          });
        }
      });
    } else {
     WidgetProperties.showToast('Already logged in', Colors.white, Colors.red);
     WidgetProperties.goToNextPageWithReplacement(context, Testing(mobile: prefs.get('phoneNumber'),));

    }
  }
}
