
import 'dart:async';

import 'package:floor/floor.dart';
import 'package:gas_station/common/constants.dart';
import 'package:gas_station/db/dao/user_dao.dart';
import 'package:gas_station/db/entities/user_entity.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

// part 'app_database.g.dart'; // the generated code will be there

@Database(version: Constants.DATABASE_VERSION, entities: [UserEntity])
abstract class AppDatabase extends FloorDatabase {
  UserDao get userDao;

}