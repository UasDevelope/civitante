class Post {
  final String id;
  final String title;
  final String description;
  final List<String> tags;
  final String category;
  final List<String> media;
  final List<String> mediaUrls;
  final CreatedBy createdBy;
  final int views;
  final int likesCount;
  final int commentsCount;
  final bool isLikedByUser;
  final List<Comment> comments;


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
    required this.comments,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['_id'] ?? '',
      title: json['title'] ?? 'Untitled',
      description: json['description'] ?? '',
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      category: json['category'] ?? '',
      media: (json['media'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      mediaUrls: (json['mediaUrls'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      createdBy: CreatedBy.fromJson(json['createdBy'] ?? {}),
      views: json['views'] ?? 0,
      likesCount: json['likesCount'] ?? 0,
      commentsCount: json['commentsCount'] ?? 0,
      isLikedByUser: json['isLikedByUser'] ?? false,
      comments: (json['comments'] as List<dynamic>?)
          ?.map((x) => Comment.fromJson(x))
          .toList() ??
          [],
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
  final List<String> likes;
  final DateTime createdAt;
  final List<Comment> replies;

  Comment({
    required this.id,
    required this.user,
    required this.text,
    required this.likes,
    required this.createdAt,
    required this.replies,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['_id'] ?? '',
      user: User.fromJson(json['user'] ?? {}),
      text: json['text'] ?? '',
      likes: List<String>.from(json['likes']?.map((x) => x.toString()) ?? []),
      createdAt: DateTime.parse(
          json['createdAt'] ?? DateTime.now().toIso8601String()),
      replies: (json['replies'] as List<dynamic>?)
          ?.map((x) => Comment.fromJson(x))
          .toList() ??
          [],
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
