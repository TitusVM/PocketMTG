import 'package:flutter/material.dart';
import 'package:pocket_mtg/themes/themes.dart';

class ThemeNotifier extends ChangeNotifier {
  MyTheme _currentTheme;

  ThemeNotifier(this._currentTheme);

  MyTheme getTheme() => _currentTheme;

  Color get primaryColor => _currentTheme.primaryColor;
  String get defaultIcon => _currentTheme.isPhyrexian ? "assets/p.svg" : _currentTheme.defaultIcon;

  bool get isPhyrexian => _currentTheme.isPhyrexian;

  void setTheme(MyTheme newTheme) {
    _currentTheme = newTheme;
    notifyListeners();
  }
  void toggleFont() {
    _currentTheme.isPhyrexian = !_currentTheme.isPhyrexian;
    notifyListeners();
  }


}
