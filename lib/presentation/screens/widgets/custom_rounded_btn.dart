import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iron_mine/core/utils/app_styles.dart';

import '../../../core/utils/colors_utils.dart';

// ignore: must_be_immutable
class CustomRoundedButton extends StatelessWidget {
  String text;
  Function pressed;
  Color backgroundColor;
  Color textColor;
  Color borderColor;
  Icon? icon;
  double width;
  double height;
  bool iconLeft;
  bool withShadow;
  double fontSize;
  double radius;
  FontWeight fontWeight;

  CustomRoundedButton({
    super.key,
    required this.pressed,
    this.text = '',
    this.backgroundColor = ColorsUtils.kPrimaryColor,
    this.borderColor = ColorsUtils.transparentColor,
    this.icon,
    this.textColor = ColorsUtils.whiteColor,
    this.width = 300,
    this.iconLeft = false,
    this.height = 50,
    this.fontSize = 15,
    this.fontWeight = FontWeight.w600,
    this.radius = 12,
    this.withShadow = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        pressed();
      },
      child: Container(
        width: width.w,
        height: height.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(radius.r),
          border: Border.all(
            color: borderColor,
          ),
          boxShadow: [
            BoxShadow(
              color: withShadow
                  ? ColorsUtils.kPrimaryColor
                  : ColorsUtils.transparentColor,
              blurRadius: 40,
              offset: const Offset(0, 7),
              spreadRadius: -10,
            )
          ],
        ),
        child: iconLeft
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon ?? const SizedBox(),
                  SizedBox(
                    width: ScreenUtil().setWidth(5),
                  ),
                  Text(text,
                      style: AppStyles.styleMedium20(context)
                          .copyWith(color: Colors.white,fontSize: fontSize,),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(text,
                      style: AppStyles.styleMedium20(context)
                          .copyWith(color: Colors.white,fontSize: fontSize),
                  ),
                ],
              ),
      ),
    );
  }
}
