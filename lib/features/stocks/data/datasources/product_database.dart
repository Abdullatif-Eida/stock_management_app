import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../../../../core/constants/app_constants.dart';

class ProductDatabase {
  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, AppConstants.dbName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE ${AppConstants.dbTable} (
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            price REAL NOT NULL,
            stock INTEGER NOT NULL,
            lastUpdated TEXT NOT NULL
          )
        ''');
      },
    );
  }
}