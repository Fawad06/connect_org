import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'constants.dart';

class MyTheme {
  static ThemeData get lightTheme => ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: kContentColorDarkTheme,
        appBarTheme: appBarTheme,
        iconTheme: const IconThemeData(color: kContentColorLightTheme),
        colorScheme: const ColorScheme.light(
          primary: kPrimaryColor,
          secondary: kSecondaryColor,
          tertiary: kTertiaryColor,
          background: Colors.white,
          onBackground: Colors.black,
          error: kErrorColor,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: kPrimaryColor,
          splashColor: kSecondaryColor,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: Colors.black,
            onPrimary: Colors.white,
            minimumSize: const Size(double.maxFinite, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        textTheme: TextTheme(
          headline4: myHeadline4(Colors.black),
          headline5: myHeadline5(Colors.black),
        ),
      );

  ///
  static ThemeData get darkTheme => ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: kContentColorLightTheme,
        appBarTheme: appBarTheme,
        iconTheme: const IconThemeData(color: kContentColorDarkTheme),
        colorScheme: const ColorScheme.dark(
          brightness: Brightness.dark,
          primary: kPrimaryColor,
          secondary: kSecondaryColor,
          tertiary: kTertiaryColor,
          background: Color(0xFF4D6D95),
          onBackground: Colors.blueGrey,
          error: kErrorColor,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: kPrimaryColor,
          splashColor: kSecondaryColor,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: Colors.blueGrey,
            onPrimary: Colors.white,
            minimumSize: const Size(double.maxFinite, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        textTheme: TextTheme(
          headline4: myHeadline4(Colors.white),
          headline5: myHeadline5(Colors.white),
        ),
      );

  static AppBarTheme appBarTheme = const AppBarTheme(
    centerTitle: false,
    elevation: 0,
    color: Colors.transparent,
  );

  ///
  ///
  static TextStyle myHeadline5(Color c) => TextStyle(
        fontWeight: FontWeight.bold,
        fontFamily: GoogleFonts.dongle().fontFamily,
        fontSize: 34,
        color: c,
        height: 0.6,
      );
  static TextStyle myBodyText1(Color c) => TextStyle(
        fontFamily: GoogleFonts.ubuntu().fontFamily,
        color: c,
        fontSize: 14,
      );
  static TextStyle myBodyText2(Color c) => TextStyle(
        fontFamily: GoogleFonts.ubuntu().fontFamily,
        color: c,
        fontSize: 12,
      );
  static TextStyle myHeadline3(Color c) => TextStyle(
        fontFamily: GoogleFonts.mochiyPopOne().fontFamily,
        color: c,
        height: 1,
      );
  static TextStyle myHeadline4(Color c) => TextStyle(
        fontFamily: GoogleFonts.mochiyPopOne().fontFamily,
        color: c,
        fontSize: 28,
      );
}
