import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddDevicePage extends StatefulWidget {
  @override
  _AddDevicePageState createState() => _AddDevicePageState();
}

class _AddDevicePageState extends State<AddDevicePage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _deviceNameController = TextEditingController();
  bool _status = false;

  // Firebase instance
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to add the device to Firestore
  void _addDevice() async {
    String deviceName = _deviceNameController.text.trim();
    if (deviceName.isEmpty) {
      // Show an error if the device name is empty
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Device name cannot be empty."),
      ));
      return;
    }

    try {
      // Add a new document to Firestore
      await _firestore.collection('Device').add({
        'device_name': deviceName,
        'status': _status,  // true or false
      });

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Device added successfully!"),
      ));

      // Clear the form
      _deviceNameController.clear();
      setState(() {
        _status = false;
      });
    } catch (e) {
      // Handle any errors
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error adding device: $e"),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Device"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Device name input
              TextFormField(
                controller: _deviceNameController,
                decoration: InputDecoration(labelText: 'Device Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a device name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              // Device status toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Status"),
                  Switch(
                    value: _status,
                    onChanged: (value) {
                      setState(() {
                        _status = value;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Submit button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _addDevice();
                  }
                },
                child: Text('Add Device'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
