import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class EmployeeDatabase {
  static Future<Database> initializeDatabase() async {
    final database = openDatabase(
      join(await getDatabasesPath(), 'employee_database.db'),
      onCreate: (db, version) {
        return db.execute(
          '''
          CREATE TABLE employees(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            employeeName TEXT,
            role TEXT,
            fromDate TEXT,
            toDate TEXT
          )
          ''',
        );
      },
      version: 1,
    );
    return database;
  }

  static Future<void> insertEmployee(Map<String, dynamic> employee) async {
    final Database db = await initializeDatabase();
    await db.insert(
      'employees',
      employee,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> deleteEmployee(int id) async {
    final Database db = await initializeDatabase();
    await db.delete(
      'employees',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<void> updateEmployee(
      int id, Map<String, dynamic> employee) async {
    final Database db = await initializeDatabase();
    await db.update(
      'employees',
      employee,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<List<Map<String, dynamic>>> retrieveEmployees() async {
    final Database db = await initializeDatabase();
    final List<Map<String, dynamic>> employees = await db.query('employees');
    return employees;
  }

  static Future<void> deleteAllEmployees() async {
    final Database db = await initializeDatabase();
    await db.delete('employees');
  }
}
