import 'package:flutter/material.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _appLocale = Locale('en');

  Locale get appLocale => _appLocale;

  void changeLanguage(Locale newLocale) {
    _appLocale = newLocale;
    notifyListeners();
  }
}
