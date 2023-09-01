import 'package:flutter/material.dart';
import 'package:registration_app/database.dart';
import 'package:registration_app/registration_page.dart';

class Screen2 extends StatefulWidget {
  const Screen2(
      {super.key,
      required String name,
      required String dob,
      required String email});

  @override
  _Screen2State createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
  final dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> registrations = [];

  @override
  void initState() {
    super.initState();
    _loadRegistrations();
  }

  Future<void> _loadRegistrations() async {
    final data = await dbHelper.getAllRegistrations();
    setState(() {
      registrations = data;
    });
  }

  Future<void> _clearDatabase() async {
    await dbHelper.clearDatabase();
    _loadRegistrations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Registrations:',
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            for (var registration in registrations)
              Card(
                margin: const EdgeInsets.all(16.0),
                elevation: 4.0,
                color: Colors.orange,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Name: ${registration['name']}'),
                      const SizedBox(height: 8.0),
                      Text('Date of Birth: ${registration['dob']}'),
                      const SizedBox(height: 8.0),
                      Text('Email: ${registration['email']}'),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
      backgroundColor: Colors.grey[300],
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const RegistrationPage(),
                ),
              );
            },
            backgroundColor: Colors.deepPurple,
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 16.0),
          FloatingActionButton(
            onPressed: _clearDatabase,
            backgroundColor: Colors.deepPurple,
            child: const Icon(Icons.delete),
          ),
        ],
      ),
    );
  }
}
