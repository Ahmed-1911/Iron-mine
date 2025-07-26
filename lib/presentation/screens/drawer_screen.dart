import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iron_mine/core/helpers/routes.dart';
import 'package:iron_mine/core/utils/colors_utils.dart';
import 'package:iron_mine/core/utils/enums.dart';
import 'package:iron_mine/presentation/screens/quality_users/quality_extraction_ticket_screen.dart';
import 'package:iron_mine/presentation/screens/quality_users/quality_storage_ticket_screen.dart';
import 'package:iron_mine/presentation/screens/quality_users/zone_list_screen.dart';

import '../../core/helpers/view_functions.dart';
import '../../core/utils/token_util.dart';
import '../../core/utils/constants.dart';
import '../../core/utils/preference_manger.dart';
import '../../generated/l10n.dart';
import '../viewModel/OrdersViewModel/extractoin_admin_controller.dart';
import 'authorization/login/login_screen.dart';
import 'widgets/custom_rounded_btn.dart';

// ignore: must_be_immutable
class DrawerScreen extends ConsumerWidget {
  DrawerScreen({super.key});

  StateProvider<String> nameProvider = StateProvider<String>(
    (ref) => '',
  );
  StateProvider<String> roleProvider = StateProvider<String>(
    (ref) => '',
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
        ref.read(nameProvider.notifier).state =
            await PreferenceManager.getInstance().getString(Constants.userName);
        ref.read(roleProvider.notifier).state =
            await PreferenceManager.getInstance().getString(Constants.role);
      });
    });
    final userName = ref.watch(nameProvider);
    final userRole = ref.watch(roleProvider);
    Widget navigationDrawerList(BuildContext context) {
      return SingleChildScrollView(
        child: SizedBox(
          height: 1.sh * .9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //  backgroundColor:  Colors.grey.withOpacity(.01),
            children: [
              Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.close,
                          color: ColorsUtils.kPrimaryColor,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                  Image.asset(
                    'assets/images/splash.jpg',
                    width: 100.w,
                    height: 100.h,
                  )
                      .animate()
                      .fade(
                        duration: Duration(seconds: 1),
                      ) // uses `Animate.defaultDuration`
                      .scale(),
                  10.verticalSpace,
                  Container(
                    width: 1.sw,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      color: ColorsUtils.kPrimaryColor,
                    ),
                    child: Row(
                      children: [
                        Text(
                          userName,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14.spMin,
                            color: ColorsUtils.whiteColor,
                          ),
                        ),
                        Spacer(),
                        Icon(
                          Icons.verified_user,
                          color: Colors.white,
                          size: 20.spMin,
                        ),
                        5.horizontalSpace,
                        Text(
                          userRole,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 10.spMin,
                            color: ColorsUtils.whiteColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  30.verticalSpace,

                  /// home list
                  userRole == RolesEnum.extractionQuality
                      ? InkWell(
                          onTap: () {
                            CustomNavigator.pushScreenReplacement(
                              context: context,
                              widget: QualityExtractionTicketScreen(),
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Row(
                              //  mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  S.of(context).home,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.spMin,
                                    color: ColorsUtils.kPrimaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : SizedBox(),
                  userRole == RolesEnum.extractionQuality
                      ? Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.sp),
                          child: Divider(
                            thickness: 1,
                            height: 20.h,
                            color: ColorsUtils.blackColor.withAlpha(10),
                          ),
                        )
                      : SizedBox(),

                  /// create new lot
                  userRole == RolesEnum.extractionAdmin
                      ? InkWell(
                          onTap: () {
                            ExtractionAdminProvider extractionPro =
                                ref.read(extractionAdminProvider);
                            extractionPro.addNewLotDialog(
                              context: context,
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Row(
                              //  mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  S.of(context).createNewLot,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.spMin,
                                    color: ColorsUtils.kPrimaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : SizedBox(),

                  userRole == RolesEnum.extractionAdmin
                      ? Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.sp),
                          child: Divider(
                            thickness: 1,
                            height: 20.h,
                            color: ColorsUtils.blackColor.withAlpha(10),
                          ),
                        )
                      : SizedBox(),

                  /// view finished storage quality tickets
                  userRole == RolesEnum.extractionAdmin
                      ? InkWell(
                          onTap: () {
                            CustomNavigator.pushScreen(
                              context: context,
                              widget: QualityStorageTicketScreen(),
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Row(
                              //  mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  S.of(context).finishedStorageQualityTickets,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.spMin,
                                    color: ColorsUtils.kPrimaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : SizedBox(),
                  userRole == RolesEnum.extractionAdmin
                      ? Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.sp),
                          child: Divider(
                            thickness: 1,
                            height: 20.h,
                            color: ColorsUtils.blackColor.withAlpha(10),
                          ),
                        )
                      : SizedBox(),

                  /// view finished extraction quality tickets
                  userRole == RolesEnum.extractionAdmin
                      ? InkWell(
                          onTap: () {
                            CustomNavigator.pushScreen(
                              context: context,
                              widget: QualityExtractionTicketScreen(),
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Row(
                              //  mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  S.of(context).finishedExtractionTickets,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.spMin,
                                    color: ColorsUtils.kPrimaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : SizedBox(),
                  userRole == RolesEnum.extractionAdmin
                      ? Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.sp),
                          child: Divider(
                            thickness: 1,
                            height: 20.h,
                            color: ColorsUtils.blackColor.withAlpha(10),
                          ),
                        )
                      : SizedBox(),

                  /// zone list
                  userRole == RolesEnum.extractionQuality
                      ? InkWell(
                          onTap: () {
                            CustomNavigator.pushScreen(
                              context: context,
                              widget: ZoneListScreen(),
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Row(
                              //  mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  S.of(context).zonesReview,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.spMin,
                                    color: ColorsUtils.kPrimaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : SizedBox(),
                  userRole == RolesEnum.extractionQuality
                      ? Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.sp),
                          child: Divider(
                            thickness: 1,
                            height: 20.h,
                            color: ColorsUtils.blackColor.withAlpha(10),
                          ),
                        )
                      : SizedBox(),

                  /// language container
                  InkWell(
                    onTap: () {
                      ViewFunctions.languageDialog(context: context, ref: ref);
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Row(
                        //  mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            S.of(context).language,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14.spMin,
                              color: ColorsUtils.kPrimaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.sp),
                    child: Divider(
                      thickness: 1,
                      height: 20.h,
                      color: ColorsUtils.blackColor.withAlpha(10),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: CustomRoundedButton(
                  backgroundColor: ColorsUtils.redColor,
                  text: S.of(context).logOut,
                  fontSize: 16.spMin,
                  textColor: ColorsUtils.whiteColor,
                  width: 1.sw,
                  height: 50.h,
                  radius: 20,
                  withShadow: false,
                  fontWeight: FontWeight.w400,
                  pressed: () {
                    TokenUtil.clearToken();
                    PreferenceManager.instance.remove(Constants.userName);
                    PreferenceManager.instance.remove(Constants.role);
                    PreferenceManager.instance.remove(Constants.token);
                    PreferenceManager.instance.remove(Constants.userId);
                    PreferenceManager.instance.remove(Constants.userPhone);
                    CustomNavigator.cleanAndPush(
                      context: context,
                      widget: LogInScreen(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(child: navigationDrawerList(context)),
    );
  }
}
