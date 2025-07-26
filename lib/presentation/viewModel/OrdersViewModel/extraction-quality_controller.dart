import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iron_mine/core/helpers/routes.dart';
import 'package:iron_mine/core/utils/colors_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/helpers/view_functions.dart';
import '../../../data/repository/ticketsRepo/tickets_repo.dart';
import '../../../generated/l10n.dart';
import '../../screens/admin_users/crusher_admins_ticket_screen.dart';
import '../../screens/quality_users/quality_extraction_ticket_screen.dart';
import '../../screens/quality_users/zone_list_screen.dart';
import '../../screens/widgets/add_image_container.dart';
import '../../screens/widgets/custom_loading.dart';
import '../../screens/widgets/custom_rounded_btn.dart';
import '../../screens/widgets/custom_textfield.dart';

ChangeNotifierProvider<ExtractionQualityProvider> extractionQualityPro =
    ChangeNotifierProvider<ExtractionQualityProvider>(
        (ref) => ExtractionQualityProvider());

class ExtractionQualityProvider extends ChangeNotifier {
  bool _sampleReportLoading;
  bool _finalReportLoading;
  bool _isRetrying = false;
  bool _isStatusChanging = false;

  ExtractionQualityProvider()
      : _sampleReportLoading = false,
        _finalReportLoading = false;

  getItemImages({
    required BuildContext context,
    required WidgetRef ref,
    required StateProvider<XFile> imageProvider,
  }) async {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 50,
        maxHeight: 700,
        maxWidth: 700);
    if (image != null) {
      ref.read(imageProvider.notifier).state = image;
    } else {
      log("Not Added");
      ViewFunctions.showCustomSnackBar(
        context: context,
        text: "No images picked",
      );
    }
  }

  Future<bool> isConnected() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult[0] != ConnectivityResult.none;
  }

  /// save report offline
  Future<void> saveReportOffline({
    required String ticketId,
    required String parametersJson,
    required String photoPath,
    required String reportType,
  }) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final reportData = {
      'ticketId': ticketId,
      'parametersJson': parametersJson,
      'photoPath': photoPath,
      'reportType': reportType,
      'timestamp': timestamp,
    };
    final prefs = await SharedPreferences.getInstance();
    final reports = prefs.getStringList('offline_reports') ?? [];
    reports.add(json.encode(reportData));
    await prefs.setStringList('offline_reports', reports);
  }

  /// extraction report Dialog
  qualityReportDialog({
    required BuildContext context,
    Function? function,
    required String ticketId,
    required String reportType,
  }) {
    Map<String, TextEditingController> parameterControllers = {
      "Na2O": TextEditingController(),
      "MgO": TextEditingController(),
      "P2O5": TextEditingController(),
      "SO3": TextEditingController(),
      "K2O": TextEditingController(),
      "CaO": TextEditingController(),
      "MnO": TextEditingController(),
      "Fe2O3_tot": TextEditingController(),
      "LOI": TextEditingController(),
      "Cu": TextEditingController(),
      "Zn": TextEditingController(),
      "Ni": TextEditingController(),
      "Rh": TextEditingController(),
      "TiO2": TextEditingController(),
      "Al2O3": TextEditingController(),
      "SiO2": TextEditingController(),
      "As": TextEditingController(),
      "F": TextEditingController(),
      "Pb": TextEditingController(),
      "ZnO": TextEditingController(),
      "Cl": TextEditingController(),
    };
    StateProvider<XFile> imageProvider =
        StateProvider<XFile>((ref) => XFile(""));
    AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader,
      bodyHeaderDistance: 0,
      alignment: Alignment.bottomCenter,
      dismissOnTouchOutside: true,
      animType: AnimType.bottomSlide,
      dialogBackgroundColor: ColorsUtils.whiteColor,
      padding: EdgeInsets.symmetric(
        horizontal: 10.w,
        vertical: 15.h,
      ),
      width: 1.sw,
      barrierColor: ColorsUtils.blackColor.withValues(alpha: 0.3),
      body: SizedBox(
        height: reportType == "sample" ? 0.3.sh : 0.55.sh,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: reportType == "sample"
                  ? AddImageContainer(
                      imageProvider: imageProvider,
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: parameterControllers.entries.map((entry) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: ParameterRow(
                              parameterCnt: entry.value,
                              parameterTitle: entry.key,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
            ),
            15.verticalSpace,

            /// sample report
            reportType == 'sample'
                ? Consumer(
                    builder: (context, ref, _) {
                      ExtractionQualityProvider orderPro =
                          ref.watch(extractionQualityPro);
                      final XFile image = ref.watch(imageProvider);
                      return orderPro.sampleReportLoading
                          ? Customloading(
                              width: 25.w,
                              color: ColorsUtils.kPrimaryColor,
                            )
                          : CustomRoundedButton(
                              backgroundColor: ColorsUtils.kPrimaryColor,
                              text: S.of(context).submit,
                              fontSize: 16.spMin,
                              textColor: ColorsUtils.whiteColor,
                              width: 330.w,
                              height: 40.h,
                              radius: 10,
                              withShadow: false,
                              fontWeight: FontWeight.w400,
                              pressed: () async {
                                if (
                                    //!validateParameters(parameterControllers) ||
                                    image.path.isEmpty) {
                                  ViewFunctions.messageDialog(
                                    context: context,
                                    message: S.of(context).addAllFieldsFirst,
                                    function: () {
                                      CustomNavigator.popScreen(
                                        context: context,
                                      );
                                    },
                                  );
                                } else {
                                  final jsonString =
                                      await convertToJson(parameterControllers);
                                  orderPro.createSampleReport(
                                    context: context,
                                    ticketId: ticketId,
                                    parametersJson: jsonString,
                                    photo: image,
                                    ref: ref,
                                  );
                                }
                              },
                            );
                    },
                  )
                :

                /// final report
                Consumer(
                    builder: (context, ref, _) {
                      ExtractionQualityProvider orderPro =
                          ref.watch(extractionQualityPro);
                      return orderPro.finalReportLoading
                          ? Customloading(
                              width: 25.w,
                              color: ColorsUtils.kPrimaryColor,
                            )
                          : CustomRoundedButton(
                              backgroundColor: ColorsUtils.kPrimaryColor,
                              text: S.of(context).submit,
                              fontSize: 16.spMin,
                              textColor: ColorsUtils.whiteColor,
                              width: 330.w,
                              height: 40.h,
                              radius: 10,
                              withShadow: false,
                              fontWeight: FontWeight.w400,
                              pressed: () async {
                                if (!validateParameters(parameterControllers)) {
                                  ViewFunctions.messageDialog(
                                    context: context,
                                    message: S.of(context).addAllFieldsFirst,
                                    function: () {
                                      CustomNavigator.popScreen(
                                        context: context,
                                      );
                                    },
                                  );
                                } else {
                                  final jsonString =
                                      await convertToJson(parameterControllers);
                                  orderPro.createFinalReport(
                                    context: context,
                                    ref: ref,
                                    ticketId: ticketId,
                                    parametersJson: jsonString,
                                  );
                                }
                              });
                    },
                  ),
          ],
        ),
      ),
    ).show();
  }

  /// validate that all parameters have values
  bool validateParameters(Map<String, TextEditingController> controllers) {
    for (var entry in controllers.entries) {
      if (entry.value.text.isEmpty) {
        // Show an error message for the missing parameter
        log('The parameter "${entry.key}" is missing a value.');
        return false; // Return false if any field is empty
      }
    }
    return true; // Return true if all fields have values
  }

  Future<String> convertToJson(
      Map<String, TextEditingController> controllers) async {
    final Map<String, dynamic> jsonMap = {};
    controllers.forEach((key, controller) {
      jsonMap[key] = controller.text.isEmpty
          ? '0.0'
          : controller.text; // Extract the text from each controller
    });
    return jsonEncode(jsonMap); // Convert the map to a JSON string
  }

  /// sample report function
  createSampleReport({
    required BuildContext context,
    required WidgetRef ref,
    required String ticketId,
    required XFile photo,
    required String parametersJson,
  }) async {
    _sampleReportLoading = true;
    notifyListeners();

    final bool connected = await isConnected();
    if (!connected) {
      // حفظ البيانات مؤقتًا
      await saveReportOffline(
        ticketId: ticketId,
        parametersJson: parametersJson,
        photoPath: photo.path,
        reportType: 'sample',
      );
      _sampleReportLoading = false;
      notifyListeners();
      CustomNavigator.popScreen(context: context);
      ViewFunctions.showCustomSnackBar(
        context: context,
        text: 'تم حفظ التقرير مؤقتًا. سيتم إرساله عند استعادة الاتصال.',
        backgroundColor: Colors.orange,
      );
      return;
    }
    TicketsRepository.createExtractionQualitySampleReport(
      ticketId: ticketId,
      parametersJson: parametersJson,
      photo: photo,
    ).then(
      (value) {
        _sampleReportLoading = false;
        notifyListeners();
        if ((value.id?.isNotEmpty ?? false) && context.mounted) {
          ref.refresh(CrusherTicketScreen.rebuildProvider.notifier).state =
              true;
          CustomNavigator.popScreen(context: context);
          ViewFunctions.showCustomSnackBar(
            context: context,
            text: S.of(context).success,
            backgroundColor: Colors.green,
          );
        } else {
          CustomNavigator.popScreen(context: context);
          ViewFunctions.showCustomSnackBar(
            context: context,
            backgroundColor: Colors.redAccent,
            text: value.message ?? 'Error...',
          );
        }
      },
    ).catchError((err) {
      _sampleReportLoading = false;
      notifyListeners();
      log(err.toString());
      CustomNavigator.popScreen(context: context);
      ViewFunctions.showCustomSnackBar(
        context: context,
        text: err.toString(),
      );
    });
  }

  /// final report function
  createFinalReport({
    required BuildContext context,
    required WidgetRef ref,
    required String ticketId,
    required String parametersJson,
  }) async {
    _finalReportLoading = true;
    notifyListeners();
    final bool connected = await isConnected();
    if (!connected) {
      // حفظ البيانات مؤقتًا
      await saveReportOffline(
          ticketId: ticketId,
          parametersJson: parametersJson,
          photoPath: '',
          reportType: 'final');
      _finalReportLoading = false;
      notifyListeners();
      CustomNavigator.popScreen(context: context);
      ViewFunctions.showCustomSnackBar(
        context: context,
        text: 'تم حفظ التقرير مؤقتًا. سيتم إرساله عند استعادة الاتصال.',
        backgroundColor: Colors.orange,
      );
      return;
    }

    TicketsRepository.createExtractionQualitySampleReport(
      ticketId: ticketId,
      parametersJson: parametersJson,
      photo: XFile(''),
    ).then((value) {
      TicketsRepository.createExtractionQualityFinalReport(
        ticketId: ticketId,
      ).then(
        (value) {
          _finalReportLoading = false;
          notifyListeners();
          if ((value.message == null) && context.mounted) {
            ref
                .refresh(QualityExtractionTicketScreen.rebuildProvider.notifier)
                .state = true;
            CustomNavigator.popScreen(context: context);
            ViewFunctions.showCustomSnackBar(
              context: context,
              text: S.of(context).success,
              backgroundColor: Colors.green,
            );
          } else {
            CustomNavigator.popScreen(context: context);
            ViewFunctions.showCustomSnackBar(
              context: context,
              backgroundColor: Colors.redAccent,
              text: value.message ?? 'Error...',
            );
          }
        },
      ).catchError((err) {
        _finalReportLoading = false;
        notifyListeners();
        CustomNavigator.popScreen(context: context);
        ViewFunctions.showCustomSnackBar(
          context: context,
          text: err.toString(),
        );
      });
    }).catchError((err) {
      _finalReportLoading = false;
      notifyListeners();
      CustomNavigator.popScreen(context: context);
      ViewFunctions.showCustomSnackBar(
        context: context,
        text: err.toString(),
      );
    });
  }

  /// change zone status function
  changZoneStatus({
    required BuildContext context,
    required WidgetRef ref,
    required String zoneId,
    required bool status,
  }) async {
    ViewFunctions.loadingDialog(context: context);
    log("message >>>> $status");
    TicketsRepository.changZoneStatus(
      zoneId: zoneId,
      status: status,
    ).then(
      (value) {
        CustomNavigator.popScreen(context: context);
        if ((value.id?.isNotEmpty ?? false) && context.mounted) {
          ref.refresh(ZoneListScreen.rebuildProvider.notifier).state = true;
          ViewFunctions.showCustomSnackBar(
            context: context,
            text: S.of(context).success,
            backgroundColor: Colors.green,
          );
        } else {
          ViewFunctions.showCustomSnackBar(
            context: context,
            backgroundColor: Colors.redAccent,
            text: value.message ?? 'Error...',
          );
        }
      },
    ).catchError((err) {
      log("Error ========> $err");
      CustomNavigator.popScreen(context: context);
      ViewFunctions.showCustomSnackBar(
        context: context,
        text: err.toString(),
      );
    });
  }

  /// Cleanup old reports that exceed the retention period
  Future<void> _cleanupOldReports() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final reports = prefs.getStringList('offline_reports') ?? [];
      final now = DateTime.now().millisecondsSinceEpoch;
      final retentionPeriod = const Duration(days: 7).inMilliseconds;

      final validReports = reports.where((report) {
        try {
          final reportData = json.decode(report);
          final timestamp = reportData['timestamp'] as int;
          return (now - timestamp) <= retentionPeriod;
        } catch (e) {
          log('Error parsing report timestamp: $e');
          return false;
        }
      }).toList();

      if (validReports.length != reports.length) {
        await prefs.setStringList('offline_reports', validReports);
        log('Cleaned up ${reports.length - validReports.length} old reports');
      }
    } catch (e) {
      log('Error during cleanup: $e');
    }
  }

  ///Resending interim reports when the connection is restored
  Future<void> retryOfflineReports(BuildContext context) async {
    if (_isRetrying) return;

    try {
      _isRetrying = true;

      // Cleanup old reports first
      await _cleanupOldReports();

      final prefs = await SharedPreferences.getInstance();
      final reports = prefs.getStringList('offline_reports') ?? [];

      if (reports.isEmpty) return;

      ViewFunctions.showCustomSnackBar(
        context: context,
        text: "Processing offline reports...",
      );

      final List<String> remainingReports = [];

      // First process all sample reports
      log('Processing sample reports...');
      for (final report in reports) {
        try {
          final reportDetails = _parseReport(report);
          if (reportDetails == null) {
            log('Invalid report format, skipping...');
            continue;
          }

          // Only process sample reports in this phase
          if (reportDetails['reportType'] == 'sample') {
            final success = await processReport(
              context: context,
              ticketId: reportDetails['ticketId'] ?? '',
              parametersJson: reportDetails['parametersJson'] ?? '',
              photoPath: reportDetails['photoPath'] ?? '',
              reportType: 'sample',
            );

            if (!success) {
              remainingReports.add(report);
            }
          } else {
            // Keep final reports for the second phase
            remainingReports.add(report);
          }
        } catch (err) {
          log('Failed to process sample report: $err');
          remainingReports.add(report);
        }
      }

      // Now process all final reports
      log('Processing final reports...');
      final finalReports = List<String>.from(remainingReports);
      remainingReports.clear();

      for (final report in finalReports) {
        try {
          final reportDetails = _parseReport(report);
          if (reportDetails == null || reportDetails['reportType'] != 'final') {
            continue;
          }

          final success = await processReport(
            context: context,
            ticketId: reportDetails['ticketId'] ?? '',
            parametersJson: reportDetails['parametersJson'] ?? '',
            photoPath: reportDetails['photoPath'] ?? '',
            reportType: 'final',
          );

          if (!success) {
            remainingReports.add(report);
          }
        } catch (err) {
          log('Failed to process final report: $err');
          remainingReports.add(report);
        }
      }

      await prefs.setStringList('offline_reports', remainingReports);

      if (remainingReports.isEmpty) {
        ViewFunctions.showCustomSnackBar(
          context: context,
          text: S.of(context).allOfflineReportsProcessedSuccessfully,
          backgroundColor: Colors.green,
        );
      } else {
        ViewFunctions.showCustomSnackBar(
          context: context,
          text: "${remainingReports.length} reports still pending",
          backgroundColor: Colors.orange,
        );
      }
    } finally {
      _isRetrying = false;
    }
  }

  /// Parses the report string into its components.
  Map<String, String>? _parseReport(String report) {
    try {
      final Map<String, dynamic> reportData = json.decode(report);

      // Validate required fields
      final requiredFields = [
        'ticketId',
        'parametersJson',
        'photoPath',
        'reportType',
        'timestamp'
      ];
      for (final field in requiredFields) {
        if (!reportData.containsKey(field)) {
          log('Missing required field: $field');
          return null;
        }
      }

      // Validate JSON structure in parametersJson
      try {
        json.decode(reportData['parametersJson']);
      } catch (e) {
        log('Invalid parameters JSON format: $e');
        return null;
      }

      return {
        'ticketId': reportData['ticketId'].toString(),
        'parametersJson': reportData['parametersJson'],
        'photoPath': reportData['photoPath'],
        'reportType': reportData['reportType'],
        'timestamp': reportData['timestamp'].toString(),
      };
    } catch (e) {
      log('Failed to parse report: $e');
      return null;
    }
  }

  /// Processes a single report based on its type.
  Future<bool> processReport({
    required BuildContext context,
    required String ticketId,
    required String parametersJson,
    required String photoPath,
    required String reportType,
  }) async {
    int retryCount = 0;
    const maxRetries = 3;
    const backoffDuration = Duration(seconds: 5);

    while (retryCount < maxRetries) {
      try {
        if (reportType == 'sample') {
          // Validate photo if it's a sample report
          if (photoPath.isNotEmpty) {
            final file = File(photoPath);
            if (!await file.exists()) {
              log('Photo file not found: $photoPath');
              return false;
            }
          }

          final result =
              await TicketsRepository.createExtractionQualitySampleReport(
            ticketId: ticketId,
            parametersJson: parametersJson,
            photo: XFile(photoPath),
          );
          return _handleResponse(context, result);
        } else {
          // Process the final report
          final sampleResult =
              await TicketsRepository.createExtractionQualitySampleReport(
            ticketId: ticketId,
            parametersJson: parametersJson,
            photo: XFile(''),
          );

          if (!_handleResponse(context, sampleResult)) {
            return false;
          }

          final result =
              await TicketsRepository.createExtractionQualityFinalReport(
            ticketId: ticketId,
          );
          return _handleResponse(context, result);
        }
      } catch (e) {
        log('Attempt ${retryCount + 1} failed: $e');
        retryCount++;
        if (retryCount < maxRetries) {
          await Future.delayed(backoffDuration * retryCount);
        }
      }
    }

    log('Failed after $maxRetries attempts');
    return false;
  }

  /// Handles the response and displays the appropriate message.
  bool _handleResponse(BuildContext context, dynamic response) {
    if ((response.id?.isNotEmpty ?? false) || response.message == null) {
      ViewFunctions.showCustomSnackBar(
        context: context,
        text: S.of(context).success,
        backgroundColor: Colors.green,
      );
      return true;
    } else {
      ViewFunctions.showCustomSnackBar(
        context: context,
        backgroundColor: ColorsUtils.redColor,
        text: response.message ?? 'Error...',
      );
      return false;
    }
  }

  bool get sampleReportLoading => _sampleReportLoading;
  bool get finalReportLoading => _finalReportLoading;
  bool get isStatusChanging => _isStatusChanging;

  /// Change ticket status manually
  changeTicketStatus({
    required BuildContext context,
    required String ticketId,
    required String newStatus,
    required WidgetRef ref,
  }) async {
    try {
      ViewFunctions.loadingDialog(context: context);

      final isConnected = await this.isConnected();
      if (!isConnected) {
        ViewFunctions.showCustomSnackBar(
          context: context,
          text: "No internet connection",
        );
        CustomNavigator.popScreen(context: context);
        return;
      }

      final result = await TicketsRepository.changeExtractionQualityStatus(
        ticketId: ticketId,
        newStatus: newStatus,
      );
      
      if (result.message == null) {
        ViewFunctions.showCustomSnackBar(
          context: context,
          text: result.message ?? S.of(context).success,
        );
        // Refresh the tickets list after status change
        ref.refresh(QualityExtractionTicketScreen.rebuildProvider.notifier).state = true;
      }
    } catch (e) {
      ViewFunctions.showCustomSnackBar(
        context: context,
        text: e.toString(),
      );
    } finally {
      CustomNavigator.popScreen(context: context);
    }
  }
}

class ParameterRow extends StatelessWidget {
  const ParameterRow({
    super.key,
    required this.parameterTitle,
    required this.parameterCnt,
  });

  final TextEditingController parameterCnt;
  final String parameterTitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            parameterTitle,
            style: TextStyle(
              color: Colors.black,
              fontSize: 14.spMin,
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.ellipsis,
            ),
            maxLines: 1,
          ),
        ),
        Expanded(
          flex: 6,
          child: CustomTextField(
            controller: parameterCnt,
            isNumber: true,
            hintText: S.of(context).parameterConcentration,
            centerText: true,
            margin: 5,
            hintStyle: TextStyle(
              fontSize: 12.spMin,
              fontWeight: FontWeight.w400,
              color: ColorsUtils.blackColor.withValues(alpha: 0.7),
            ),
          ),
        ),
      ],
    );
  }
}
