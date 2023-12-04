import 'package:flutter/material.dart';

class MyTheme{
  /*configurable colors stars*/
  static Color accent_color = Color(0xff000000);
  static Color secondary_color = Color(0xfff0d02d);
  static Color accent_color_shadow = Color.fromRGBO(229,65,28, .40); // this color is a dropshadow of
  static Color soft_accent_color = Color.fromRGBO(
      0, 0, 0, 0.14901960784313725);
  static Color success = Colors.green;
  static Color danger = Colors.redAccent;
  static Color splash_screen_color = Color(0xff000000); // if not sure , use the same color as accent color
  /*configurable colors ends*/


  /*If you are not a developer, do not change the bottom colors*/
  static Color white = Color.fromRGBO(255,255,255, 1);
  static Color black = Color.fromRGBO(0,0,0, 0);
  static Color noColor = Color.fromRGBO(255,255,255, 0);
  static Color light_grey = Color.fromRGBO(239,239,239, 1);
  static Color light_bg = Color(0xfff4f3fa);
  static Color dark_grey = Color.fromRGBO(107,115,119, 1);
  static Color medium_grey = Color.fromRGBO(167,175,179, 1);
  static Color medium_grey_50 = Color.fromRGBO(167,175,179, .5);
  static Color grey_153 = Color.fromRGBO(153,153,153, 1);
  static Color dark_font_grey = Color.fromRGBO(17, 18, 19, 1);
  static Color font_grey = Color.fromRGBO(107,115,119, 1);
  static Color textfield_grey = Color.fromRGBO(209,209,209, 1);
  static Color golden = Color.fromRGBO(255, 168, 0, 1);
  static Color amber = Color.fromRGBO(254, 234, 209, 1);
  static Color golden_shadow = Color.fromRGBO(255, 168, 0, .4);
  static Color shimmer_base = Colors.grey.shade50;
  static Color shimmer_highlighted = Colors.grey.shade200;


  //testing shimmer
  /*static Color shimmer_base = Colors.redAccent;
  static Color shimmer_highlighted = Colors.yellow;*/



}