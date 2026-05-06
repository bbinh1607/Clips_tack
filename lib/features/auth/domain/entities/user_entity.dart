class UserEntity {
  final String id;
  final String? email;
  final String? name;
  final String? password;
  final String? avatarUrl;
  final String? username;

  const UserEntity({
    required this.id,
    required this.email,
    this.name,
    this.avatarUrl,
    this.username,
    this.password,
  });
}
