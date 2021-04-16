import 'package:floor/floor.dart';

@entity
class UserEntity {
  @PrimaryKey(autoGenerate: true)
  int id;
  int PersonId;
  String UserName;
  String Password;

  UserEntity(
      this.id,
      this.PersonId,
      this.UserName,
      this.Password,
  );

  UserEntity.fromEntity();
}
