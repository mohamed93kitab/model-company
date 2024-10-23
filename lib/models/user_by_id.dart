// To parse this JSON data, do
//
//     final userByTokenResponse = userByTokenResponseFromJson(jsonString);

import 'dart:convert';

UserByIdResponse userByIdResponseFromJson(String str) => UserByIdResponse.fromJson(json.decode(str));

String userByIdResponseToJson(UserByIdResponse data) => json.encode(data.toJson());

class UserByIdResponse {
  UserByIdResponse({
     this.result,
     this.id,
     this.name,
     this.email,
     this.username,
     this.avatar,
     this.phone,
     this.points,
     this.stars,
     this.role_name,
     this.frame,
     this.verified,
     this.created_at,
  });

  bool result;
  int id;
  String name;
  var email;
  String username;
  var avatar;
  var frame;
  String phone;
  String role_name;
  String verified;
  String created_at;
  int points;
  int stars;

  factory UserByIdResponse.fromJson(Map<String, dynamic> json) => UserByIdResponse(
    result: json["result"] == null ? null : json["result"],
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    username: json["username"] == null ? null : json["username"],
    email: json["email"] == null ? null : json["email"],
    avatar: json["avatar"] == null ? null : json["avatar"],
    frame: json["frame"] == null ? null : json["frame"],
    phone: json["phone"] == null ? null : json["phone"],
    points: json["points"] == null ? null : json["points"],
    stars: json["stars"] == null ? null : json["stars"],
    role_name: json["role_name"] == null ? null : json["role_name"],
    verified: json["verified"] == null ? null : json["verified"],
    created_at: json["created_at"] == null ? null : json["created_at"],
  );

  Map<String, dynamic> toJson() => {
    "result": result == null ? null : result,
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "username": username == null ? null : username,
    "email": email == null ? null : email,
    "avatar": avatar == null ? null : avatar,
    "frame": frame == null ? null : frame,
    "phone": phone == null ? null : phone,
    "points": points == null ? null : points,
    "stars": stars == null ? null : stars,
    "role_name": role_name == null ? null : role_name,
    "verified": verified == null ? null : verified,
    "created_at": created_at == null ? null : created_at,
  };
}