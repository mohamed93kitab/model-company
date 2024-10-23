import 'package:flutter/material.dart';
import 'package:bab_algharb/assets.dart' as app_assets;

class CourseModel {
  CourseModel(
      {this.id,
        this.title = "",
        this.subtitle = "",
        this.caption = "",
        this.color = Colors.white,
        this.image = "",
        this.newsImage = "",
      });

  UniqueKey id = UniqueKey();
  String title, caption, image, newsImage;
  String subtitle;
  Color color;

  static List<CourseModel> courses = [
    CourseModel(
        title: "",
        subtitle: "من المنتظر أن يخضع حراس المرمى لقاعدة جديدة بموجب قانون في كرة القدم من شأنه أن يضع حدا لإهدار الوقت خلال المباراة.وسيمنح حراس المرمى المتباطئين مزيدا من الوقت للاحتفاظ بالكرة، لكن سيتم إخضاعهم للعد التنازلي من قبل الحكم ومعاقبتهم إذا فشلوا في إطلاق الكرة في الوقت المناسب",
        caption: "- منذ 20 دقيقة",
        color: const Color(0xFF7850F0),
        newsImage: app_assets.topic_1
       // image: app_assets.topic_1
    ),
    CourseModel(
        title: "",
        subtitle:
        "سقط يوفنتوس الثاني على ملعب نابولي حامل اللقب بالخسارة أمامه 1-2 الأحد في المرحلة الـ27 من الدوري الإيطالي لكرة القدم، فيما واصل بولونيا تألقه وحلمه بخوض دوري أبطال أوروبا للمرة الثانية فقط في تاريخه بفوزه على مضيفه أتالانتا 2-1.",
        caption: "- منذ 43 دقيقة",
        color: const Color(0xFF6792FF),
        //image: app_assets.topic_2
        newsImage: app_assets.topic_2

    ),
    CourseModel(
        title: "",
        subtitle:
        "تصنع المراوغات والفواصل المهارية الفرجة الكروية الجميلة وتمنح الكثير من المتعة للجماهير والمشاهدين، غير أن تسجيل الأهداف له نشوة خاصة سواء لدى الأنصار أو اللاعبين على حد سواء، لكن إحراز هدف في الوقت القاتل من المباراة يبقى له وقع وطعم خاصان.",
        caption: "- منذ 49 دقيقة",
        color: const Color(0xFF005FE7),
        // image: app_assets.topic_1
        newsImage: app_assets.topic_3
    ),
  ];

  static List<CourseModel> courseSections = [
    CourseModel(
        title: "State Machine",
        caption: "Watch video - 15 mins",
        color: const Color(0xFF9CC5FF),
        //image: app_assets.topic_2
        newsImage: app_assets.topic_1
    ),
    CourseModel(
        title: "Animated Menu",
        caption: "Watch video - 10 mins",
        color: const Color(0xFF6E6AE8),
        //image: app_assets.topic_1
        newsImage: app_assets.topic_1
    ),
    CourseModel(
        title: "Tab Bar",
        caption: "Watch video - 8 mins",
        color: const Color(0xFF005FE7),
      //  image: app_assets.topic_2
        newsImage: app_assets.topic_1
    ),
    CourseModel(
        title: "Button",
        caption: "Watch video - 9 mins",
        color: const Color(0xFFBBA6FF),
        //image: app_assets.topic_1
        newsImage: app_assets.topic_1
    ),
  ];
}