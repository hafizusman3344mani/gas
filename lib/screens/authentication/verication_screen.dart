// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:gas_station/screens/home_screen.dart';
// import 'package:sms_autofill/sms_autofill.dart';
//
// class VerificationPage extends StatefulWidget {
//   final String verificationId;
//
//   const VerificationPage({Key key, this.verificationId}) : super(key: key);
//   @override
//   _VerificationPageState createState() => _VerificationPageState();
// }
//
// class _VerificationPageState extends State<VerificationPage> {
//
//   final _codeController = TextEditingController();
//   FirebaseAuth _auth = FirebaseAuth.instance;
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     SmsAutoFill().unregisterListener();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData.light(),
//       home: Scaffold(
//         resizeToAvoidBottomInset: true,
//         appBar: AppBar(
//           title: const Text('Plugin example app'),
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.max,
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: <Widget>[
//               PinFieldAutoFill(
//                 controller: _codeController,
//                 decoration: UnderlineDecoration(
//                   textStyle: TextStyle(fontSize: 20, color: Colors.black),
//                   colorBuilder: FixedColorBuilder(Colors.black.withOpacity(0.3)),
//                 ),
//                 currentCode: _codeController.text.trim().toString(),
//                 onCodeSubmitted: (code)  {
//
//                 },
//                 onCodeChanged: (code) async {
//                   if (code.length == 6) {
//                     FocusScope.of(context).requestFocus(FocusNode());
//                   }
//
//                   AuthCredential credential =
//                   PhoneAuthProvider.credential(
//                       verificationId: widget.verificationId, smsCode: code);
//
//                   UserCredential result =
//                       await _auth.signInWithCredential(credential);
//
//                   User user = result.user;
//
//                   if (user != null) {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => HomeScreen(
//                               user: user,
//                             )));
//                   } else {
//                     print("Error");
//                   }
//                 },
//               ),
//
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }