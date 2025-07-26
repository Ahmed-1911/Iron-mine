import 'package:image_picker/image_picker.dart';

class ReceiveVehicleLoadRequest {
  String bagsCount;
  String destinationId;
  XFile photo;
  String lat;
  String lng;

  ReceiveVehicleLoadRequest({
    required this.bagsCount,
    required this.destinationId,
    required this.lat,
    required this.lng,
    required this.photo,
  });

  toJson() => {
        "bagsCount": bagsCount,
        "destination_id": destinationId,
        "lat": lat,
        "lng": lng,
      };
}
