import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Covid {
  static const String app_name = "Covid 19 Nigeria";
  static const String app_version = "Version 1.0.0";
  static const int app_version_code = 1;
  static const String app_color = "#ffd7167";
  static Color primaryAppColor = Colors.white;
  static Color secondaryAppColor = Colors.black;
  static const String google_sans_family = "GoogleSans";
  static bool isDebugMode = true;

  //* Images

  static const String Header = "assets/images/bacteria.svg";
  static const String Dashboard_light = "assets/images/dashboard_white.svg";
  static const String Dashboard_dark = "assets/images/dashboard.svg";
  static const String Information_light = "assets/images/information_white.svg";
  static const String Information_dark = "assets/images/information.svg";
  static const String News_light = "assets/images/newspaper_white.svg";
  static const String News_dark = "assets/images/newspaper.svg";
  static const String Recovered_img = "assets/images/recovered.svg";
  static const String Death_img = "assets/images/death.svg";
  static const String Cases_img = "assets/images/coronavirus.svg";
  static const String Nurse = "assets/images/nurse.svg";
  static const String Splash = "assets/images/covid.svg";
  static const String Mask = "assets/images/mask.png";
  static const String Social_distance = "assets/images/social_distance.png";
  static const String Wash = "assets/images/wash.png";

  //* Texts
  static const String recovered = "Recovered";
  static const String active = "Active Cases";
  static const String total = "Total Cases";
  static const String death = "Deaths";
  static const String washText = "Wash and Sanitize Hands";
  static const String maskText = "Wear Face Mask Often";
  static const String distanceText = "Keep 2m Distance";

  //* Preferences
  static SharedPreferences prefs;
  static const String darkModePref = "darkModePref";
  static const String initialized = "initialized";
}