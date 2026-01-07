import '../../domain/entities/auth_user.dart';

class AuthUserModel {
  final String id;
  final String email;
  final String name;
  final String? phoneNumber;
  final String? photoUrl;

  const AuthUserModel({
    required this.id,
    required this.email,
    required this.name,
    this.phoneNumber,
    this.photoUrl,
  });

  AuthUser toEntity() {
    return AuthUser(
      id: id,
      email: email,
      name: name,
      phoneNumber: phoneNumber,
      photoUrl: photoUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'name': name,
      'phoneNumber': phoneNumber,
      'photoUrl': photoUrl,
    };
  }

  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    return AuthUserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      photoUrl: json['photoUrl'] as String?,
    );
  }
}
