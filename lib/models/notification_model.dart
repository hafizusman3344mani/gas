class NotificationModel {
  String id;
  String senderId;
  String receiverId;
  String sendDate;
  String searchString;
  bool isRead;
  String address;
  List createdBy;
  String createdAt;
  String updatedAt;
  String name;

  Map<String, dynamic> toMap() => {
        'senderId': senderId,
        'id': id,
        'receiverId': receiverId,
        'searchString': searchString,
        'sendDate': sendDate,
        'name': name,
        'createdBy': createdBy,
        'address': address,
        'isRead': isRead,
        'createdAt': createdAt,
        'updatedAt': updatedAt
      };
  NotificationModel();

  NotificationModel.fromMap(Map<String, dynamic> json)
      : senderId = json['senderId'],
        id = json['id'],
        receiverId = json['receiverId'],
        searchString = json['searchString'],
        name = json['name'],
        //createdBy = json['createdBy'],
        createdBy = List.from(json['createdBy']),
        address = json['address'],
        sendDate = json['sendDate'],
        isRead = json['isRead'],
        createdAt = json['createdAt'],
        updatedAt = json['updatedAt'];
}
