import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/local/auth_local_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl(this.localDataSource);

  @override
Future<UserEntity?> signup(
    String fullName,
    String email,
    String phone,
    String password) async {

  final existing = await localDataSource.getUser();

  if (existing != null && existing.email == email) {
    throw Exception("User already exists");
  }

  final user = UserModel(
    userId: DateTime.now().millisecondsSinceEpoch.toString(),
    fullName: fullName,
    email: email,
    phoneNumber: phone,
    password: password,
  );

  await localDataSource.saveUser(user);

  return user.toEntity();
}

  @override
  Future<UserEntity?> login(String email, String password) async {
    final saved = await localDataSource.getUser();

    if (saved == null) return null;

    if (saved.email == email && saved.password == password) {
      return saved.toEntity();
    }

    return null;
  }

 @override
Future<void> logout() async {
  // DO NOT delete stored user
}

}
