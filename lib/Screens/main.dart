import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'vehicle_form.dart'; // Import the VehicleForm widget
import 'dashboard.dart'; // Import the Dashboard widget
import 'report.dart'; // Import the Report widget
import '../Provider/parking_provider.dart'; // Import the ParkingProvider
import 'login_screen.dart'; // Import the LoginScreen widget

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ParkingProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parkify App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    VehicleForm(),
    Dashboard(),
    Report(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _logout() {
    // Handle logout functionality here
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Parkify App'),
      ),
      body: Column(
        children: [
          Expanded(
            child: _widgetOptions.elementAt(_selectedIndex),
          ), // Use Expanded to take available space
          Padding(
            padding: const EdgeInsets.only(
                bottom: 8.0), // Add padding to avoid overflow
            child: BottomAppBar(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _onItemTapped(0); // Add Vehicle
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add),
                        Text('Add'),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _onItemTapped(1); // Dashboard
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.dashboard),
                        Text('Dashboard'),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _onItemTapped(2); // Generate Report
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.report),
                        Text('Report'),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _logout,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.logout),
                        Text('Logout'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
