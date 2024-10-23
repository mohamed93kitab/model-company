import 'dart:convert';

BannerResponse bannerResponseFromJson(String str) => BannerResponse.fromJson(json.decode(str));

String bannerResponseToJson(BannerResponse data) => json.encode(data.toJson());

class BannerResponse {
  BannerResponse({
     this.data,
     this.success,
  });

  List<Banner> data;
  bool success;

  factory BannerResponse.fromJson(Map<String, dynamic> json) => BannerResponse(
    data: List<Banner>.from(json["data"].map((x) => Banner.fromJson(x))),
    success: json["success"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "success": success,
  };
}

class Banner {
  Banner({
     this.id,
     this.photo,
     this.created_at,
  });

  int id;
  String photo;
  String created_at;

  factory Banner.fromJson(Map<String, dynamic> json) => Banner(
    id: json["id"],
    photo: json["photo"],
    created_at: json["created_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "photo": photo,
    "created_at": created_at,
  };
}
