// Post Model (unchanged)
class Post {
  final String id;
  final String communityId;

  final String title;
  final String description;
  final List<String> tags;
  final String category;
  final List<String> mediaUrls;
  final CreatedBy createdBy;
  final List<Comment> comments;
  final List<String> likes;
  final int views;
  final DateTime createdAt;

  Post({
    required this.id,
    required this.communityId,
    required this.title,
    required this.description,
    required this.tags,
    required this.category,
    required this.mediaUrls,
    required this.createdBy,
    required this.comments,
    required this.likes,
    required this.views,
    required this.createdAt,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['_id'] ?? '',
      communityId: json['communityId'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
      category: json['category'] ?? '',
      mediaUrls: List<String>.from(json['mediaUrls'] ?? []),
      createdBy: CreatedBy.fromJson(json['createdBy'] ?? {}),
      comments: (json['comments'] as List<dynamic>?)
              ?.map((x) => Comment.fromJson(x))
              .toList() ??
          [],
      likes: List<String>.from(json['likes'] ?? []),
      views: json['views'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

// CreatedBy Model (unchanged)
class CreatedBy {
  final String id;
  final String email;
  final String name;
  final String profileImage;

  CreatedBy({
    required this.id,
    required this.email,
    required this.name,
    this.profileImage = '',
  });

  factory CreatedBy.fromJson(Map<String, dynamic> json) {
    return CreatedBy(
      id: json['_id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      profileImage: json['profileImage'] ?? '',
    );
  }
}

// Comment Model (FIXED)
class Comment {
  final String id;
  final String text;
  final DateTime createdAt;
  final String userId; // Changed from CommentUser to String
  final List<Comment> replies;
  final List<String> likes;

  Comment({
    required this.id,
    required this.text,
    required this.createdAt,
    required this.userId, // Now expects a user ID string
    required this.replies,
    required this.likes,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['_id'] ?? '',
      text: json['text'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      userId: json['user'] ?? '', // Directly read the user ID string
      replies: (json['replies'] as List<dynamic>?)
              ?.map((x) => Comment.fromJson(x))
              .toList() ??
          [],
      likes: List<String>.from(json['likes'] ?? []),
    );
  }

  String get timeAgo {
    final difference = DateTime.now().difference(createdAt);
    if (difference.inDays > 365) return '${(difference.inDays / 365).floor()}y';
    if (difference.inDays > 30) return '${(difference.inDays / 30).floor()}mo';
    if (difference.inDays > 0) return '${difference.inDays}d';
    if (difference.inHours > 0) return '${difference.inHours}h';
    if (difference.inMinutes > 0) return '${difference.inMinutes}m';
    return 'Just now';
  }
}
