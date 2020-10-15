import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const databaseName = 'app.db';

  static Future<Database> _database;

  static Future<Database> get database {
    if (_database == null) {
      _database =
          openDatabase(databaseName, version: 1, onCreate: (db, version) async {
        await db.transaction((txn) async {
          await txn.execute(
              'CREATE TABLE spelling (id INTEGER PRIMARY KEY NOT NULL, title TEXT NOT NULL, language TEXT NOT NULL, date INTEGER NOT NULL)');
          await txn.execute(
              'CREATE TABLE vocabulary (id INTEGER PRIMARY KEY NOT NULL, vocabulary TEXT NOT NULL, spelling_id INTEGER NOT NULL)');
        });
      });
    }
    return _database;
  }
}
