
import 'package:floor/floor.dart';
import 'package:gas_station/db/entities/user_entity.dart';
import 'package:gas_station/db/queries.dart';
import 'package:gas_station/models/user/user_model.dart';

@dao
abstract class UserDao {

  // @Query(DBQueries.findUser)
  // Future<List<UserModel>> findUser();

  @insert
  Future<void> insertUserModel(UserModel user);

  //
  // @Query(DBQueries.deleteUser)
  // Future<void> deleteUser();
}