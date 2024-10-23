import 'dart:convert';

FinishedCounterResponse finishedCounterResponseFromJson(String str) => FinishedCounterResponse.fromJson(json.decode(str));

String finishedCounterResponseToJson(FinishedCounterResponse data) => json.encode(data.toJson());

class FinishedCounterResponse {
  FinishedCounterResponse({
     this.success,
     this.message,
  });

  bool success;
  String message;

  factory FinishedCounterResponse.fromJson(Map<String, dynamic> json) => FinishedCounterResponse(
    success: json["success"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message" : message
  };


}
