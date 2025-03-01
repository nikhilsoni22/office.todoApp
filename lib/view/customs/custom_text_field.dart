import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  TextEditingController controller;
  final String hintText;
  final String validatorText;
  final TextInputType textInputType;
  final bool obscureText;
  final Icon icon;
  final VoidCallback functionOnEyeBtn;


   CustomTextField({super.key,
   required this.controller,
     this.hintText = '',
     required this.validatorText,
     this.textInputType = TextInputType.text,
     this.obscureText = false,
     this.icon = const Icon(null),
     this.functionOnEyeBtn = _defaultFunction,
   });

    static void _defaultFunction(){}
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      keyboardType: textInputType,
      controller: controller,
      decoration: InputDecoration(
        suffixIcon: InkWell(
          splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: functionOnEyeBtn,
            child: icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
          hintText: hintText
      ),
      validator: (value) {
        if(value!.isEmpty){
          return validatorText;
        }
        if(hintText == "Email" && !value.contains('@gmail.com') && value.contains(" ")){
          return "Please Provide Valid Email Address";
        }
        if(hintText == "password" && value.length < 6){
          return "Password must be atleast 6 characters";
        }
          return null;
      },
    );
  }
}
