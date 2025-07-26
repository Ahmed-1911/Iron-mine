// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iron_mine/presentation/viewModel/OrdersViewModel/extraction-quality_controller.dart';

import '../../../core/utils/colors_utils.dart';

class AddImageContainer extends StatelessWidget {
  AddImageContainer({
    super.key,
    required this.imageProvider,
  });

  StateProvider<XFile> imageProvider;
  

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        ExtractionQualityProvider orderPro = ref.watch(extractionQualityPro);
        final image = ref.watch(imageProvider);
        return Column(
          children: [
            InkWell(
              splashColor: Colors.transparent,
              onTap: () {
                orderPro.getItemImages(
                  ref: ref,
                  context: context,
                  imageProvider: imageProvider,
                );
              },
              child: Container(
                height: 180.h,
                margin: EdgeInsets.symmetric(horizontal: 20.w),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24.r),
                  image: image.path.isNotEmpty
                      ? DecorationImage(
                          image: FileImage(
                            File(image.path),
                          ),
                          fit: BoxFit.fitHeight,
                        )
                      : null,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0, 2),
                      blurRadius: 6,
                    )
                  ],
                ),
                child: image.path.isEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.camera_alt_outlined,
                            size: 50.spMin,
                            color: ColorsUtils.kPrimaryColor,
                          ),
                        ],
                      )
                    : Stack(
                        children: [
                          /// add buttons
                          Positioned(
                            bottom: 0,
                            left: 0,
                            child: InkWell(
                              splashColor: Colors.transparent,
                              onTap: () {
                                orderPro.getItemImages(
                                  ref: ref,
                                  context: context,
                                  imageProvider: imageProvider,
                                );
                              },
                              child: Container(
                                height: 40.h,
                                width: 40.w,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 10.h),
                                decoration: const BoxDecoration(
                                  color: ColorsUtils.kMainSecondaryColor,
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.add_a_photo_rounded,
                                  color: Colors.black,
                                  size: 20.sp,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        );
      },
    );
  }
}
