


import 'dart:convert';

PostResponse postsResponseFromJson(String str) => PostResponse.fromJson(json.decode(str));

String postsResponseToJson(PostResponse data) => json.encode(data.toJson());

class PostResponse {
  PostResponse({
    this.data,
    this.status,
  });

  List<Post> data;
  var status;

  factory PostResponse.fromJson(Map<String, dynamic> json) => PostResponse(
    data: List<Post>.from(json["data"]["posts"].map((x) => Post.fromJson(x))),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "status": status,
  };
}

class Post {
  Post({
    this.id,
    this.type,
    this.user_name,
    this.avatar,
    this.content,
    this.photo,
    this.video,
    this.created_at,
    this.likes,
  });

  int id;
  String type;
  String user_name;
  String avatar;
  String content;
  String photo;
  String video;
  String created_at;
  int likes;

  factory Post.fromJson(Map<String, dynamic> json) => Post(
    id: json["id"],
    type: json["type"],
    user_name: json["user_name"],
    avatar: json["avatar"],
    content: json["content"],
    photo: json["photo"],
    video: json["video"],
    created_at: json["created_at"],
    likes: json["likes"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "user_name": user_name,
    "avatar": avatar,
    "content": content,
    "photo": photo,
    "video": video,
    "created_at": created_at,
    "likes": likes,
  };
}
