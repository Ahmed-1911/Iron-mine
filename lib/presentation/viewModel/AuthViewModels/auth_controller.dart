import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iron_mine/core/helpers/routes.dart';
import 'package:iron_mine/core/utils/colors_utils.dart';
import 'package:iron_mine/core/utils/enums.dart';
import 'package:iron_mine/data/models/response/auth/login_response.dart';
import 'package:iron_mine/presentation/screens/admin_users/extraction_admin_screen.dart';
import 'package:iron_mine/presentation/screens/authorization/login/login_screen.dart';

import '../../../core/helpers/view_functions.dart';
import '../../../core/utils/token_util.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/preference_manger.dart';
import '../../../data/models/request/auth/log_in_with_otp_request.dart';
import '../../../data/models/request/auth/login_request.dart';
import '../../../data/repository/authRepo/auth_repo.dart';
import '../../../generated/l10n.dart';
import '../../screens/admin_users/crusher_admins_ticket_screen.dart';
import '../../screens/admin_users/storage_admins_ticket_screen.dart';
import '../../screens/quality_users/quality_extraction_ticket_screen.dart';
import '../../screens/quality_users/quality_storage_ticket_screen.dart';

ChangeNotifierProvider<AuthProvider> authProvider =
    ChangeNotifierProvider<AuthProvider>((ref) => AuthProvider());

class AuthProvider extends ChangeNotifier {
  final bool _addAccountLoading;
  bool _logInLoading;
  bool _logInWithOtpLoading;

  AuthProvider()
      : _addAccountLoading = false,
        _logInWithOtpLoading = false,
        _logInLoading = false;

  logIn({
    required BuildContext context,
    required TextEditingController phoneCnt,
    required TextEditingController passwordCnt,
  }) async {
    final RegExp phoneNumberPattern = RegExp(r'^([0٠][١1][\d٠١٢٣٤٥٦٧٨٩]{9})$');

    if (phoneCnt.text.isEmpty || passwordCnt.text.isEmpty) {
      ViewFunctions.showCustomSnackBar(
        context: context,
        hasIcon: false,
        text: S.of(context).addAllFieldsFirst,
      );
    } else if (phoneCnt.text.length != 11 ||
        !(phoneNumberPattern.hasMatch(phoneCnt.text))) {
      ViewFunctions.showCustomSnackBar(
        context: context,
        hasIcon: false,
        text: S.of(context).phoneInvalid,
      );
    } else {
      _logInLoading = true;
      notifyListeners();
      AuthRepository.login(
        loginRequest: LoginRequest(
          phone: phoneCnt.text,
          password: passwordCnt.text,
        ),
      ).then(
        (value) {
          _logInLoading = false;
          notifyListeners();
          if (value.id?.isNotEmpty ?? false) {
            passwordCnt.clear();
            phoneCnt.clear();
            if (context.mounted) {  
              ViewFunctions.showCustomSnackBar(
                context: context,
                text: S.of(context).success,
                backgroundColor: ColorsUtils.kPrimaryColor,
              );
            }
            saveData(value);
            if (context.mounted) {
              navigateToHome(value, context);
            }
          } else {
            if (context.mounted) {
              ViewFunctions.showCustomSnackBar(
                context: context,
                backgroundColor: Colors.redAccent,
                text: value.message?.toString() ?? "Error...",
              );
            }
          }
        },
      ).catchError((err) {
        _logInLoading = false;
        notifyListeners();  
        if (context.mounted) {
          ViewFunctions.showCustomSnackBar(
            context: context,
            text: err.toString(),
          );
        }
      });
    }
  }

  logInWithOtp({
    required BuildContext context,
    required TextEditingController phoneCnt,
    required TextEditingController otpCnt,
    required TextEditingController confirmPasswordCnt,
    required TextEditingController passwordCnt,
  }) async {
    final RegExp phoneNumberPattern = RegExp(r'^([0٠][١1][\d٠١٢٣٤٥٦٧٨٩]{9})$');

    if (passwordCnt.text != confirmPasswordCnt.text) {
      ViewFunctions.showCustomSnackBar(
        context: context,
        hasIcon: false,
        text: "Password not matching",
      );
    } else if (phoneCnt.text.length != 11 ||
        !(phoneNumberPattern.hasMatch(phoneCnt.text))) {
      ViewFunctions.showCustomSnackBar(
        context: context,
        hasIcon: false,
        text: S.of(context).phoneInvalid,
      );
    } else {
      _logInWithOtpLoading = true;
      notifyListeners();
      AuthRepository.loginWithOtp(
        loginRequest: LogInWithOtpRequest(
          phone: phoneCnt.text,
          password: passwordCnt.text,
          otp: otpCnt.text,
        ),
      ).then(
        (value) {
          _logInWithOtpLoading = false;
          notifyListeners();
          if (value.id?.isNotEmpty ?? false) {
            passwordCnt.clear();
            phoneCnt.clear();
            if (context.mounted) {
              ViewFunctions.showCustomSnackBar(
                context: context,
                text: S.of(context).success,
                backgroundColor: ColorsUtils.kPrimaryColor,
              );
            }
            if (context.mounted) {
              CustomNavigator.cleanAndPush(
                context: context,
                widget: LogInScreen(),
              );
            }
          } else {
            if (context.mounted) {
              ViewFunctions.showCustomSnackBar(
                context: context,
              backgroundColor: Colors.redAccent,
                text: value.message?.toString() ?? "Error...",
              );
            }
          }
        },
      ).catchError((err) {
        _logInWithOtpLoading = false;
        notifyListeners();
        if (context.mounted) {
          ViewFunctions.showCustomSnackBar(
            context: context,
            text: err.toString(),
          );
        }
      });
    }
  }

  void navigateToHome(LoginResponse value, BuildContext context) {
    if (value.role == RolesEnum.crusherAdmin) {
      CustomNavigator.cleanAndPush(
        context: context,
        widget: CrusherTicketScreen(),
      );
    } else if (value.role == RolesEnum.storageAdmin) {
      CustomNavigator.cleanAndPush(
        context: context,
        widget: StorageTicketScreen(),
      );
    } else if(value.role == RolesEnum.extractionQuality) {
      CustomNavigator.cleanAndPush(
        context: context,
        widget: QualityExtractionTicketScreen(),
      );
    } else if(value.role == RolesEnum.storageQuality) {
      CustomNavigator.cleanAndPush(
        context: context,
        widget: QualityStorageTicketScreen(),
      );
    } else {
      CustomNavigator.cleanAndPush(
        context: context,
        widget: ExtractionZoneListScreen(),
      );
    }
  }

  void saveData(LoginResponse value) {
    TokenUtil.saveToken(value.accessToken.toString());
    PreferenceManager.instance.saveString(
      Constants.token,
      value.accessToken.toString(),
    );
    PreferenceManager.instance.saveString(
      Constants.userId,
      value.id.toString(),
    );
    PreferenceManager.instance.saveString(
      Constants.userPhone,
      value.phone.toString(),
    );
    PreferenceManager.instance.saveString(
      Constants.userName,
      value.name.toString(),
    );
    PreferenceManager.instance.saveString(
      Constants.destinationId,
      value.orgId.toString(),
    );
    PreferenceManager.instance.saveString(
      Constants.role,
      value.role.toString(),
    );
  }

  bool get addAccountLoading => _addAccountLoading;

  bool get logInWithOtpLoading => _logInWithOtpLoading;

  bool get logInLoading => _logInLoading;
}
