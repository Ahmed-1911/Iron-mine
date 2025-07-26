import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iron_mine/core/utils/app_styles.dart';
import 'package:iron_mine/core/utils/colors_utils.dart';
import 'package:iron_mine/presentation/viewModel/OrdersViewModel/storage_admin_controller.dart';

import '../../../../data/models/response/orders/get_tickets_response.dart';
import '../../../../generated/l10n.dart';

class StorageTicketItem extends ConsumerWidget {
  const StorageTicketItem({
    super.key,
    required this.index,
    required this.ticket,
  });

  final int index;
  final TicketModel ticket;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    StorageAdminProvider storagePro = ref.watch(storageAdminProvider);

    return Container(
      // height: 85.h,
      margin: EdgeInsets.only(bottom: 15.h, left: 20.w, right: 20.w),
      padding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: ColorsUtils.whiteColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color:
              ticket.qualityStatus == "pending" ? Colors.amber : Colors.green,
          strokeAlign: 3,
        ),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 4),
            color: ColorsUtils.kPrimaryColor.withAlpha(10),
            blurRadius: 20,
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          storagePro.storageReceivableDialog(
            context: context,
            ticketId: ticket.id ?? '',
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Ticket No : ${ticket.incrementId}",
              style: TextStyle(
                color: ColorsUtils.blackColor,
                fontSize: 14.spMin,
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.ellipsis,
              ),
              maxLines: 2,
            ),
            Row(
              mainAxisAlignment: ticket.zone?.incId == null
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.spaceBetween,
              children: [
                ticket.zone?.incId == null
                    ? SizedBox()
                    : Text(
                        "${S.of(context).zoneName} : ${ticket.zone?.name}",
                        style: TextStyle(
                          color: ColorsUtils.blackColor,
                          fontSize: 14.spMin,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 1,
                      ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${S.of(context).lotName} : ${ticket.lot?.name}",
                      style: AppStyles.styleBold16(context)
                          .copyWith(color: Colors.black),
                    ),
                    Text(
                      "${S.of(context).lotId} : ${ticket.lot?.incId}",
                      style: AppStyles.styleBold16(context)
                          .copyWith(color: Colors.black),
                    ),
                  ],
                ),
              ],
            ),
            Text(
              '${S.of(context).date} : ${ticket.createdDate.toString().substring(0, 11)}',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14.spMin,
                fontWeight: FontWeight.w500,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    ).animate().fade().move(
          begin: Offset(0, 20),
          duration: (index * 200).milliseconds,
        );
  }
}
