import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iron_mine/core/helpers/routes.dart';
import 'package:iron_mine/core/utils/colors_utils.dart';
import 'package:iron_mine/data/models/request/orders/get_orders_request.dart';
import 'package:iron_mine/data/models/response/orders/get_zone_list_response.dart';

import '../../../core/helpers/view_functions.dart';
import '../../../data/repository/ticketsRepo/tickets_repo.dart';
import '../../../generated/l10n.dart';
import '../../screens/admin_users/extraction_admin_screen.dart';
import '../../screens/widgets/custom_loading.dart';
import '../../screens/widgets/custom_rounded_btn.dart';
import '../../screens/widgets/custom_textfield.dart';
import '../../screens/widgets/verified_zones_list.dart';

ChangeNotifierProvider<ExtractionAdminProvider> extractionAdminProvider =
    ChangeNotifierProvider<ExtractionAdminProvider>(
        (ref) => ExtractionAdminProvider());

class ExtractionAdminProvider extends ChangeNotifier {
  bool _addZoneLoading;
  bool _addLotLoading;

  ExtractionAdminProvider()
      : _addZoneLoading = false,
        _addLotLoading = false;

  /// add zone Dialog
  addZoneDialog({
    required BuildContext context,
  }) {
    TextEditingController zoneNameCnt = TextEditingController();
    AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader,
      bodyHeaderDistance: 0,
      showCloseIcon: true,
      alignment: Alignment.bottomCenter,
      dismissOnTouchOutside: true,
      animType: AnimType.bottomSlide,
      dialogBackgroundColor: ColorsUtils.whiteColor,
      padding: EdgeInsets.symmetric(
        horizontal: 15.w,
        vertical: 10.h,
      ),
      width: 1.sw,
      barrierColor: ColorsUtils.blackColor.withAlpha(26),
      body: Column(
        children: [
          30.verticalSpace,

          /// vehicle plate no
          CustomTextField(
            margin: 0,
            controller: zoneNameCnt,
            hintText: S.of(context).zoneName,
          ),
          20.verticalSpace,

          /// add button
          Consumer(
            builder: (context, ref, _) {
              ref.watch(extractionAdminProvider);
              return _addZoneLoading
                  ? Customloading(
                      width: 25.w,
                      color: ColorsUtils.kPrimaryColor,
                    )
                  : CustomRoundedButton(
                      backgroundColor: ColorsUtils.kPrimaryColor,
                      text: S.of(context).add,
                      fontSize: 16.spMin,
                      textColor: ColorsUtils.whiteColor,
                      width: 330.w,
                      height: 40.h,
                      radius: 10,
                      withShadow: false,
                      fontWeight: FontWeight.w400,
                      pressed: () async {
                        if (zoneNameCnt.text.isEmpty) {
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
                          addZone(
                            context: context,
                            zoneName: zoneNameCnt.text,
                            ref: ref,
                          );
                        }
                      },
                    );
            },
          ),
        ],
      ),
    ).show();
  }

  /// add zone function
  addZone({
    required BuildContext context,
    required WidgetRef ref,
    required String zoneName,
  }) async {
    _addZoneLoading = true;
    notifyListeners();
    TicketsRepository.addZone(
      zoneName: zoneName,
    ).then(
      (value) {
        _addZoneLoading = false;
        notifyListeners();
        if ((value.id?.isNotEmpty ?? false) && context.mounted) {
          ref.refresh(ExtractionZoneListScreen.rebuildProvider.notifier).state =
              true;
          CustomNavigator.popScreen(context: context);
          ViewFunctions.showCustomSnackBar(
            context: context,
            text: S.of(context).success,
            backgroundColor: Colors.green,
          );
        } else {
          CustomNavigator.popScreen(context: context);
          ViewFunctions.showCustomSnackBar(
            context: context,
            backgroundColor: Colors.redAccent,
            text: value.message ?? 'Error...',
          );
        }
      },
    ).catchError((err) {
      // ref.refresh(AllVehicleLoadsScreen.rebuildProvider.notifier).state = true;
      _addZoneLoading = false;
      notifyListeners();
      CustomNavigator.popScreen(context: context);
      ViewFunctions.showCustomSnackBar(
        context: context,
        text: err.toString(),
      );
    });
  }

  ///  ///////////////////////////////////// add new lot

  /// add zone Dialog
  addNewLotDialog({
    required BuildContext context,
  }) {
    TextEditingController lotNameCnt = TextEditingController();
    StateProvider<ZoneModel> vehicleItemProvider =
        StateProvider<ZoneModel>((ref) => ZoneModel());
    AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader,
      bodyHeaderDistance: 0,
      showCloseIcon: true,
      alignment: Alignment.bottomCenter,
      dismissOnTouchOutside: true,
      animType: AnimType.bottomSlide,
      dialogBackgroundColor: ColorsUtils.whiteColor,
      padding: EdgeInsets.symmetric(
        horizontal: 15.w,
        vertical: 10.h,
      ),
      width: 1.sw,
      barrierColor: ColorsUtils.blackColor.withAlpha(26),
      body: Column(
        children: [
          30.verticalSpace,

          /// verified  zones list
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                S.of(context).zoneName,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12.spMin,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 1,
              ),
              5.horizontalSpace,
              Expanded(
                flex: 2,
                child: Consumer(
                  builder:
                      (BuildContext context, WidgetRef ref, Widget? child) {
                    return InkWell(
                      onTap: () {
                        VerifiedZonesList()
                            .selectZoneDialog(
                          context: context,
                          futureBuilder:
                              TicketsRepository.getExtractionZonesList(
                            zonesType: 'verified',
                            getOrderRequest: GetOrdersRequest(),
                          ),
                        )
                            .then(
                          (value) {
                            if (value != null) {
                              log(value.toString());
                              ref.read(vehicleItemProvider.notifier).state =
                                  value;
                            }
                          },
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 15),
                        decoration: BoxDecoration(
                            color: ColorsUtils.whiteColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                10.toDouble(),
                              ),
                            ),
                            border: Border.all(
                              color: ColorsUtils.kPrimaryColor,
                            )),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Consumer(
                                builder: (context, ref, child) {
                                  final selectedZone =
                                      ref.watch(vehicleItemProvider);
                                  return Text(
                                    selectedZone.name ?? 'Zone Name',
                                    style: TextStyle(
                                      fontSize: 15.spMin,
                                      color: selectedZone.name?.isEmpty ?? true
                                          ? ColorsUtils.blackColor.withAlpha(128)
                                          : Colors.black,
                                    ),
                                  );
                                },
                              ),
                            ),
                            Icon(
                              Icons.arrow_drop_down,
                              size: 20,
                              color: ColorsUtils.blackColor.withAlpha(128),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          10.verticalSpace,
          CustomTextField(
            margin: 0,
            controller: lotNameCnt,
            hintText: S.of(context).addLotName,
          ),
          20.verticalSpace,
          /// add button
          Consumer(
            builder: (context, ref, _) {
              ExtractionAdminProvider orderPro =
                  ref.watch(extractionAdminProvider);
              final selectedZone = ref.watch(vehicleItemProvider);
              return orderPro.addLotLoading
                  ? Customloading(
                      width: 25.w,
                      color: ColorsUtils.kPrimaryColor,
                    )
                  : CustomRoundedButton(
                      backgroundColor: ColorsUtils.kPrimaryColor,
                      text: S.of(context).add,
                      fontSize: 16.spMin,
                      textColor: ColorsUtils.whiteColor,
                      width: 330.w,
                      height: 40.h,
                      radius: 10,
                      withShadow: false,
                      fontWeight: FontWeight.w400,
                      pressed: () async {
                        if ((selectedZone.id?.isEmpty ?? true) || lotNameCnt.text.isEmpty) {
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
                          orderPro.addNewLot(
                            context: context,
                            zoneId: selectedZone.id ?? '',
                            lotName: lotNameCnt.text ,
                            ref: ref,
                          );
                        }
                      },
                    );
            },
          ),
        ],
      ),
    ).show();
  }

  /// add lot function
  addNewLot({
    required BuildContext context,
    required WidgetRef ref,
    required String zoneId,
    required String lotName,
  }) async {
    _addLotLoading = true;
    notifyListeners();
    TicketsRepository.addNewLot(
      zoneId: zoneId,
      lotName: lotName,
    ).then(
      (value) {
        _addLotLoading = false;
        notifyListeners();
        if ((value.id?.isNotEmpty ?? false) && context.mounted) {
          CustomNavigator.popScreen(context: context);
          ViewFunctions.showCustomSnackBar(
            context: context,
            text: S.of(context).success,
            backgroundColor: Colors.green,
          );
        } else {
          CustomNavigator.popScreen(context: context);
          ViewFunctions.showCustomSnackBar(
            context: context,
            backgroundColor: Colors.redAccent,
            text: value.message ?? 'Error...',
          );
        }
      },
    ).catchError((err) {
      _addLotLoading = false;
      notifyListeners();
      CustomNavigator.popScreen(context: context);
      ViewFunctions.showCustomSnackBar(
        context: context,
        text: err.toString(),
      );
    });
  }

  bool get addZoneLoading => _addZoneLoading;

  bool get addLotLoading => _addLotLoading;
}
