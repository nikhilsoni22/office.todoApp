import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_one/bloc/obscure_text/obscure_text_bloc.dart';
import 'package:project_one/model/user_model.dart';
import 'package:project_one/resources/images.dart';
import 'package:project_one/view/Authentication/login_screen.dart';
import 'package:project_one/view/customs/custom_auth_btn.dart';
import 'package:project_one/view/customs/custom_text_field.dart';

import '../../repository/user_repository.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 1;
    final height = MediaQuery.of(context).size.height * 1;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(width * 0.04),
          child: Column(
            children: [
              Image.asset(AppImages.todoLogo, scale: 1.2),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 20,
                children: [
                  Text(
                    "Sign-up Details",
                    style: GoogleFonts.acme(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      spacing: 10,
                      children: [
                        CustomTextField(
                          controller: nameController,
                          validatorText: "name Required",
                          hintText: "name",
                        ),
                        CustomTextField(
                          controller: emailController,
                          validatorText: "Email Required",
                          hintText: "Email",
                        ),
                        CustomTextField(
                          controller: phoneController,
                          validatorText: "phone number Required",
                          hintText: "phone number",
                        ),
                        BlocBuilder<ObscureTextBloc, ObscureTextState>(
                          builder: (context, state) {
                            return CustomTextField(
                              functionOnEyeBtn: () {
                                context.read<ObscureTextBloc>().add(
                                  EnableOrDisableObscureTextEvent(),
                                );
                              },
                              icon:
                                  state.obscure == true
                                      ? Icon(CupertinoIcons.eye_slash_fill)
                                      : Icon(CupertinoIcons.eye_fill),
                              obscureText: state.obscure,
                              controller: passwordController,
                              validatorText: "Password Required",
                              hintText: "password",
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  Center(
                    child: CustomAuthBtn(
                      btnName: "Sign-up",
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          UserModel newUser = UserModel(
                            name: nameController.text,
                            email: emailController.text,
                            phone: phoneController.text,
                            password: passwordController.text,
                          );
                          int result = await DatabaseHelper.instance.insertUser(
                            newUser,
                          );

                          if (result > 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('User registered successfully!'),
                              ),
                            );

                            nameController.clear();
                            emailController.clear();
                            phoneController.clear();
                            passwordController.clear();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Error registering user.'),
                              ),
                            );
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an Account?"),
                  TextButton(
                    style: ButtonStyle(
                      padding: WidgetStatePropertyAll(EdgeInsets.all(0)),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    child: Text("LogIn"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
