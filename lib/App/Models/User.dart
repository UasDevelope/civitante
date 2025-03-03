class UserMatch {
  String name;
  String profileImage;
  int costPoints;
  bool isPro;
  Location location;
  int totalPosts;
  List<Post> posts;
  bool isFollow;
  int followersCount;
  int followingCount;
  List<Follower> followers;
  List<Follower> following;

  UserMatch({
    required this.name,
    required this.profileImage,
    required this.costPoints,
    required this.isPro,
    required this.location,
    required this.totalPosts,
    required this.posts,
    required this.isFollow,
    required this.followersCount,
    required this.followingCount,
    required this.followers,
    required this.following,
  });

  factory UserMatch.fromJson(Map<String, dynamic> json) {
    return UserMatch(
      name: json["name"] ?? "",
      profileImage: json["profileImage"] ?? "",
      costPoints: json["costPoints"] ?? 0,
      isPro: json["isPro"] ?? false,
      location: Location.fromJson(json["location"] ?? {}),
      totalPosts: json["totalPosts"] ?? 0,
      posts: (json["posts"] as List<dynamic>?)
          ?.map((e) => Post.fromJson(e))
          .toList() ??
          [],
      isFollow: json["isFollow"] ?? false,
      followersCount: json["followersCount"] ?? 0,
      followingCount: json["followingCount"] ?? 0,
      followers: (json["followers"] as List<dynamic>?)
          ?.map((e) => Follower.fromJson(e))
          .toList() ??
          [],
      following: (json["following"] as List<dynamic>?)
          ?.map((e) => Follower.fromJson(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "profileImage": profileImage,
      "costPoints": costPoints,
      "isPro": isPro,
      "location": location.toJson(),
      "totalPosts": totalPosts,
      "posts": posts.map((e) => e.toJson()).toList(),
      "isFollow": isFollow,
      "followersCount": followersCount,
      "followingCount": followingCount,
      "followers": followers.map((e) => e.toJson()).toList(),
      "following": following.map((e) => e.toJson()).toList(),
    };
  }
}

class Location {
  double long;
  double lat;
  String id;

  Location({required this.long, required this.lat, required this.id});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      long: (json["long"] ?? 0.0).toDouble(),
      lat: (json["lat"] ?? 0.0).toDouble(),
      id: json["_id"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "long": long,
      "lat": lat,
      "_id": id,
    };
  }
}

class Post {
  String id;
  String title;
  String description;
  List<String> media;
  List<String> mediaUrls;
  CreatedBy createdBy;
  String createdAt;
  int likesCount;
  int commentsCount;
  int views;
  List<Comment> comments;

  Post({
    required this.id,
    required this.title,
    required this.description,
    required this.media,
    required this.mediaUrls,
    required this.createdBy,
    required this.createdAt,
    required this.likesCount,
    required this.commentsCount,
    required this.views,
    required this.comments,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json["_id"] ?? "",
      title: json["title"] ?? "",
      description: json["description"] ?? "",
      media: List<String>.from(json["media"] ?? []),
      mediaUrls: List<String>.from(json["mediaUrls"] ?? []),
      createdBy: CreatedBy.fromJson(json["createdBy"] ?? {}),
      createdAt: json["createdAt"] ?? "",
      likesCount: json["likesCount"] ?? 0,
      commentsCount: json["commentsCount"] ?? 0,
      views: json["views"] ?? 0,
      comments: (json["comments"] as List<dynamic>?)
          ?.map((e) => Comment.fromJson(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "title": title,
      "description": description,
      "media": media,
      "mediaUrls": mediaUrls,
      "createdBy": createdBy.toJson(),
      "createdAt": createdAt,
      "likesCount": likesCount,
      "commentsCount": commentsCount,
      "views": views,
      "comments": comments.map((e) => e.toJson()).toList(),
    };
  }
}

class CreatedBy {
  String id;
  String name;

  CreatedBy({required this.id, required this.name});

  factory CreatedBy.fromJson(Map<String, dynamic> json) {
    return CreatedBy(
      id: json["_id"] ?? "",
      name: json["name"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "name": name,
    };
  }
}

class Comment {
  String id;
  String text;
  Follower user;
  String createdAt;
  int likesCount;
  int repliesCount;
  List<Comment> replies;

  Comment({
    required this.id,
    required this.text,
    required this.user,
    required this.createdAt,
    required this.likesCount,
    required this.repliesCount,
    required this.replies,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json["_id"] ?? "",
      text: json["text"] ?? "",
      user: Follower.fromJson(json["user"] ?? {}),
      createdAt: json["createdAt"] ?? "",
      likesCount: json["likesCount"] ?? 0,
      repliesCount: json["repliesCount"] ?? 0,
      replies: (json["replies"] as List<dynamic>?)
          ?.map((e) => Comment.fromJson(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "text": text,
      "user": user.toJson(),
      "createdAt": createdAt,
      "likesCount": likesCount,
      "repliesCount": repliesCount,
      "replies": replies.map((e) => e.toJson()).toList(),
    };
  }
}

class Follower {
  String id;
  String name;
  String profileImage;

  Follower({
    required this.id,
    required this.name,
    required this.profileImage,
  });

  factory Follower.fromJson(Map<String, dynamic> json) {
    return Follower(
      id: json["_id"] ?? "",
      name: json["name"] ?? "",
      profileImage: json["profileImage"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "name": name,
      "profileImage": profileImage,
    };
  }
}
