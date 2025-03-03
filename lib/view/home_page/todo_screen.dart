import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_one/bloc/image_picker/image_pickerr_bloc.dart';
import 'package:project_one/bloc/obscure_text/obscure_text_bloc.dart';
import 'package:project_one/model/task_model.dart';
import 'package:project_one/repository/task_repository.dart';
import 'package:project_one/view/home_page/add_task/add_task.dart';
import 'package:project_one/view/home_page/edit_todo/edit_todo.dart';
import 'package:project_one/view/home_page/todo_detail_screen.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  bool iscomplete = false;

  TextEditingController taskController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController taskEditController = TextEditingController();

  late Future<List<TaskModel>> _tasksFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _refreshTasks();
  }

  Future<void> _refreshTasks() async {
    setState(() {
      _tasksFuture = TaskDbHelper.instance.getAllUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 1;
    final width = MediaQuery.of(context).size.width * 1;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          setState(() {

          });
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddTask()));
        },
        label: Text(
          "Add Task",
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: Color(0xff151515),
      appBar: AppBar(
        title: Text("Todo List"),
        centerTitle: true,
        backgroundColor: Color(0xff0AB6AB),
        toolbarHeight: height * 0.1,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: height * 0.05,
              left: width * 0.04,
              bottom: height * 0.04,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Today",
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
                Text(
                  "march 4 2025",
                  style: TextStyle(color: Color(0xff7D7878)),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: TaskDbHelper.instance.getAllUsers(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text("No tasks found"));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final items = snapshot.data![index];
                      return InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => TodoDetailScreen(items: items),
                            ),
                          );
                        },
                        child: Card(
                          color: Color(0xff201F1F),
                          child: ListTile(
                            trailing: Row(
                              spacing: 10,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => EditTodo(items: items,)));
                                    },
                                    child: Icon(Icons.edit)),
                                InkWell(
                                  onTap: () {
                                    TaskDbHelper.instance.deleteTask(items.id!);
                                    setState(() {});
                                  },
                                  child: Icon(Icons.cancel_outlined),
                                ),
                              ],
                            ),
                            leading:
                                BlocBuilder<ObscureTextBloc, ObscureTextState>(
                                  builder: (context, state) {
                                    return Checkbox(
                                      checkColor: Color(0xff7A7777),
                                      shape: CircleBorder(
                                        side: BorderSide(color: Colors.teal),
                                      ),
                                      value: items.isCompleted,
                                      onChanged: (value) {},
                                    );
                                  },
                                ),
                            title: Text(
                              items.task,
                              style: TextStyle(
                                color: Color(0xffF5F5F5),
                                // decoration: TextDecoration.lineThrough,
                                // decorationColor: Color(0xffF5F5F5),
                                // decorationThickness: 2,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
