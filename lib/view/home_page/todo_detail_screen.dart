import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_one/model/task_model.dart';

class TodoDetailScreen extends StatelessWidget {
  TaskModel items;
  TodoDetailScreen({super.key,
      required this.items
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 1;
    final width = MediaQuery.of(context).size.width * 1;
    return Scaffold(
      backgroundColor: Color(0xff151515),
      body: Center(
        child: Column(
              spacing: 30,
          children: [
            SizedBox(
              height: height * 0.04,
            ),
            Container(
              width: width * 0.7,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: EdgeInsets.all(15.0),
                child: Center(
                  child: Text(
                    items.task,
                    style: GoogleFonts.acme(color: Colors.white, fontSize: 30),
                  ),
                ),
              ),
            ),
            Container(
              width: width * 0.8,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(15)
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Center(child: Text(items.desc,style: GoogleFonts.acme(color: Colors.white, fontSize: 20))),
              ),
            ),
            Container(
                height: height * 0.3,
                width: width * 0.8,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.file(File(items.image),fit: BoxFit.cover))),
          ],
        ),
      ),
    );
  }
}
