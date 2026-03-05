class UserEntity {
  final String id;
  final String email;
  final String role;
  final String status;

  final String? firstName;
  final String? lastName;
  final String? ownerId;
  final String? profileImage;

  final String? token; // only set after login

  const UserEntity({
    required this.id,
    required this.email,
    required this.role,
    required this.status,
    this.firstName,
    this.lastName,
    this.ownerId,
    this.profileImage,
    this.token,
  });

  UserEntity copyWith({
    String? id,
    String? email,
    String? role,
    String? status,
    String? firstName,
    String? lastName,
    String? ownerId,
    String? profileImage,
    String? token,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      role: role ?? this.role,
      status: status ?? this.status,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      ownerId: ownerId ?? this.ownerId,
      profileImage: profileImage ?? this.profileImage,
      token: token ?? this.token,
    );
  }
}