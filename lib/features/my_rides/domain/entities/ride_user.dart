class RideUser {
  final String id;
  final String name;
  final bool isVerified;

  const RideUser({
    required this.id,
    required this.name,
    this.isVerified = false,
  });
}
