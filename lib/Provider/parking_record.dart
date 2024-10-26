import 'package:parking_app/Provider/Vehicle.dart';

class ParkingRecord {
  final Vehicle vehicle;
  final DateTime entryTime;
  DateTime? exitTime;
  bool isPaid; // Add this field

  ParkingRecord({
    required this.vehicle,
    required this.entryTime,
    this.exitTime,
    this.isPaid = false, // Default to unpaid
  });

  double calculateFee() {
    final duration = exitTime?.difference(entryTime).inHours ?? 0;
    if (vehicle.type == 'motorcycle') {
      return duration <= 3 ? 20 : 20 + (duration - 3) * 5;
    } else {
      return duration <= 3 ? 30 : 30 + (duration - 3) * 5;
    }
  }
}
