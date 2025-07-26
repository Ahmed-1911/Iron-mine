import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iron_mine/core/helpers/routes.dart';
import 'package:iron_mine/core/helpers/view_functions.dart';
import 'package:iron_mine/core/utils/app_styles.dart';
import 'package:iron_mine/core/utils/colors_utils.dart';
import 'package:iron_mine/presentation/screens/authorization/login/login_with_otp_screen.dart';

import '../../../../generated/l10n.dart';
import '../../../viewModel/AuthViewModels/auth_controller.dart';
import '../../widgets/custom_loading.dart';
import '../../widgets/custom_rounded_btn.dart';
import '../../widgets/custom_textfield.dart';

class LogInScreen extends StatelessWidget {
  LogInScreen({super.key});

  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

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
                      'assets/images/splash.jpg',
                      width: 1.sw,
                      height: 300.h,
                      fit: BoxFit.fill,
                    ),
                  ),
                  50.verticalSpace,

                  /// debug auth 
                  kDebugMode
                      ? Container(
                          height: 50.h,
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(
                              color: ColorsUtils.kPrimaryColor,
                            ),
                          ),
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              UserRole(
                                phoneController: phoneController,
                                passwordController: passwordController,
                                phone: '01111111111',
                                role: 'crusher Admin',
                              ),
                              UserRole(
                                phoneController: phoneController,
                                passwordController: passwordController,
                                phone: '01222222222',
                                role: 'storage Admin',
                              ),
                              UserRole(
                                phoneController: phoneController,
                                passwordController: passwordController,
                                phone: '01333333333',
                                role: 'extraction quality',
                              ),
                              UserRole(
                                phoneController: phoneController,
                                passwordController: passwordController,
                                phone: '01444444444',
                                role: 'storage quality',
                              ),
                              UserRole(
                                phoneController: phoneController,
                                passwordController: passwordController,
                                phone: '01555555555',
                                role: 'extraction admin',
                              ),
                            ],
                          ),
                        )
                      : SizedBox(),
                  10.verticalSpace,
                  CustomTextField(
                    controller: phoneController,
                    hintText: S.of(context).phoneNumber,
                    prefixIcon: const Icon(Icons.phone),
                    margin: 0,
                    isMobile: true,
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
                    hasPassword: true,
                    controller: passwordController,
                    hintText: S.of(context).password,
                    prefixIcon: const Icon(Icons.lock),
                    margin: 0,
                  )
                      .animate()
                      .fade() // uses `Animate.defaultDuration`
                      .scale()
                      .move(
                        duration: 1.seconds,
                        begin: Offset(15, 0),
                      ),
                  10.verticalSpace,
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          CustomNavigator.pushScreen(
                            context: context,
                            widget: LoginWithOtpScreen(),
                          );
                        },
                        child: Text(S.of(context).registerWithOtp,
                            style: AppStyles.styleRegular16(context)),
                      ),
                    ],
                  ),
                  50.verticalSpace,

                  /// log in button
                  Align(
                    alignment: Alignment.center,
                    child: Consumer(
                      builder: (context, ref, _) {
                        AuthProvider authPro = ref.watch(authProvider);
                        return authPro.logInLoading
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
                                  if (phoneController.text.isEmpty ||
                                      passwordController.text.isEmpty) {
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
                                    authPro.logIn(
                                      context: context,
                                      passwordCnt: passwordController,
                                      phoneCnt: phoneController,
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
                  10.verticalSpace,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class UserRole extends StatelessWidget {
  const UserRole({
    super.key,
    required this.phoneController,
    required this.passwordController,
    required this.role,
    required this.phone,
  });

  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final String role, phone;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        phoneController.text = phone;
        passwordController.text = '0000';
      },
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(
          horizontal: 10.w,
          vertical: 5.h,
        ),
        margin: EdgeInsets.symmetric(horizontal: 3.w),
        decoration: BoxDecoration(
          color: ColorsUtils.kMainSecondaryColor,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Text(
          role,
          style: AppStyles.styleMedium16(context)
              .copyWith(color: ColorsUtils.whiteColor),
        ),
      ),
    );
  }
}
