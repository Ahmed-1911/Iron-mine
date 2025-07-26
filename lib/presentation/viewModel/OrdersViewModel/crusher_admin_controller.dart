import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iron_mine/core/helpers/routes.dart';
import 'package:iron_mine/core/utils/app_styles.dart';
import 'package:iron_mine/core/utils/colors_utils.dart';
import 'package:iron_mine/data/models/request/orders/get_orders_request.dart';
import 'package:iron_mine/data/models/response/orders/get_vehicles_list_response.dart';
import 'package:iron_mine/presentation/screens/widgets/vehicles_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/helpers/view_functions.dart';
import '../../../data/repository/ticketsRepo/tickets_repo.dart';
import '../../../generated/l10n.dart';
import '../../screens/admin_users/crusher_admins_ticket_screen.dart';
import '../../screens/widgets/custom_loading.dart';
import '../../screens/widgets/custom_rounded_btn.dart';

ChangeNotifierProvider<CrusherAdminProvider> orderProvider =
    ChangeNotifierProvider<CrusherAdminProvider>(
        (ref) => CrusherAdminProvider());

class CrusherAdminProvider extends ChangeNotifier {
  final bool _receiveLoading;
  bool _crusherReceiveLoading;
  bool _crusherDispatchLoading;
  final List<String> _selectedCrushingTickets = [];

  CrusherAdminProvider()
      : _receiveLoading = false,
        _crusherReceiveLoading = false,
        _crusherDispatchLoading = false;

