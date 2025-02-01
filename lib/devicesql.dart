class Device {
  final int? id;
  final String deviceName;
  final bool status;

  Device({this.id, required this.deviceName, required this.status});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'device_name': deviceName,
      'status': status ? 1 : 0, // SQLite stores booleans as 1 or 0
    };
  }

  factory Device.fromMap(Map<String, dynamic> map) {
    return Device(
      id: map['id'],
      deviceName: map['device_name'],
      status: map['status'] == 1, // Convert 1 or 0 to boolean
    );
  }
}
