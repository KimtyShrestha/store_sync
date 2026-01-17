import '../repositories/auth_repository.dart';
import '../entities/user_entity.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<UserEntity?> call(String email, String password) async {

    // Basic validation
    if (email.isEmpty || password.isEmpty) {
      throw Exception("Email and password are required");
    }

    return await repository.login(email, password);
  }
}
