import 'dart:convert';

CounterResponse counterResponseFromJson(String str) => CounterResponse.fromJson(json.decode(str));

String counterResponseToJson(CounterResponse data) => json.encode(data.toJson());

class CounterResponse {
  CounterResponse({
     this.data,
     this.success,
     this.message,
  });

  List<Counter> data;
  bool success;
  String message;

  factory CounterResponse.fromJson(Map<String, dynamic> json) => CounterResponse(
    data: List<Counter>.from(json["data"].map((x) => Counter.fromJson(x))),
    success: json["success"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "success": success,
  };
}

class Counter {
  Counter({
     this.id,
     this.duration,
     this.name,
     this.price,
     this.gift,
     this.created_at,
     this.expired_at,
  });

  int id;
  int price;
  int gift;
  String duration;
  String name;
  String created_at;
  String expired_at;

  factory Counter.fromJson(Map<String, dynamic> json) => Counter(
    id: json["id"],
    duration: json["duration"],
    name: json["name"],
    price: json["price"],
    gift: json["gift"],
    created_at: json["created_at"],
    expired_at: json["expired_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "duration": duration,
    "name": name,
    "price": price,
    "gift": gift,
    "created_at": created_at,
    "expired_at": expired_at,
  };
}
