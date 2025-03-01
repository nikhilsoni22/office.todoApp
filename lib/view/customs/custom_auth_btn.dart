import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAuthBtn extends StatelessWidget {
  final String btnName;
  final VoidCallback onTap;

  CustomAuthBtn({super.key,
      required this.btnName,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return  InkWell(
          onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(width * 0.02),
          color: Colors.blue,
        ),
        width: width * 0.7,
        height: height * 0.06,
        child: Center(
          child: Text(
            btnName,
            style: GoogleFonts.acme(
              color: Colors.white,
              fontSize: width * 0.06,
            ),
          ),
        ),
      ),
    );
  }
}
