import 'package:flutter/material.dart';

class AppColors {
  static const red = Color.fromRGBO(245, 72, 72, 1);
  static const darkgrey = Color.fromRGBO(74, 74, 74, 1);
  static const lightGrey = Color.fromRGBO(243, 243, 243, 1);
  static const grey = Color.fromRGBO(174, 174, 174, 1);
  static const blue = Color.fromRGBO(38, 79, 183, 1);
  static const blueOpacity = Color.fromRGBO(38, 79, 183, 24);
  static const lightBlue = Color.fromRGBO(38, 79, 183, 0.5);
  static const blueInputField = Color.fromRGBO(38, 79, 183, 0.24);
  static const background = Color.fromRGBO(255, 255, 255, 1);
  static const green = Color.fromRGBO(38, 183, 174, 1);
  static final ligthGreen = Color.fromRGBO(38, 183, 174, 0.2);
  static final fields = Color.fromRGBO(38, 79, 183, 0.3);
  static final black = Color.fromRGBO(0, 0, 0, 1);
  static final shadowBlack = Color.fromRGBO(0, 0, 0, 0.13);
  static final gradientInicial = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[
      Color.fromRGBO(38, 183, 174, 1),
      Color.fromRGBO(38, 79, 183, 1),
    ],
  );
  static final gradientAppBar = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[
      Color.fromRGBO(38, 79, 183, 1),
      Color.fromRGBO(38, 183, 174, 1),
    ],
  );
}
