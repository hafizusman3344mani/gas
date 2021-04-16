class DBQueries {
  //region UserEntity

  static const String findUser = 'SELECT * FROM ' + Tables.UserEntity;

  static const String deleteUser = 'DELETE FROM ' + Tables.UserEntity;


}

class Tables {
  static const String UserEntity = "UserEntity";
}
