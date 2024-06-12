import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:geolocator/geolocator.dart';
class DatabaseHelper {
  DatabaseHelper._privateConstructor(); // Private constructor for the singleton
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor(); // Singleton instance
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }
  initDB() async {
    final path = await getDatabasesPath();
    return await openDatabase(
      join(path, 'coordinate_database.db'),
      onCreate: (db, version) async {
        await db.execute('''
 CREATE TABLE coordinates(
 id INTEGER PRIMARY KEY AUTOINCREMENT,
 timestamp TEXT,
 latitude REAL,
 longitude REAL,
 userID TEXT
 )
 ''');
      },
      onUpgrade: (db, oldV, newV) async{
        if(oldV < newV){ await db.execute('''ALTER TABLE coordinates ADD COLUMN userID TEXT''');}
      },
      version: 3,
    );
  }
  Future<void> insertCoordinate(Position position, String userID) async {
    final db = await database;
    await db.insert('coordinates', {
      'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
      'latitude': position.latitude,
      'longitude': position.longitude,
      'userID': userID
    });
  }

  Future<List<Map<String, dynamic>>> getCoordinates(String userID) async {
    final db = await database;
    const String sql = "SELECT * FROM coordinates WHERE userID=?";
    return await db.rawQuery(sql,[userID]);
  }

  Future<void> updateCoordinate(String timestamp, String newLat, String newLong) async {
    final db = await database;
    await db.update(
      'coordinates',
      {'latitude': newLat, 'longitude': newLong},
      where: 'timestamp = ?',
      whereArgs: [timestamp],
    );
  }

  Future<void> deleteCoordinate(String timestamp) async {
    final db = await database;
    await db.delete(
      'coordinates',
      where: 'timestamp = ?',
      whereArgs: [timestamp],
    );
  }

}