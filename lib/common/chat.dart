import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bubble/bubble.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gas_station/common/full_photo.dart';
import 'package:gas_station/generated/l10n.dart';
import 'package:gas_station/utils/route_singleton.dart';
import 'package:gas_station/utils/widgetproperties.dart';
import 'package:http/http.dart' as http;
import 'package:gas_station/common/text_view.dart';
import 'package:gas_station/models/user/user_model.dart';
import 'package:gas_station/utils/colors.dart';
import 'package:gas_station/utils/const.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:loading/loading.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class Chat extends StatelessWidget {
  final String peerId;
  final UserModel userModel;
  final String type;

  Chat({this.peerId, this.userModel, this.type});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          userModel.firstName ?? 'No Name',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
      ),
      body: ChatScreen(
        peerId: peerId,
        userModel: userModel,
        type: type,
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String peerId;
  final UserModel userModel;
  final String type;

  ChatScreen({this.peerId, this.userModel, this.type});

  @override
  State createState() => ChatScreenState(peerId: peerId);
}

class ChatScreenState extends State<ChatScreen> {
  ChatScreenState({this.peerId});

  String peerId;
  String id;
  bool isClicked = false;
  List<QueryDocumentSnapshot> listMessage = new List.from([]);
  int _limit = 20;
  int _limitIncrement = 20;
  String groupChatId;
  SharedPreferences prefs;

  File imageFile;
  bool isLoading;
  bool isShowSticker;
  String imageUrl;
  String token = '';
  String textMessage = '';

  final TextEditingController textEditingController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    setState(() {
      token = widget.userModel.fcmToken;
    });
    super.initState();
    focusNode.addListener(onFocusChange);

    groupChatId = '';

    isLoading = false;
    isShowSticker = false;
    imageUrl = '';

    readLocal();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  void onFocusChange() {
    if (focusNode.hasFocus) {
      setState(() {
        isClicked = false;
      });
    }
  }

  readLocal() async {
    prefs = await SharedPreferences.getInstance();
    id = prefs.getString('currentUserId') ?? '';
    if (id.hashCode <= peerId.hashCode) {
      groupChatId = '$id-$peerId';
    } else {
      groupChatId = '$peerId-$id';
    }

    FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .update({'chattingWith': peerId});

    setState(() {});
  }

  Future getImage() async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile pickedFile;

