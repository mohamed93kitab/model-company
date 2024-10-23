

import 'dart:convert';

TransferResponse transferResponseFromJson(String str) => TransferResponse.fromJson(json.decode(str));

String transferResponseToJson(TransferResponse data) => json.encode(data.toJson());

class TransferResponse {
  TransferResponse({
     this.data,
     this.success,
     this.message,
  });

  List<Transfer> data;
  bool success;
  String message;

  factory TransferResponse.fromJson(Map<String, dynamic> json) => TransferResponse(
    data: List<Transfer>.from(json["data"].map((x) => Transfer.fromJson(x))),
    success: json["success"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "success": success,
  };
}

class Transfer {
  Transfer({
     this.id,
     this.avatar,
     this.from,
     this.from_id,
     this.to,
     this.to_avatar,
     this.points,
     this.status,
     this.verified,
     this.created_at,
  });

  var id;
  var avatar;
  var from;
  var from_id;
  var to;
  var to_avatar;
  var points;
  var status;
  var verified;
  var created_at;

  factory Transfer.fromJson(Map<String, dynamic> json) => Transfer(
    id: json["id"],
    avatar: json["avatar"],
    from: json["from"],
    from_id: json["from_id"],
    points: json["points"],
    to: json["to"],
    to_avatar: json["to_avatar"],
    status: json["status"],
    created_at: json["created_at"],
    verified: json["verified"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "avatar": avatar,
    "from": from,
    "from_id": from_id,
    "to": to,
    "to_avatar": to_avatar,
    "points": points,
    "status": status,
    "verified": verified,
    "created_at": created_at,
  };
}
