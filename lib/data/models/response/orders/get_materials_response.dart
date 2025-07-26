// To parse this JSON data, do
//
//     final getMaterialsResponse = getMaterialsResponseFromJson(jsonString);

import 'dart:convert';

GetMaterialsResponse getMaterialsResponseFromJson(String str) =>
    GetMaterialsResponse.fromJson(json.decode(str));

String getMaterialsResponseToJson(GetMaterialsResponse data) =>
    json.encode(data.toJson());

class GetMaterialsResponse {
  List<MatrialItem>? materialItems;

  GetMaterialsResponse({
    this.materialItems,
  });

  factory GetMaterialsResponse.fromJson(Map<String, dynamic> json) =>
      GetMaterialsResponse(
        materialItems: json["items"] == null
            ? []
            : List<MatrialItem>.from(
                json["items"]!.map((x) => MatrialItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "items": materialItems == null
            ? []
            : List<dynamic>.from(materialItems!.map((x) => x.toJson())),
      };
}

class MatrialItem {
  String? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? material;
  double? weight;
  String? stopStatusId;
  String? destinationId;

  MatrialItem({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.material,
    this.weight,
    this.stopStatusId,
    this.destinationId,
  });

  factory MatrialItem.fromJson(Map<String, dynamic> json) => MatrialItem(
        id: json["id"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        material: json["material"],
        weight: json["weight"]?.toDouble(),
        stopStatusId: json["stop_status_id"],
        destinationId: json["destination_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "material": material,
        "weight": weight,
        "stop_status_id": stopStatusId,
        "destination_id": destinationId,
      };
}
