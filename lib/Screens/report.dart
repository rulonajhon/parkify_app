import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/parking_provider.dart';

class Report extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            // Optionally, you can add a logo here as well
            // Image.asset(
            //   'assets/your_logo.png', // Replace with your logo path
            //   height: 40,
            // ),
            // SizedBox(width: 10), // Space between logo and title
            Text('Generate Report'), // Title of the app
          ],
        ),
        backgroundColor: Color(0xFF789DBC), // Set the AppBar background color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Add padding around the body
        child: Center( // Center the entire body content
          child: Consumer<ParkingProvider>(
            builder: (context, provider, child) {
              final totalRevenue = provider.getTotalRevenue();
              final totalUnpaid = provider.getTotalUnpaid();
              return Column(
                mainAxisAlignment: MainAxisAlignment.center, // Center items in the column
                children: [
                  Text(
                    'Total Revenue: ₱${totalRevenue.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 24),
                    textAlign: TextAlign.center, // Center the text
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Total Unpaid Fees: ₱${totalUnpaid.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 24),
                    textAlign: TextAlign.center, // Center the text
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
