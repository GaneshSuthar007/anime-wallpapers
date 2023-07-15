import 'package:flutter/material.dart';

import 'app_bar.theme.dart';
import 'button.theme.dart';
import 'colors.theme.dart';
import 'text.theme.dart';

ThemeData themeData = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: ColorsTheme.grey,
    primary: ColorsTheme.primary,
    secondary: ColorsTheme.secondary,
    brightness: Brightness.dark,
    background: ColorsTheme.background,
  ),
  appBarTheme: appBarTheme,
  elevatedButtonTheme: buttonTheme,
  textTheme: textTheme,
  useMaterial3: true,
  fontFamily: "Teko",
  scaffoldBackgroundColor: Colors.white,
);
