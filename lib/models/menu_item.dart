import 'package:flutter/material.dart';
import 'package:bab_algharb/models/tab_item.dart';

class MenuItemModel {
  MenuItemModel({
    this.id,
    this.title = "",
     this.riveIcon,
  });

  UniqueKey id = UniqueKey();
  String title;
  TabItem riveIcon;

  static List<MenuItemModel> menuItems = [
    MenuItemModel(
        title: "الرئيسية",
        riveIcon: TabItem(stateMachine: "HOME_interactivity", artboard: "HOME"),
    ),
    MenuItemModel(
        title: "الأصدقاء",
        riveIcon:
        TabItem(stateMachine: "SEARCH_Interactivity", artboard: "SEARCH"),
    ),
    // MenuItemModel(
    //     title: "تواصل",
    //     riveIcon:
    //     TabItem(stateMachine: "STAR_Interactivity", artboard: "LIKE/STAR"),
    // ),
    // MenuItemModel(
    //     title: "الدردشة",
    //     riveIcon: TabItem(stateMachine: "CHAT_Interactivity", artboard: "CHAT"),
    // ),
  ];

  static List<MenuItemModel> menuItems2 = [
    MenuItemModel(
        title: "غرف الدردشة",
        riveIcon: TabItem(stateMachine: "TIMER_Interactivity", artboard: "TIMER"),
    ),
    MenuItemModel(
        title: "الدخول إلى المسابقة",
        riveIcon: TabItem(stateMachine: "BELL_Interactivity", artboard: "BELL"),
    ),
  ];
  static List<MenuItemModel> menuItems4 = [
    MenuItemModel(
        title: "تحويل النقاط",
        riveIcon: TabItem(stateMachine: "TIMER_Interactivity", artboard: "convert coins"),
    ),
    MenuItemModel(
      title: "طلبات التحويل",
      riveIcon: TabItem(stateMachine: "REFRESH_Interactivity", artboard: "REFRESH/RELOAD"),
    ),
    MenuItemModel(
      title: "المحفظة",
      riveIcon:
      TabItem(stateMachine: "STAR_Interactivity", artboard: "LIKE/STAR"),
     ),
    MenuItemModel(
      title: "الوكلاء",
      riveIcon:
      TabItem(stateMachine: "USER_Interactivity", artboard: "USER"),
     ),
    MenuItemModel(
      title: "سجل الإشتراكات",
      riveIcon:
      TabItem(stateMachine: "BELL_Interactivity", artboard: "BELL"),
     ),
    MenuItemModel(
      title: "الفريق",
      riveIcon:
      TabItem(stateMachine: "SEARCH_Interactivity", artboard: "SEARCH"),
     ),

      MenuItemModel(
      title: "إعدادات الخصوصية",
      riveIcon:
      TabItem(stateMachine: "SEARCH_Interactivity", artboard: "USER"),
     ),
    // MenuItemModel(
    //   title: "العدادات",
    //   riveIcon:
    //   TabItem(stateMachine: "TIMER_Interactivity", artboard: "TIMER"),
    //  ),
   ];
  //
  static List<MenuItemModel> menuItems3 = [
    MenuItemModel(
      title: "Dark Mode",
      riveIcon:
      TabItem(stateMachine: "SETTINGS_Interactivity", artboard: "SETTINGS"),
    ),
  ];
}