import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomListHeaders extends StatelessWidget {
  CustomListHeaders({
    super.key,
    this.firstTitle,
    this.secTitle,
    this.thirdTitle,
    this.fourthTitle,
    this.fifthTitle,
    this.sixthTitle,
    this.seventhTitle,
    this.eighthTitle,
    this.ninthTitle,
    this.tenthTitle,
    this.defaultFlex = 2,

    /// default flex is 2
    this.firstFlex,
    this.secFlex,
    this.thirdFlex,
    this.fourthFlex,
    this.fifthFlex,
    this.sixthFlex,
    this.seventhFlex,
    this.eighthFlex,
    this.ninthFlex,
    this.tenthFlex,
    this.fontColor,
    this.fontSize,
    this.dottedBorderColor,
    // this.withDottedBorder = true,
    this.withDividerBelow = true,
  });

  Color? dottedBorderColor;
  Color? fontColor;
  double? fontSize;
  dynamic firstTitle;
  int? firstFlex;
  String? secTitle;
  int? secFlex;
  String? thirdTitle;
  int? thirdFlex;
  String? fourthTitle;
  int? fourthFlex;
  String? fifthTitle;
  int? fifthFlex;
  String? sixthTitle;
  int? sixthFlex;
  String? seventhTitle;
  int? seventhFlex;
  String? eighthTitle;
  int? eighthFlex;
  String? ninthTitle;
  int? ninthFlex;
  String? tenthTitle;
  int? tenthFlex;
  int? defaultFlex;

  //bool withDottedBorder;
  bool withDividerBelow;

  @override
  Widget build(BuildContext context) {
    Widget contentWidget = Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            firstTitle == null
                ? const SizedBox()
                : Expanded(
                    flex: firstFlex ?? defaultFlex!,
                    child: Center(
                      child: firstTitle is IconData
                          ? Icon(firstTitle)
                          : Text(
                              firstTitle!,
                              style: TextStyle(
                                fontSize: fontSize ?? 20,
                                color: fontColor ?? Colors.black,
                              ),
                            ),
                    ),
                  ),
            secTitle == null
                ? const SizedBox()
                : Expanded(
                    flex: secFlex ?? defaultFlex!,
                    child: Center(
                      child: Text(
                        secTitle!,
                        style: TextStyle(
                          fontSize: fontSize ?? 20,
                          color: fontColor ?? Colors.black,
                        ),
                      ),
                    ),
                  ),
            thirdTitle == null
                ? const SizedBox()
                : Expanded(
                    flex: thirdFlex ?? defaultFlex!,
                    child: Center(
                      child: Text(
                        thirdTitle!,
                        style: TextStyle(
                          fontSize: fontSize ?? 20,
                          color: fontColor ?? Colors.black,
                        ),
                      ),
                    ),
                  ),
            fourthTitle == null
                ? const SizedBox()
                : Expanded(
                    flex: fourthFlex ?? defaultFlex!,
                    child: Center(
                      child: Text(
                        fourthTitle!,
                        style: TextStyle(
                          fontSize: fontSize ?? 20,
                          color: fontColor ?? Colors.black,
                        ),
                      ),
                    ),
                  ),
            fifthTitle == null
                ? const SizedBox()
                : Expanded(
                    flex: fifthFlex ?? defaultFlex!,
                    child: Center(
                      child: Text(
                        fifthTitle!,
                        style: TextStyle(
                          fontSize: fontSize ?? 20,
                          color: fontColor ?? Colors.black,
                        ),
                      ),
                    ),
                  ),
            sixthTitle == null
                ? const SizedBox()
                : Expanded(
                    flex: sixthFlex ?? defaultFlex!,
                    child: Center(
                      child: Text(
                        sixthTitle!,
                        style: TextStyle(
                          fontSize: fontSize ?? 20,
                          color: fontColor ?? Colors.black,
                        ),
                      ),
                    ),
                  ),
            seventhTitle == null
                ? const SizedBox()
                : Expanded(
                    flex: seventhFlex ?? defaultFlex!,
                    child: Center(
                      child: Text(
                        seventhTitle!,
                        style: TextStyle(
                          fontSize: fontSize ?? 20,
                          color: fontColor ?? Colors.black,
                        ),
                      ),
                    ),
                  ),
            eighthTitle == null
                ? const SizedBox()
                : Expanded(
                    flex: eighthFlex ?? defaultFlex!,
                    child: Center(
                      child: Text(
                        eighthTitle!,
                        style: TextStyle(
                          fontSize: fontSize ?? 20,
                          color: fontColor ?? Colors.black,
                        ),
                      ),
                    ),
                  ),
            ninthTitle == null
                ? const SizedBox()
                : Expanded(
                    flex: ninthFlex ?? defaultFlex!,
                    child: Center(
                      child: Text(
                        ninthTitle!,
                        style: TextStyle(
                          fontSize: fontSize ?? 20,
                          color: fontColor ?? Colors.black,
                        ),
                      ),
                    ),
                  ),
            tenthTitle == null
                ? const SizedBox()
                : Expanded(
                    flex: tenthFlex ?? defaultFlex!,
                    child: Center(
                      child: Text(
                        tenthTitle!,
                        style: TextStyle(
                          fontSize: fontSize ?? 20,
                          color: fontColor ?? Colors.black,
                        ),
                      ),
                    ),
                  ),
          ],
        ),
        withDividerBelow
            ? Divider(
                color: Colors.black.withAlpha(102),
              )
            : const SizedBox()
      ],
    );

    return SizedBox(child: contentWidget);
  }
}
