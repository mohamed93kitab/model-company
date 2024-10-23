import 'dart:convert';

SignupResponse signupResponseFromJson(String str) => SignupResponse.fromJson(json.decode(str));

String signupResponseToJson(SignupResponse data) => json.encode(data.toJson());

class SignupResponse {
  SignupResponse({
     this.success,
     this.message,
     this.user_id
  });

  bool success;
  var message;
  var user_id;

  factory SignupResponse.fromJson(Map<String, dynamic> json) => SignupResponse(
    success: json["success"],
    message: json["message"],
    user_id: json["user_id"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "user_id": user_id,
  };
}