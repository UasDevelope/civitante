import 'package:get/get.dart';

class MyCommunityModel {
  final String id;
  final String name;
  final String image;
  final String category;
  final List<String> interests;
  final String status;
  final int totalMembers;
  final DateTime createdAt;

  MyCommunityModel({
    required this.id,
    required this.name,
    required this.image,
    required this.category,
    required this.interests,
    required this.status,
    required this.totalMembers,
    required this.createdAt,
  });

  // Factory method to create an instance from JSON
  factory MyCommunityModel.fromJson(Map<String, dynamic> json) {
    return MyCommunityModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      category: json['category'] ?? '',
      interests: List<String>.from(json['interests'] ?? []),
      status: json['status'] ?? '',
      totalMembers: json['totalMembers'] ?? 0,
      createdAt:
          DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  // Convert the object to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'image': image,
      'category': category,
      'interests': interests,
      'status': status,
      'totalMembers': totalMembers,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
