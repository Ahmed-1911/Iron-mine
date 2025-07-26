import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iron_mine/core/utils/colors_utils.dart';
import 'package:iron_mine/presentation/screens/widgets/custom_loading.dart';

// ignore: must_be_immutable
class CustomPagination extends ConsumerWidget {
  CustomPagination(
      {super.key,
      this.take = 10,
      @required this.futureMethod,
      this.passFutureBuilderProvider,
      @required this.cardWidget,
      this.turnOffPagination = false});

  static StateController<dynamic>? localListRebuild;
  Function(StateProvider<bool>)? passFutureBuilderProvider;
  static final localListProvider = StateProvider<bool>((ref) => true);

  int take;
  bool turnOffPagination;
  Widget Function(int index, List<dynamic> list, dynamic item,
      StateController<dynamic> provider)? cardWidget;
  Function(String skip)? futureMethod;
  final listViewRebuilding = StateProvider<String>((ref) => "");

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build
    ScrollController scrollController = ScrollController();
    int page = 1;
    int skip = 0;
    bool isLastPage = false;
    bool isFetchingData = false;
    bool initState = false;
    final centerLoadingProvider = StateProvider<bool>((ref) => false);
    final bottomLoadingProvider = StateProvider<bool>((ref) => false);
    List fetchedData = [];
    localListRebuild = ref.read(localListProvider.notifier);
    log('in 2222');
    var searchedListProvider = StateProvider<bool>((ref) => true);
    ref.watch(listViewRebuilding.notifier).state;
    try {
      ref.watch(searchedListProvider);
    } catch (e) {
      log(e.toString());
    }
    ref.watch(localListProvider);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      log('in 4444');

      try {
        passFutureBuilderProvider!(searchedListProvider);
      } catch (e) {
        log(e.toString());
      }
      log('in 5555');
    });
    void getData(BuildContext context) async {
      if (!isLastPage) {
        if (!isFetchingData) {
          isFetchingData = true;
          if (page == 1) {
            ref.read(centerLoadingProvider.notifier).state = true;
          } else {
            ref.read(bottomLoadingProvider.notifier).state = true;
          }

          List tempFetchedData = await futureMethod!(
            skip.toString(),
          );

          if (tempFetchedData.isEmpty) {
            isLastPage = true;
          }

          fetchedData += tempFetchedData;
          page++;
          if (page == 2) {
            ref.read(centerLoadingProvider.notifier).state = false;
          } else {
            ref.read(bottomLoadingProvider.notifier).state = false;
          }
          isFetchingData = false;
        }
      }
    }

    if (!initState) {
      initState = true;
      WidgetsBinding.instance.addPostFrameCallback(
        (timeStamp) {
          getData(context);
          scrollController.addListener(
            () {
              if (!turnOffPagination) {
                if (scrollController.position.atEdge &&
                    scrollController.position.pixels != 0) {
                  log('pppp0');
                  if (skip > 0) {
                  log('pppp1');
                  if ((fetchedData.length) == (skip + take)) {
                    log('pppp2');
                    skip += take;
                    getData(context);
                  }
                } else {
                  log('pppp3');
                  skip += take;
                  getData(context);
                  }
                }
              }
            },
          );
        },
      );
    }

    return Expanded(
      child: Consumer(
        builder: (context, ref, child) {
          final centerLoading = ref.watch(centerLoadingProvider);
          final bottomLoading = ref.watch(bottomLoadingProvider);
          return centerLoading
              ? Center(
                  child: Customloading(
                    width: 40.w,
                    color: ColorsUtils.kPrimaryColor,
                  ),
                )
              : ListView.builder(
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  controller: scrollController,
                  itemCount: fetchedData.length,
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        cardWidget!(index, fetchedData, fetchedData[index],
                            localListRebuild!),
                        index == fetchedData.length - 1 &&
                                bottomLoading &&
                                !turnOffPagination
                            ? Center(
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  margin: const EdgeInsets.only(bottom: 10),
                                  child: Center(
                                    //TODO check platform!
                                    child: Platform.isIOS
                                        ? const CupertinoActivityIndicator(
                                            radius: 5,
                                          )
                                        : const CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                  ),
                                ),
                              )
                            : const SizedBox(),
                      ],
                    );
                  },
                );
        },
      ),
    );
  }
}
