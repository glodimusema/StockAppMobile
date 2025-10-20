import 'package:flutter/material.dart';

class Themes {
  static const DARK_THEME_CODE = 0;
  static const LIGHT_THEME_CODE = 1;

  static final _dark = ThemeData(
    fontFamily: 'GoogleSans',
    iconTheme: const IconThemeData(color: Colors.white),
    disabledColor: Colors.green, colorScheme: ColorScheme.fromSwatch(primarySwatch: MaterialColor(
      Colors.black.value,
      const <int, Color>{
        50: Colors.black12,
        100: Colors.black26,
        200: Colors.black38,
        300: Colors.black45,
        400: Colors.black54,
        500: Colors.black87,
        600: Colors.black87,
        700: Colors.black87,
        800: Colors.black87,
        900: Colors.black87,
      },
    )).copyWith(secondary: Colors.white),
  );

  static final _light = ThemeData(
    fontFamily: 'GoogleSans',
    iconTheme: IconThemeData(color: Color(0xFF1a84b8)),
      disabledColor: Colors.green, colorScheme: ColorScheme.fromSwatch(primarySwatch: MaterialColor(
      Colors.white.value,
      const <int, Color>{
        50: Colors.white10,
        100: Colors.white12,
        200: Colors.white24,
        300: Colors.white30,
        400: Colors.white54,
        500: Colors.white70,
        600: Colors.white70,
        700: Colors.white70,
        800: Colors.white70,
        900: Colors.white70,
      },
    )).copyWith(secondary: Colors.black)
    
  );
static Color loginGradientStart = const Color(0xFF1a84b8);
  static Color loginGradientEnd = const Color(0xFF232333);
  static bool isLight=true;
  static ThemeData getTheme(int code) {
    if(code == LIGHT_THEME_CODE){
      loginGradientStart = const Color(0xFF1a84b8);
      loginGradientEnd = const Color(0xFF232333);
      isLight=true;
      return _light;
    }
    loginGradientStart = const Color(0xFF232333);
      loginGradientEnd = const Color(0xFF000000);
      isLight=false;
    return _dark;
  }

  //==================

  

  static final primaryGradient = LinearGradient(
    colors: [loginGradientStart, loginGradientEnd],
    stops: const [0.0, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

}