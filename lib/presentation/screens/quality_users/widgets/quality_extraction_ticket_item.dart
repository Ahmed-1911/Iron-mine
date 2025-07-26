import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iron_mine/core/utils/app_styles.dart';
import 'package:iron_mine/core/utils/colors_utils.dart';
import 'package:iron_mine/core/utils/token_util.dart';
import 'package:iron_mine/presentation/screens/widgets/custom_rounded_btn.dart';

import '../../../../core/utils/enums.dart';
import '../../../../data/models/response/orders/get_storage_quality_tickets_response.dart';
import '../../../../generated/l10n.dart';
import '../../../viewModel/OrdersViewModel/extraction-quality_controller.dart';

class QualityExtractionTicketItem extends ConsumerWidget {
  const QualityExtractionTicketItem({
    super.key,
    required this.index,
    required this.ticket,
    required this.ticketsStatus,
  });

  final int index;
  final StorageQualityTicketModel ticket;
  final String ticketsStatus;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ExtractionQualityProvider orderPro = ref.watch(extractionQualityPro);
    // Get current user role
    final userRole = TokenUtil.getRoleFromMemory();
    log('Current user role: $userRole');
    log('Is extraction admin: ${userRole == RolesEnum.extractionAdmin}');

    return Container(
      margin: EdgeInsets.only(bottom: 15.h, left: 20.w, right: 20.w),
      padding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: ColorsUtils.whiteColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
            color: (ticketsStatus == OrderStatusEnum.completed &&
                    ticket.extractionQualityStatus == "rejected")
                ? ColorsUtils.redColor
                : ticket.extractionQualityStatus == "accepted"
                    ? ColorsUtils.greenColor
                    : ColorsUtils.kPrimaryColor,
            strokeAlign: 2,
            width: 2),
      ),
      child: InkWell(
        // onTap: ticketsStatus == OrderStatusEnum.pending
        //     ? () {
        //         orderPro.qualityReportDialog(
        //           context: context,
        //           ticketId: ticket.id!,
        //         );
        //       }
        //     : () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${S.of(context).lotName} : ${ticket.name}",
                      style: AppStyles.styleBold16(context)
                          .copyWith(color: Colors.black),
                      maxLines: 2,
                    ),
                    Text(
                      "${S.of(context).lotId} : ${ticket.incId}",
                      style: AppStyles.styleBold16(context)
                          .copyWith(color: Colors.black),
                    ),
                  ],
                ),
                Text(
                  "${S.of(context).zoneName} : ${ticket.zone?.name.toString().toUpperCase()}",
                  style: TextStyle(
                    color: ColorsUtils.blackColor,
                    fontSize: 14.spMin,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 1,
                ),
              ],
            ),
            Text(
              '${S.of(context).date} : ${ticket.createdAt.toString().substring(0, 11)}',
              style: TextStyle(
                color: Colors.black,
                fontSize: 12.spMin,
                fontWeight: FontWeight.w500,
                overflow: TextOverflow.ellipsis,
              ),
              maxLines: 1,
            ),
            10.verticalSpace,
            ticketsStatus == OrderStatusEnum.pending
                ? Row(
                    children: [
                      Expanded(
                        child: CustomRoundedButton(
                          backgroundColor: ColorsUtils.kMainSecondaryColor,
                          text: S.of(context).sampleReport,
                          fontSize: 12.spMin,
                          textColor: ColorsUtils.whiteColor,
                          width: 330.w,
                          height: 25.h,
                          radius: 10,
                          withShadow: false,
                          fontWeight: FontWeight.w400,
                          pressed: () {
                            orderPro.qualityReportDialog(
                              context: context,
                              ticketId: ticket.id!,
                              reportType: 'sample',
                            );
                          },
                        ),
                      ),
                      10.horizontalSpace,
                      Expanded(
                        child: CustomRoundedButton(
                          backgroundColor: ColorsUtils.kPrimaryColor,
                          text: S.of(context).finalReport,
                          fontSize: 12.spMin,
                          textColor: ColorsUtils.whiteColor,
                          width: 330.w,
                          height: 25.h,
                          radius: 10,
                          withShadow: false,
                          fontWeight: FontWeight.w400,
                          pressed: () {
                            orderPro.qualityReportDialog(
                              context: context,
                              ticketId: ticket.id!,
                              reportType: 'final',
                            );
                          },
                        ),
                      ),
                    ],
                  )
                : userRole == RolesEnum.extractionAdmin
                ? CustomRoundedButton(
                    backgroundColor: ColorsUtils.kPrimaryColor,
                    text: orderPro.isStatusChanging
                        ? "Changing..."
                        : S.of(context).changeStatus,
                    fontSize: 12.spMin,
                    textColor: ColorsUtils.whiteColor,
                    width: 330.w,
                    height: 25.h,
                    radius: 10,
                    withShadow: false,
                    fontWeight: FontWeight.w400,
                    pressed: orderPro.isStatusChanging
                        ? () {} // Empty function when loading
                        : () async {
                            String selectedStatus =
                                await showStatusChangeDialog(
                              context,
                            );
                            log(selectedStatus);
                            if (selectedStatus != '') {
                              orderPro.changeTicketStatus(
                                context: context,
                                ticketId: ticket.id!,
                                newStatus: selectedStatus,
                                ref: ref,
                              );
                            }
                          },
                  )
                : SizedBox() // Don't show the button for other roles
          ],
        ),
      ),
    ).animate().fade().move(
          begin: Offset(0, 20),
          duration: (index * 200).milliseconds,
        );
  }

  // Dialog to select new status
  Future<String> showStatusChangeDialog(BuildContext context) async {
    final statusOptions = [ 'accepted', 'rejected'];
    String? selectedStatus;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            S.of(context).changeStatus,
            style: TextStyle(
              color: ColorsUtils.kPrimaryColor,
              fontSize: 16.spMin,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SizedBox(
            width: double.minPositive,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: statusOptions.map(
                (status) {
                  return ListTile(
                    title: Text(status),
                    onTap: () {
                      selectedStatus = status;
                      Navigator.pop(context);
                    },
                  );
                },
              ).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                S.of(context).cancel,
                style: TextStyle(
                  color: ColorsUtils.kPrimaryColor,
                  fontSize: 16.spMin,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
    return selectedStatus ?? '';
  }
}
