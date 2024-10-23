import 'dart:convert';

SubscribesPointsResponse subscribesPointsResponseFromJson(String str) => SubscribesPointsResponse.fromJson(json.decode(str));

String subscribesPointsResponseToJson(SubscribesPointsResponse data) => json.encode(data.toJson());

class SubscribesPointsResponse {
  SubscribesPointsResponse({
    this.success,
    this.message,
    this.user_id,
  });

  bool success;
  String message;
  var user_id;

  factory SubscribesPointsResponse.fromJson(Map<String, dynamic> json) => SubscribesPointsResponse(
    success: json["success"],
    message: json["message"],
    user_id: json["user_id"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message" : message,
    "user_id" : user_id,
  };


}
