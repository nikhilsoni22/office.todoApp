import 'package:go_router/go_router.dart';
import 'package:project_one/resources/router/app_router_path.dart';
import 'package:project_one/view/Authentication/login_screen.dart';

import 'package:project_one/view/Authentication/signup_screen.dart';
import 'package:project_one/view/home_page/add_task/add_task.dart';
import 'package:project_one/view/home_page/todo_screen.dart';

class AppRouter {
  static final goRoute = GoRouter(
    routes: [
      GoRoute(path: AppRouterPath.LoginScreen, name: AppRouterPath.LoginScreen, builder: (context, GoRouterState state) {
          return LoginScreen(); // loginScreen();
        },
      ),
      GoRoute(path: AppRouterPath.SignupScreen, builder: (context, GoRouterState state) => SignupScreen()),
      GoRoute(path: AppRouterPath.TodoScreen, builder: (context,GoRouterState state) => TodoScreen()),
      GoRoute(name: AppRouterPath.AddTaskScreen, path: AppRouterPath.AddTaskScreen, builder: (context,GoRouterState state) => AddTask()),

    ],
  );
}
