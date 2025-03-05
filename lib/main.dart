import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_one/bloc/image_picker/image_pickerr_bloc.dart';
import 'package:project_one/bloc/obscure_text/obscure_text_bloc.dart';
import 'package:project_one/repository/task_repository.dart';
import 'package:project_one/resources/router/app_router.dart';
import 'package:project_one/view/Authentication/login_screen.dart';
import 'package:project_one/view/splash_screen/splash_screen.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
   // await TaskDbHelper.instance.deleteDatabase();
   //await DatabaseHelper.instance.deleteDatabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(create: (_) => ObscureTextBloc()),
      BlocProvider(create: (_) => ImagePickerBloc()),
    ], child: MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: SplashScreen(),// loginScreen(),
    ));
  }
}