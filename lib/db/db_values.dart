import 'package:gas_station/db/entities/user_entity.dart';

class DBValues {
  UserEntity _userDao;
  bool _userValue;

  DBValues._privateConstructor();

  static final DBValues instance = DBValues._privateConstructor();

  setUserEntity(UserEntity entity) {
    _userDao = entity;
  }

  setUserValue(bool value) {
    _userValue = value;
  }

  bool getUserValue() {
    if (_userValue == null) {
      _userValue = false;
    }
    return _userValue;
  }

  UserEntity getUserEntity() {
    if (_userDao == null) {
      _userDao = UserEntity.fromEntity();
      // _userDao.IsDarkTheme=false;
    }
    return _userDao;
  }
}
