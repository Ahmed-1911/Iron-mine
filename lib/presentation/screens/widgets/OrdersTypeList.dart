import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iron_mine/core/utils/colors_utils.dart';

import '../../../core/utils/enums.dart';
import '../../../generated/l10n.dart';

// ignore: must_be_immutable
class OrdersTypeList extends StatelessWidget {
  OrdersTypeList({super.key, required this.selectedOrdersType});

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
              Expanded(
                child: InkWell(
                  splashColor: Colors.transparent,
                  onTap: () {
                    ref.read(selectedOrdersType.notifier).state =
                        OrderStatusEnum.pending;
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: selectedType == OrderStatusEnum.pending
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
                          color: selectedType == OrderStatusEnum.pending
                              ? ColorsUtils.kPrimaryColor
                              : Colors.transparent,
                      ),
                    ),
                    child: Text(
                      S.of(context).pending,
                      style: TextStyle(
                        color: selectedType == OrderStatusEnum.pending
                            ? ColorsUtils.whiteColor
                            : ColorsUtils.kPrimaryColor,
                        fontSize: 12.spMin,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              12.horizontalSpace,
              Expanded(
                child: InkWell(
                  splashColor: Colors.transparent,
                  onTap: () {
                    ref.read(selectedOrdersType.notifier).state =
                        OrderStatusEnum.completed;
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: selectedType == OrderStatusEnum.completed
                          ? ColorsUtils.kPrimaryColor
                          : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: selectedType == OrderStatusEnum.completed
                            ? ColorsUtils.kPrimaryColor
                            : Colors.transparent,
                      ),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 4),
                          color: Colors.black.withAlpha(10),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Text(
                      S.of(context).finished,
                      style: TextStyle(
                        color: selectedType == OrderStatusEnum.completed
                            ? ColorsUtils.whiteColor
                            : ColorsUtils.kPrimaryColor,
                        fontSize: 12.spMin,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
