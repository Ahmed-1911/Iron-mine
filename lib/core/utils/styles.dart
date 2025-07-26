import 'package:flutter/material.dart';

BoxDecoration dawarGreenBoxDecoration(
        {bool isCircle = true,
        double? radius,
        bool isDawarGreen = true,
        Color? color}) =>
    BoxDecoration(
      color: color,
      borderRadius: radius == null ? null : BorderRadius.circular(radius),
      shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
      gradient: !isDawarGreen ? null : dawarGreenGradiant,
    );

LinearGradient dawarGreenGradiant = const LinearGradient(
  begin: Alignment.topRight,
  end: Alignment.topLeft,
  colors: <Color>[Color(0xFF8BFCB8), Color(0xFF8BFBE5)],
);
