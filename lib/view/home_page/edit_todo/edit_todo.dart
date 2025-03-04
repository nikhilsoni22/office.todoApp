import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../bloc/image_picker/image_pickerr_bloc.dart';
import '../../../model/task_model.dart';
import '../../../repository/task_repository.dart';

class EditTodo extends StatefulWidget {
 final TaskModel items;
  EditTodo({super.key,
      required this.items,
  });

  @override
  State<EditTodo> createState() => _EditTodoState();
}

class _EditTodoState extends State<EditTodo> {

  bool isComplete = false;
  late String updatedTask;
  late String updatedDesc;

  @override
  void initState() {
    // TODO: implement initState
    updatedTask = widget.items.task;
    updatedDesc = widget.items.desc;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final height = MediaQuery.of(context).size.height * 1;
    final width = MediaQuery.of(context).size.width * 1;

    return Scaffold(
      floatingActionButton: BlocBuilder<ImagePickerBloc, ImagePickerState>(
          builder: (context, state) {
        return FloatingActionButton(onPressed: (){
          setState(() {});
          TaskDbHelper.instance.updateTask(
              TaskModel(
                  id: widget.items.id,
                  task: updatedTask,
                  desc: updatedDesc,
                  isCompleted: isComplete,
                  image: state.image?.path ?? widget.items.image)).then((value) {
            return Navigator.pop(context);

          }).onError((error, stackTrace) {
            print("${error}-------------------------> this is error");
          });
        }, child: Icon(Icons.edit));
      }),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text("EDIT YOUR TODO....",style: GoogleFonts.acme(fontSize: 35,fontWeight: FontWeight.bold)),
            TextFormField(
              initialValue: widget.items.task,
              onChanged: (value) {
                setState(() {
                  updatedTask = value;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    20,
                  ),
                ),
              ),
            ),
            SizedBox(height: height * 0.02),
            TextFormField(
              initialValue: widget.items.desc,
              onChanged: (value) {
                updatedDesc = value;
                setState(() {
        
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    20,
                  ),
                ),
              ),
            ),
            SizedBox(height: height * 0.02),
            InkWell(
              onTap: () {
                context.read<ImagePickerBloc>().add(
                  PickImageFromGallery(),
                );
              },
              child: Container(
                width: width * 0.8,
                height: height * 0.2,
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(
                    15,
                  ),
                ),
                child: BlocBuilder<ImagePickerBloc, ImagePickerState>(
                  builder: (context, state) {
                    return ClipRRect(
                      borderRadius:
                      BorderRadius.circular(15),
                      child:
                      state.image == null
                          ? Image.file(
                        File(widget.items.image),fit: BoxFit.cover,
                      )
                          : Image.file(
                        File(
                          state.image!.path,
                        ),fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
