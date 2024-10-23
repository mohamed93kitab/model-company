import 'package:flutter/material.dart';
import 'package:bab_algharb/assets.dart' as app_assets;

class PostModel {
  PostModel(
      {this.id,
        this.avatar = "",
        this.user_name = "",
        this.subtitle = "",
        this.caption = "",
        this.color = Colors.white,
        this.postImage = "",
      });

  UniqueKey id = UniqueKey();
  String avatar, caption, user_name, postImage;
  String subtitle;
  Color color;

  static List<PostModel> posts = [
    PostModel(
        avatar: app_assets.avatar_1,
        subtitle: "",
        caption: "- منذ 20 دقيقة",
        color: const Color(0xFF7850F0),
        postImage: app_assets.p_3,
        user_name: "mohamed ali"
    ),
    PostModel(
        avatar: app_assets.avatar_2,
        subtitle:
        "خلل عام يصيب سيرفرات meta منهم فيسبوك و أنستغرام و واتس أب ، لتنقطع الخدمة عن هذه التطبيقات بشكل مؤقت مما يكبد شركة فيسبوك خسائر مالية كبيرة, كما اثار  هذا التعطل غضب الكثير من المستخدمين حول العالم، وقد تم حل مشكلة الفيس بوك وعودتها مرة اخري علي جميع الاجهزة والهواتف المحمولة، ويستطيع جميع المستخدمين فتح الفيسبوك من جديد",
        caption: "- منذ 22 دقيقة",
        color: const Color(0xFF6792FF),
        user_name: "ahmed mustafa",
        postImage: app_assets.p_1

    ),
    PostModel(
        avatar: app_assets.avatar_3,
        subtitle:
        "اللهم بلغنا شهر رمضان",
        caption: "- منذ 29 دقيقة",
        color: const Color(0xFF005FE7),
        user_name: "abdulla jassim",
        postImage: app_assets.p_2
    ),
  ];

  static List<PostModel> courseSections = [
    PostModel(
        avatar: "State Machine",
        caption: "Watch video - 15 mins",
        color: const Color(0xFF9CC5FF),
        user_name: "ali abbas",
        postImage: app_assets.topic_1
    ),
    PostModel(
        avatar: "Animated Menu",
        caption: "Watch video - 10 mins",
        color: const Color(0xFF6E6AE8),
        user_name:"omar mohamed",
        postImage: app_assets.topic_1
    ),
    PostModel(
        avatar: "Tab Bar",
        caption: "Watch video - 8 mins",
        color: const Color(0xFF005FE7),
        user_name: "hayder ahmed",
        postImage: app_assets.topic_1
    ),
    PostModel(
        avatar: "Button",
        caption: "Watch video - 9 mins",
        color: const Color(0xFFBBA6FF),
        user_name: "ahmed mohamed",
        postImage: app_assets.topic_1
    ),
  ];
}