    pickedFile = await imagePicker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      setState(() {
        isLoading = true;
      });
      uploadFile();
    } else {
      WidgetProperties.showToast(
          'No image selected!', Colors.white, Colors.green);
    }
  }

  uploadFile() async {
    final _storage = FirebaseStorage.instance;
    var uuid = Uuid();
    if (imageFile != null) {
      var snapShot = await _storage
          .ref()
          .child('GasStation/image+${uuid.v4()}')
          .putFile(imageFile)
          .whenComplete(() {
        WidgetProperties.showToast(
            'Image sent successfully!', Colors.white, Colors.green);
      }).catchError((error) {
        WidgetProperties.showToast(
            'Some thing went wrong, try again.', Colors.white, Colors.green);
      });
      await snapShot.ref.getDownloadURL().then((value) {
        imageUrl = value;
        setState(() {
          isLoading = false;
          onSendMessage(imageUrl, 1);
        });
      });
    } else {
      WidgetProperties.showToast(
          'Image not selected!', Colors.white, Colors.red);
    }
  }

  void onSendMessage(String content, int type) {
    // type: 0 = text, 1 = image, 2 = sticker
    if (content.trim() != '') {
    String time=  DateTime.now().millisecondsSinceEpoch.toString();
      textEditingController.clear();
      var documentReference = FirebaseFirestore.instance
          .collection('messages')
          .doc(groupChatId)
          .collection(groupChatId)
          .doc(time);

      FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(
          documentReference,
          {
            'idFrom': id,
            'idTo': peerId,
            'timestamp':time,
            'content': content,
            'type': type,
          },
        );
      });

     sendPushMessage(token, type == 0?textMessage:'Image');
    } else {
      Fluttertoast.showToast(
          msg: 'Nothing to send',
          backgroundColor: Colors.black,
          textColor: Colors.red);
    }
  }

  Widget buildItem(int index, DocumentSnapshot document) {
    return Column(
      crossAxisAlignment: (document['idFrom'] == id)
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        document['type'] == 0
            ? Container(
                width: MediaQuery.of(context).size.width * .80,
                child: Row(
                  children: [
                    Expanded(
                      child: Bubble(
                        padding:
                            BubbleEdges.symmetric(vertical: 15, horizontal: 10),
                        margin: BubbleEdges.only(
                            left: document.data()['idFrom'] == id ? 10.0 : 10.0,
                            right:
                                document.data()['idFrom'] == id ? 10.0 : 10.0,
                            top: 10,
                            bottom: 3),
                        stick: true,
                        nip: document.data()['idFrom'] == id
                            ? BubbleNip.rightTop
                            : BubbleNip.leftBottom,
                        color: document.data()['idFrom'] == id
                            ? Color(0xff762B2F)
                            : null,
                        //Color.fromRGBO(100,200,95,90)
                        child: Text(
                          document.data()['content'],
                          textAlign: document.data()['idFrom'] == id
                              ? TextAlign.right
                              : TextAlign.left,
                          style: TextStyle(
                              color: document.data()['idFrom'] == id
                                  ? Colors.white
                                  : Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Container(
                child: TextButton(
                  child: Material(
                    child: CachedNetworkImage(
                      placeholder: (context, url) => Container(
                        padding: EdgeInsets.all(70),
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.lightBlueAccent),
                        ),
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(8.0)),
                      ),
                      errorWidget: (context, url, error) => Material(
                        child: Image.asset(
                          'assets/images/img_not_available.jpeg',
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                        clipBehavior: Clip.hardEdge,
                      ),
                      imageUrl: document.data()['content'],
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                    clipBehavior: Clip.hardEdge,
                  ),
                  onPressed: () {
                    WidgetProperties.goToNextPage(
                        context,
                        FullPhoto(
                          url: document.data()['content'],
                        ));
                  },
                ),
                margin: EdgeInsets.only(bottom: 5, right: 0.0),
              ),
        Container(
          padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
          child: Text(
            DateFormat('hh:mm:aa').format(DateTime.fromMillisecondsSinceEpoch(
                int.parse(document['timestamp']))),
            style: TextStyle(
                color: Colors.grey,
                fontSize: 12.0,
                fontStyle: FontStyle.italic),
          ),
        )
      ],
    );
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1].data()['idFrom'] == id) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1].data()['idFrom'] != id) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            // List of messages
            buildListMessage(),

            // Input content
            buildInput(),
          ],
        ),

        // Loading
        buildLoading()
      ],
    );
  }

  Widget buildLoading() {
    return Positioned(
      child: isLoading ? Loading() : Container(),
    );
  }

  Widget buildInput() {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 15, bottom: 10, right: 15),
      padding: EdgeInsets.only(left: 10),
      child: Row(
        children: <Widget>[
          isClicked
              ? Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isClicked = false;
                        });
                        getCameraImage();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.camera_alt,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isClicked = false;
                        });
                        getImage();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.photo,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    )
                  ],
                )
              : GestureDetector(
                  onTap: () {
                    setState(() {
                      isClicked = true;
                    });
                  },
                  child: Icon(
                    Icons.add_circle,
                    color: AppColors.primaryColor,
                  ),
                ),
          // Edit text
          Flexible(
            child: Container(
              child: TextField(
                onSubmitted: (value) {
                  onSendMessage(textEditingController.text, 0);
                },
                style: TextStyle(color: primaryColor, fontSize: 15.0),
                controller: textEditingController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(color: greyColor),
                ),
                focusNode: focusNode,
              ),
            ),
          ),

          // Button send message
          Container(
            child: IconButton(
              icon: Icon(Icons.send),
              onPressed: () {
                setState(() {
                  isClicked = false;
                });
                setState(() {
                  textMessage = textEditingController.text;
                });
                onSendMessage(textEditingController.text, 0);
              },
              color: primaryColor,
            ),
          ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: greyColor2, width: 0.5)),
        color: Colors.black12,
      ),
    );
  }

  Widget buildListMessage() {
    return Flexible(
      child: groupChatId == ''
          ? Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(themeColor)))
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .doc(groupChatId)
                  .collection(groupChatId)
                  .orderBy('timestamp', descending: true)

                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                      child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.primaryColor)));
                } else if (snapshot.data.docs.length == 0) {
                  return Center(child: Text('No Data Found'));
                } else {
                  listMessage.addAll(snapshot.data.docs);
                  return ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemBuilder: (context, index) =>
                        buildItem(index, snapshot.data.docs[index]),
                    itemCount: snapshot.data.docs.length,
                    reverse: true,
                  );
                }
              },
            ),
    );
  }

  Future<void> sendPushMessage(String _token, String message) async {
    // String _token = 'fNIdm69wR1-FJGB0xNpZ57:APA91bGBHGZjNHHPVMdEUWtNmKP9d6n2AxEBbJxXV_udXLXm8IQ469ksLqJcq9J4BseAfydYQf-QV3-vDa1jydDwdBJHO1YpB3rTlJ7XkflTx33uwCkCXjB2wJD6DQHRP3mq5O6mg_ZB';
    if (_token == null) {
      print('Unable to send FCM message, no token exists.');
      return;
    }

    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key='+RouteSingleton.instance.serverKey,
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': message,
              'title': 'Notification' ?? ''
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'id': '1',
              'status': 'done',
            },
            'to': _token,
          },
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  getCameraImage() async {
    var _picker = ImagePicker();
    PickedFile image;
    image = await _picker.getImage(source: ImageSource.camera);

    if (image != null) {
      imageFile = File(image.path);
      setState(() {
        isLoading = true;
      });
      uploadFile();
    }
  }
}
