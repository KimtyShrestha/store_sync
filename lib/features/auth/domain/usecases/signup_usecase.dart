import '../repositories/auth_repository.dart';
import '../entities/user_entity.dart';

class SignupUseCase {
  final AuthRepository repository;

  SignupUseCase(this.repository);

  Future<UserEntity?> call(String fullName, String email, String phone, String password) async {
    
    // Validate fields
    if (fullName.isEmpty || email.isEmpty || phone.isEmpty || password.isEmpty) {
      return null;
    }

    return await repository.signup(fullName, email, phone, password);
  }
}
