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

  void togglePhyrexian() {
    isPhyrexian = !isPhyrexian;
  }

  // Build ThemeData when needed
  ThemeData buildTheme() {
    return createMyTheme(primaryColor, textColor, isPhyrexian);
  }
}

ThemeData createMyTheme(MaterialColor primaryColor, Color textColor, bool isPhyrexian) {
  return ThemeData(
    textSelectionTheme: TextSelectionThemeData(cursorColor: primaryColor),
    fontFamily: isPhyrexian ? 'Phyrexian' : '',
    inputDecorationTheme: InputDecorationTheme(
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: primaryColor),
      ),
      focusedErrorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: primaryColor),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: primaryColor),
      ),
      errorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: primaryColor),
      ),
      hintStyle: TextStyle(color: primaryColor),
      errorStyle: TextStyle(color: primaryColor),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(primaryColor),
      ),
    ),
    primarySwatch: primaryColor,
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: textColor,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: textColor,
    ),
    switchTheme: SwitchThemeData(
      trackColor: MaterialStateProperty.all<Color>(primaryColor),
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

