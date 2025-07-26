// import 'dart:developer';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// import '../../../core/helpers/routes.dart';
//
// final otpProvider = ChangeNotifierProvider<OtpProvider>((ref) => OtpProvider());
//
// class OtpProvider extends ChangeNotifier {
//   late AuthCredential _phoneAuthCredential;
//   String _verificationId = '';
//   int? _code;
//
//   late User _firebaseUser;
//
//   String errorMessage = '------';
//
//   Future<String> submitPhoneNumber({
//     required BuildContext context,
//     required String mobileNumber,
//     required String countryCode,
//   }) async {
//     /// NOTE: Either append your phone number country code or add in the code itself
//     /// Since I'm in India we use "+91 " as prefix `phoneNumber`
//     String phoneNumber = countryCode + mobileNumber.trim();
//     log(phoneNumber);
//
//     /// The below functions are the callbacks, separated so as to make code more redable
//     void verificationCompleted(AuthCredential phoneAuthCredential) {
//       log('verificationCompleted');
//
//       _phoneAuthCredential = phoneAuthCredential;
//       log('our phone AuthCredential$phoneAuthCredential');
//     }
//
//     void verificationFailed(FirebaseAuthException error) {
//       log('verificationFailed');
//       log('our error${error.message}');
//       ViewFunctions.showCustomSnackBar(
//         context: context,
//         hasIcon: false,
//         text: error.message ?? '',
//       );
//       CustomNavigator.popScreen(context: context);
//     }
//
//     void codeSent(String verificationId, [int? code]) {
//       log('codeSent');
//       _verificationId = verificationId;
//       log('verificationId : $verificationId');
//       _code = code ?? 0;
//       log('our new code $code');
//     }
//
//     void codeAutoRetrievalTimeout(String verificationId) {
//       log('codeAutoRetrievalTimeout');
//     }
//
//     await FirebaseAuth.instance.verifyPhoneNumber(
//       /// Make sure to prefix with your country code
//       phoneNumber: phoneNumber,
//
//       /// `seconds` didn't work. The underlying implementation code only reads in `millisenconds`
//       timeout: const Duration(seconds: 60),
//
//       /// If the SIM (with phoneNumber) is in the current device this function is called.
//       /// This function gives `AuthCredential`. Moreover `login` function can be called from this callback
//       /// When this function is called there is no need to enter the OTP, you can click on Login button to sigin directly as the device is now verified
//       verificationCompleted: verificationCompleted,
//
//       /// Called when the verification is failed
//       verificationFailed: verificationFailed,
//
//       /// This is called after the OTP is sent. Gives a `verificationId` and `code`
//       codeSent: codeSent,
//
//       /// After automatic code retrival `tmeout` this function is called
//       codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
//     ); // All the callbacks are above
//
//     notifyListeners();
//
//     log(_code.toString());
//     return _code.toString();
//   }
//
//   Future<String> submitOTP({String? smsCode}) async {
//     /// get the `smsCode` from the user
//     log('vefid$_verificationId');
//
//     /// when used different phoneNumber other than the current (running) device
//     /// we need to use OTP to get `phoneAuthCredential` which is inturn used to signIn/login
//     _phoneAuthCredential = PhoneAuthProvider.credential(
//       verificationId: _verificationId,
//       smsCode: smsCode!.trim(),
//     );
//
//     log('our Code ${_phoneAuthCredential.token}');
//     final userId = await _loginFirebase();
//     notifyListeners();
//     return userId;
//   }
//
//   Future<String> _loginFirebase() async {
//     /// This method is used to login the user
//     /// `AuthCredential`(`_phoneAuthCredential`) is needed for the signIn method
//     /// After the signIn method from `AuthResult` we can get `FirebaserUser`(`_firebaseUser`)
//
//     String userId = '';
//     try {
//       await FirebaseAuth.instance
//           .signInWithCredential(_phoneAuthCredential)
//           .then((UserCredential authRes) {
//         _firebaseUser = authRes.user!;
//         userId = _firebaseUser.uid;
//       }).catchError((e) {
//         log(e.toString());
//         errorMessage = e.toString();
//       });
//     } catch (e) {
//       log(e.toString());
//       errorMessage = e.toString();
//     }
//     notifyListeners();
//     return userId;
//   }
// }
