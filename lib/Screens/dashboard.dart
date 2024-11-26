import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/parking_provider.dart' as provider;

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isSearchVisible = false; // Controls the visibility of the search bar

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'), // Title without the logo
        backgroundColor: Color(0xFF789DBC),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              setState(() {
                _isSearchVisible =
                    !_isSearchVisible; // Toggle search visibility
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Show search bar only when _isSearchVisible is true
            if (_isSearchVisible)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Search by Driver Name or License Plate',
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _isSearchVisible =
                              false; // Hide the search bar when 'X' is clicked
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),

            // Use Expanded to make ListView take the remaining space
            Expanded(
              child: Consumer<provider.ParkingProvider>(
                builder: (context, provider, child) {
                  // Get all records and filter them based on the search query
                  final filteredRecords = provider.records.where((record) {
                    final driverName = record.vehicle.driverName.toLowerCase();
                    final licensePlate =
                        record.vehicle.licensePlate.toLowerCase();
                    return driverName.contains(_searchQuery) ||
                        licensePlate.contains(_searchQuery);
                  }).toList();

                  // Sort records: unpaid first, paid last
                  filteredRecords.sort((a, b) {
                    if (a.isPaid && !b.isPaid) return 1;
                    if (!a.isPaid && b.isPaid) return -1;
                    return 0;
                  });

                  // If no records are found, show a message
                  if (filteredRecords.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'No vehicles found.',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  }

                  // Return the list of filtered vehicles
                  return ListView.builder(
                    itemCount: filteredRecords.length,
                    itemBuilder: (context, index) {
                      final record = filteredRecords[index];
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
