import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeGloballyTheme with ChangeNotifier {
  Color brightBackgroundColor = Colors.white;
  Color lightBackgroundColor = Colors.white;
  String _backgroundImage = "";

  Color get brightBgColor => brightBackgroundColor;

  Color get lightBgColor => lightBackgroundColor;

  String get bgImage => _backgroundImage;

  ChangeGloballyTheme() {
    loadBackgroundImageScreenTheme();
  }

  Future<void> loadBackgroundImageScreenTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt('IndexValue') ?? -1;
    if (themeIndex == -1) {
      _backgroundImage = "";
    } else if (themeIndex == 0) {
      _backgroundImage = "assets/ThemeImage/Daily diary Theme-01.jpg";
    } else if (themeIndex == 1) {
      _backgroundImage = "assets/ThemeImage/Daily diary Theme-02.jpg";
    } else if (themeIndex == 2) {
      _backgroundImage = "assets/ThemeImage/Daily diary Theme-03.jpg";
    } else if (themeIndex == 3) {
      _backgroundImage = "assets/ThemeImage/Daily diary Theme-04.jpg";
    } else if (themeIndex == 4) {
      _backgroundImage = "assets/ThemeImage/Daily diary Theme-05.jpg";
    } else if (themeIndex == 5) {
      _backgroundImage = "assets/ThemeImage/Daily diary Theme-06.jpg";
    } else if (themeIndex == 6) {
      _backgroundImage = "assets/ThemeImage/Daily diary Theme-07.jpg";
    } else if (themeIndex == 7) {
      _backgroundImage = "assets/ThemeImage/Daily diary Theme-08.jpg";
    } else if (themeIndex == 8) {
      _backgroundImage = "assets/ThemeImage/Daily diary Theme-09.jpg";
    } else if (themeIndex == 9) {
      _backgroundImage = "assets/ThemeImage/Daily diary Theme-10.jpg";
    }
    notifyListeners();
  }
}
