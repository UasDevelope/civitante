import 'package:get/get.dart';

class MyCommunityModel {
  final String id;
  final String name;
  final String description;
  final String image;
  final String category;
  final List<String> interests;
  final String status;
  final int totalMembers;
  final DateTime createdAt;

  MyCommunityModel({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.category,
    required this.interests,
    required this.status,
    required this.totalMembers,
    required this.createdAt,
  });

  // Factory method to create an instance from JSON with null safety
  factory MyCommunityModel.fromJson(Map<String, dynamic> json) {
    return MyCommunityModel(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Unknown',
      description:
          json['description']?.toString() ?? 'No description available',
      image: json['image']?.toString() ?? '',
      category: json['category']?.toString() ?? 'Uncategorized',
      interests: json['interests'] is List
          ? List<String>.from(json['interests'].map((e) => e.toString()))
          : [],
      status: json['status']?.toString() ?? 'Inactive',
      totalMembers: json['totalMembers'] is int
          ? json['totalMembers']
          : int.tryParse(json['totalMembers']?.toString() ?? '0') ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  // Convert the object to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'image': image,
      'category': category,
      'interests': interests,
      'status': status,
      'totalMembers': totalMembers,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
