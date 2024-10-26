import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/parking_provider.dart' as provider;

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('Dashboard'), // Title of the app
          ],
        ),
        backgroundColor: Color(0xFF789DBC), // Set the AppBar background color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Add padding around the body
        child: Column(
          children: [
            Expanded(
              // Use Expanded to make ListView take remaining space
              child: Consumer<provider.ParkingProvider>(
                builder: (context, provider, child) {
                  // Get all records
                  final records = provider.records;

                  // Sort records: unpaid first, paid last
                  records.sort((a, b) {
                    if (a.isPaid && !b.isPaid) {
                      return 1; // Move paid record to the bottom
                    } else if (!a.isPaid && b.isPaid) {
                      return -1; // Keep unpaid record at the top
                    }
                    return 0; // Keep original order if both are paid or unpaid
                  });

                  return ListView.builder(
                    itemCount: records.length,
                    itemBuilder: (context, index) {
                      final record = records[index];
                      return ListTile(
                        title: Text(
                          '${record.vehicle.type.toUpperCase()} - ${record.vehicle.licensePlate}',
                        ),
                        subtitle: Text('Driver: ${record.vehicle.driverName}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Fee: ₱${record.calculateFee().toStringAsFixed(2)}',
                            ),
                            SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () {
                                provider.markAsPaid(record);
                              },
                              child: Text(record.isPaid ? 'Paid' : 'Unpaid'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    record.isPaid ? Colors.green : Colors.red,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