  Future<bool> isConnected() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult[0] != ConnectivityResult.none;
  }

  /// save report offline
  Future<void> saveReportOffline({
    required String ticketId,
    required String plateNo,
    required String reportType,
    List<String>? ticketIds,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final reports = prefs.getStringList('offline_requests') ?? [];
    
    if (reportType == 'crush' && ticketIds != null) {
      reports.add('${ticketIds.join(",")}##$reportType');
    } else {
      reports.add('$ticketId#$plateNo#$reportType');
    }
    
    await prefs.setStringList('offline_requests', reports);
  }

  /// crusher receivable able Dialog
  crusherReceivableDialog({
    required BuildContext context,
    required String ticketId,
  }) {
    StateProvider<VehicleItem> vehicleItemProvider =
        StateProvider<VehicleItem>((ref) => VehicleItem());
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                S.of(context).receivedFrom,
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
                        VehiclesList()
                            .selectVehicleDialog(
                          context: context,
                          futureBuilder: TicketsRepository.getVehicleItems(
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
                                  final selectedVehicle =
                                      ref.watch(vehicleItemProvider);
                                  return Text(
                                    selectedVehicle.plateNumber ??
                                        S.of(context).plateNumber,
                                    style: TextStyle(
                                      fontSize: 15.spMin,
                                      color: selectedVehicle
                                                  .plateNumber?.isEmpty ??
                                              true
                                          ? ColorsUtils.blackColor
                                              .withAlpha(128)
                                          : Colors.black,
                                    ),
                                  );
                                },
                              ),
                            ),
                            Icon(
                              Icons.arrow_drop_down,
                              size: 20,
                              color: ColorsUtils.blackColor.withAlpha(50),
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
          20.verticalSpace,

          /// receive button
          Consumer(
            builder: (context, ref, _) {
              CrusherAdminProvider orderPro = ref.watch(orderProvider);
              final selectedVehicle = ref.watch(vehicleItemProvider);
              return orderPro.crusherReceiveLoading
                  ? Customloading(
                      width: 25.w,
                      color: ColorsUtils.kPrimaryColor,
                    )
                  : CustomRoundedButton(
                      backgroundColor: ColorsUtils.kPrimaryColor,
                      text: S.of(context).submit,
                      fontSize: 16.spMin,
                      textColor: ColorsUtils.whiteColor,
                      width: 330.w,
                      height: 40.h,
                      radius: 10,
                      withShadow: false,
                      fontWeight: FontWeight.w400,
                      pressed: () async {
                        if (selectedVehicle.id?.isEmpty ?? true) {
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
                          orderPro.crusherReceiveTicket(
                            context: context,
                            ticketId: ticketId,
                            plateNo: selectedVehicle.plateNumber ?? '',
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

  /// crusher receive function
  crusherReceiveTicket({
    required BuildContext context,
    required WidgetRef ref,
    required String ticketId,
    required String plateNo,
  }) async {
    _crusherReceiveLoading = true;
    notifyListeners();
    final bool connected = await isConnected();
    if (!connected) {
      // حفظ البيانات مؤقتًا
      await saveReportOffline(
        ticketId: ticketId,
        reportType: 'receive',
        plateNo: plateNo,
      );
      _crusherReceiveLoading = false;
      notifyListeners();
      CustomNavigator.popScreen(context: context);
      ViewFunctions.showCustomSnackBar(
        context: context,
        text: 'تم حفظ التقرير مؤقتًا. سيتم إرساله عند استعادة الاتصال.',
        backgroundColor: Colors.orange,
      );
      return;
    }
    TicketsRepository.crusherReceiveTicket(
      ticketId: ticketId,
      plateNo: plateNo,
    ).then(
      (value) {
        _crusherReceiveLoading = false;
        notifyListeners();
        if ((value.id?.isNotEmpty ?? false) && context.mounted) {
          ref.refresh(CrusherTicketScreen.rebuildProvider.notifier).state =
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
      _crusherReceiveLoading = false;
      notifyListeners();
      CustomNavigator.popScreen(context: context);
      ViewFunctions.showCustomSnackBar(
        context: context,
        text: err.toString(),
      );
    });
  }

  //////////////////////////////////////////////////////////////////////////////////////

  /// crusher crushing Dialog
  crusherCrushingDialogMultiple({
    required BuildContext context,
    required List<String> ticketIds,
  }) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader,
      bodyHeaderDistance: 0,
      showCloseIcon: true,
      alignment: Alignment.center,
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
          20.verticalSpace,
          Text(
            S.of(context).confirmCrushing,
            style: AppStyles.styleSemiBold18(context).copyWith(
              color: ColorsUtils.blackColor,
            ),
          ),
          20.verticalSpace,

          // receive button
          Consumer(
            builder: (context, ref, _) {
              CrusherAdminProvider orderPro = ref.watch(orderProvider);
              return Row(
                children: [
                  Expanded(
                    child: CustomRoundedButton(
                      backgroundColor: Colors.green,
                      text: S.of(context).submit,
                      fontSize: 14.spMin,
                      width: 330.w,
                      height: 30.h,
                      radius: 10,
                      withShadow: false,
                      fontWeight: FontWeight.w400,
                      pressed: () async {
                        orderPro.crusherCrushingTicket(
                          context: context,
                          ticketIds: ticketIds,
                          ref: ref,
                        );
                      },
                    ),
                  ),
                  10.horizontalSpace,
                  Expanded(
                    child: CustomRoundedButton(
                      backgroundColor: ColorsUtils.redColor,
                      text: S.of(context).cancel,
                      fontSize: 14.spMin,
                      width: 330.w,
                      height: 30.h,
                      radius: 10,
                      withShadow: false,
                      fontWeight: FontWeight.w400,
                      pressed: () async {
                        CustomNavigator.popScreen(context: context);
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    ).show();
  }

  /// crusher crushing function
  crusherCrushingTicket({
    required BuildContext context,
    required WidgetRef ref,
    required List<String> ticketIds,
  }) async {
    ViewFunctions.loadingDialog(context: context);
    final bool connected = await isConnected();
    if (!connected) {
      // حفظ البيانات مؤقتًا
      await saveReportOffline(
        ticketId: '',
        reportType: 'crush',
        plateNo: '',
        ticketIds: ticketIds,
      );
      CustomNavigator.popScreen(context: context);
      CustomNavigator.popScreen(context: context);
      ViewFunctions.showCustomSnackBar(
        context: context,
        text: 'تم حفظ التقرير مؤقتًا. سيتم إرساله عند استعادة الاتصال.',
        backgroundColor: Colors.orange,
      );
      return;
    }
    TicketsRepository.crusherCrushTicket(
      ticketIds: ticketIds,
    ).then(
      (value) {
        CustomNavigator.popScreen(context: context);
        if ((value.id?.isNotEmpty ?? false) && context.mounted) {
          ref.refresh(CrusherTicketScreen.rebuildProvider.notifier).state =
              true;
          clearSelectedCrushingTickets();
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
      CustomNavigator.popScreen(context: context);
      CustomNavigator.popScreen(context: context);
      ViewFunctions.showCustomSnackBar(
        context: context,
        text: err.toString(),
      );
    });
  }

/////////////////////////////////////////////////////////////////////////////////////////
  /// crusher dispatch able Dialog
  crusherDispatchDialog({
    required BuildContext context,
    required String ticketId,
  }) {
    StateProvider<VehicleItem> vehicleItemProvider =
        StateProvider<VehicleItem>((ref) => VehicleItem());
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                S.of(context).dispatchBy,
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
                        VehiclesList()
                            .selectVehicleDialog(
                          context: context,
                          futureBuilder: TicketsRepository.getVehicleItems(
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
                                  final selectedVehicle =
                                      ref.watch(vehicleItemProvider);
                                  return Text(
                                    selectedVehicle.plateNumber ??
                                        S.of(context).plateNumber,
                                    style: TextStyle(
                                      fontSize: 12.spMin,
                                      color: selectedVehicle
                                                  .plateNumber?.isEmpty ??
                                              true
                                          ? ColorsUtils.blackColor
                                              .withAlpha(128)
                                          : Colors.black,
                                    ),
                                  );
                                },
                              ),
                            ),
                            Icon(
                              Icons.arrow_drop_down,
                              size: 20,
                              color: ColorsUtils.blackColor.withAlpha(50),
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
          20.verticalSpace,

          /// dispatch button
          Consumer(
            builder: (context, ref, _) {
              CrusherAdminProvider orderPro = ref.watch(orderProvider);
              final selectedVehicle = ref.watch(vehicleItemProvider);
              return orderPro.crusherDispatchLoading
                  ? Customloading(
                      width: 25.w,
                      color: ColorsUtils.kPrimaryColor,
                    )
                  : CustomRoundedButton(
                      backgroundColor: ColorsUtils.kPrimaryColor,
                      text: S.of(context).submit,
                      fontSize: 16.spMin,
                      textColor: ColorsUtils.whiteColor,
                      width: 330.w,
                      height: 40.h,
                      radius: 10,
                      withShadow: false,
                      fontWeight: FontWeight.w400,
                      pressed: () async {
                        if (selectedVehicle.id?.isEmpty ?? true) {
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
                          orderPro.crusherDispatchTicket(
                            context: context,
                            ticketId: ticketId,
                            vehicleId: selectedVehicle.id ?? '',
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

  /// crusher dispatch function
  crusherDispatchTicket({
    required BuildContext context,
    required WidgetRef ref,
    required String ticketId,
    required String vehicleId,
  }) async {
    _crusherDispatchLoading = true;
    notifyListeners();
    final bool connected = await isConnected();
    if (!connected) {
      // حفظ البيانات مؤقتًا
      await saveReportOffline(
        ticketId: ticketId,
        reportType: 'dispatch',
        plateNo: vehicleId,
      );
      _crusherDispatchLoading = false;
      notifyListeners();
      CustomNavigator.popScreen(context: context);
      ViewFunctions.showCustomSnackBar(
        context: context,
        text: 'تم حفظ التقرير مؤقتًا. سيتم إرساله عند استعادة الاتصال.',
        backgroundColor: Colors.orange,
      );
      return;
    }
    TicketsRepository.crusherDispatchTicket(
      ticketId: ticketId,
      vehicleId: vehicleId,
    ).then(
      (value) {
        _crusherDispatchLoading = false;
        notifyListeners();
        if ((value.id?.isNotEmpty ?? false) && context.mounted) {
          ref.refresh(CrusherTicketScreen.rebuildProvider.notifier).state =
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
      _crusherDispatchLoading = false;
      notifyListeners();
      CustomNavigator.popScreen(context: context);
      ViewFunctions.showCustomSnackBar(
        context: context,
        text: err.toString(),
      );
    });
  }

  ///Resending interim reports when the connection is restored
  Future<void> retryOfflineRequests(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final reports = prefs.getStringList('offline_requests') ?? [];

    if (reports.isEmpty) return;

    ViewFunctions.showCustomSnackBar(
      context: context,
      text: "Sending offline reports...",
    );

    final List<String> reportsToRetry = List.from(reports);

    for (final report in reportsToRetry) {
      try {
        final reportDetails = _parseReport(report);
        if (reportDetails == null) continue;

        if (reportDetails['reportType'] == 'crush') {
          await processReport(
            context: context,
            ticketId: '',
            plateNo: '',
            reportType: 'crush',
            ticketIds: reportDetails['ticketIds'] as List<String>,
          );
        } else {
          await processReport(
            context: context,
            ticketId: reportDetails['ticketId'] ?? '',
            plateNo: reportDetails['plateNo'] ?? '',
            reportType: reportDetails['reportType'] ?? 'receive',
          );
        }

        reports.remove(report);
      } catch (err) {
        log('Failed to retry report: $err');
      }
    }

    await prefs.setStringList('offline_requests', reports);
    log("Reports after processing: $reports");
  }

  /// Parses the report string into its components.
  Map<String, dynamic>? _parseReport(String report) {
    try {
      final parts = report.split('#');
      
      if (parts.length == 2 && parts[1] == 'crush') {
        final ticketIds = parts[0].split(',');
        return {
          'ticketIds': ticketIds,
          'reportType': 'crush',
        };
      }
      
      if (parts.length < 3) return null;
      return {
        'ticketId': parts[0],
        'plateNo': parts[1],
        'reportType': parts[2],
      };
    } catch (e) {
      log('Failed to parse report: $e');
      return null;
    }
  }

  /// Processes a single report based on its type.
  Future<bool> processReport({
    required BuildContext context,
    required String ticketId,
    required String plateNo,
    required String reportType,
    List<String>? ticketIds,
  }) async {
    try {
      if (reportType == 'receive') {
        final result = await TicketsRepository.crusherReceiveTicket(
          ticketId: ticketId,
          plateNo: plateNo
        );
        return _handleResponse(context, result);
      }
      else if (reportType == 'crush') {
        final result = await TicketsRepository.crusherCrushTicket(
          ticketIds: ticketIds ?? [ticketId],
        );
        return _handleResponse(context, result);
      } else {
        final result = await TicketsRepository.crusherDispatchTicket(
          vehicleId: plateNo,
          ticketId: ticketId,
        );
        return _handleResponse(context, result);
      }
    } catch (err) {
      log('Error processing report: $err');
      return false;
    }
  }

  /// Handles the response and displays the appropriate message.
  bool _handleResponse(BuildContext context, dynamic response) {
    if (response.id?.isNotEmpty ?? false) {
      ViewFunctions.showCustomSnackBar(
        context: context,
        text: S.of(context).success,
        backgroundColor: Colors.green,
      );
      return true;
    } else {
      ViewFunctions.showCustomSnackBar(
        context: context,
        backgroundColor: Colors.redAccent,
        text: response.message ?? 'Error...',
      );
      return false;
    }
  }


  void addSelectedCrushingTicket(String ticketId) {
    _selectedCrushingTickets.add(ticketId);
    notifyListeners();
  }

  void removeSelectedCrushingTicket(String ticketId) {
    _selectedCrushingTickets.remove(ticketId);
    notifyListeners();
  }

  void clearSelectedCrushingTickets() {
    _selectedCrushingTickets.clear();
    notifyListeners();
  }


  bool get receiveLoading => _receiveLoading;

  List<String> get selectedCrushingTickets => _selectedCrushingTickets;

  bool get crusherReceiveLoading => _crusherReceiveLoading;

  bool get crusherDispatchLoading => _crusherDispatchLoading;
}
