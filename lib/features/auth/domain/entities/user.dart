import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String? name; // Optional, as per PRD "Profile Summary: Display user data (name, email, avatar)"
  final String? avatarUrl; // Optional

  const User({
    required this.id,
    required this.email,
    this.name,
    this.avatarUrl,
  });

  @override
  List<Object?> get props => [id, email, name, avatarUrl];
}
