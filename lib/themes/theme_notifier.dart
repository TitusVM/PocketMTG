import 'package:flutter/material.dart';
import 'package:pocket_mtg/themes/themes.dart';

class ThemeNotifier extends ChangeNotifier {
  MyTheme _currentTheme;

  ThemeNotifier(this._currentTheme);

  MyTheme getTheme() => _currentTheme;

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
