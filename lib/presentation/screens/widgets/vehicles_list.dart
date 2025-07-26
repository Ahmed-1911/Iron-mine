import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iron_mine/core/utils/colors_utils.dart';
import 'package:iron_mine/presentation/screens/widgets/custom_loading.dart';

import '../../../data/models/response/orders/get_vehicles_list_response.dart';

class VehiclesList {
  VehicleItem? selectedVehicle;

  Future<VehicleItem?> selectVehicleDialog(
      {required BuildContext context,
      required Future<List<VehicleItem>> futureBuilder}) async {
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
                  'Vehicles List',
                  style: TextStyle(
                    color: ColorsUtils.kPrimaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                10.verticalSpace,
                Expanded(
                  child: FutureBuilder<List<VehicleItem>>(
                    future: futureBuilder,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<VehicleItem>> snapshot) {
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
                              itemCount: snapshot.data?.length ?? 0,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    selectedVehicle =
                                        snapshot.data?[index] ??
                                            VehicleItem();
                                    Navigator.pop(context);
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        snapshot.data?[index]
                                                .plateNumber ??
                                            '',
                                        style: TextStyle(
                                          color: Colors.black.withAlpha(70),
                                          fontSize: 16,
                                        ),
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
    return selectedVehicle;
  }
}
