import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class ThemeNotifier with ChangeNotifier {
  ThemeData? _themeData;

  ThemeNotifier() {
    _themeData = ThemeData.light(); //// Default to the light theme
    _loadTheme();
  }

  ThemeData? get theme => _themeData;

  Future<void> setTheme(ThemeData themeData) async {
    _themeData = themeData;
    notifyListeners();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDark') ?? true; // Check if dark mode is enabled in shared preferences
    if (isDark) {
      _themeData = ThemeData.dark();
    }
    notifyListeners();
  }

  Future<void> darkTheme() async {
      _themeData = ThemeData.dark().copyWith(
        textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(primary: Colors.white)),
    bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Colors.transparent,),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(backgroundColor: Colors.transparent,),
        datePickerTheme: DatePickerThemeData(
    backgroundColor: brightBackgroundColor,
    todayBackgroundColor: MaterialStatePropertyAll(
    lightBackgroundColor),
    dayStyle: const TextStyle(color: Colors.white,)),);
    notifyListeners();
  }

  Future<void> lightTheme() async {
      _themeData =   ThemeData(
        dialogTheme: DialogTheme(),
          // actionIconTheme: ActionIconThemeData(),
          textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(primary: Colors.black)),
          bottomSheetTheme: const BottomSheetThemeData(
            backgroundColor: Colors.transparent,),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(backgroundColor: Colors.transparent),
          datePickerTheme: DatePickerThemeData(
              backgroundColor: brightBackgroundColor,
              todayBackgroundColor: MaterialStatePropertyAll(
                  lightBackgroundColor),
              dayStyle: TextStyle(color: Colors.black,)));
    notifyListeners();
  }
}
