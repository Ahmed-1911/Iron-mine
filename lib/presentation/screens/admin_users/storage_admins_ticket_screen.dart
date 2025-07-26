import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iron_mine/core/helpers/routes.dart';
import 'package:iron_mine/core/utils/colors_utils.dart';
import 'package:iron_mine/presentation/screens/admin_users/widgets/storage_ticket_item.dart';
import 'package:iron_mine/presentation/screens/widgets/custom_loading.dart';

import '../../../data/models/response/orders/get_tickets_response.dart';
import '../../../data/repository/ticketsRepo/tickets_repo.dart';
import '../../../generated/l10n.dart';
import '../drawer_screen.dart';

class StorageTicketScreen extends ConsumerWidget {
  const StorageTicketScreen({super.key});

  static StateProvider<bool> rebuildProvider =
      StateProvider<bool>((ref) => false);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

            ///items LList
            Expanded(
              child: Consumer(
                builder: (context, ref, widget) {
                  ref.watch(rebuildProvider);
                  return FutureBuilder(
                    future: TicketsRepository.getStorageTickets(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
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
                            List<TicketModel> ticketsList = snapshot.data?.ticketsList ?? [];
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
                                      return StorageTicketItem(
                                        index: index,
                                        ticket: ticketsList[index],
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
