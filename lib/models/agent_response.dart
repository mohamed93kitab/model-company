import 'dart:convert';

AgentResponse agentResponseFromJson(String str) => AgentResponse.fromJson(json.decode(str));

String agentResponseToJson(AgentResponse data) => json.encode(data.toJson());

class AgentResponse {
  AgentResponse({
     this.data,
     this.status,
  });

  List<Agent> data;
  bool status;

  factory AgentResponse.fromJson(Map<String, dynamic> json) => AgentResponse(
    data: List<Agent>.from(json["data"].map((x) => Agent.fromJson(x))),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "status": status,
  };
}

class Agent {
  Agent({
     this.id,
     this.name,
     this.photo,
     this.country,
     this.governorate,
     this.address,
     this.phone_number,
     this.code,
     this.username,
     this.created_at,
  });

  int id;
  String name;
  String photo;
  String country;
  String governorate;
  String address;
  var phone_number;
  var username;
  var code;
  String created_at;

  factory Agent.fromJson(Map<String, dynamic> json) => Agent(
    id: json["id"],
    name: json["name"],
    governorate: json["governorate"],
    address: json["address"],
    country: json["country"],
    phone_number: json["phone_number"],
    photo: json["photo"],
    code: json["code"],
    username: json["username"],
    created_at: json["created_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "code": code,
    "name": name,
    "photo": photo,
    "governorate": governorate,
    "country": country,
    "address": address,
    "phone_number": phone_number,
    "username": username,
    "created_at": created_at,
  };
}
