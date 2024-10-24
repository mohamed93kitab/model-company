import 'package:flutter/material.dart';

var this_year = DateTime.now().year.toString();

class AppConfig {
  static String copyright_text = "@ Light-Speed " + this_year; //this shows in the splash screen
  static String app_name = "باب الغرب"; //this shows in the splash screen
  static String purchase_code = "mohamed-kitab"; //enter your purchase code for the app from codecanyon

  //Default language config
  static String version = "1.0.0";


  static String default_language = "ar";
  static String mobile_app_code = "ar";
  static bool app_language_rtl = true;

  //configure this
  static const bool HTTPS = true;

  //configure this

  static const DOMAIN_PATH = "bab-algharb.com"; //localhost
  //
  //static const DOMAIN_PATH = "domain.com"; // directly inside the public folder

  //do not configure these below
  static const String API_ENDPATH = "api/v1";
  static const String PROTOCOL = HTTPS ? "https://" : "http://";
  static const String RAW_BASE_URL = "${PROTOCOL}${DOMAIN_PATH}";
  static const String BASE_URL = "${RAW_BASE_URL}/${API_ENDPATH}";
  static const IMAGES_PATH = "${RAW_BASE_URL}/storage/app/public/";

}