import 'package:flutter/material.dart';

class LocaleNotifier extends ChangeNotifier {
  LocaleNotifier(this._locale);

  Locale _locale;

  Locale get locale => _locale;

  void toggleLocale() {
    _locale = _locale == Locale('en') ? Locale('fr') : Locale('en');
    notifyListeners();
  }
}