import 'package:flutter/material.dart';

class MyTheme {
  final MaterialColor primaryColor;
  final Color textColor;
  final String defaultIcon;
  bool isPhyrexian;

  MyTheme({
    required this.primaryColor,
    required this.textColor,
    required this.defaultIcon,
    this.isPhyrexian = false,
  });

  // Build ThemeData when needed
  ThemeData buildTheme() {
    return createMyTheme(primaryColor, textColor, isPhyrexian);
  }
}

ThemeData createMyTheme(MaterialColor primaryColor, Color textColor, bool isPhyrexian) {
  return ThemeData(
    fontFamily: isPhyrexian ? 'Phyrexian' : '',
    primarySwatch: primaryColor,
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: textColor,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: textColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: textColor,
          )),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: primaryColor,
    ),
  );
}

final MyTheme mtgBlue = MyTheme(
  primaryColor: Colors.blue,
  textColor: Colors.white,
  defaultIcon: "assets/u.svg",
);

final MyTheme mtgRed = MyTheme(
  primaryColor: Colors.red,
  textColor: Colors.white,
  defaultIcon: "assets/r.svg",
);

final MyTheme mtgGreen = MyTheme(
  primaryColor: Colors.green,
  textColor: Colors.white,
  defaultIcon: "assets/g.svg",
);

final MyTheme mtgPurple = MyTheme(
  primaryColor: Colors.purple,
  textColor: Colors.white,
  defaultIcon: "assets/b.svg",
);

final MyTheme mtgGrey = MyTheme(
  primaryColor: Colors.grey,
  textColor: Colors.white,
  defaultIcon: "assets/c.svg",
);

final MyTheme mtgWhite = MyTheme(
  primaryColor: Colors.amber,
  textColor: Colors.black,
  defaultIcon: "assets/w.svg",
);

