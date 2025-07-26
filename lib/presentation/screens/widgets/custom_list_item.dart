import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/styles.dart';

class CustomListItem extends ConsumerWidget {
  const CustomListItem({
    super.key,
    @required this.itemId,
    this.colorSelectedItem = true,
    this.onTapFun,
    this.firstItem,
    this.secItem,
    this.thirdItem,
    this.fourthItem,
    this.fifthItem,
    this.sixthItem,
    this.seventhItem,
    this.eighthItem,
    this.ninthItem,
    this.firstItemTitle,
    this.secItemTitle,
    this.thirdItemTitle,
    this.fourthItemTitle,
    this.fifthItemTitle,
    this.sixthItemTitle,
    this.seventhItemTitle,
    this.eighthItemTitle,
    this.ninthItemTitle,
    this.widgetWithProvider,
    this.titleTextConfig,
    this.firstFlex,
    this.secFlex,
    this.thirdFlex,
    this.fourthFlex,
    this.fifthFlex,
    this.sixthFlex,
    this.seventhFlex,
    this.eigthFlex,
    this.ninthFlex,
    this.defaultFlex = 2,
    this.color,
    this.borderColor,

    /// default flex is 2
  });

  final Color? color;
  final String? itemId;
  final Color? borderColor;

  final bool? colorSelectedItem;
  final void Function(String)? onTapFun;
  final Widget Function(StateController stateController)? firstItem;
  final Widget Function(StateController stateController)? secItem;
  final Widget Function(StateController stateController)? thirdItem;
  final Widget Function(StateController stateController)? fourthItem;
  final Widget Function(StateController stateController)? fifthItem;
  final Widget Function(StateController stateController)? sixthItem;
  final Widget Function(StateController stateController)? seventhItem;
  final Widget Function(StateController stateController)? eighthItem;
  final Widget Function(StateController stateController)? ninthItem;
  final String? firstItemTitle;
  final String? secItemTitle;
  final String? thirdItemTitle;
  final String? fourthItemTitle;
  final String? fifthItemTitle;
  final String? sixthItemTitle;
  final String? seventhItemTitle;
  final String? eighthItemTitle;
  final String? ninthItemTitle;
  final int? firstFlex;
  final int? secFlex;
  final int? thirdFlex;
  final int? fourthFlex;
  final int? fifthFlex;
  final int? sixthFlex;
  final int? seventhFlex;
  final int? eigthFlex;
  final int? ninthFlex;
  final int? defaultFlex;

