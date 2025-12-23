class AuthUser {
  final String id;
  final String email;
  final String name;
  final String? phoneNumber;
  final String? photoUrl;

  const AuthUser({
    required this.id,
    required this.email,
    required this.name,
    this.phoneNumber,
    this.photoUrl,
  });
}