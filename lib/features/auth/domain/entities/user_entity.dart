class UserEntity {
  final String? userId;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String password;

  const UserEntity({
    this.userId,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.password,
  });
}
