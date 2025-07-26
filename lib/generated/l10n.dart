// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `No internet connection, please check you network and try again`
  String get no_internet_connection {
    return Intl.message(
      'No internet connection, please check you network and try again',
      name: 'no_internet_connection',
      desc: '',
      args: [],
    );
  }

  /// `No Available Data`
  String get no_data {
    return Intl.message(
      'No Available Data',
      name: 'no_data',
      desc: '',
      args: [],
    );
  }

  /// `No Available Orders Now!`
  String get no_order {
    return Intl.message(
      'No Available Orders Now!',
      name: 'no_order',
      desc: '',
      args: [],
    );
  }

  /// `Internal Server Error`
  String get internal_server_error {
    return Intl.message(
      'Internal Server Error',
      name: 'internal_server_error',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number`
  String get phoneNumber {
    return Intl.message(
      'Phone Number',
      name: 'phoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get confirmPassword {
    return Intl.message(
      'Confirm Password',
      name: 'confirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `All offline reports processed successfully`
  String get allOfflineReportsProcessedSuccessfully {
    return Intl.message(
      'All offline reports processed successfully',
      name: 'allOfflineReportsProcessedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Lot Name`
  String get lotName {
    return Intl.message(
      'Lot Name',
      name: 'lotName',
      desc: '',
      args: [],
    );
  }

  /// `Full Name`
  String get fullName {
    return Intl.message(
      'Full Name',
      name: 'fullName',
      desc: '',
      args: [],
    );
  }

  /// `Log in`
  String get login {
    return Intl.message(
      'Log in',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get register {
    return Intl.message(
      'Register',
      name: 'register',
      desc: '',
      args: [],
    );
  }

  /// `Add all the data first`
  String get addAllFieldsFirst {
    return Intl.message(
      'Add all the data first',
      name: 'addAllFieldsFirst',
      desc: '',
      args: [],
    );
  }

  /// `Phone number is incorrect`
  String get phoneInvalid {
    return Intl.message(
      'Phone number is incorrect',
      name: 'phoneInvalid',
      desc: '',
      args: [],
    );
  }

  /// `Password has entered successfully`
  String get passwordCompleted {
    return Intl.message(
      'Password has entered successfully',
      name: 'passwordCompleted',
      desc: '',
      args: [],
    );
  }

  /// `Ok`
  String get ok {
    return Intl.message(
      'Ok',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Register with OTP`
  String get registerWithOtp {
    return Intl.message(
      'Register with OTP',
      name: 'registerWithOtp',
      desc: '',
      args: [],
    );
  }

  /// `OTP`
  String get otp {
    return Intl.message(
      'OTP',
      name: 'otp',
      desc: '',
      args: [],
    );
  }

  /// `Success...`
  String get success {
    return Intl.message(
      'Success...',
      name: 'success',
      desc: '',
      args: [],
    );
  }

  /// `Already registered`
  String get alreadyRegistered {
    return Intl.message(
      'Already registered',
      name: 'alreadyRegistered',
      desc: '',
      args: [],
    );
  }

  /// `Weight`
  String get weight {
    return Intl.message(
      'Weight',
      name: 'weight',
      desc: '',
      args: [],
    );
  }

  /// `KG`
  String get kg {
    return Intl.message(
      'KG',
      name: 'kg',
      desc: '',
      args: [],
    );
  }

  /// `Receive load`
  String get receiveLoad {
    return Intl.message(
      'Receive load',
      name: 'receiveLoad',
      desc: '',
      args: [],
    );
  }

  /// `Vehicle Loads`
  String get vehicleLoads {
    return Intl.message(
      'Vehicle Loads',
      name: 'vehicleLoads',
      desc: '',
      args: [],
    );
  }

  /// `Orders number`
  String get ordersNumber {
    return Intl.message(
      'Orders number',
      name: 'ordersNumber',
      desc: '',
      args: [],
    );
  }

  /// `Ticket No`
  String get ticketNo {
    return Intl.message(
      'Ticket No',
      name: 'ticketNo',
      desc: '',
      args: [],
    );
  }

  /// `Choose Waste Type First`
  String get chooseWasteType {
    return Intl.message(
      'Choose Waste Type First',
      name: 'chooseWasteType',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Log Out`
  String get logOut {
    return Intl.message(
      'Log Out',
      name: 'logOut',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get submit {
    return Intl.message(
      'Submit',
      name: 'submit',
      desc: '',
      args: [],
    );
  }

  /// `Change Status`
  String get changeStatus {
    return Intl.message(
      'Change Status',
      name: 'changeStatus',
      desc: '',
      args: [],
    );
  }

  /// `Finished Storage Quality Tickets`
  String get finishedStorageQualityTickets {
    return Intl.message(
      'Finished Storage Quality Tickets',
      name: 'finishedStorageQualityTickets',
      desc: '',
      args: [],
    );
  }

  /// `Finished Extraction Tickets`
  String get finishedExtractionTickets {
    return Intl.message(
      'Finished Extraction Tickets',
      name: 'finishedExtractionTickets',
      desc: '',
      args: [],
    );
  }

  /// `Extraction Admin`
  String get extraction_admin {
    return Intl.message(
      'Extraction Admin',
      name: 'extraction_admin',
      desc: '',
      args: [],
    );
  }

  /// `Zones review`
  String get zonesReview {
    return Intl.message(
      'Zones review',
      name: 'zonesReview',
      desc: '',
      args: [],
    );
  }

  /// `Zones Name`
  String get zoneName {
    return Intl.message(
      'Zones Name',
      name: 'zoneName',
      desc: '',
      args: [],
    );
  }

  /// `date`
  String get date {
    return Intl.message(
      'date',
      name: 'date',
      desc: '',
      args: [],
    );
  }

  /// `zone id`
  String get zoneId {
    return Intl.message(
      'zone id',
      name: 'zoneId',
      desc: '',
      args: [],
    );
  }

  /// `add zone name`
  String get addZoneName {
    return Intl.message(
      'add zone name',
      name: 'addZoneName',
      desc: '',
      args: [],
    );
  }

  /// `add`
  String get add {
    return Intl.message(
      'add',
      name: 'add',
      desc: '',
      args: [],
    );
  }

  /// `extraction quality`
  String get extractionQuality {
    return Intl.message(
      'extraction quality',
      name: 'extractionQuality',
      desc: '',
      args: [],
    );
  }

  /// `lots review`
  String get lotsReview {
    return Intl.message(
      'lots review',
      name: 'lotsReview',
      desc: '',
      args: [],
    );
  }

  /// `pending`
  String get pending {
    return Intl.message(
      'pending',
      name: 'pending',
      desc: '',
      args: [],
    );
  }

  /// `finished`
  String get finished {
    return Intl.message(
      'finished',
      name: 'finished',
      desc: '',
      args: [],
    );
  }

  /// `lot id`
  String get lotId {
    return Intl.message(
      'lot id',
      name: 'lotId',
      desc: '',
      args: [],
    );
  }

  /// `sample report`
  String get sampleReport {
    return Intl.message(
      'sample report',
      name: 'sampleReport',
      desc: '',
      args: [],
    );
  }

  /// `final report`
  String get finalReport {
    return Intl.message(
      'final report',
      name: 'finalReport',
      desc: '',
      args: [],
    );
  }

  /// `home `
  String get home {
    return Intl.message(
      'home ',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `zone list`
  String get zoneList {
    return Intl.message(
      'zone list',
      name: 'zoneList',
      desc: '',
      args: [],
    );
  }

  /// `unverified`
  String get unverified {
    return Intl.message(
      'unverified',
      name: 'unverified',
      desc: '',
      args: [],
    );
  }

  /// `verified zones`
  String get verifiedZones {
    return Intl.message(
      'verified zones',
      name: 'verifiedZones',
      desc: '',
      args: [],
    );
  }

  /// `accepted`
  String get accepted {
    return Intl.message(
      'accepted',
      name: 'accepted',
      desc: '',
      args: [],
    );
  }

  /// `rejected`
  String get rejected {
    return Intl.message(
      'rejected',
      name: 'rejected',
      desc: '',
      args: [],
    );
  }

  /// `receivable`
  String get receivable {
    return Intl.message(
      'receivable',
      name: 'receivable',
      desc: '',
      args: [],
    );
  }

  /// `crushing`
  String get crushing {
    return Intl.message(
      'crushing',
      name: 'crushing',
      desc: '',
      args: [],
    );
  }

  /// `dispatchable`
  String get dispatchable {
    return Intl.message(
      'dispatchable',
      name: 'dispatchable',
      desc: '',
      args: [],
    );
  }

  /// `Quality Status`
  String get qualityStatus {
    return Intl.message(
      'Quality Status',
      name: 'qualityStatus',
      desc: '',
      args: [],
    );
  }

  /// `Create New Lot`
  String get createNewLot {
    return Intl.message(
      'Create New Lot',
      name: 'createNewLot',
      desc: '',
      args: [],
    );
  }

  /// `Parameter Concentration`
  String get parameterConcentration {
    return Intl.message(
      'Parameter Concentration',
      name: 'parameterConcentration',
      desc: '',
      args: [],
    );
  }

  /// `Received From`
  String get receivedFrom {
    return Intl.message(
      'Received From',
      name: 'receivedFrom',
      desc: '',
      args: [],
    );
  }

  /// `Plate Number`
  String get plateNumber {
    return Intl.message(
      'Plate Number',
      name: 'plateNumber',
      desc: '',
      args: [],
    );
  }

  /// `Are You Confirm Crushing This Lot ?`
  String get confirmCrushing {
    return Intl.message(
      'Are You Confirm Crushing This Lot ?',
      name: 'confirmCrushing',
      desc: '',
      args: [],
    );
  }

  /// `Dispatch By`
  String get dispatchBy {
    return Intl.message(
      'Dispatch By',
      name: 'dispatchBy',
      desc: '',
      args: [],
    );
  }

  /// `Add lot name`
  String get addLotName {
    return Intl.message(
      'Add lot name',
      name: 'addLotName',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
