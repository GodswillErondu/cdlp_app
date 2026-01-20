import '../../domain/entities/user.dart';

class UserModel extends User {
  final String? token;

  const UserModel({
    required super.id,
    required super.email,
    super.name,
    super.avatarUrl,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(),
      email: json['email'] as String,
      name: '${json['firstName'] ?? ''} ${json['lastName'] ?? ''}'.trim(),
      avatarUrl: json['image'] as String?,
      token: (json['accessToken'] ?? json['token']) as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'avatarUrl': avatarUrl,
      'token': token,
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? avatarUrl,
    String? token,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      token: token ?? this.token,
    );
  }
}
