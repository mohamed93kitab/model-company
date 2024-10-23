



import 'dart:convert';

UserResponse usersResponseFromJson(String str) => UserResponse.fromJson(json.decode(str));

String usersResponseToJson(UserResponse data) => json.encode(data.toJson());

class UserResponse {
  UserResponse({
     this.data,
     this.status,
  });

  List<User> data;
  bool status;

  factory UserResponse.fromJson(Map<String, dynamic> json) => UserResponse(
    data: List<User>.from(json["data"].map((x) => User.fromJson(x))),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "status": status,
  };
}

class User {
  User({
     this.id,
     this.name,
     this.photo,
     this.username,
     this.request_id,
     this.created_at,
  });

  int id;
  String name;
  String photo;
  String username;
  var request_id;
  String created_at;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    photo: json["photo"],
    username: json["username"],
    request_id: json["request_id"],
    created_at: json["created_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "photo": photo,
    "username": username,
    "request_id": request_id,
    "created_at": created_at,
  };
}
