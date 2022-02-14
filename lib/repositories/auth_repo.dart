import 'package:chat_app/helpers/constants.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepo {
  Future<UserModel?> getUserDetails() async {
    try {
      var res = await FirebaseFirestore.instance
          .collection(USER_COLLECTION)
          .where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      return UserModel.fromJson(res.docs.first.data());
    } on Exception catch (e) {
      return null;
    }
  }

  Future<String?> login(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message ??
          "Unable to login at the moment, please try again later.";
    } catch (e) {
      return "Unable to login at the moment, please try again later.";
    }
  }

  Future<String?> signUp(
      String email, String password, String phone, String name) async {
    try {
      User? user = (await FirebaseAuth.instance
              .createUserWithEmailAndPassword(email: email, password: password))
          .user;

      //update user details on firestore
      UserModel userModel =
          UserModel(id: user!.uid, fullName: name, email: email, phone: phone);

      await FirebaseFirestore.instance
          .collection(USER_COLLECTION)
          .doc(userModel.id)
          .set(
            userModel.toJson(),
          );

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message ??
          "Unable to sign up at the moment, please try again later.";
    } catch (e) {
      return "Unable to sign up at the moment, please try again later.";
    }
  }

  Future<Either<String, String>> fogotPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return const Right("Password reset link sent successfully!");
    } on FirebaseAuthException catch (e) {
      return Left(e.message ??
          "Unable to reset password at the moment, please try again later.");
    } catch (e) {
      return const Left(
          "Unable to reset password at the moment, please try again later.");
    }
  }
}
