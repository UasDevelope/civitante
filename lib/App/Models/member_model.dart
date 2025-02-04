import 'package:get/get.dart';

class NonMemberUser {
  final String id;
  final String profileImage;
  final String email;
  final String name;
  final int costPoints;

  NonMemberUser({
    required this.id,
    required this.profileImage,
    required this.email,
    required this.name,
    required this.costPoints,
  });

  // Factory method to create an instance from JSON
  factory NonMemberUser.fromJson(Map<String, dynamic> json) {
    return NonMemberUser(
      id: json['_id'] ?? '',
      profileImage: json['profileImage'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      costPoints: json['costPoints'] ?? 0,
    );
  }

  // Convert the object to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'profileImage': profileImage,
      'email': email,
      'costPoints': costPoints,
    };
  }
}
