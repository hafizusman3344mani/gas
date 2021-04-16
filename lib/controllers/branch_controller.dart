import 'package:gas_station/common/models/validity_model.dart';
import 'package:gas_station/models/branch_model.dart';
import 'package:gas_station/models/user/user_validation.dart';
import 'package:get/get.dart';

class BranchController extends GetxController {
  var validityBranchName = ValidityModel();
  var validityBranchAddress = ValidityModel();

  bool checkBranchValidation(BranchModel branchModel) {
    validityBranchName = UserValidation.validateBranchName(branchModel.name);
    validityBranchAddress =
        UserValidation.validateBranchAddress(branchModel.branchAddress);
    if (validityBranchName.valid && validityBranchAddress.valid) {
      return true;
    } else
      return false;
  }

  Future<void> checkBranchName(String value) {
    validityBranchName = UserValidation.validateBranchName(value);
    // updateUserBuilder();
  }

  Future<void> checkBranchAddress(String value) {
    validityBranchAddress = UserValidation.validateBranchAddress(value);
    // updateUserBuilder();
  }

  Future<void> updateBranchBuilder() {
    update();
  }
}
