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
  final RxList<String> reports; // New field for reports
  final RxList<String> viewedBy; // New field for viewedBy
  final RxList<String> block; // New field for blocked users
  final RxList<String> ratings; // New field for ratings
  RxBool isRated; // New field for isRated
  RxInt rate; // New field for rate

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
    required this.reports,
    required this.viewedBy,
    required this.block,
    required this.ratings,
    required this.isRated,
    required this.rate,
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
      reports: RxList<String>((json['reports'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          []),
      viewedBy: RxList<String>((json['viewedBy'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          []),
      block: RxList<String>((json['block'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          []),
      ratings: RxList<String>((json['ratings'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          []),
      isRated: RxBool(json['isRated'] ?? false),
      rate: RxInt(json['rate'] ?? 0),
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
  final DateTime createdAt;
  RxList<String>? likes; // Made optional
  RxList<Comment>? replies; // Made optional
  final RxBool isCommentLikedByUser;

  Comment({
    required this.id,
    required this.user,
    required this.text,
    required this.createdAt,
    this.likes, // Optional
    this.replies, // Optional
    required this.isCommentLikedByUser,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['_id'] ?? '',
      user: User.fromJson(json['user'] ?? {}),
      text: json['text'] ?? '',
      createdAt:
          DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      likes: json['likes'] != null
          ? RxList<String>((json['likes'] as List<dynamic>)
              .map((e) => e.toString())
              .toList())
          : null,
      replies: json['replies'] != null
          ? RxList<Comment>((json['replies'] as List<dynamic>)
              .map((x) => Comment.fromJson(x))
              .toList())
          : null,
      isCommentLikedByUser: RxBool(json['isCommentLikedByUser'] ?? false),
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
