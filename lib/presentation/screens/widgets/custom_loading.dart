import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

// ignore: must_be_immutable
class Customloading extends StatelessWidget {
  Customloading({super.key, required this.width, required this.color});

  Color color;
  double width;


  @override
  Widget build(BuildContext context) {
    return SpinKitSpinningLines(
      color: color,
      size: width,
    );
  }
}
