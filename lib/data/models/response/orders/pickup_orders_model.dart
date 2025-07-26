// To parse this JSON data, do
//
//     final getPickupOrdersResponse = getPickupOrdersResponseFromJson(jsonString);

import 'dart:convert';

GetPickupOrdersResponse getPickupOrdersResponseFromJson(String str) =>
    GetPickupOrdersResponse.fromJson(json.decode(str));

String getPickupOrdersResponseToJson(GetPickupOrdersResponse data) =>
    json.encode(data.toJson());

class GetPickupOrdersResponse {
  List<PickupOrder>? items;
  Meta? meta;

  GetPickupOrdersResponse({
    this.items,
    this.meta,
  });

  factory GetPickupOrdersResponse.fromJson(Map<String, dynamic> json) =>
      GetPickupOrdersResponse(
        items: json["items"] == null
            ? []
            : List<PickupOrder>.from(
                json["items"]!.map((x) => PickupOrder.fromJson(x))),
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "items": items == null
            ? []
            : List<dynamic>.from(items!.map((x) => x.toJson())),
        "meta": meta?.toJson(),
      };
}

class PickupOrder {
  String? id;
  String? createdDate;
  String? updatedDate;
  String? createdById;
  dynamic updatedById;
  dynamic wasteTypeId;
  String? shift;
  String? blockNo;
  String? unitNo;
  String? floorNo;
  String? expPickupDate;
  String? stopId;
  int? countOfBags;
  int? finalWeightInKg;
  int? shortId;
  String? status;
  RecentPhoto? recentPhoto;
  Stop? stop;

  PickupOrder({
    this.id,
    this.createdDate,
    this.updatedDate,
    this.createdById,
    this.updatedById,
    this.wasteTypeId,
    this.shift,
    this.blockNo,
    this.unitNo,
    this.countOfBags,
    this.floorNo,
    this.expPickupDate,
    this.shortId,
    this.finalWeightInKg,
    this.stopId,
    this.status,
    this.recentPhoto,
    this.stop,
  });

  factory PickupOrder.fromJson(Map<String, dynamic> json) => PickupOrder(
        id: json["id"],
        createdDate: json["createdDate"],
        updatedDate: json["updatedDate"],
        createdById: json["createdById"],
        updatedById: json["updatedById"],
        wasteTypeId: json["wasteTypeId"],
        shift: json["shift"],
        finalWeightInKg: json["finalWeightInKg"],
        blockNo: json["blockNo"],
        unitNo: json["unitNo"],
        countOfBags: json["countOfBags"],
        floorNo: json["floorNo"],
        shortId: json["shortId"],
        expPickupDate: json["expPickupDate"],
        stopId: json["stopId"],
        status: json["status"],
        recentPhoto: json["recentPhoto"] == null
            ? null
            : RecentPhoto.fromJson(json["recentPhoto"]),
        stop: json["stop"] == null ? null : Stop.fromJson(json["stop"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "createdDate": createdDate,
        "updatedDate": updatedDate,
        "createdById": createdById,
        "finalWeightInKg": finalWeightInKg,
        "updatedById": updatedById,
        "wasteTypeId": wasteTypeId,
        "shift": shift,
        "blockNo": blockNo,
        "unitNo": unitNo,
        "countOfBags": countOfBags,
        "floorNo": floorNo,
        "shortId": shortId,
        "expPickupDate": expPickupDate,
        "stopId": stopId,
        "status": status,
        "recentPhoto": recentPhoto?.toJson(),
        "stop": stop?.toJson(),
      };
}

class RecentPhoto {
  String? name;
  String? path;

  RecentPhoto({
    this.name,
    this.path,
  });

  factory RecentPhoto.fromJson(Map<String, dynamic> json) => RecentPhoto(
        name: json["name"],
        path: json["path"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "path": path,
      };
}

class Stop {
  String? id;
  String? distCode;

  Stop({
    this.id,
    this.distCode,
  });

  factory Stop.fromJson(Map<String, dynamic> json) => Stop(
        id: json["id"],
        distCode: json["distCode"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "distCode": distCode,
      };
}

class Meta {
  int? totalItems;
  int? itemCount;
  int? itemsPerPage;
  int? totalPages;
  int? currentPage;

  Meta({
    this.totalItems,
    this.itemCount,
    this.itemsPerPage,
    this.totalPages,
    this.currentPage,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        totalItems: json["totalItems"],
        itemCount: json["itemCount"],
        itemsPerPage: json["itemsPerPage"],
        totalPages: json["totalPages"],
        currentPage: json["currentPage"],
      );

  Map<String, dynamic> toJson() => {
        "totalItems": totalItems,
        "itemCount": itemCount,
        "itemsPerPage": itemsPerPage,
        "totalPages": totalPages,
        "currentPage": currentPage,
      };
}
