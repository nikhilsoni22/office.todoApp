import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:project_one/model/task_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class TaskDbHelper {
  TaskDbHelper._privaterConstructor();

  static final TaskDbHelper instance = TaskDbHelper._privaterConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    io.Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "AddTask_db");
    return await openDatabase(
      path,
      version: 3,
      onCreate: _onCreate,
     // onUpgrade: _onUpgrade,
    );
  }

  Future _onCreate(Database db, int version) async {
    // Create the task table

    SharedPreferences sp = await SharedPreferences.getInstance();
    await db.execute('''
      CREATE TABLE ${sp.getString("userEmail")} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId TEXT,
        task TEXT,
        desc TEXT,
        isCompleted INTEGER,
        image TEXT
      )
    ''');
  }

  // Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
  //   print(
  //     "Upgrading database from version $oldVersion to $newVersion ------------------------------------------>",
  //   );
  //   if (oldVersion < newVersion) {
  //     if (oldVersion < 2) {
  //       // Add the userId column
  //       await db.execute("ALTER TABLE task ADD COLUMN userId TEXT");
  //       print(
  //         "Added userId column to task table >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>",
  //       );
  //     }
  //     if (oldVersion < 3) {
  //       // Rename the userId column to userEmail
  //       await db.execute("ALTER TABLE task RENAME COLUMN userId TO userEmail");
  //       print(
  //         "Renamed userId column to userEmail in task table >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>",
  //       );
  //     }
  //   }
  // }

  Future<String?> getCurrentUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    String? userEmail = prefs.getString('userEmail');
    return userEmail;
  }

  Future<void> clearUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userEmail');
  }

  Future<void> deleteDatabase() async {
    io.Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "AddTask_db");
    io.File dbFile = io.File(path);
    if (await dbFile.exists()) {
      await dbFile.delete();
      print("Database file deleted: $path");
    } else {
      print("Database file not found: $path");
    }
  }

  Future<int> insertTask(TaskModel taskModel) async {
    Database db = await instance.database;
    String? userEmail = await getCurrentUserEmail();
    if (userEmail == null) {
      return -1; // No user logged in
    }
    Map<String, dynamic> taskMap = taskModel.toMap();
    taskMap['userEmail'] = userEmail;
    return await db.insert("task", taskMap);
  }

  Future<List<TaskModel>> getAllTasks() async {
    Database db = await instance.database;
    String? userEmail = await getCurrentUserEmail();
    if (userEmail == null) {
      return [];
    }
    var tasks = await db.query(
      "task",
      where: 'userEmail = ?',
      whereArgs: [userEmail],
    );
    List<TaskModel> taskList =
        tasks.isNotEmpty ? tasks.map((e) => TaskModel.fromMap(e)).toList() : [];
    return taskList;
  }

  Future<List<TaskModel>> deleteTask(int id) async {
    Database db = await instance.database;
    String? userEmail = await getCurrentUserEmail();
    if (userEmail == null) {
      return []; // No user logged in, return empty list
    }
    await db.delete(
      "task",
      where: 'id = ? AND userEmail = ?',
      whereArgs: [id, userEmail],
    );
    return await getAllTasks();
  }

  Future<List<TaskModel>> updateTask(TaskModel taskModel) async {
    Database db = await instance.database;
    String? userEmail = await getCurrentUserEmail();
    if (userEmail == null) {
      return []; // No user logged in, return empty list
    }
    await db.update(
      "task",
      taskModel.toMap(),
      where: 'id = ? AND userEmail = ?',
      whereArgs: [taskModel.id, userEmail],
    );
    return await getAllTasks();
  }
}
