
import 'package:flutter/material.dart';

const primaryColor = Color(0xFFfbab66);
const primaryLight = Color(0xFFFF9F59);
const primaryDark = Color(0xFFFF9F59);

const introColor = Color(0xFFFB9070);

const backgroundColor = Color(0xFFF5F5F5);

const secondaryColor = Color(0xFFFF9F59);
const secondaryLight = Color(0xFFFF9F59);
const secondaryDark = Color(0xFFFF9F59);

const Color gradientStart = Color(0xFFfbab66);
const Color gradientEnd = Color(0xFFf7418c);


const Color bottomNavBar = Color(0xFFFE9801);
const Color buttonBackgroundColor = Color(0xFFEC417A);


const primaryGradient = LinearGradient(
  colors: [gradientStart, gradientEnd],
  stops: [0.0, 1.0],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);



const chatBubbleGradient = LinearGradient(
  colors: [Color(0xFFFD60A3), Color(0xFFFF8961)],
  begin: Alignment.topRight,
  end: Alignment.bottomLeft,
);

const chatBubbleGradient2 = LinearGradient(
  colors: [Color(0xFFf4e3e3), Color(0xFFf4e3e3)],
  begin: Alignment.topRight,
  end: Alignment.bottomLeft,
);



class AppTheme {

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryColor,
    backgroundColor: Colors.white,
    fontFamily: 'Quicksand'
  );

  static ThemeData dark = ThemeData(
    primaryColor: primaryDark,
    backgroundColor: primaryDark,
    brightness: Brightness.dark,
    fontFamily: 'Quicksand',
  );

}