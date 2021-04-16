import 'package:gas_station/common/models/validity_model.dart';
import 'package:gas_station/models/city_model.dart';
import 'package:gas_station/models/user/user_validation.dart';
import 'package:get/get.dart';

class CityController extends GetxController {
  var validityCityName = ValidityModel();

  bool checkCityNameValidation(CityModel cityModel) {
    validityCityName = UserValidation.validateCityName(cityModel.name);
    if (validityCityName.valid) {
      return true;
    } else
      return false;
  }

  Future<void> checkCityName(String value) {
    validityCityName = UserValidation.validateCityName(value);
    // updateUserBuilder();
  }

   Future<void> updateCityBuilder() {
    update();
  }
}
