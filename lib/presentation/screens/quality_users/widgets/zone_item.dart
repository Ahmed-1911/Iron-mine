import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iron_mine/core/utils/colors_utils.dart';
import 'package:iron_mine/core/utils/enums.dart';
import 'package:iron_mine/data/models/response/orders/get_zone_list_response.dart';

import '../../../../generated/l10n.dart';
import '../../../viewModel/OrdersViewModel/extraction-quality_controller.dart';

class ZoneItem extends ConsumerWidget {
  const ZoneItem({
    super.key,
    required this.index,
    required this.zone,
    required this.zoneStatus,
  });

  final int index;
  final ZoneModel zone;
  final String zoneStatus;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ExtractionQualityProvider crusherPro = ref.watch(extractionQualityPro);
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
        color: ColorsUtils.whiteColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: zone.verified == null
              ? ColorsUtils.kPrimaryColor
              : (zone.verified ?? true)
                  ? Colors.green
                  : ColorsUtils.redColor,
          strokeAlign: 2,
          width: 2.5
        ),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 4),
            color: ColorsUtils.kPrimaryColor.withAlpha(10),
            blurRadius: 20,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              spacing: 5.h,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${S.of(context).zoneId} : ${zone.incId}",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.spMin,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 2,
                ),

                Text(
                  "${S.of(context).zoneName} : ${zone.name.toString().toUpperCase()}",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.spMin,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 2,
                ),

                Text(
                  '${S.of(context).date} : ${zone.createdAt.toString().substring(0, 11)}',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12.spMin,
                    fontWeight: FontWeight.w500,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 1,
                ),
              ],
            ),
          ),
          zoneStatus == ZoneStatusEnum.unverifiedZones
              ? Column(
                  spacing: 10.h,
                  children: [
                    InkWell(
                      onTap: () {
                        crusherPro.changZoneStatus(
                          context: context,
                          ref: ref,
                          zoneId: zone.id!,
                          status: true,
                        );
                      },
                      child: Container(
                        width: 100.w,
                        padding: EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          color: Colors.green,
                        ),
                        child: Text(
                          S.of(context).accepted,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12.spMin,
                            color: ColorsUtils.whiteColor,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        crusherPro.changZoneStatus(
                          context: context,
                          ref: ref,
                          zoneId: zone.id!,
                          status: false,
                        );
                      },
                      child: Container(
                        width: 100.w,
                        padding: EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          color: ColorsUtils.redColor,
                        ),
                        child: Text(
                          S.of(context).rejected,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12.spMin,
                            color: ColorsUtils.whiteColor,
                          ),
                        ),
                      ),
                    )
                  ],
                )
              : SizedBox(),
        ],
      ),
    ).animate().fade().move(
          begin: Offset(0, 20),
          duration: (index * 200).milliseconds,
        );
  }
}
