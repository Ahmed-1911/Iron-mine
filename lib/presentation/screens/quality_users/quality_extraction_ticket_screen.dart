import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iron_mine/core/helpers/routes.dart';
import 'package:iron_mine/core/utils/colors_utils.dart';
import 'package:iron_mine/core/utils/token_util.dart';
import 'package:iron_mine/data/models/request/orders/get_orders_request.dart';
import 'package:iron_mine/presentation/screens/quality_users/widgets/quality_extraction_ticket_item.dart';
import 'package:iron_mine/presentation/screens/widgets/custom_loading.dart';

import '../../../core/utils/enums.dart';
import '../../../data/models/response/orders/get_storage_quality_tickets_response.dart';
import '../../../data/repository/ticketsRepo/tickets_repo.dart';
import '../../../generated/l10n.dart';
import '../../viewModel/OrdersViewModel/extraction-quality_controller.dart';
import '../drawer_screen.dart';
import '../widgets/OrdersTypeList.dart';

class QualityExtractionTicketScreen extends ConsumerWidget {
  QualityExtractionTicketScreen({super.key});

  static StateProvider<bool> rebuildProvider =
      StateProvider<bool>((ref) => false);

  // Set default order status based on user role
  // If user is extraction quality, show pending orders by default
  // For all other roles, show completed orders by default
  final orderStatus = StateProvider<String>((ref) {
    final userRole = TokenUtil.getRoleFromMemory();
    log('Setting default order status based on role: $userRole');
    return userRole == RolesEnum.extractionQuality
        ? OrderStatusEnum.pending
        : OrderStatusEnum.completed;
  });

  void handleConnectivityChanges(
    BuildContext context,
    WidgetRef ref,
  ) {
    ExtractionQualityProvider orderPro = ref.read(extractionQualityPro);

    Connectivity().onConnectivityChanged.listen(
      (result) {
        log("Connection >>>> $result");
        if (result[0] != ConnectivityResult.none) {
          if (context.mounted) {
            orderPro.retryOfflineReports(
              context,
            ); // إعادة إرسال التقارير عند استعادة الاتصال
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get the user role for UI decisions
    final userRole = TokenUtil.getRoleFromMemory();
    
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        handleConnectivityChanges(
          context,
          ref,
        );
      },
    );
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                    userRole == RolesEnum.extractionQuality
                        ? S.of(context).lotsReview
                        : S.of(context).finishedExtractionTickets,
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

            /// orders status - only shown for extraction quality role
            Consumer(
              builder: (context, ref, child) {
                final userRole = TokenUtil.getRoleFromMemory();
                log('Current user role for order status view: $userRole');
                
                // Only show the OrdersTypeList for extraction quality users
                if (userRole == RolesEnum.extractionQuality) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: OrdersTypeList(
                      selectedOrdersType: orderStatus,
                    ),
                  );
                } else {
                  // For other roles, return empty SizedBox
                  return SizedBox();
                }
              },
            ),

            ///items List
            Expanded(
              child: Consumer(
                builder: (context, ref, widget) {
                  ref.watch(rebuildProvider);
                  final String ticketsType = ref.watch(orderStatus);
                  return FutureBuilder<GetStorageQualityTicketsResponse>(
                    future: TicketsRepository.getExtractionQualityTickets(
                      getOrderRequest: GetOrdersRequest(limit: '1000'),
                      ticketsType: ticketsType,
                    ),
                    builder: (BuildContext context,
                        AsyncSnapshot<GetStorageQualityTicketsResponse>
                            snapshot) {
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
                            List<StorageQualityTicketModel> ticketsList =
                                snapshot.data?.ticketsList ?? [];
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
                                      return QualityExtractionTicketItem(
                                        index: index,
                                        ticket: ticketsList[index],
                                        ticketsStatus: ticketsType,
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
