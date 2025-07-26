import 'dart:convert';

import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';

import '../../../core/utils/enums.dart';
import '../../models/request/orders/get_orders_request.dart';
import '../../models/response/orders/extraction_receive_ticket_response.dart';
import '../../models/response/orders/get_materials_response.dart';
import '../../models/response/orders/get_storage_quality_tickets_response.dart';
import '../../models/response/orders/get_tickets_response.dart';
import '../../models/response/orders/get_vehicles_list_response.dart';
import '../../models/response/orders/get_zone_list_response.dart';
import '../../network/networkCallback/network_callback.dart';
import '../../network/services_urls.dart';

class TicketsRepository {
  static Future<List<VehicleItem>> getVehicleItems({
    required GetOrdersRequest getOrderRequest,
  }) async {
    final response = await NetworkCall.makeCall(
      endPoint: ServicesURLs.getVehicles,
      method: HttpMethod.get,
      queryParams: getOrderRequest.toMap(),
    );
    return VehiclesListResponse.fromJson(response).vehicleItems ?? [];
  }

  ///  crusher admin
  static Future<GetTicketsResponse> getCrusherTickets({
    required String ticketsType,
    required GetOrdersRequest getOrderRequest,
  }) async {
    final response = await NetworkCall.makeCall(
      endPoint: ServicesURLs.getCrusherTickets + ticketsType,
      method: HttpMethod.get,
      queryParams: getOrderRequest.toMap(),
    );
    return GetTicketsResponse.fromJson(response);
  }

  static Future<GetMaterialsResponse> getMaterials({
    required String ssid,
  }) async {
    final response = await NetworkCall.makeCall(
      endPoint: ServicesURLs.collectedMaterials,
      method: HttpMethod.get,
      queryParams: {
        'ssid': ssid,
      },
    );
    return GetMaterialsResponse.fromJson(response);
  }

  static Future<ExtractionReceiveTicketResponse> crusherReceiveTicket({
    required String plateNo,
    required String ticketId,
  }) async {
    final response = await NetworkCall.makeCall(
      endPoint: '${ServicesURLs.crusherReceiveTickets}/$ticketId/receive',
      method: HttpMethod.post,
      requestBody: {"vehicle_plate_number": plateNo},
    );
    return ExtractionReceiveTicketResponse.fromJson(response);
  }

  static Future<ExtractionReceiveTicketResponse> crusherCrushTicket({
    required List<String> ticketIds,
  }) async {
    // Explicitly encode the body to match Postman's format
    final String encodedBody = json.encode({
      "ticket_ids": ticketIds,
    });
    
    final response = await NetworkCall.makeCall(
      endPoint: '${ServicesURLs.crusherCrushTickets}/crush',
      method: HttpMethod.post,
      requestBody: encodedBody,  // Send the encoded string directly
      headers: {
        'Content-Type': 'application/json',  // Ensure content type is set
      },
    );
    return ExtractionReceiveTicketResponse.fromJson(response);
  }

  static Future<ExtractionReceiveTicketResponse> crusherDispatchTicket({
    required String vehicleId,
    required String ticketId,
  }) async {
    final response = await NetworkCall.makeCall(
      endPoint: '${ServicesURLs.crusherDispatchTickets}/$ticketId/dispatch',
      method: HttpMethod.post,
      requestBody: {"vehicle_id": vehicleId},
    );
    return ExtractionReceiveTicketResponse.fromJson(response);
  }

  ///  storage admin
  static Future<GetTicketsResponse> getStorageTickets() async {
    final response = await NetworkCall.makeCall(
      endPoint: ServicesURLs.getStorageTickets,
      method: HttpMethod.get,
    );
    return GetTicketsResponse.fromJson(response);
  }

  static Future<ExtractionReceiveTicketResponse> storageReceiveTicket({
    required String vehicleId,
    required String ticketId,
    required String weight,
  }) async {
    final response = await NetworkCall.makeCall(
      endPoint: '${ServicesURLs.storageReceiveTickets}/$ticketId/receive',
      method: HttpMethod.post,
      requestBody: {"vehicle_id": vehicleId,"weight":weight,},
    );
    return ExtractionReceiveTicketResponse.fromJson(response);
  }

  ///  extraction admin
  static Future<GetZoneListResponse> getExtractionZonesList({
    required GetOrdersRequest getOrderRequest,
    required String zonesType,
}) async {
    final response = await NetworkCall.makeCall(
      endPoint: ServicesURLs.getExtractionZones,
      method: HttpMethod.get,
      queryParams: {
        ...getOrderRequest.toMap(),
        if (zonesType == 'verified') 'isVerified': 'true',
      },
    );
    return GetZoneListResponse.fromJson(response);
  }



  static Future<ExtractionReceiveTicketResponse> addZone({
    required String zoneName,
  }) async {
    final response = await NetworkCall.makeCall(
      endPoint: ServicesURLs.addZone,
      method: HttpMethod.post,
      requestBody: {"name": zoneName},
    );
    return ExtractionReceiveTicketResponse.fromJson(response);
  }

  static Future<ExtractionReceiveTicketResponse> addNewLot({
    required String zoneId,
    required String lotName,
  }) async {
    final response = await NetworkCall.makeCall(
      endPoint: ServicesURLs.addLot,
      method: HttpMethod.post,
      requestBody: {"zone_id": zoneId,"name":lotName},
    );
    return ExtractionReceiveTicketResponse.fromJson(response);
  }

