import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';
  bool _isAuthenticated = false;

  void _login() {
    if (_username == 'admin' && _password == 'admin123') {
      setState(() {
        _isAuthenticated = true;
      });
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Invalid Credentials'),
            content: Text('Please check your username and password.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFE3E3), // Set the background color
      appBar: AppBar(
        backgroundColor: Color(0xFF789DBC), // Set the AppBar background color
        title: Row(
          children: [
            Image.asset(
              'lib/assets/parkify_logo2.png', // Path to your logo
              height: 40, // Adjust the height as needed
            ),
            SizedBox(width: 10), // Space between logo and title
            Padding(
              padding: const EdgeInsets.only(right: 16.0), // Add right padding
              child: Text('Parkify App'), // Title of the app
            ), // Title of the app
          ],
        ),
      ),
      body: SingleChildScrollView(
        // Allow scrolling
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Add the Parkify logo in the body (optional)
              Image.asset(
                'lib/assets/parkify_logo.png', // Path to your logo
                height: 250, // Adjust the height as needed
              ),
              SizedBox(height: 20), // Space between logo and form
              TextFormField(
                decoration: InputDecoration(labelText: 'Username'),
                onChanged: (value) {
                  _username = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                onChanged: (value) {
                  _password = value;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF789DBC), // Set the button color
                  foregroundColor: Colors.white,
                ),
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
