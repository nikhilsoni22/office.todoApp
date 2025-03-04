import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_one/model/task_model.dart';
import 'package:project_one/resources/router/app_router_path.dart';
import 'package:project_one/resources/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../repository/task_repository.dart';

class TodoDetailScreen extends StatefulWidget {
  TaskModel items;

  TodoDetailScreen({super.key, required this.items});

  @override
  State<TodoDetailScreen> createState() => _TodoDetailScreenState();
}

class _TodoDetailScreenState extends State<TodoDetailScreen> {

  final List<String> genderItems = [
    'important',
    'default',
    'urgent',
  ];

  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 1;
    final width = MediaQuery.of(context).size.width * 1;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Icon(Icons.cancel),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Checkbox(value: false, onChanged: (value) {}),
              Text(
                widget.items.task,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width * .13),
            child: Text(
              widget.items.desc,
              style: GoogleFonts.poppins(fontSize: 17, color: Colors.grey),
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: width * .03, vertical: height * 0.05),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.outlined_flag_outlined),
                    Text("Task Priority:",style: AppStyle.defaultStyle),
                  ],
                ),
                SizedBox(
                  width: width * 0.37,
                  child: DropdownButtonFormField2<String>(
                    isExpanded: true,
                    decoration: InputDecoration(
                      // Add Horizontal padding using menuItemStyleData.padding so it matches
                      // the menu padding when button's width is not specified.
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      // Add more decoration..
                    ),
                    hint: const Text(
                      'select Prioty',
                      style: TextStyle(fontSize: 14),
                    ),
                    items: genderItems
                        .map((item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ))
                        .toList(),
                    onChanged: (value) {
                      //Do something when selected item is changed.
                    },
                    onSaved: (value) {
                      selectedValue = value.toString();
                    },
                    buttonStyleData: const ButtonStyleData(
                      padding: EdgeInsets.only(right: 8),
                    ),
                    iconStyleData: const IconStyleData(
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black45,
                      ),
                      iconSize: 24,
                    ),
                    dropdownStyleData: DropdownStyleData(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: width * .1,
              vertical: height * 0.03,
            ),
            child: Container(
              height: height * 0.2,
              width: width * 0.4,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.file(File(widget.items.image), fit: BoxFit.cover),
              ),
            ),
          ),
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              _deleteTask();
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: width * .09),
              child: Row(
                children: [
                  Icon(
                    Icons.delete_outline_outlined,
                    color: Colors.red,
                    size: 22,
                  ),
                  Text(
                    "Delete Task",
                    style: GoogleFonts.poppins(color: Colors.red, fontSize: 22),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _deleteTask(){
    setState(() {
      TaskDbHelper.instance.deleteTask(widget.items.id!);
    });
    context.go(AppRouterPath.TodoScreen);
  }

}
