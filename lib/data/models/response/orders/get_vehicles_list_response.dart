class VehiclesListResponse {
  List<VehicleItem>? vehicleItems;
  int? totalCount;

  VehiclesListResponse({
    this.vehicleItems,
    this.totalCount,
  });

  factory VehiclesListResponse.fromJson(Map<String, dynamic> json) =>
      VehiclesListResponse(
        vehicleItems: json["items"] == null
            ? []
            : List<VehicleItem>.from(
                json["items"]!.map((x) => VehicleItem.fromJson(x))
        ),
        totalCount: json["totalCount"],

      );

  Map<String, dynamic> toJson() => {
        "items": vehicleItems == null
            ? []
            : List<dynamic>.from(vehicleItems!.map((x) => x.toJson())),
    "totalCount": totalCount,

      };
}

class VehicleItem {
  String? id;
  DateTime? createdDate;
  dynamic createdById;
  dynamic deletedById;
  String? barcode;
  String? licenseNumber;
  String? plateNumber;
  dynamic modelYear;
  String? manufacturerEng;
  dynamic manufacturerAr;
  String? type;
  dynamic capacity;
  dynamic volume;
  bool? active;
  dynamic photo;
  dynamic organization;

  VehicleItem({
    this.id,
    this.createdDate,
    this.createdById,
    this.deletedById,
    this.barcode,
    this.licenseNumber,
    this.plateNumber,
    this.modelYear,
    this.manufacturerEng,
    this.manufacturerAr,
    this.type,
    this.capacity,
    this.volume,
    this.active,
    this.photo,
    this.organization,
  });

  factory VehicleItem.fromJson(Map<String, dynamic> json) => VehicleItem(
    id: json["id"],
    createdDate: json["createdDate"] == null ? null : DateTime.parse(json["createdDate"]),
    createdById: json["createdById"],
    deletedById: json["deletedById"],
    barcode: json["barcode"],
    licenseNumber: json["license_number"],
    plateNumber: json["plate_number"],
    modelYear: json["modelYear"],
    manufacturerEng: json["manufacturer_eng"],
    manufacturerAr: json["manufacturer_ar"],
    type: json["type"],
    capacity: json["capacity"],
    volume: json["volume"],
    active: json["active"],
    photo: json["photo"],
    organization: json["organization"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "createdDate": createdDate?.toIso8601String(),
    "createdById": createdById,
    "deletedById": deletedById,
    "barcode": barcode,
    "license_number": licenseNumber,
    "plate_number": plateNumber,
    "modelYear": modelYear,
    "manufacturer_eng": manufacturerEng,
    "manufacturer_ar": manufacturerAr,
    "type": type,
    "capacity": capacity,
    "volume": volume,
    "active": active,
    "photo": photo,
    "organization": organization,
  };
}

