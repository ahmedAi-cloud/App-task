import 'package:flutter/material.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('ar');

  Locale get locale => _locale;

  void setArabic() {
    _locale = const Locale('ar');
    notifyListeners();
  }

  void setEnglish() {
    _locale = const Locale('en');
    notifyListeners();
  }

  void toggleLanguage() {
    if (_locale.languageCode == 'ar') {
      setEnglish();
    } else {
      setArabic();
    }
  }
}
