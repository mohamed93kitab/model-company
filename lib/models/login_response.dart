import 'dart:convert';

LoginResponse loginResponseFromJson(String str) => LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  LoginResponse({
     this.success,
     this.message,
     this.user_id,
     this.data,
  });

  bool success;
  String message;
  String user_id;
  User data;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    success: json["success"],
    message: json["message"],
    user_id: json["user_id"] == null ? null : json["access_token"],
    data: json["data"] == null ? null : User.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "user_id": user_id,
    "data": data == null ? null : data?.toJson(),
  };
}

class User {
  User({
     this.id,
     this.role_name,
     this.name,
     this.username,
     this.phone_number,
     this.photo,
     this.notification_id,
     this.token,
     this.points,
     this.stars,
     this.verified_account,
  });

  int id;
  String role_name;
  String name;
  String username;
  String phone_number;
  var photo;
  var notification_id;
  var points;
  var stars;
  var token;
  var verified_account;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    role_name: json["role_name"],
    name: json["name"],
    username: json["username"],
    photo: json["photo"],
    notification_id: json["notification_id"],
    phone_number: json["phone_number"],
    token: json["token"] == null ? null : json["token"],
    points: json["points"],
    stars: json["stars"],
    verified_account: json["verified_account"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "role_name": role_name,
    "name": name,
    "username": username,
    "notification_id": notification_id,
    "photo": photo,
    "phone_number": phone_number,
    "token": token,
    "points": points,
    "stars": stars,
    "verified_account": verified_account,
  };
}