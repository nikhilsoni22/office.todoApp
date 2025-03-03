import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_one/bloc/obscure_text/obscure_text_bloc.dart';
import 'package:project_one/model/user_model.dart';
import 'package:project_one/resources/images.dart';
import 'package:project_one/view/Authentication/signup_screen.dart';
import 'package:project_one/view/customs/custom_auth_btn.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:project_one/view/customs/custom_text_field.dart';
import 'package:project_one/view/home_page/todo_screen.dart';

import '../../repository/user_repository.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailOrPhoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
            spacing: height * 0.04,
            children: [
              Image.asset(AppImages.todoLogo, scale: 1.2),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: height * 0.02,
                children: [
                  Text(
                    "Log-In Details",
                    style: GoogleFonts.acme(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      spacing: height * 0.02,
                      children: [
                        CustomTextField(
                          controller: emailOrPhoneController,
                          validatorText: "Email Required",
                          hintText: "Email & phone number",
                        ),
                        BlocBuilder<ObscureTextBloc, ObscureTextState>(
                          builder: (context, state) {
                            return CustomTextField(
                              functionOnEyeBtn: () {
                                context.read<ObscureTextBloc>().add(
                                  EnableOrDisableIbscureInLogin()
                                );
                              },
                              icon:
                                  state.obscureLogin == true
                                      ? Icon(CupertinoIcons.eye_slash_fill)
                                      : Icon(CupertinoIcons.eye_fill),
                              obscureText: state.obscureLogin,
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
                      btnName: "Log-in",
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          DatabaseHelper.instance
                              .loginUser(
                                emailOrPhoneController.text,
                                passwordController.text,
                              )
                              .then((value) {
                                print(
                                  "${value}--------------------------->then",
                                );
                                if (value == null) {
                                  return ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        elevation: 0,
                                          backgroundColor: Colors.transparent,
                                          behavior: SnackBarBehavior.floating,
                                          content: AwesomeSnackbarContent(
                                    title: "Invalid credential",
                                    message:
                                    "Please check your email or password",
                                    contentType: ContentType.warning,
                                  )));
                                } else {
                                  return Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TodoScreen(),
                                    ),
                                  );
                                }
                              })
                              .onError((error, stackTrace) {
                                return Container();
                              });
                        }
                      },
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an Account?"),
                  TextButton(
                    style: ButtonStyle(
                      padding: WidgetStatePropertyAll(EdgeInsets.all(0)),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => SignupScreen()),
                      );
                    },
                    child: Text("Sign-up"),
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
