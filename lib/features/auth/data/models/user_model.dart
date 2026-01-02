import 'package:hive/hive.dart';
import '../../domain/entities/user_entity.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends UserEntity {
  @override
  @HiveField(0)
  final String userId;

  @override
  @HiveField(1)
  final String fullName;

  @override
  @HiveField(2)
  final String email;

  @override
  @HiveField(3)
  final String phoneNumber;

  @override
  @HiveField(4)
  final String password;

  UserModel({
    required this.userId,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.password,
  }) : super(
          userId: userId,
          fullName: fullName,
          email: email,
          phoneNumber: phoneNumber,
          password: password
        );

  UserEntity toEntity() {
    return UserEntity(
      userId: userId,
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
      password: password,
    );
  }
}