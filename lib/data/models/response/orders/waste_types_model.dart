// To parse this JSON data, do
//
//     final incidentTypesModel = incidentTypesModelFromJson(jsonString);

import 'dart:convert';

WasteTypesModel wasteTypesModelFromJson(String str) =>
    WasteTypesModel.fromJson(json.decode(str));

String wasteTypesModelToJson(WasteTypesModel data) =>
    json.encode(data.toJson());

class WasteTypesModel {
  WasteTypesModel({
    this.wasteTypes,
  });

  List<WasteType>? wasteTypes;

  factory WasteTypesModel.fromJson(List<dynamic> json) => WasteTypesModel(
        wasteTypes: json.isEmpty
            ? []
            : List<WasteType>.from(json.map((x) => WasteType.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "wasteTypes": wasteTypes == null
            ? []
            : List<dynamic>.from(wasteTypes!.map((x) => x.toJson())),
      };
}

class WasteType {
  WasteType({
    this.id,
    this.name,
  });

  String? id;
  String? name;

  factory WasteType.fromJson(Map<String, dynamic> json) => WasteType(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
