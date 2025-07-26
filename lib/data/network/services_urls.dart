import 'package:flutter/foundation.dart';

class ServicesURLs {
  static const productionUrl = "https://api-iron-miner.environ-adapt.com/";
  static const devUrl = "https://apitest-iron-miner.environ-adapt.com/";

  static const developmentEnvironment = kReleaseMode ? productionUrl : devUrl;
  static const developmentEnvironmentScheme = 'http';

  //Auth endPoints
  static const login = "auth/login";
  static const loginWithOtp = "users/verify";

  // crusher endPoints
  static const getVehicles = "vehicles";
  static const getCrusherTickets = "crusher/";
  static const collectedMaterials = "collected-materials";
  static const crusherReceiveTickets = "crusher/receive-tickets";
  static const crusherDispatchTickets = "crusher/dispatchable-tickets";
  static const crusherCrushTickets = "crusher/crushing-tickets";

  // storage admin endPoints
  static const getStorageTickets = "storage/receivable-tickets";
  static const storageReceiveTickets = "storage/receivable-tickets";

  // extraction admin endPoints
  static const getExtractionZones = "extraction-admin/zones";
  static const addZone = "extraction-admin/zones";
  static const addLot= "extraction-admin/lots";

  // storage quality endPoints
  static const getStorageQualityTickets = "storage-quality/";
  static const storageQualityReport = "storage-quality/pending-lots";
  static const changeStorageQualityStatus = "storage-quality/finished-lots";

  // crusher quality endPoints
  static const getExtractionQualityTickets = "extraction-quality/";
  static const changeExtractionQualityStatus = "extraction-quality/finished-lots";
  static const getZones = "extraction-quality/";
  static const extractionQualityReport = "extraction-quality/pending-lots";
  static const changeZoneStatus = "extraction-quality/unverified-zones";

}
