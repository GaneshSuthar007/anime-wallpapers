import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'colors.theme.dart';

ElevatedButtonThemeData buttonTheme = ElevatedButtonThemeData(
    style: ButtonStyle(
        shape: MaterialStateProperty.resolveWith<OutlinedBorder>((_) {
          return RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10));
        }),
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (states) => ColorsTheme.primary)));
