import 'package:get/get.dart';

class Post {
  final String id;
  final String title;
  final String description;
  final RxList<String> tags;
  final String category;
  final RxList<String> media;
  final RxList<String> mediaUrls;
  final CreatedBy createdBy;

  final RxInt views;
  RxInt likesCount;
  final RxInt commentsCount;
  RxBool isLikedByUser;
  RxBool isReported;
  RxBool isViewed;
  RxList<Comment> comments;
  final RxList<String> reports;
  final RxList<String> viewedBy;
  final RxList<String> block;
  final RxList<String> ratings;
  RxBool isRated;
  RxInt rate = 0.obs;

  // New Fields
  final RxList<String> savedBy; // Users who saved the post
  final RxList<String> sharedBy; // Users who shared the post
  RxBool isShared; // Whether the post has been shared by the user


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

    // New Fields
    required this.savedBy,
    required this.sharedBy,
    required this.isShared,

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

      // New Fields
      savedBy: RxList<String>((json['savedBy'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? []),
      sharedBy: RxList<String>((json['sharedBy'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? []),
      isShared: RxBool(json['isShared'] ?? false),

    );
  }
}

class CreatedBy {
  final String id;
  final String name;
  final String email;
  final String profileImage;

  // New Fields
  final String bio; // Short bio of the user
  final String phone; // Contact number

  CreatedBy({
    required this.id,
    required this.name,
    required this.email,
    required this.profileImage,
    required this.bio,
    required this.phone,
  });

  factory CreatedBy.fromJson(Map<String, dynamic> json) {
    return CreatedBy(
      id: json['_id'] ?? '',
      name: json['name'] ?? 'Unknown',
      email: json['email'] ?? '',
      profileImage: json['profileImage'] ?? '',
      bio: json['bio'] ?? '',
      phone: json['phone'] ?? '',
    );
  }
}

class Comment {
  final String id;
  final User user;
  final String text;
  final DateTime createdAt;

  RxList<String>? likes;
  RxList<Comment> replies; // Always initialized
  RxBool isCommentLikedByUser;
  RxBool? isReplyLikedByUser;

  // New Fields
  final RxInt repliesCount; // Number of replies
  RxBool isEdited; // Whether the comment has been edited


  Comment({
    required this.id,
    required this.user,
    required this.text,
    required this.createdAt,

    this.likes,
    RxList<Comment>? replies, // Now optional
    required this.isCommentLikedByUser,
     this.isReplyLikedByUser,
    required this.repliesCount,
    required this.isEdited,
  }) : replies = replies ?? RxList<Comment>(); // Ensuring replies is never null


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

      replies: RxList<Comment>((json['replies'] as List<dynamic>? ?? []).map((x) => Comment.fromJson(x)).toList()), // Ensuring replies is never null

      isCommentLikedByUser: RxBool(json['isCommentLikedByUser'] ?? false),
      isReplyLikedByUser: RxBool(json['isReplyLikedByUser'] ?? false),
      repliesCount: RxInt(json['repliesCount'] ?? 0),
      isEdited: RxBool(json['isEdited'] ?? false),
    );
  }
}


class User {
  final String id;
  final String name;
  final String? email;
  final String? profileImage;

  // New Fields
  final String? status; // User's status message
  final DateTime? lastSeen; // Last seen timestamp

  User({
     this.id="",
    required this.name,
    this.email,
    this.profileImage,
    this.status,
    this.lastSeen,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'],
      profileImage: json['profileImage'],
      status: json['status'] ?? '',
      lastSeen: json['lastSeen'] != null ? DateTime.tryParse(json['lastSeen']) : null,
    );
  }
}
