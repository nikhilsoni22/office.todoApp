import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

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
                  BlocBuilder<ImagePickerBloc, ImagePickerState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed: () async {
                          setState(() {});
                          int result = await TaskDbHelper.instance.insertUser(
                            TaskModel(
                              task: taskController.text,
                              desc: descController.text,
                              isCompleted: iscomplete,
                              image: state.image!.path,
                            ),
                          );
                          if (result > 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: AwesomeSnackbarContent(
                                  title: "Task added Successfully",
                                  message:
                                      "This is your task ${taskController.text}",
                                  contentType: ContentType.success,
                                ),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Something Went Wrong")),
                            );
                          }
                          Navigator.pop(context);
                        },
                        child: Text("Add"),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
