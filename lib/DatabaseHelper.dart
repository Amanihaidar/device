import 'package:device/devicesql.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();
  static Database? _database;

  DatabaseHelper._instance();

  Future<Database> get db async {
    _database ??= await initDb();
    return _database!;
  }

  Future<Database> initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'devices.db'); // Updated DB name for devices

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    // Create devices table
    await db.execute(''' 
      CREATE TABLE devices (
        id INTEGER PRIMARY KEY,
        device_name TEXT,
        status INTEGER
      )
    ''');
  }

  // Devices CRUD operations
  Future<int> insertDevice(Device device) async {
    Database db = await instance.db;
    return await db.insert('devices', device.toMap());
  }

  Future<List<Device>> queryAllDevices() async {
    Database db = await instance.db;
    final List<Map<String, dynamic>> maps = await db.query('devices');

    // Convert the List<Map<String, dynamic>> to List<Device>
    return List.generate(maps.length, (i) {
      return Device.fromMap(maps[i]);
    });
  }

  Future<int> updateDevice(Device device) async {
    Database db = await instance.db;
    return await db.update('devices', device.toMap(), where: 'id = ?', whereArgs: [device.id]);
  }

  Future<int> deleteDevice(int id) async {
    Database db = await instance.db;
    return await db.delete('devices', where: 'id = ?', whereArgs: [id]);
  }

  // Initialize Devices (you can call this method when needed to add sample devices)
  Future<void> initializeDevices() async {
    List<Device> devicesToAdd = [
      Device(deviceName: 'Device A', status: true),
      Device(deviceName: 'Device B', status: false),
      Device(deviceName: 'Device C', status: true),
    ];

    for (Device device in devicesToAdd) {
      await insertDevice(device);
    }
  }
}
