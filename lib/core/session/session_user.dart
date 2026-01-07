class SessionUser {
  final String id;
  final String? email;
  final String? phone;
  final String? displayName;

  const SessionUser({
    required this.id,
    this.email,
    this.phone,
    this.displayName,
  });
}

