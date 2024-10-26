import 'package:flutter/material.dart';
import 'parking_record.dart';

class ParkingProvider with ChangeNotifier {
  final List<ParkingRecord> _records = [];

  void addRecord(ParkingRecord record) {
    _records.add(record);
    notifyListeners();
  }

  void markAsPaid(ParkingRecord record) {
    record.isPaid = true;
    notifyListeners();
  }

  List<ParkingRecord> get records => _records;

  double getTotalRevenue() {
    return _records
        .where((record) => record.isPaid)
        .fold(0, (sum, record) => sum + record.calculateFee());
  }

  double getTotalUnpaid() {
    return _records
        .where((record) => !record.isPaid)
        .fold(0, (sum, record) => sum + record.calculateFee());
  }
}
