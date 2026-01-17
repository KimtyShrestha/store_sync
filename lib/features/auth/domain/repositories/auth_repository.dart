import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity?> signup(
    String firstName,
    String lastName,
    String username,
    String email,
    String password,
  );

  Future<UserEntity?> login(String email, String password);

  Future<void> logout();
}
