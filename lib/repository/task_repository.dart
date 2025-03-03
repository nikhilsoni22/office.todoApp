import 'dart:io' as io;

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:project_one/model/task_model.dart';
import 'package:sqflite/sqflite.dart';

class TaskDbHelper {
  TaskDbHelper._privaterConstructor();
  static final TaskDbHelper instance = TaskDbHelper._privaterConstructor();

  static Database? _database;
  Future<Database> get database async {
    if(_database != null) return _database!;
      _database = await _initDatabase();
    return _database!;
  }

  _initDatabase()async{
    io.Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "AddTask_db");
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version)async{
    await db.execute("CREATE TABLE task(id INTEGER PRIMARY KEY AUTOINCREMENT, task TEXT, desc TEXT, isCompleted INTEGER, image TEXT)");
  }

  Future<int> insertUser(TaskModel taskModel) async {
    Database db = await instance.database;
    return await db.insert("task", taskModel.toMap());
  }

  Future<List<TaskModel>> getAllUsers()async{
    Database db = await instance.database;
    var users = await db.query("task");
    List<TaskModel> userList = users.isNotEmpty ? users.map((e) => TaskModel.fromMap(e)).toList() : [];
    return userList;
  }

  Future<List<TaskModel>> deleteTask(int id)async{
    Database db = await instance.database;
    await db.delete("task", where: "id = ?", whereArgs: [id]);
    return await getAllUsers();
  }

  Future<List<TaskModel>> updateTask(TaskModel taskModel)async{
    Database db = await instance.database;
    await db.update("task", taskModel.toMap(), where: "id = ?", whereArgs: [taskModel.id]);
    return await getAllUsers();
  }
}