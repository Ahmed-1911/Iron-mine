import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iron_mine/core/helpers/routes.dart';
import 'package:iron_mine/core/utils/colors_utils.dart';
import 'package:iron_mine/data/models/request/orders/get_orders_request.dart';
import 'package:iron_mine/data/models/response/orders/get_zone_list_response.dart';
import 'package:iron_mine/presentation/screens/admin_users/widgets/extraction_zone_item.dart';
import 'package:iron_mine/presentation/screens/widgets/custom_loading.dart';
import 'package:iron_mine/presentation/viewModel/OrdersViewModel/extractoin_admin_controller.dart';

import '../../../data/repository/ticketsRepo/tickets_repo.dart';
import '../../../generated/l10n.dart';
import '../drawer_screen.dart';

class ExtractionZoneListScreen extends ConsumerWidget {
  const ExtractionZoneListScreen({super.key});

  static StateProvider<bool> rebuildProvider =
      StateProvider<bool>((ref) => false);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorsUtils.kPrimaryColor,
        child: Icon(Icons.add),
        onPressed: () {
          ExtractionAdminProvider extractionPro = ref.read(extractionAdminProvider);
          extractionPro.addZoneDialog(context: context,);
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: ColorsUtils.blackColor.withAlpha(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () async {
                      CustomNavigator.pushScreen(
                        context: context,
                        widget: DrawerScreen(),
                      );
                    },
                    icon: Icon(
                      Icons.menu,
                      color: ColorsUtils.kPrimaryColor,
                      size: 25.spMin,
                    ),
                  ),
                  Text(
                    S.of(context).zonesReview,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.spMin,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 1,
                  ),
                  25.horizontalSpace,
                ],
              ),
            ),
            10.verticalSpace,

            ///items List
            Expanded(
              child: Consumer(
                builder: (context, ref, widget) {
                  ref.watch(rebuildProvider);
                  return FutureBuilder<GetZoneListResponse>(
                    future: TicketsRepository.getExtractionZonesList(
                      getOrderRequest: GetOrdersRequest(limit: '100'),
                      zonesType: 'all'
                    ),
                    builder: (BuildContext context,
                        AsyncSnapshot<GetZoneListResponse> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          {
                            return Center(
                              child: Customloading(
                                width: 30.spMin,
                                color: ColorsUtils.kPrimaryColor,
                              ),
                            );
                          }
                        default:
                          if ((snapshot.data == null)) {
                            return Center(
                              child: Text(
                                '${snapshot.error}',
                              ),
                            );
                          } else {
                            List<ZoneModel> ticketsList =
                                snapshot.data?.zonesList ?? [];
                            return ticketsList.isEmpty
                                ? Center(
                                    child: Text(
                                      S.of(context).no_order,
                                      style: TextStyle(
                                        fontSize: 15.spMin,
                                        color: ColorsUtils.blackColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    itemCount: ticketsList.length,
                                    cacheExtent: 9999,
                                    padding: EdgeInsets.only(top: 5),
                                    itemBuilder: (context, index) {
                                      return ExtractionZoneItem(
                                        index: index,
                                        zone: ticketsList[index],
                                      );
                                    },
                                  );
                          }
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
