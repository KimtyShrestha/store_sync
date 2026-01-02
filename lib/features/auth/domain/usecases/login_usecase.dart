import '../repositories/auth_repository.dart';
import '../entities/user_entity.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<UserEntity?> call(String email, String password) async {
    if (email.isEmpty || password.isEmpty) return null;

    return await repository.login(email, password);
  }
}
