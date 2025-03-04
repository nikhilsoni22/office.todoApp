import 'package:path/path.dart';
import 'package:project_one/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;

import 'package:uuid/uuid.dart';

class DatabaseHelper {
  static const _databaseName = "users.db";
  static const _databaseVersion = 2;
  static const table = "users";

  // Make this a singleton class
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Open the database
  Future<Database> _initDatabase() async {
    io.Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  // Create the table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        phone TEXT NOT NULL,
        password TEXT NOT NULL
      )
    ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print("Upgrading database from version $oldVersion to $newVersion ------------------------------------------>");
    if (oldVersion < newVersion) {
      if (oldVersion < 3) {
        // Add the userEmail column
        await db.execute("ALTER TABLE $table ADD COLUMN userEmail TEXT");
        print("Added userEmail column to user table >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      }
    }
  }

  // Insert a user
  Future<int> insertUser(UserModel user) async {
    Database db = await instance.database;
    return await db.insert('users', user.toMap());
  }

  Future<List<UserModel>> getAllUsers() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('users');
    return List.generate(maps.length, (i) {
      return UserModel.fromMap(maps[i]);
    });
  }

  Future<UserModel?> loginUser(String emailOrPhone, String password) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'email = ? OR phone = ? AND password = ?',
      whereArgs: [emailOrPhone, emailOrPhone, password],
    );
    if (result.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      // Store the user's email in SharedPreferences
      // await prefs.setString('userEmail', result.first['email']);
      print(result.first);
      return UserModel.fromMap(result.first);
    }
    return null;
  }

  Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    await prefs.remove('phone');
    await prefs.remove('name');
    await prefs.remove('password');
    // Remove the userEmail from SharedPreferences
    await prefs.remove('userEmail');
  }
}
