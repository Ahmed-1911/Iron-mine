import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iron_mine/core/utils/app_styles.dart';

import '../../../core/utils/colors_utils.dart';

// ignore: must_be_immutable
class CustomTextField extends ConsumerStatefulWidget {
  String? label;
  Widget? prefixIcon;
  Widget? suffixIcon;
  Color? filledColor;
  bool isMobile;
  bool isNumber;
  bool centerText;
  TextEditingController? controller;
  bool hasPassword;
  bool isEmail;
  bool isPhoneCode;
  bool isFinal;
  bool isEditable;
  bool isNotes;
  bool hasBorder;
  bool readOnly;
  TextStyle? style;
  Function? validator;
  Function? onChange;
  String? hintText;
  String? initialValue;
  TextStyle? hintStyle;
  int? maxLine = 1;
  double radius;
  double margin;
  BoxShadow? shadow;

  CustomTextField({
    super.key,
    this.prefixIcon,
    this.label,
    this.filledColor,
    this.hasBorder = true,
    this.isEditable = true,
    this.isNotes = false,
    this.centerText = false,
    this.isFinal = false,
    this.isPhoneCode = false,
    this.isMobile = false,
    this.isNumber = false,
    this.isEmail = false,
    this.hasPassword = false,
    this.controller,
    this.suffixIcon,
    this.readOnly = false,
    this.style,
    this.validator,
    this.onChange,
    this.hintText,
    this.initialValue,
    this.hintStyle,
    this.maxLine = 1,
    this.radius = 10,
    this.shadow,
    this.margin = 21,
  });

  @override
  CustomTextFieldState createState() => CustomTextFieldState();
}

class CustomTextFieldState extends ConsumerState<CustomTextField> {
  bool showPassword = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: widget.margin.w),
      alignment: Alignment.center,
      child: TextFormField(
        key: widget.key,
        initialValue: widget.initialValue,
        readOnly: widget.readOnly,
        onChanged: (String value) {
          if (widget.onChange != null) {
            widget.onChange!(value);
          }
        },
        style: widget.style ??
            TextStyle(
              color: ColorsUtils.blackColor,
              fontSize: 14.spMin,
              fontWeight: FontWeight.w500,
            ),
        controller: widget.controller,
        enabled: widget.isEditable,
        cursorColor: ColorsUtils.kPrimaryColor,
        textInputAction: TextInputAction.next,
        obscureText: (widget.hasPassword) ? showPassword : widget.hasPassword,
        minLines: widget.isNotes ? 5 : 1,
        maxLines: widget.hasPassword ? 1 : widget.maxLine,
        textAlign: (widget.centerText) ? TextAlign.center : TextAlign.start,
                keyboardType: (widget.isEmail)
            ? TextInputType.emailAddress
            : (widget.isMobile)
                ? TextInputType.phone
                : (widget.isNumber)
                    ? TextInputType.number
                    : TextInputType.text,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: widget.hintStyle??AppStyles.styleRegular14(context),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 5.w,
            vertical: 3.h,
          ),
          enabledBorder: (!widget.hasBorder)
              ? InputBorder.none
              : buildOutlineInputBorder(),
          disabledBorder: (!widget.hasBorder)
              ? InputBorder.none
              : buildOutlineInputBorder(),
          border: (!widget.hasBorder)
              ? InputBorder.none
              : buildOutlineInputBorder(),
          focusedBorder: (!widget.hasBorder)
              ? InputBorder.none
              : buildOutlineInputBorder(width: 2),
          labelText: widget.label,
          labelStyle: TextStyle(
            color: ColorsUtils.blackColor.withAlpha(128),
            fontSize: 14.spMin,
            fontWeight: FontWeight.w400,
          ),
          suffixIcon: (widget.hasPassword)
              ? InkWell(
                  onTap: () {
                    showPassword = !showPassword;
                    setState(() {});
                  },
                  child: (!showPassword)
                      ? Icon(
                          Icons.visibility_outlined,
                          color: ColorsUtils.blackColor,
                          size: 18.w,
                        )
                      : Icon(
                          Icons.visibility_off_outlined,
                          color: ColorsUtils.blackColor,
                          size: 18.w,
                        ),
                )
              : (!widget.isPhoneCode)
                  ? widget.suffixIcon
                  : const SizedBox(),
          fillColor: (widget.filledColor == null)
              ? Colors.transparent
              : widget.filledColor,
          filled: true,
          prefixIcon: widget.prefixIcon,
        ),
      ),
    );
  }

  OutlineInputBorder buildOutlineInputBorder({double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.radius.r),
      borderSide:  BorderSide(
        color: ColorsUtils.kPrimaryColor,
        width: width
      ),
    );
  }
}
