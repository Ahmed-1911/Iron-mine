class GetTicketsResponse {
  List<TicketModel>? ticketsList;
  int? totalCount;

  GetTicketsResponse({
    this.ticketsList,
    this.totalCount,
  });

  factory GetTicketsResponse.fromJson(Map<String, dynamic> json) =>
      GetTicketsResponse(
        ticketsList: json["items"] == null
            ? []
            : List<TicketModel>.from(json["items"]!.map((x) => TicketModel.fromJson(x))),
        totalCount: json["totalCount"],
      );

  Map<String, dynamic> toJson() => {
        "items": ticketsList == null
            ? []
            : List<dynamic>.from(ticketsList!.map((x) => x.toJson())),
        "totalCount": totalCount,
      };
}

class TicketModel {
  String? id;
  DateTime? createdDate;
  String? ticketType;
  String? qualityStatus;
  DateTime? startDate;
  int? incrementId;
  Lot? zone;
  Lot? lot;
  Vehicle? vehicle;
  dynamic tracedAmount;

  TicketModel({
    this.id,
    this.createdDate,
    this.ticketType,
    this.qualityStatus,
    this.startDate,
    this.incrementId,
    this.zone,
    this.lot,
    this.vehicle,
    this.tracedAmount,
  });

  factory TicketModel.fromJson(Map<String, dynamic> json) => TicketModel(
    id: json["id"],
    createdDate: json["createdDate"] == null ? null : DateTime.parse(json["createdDate"]),
    ticketType: json["ticket_type"],
    qualityStatus: json["quality_status"],
    startDate: json["startDate"] == null ? null : DateTime.parse(json["startDate"]),
    incrementId: json["incrementId"],
    zone: json["zone"] == null ? null : Lot.fromJson(json["zone"]),
    lot: json["lot"] == null ? null : Lot.fromJson(json["lot"]),
    vehicle: json["vehicle"] == null ? null : Vehicle.fromJson(json["vehicle"]),
    tracedAmount: json["tracedAmount"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "createdDate": createdDate?.toIso8601String(),
    "ticket_type": ticketType,
    "quality_status": qualityStatus,
    "startDate": startDate?.toIso8601String(),
    "incrementId": incrementId,
    "zone": zone?.toJson(),
    "lot": lot?.toJson(),
    "vehicle": vehicle?.toJson(),
    "tracedAmount": tracedAmount,
  };
}

class Lot {
  String? id;
  int? incId;
  String? name;

  Lot({
    this.id,
    this.incId,
    this.name,
  });

  factory Lot.fromJson(Map<String, dynamic> json) => Lot(
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

class Vehicle {
  String? id;
  String? plateNumber;

  Vehicle({
    this.id,
    this.plateNumber,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
    id: json["id"],
    plateNumber: json["plate_number"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "plate_number": plateNumber,
  };
}
