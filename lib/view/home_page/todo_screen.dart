import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bottom_sheet/bottom_sheet.dart';

class TodoScreen extends StatelessWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 1;
    final width = MediaQuery.of(context).size.width * 1;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
            showStickyFlexibleBottomSheet(context: context, headerBuilder: (BuildContext context, double offset){
                return Container();
            }, bodyBuilder: (BuildContext context, double offset){
                return SliverChildListDelegate(
                  [

                  ]
                );
            });
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
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return Card(
                  color: Color(0xff201F1F),
                  child: ListTile(
                    leading: Checkbox(
                      checkColor: Color(0xff7A7777),
                      shape: CircleBorder(side: BorderSide(color: Colors.teal)),
                      value: false,
                      onChanged: (value) {},
                    ),
                    title: Text(
                      "Do exercise",
                      style: TextStyle(
                        color: Color(0xffF5F5F5),
                        decoration: TextDecoration.lineThrough,
                        decorationColor: Color(0xffF5F5F5),
                        decorationThickness: 2,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
