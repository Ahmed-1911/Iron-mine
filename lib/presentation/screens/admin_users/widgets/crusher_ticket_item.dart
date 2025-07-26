import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iron_mine/core/utils/app_styles.dart';
import 'package:iron_mine/core/utils/colors_utils.dart';
import 'package:iron_mine/core/utils/enums.dart';

import '../../../../data/models/response/orders/get_tickets_response.dart';
import '../../../../generated/l10n.dart';
import '../../../viewModel/OrdersViewModel/crusher_admin_controller.dart';

class CrusherTicketItem extends ConsumerWidget {
  const CrusherTicketItem({
    super.key,
    required this.index,
    required this.ticket,
    required this.ticketsType,
  });

  final int index;
  final TicketModel ticket;
  final String ticketsType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CrusherAdminProvider orderPro = ref.watch(orderProvider);

    return Container(
      margin: EdgeInsets.only(
        bottom: 15.h,
        left: 20.w,
        right: 20.w,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color:ticketsType == CrusherOrderStatusEnum.crushing && orderPro.selectedCrushingTickets.contains(ticket.id)? ColorsUtils.kPrimaryColor.withAlpha(50) : ColorsUtils.whiteColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: ticketsType == CrusherOrderStatusEnum.crushing && orderPro.selectedCrushingTickets.contains(ticket.id)
              ? ColorsUtils.kPrimaryColor
              : ticket.qualityStatus == "pending"
                  ? Colors.amber
                  : ticket.qualityStatus == "rejected"
                      ? ColorsUtils.redColor
                      : Colors.green,
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
          if (ticketsType == CrusherOrderStatusEnum.crushing) {
            // Toggle selection for crushing tickets
            if (orderPro.selectedCrushingTickets.contains(ticket.id)) {
              orderPro.removeSelectedCrushingTicket(ticket.id ?? '');
            } else {
              orderPro.addSelectedCrushingTicket(ticket.id ?? '');
            }
          } else {
            // Original behavior for other ticket types
            ticketsType == CrusherOrderStatusEnum.dispatchable
                ? orderPro.crusherDispatchDialog(
                    context: context,
                    ticketId: ticket.id ?? '',
                  )
                :  orderPro.crusherReceivableDialog(
                        context: context,
                        ticketId: ticket.id ?? '',
                      );
                    
          }
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
              mainAxisAlignment:  ticket.zone?.incId == null ? MainAxisAlignment.start:MainAxisAlignment.spaceBetween,
              children: [
                ticket.zone?.incId == null ? SizedBox():  Text(
                  "${S.of(context).zoneName} : ${ticket.zone?.name.toString().toUpperCase()}",
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
                      "${S.of(context).lotName} : ${ticket.lot?.name ?? "-"}",
                      style: AppStyles.styleBold16(context).copyWith(color: Colors.black),
                    ),
                    Text(
                      "${S.of(context).lotId} : ${ticket.lot?.incId}",
                      style: AppStyles.styleBold16(context).copyWith(color: Colors.black),
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
              maxLines: 1,
            ),
            Text(
              "${S.of(context).qualityStatus} : ${ticket.qualityStatus}",
              style: TextStyle(
                color: ticket.qualityStatus == "pending"
                    ? Colors.amber
                    : ticket.qualityStatus == "rejected"
                        ? ColorsUtils.redColor
                        : Colors.green,
                fontSize: 14.spMin,
                fontWeight: FontWeight.w500,
                overflow: TextOverflow.ellipsis,
              ),
              maxLines: 1,
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
