class UserEntity {
  final String? id;
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final String role;
  final String? token; // only available after login

  const UserEntity({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.role,
    this.token,
  });
}
