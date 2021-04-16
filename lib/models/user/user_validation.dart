import 'package:gas_station/common/exception_codes_messages.dart';
import 'package:gas_station/common/models/validity_model.dart';


class UserValidation {

  static ValidityModel validateFirstName(String value) {
    var model = ValidityModel();
    if (value == null || value.isEmpty) {
      model.message = Exceptions.EMPTY_ERROR;
      model.valid = false;
    } else {
      model.message = '';
      model.valid = true;
    }
    return model;
  }
  static ValidityModel validateLastName(String value) {
    var model = ValidityModel();
    if (value == null || value.isEmpty) {
      model.message = Exceptions.EMPTY_ERROR;
      model.valid = false;
    } else {
      model.message = '';
      model.valid = true;
    }
    return model;
  }
  static ValidityModel validateBranchName(String value) {
    var model = ValidityModel();
    if (value == null || value.isEmpty) {
      model.message = Exceptions.EMPTY_ERROR;
      model.valid = false;
    } else {
      model.message = '';
      model.valid = true;
    }
    return model;
  }
  static ValidityModel validateCityName(String value) {
    var model = ValidityModel();
    if (value == null || value.isEmpty) {
      model.message = Exceptions.EMPTY_ERROR;
      model.valid = false;
    } else {
      model.message = '';
      model.valid = true;
    }
    return model;
  }
  static ValidityModel validateNotificationName(String value) {
    var model = ValidityModel();
    if (value == null || value.isEmpty) {
      model.message = Exceptions.EMPTY_ERROR;
      model.valid = false;
    } else {
      model.message = '';
      model.valid = true;
    }
    return model;
  }
  static ValidityModel validateBranchAddress(String value) {
    var model = ValidityModel();
    if (value == null || value.isEmpty) {
      model.message = Exceptions.EMPTY_ERROR;
      model.valid = false;
    } else {
      model.message = '';
      model.valid = true;
    }
    return model;
  }

  static ValidityModel validateNoOfQuestion(String value) {
    var model = ValidityModel();
    if (value == null || value.isEmpty) {
      model.message = Exceptions.EMPTY_ERROR;
      model.valid = false;
    } else {
      model.message = '';
      model.valid = true;
    }
    return model;
  }



  static ValidityModel validateUsername(String value) {
    var model = ValidityModel();
    if (value == null || value.isEmpty) {
      model.message = Exceptions.EMPTY_ERROR;
      model.valid = false;
    } else {
      model.message = '';
      model.valid = true;
    }
    return model;
  }

  static ValidityModel validateUserEmail(String value) {
    var model = ValidityModel();
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value);
    if (value == null || value.isEmpty) {
      model.message = Exceptions.EMPTY_ERROR;
      model.valid = false;
    } else if (!emailValid) {
      model.message = Exceptions.INVALID_EMAIL;
      model.valid = false;
    } else {
      model.message = '';
      model.valid = true;
    }
    return model;
  }

  static ValidityModel validateUserPassword(String value) {
    var model = ValidityModel();
    if (value == null || value.isEmpty) {
      model.message = Exceptions.EMPTY_ERROR;
      model.valid = false;
    } else if (value.length < 4) {
      model.message = Exceptions.PASWWORD_LENGTH_ERROR;
      model.valid = false;
    } else {
      model.message = '';
      model.valid = true;
    }
    return model;
  }

  static ValidityModel validateCountry(String value) {
    var model = ValidityModel();
    if (value == null || value.isEmpty) {
      model.message = Exceptions.EMPTY_ERROR;
      model.valid = false;
    } else {
      model.message = '';
      model.valid = true;
    }
    return model;
  }

  static ValidityModel validateTimezone(String value) {
    var model = ValidityModel();
    if (value == null || value.isEmpty) {
      model.message = Exceptions.EMPTY_ERROR;
      model.valid = false;
    } else {
      model.message = '';
      model.valid = true;
    }
    return model;
  }

  static ValidityModel validatePhone(String value) {
    var model = ValidityModel();
    if (value == null || value.isEmpty) {
      model.message = Exceptions.EMPTY_ERROR;
      model.valid = false;
    } else {
      model.message = '';
      model.valid = true;
    }
    return model;
  }
  static ValidityModel validateEmployeeNumber(String value) {
    var model = ValidityModel();
    if (value == null || value.isEmpty) {
      model.message = Exceptions.EMPTY_ERROR;
      model.valid = false;
    } else {
      model.message = '';
      model.valid = true;
    }
    return model;
  }
  static ValidityModel validateManagerNumber(String value) {
    var model = ValidityModel();
    if (value == null || value.isEmpty) {
      model.message = Exceptions.EMPTY_ERROR;
      model.valid = false;
    } else {
      model.message = '';
      model.valid = true;
    }
    return model;
  }

  static ValidityModel validateOtpCode(String value) {
    var model = ValidityModel();
    if (value == null || value.isEmpty) {
      model.message = Exceptions.EMPTY_ERROR;
      model.valid = false;
    } else {
      model.message = '';
      model.valid = true;
    }
    return model;
  }
}
