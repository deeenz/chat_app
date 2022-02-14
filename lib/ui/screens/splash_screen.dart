import 'package:chat_app/helpers/route_generator.dart';
import 'package:chat_app/helpers/screen_factors.dart';
import 'package:chat_app/ui/screens/home_screen.dart';
import 'package:chat_app/ui/shared/colors.dart';
import 'package:chat_app/ui/shared/space.dart';
import 'package:chat_app/ui/shared/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), navigateAccordingly);
  }

  void navigateAccordingly() {
    if (FirebaseAuth.instance.currentUser != null) {
      // there is a currently signed in user, goto home page
      Navigator.of(context).pushReplacementNamed(homePage);
    } else {
      Navigator.of(context).pushReplacementNamed(signUp);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: deviceWidth(context),
        height: deviceHeight(context),
        child: Column(
          children: [
            VSpace(deviceHeight(context) * .4),
            Image.asset(
              "assets/chat_logo.jpeg",
              height: 80.sp,
              width: 80.sp,
              fit: BoxFit.contain,
            ),
            VSpace(10.h),
            Styles.bold(
              "ChatsApp",
              color: mainColor,
              fontSize: 18.sp,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Styles.regular("By Deeenz", color: grey),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
