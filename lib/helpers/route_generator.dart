import 'package:chat_app/ui/screens/all_users.dart';
import 'package:chat_app/ui/screens/forgot_password.dart';
import 'package:chat_app/ui/screens/home_screen.dart';
import 'package:chat_app/ui/screens/login_screen.dart';
import 'package:chat_app/ui/screens/signup_screen.dart';
import 'package:flutter/material.dart';

const String login = "/login";
const String signUp = "/signUp";
const String homePage = "/homePage";
const String forgotPassword = "/forgotPassword";

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(
          builder: (_) => const Login(),
        );
      case signUp:
        return MaterialPageRoute(
          builder: (_) => const SignUp(),
        );
      case forgotPassword:
        return MaterialPageRoute(
          builder: (_) => const ForgotPassword(),
        );
      case homePage:
        return MaterialPageRoute(
          builder: (_) => const HomePage(),
        );
   
     
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
