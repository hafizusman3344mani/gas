// import 'package:fcm_config/fcm_config.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
//
// class NotificationSingleton {
//   NotificationSingleton._privateConstructor();
//
//   static final NotificationSingleton instance =
//       NotificationSingleton._privateConstructor();
//
//   messages() async {
//     await Firebase.initializeApp();
//     await FCMConfig()
//         .init(onBackgroundMessage: firebaseMessagingBackgroundHandler)
//         .then((value) {
//       if (!kIsWeb) {
//         FCMConfig().subscribeToTopic('test_fcm_topic');
//       }
//     });
//   }
//
//
// }
