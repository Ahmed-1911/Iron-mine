class GetZoneListResponse {
  List<ZoneModel>? zonesList;
  int? totalCount;

  GetZoneListResponse({
    this.zonesList,
    this.totalCount,
  });

  factory GetZoneListResponse.fromJson(Map<String, dynamic> json) =>
      GetZoneListResponse(
        zonesList: json["items"] == null
            ? []
            : List<ZoneModel>.from(json["items"]!.map((x) => ZoneModel.fromJson(x))),
        totalCount: json["totalCount"],
      );

  Map<String, dynamic> toJson() => {
        "items": zonesList == null
            ? []
            : List<dynamic>.from(zonesList!.map((x) => x.toJson())),
        "totalCount": totalCount,
      };
}

class ZoneModel {
  String? id;
  int? incId;
  bool? verified;
  DateTime? createdAt;
  String? name;

  ZoneModel({
    this.id,
    this.incId,
    this.name,
    this.verified,
    this.createdAt,
  });

  factory ZoneModel.fromJson(Map<String, dynamic> json) => ZoneModel(
    id: json["id"],
    incId: json["inc_id"],
    name: json["name"],
    verified: json["verified"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "inc_id": incId,
    "name": name,
    "verified": verified,
    "created_at": createdAt?.toIso8601String(),
  };
}