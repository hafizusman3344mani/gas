import 'package:gas_station/common/models/validity_model.dart';
import 'package:gas_station/models/city_model.dart';
import 'package:gas_station/models/notification_model.dart';
import 'package:gas_station/models/user/user_validation.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {


  var validityNotificationName = ValidityModel();

  bool checkNotificationNameValidation(NotificationModel notificationModel) {
    validityNotificationName =
        UserValidation.validateNotificationName(notificationModel.name);
    if (validityNotificationName.valid) {
      return true;
    } else
      return false;
  }

  Future<void> checkNotificationName(String value) {
    validityNotificationName = UserValidation.validateNotificationName(value);
    // updateUserBuilder();
  }

  Future<void> updateNotificationBuilder() {
    update();
  }
}
