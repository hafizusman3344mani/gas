import 'package:floor/floor.dart';

@entity
class UserModel {
  @PrimaryKey(autoGenerate: true)
  String id;
  String phone;
  String password;
  String fcmToken;
  String address;
  String branchName;
  String cityName;
  String firstName;
  String lastName;
  String createdAt;
  String updatedAt;
  bool isVerified;
  String searchString;
  String roleId;
  String profileImage;
  String branchId;
  String userPermission;
  String otpCode;
  String employeeNumber;
  String managerNumber;
  String createdBy;

  UserModel();

  Map<String, dynamic> toMap() => {
        'id': id,
        'createdBy': createdBy,
        'userPermission': userPermission,
        'managerNumber': managerNumber,
        'otpCode': otpCode,
        'phone': phone,
        'fcmToken': fcmToken,
        'searchString': searchString,
        'password': password,
        'employeeNumber': employeeNumber,
        'address': address,
        'cityName': cityName,
        'branchName': branchName,
        'firstName': firstName,
        'lastName': lastName,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'isVerified': isVerified,
        'roleId': roleId,
        'profileImage': profileImage,
        'branchId': branchId,
        'user_permission': userPermission,
      };

  UserModel.fromMap(Map<String, dynamic> json)
      : id = json['id'],
        otpCode = json['otpCode'],
        employeeNumber = json['employeeNumber'],
        managerNumber = json['managerNumber'],
        searchString = json['searchString'],
        fcmToken = json['fcmToken'],
        branchName = json['branchName'],
        cityName = json['cityName'],
        userPermission = json['userPermission'],
        phone = json['phone'],
        createdBy = json['createdBy'],
        password = json['password'],
        address = json['address'],
        firstName = json['firstName'],
        lastName = json['lastName'],
        createdAt = json['createdAt'],
        updatedAt = json['updatedAt'],
        isVerified = json['isVerified'],
        roleId = json['roleId'],
        profileImage = json['profileImage'],
        branchId = json['branchId'];
}
