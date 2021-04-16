import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gas_station/utils/widgetproperties.dart';
import 'package:sms_autofill/sms_autofill.dart';

class PhoneAuthen extends StatefulWidget {
  PhoneAuthen({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _PhoneAuthenState createState() => _PhoneAuthenState();
}

class _PhoneAuthenState extends State<PhoneAuthen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _smsController = TextEditingController();
  String _verificationId;
  final SmsAutoFill _autoFill = SmsAutoFill();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        body: Padding(padding: const EdgeInsets.all(8),
          child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    controller: _phoneNumberController,
                    decoration: const InputDecoration(labelText: 'Phone number (+xx xxx-xxx-xxxx)'),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    alignment: Alignment.center,
                    child: RaisedButton(child: Text("Get current number"),
                        onPressed: () async => {
                          _phoneNumberController.text = await _autoFill.hint
                        },
                        color: Colors.greenAccent[700]),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    alignment: Alignment.center,
                    child: RaisedButton(
                      color: Colors.greenAccent[400],
                      child: Text("Verify Number"),
                      onPressed: () async {
                        verifyPhoneNumber();
                      },
                    ),
                  ),
                  TextFormField(
                    controller: _smsController,
                    decoration: const InputDecoration(labelText: 'Verification code'),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 16.0),
                    alignment: Alignment.center,
                    child: RaisedButton(
                        color: Colors.greenAccent[200],
                        onPressed: () async {
                          signInWithPhoneNumber();
                        },
                        child: Text("Sign in")),
                  ),
                ],
              )
          ),
        )
    );
  }
  void verifyPhoneNumber() async {
    //Callback for when the user has already previously signed in with this phone number on this device
    PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) async {
      await _auth.signInWithCredential(phoneAuthCredential);
      WidgetProperties.showToast("Phone number automatically verified and user signed in: ${_auth.currentUser.uid}",Colors.white,Colors.red);
    };
    PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
          WidgetProperties.showToast('Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}',Colors.white,Colors.red);
    };
    //Callback for when the code is sent
    PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
          WidgetProperties.showToast('Please check your phone for the verification code.',Colors.white,Colors.green);
      _verificationId = verificationId;
    };
    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
          WidgetProperties.showToast("verification code: " + verificationId,Colors.white,Colors.green);
      _verificationId = verificationId;
    };
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: _phoneNumberController.text,
          timeout: const Duration(seconds: 5),
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    } catch (e) {
      WidgetProperties.showToast("Failed to Verify Phone Number: ${e}",Colors.white,Colors.red);
    }
  }
  void signInWithPhoneNumber() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: _smsController.text,
      );

      final User user = (await _auth.signInWithCredential(credential)).user;

      WidgetProperties.showToast("Successfully signed in UID: ${user.uid}",Colors.white,Colors.green);
    } catch (e) {
      WidgetProperties.showToast("Failed to sign in: " + e.toString(),Colors.white,Colors.red);
    }
  }
}
