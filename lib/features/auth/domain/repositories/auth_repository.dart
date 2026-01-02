import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity?> signup(
    String fullName,
    String email,
    String phone,
    String password,
  );

  Future<UserEntity?> login(String email, String password);

  Future<void> logout();
}
