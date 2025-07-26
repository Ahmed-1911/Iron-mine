import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iron_mine/core/utils/colors_utils.dart';
import 'package:iron_mine/presentation/viewModel/OrdersViewModel/crusher_admin_controller.dart';

import '../../../core/utils/enums.dart';
import '../../../generated/l10n.dart';

// ignore: must_be_immutable
class CrusherOrdersTypeList extends StatelessWidget {
  CrusherOrdersTypeList({super.key, required this.selectedOrdersType});

  StateProvider<String> selectedOrdersType;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        String selectedType = ref.watch(selectedOrdersType);
        return Container(
          margin: EdgeInsets.symmetric(vertical: 20),
          child: Row(
            children: [
              TicketTypeContainer(
                selectedOrdersType: selectedOrdersType,
                selectedType: selectedType,
                ticketType: CrusherOrderStatusEnum.receivable,
                title: S.of(context).receivable,
              ),
              12.horizontalSpace,
              TicketTypeContainer(
                selectedOrdersType: selectedOrdersType,
                selectedType: selectedType,
                ticketType: CrusherOrderStatusEnum.crushing,
                title: S.of(context).crushing,
              ),
              12.horizontalSpace,
              TicketTypeContainer(
                selectedOrdersType: selectedOrdersType,
                selectedType: selectedType,
                ticketType: CrusherOrderStatusEnum.dispatchable,
                title: S.of(context).dispatchable,
              ),
            ],
          ),
        );
      },
    );
  }
}

class TicketTypeContainer extends ConsumerWidget {
  const TicketTypeContainer({
    super.key,
    required this.selectedOrdersType,
    required this.selectedType,
    required this.ticketType,
    required this.title,
  });

  final StateProvider<String> selectedOrdersType;
  final String selectedType;
  final String ticketType;
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: InkWell(
        splashColor: Colors.transparent,
        onTap: () {
          ref.read(selectedOrdersType.notifier).state = ticketType;
          ref.read(orderProvider).clearSelectedCrushingTickets();
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selectedType == ticketType
                ? ColorsUtils.kPrimaryColor
                : Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 4),
                color: Colors.black.withAlpha(10),
                blurRadius: 4,
              ),
            ],
            border: Border.all(
              color: selectedType == ticketType
                  ? ColorsUtils.kPrimaryColor
                  : Colors.transparent,
            ),
          ),
          child: Text(
            title,
            style: TextStyle(
              color: selectedType == ticketType
                  ? ColorsUtils.whiteColor
                  : ColorsUtils.kPrimaryColor,
              fontSize: 12.spMin,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
