import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device/AddDevice.dart';
import 'package:flutter/material.dart';

class DevicePage extends StatefulWidget {
  @override
  _DevicePageState createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch device data from Firestore
  Stream<QuerySnapshot> _getDeviceList() {
    return _firestore.collection('Device').snapshots();
  }

  // Toggle device status
  void _toggleDeviceStatus(String deviceId, bool status) async {
    await _firestore.collection('Device').doc(deviceId).update({
      'status': !status,  // Update status (true to false or false to true)
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Device List"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Navigate to AddDevicePage when the + button is clicked
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddDevicePage()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _getDeviceList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final devices = snapshot.data!.docs;

          return ListView.builder(
            itemCount: devices.length,
            itemBuilder: (context, index) {
              var device = devices[index];
              String deviceId = device.id;

              // Safely retrieve the device_name and status fields
              String deviceName = device['device_name'] ?? 'Unnamed Device'; // Default if not found
              bool status = device['status'] ?? false; // Default to false if not found

              return ListTile(
                title: Text(deviceName),
                trailing: Switch(
                  value: status,
                  onChanged: (value) {
                    _toggleDeviceStatus(deviceId, status);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
