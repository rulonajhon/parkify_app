import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';
  String _storedPassword = 'admin123'; // Default password
  bool _isAuthenticated = false;

  // Unchangeable admin code
  final String adminCode = 'ADMIN2024';

  @override
  void initState() {
    super.initState();
    _loadStoredPassword();
  }

  // Load stored password from SharedPreferences
  Future<void> _loadStoredPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _storedPassword = prefs.getString('password') ?? 'admin123';
    });
  }

  // Save new password to SharedPreferences
  Future<void> _saveNewPassword(String newPassword) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('password', newPassword);
    setState(() {
      _storedPassword = newPassword;
    });
  }

  void _login() {
    if (_username == 'admin' && _password == _storedPassword) {
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

  void _showForgotPasswordDialog() {
    final TextEditingController adminCodeController = TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Forgot Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: adminCodeController,
                decoration: InputDecoration(labelText: 'Enter Admin Code'),
                obscureText: true,
              ),
              TextFormField(
                controller: newPasswordController,
                decoration: InputDecoration(labelText: 'Enter New Password'),
                obscureText: true,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Submit'),
              onPressed: () {
                if (adminCodeController.text == adminCode) {
                  _saveNewPassword(newPasswordController.text);
                  Navigator.of(context).pop(); // Close the dialog
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Password Reset'),
                        content:
                            Text('Your password has been reset successfully.'),
                        actions: [
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Incorrect Admin Code'),
                        content: Text('The admin code entered is incorrect.'),
                        actions: [
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
          ],
        );
      },
    );
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
            ),
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
              TextButton(
                onPressed: _showForgotPasswordDialog,
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(color: Colors.blueAccent),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
