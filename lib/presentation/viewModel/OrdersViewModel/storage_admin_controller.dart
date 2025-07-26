import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iron_mine/core/helpers/routes.dart';
import 'package:iron_mine/core/utils/colors_utils.dart';
import 'package:iron_mine/data/models/request/orders/get_orders_request.dart';
import 'package:iron_mine/data/models/response/orders/get_vehicles_list_response.dart';
import 'package:iron_mine/presentation/screens/widgets/vehicles_list.dart';

import '../../../core/helpers/view_functions.dart';
import '../../../data/repository/ticketsRepo/tickets_repo.dart';
import '../../../generated/l10n.dart';
import '../../screens/admin_users/storage_admins_ticket_screen.dart';
import '../../screens/widgets/custom_loading.dart';
import '../../screens/widgets/custom_rounded_btn.dart';
import '../../screens/widgets/custom_textfield.dart';

ChangeNotifierProvider<StorageAdminProvider> storageAdminProvider =
    ChangeNotifierProvider<StorageAdminProvider>((ref) => StorageAdminProvider());

class StorageAdminProvider extends ChangeNotifier {
  bool _storageReceiveLoading;

  StorageAdminProvider()
      : _storageReceiveLoading = false;


  /// storage receivable able Dialog
  storageReceivableDialog({
    required BuildContext context,
    required String ticketId,
  }) {
    StateProvider<VehicleItem> vehicleItemProvider =
        StateProvider<VehicleItem>((ref) => VehicleItem());
    TextEditingController weightCnt = TextEditingController();
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
                                    selectedVehicle.plateNumber ?? S.of(context).plateNumber,
                                    style: TextStyle(
                                      fontSize: 15.spMin,
                                      color:
                                      selectedVehicle.plateNumber?.isEmpty ?? true
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
            controller: weightCnt,
            hintText: S.of(context).weight,
            prefixIcon: Icon(
              Icons.monitor_weight_outlined,
              color: ColorsUtils.blackColor.withAlpha(128),
            ),
            suffixIcon: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 20.h,
                  width: 2.w,
                  color: ColorsUtils.blackColor.withAlpha(51),
                ),
                10.horizontalSpace,
                Text(
                  'TON',
                  style: TextStyle(
                    fontSize: 15.spMin,
                    color: ColorsUtils.blackColor.withAlpha(128),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                10.horizontalSpace,
              ],
            ),
            hintStyle: TextStyle(
              fontSize: 12.spMin,
              color: ColorsUtils.blackColor.withAlpha(128),
            ),
            isNumber: true,
            margin: 0,
          ),
          20.verticalSpace,
          /// receive button
          Consumer(
            builder: (context, ref, _) {
              //OrdersProvider orderPro = ref.watch(orderProvider);
              final selectedVehicle =
              ref.watch(vehicleItemProvider);
              return _storageReceiveLoading
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
                        if ((selectedVehicle.id?.isEmpty ??true) || weightCnt.text.isEmpty) {
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
                         storageReceiveTicket(
                            context: context,
                            ticketId: ticketId,
                           vehicleId: selectedVehicle.id??'',
                            weight:weightCnt.text,
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

  /// storage receive function
  storageReceiveTicket({
    required BuildContext context,
    required WidgetRef ref,
    required String ticketId,
    required String vehicleId,
    required String weight,
  }) async {
    _storageReceiveLoading = true;
    notifyListeners();
    TicketsRepository.storageReceiveTicket(
      ticketId: ticketId,
      vehicleId: vehicleId,
      weight: weight
    ).then(
      (value) {
        _storageReceiveLoading = false;
        notifyListeners();
        if ((value.id?.isNotEmpty ?? false) && context.mounted) {
          ref.refresh(StorageTicketScreen.rebuildProvider.notifier).state = true;
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
      _storageReceiveLoading = false;
      notifyListeners();
      CustomNavigator.popScreen(context: context);
      ViewFunctions.showCustomSnackBar(
        context: context,
        text: err.toString(),
      );
    });
  }

  bool get crusherReceiveLoading => _storageReceiveLoading;

}
