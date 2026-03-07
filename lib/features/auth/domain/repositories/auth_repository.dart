import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity?> signup(
    String firstName,
    String lastName,
    String email,
    String password,
  );

  Future<UserEntity?> login(
    String email,
    String password,
  );

  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  );

  Future<void> logout();
}