  final Widget Function(StateController stateController)? widgetWithProvider;
  static final selectedItemId = StateProvider<String>((ref) => '');
  final TextStyle? titleTextConfig;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    StateController<dynamic> stateProvider =
        ref.refresh(selectedItemId.notifier);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (colorSelectedItem!) {
        ref.refresh(selectedItemId.notifier).state = '';
      }
    });
    return Consumer(builder: (context, ref, child) {
      String? selectedItemIdWatcher = ref.watch(selectedItemId);
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: !colorSelectedItem! && (onTapFun == null)
              ? null
              : () {
                  ref.refresh(selectedItemId.notifier).state = itemId!;

                  if (onTapFun != null) {
                    onTapFun!(itemId!);
                  }
                },
          child: Column(
            children: [
              Container(
                height: 60,
                padding: const EdgeInsets.all(8.0),
                decoration:
                    colorSelectedItem! && selectedItemIdWatcher == itemId
                        ? dawarGreenBoxDecoration(isCircle: false)
                        : BoxDecoration(
                            color: color ?? Colors.grey.withAlpha(10),
                            border: borderColor == null
                                ? null
                                : Border.all(
                                    color: borderColor!,
                                  ),
                          ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    firstItem != null
                        ? firstItemTitle != null
                            ? Expanded(
                                flex: firstFlex ?? defaultFlex!,
                                child: Column(
                                  children: [
                                    Text(
                                      firstItemTitle ?? '',
                                      style: titleTextConfig,
                                    ),
                                    firstItem!(stateProvider)
                                  ],
                                ))
                            : Expanded(
                                flex: firstFlex ?? defaultFlex!,
                                child: Center(child: firstItem!(stateProvider)))
                        : const SizedBox(),
                    secItem != null
                        ? secItemTitle != null
                            ? Expanded(
                                flex: secFlex ?? defaultFlex!,
                                child: Column(
                                  children: [
                                    Text(
                                      secItemTitle ?? '',
                                      style: titleTextConfig,
                                    ),
                                    secItem!(stateProvider)
                                  ],
                                ))
                            : Expanded(
                                flex: secFlex ?? defaultFlex!,
                                child: Center(child: secItem!(stateProvider)))
                        : const SizedBox(),
                    thirdItem != null
                        ? thirdItemTitle != null
                            ? Expanded(
                                flex: thirdFlex ?? defaultFlex!,
                                child: Column(
                                  children: [
                                    Text(
                                      thirdItemTitle ?? '',
                                      style: titleTextConfig,
                                    ),
                                    thirdItem!(stateProvider)
                                  ],
                                ))
                            : Expanded(
                                flex: thirdFlex ?? defaultFlex!,
                                child: Center(child: thirdItem!(stateProvider)))
                        : const SizedBox(),
                    fourthItem != null
                        ? fourthItemTitle != null
                            ? Expanded(
                                flex: fourthFlex ?? defaultFlex!,
                                child: Column(
                                  children: [
                                    Text(
                                      fourthItemTitle ?? '',
                                      style: titleTextConfig,
                                    ),
                                    fourthItem!(stateProvider)
                                  ],
                                ))
                            : Expanded(
                                flex: fourthFlex ?? defaultFlex!,
                                child:
                                    Center(child: fourthItem!(stateProvider)))
                        : const SizedBox(),
                    fifthItem != null
                        ? fifthItemTitle != null
                            ? Expanded(
                                flex: fifthFlex ?? defaultFlex!,
                                child: Column(
                                  children: [
                                    Text(
                                      fifthItemTitle ?? '',
                                      style: titleTextConfig,
                                    ),
                                    fifthItem!(stateProvider)
                                  ],
                                ))
                            : Expanded(
                                flex: fifthFlex ?? defaultFlex!,
                                child: Center(child: fifthItem!(stateProvider)))
                        : const SizedBox(),
                    sixthItem != null
                        ? sixthItemTitle != null
                            ? Expanded(
                                flex: sixthFlex ?? defaultFlex!,
                                child: Column(
                                  children: [
                                    Text(
                                      sixthItemTitle ?? '',
                                      style: titleTextConfig,
                                    ),
                                    sixthItem!(stateProvider)
                                  ],
                                ))
                            : Expanded(
                                flex: sixthFlex ?? defaultFlex!,
                                child: Center(child: sixthItem!(stateProvider)))
                        : const SizedBox(),
                    seventhItem != null
                        ? seventhItemTitle != null
                            ? Expanded(
                                flex: seventhFlex ?? defaultFlex!,
                                child: Column(
                                  children: [
                                    Text(
                                      seventhItemTitle ?? '',
                                      style: titleTextConfig,
                                    ),
                                    seventhItem!(stateProvider)
                                  ],
                                ))
                            : Expanded(
                                flex: seventhFlex ?? defaultFlex!,
                                child:
                                    Center(child: seventhItem!(stateProvider)))
                        : const SizedBox(),
                    eighthItem != null
                        ? eighthItemTitle != null
                            ? Expanded(
                                flex: eigthFlex ?? defaultFlex!,
                                child: Column(
                                  children: [
                                    Text(
                                      eighthItemTitle ?? '',
                                      style: titleTextConfig,
                                    ),
                                    eighthItem!(stateProvider)
                                  ],
                                ))
                            : Expanded(
                                flex: eigthFlex ?? defaultFlex!,
                                child:
                                    Center(child: eighthItem!(stateProvider)))
                        : const SizedBox(),
                    ninthItem != null
                        ? ninthItemTitle != null
                            ? Expanded(
                                flex: ninthFlex ?? defaultFlex!,
                                child: Column(
                                  children: [
                                    Text(
                                      ninthItemTitle ?? '',
                                      style: titleTextConfig,
                                    ),
                                    ninthItem!(stateProvider)
                                  ],
                                ))
                            : Expanded(
                                flex: ninthFlex ?? defaultFlex!,
                                child: Center(child: ninthItem!(stateProvider)))
                        : const SizedBox(),
                  ],
                ),
              ),
              //! this dotted line in this widget distroys the performance
              //DottedLine.dottedLine(dashWidth: 3,)
            ],
          ),
        ),
      );
    });
  }
}
