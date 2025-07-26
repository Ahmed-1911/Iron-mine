import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iron_mine/core/helpers/routes.dart';
import 'package:iron_mine/generated/l10n.dart';

import '../../presentation/screens/widgets/custom_loading.dart';
import '../../presentation/viewModel/locale/localization_provider.dart';
import '../utils/colors_utils.dart';

class ViewFunctions {
  static void languageDialog({
    required WidgetRef ref,
    required BuildContext context,
  }) {
    final locProvider = ref.read(localProvider);
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => CupertinoAlertDialog(
        content: Card(
          color: ColorsUtils.transparentColor,
          elevation: 0,
          child: Column(
            children: [
              InkWell(
                onTap: () async {
                  locProvider.changeLanguage(const Locale("en"));
                  CustomNavigator.popScreen(context: context);
                },
                child: Text(
                  'English',
                  style: TextStyle(
                    fontSize: locProvider.appLocal == const Locale('en')
                        ? 17.spMin
                        : 15.spMin,
                    color: locProvider.appLocal == const Locale('en')
                        ? ColorsUtils.kPrimaryColor
                        : ColorsUtils.blackColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              InkWell(
                onTap: () async {
                  locProvider.changeLanguage(const Locale("ar"));
                  CustomNavigator.popScreen(context: context);
                },
                child: Text(
                  'العربية',
                  style: TextStyle(
                    fontSize: locProvider.appLocal == const Locale('ar')
                        ? 17.spMin
                        : 15.spMin,
                    color: locProvider.appLocal == const Locale('ar')
                        ? ColorsUtils.kPrimaryColor
                        : ColorsUtils.blackColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void showCustomSnackBar({
    required BuildContext context,
    required String text,
    bool? hasIcon,
    IconData? iconType,
    Color? iconColor,
    Color? backgroundColor,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        content: Row(
          children: [
            hasIcon ?? false
                ? Icon(
                    iconType,
                    color: iconColor,
                  )
                : Container(
                    height: 22.0,
                  ),
            SizedBox(
              width: 10.w,
            ),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(fontSize: 15.0),
              ),
            ),
          ],
        ),
        elevation: 50,
        backgroundColor: backgroundColor ?? ColorsUtils.blackColor,
      ),
    );
  }

  static void successRegisterDialog({
    required BuildContext context,
    required String text,
    Function? function,
  }) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      bodyHeaderDistance: 0,
      dismissOnTouchOutside: false,
      animType: AnimType.topSlide,
      btnOkColor: ColorsUtils.kPrimaryColor,
      btnOkOnPress: () {
        function != null ? function() : () {};
      },
      btnOkText: S.of(context).ok,
      dialogBackgroundColor: ColorsUtils.whiteColor,
      padding: EdgeInsets.symmetric(
        horizontal: 10.w,
        vertical: 10.h,
      ),
      width: 0.7.sw,
      barrierColor: ColorsUtils.blackColor.withAlpha(100),
      body: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: ColorsUtils.blackColor,
            fontSize: 15.spMin,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ).show();
  }

  static void messageDialog({
    required BuildContext context,
    required String message,
    String actionTitle = 'OK',
    required Function function,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CupertinoAlertDialog(
        content: SelectableText(
          message,
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () {
              function();
            },
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                actionTitle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static void loadingDialog({required BuildContext context}) {
    showDialog(
      barrierDismissible: false,
      barrierColor: ColorsUtils.kPrimaryColor.withAlpha(100),
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ColorsUtils.transparentColor,
        contentPadding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 0.w),
        content: Container(
          height: 60.h,
          decoration: BoxDecoration(
            color: ColorsUtils.whiteColor,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 10.w,
              ),
              SizedBox(
                width: 30,
                height: 30,
                child: Customloading(
                  width: 30.w,
                  color: ColorsUtils.kPrimaryColor,
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
              const Text(
                "wait....",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
