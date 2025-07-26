class GetStorageQualityTicketsResponse {
  List<StorageQualityTicketModel>? ticketsList;
  int? totalCount;

  GetStorageQualityTicketsResponse({
    this.ticketsList,
    this.totalCount,
  });

  factory GetStorageQualityTicketsResponse.fromJson(Map<String, dynamic> json) =>
      GetStorageQualityTicketsResponse(
        ticketsList: json["items"] == null
            ? []
            : List<StorageQualityTicketModel>.from(json["items"]!.map((x) => StorageQualityTicketModel.fromJson(x))),
        totalCount: json["totalCount"],
      );

  Map<String, dynamic> toJson() => {
        "items": ticketsList == null
            ? []
            : List<dynamic>.from(ticketsList!.map((x) => x.toJson())),
        "totalCount": totalCount,
      };
}

class StorageQualityTicketModel {
  String? id;
  String? name;
  String? extractionQualityStatus;
  String? storageQualityStatus;
  int? incId;
  DateTime? createdAt;
  Zone? zone;

  StorageQualityTicketModel({
    this.id,
    this.name,
    this.extractionQualityStatus,
    this.storageQualityStatus,
    this.incId,
    this.createdAt,
    this.zone,
  });

  factory StorageQualityTicketModel.fromJson(Map<String, dynamic> json) =>
      StorageQualityTicketModel(
        id: json["id"],
        name: json["name"],
        incId: json["inc_id"],
        extractionQualityStatus:json["extraction_quality_status"],
        storageQualityStatus:json["storage_quality_status"],
        zone: json["zone"] == null ? null : Zone.fromJson(json["zone"]),
        createdAt: json["created_at"] == null ? null : DateTime.parse(
            json["created_at"]),
      );

  Map<String, dynamic> toJson() =>
      {
        "id": id,
        "name":name,
        "extraction_quality_status":extractionQualityStatus,
        "storage_quality_status":storageQualityStatus,
        "inc_id": incId,
        "created_at": createdAt?.toIso8601String(),
        "zone": zone?.toJson(),
      };
}

class Zone {
  String? id;
  String? name;
  int? incId;

  Zone({
    this.id,
    this.incId,
    this.name,
  });

  factory Zone.fromJson(Map<String, dynamic> json) => Zone(
    id: json["id"],
    incId: json["inc_id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "inc_id": incId,
    "name": name,
  };
}
