import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iron_mine/core/helpers/routes.dart';
import 'package:iron_mine/core/utils/colors_utils.dart';
import 'package:iron_mine/data/models/request/orders/get_orders_request.dart';
import 'package:iron_mine/presentation/screens/admin_users/widgets/crusher_ticket_item.dart';
import 'package:iron_mine/presentation/screens/widgets/crusher_orders_type_list.dart';
import 'package:iron_mine/presentation/screens/widgets/custom_loading.dart';

import '../../../core/utils/enums.dart';
import '../../../data/models/response/orders/get_tickets_response.dart';
import '../../../data/repository/ticketsRepo/tickets_repo.dart';
import '../../../generated/l10n.dart';
import '../../viewModel/OrdersViewModel/crusher_admin_controller.dart';
import '../drawer_screen.dart';

// ignore: must_be_immutable
class CrusherTicketScreen extends ConsumerWidget {
  CrusherTicketScreen({super.key});

  static StateProvider<bool> rebuildProvider =
      StateProvider<bool>((ref) => false);
  final selectedTypeProvider =
      StateProvider<String>((ref) => CrusherOrderStatusEnum.receivable);

  void handleConnectivityChanges(
    BuildContext context,
    WidgetRef ref,
  ) {
    CrusherAdminProvider orderPro = ref.read(orderProvider);

    Connectivity().onConnectivityChanged.listen(
      (result) {
        log("Connection >>>> $result");
        if (context.mounted) {
          if (result[0] != ConnectivityResult.none) {
            orderPro.retryOfflineRequests(
              context,
            ); // إعادة إرسال التقارير عند استعادة الاتصال
          }
        }
      },
    );
  }

  bool called = false;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!called) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) async {
          handleConnectivityChanges(
            context,
            ref,
          );
        },
      );
      called = true;
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              decoration:
                  BoxDecoration(color: ColorsUtils.blackColor.withAlpha((0.1 * 255).round())),
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
                    S.of(context).lotsReview,
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

            /// orders status
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: CrusherOrdersTypeList(
                selectedOrdersType: selectedTypeProvider,
              ),
            ),

            ///items LList
            Expanded(
              child: Consumer(
                builder: (context, ref, widget) {
                  final String ticketsType = ref.watch(selectedTypeProvider);
                  ref.watch(rebuildProvider);
                  return FutureBuilder(
                    future: TicketsRepository.getCrusherTickets(
                      getOrderRequest: GetOrdersRequest(limit: '1000'),
                      ticketsType: ticketsType,
                    ),
                    builder: (BuildContext context,
                        AsyncSnapshot<GetTicketsResponse> snapshot) {
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
                            List<TicketModel> ticketsList =
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
                                      return CrusherTicketItem(
                                        index: index,
                                        ticket: ticketsList[index],
                                        ticketsType: ticketsType,
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
      floatingActionButton: Consumer(
        builder: (context, ref, _) {
          final orderPro = ref.watch(orderProvider);
          final selectedType = ref.watch(selectedTypeProvider);
          
          return orderPro.selectedCrushingTickets.isNotEmpty && 
                 selectedType == CrusherOrderStatusEnum.crushing
              ? FloatingActionButton.extended(
                  onPressed: () {
                    orderPro.crusherCrushingDialogMultiple(
                      context: context,
                      ticketIds: orderPro.selectedCrushingTickets,
                    );
                  },
                  backgroundColor: ColorsUtils.kPrimaryColor,
                  label: Row(
                    children: [
                      Text(
                        'Process ${orderPro.selectedCrushingTickets.length} Tickets',
                        style: TextStyle(
                          color: ColorsUtils.whiteColor,
                          fontSize: 14.spMin,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      8.horizontalSpace,
                      Icon(Icons.check_circle, color: ColorsUtils.whiteColor),
                    ],
                  ),
                )
              : SizedBox();
        },
      ),
    );
  }
}
