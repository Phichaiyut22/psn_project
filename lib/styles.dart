// lib/styles.dart
import 'package:flutter/material.dart';

TextStyle customTextStyle({
  double fontSize = 16.0,
  FontWeight fontWeight = FontWeight.normal,
  Color color = Colors.black,
}) {
  return TextStyle(
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
    shadows: [
      Shadow(
        offset: Offset(1.5, 1.5),
        blurRadius: 3.0,
        color: Colors.black.withOpacity(0.3),
      ),
    ],
  );
}
