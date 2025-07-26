import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iron_mine/core/utils/colors_utils.dart';

import '../../../core/utils/enums.dart';
import '../../../generated/l10n.dart';

// ignore: must_be_immutable
class ZoneTypeList extends StatelessWidget {
  ZoneTypeList({super.key, required this.zoneType});

  StateProvider<String> zoneType;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        String selectedType = ref.watch(zoneType);
        return Container(
          margin: EdgeInsets.symmetric(vertical: 20),
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  splashColor: Colors.transparent,
                  onTap: () {
                    ref.read(zoneType.notifier).state =
                        ZoneStatusEnum.unverifiedZones;
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: selectedType == ZoneStatusEnum.unverifiedZones
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
                          color: selectedType == ZoneStatusEnum.unverifiedZones
                              ? ColorsUtils.kPrimaryColor
                              : Colors.transparent,
                      ),
                    ),
                    child: Text(
                     S.of(context).unverified ,
                      style: TextStyle(
                        color: selectedType == ZoneStatusEnum.unverifiedZones
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
                    ref.read(zoneType.notifier).state =
                        ZoneStatusEnum.verifiedZones;
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: selectedType == ZoneStatusEnum.verifiedZones
                          ? ColorsUtils.kPrimaryColor
                          : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: selectedType == ZoneStatusEnum.verifiedZones
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
                      S.of(context).verifiedZones ,
                      style: TextStyle(
                        color: selectedType == ZoneStatusEnum.verifiedZones
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
