import 'package:hive/hive.dart';
import '../../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> saveUser(UserModel user);
  Future<UserModel?> getUser();
  Future<void> clearUser();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  static const String userBoxName = "userBox";

  @override
  Future<void> saveUser(UserModel user) async {
    final box = await Hive.openBox<UserModel>(userBoxName);
    await box.put('currentUser', user);
  }

  @override
  Future<UserModel?> getUser() async {
    final box = await Hive.openBox<UserModel>(userBoxName);
    return box.get('currentUser');
  }

  @override
  Future<void> clearUser() async {
    final box = await Hive.openBox<UserModel>(userBoxName);
    await box.delete('currentUser');
  }
}
