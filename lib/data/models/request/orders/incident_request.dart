

/// username : "ahmed"
/// password : "12346"
library;

class IncidentRequest {
  String? stopId;
  String? lat;
  String? lng;
  String? isMock;
  String? material;
  String? finalWeightInKg;
  String? stopStatusId;

  IncidentRequest({
    this.stopId,
    this.lat,
    this.lng,
    this.isMock,
    this.finalWeightInKg,
    this.stopStatusId,
    this.material,
  });

  IncidentRequest.fromJson(Map<String, dynamic> json) {
    if (json['destination_id'] != null) {
      stopId = json['destination_id'];
    }
    finalWeightInKg = json['weight'];
    material = json['material'];
    isMock = json['isMock'];
    lat = json['lat'];
    lng = json['lng'];
    stopStatusId = json['stop_status_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (stopId != null) {
      data['destination_id'] = stopId;
    }
    data['lat'] = lat;
    data['weight'] = finalWeightInKg;
    data['lng'] = lng;
    data['stop_status_id'] = stopStatusId;
    data['isMock'] = isMock;
    data['material'] = material;

    return data;
  }
}
