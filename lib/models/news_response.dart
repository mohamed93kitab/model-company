

import 'dart:convert';

NewsResponse newsResponseFromJson(String str) => NewsResponse.fromJson(json.decode(str));

String newsResponseToJson(NewsResponse data) => json.encode(data.toJson());

class NewsResponse {
  NewsResponse({
     this.data,
     this.status,
  });

  List<News> data;
  bool status;

  factory NewsResponse.fromJson(Map<String, dynamic> json) => NewsResponse(
    data: List<News>.from(json["data"].map((x) => News.fromJson(x))),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "status": status,
  };
}

class News {
  News({
     this.id,
     this.title,
     this.content,
     this.photo,
     this.created_at,
     this.likes,
  });

  int id;
  String title;
  String content;
  String photo;
  String created_at;
  int likes;

  factory News.fromJson(Map<String, dynamic> json) => News(
    id: json["id"],
    title: json["title"],
    content: json["content"],
    photo: json["photo"],
    created_at: json["created_at"],
    likes: json["likes"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "content": content,
    "photo": photo,
    "created_at": created_at,
    "likes": likes,
  };
}
