// ignore_for_file: use_super_parameters

import 'package:iron_mine/core/utils/enumeration.dart';

class HttpMethod extends Enum {
  HttpMethod(value) : super(value);

  static final HttpMethod get = HttpMethod('GET');
  static final HttpMethod post = HttpMethod('POST');
  static final HttpMethod patch = HttpMethod('PATCH');
  static final HttpMethod delete = HttpMethod('DELETE');
}

class NetworkStatusCodes extends Enum {
  NetworkStatusCodes(value) : super(value);

  static final unAuthorizedUser = NetworkStatusCodes(401);
  static final badRequest = NetworkStatusCodes(400);
  static final serverInternalError = NetworkStatusCodes(500);
  static final ok200 = NetworkStatusCodes(200);
  static final ok201 = NetworkStatusCodes(201);
}

class ContractTypes extends Enum {
  ContractTypes(value) : super(value);

  static final individuals = ContractTypes(230);
  static final companies = ContractTypes(231);
}

class ContractModes extends Enum {
  ContractModes(value) : super(value);

  static final contractMode = ContractModes(240);
}

class AuthTypesEnum {
  static const logIn = 'logIn';
  static const signUp = 'signUp';
}

class OrderStatusEnum {
  static const String pending = 'pending-lots';
  static const String completed ='finished-lots';
}

class CrusherOrderStatusEnum {
  static const String receivable = 'receive-tickets';
  static const String crushing = 'crushing-tickets';
  static const String dispatchable ='dispatchable-tickets';
}

class ZoneStatusEnum {
  static const String verifiedZones = 'verified-zones';
  static const String unverifiedZones ='unverified-zones';
}

class RolesEnum {
  static const storageQuality = 'storage_quality';
  static const extractionQuality = 'extraction_quality';
  static const storageAdmin = 'storage_admin';
  static const crusherAdmin = 'crusher_admin';
  static const extractionAdmin = 'extraction_admin';
}


