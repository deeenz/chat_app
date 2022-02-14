import 'package:chat_app/repositories/auth_repo.dart';
import 'package:chat_app/ui/screens/forgot_password.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  AuthRepo authRepo = AuthRepo();
  
  Future<UserModel?> getUserDetails() async {
    return authRepo.getUserDetails();
  }

  Future<String?> login(String email, String password) async {
    return authRepo.login(email, password);
  }

  Future<String?> signUp(
      String email, String password, String phone, String name) async {
    return authRepo.signUp(email, password, phone, name);
  }

  Future<Either<String, String>> fogotPassword(String email) async {
    return authRepo.fogotPassword(email);
  }
}
