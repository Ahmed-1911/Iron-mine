import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iron_mine/core/utils/app_styles.dart';
import 'package:iron_mine/core/utils/colors_utils.dart';
import 'package:iron_mine/presentation/screens/widgets/custom_loading.dart';

import '../../../data/models/response/orders/get_zone_list_response.dart';
import '../../../generated/l10n.dart';

class VerifiedZonesList {
  ZoneModel? selectedZone;

  Future<ZoneModel?> selectZoneDialog(
      {required BuildContext context,
      required Future<GetZoneListResponse> futureBuilder}) async {
    await showModalBottomSheet(
      context: context,
      builder: (builder) {
        return Container(
          height: 350.0,
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
            ),
            child: Column(
              children: [
                Text(
                  S.of(context).zoneList,
                  style: TextStyle(
                    color: ColorsUtils.kPrimaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                10.verticalSpace,
                Expanded(
                  child: FutureBuilder<GetZoneListResponse>(
                    future: futureBuilder,
                    builder: (BuildContext context,
                        AsyncSnapshot<GetZoneListResponse> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          {
                            return Center(
                              child: Customloading(
                                width: 25.spMin,
                                color: ColorsUtils.kPrimaryColor,
                              ),
                            );
                          }
                        default:
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: snapshot.data?.totalCount ?? 0,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    selectedZone =
                                        snapshot.data?.zonesList?[index] ??
                                            ZoneModel();
                                    Navigator.pop(context);
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "${S.of(context).zoneName} :${snapshot.data?.zonesList?[index]
                                                    .name.toString().toUpperCase()}",
                                            style: AppStyles.styleRegular16(
                                              context,
                                            ),
                                          ),
                                          Text(
                                            "${S.of(context).zoneId} ${snapshot.data?.zonesList?[index]
                                                .incId}",
                                            style: AppStyles.styleRegular16(
                                              context,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Divider(
                                        height: 15,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    return selectedZone;
  }
}
