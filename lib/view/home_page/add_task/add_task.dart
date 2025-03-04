import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_one/utils/utils.dart';
import '../../../bloc/image_picker/image_pickerr_bloc.dart';
import '../../../model/task_model.dart';
import '../../../repository/task_repository.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  TextEditingController taskController = TextEditingController();
  TextEditingController descController = TextEditingController();

  bool iscomplete = false;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 1;
    final width = MediaQuery.of(context).size.width * 1;

    return Scaffold(
      floatingActionButton: BlocBuilder<ImagePickerBloc, ImagePickerState>(
        builder: (context, state) {
          return FloatingActionButton(
            onPressed: () async {
              _addTask(state);
            },
            child: Icon(Icons.arrow_forward),
          );
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          spacing: height * 0.07,
          children: [
            SizedBox(height: height * 0.01),
            Text(
              "ADD TASKs",
              style: GoogleFonts.poppins(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                spacing: 20,
                children: [
                  TextFormField(
                    controller: taskController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      hintText: "Add Task",
                    ),
                  ),

                  TextFormField(
                    maxLines: 5,
                    controller: descController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      hintText: "description",
                    ),
                  ),
                  Container(
                    width: width * 0.6,
                    height: height * 0.2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.black),
                    ),
                    child: InkWell(
                      onTap: () {
                        context.read<ImagePickerBloc>().add(
                          PickImageFromGallery(),
                        );
                      },
                      child: BlocBuilder<ImagePickerBloc, ImagePickerState>(
                        builder: (context, state) {
                          return Center(
                            child:
                                state.image == null
                                    ? Icon(Icons.image)
                                    : Container(
                                      height: 300,
                                      width: 300,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Image.file(
                                          File(state.image!.path),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addTask(ImagePickerState state) async {
    try {
      // Check if a user is logged in
      String? userId = await TaskDbHelper.instance.getCurrentUserEmail();
      if (userId == null) {
        // No user logged in, show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("You must be logged in to create a task")),
        );
        return; // Exit the method
      }
      int result = await TaskDbHelper.instance.insertTask(
        TaskModel(
          task: taskController.text,
          desc: descController.text,
          isCompleted: iscomplete,
          image: state.image!.path,
        ),
      );
      if (result == -1) {
        // No user logged in, show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("You must be logged in to create a task")),
        );
        return; // Exit the method
      }
      if (result > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: AwesomeSnackbarContent(
              title: "Task added Successfully",
              message: "This is your task ${taskController.text}",
              contentType: ContentType.success,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Something Went Wrong")));
      }
      context.pop();
      setState(() {});
    } catch (e) {
      print(e);
      Utils().flutterToastMessage(e.toString());
    }
  }
}
