import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_one/bloc/obscure_text/obscure_text_bloc.dart';
import 'package:project_one/model/task_model.dart';
import 'package:project_one/repository/task_repository.dart';
import 'package:project_one/resources/images.dart';
import 'package:project_one/resources/router/app_router_path.dart';
import 'package:project_one/resources/style.dart';
import 'package:project_one/view/home_page/edit_todo/edit_todo.dart';
import 'package:project_one/view/home_page/todo_detail_screen.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  final dateTime = DateTime.now();
  late Future<List<TaskModel>> _tasksFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _refreshTasks();
  }

  Future<void> _refreshTasks() async {
    setState(() {
      _tasksFuture = TaskDbHelper.instance.getAllTasks();
    });
  }

  List<String> timeList = [];

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 1;
    final width = MediaQuery.of(context).size.width * 1;
  print(dateTime);
    final time = DateFormat.jm().format(dateTime);
    final formatDateTime = DateFormat.yMMMMEEEEd().format(dateTime);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.pushNamed(AppRouterPath.AddTaskScreen);
        },
        label: Text(
          "Add Task",
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){
            TaskDbHelper.instance.clearUserEmail();
            setState(() {

            });
            context.pushNamed(AppRouterPath.LoginScreen);
          }, icon: Icon(Icons.logout))
        ],
        title: Text("Todo List"),
        centerTitle: true,
        backgroundColor: Color(0xff0AB6AB),
        toolbarHeight: height * 0.1,
      ),
      body: FutureBuilder(
        future: TaskDbHelper.instance.getAllTasks(),
        builder: (context, snapshot) {

          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          }

          else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                SizedBox(
                    width: width * 0.8,
                    child: Image.asset(AppImages.NoTaskImg)),
                    Text("What do you want to do today?",style: AppStyle.homePageStyle),
                    Text('Tap "Add Task" to add your task',style: AppStyle.Grey17),
              ]),
            );
          }
          else {
            return Column(
              spacing: 15,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding:  EdgeInsets.symmetric(horizontal: width * .08),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        formatDateTime,
                        style: TextStyle(color: Color(0xff7D7878)),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * .03),
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final items = snapshot.data![index];
                        return InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => TodoDetailScreen(items: items),
                              ),
                            );
                            SharedPreferences sp = await SharedPreferences.getInstance();
                            final nowTime = timeList.add(time);
                            sp.setString("listOfTime", nowTime as String);
                            setState(() {

                            });
                          },
                          child: Card(
                            child: ListTile(
                              trailing: Row(
                                spacing: 10,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  InkWell(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => EditTodo(items: items),
                                        ),
                                      );
                                    },
                                    child: Icon(Icons.edit),
                                  ),
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
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
