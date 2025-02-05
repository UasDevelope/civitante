import 'package:get/get.dart';

class Post {
  final String id;
  final String title;
  final String description;
  final RxList<String> tags; // Using RxList for tags
  final String category;
  final RxList<String> media; // Using RxList for media
  final RxList<String> mediaUrls; // Using RxList for mediaUrls
  final CreatedBy createdBy;
  final RxInt views; // Reactive views count
  RxInt likesCount; // Using RxInt for likesCount
  final RxInt commentsCount; // Using RxInt for commentsCount
  RxBool isLikedByUser; // Using RxBool for isLikedByUser
  RxBool isReported; // Using RxBool for isReported
  RxBool isViewed; // Using RxBool for isViewed
  RxList<Comment> comments; // Using RxList for comments

  Post({
    required this.id,
    required this.title,
    required this.description,
    required this.tags,
    required this.category,
    required this.media,
    required this.mediaUrls,
    required this.createdBy,
    required this.views,
    required this.likesCount,
    required this.commentsCount,
    required this.isLikedByUser,
    required this.isReported,
    required this.isViewed,
    required this.comments,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['_id'] ?? '',
      title: json['title'] ?? 'Untitled',
      description: json['description'] ?? '',
      tags: RxList<String>(
          (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
              []),
      category: json['category'] ?? '',
      media: RxList<String>((json['media'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          []),
      mediaUrls: RxList<String>((json['mediaUrls'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          []),
      createdBy: CreatedBy.fromJson(json['createdBy'] ?? {}),
      views: RxInt(json['views'] ?? 0),
      likesCount: RxInt(json['likesCount'] ?? 0),
      commentsCount: RxInt(json['commentsCount'] ?? 0),
      isLikedByUser: RxBool(json['isLikedByUser'] ?? false),
      isReported: RxBool(json['isReported'] ?? false),
      isViewed: RxBool(json['isViewed'] ?? false),
      comments: RxList<Comment>((json['comments'] as List<dynamic>?)
              ?.map((x) => Comment.fromJson(x))
              .toList() ??
          []),
    );
  }
}

class CreatedBy {
  final String id;
  final String name;
  final String email;
  final String profileImage;

  CreatedBy({
    required this.id,
    required this.name,
    required this.email,
    required this.profileImage,
  });

  factory CreatedBy.fromJson(Map<String, dynamic> json) {
    return CreatedBy(
      id: json['_id'] ?? '',
      name: json['name'] ?? 'Unknown',
      email: json['email'] ?? '',
      profileImage: json['profileImage'] ?? '',
    );
  }
}

class Comment {
  final String id;
  final User user;
  final String text;
  // Using RxList for likes
  final DateTime createdAt;
  // Using RxList for replies

  Comment({
    required this.id,
    required this.user,
    required this.text,
    required this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['_id'] ?? '',
      user: User.fromJson(json['user'] ?? {}),
      text: json['text'] ?? '',
      // likes: RxList<String>(List<String>.from(json['likes']?.map((x) => x.toString()) ?? [])),
      createdAt:
          DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      // replies: RxList<Comment>((json['replies'] as List<dynamic>?)?.map((x) => Comment.fromJson(x)).toList() ?? []),
    );
  }
}

class User {
  final String id;
  final String name;
  final String? email;
  final String? profileImage;

  User({
    required this.id,
    required this.name,
    this.email,
    this.profileImage,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'],
      profileImage: json['profileImage'],
    );
  }
}
