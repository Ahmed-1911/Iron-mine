import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iron_mine/core/helpers/routes.dart';
import 'package:iron_mine/core/utils/app_styles.dart';
import 'package:iron_mine/core/utils/colors_utils.dart';
import 'package:iron_mine/presentation/screens/authorization/login/login_screen.dart';
import 'package:iron_mine/presentation/screens/widgets/custom_textfield.dart';

import '../../../../core/helpers/view_functions.dart';
import '../../../../generated/l10n.dart';
import '../../../viewModel/AuthViewModels/auth_controller.dart';
import '../../widgets/custom_loading.dart';
import '../../widgets/custom_rounded_btn.dart';

class LoginWithOtpScreen extends StatelessWidget {
  final phoneCnt = TextEditingController();
  final passwordCnt = TextEditingController();
  final otpCnt = TextEditingController();
  final confirmPasswordCnt = TextEditingController();

  LoginWithOtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SafeArea(
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(
              horizontal: 24.w,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: 'logo',
                    child: Image.asset(
                      'assets/images/logo.jpg',
                    ),
                  ),
                  Text(S.of(context).registerWithOtp,
                      style: AppStyles.styleSemiBold18(context).copyWith(color: ColorsUtils.blackColor)),
                  10.verticalSpace,
                  CustomTextField(
                    prefixIcon: const Icon(Icons.phone),
                    margin: 0,
                    isMobile: true,
                    hintText: S.of(context).phoneNumber,
                    controller: phoneCnt,
                  )
                      .animate()
                      .fade() // uses `Animate.defaultDuration`
                      .scale()
                      .move(
                        duration: 1.seconds,
                        begin: Offset(-15, 0),
                      ),
                  15.verticalSpace,
                  CustomTextField(
                    prefixIcon: const Icon(Icons.message),
                    margin: 0,
                    isNumber: true,
                    hintText: S.of(context).otp,
                    controller: otpCnt,
                  )
                      .animate()
                      .fade() // uses `Animate.defaultDuration`
                      .scale()
                      .move(
                        duration: 1.seconds,
                        begin: Offset(15, 0),
                      ),
                  15.verticalSpace,
                  CustomTextField(
                    prefixIcon: const Icon(Icons.lock),
                    margin: 0,
                    hasPassword: true,
                    hintText: S.of(context).password,
                    controller: passwordCnt,
                  )
                      .animate()
                      .fade() // uses `Animate.defaultDuration`
                      .scale()
                      .move(
                        duration: 1.seconds,
                        begin: Offset(-15, 0),
                      ),
                  15.verticalSpace,
                  CustomTextField(
                    prefixIcon: const Icon(Icons.lock),
                    margin: 0,
                    hasPassword: true,
                    hintText: S.of(context).confirmPassword,
                    controller: confirmPasswordCnt,
                  )
                      .animate()
                      .fade() // uses `Animate.defaultDuration`
                      .scale()
                      .move(
                        duration: 1.seconds,
                        begin: Offset(-15, 0),
                      ),
                  30.verticalSpace,
                  Align(
                    alignment: Alignment.center,
                    child: Consumer(
                      builder: (context, ref, _) {
                        AuthProvider authPro = ref.watch(authProvider);
                        return authPro.logInWithOtpLoading
                            ? Customloading(
                                width: 40.w,
                                color: ColorsUtils.kPrimaryColor,
                              )
                            : CustomRoundedButton(
                                backgroundColor: ColorsUtils.kPrimaryColor,
                                text: S.of(context).login,
                                textColor: ColorsUtils.whiteColor,
                                width: 1.sw,
                                height: 50.h,
                                radius: 10,
                                withShadow: false,
                                fontWeight: FontWeight.w400,
                                pressed: () {
                                  if (phoneCnt.text.isEmpty ||
                                      otpCnt.text.isEmpty ||
                                      passwordCnt.text.isEmpty ||
                                      confirmPasswordCnt.text.isEmpty) {
                                    ViewFunctions.messageDialog(
                                      context: context,
                                      message: S.of(context).addAllFieldsFirst,
                                      function: () {
                                        CustomNavigator.popScreen(
                                          context: context,
                                        );
                                      },
                                    );
                                  } else {
                                    authPro.logInWithOtp(
                                      context: context,
                                      passwordCnt: passwordCnt,
                                      phoneCnt: phoneCnt,
                                      otpCnt: otpCnt,
                                      confirmPasswordCnt: confirmPasswordCnt,
                                    );
                                  }
                                },
                              );
                      },
                    ),
                  )
                      .animate()
                      .fade() // uses `Animate.defaultDuration`
                      .scale()
                      .move(
                        delay: 500.ms,
                        duration: 1.seconds,
                        begin: Offset(0, 15),
                        curve: Curves.bounceOut,
                      ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        onTap: () {
                          CustomNavigator.cleanAndPush(
                            context: context,
                            widget: LogInScreen(),
                          );
                        },
                        child: Text(S.of(context).alreadyRegistered,
                            style: AppStyles.styleRegular16(context)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
