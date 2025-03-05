import 'dart:async';

import 'package:flutter/material.dart';
import 'package:project_one/resources/images.dart';
import 'package:project_one/view/Authentication/login_screen.dart';

import '../../repository/task_repository.dart';
import '../home_page/todo_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  Timer? _timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkLoginStatus();
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  Future<void> _checkLoginStatus() async {
    String? userEmail = await TaskDbHelper.instance.getCurrentUserEmail();
    if (userEmail != null && userEmail.contains("@gmail.com")) {
      // User is logged in, navigate to TodoScreen
      print(
          ">>>>>>>>>>>>>>>>> SplashScreen: User is logged in, navigating to TodoScreen");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => TodoScreen()),
      );
    } else {
      // User is not logged in, navigate to LoginScreen after 2 seconds
      print(
          ">>>>>>>>>>>>>>>>> SplashScreen: User is not logged in, navigating to LoginScreen");
      _timer = Timer(Duration(seconds: 2), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black26,
      body: Center(
        child: Container(
              height: 200,
            width: 200,
            child: Image.asset(AppImages.splashImg)),
      ),
    );
  }
}