  ///  storage quality
  static Future<GetStorageQualityTicketsResponse> getStorageQualityTickets({
    required GetOrdersRequest getOrderRequest,
    required String ticketsType,
  }) async {
    final response = await NetworkCall.makeCall(
      endPoint: ServicesURLs.getStorageQualityTickets + ticketsType,
      method: HttpMethod.get,
      queryParams: getOrderRequest.toMap(),
    );
    return GetStorageQualityTicketsResponse.fromJson(response);
  }

  static Future<ExtractionReceiveTicketResponse> createStorageQualitySampleReport({
    required String ticketId,
    required String parametersJson,
    required XFile photo,
  }) async {
    List<MultipartFile> multiPartList = [];
    if(photo.path.isNotEmpty){
      multiPartList.add(
        await MultipartFile.fromPath(
            "photo", photo.path, contentType: MediaType('image', 'jpg',)),
      );
    }
    final response = await NetworkCall.makeCall(
      endPoint: '${ServicesURLs.storageQualityReport}/$ticketId/sample-reports',
      method: HttpMethod.post,
      requestBody: jsonDecode(parametersJson),
      isMultipart: photo.path.isNotEmpty,
      multiPartValues: multiPartList,
    );
    return ExtractionReceiveTicketResponse.fromJson(response);
  }

  static Future<ExtractionReceiveTicketResponse> createStorageQualityFinalReport({
    required String ticketId,
  }) async {
    final response = await NetworkCall.makeCall(
      endPoint: '${ServicesURLs.storageQualityReport}/$ticketId/final-report',
      method: HttpMethod.post,
    );
    return ExtractionReceiveTicketResponse.fromJson(response);
  }

  // Function to manually change storage quality ticket status
  static Future<ExtractionReceiveTicketResponse> changeStorageQualityStatus({
    required String ticketId,
    required String newStatus,
  }) async {
    final response = await NetworkCall.makeCall(
      endPoint: '${ServicesURLs.changeStorageQualityStatus}/$ticketId/acceptance',
      method: HttpMethod.post,
      requestBody: {"quality_status": newStatus},
    );
    return ExtractionReceiveTicketResponse.fromJson(response);
  }

  ///  extraction quality
  static Future<GetStorageQualityTicketsResponse> getExtractionQualityTickets({
    required GetOrdersRequest getOrderRequest,
    required String ticketsType,
  }) async {
    final response = await NetworkCall.makeCall(
      endPoint: ServicesURLs.getExtractionQualityTickets + ticketsType,
      method: HttpMethod.get,
      queryParams: getOrderRequest.toMap(),
    );
    return GetStorageQualityTicketsResponse.fromJson(response);
  }

  static Future<GetZoneListResponse> getZonesList({
    required String zoneType,
    required GetOrdersRequest getOrderRequest,
  }) async {
    final response = await NetworkCall.makeCall(
      endPoint: ServicesURLs.getZones + zoneType,
      method: HttpMethod.get,
      queryParams: getOrderRequest.toMap(),
    );
    return GetZoneListResponse.fromJson(response);
  }

  static Future<ExtractionReceiveTicketResponse> changZoneStatus({
    required String zoneId,
    required bool status,
  }) async {
    final response = await NetworkCall.makeCall(
        endPoint: '${ServicesURLs.changeZoneStatus}/$zoneId/verify',
        method: HttpMethod.post,
        requestBody: {"verified": '$status'},
    );
    return ExtractionReceiveTicketResponse.fromJson(response);
  }

  static Future<ExtractionReceiveTicketResponse> createExtractionQualitySampleReport({
    required String ticketId,
    required String parametersJson,
    required XFile photo,
  }) async {
    List<MultipartFile> multiPartList = [];
    if(photo.path.isNotEmpty){
      multiPartList.add(
        await MultipartFile.fromPath(
            "photo", photo.path, contentType: MediaType('image', 'jpg',)),
      );
    }
    final response = await NetworkCall.makeCall(
      endPoint: '${ServicesURLs.extractionQualityReport}/$ticketId/sample-reports',
      method: HttpMethod.post,
      requestBody: jsonDecode(parametersJson),
      isMultipart: photo.path.isNotEmpty,
      multiPartValues: multiPartList,
    );
    return ExtractionReceiveTicketResponse.fromJson(response);
  }

  static Future<ExtractionReceiveTicketResponse> createExtractionQualityFinalReport({
    required String ticketId,
  }) async {
    final response = await NetworkCall.makeCall(
      endPoint: '${ServicesURLs.extractionQualityReport}/$ticketId/final-report',
      method: HttpMethod.post,
    );
    return ExtractionReceiveTicketResponse.fromJson(response);
  }

  // Function to manually change extraction quality ticket status
  static Future<ExtractionReceiveTicketResponse> changeExtractionQualityStatus({
    required String ticketId,
    required String newStatus,
  }) async {
    final response = await NetworkCall.makeCall(
      endPoint: '${ServicesURLs.changeExtractionQualityStatus}/$ticketId/acceptance',
      method: HttpMethod.post,
      requestBody: {"quality_status": newStatus},
    );
    return ExtractionReceiveTicketResponse.fromJson(response);
  }

}
