import 'package:flutter_test/flutter_test.dart';
import 'package:store_sync/features/auth/presentation/providers/auth_provider.dart';
import 'package:store_sync/features/auth/domain/entities/user_entity.dart';

void main() {

  final user = UserEntity(
    id: "1",
    firstName: "Test",
    lastName: "User",
    email: "test@mail.com",
    role: "manager",
    status: "active",
    profileImage: null,
  );

  test("AuthState initializes correctly", () {
    final state = AuthState(user: user);

    expect(state.user!.email, "test@mail.com");
  });

  test("copyWith updates loading", () {
    final state = AuthState(user: user);

    final updated = state.copyWith(isLoading: true);

    expect(updated.isLoading, true);
  });

  test("copyWith updates error", () {
    final state = AuthState(user: user);

    final updated = state.copyWith(error: "error");

    expect(updated.error, "error");
  });

  test("profile image update works", () {
    final updatedUser = user.copyWith(profileImage: "img.jpg");

    expect(updatedUser.profileImage, "img.jpg");
  });

  test("user full name correct", () {
    final fullName = "${user.firstName} ${user.lastName}";

    expect(fullName, "Test User");
  });
}