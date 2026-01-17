import '../repositories/auth_repository.dart';
import '../entities/user_entity.dart';

class SignupUseCase {
  final AuthRepository repository;

  SignupUseCase(this.repository);

  Future<UserEntity?> call(
    String firstName,
    String lastName,
    String username,
    String email,
    String password,
  ) async {
    
    if (firstName.isEmpty ||
        lastName.isEmpty ||
        username.isEmpty ||
        email.isEmpty ||
        password.isEmpty) {
      throw Exception("All fields are required");
    }

    return await repository.signup(
      firstName,
      lastName,
      username,
      email,
      password,
    );
  }
}
