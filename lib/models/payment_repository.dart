

import 'dart:convert';

PaymentResponse paymentResponseFromJson(String str) => PaymentResponse.fromJson(json.decode(str));

String paymentResponseToJson(PaymentResponse data) => json.encode(data.toJson());

class PaymentResponse {
  PaymentResponse({
     this.data,
     this.success,
     this.message,
  });

  List<Payment> data;
  bool success;
  String message;

  factory PaymentResponse.fromJson(Map<String, dynamic> json) => PaymentResponse(
    data: List<Payment>.from(json["data"].map((x) => Payment.fromJson(x))),
    success: json["success"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "success": success,
  };
}

class Payment {
  Payment({
     this.id,
     this.user_id,
     this.username,
     this.amount,
     this.payment_method,
     this.number,
     this.status,
     this.created_at,
  });

  var id;
  var user_id;
  var username;
  var amount;
  var payment_method;
  var number;
  var status;
  var created_at;

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
    id: json["id"],
    user_id: json["user_id"],
    username: json["username"],
    amount: json["amount"],
    payment_method: json["payment_method"],
    number: json["number"],
    status: json["status"],
    created_at: json["created_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "user_id": user_id,
    "amount": amount,
    "payment_method": payment_method,
    "number": number,
    "status": status,
    "created_at": created_at,
  };
}
