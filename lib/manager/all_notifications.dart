import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gas_station/models/notification_model.dart';
import 'package:gas_station/models/user/user_model.dart';
import 'package:gas_station/utils/colors.dart';
import 'package:gas_station/utils/widgetproperties.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllNotifications extends StatefulWidget {
  @override
  _AllNotificationsState createState() => _AllNotificationsState();
}

class _AllNotificationsState extends State<AllNotifications> {
  String managerAddress = '';
  UserModel managerModel;
  @override
  void initState() {
    getBool();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
      ),
      body: Container(
        width: WidgetProperties.screenWidth(context),
        height: WidgetProperties.screenHeight(context),
        child: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('pushnotifications')
              .where('address', isEqualTo: managerAddress)
              .get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.data.docs.length == 0) {
              return Center(child: Text('No data found'));
            } else {
              return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    NotificationModel notificationModel =
                        NotificationModel.fromMap(
                            snapshot.data.docs[index].data());
                    var formatter = new DateFormat('MM-dd kk:mm');
                    String formattedDate = formatter.format(
                        DateTime.parse(notificationModel.sendDate.toString()));

                    // String duration = '';
                    // var currentTime = DateTime.now();
                    // var messageTime =
                    //     DateTime.parse(notificationModel.sendDate);
                    // final difference =
                    //     currentTime.difference(messageTime).inMinutes;
                    // if (difference < 0) {
                    //   setState(() {
                    //     duration = 'just now';
                    //   });
                    // } else if (difference > 60) {
                    //   setState(() {
                    //     duration = '${difference / 60} hours ago';
                    //   });
                    // } else {
                    //   setState(() {
                    //     duration = '$difference minutes ago';
                    //   });
                    // }

                    return Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                        margin:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: Material(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(10),
                          child: ListTile(
                            leading: Icon(
                              Icons.notifications,
                              color: AppColors.primaryColor,
                            ),
                            title: Text(notificationModel.name),
                            subtitle:
                                Text(notificationModel.senderId.toString()),
                            trailing: Text(formattedDate),
                          ),
                        ));
                  });
            }
          },
        ),
      ),
    );
  }

  getBool() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //String branchId = prefs.getString('branchId');
    String managerPhone = prefs.getString('phoneNumber');
    FirebaseFirestore.instance
        .collection('managers')
        .where('phone', isEqualTo: managerPhone)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        managerModel = UserModel.fromMap(value.docs.first.data());
        setState(() {
          managerAddress = managerModel.address;
        });
      }
    });
  }
}
