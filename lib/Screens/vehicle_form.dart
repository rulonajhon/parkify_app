import 'package:flutter/material.dart';
import '../Provider/Vehicle.dart'; // Import the Vehicle model
import '../Provider/parking_provider.dart'; // Import the ParkingProvider
import '../Provider/parking_record.dart'; // Ensure this path is correct
import 'package:provider/provider.dart';

class VehicleForm extends StatefulWidget {
  @override
  _VehicleFormState createState() => _VehicleFormState();
}

class _VehicleFormState extends State<VehicleForm> {
  final _formKey = GlobalKey<FormState>();
  String _type = 'car'; // Default vehicle type
  final TextEditingController _driverNameController = TextEditingController();
  final TextEditingController _licensePlateController = TextEditingController();

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Vehicle has been added to the dashboard.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _clearFields() {
    _driverNameController.clear(); // Clear the driver name field
    _licensePlateController.clear(); // Clear the license plate field
    setState(() {
      _type = 'car'; // Reset dropdown to default value
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('Add Vehicle'), // Title of the app
          ],
        ),
        backgroundColor: Color(0xFF789DBC), // Set the AppBar background color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Add padding around the body
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: _type,
                onChanged: (value) {
                  setState(() {
                    _type = value!;
                  });
                },
                items: ['car', 'motorcycle'].map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
              ),
              TextFormField(
                controller: _driverNameController, // Assign controller
                decoration: InputDecoration(labelText: 'Driver Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the driver name';
                  }
                  return null; // Return null if the input is valid
                },
              ),
              TextFormField(
                controller: _licensePlateController, // Assign controller
                decoration: InputDecoration(labelText: 'License Plate'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the license plate';
                  }
                  return null; // Return null if the input is valid
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final vehicle = Vehicle(
                      type: _type,
                      driverName: _driverNameController.text,
                      licensePlate: _licensePlateController.text,
                    );
                    Provider.of<ParkingProvider>(context, listen: false)
                        .addRecord(
                      ParkingRecord(
                        vehicle: vehicle,
                        entryTime: DateTime.now(),
                      ),
                    );

                    _showSuccessDialog(); // Show success message
                    _clearFields(); // Clear the text fields
                  }
                },
                child: Text('Submit'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF789DBC), // Set the button color
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
