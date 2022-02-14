import 'package:chat_app/helpers/route_generator.dart';
import 'package:chat_app/helpers/screen_factors.dart';
import 'package:chat_app/helpers/snackbar_helper.dart';
import 'package:chat_app/providers/auth_provider.dart';
import 'package:chat_app/ui/shared/busy_overlay.dart';
import 'package:chat_app/ui/shared/colors.dart';
import 'package:chat_app/ui/shared/space.dart';
import 'package:chat_app/ui/shared/styles.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String passwordTrailing = "SHOW";
  bool obscurePassword = true;
  bool loading = false;

  void showPassword() {
    setState(() {
      obscurePassword = !obscurePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BusyOverlay(
      show: loading,
      child: SafeArea(
          child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(
          FocusNode(),
        ),
        child: SizedBox(
          width: deviceWidth(context),
          height: deviceHeight(context),
          child: SingleChildScrollView(
            child: Form(
              key: loginFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  VSpace(100.sp),
                  Styles.bold(
                    "Sign in",
                    fontSize: 24.sp,
                  ),
                  VSpace(15.h),
                  InkWell(
                    onTap: () => Navigator.of(context).pushNamed(signUp),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Don't have an account? ",
                            style: TextStyle(
                              color: black,
                              fontSize: 14.sp,
                            ),
                          ),
                          TextSpan(
                            text: "Sign up",
                            style: TextStyle(
                              color: mainColor,
                              fontSize: 14.sp,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  VSpace(30.h),
                  SizedBox(
                    width: deviceWidth(context) * .9,
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Email must be provided";
                        } else if (!EmailValidator.validate(value)) {
                          return "Please provide a valid email";
                        } else {
                          return null;
                        }
                      },
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: "Email address",
                        contentPadding: const EdgeInsets.all(15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            10.sp,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            10.sp,
                          ),
                          borderSide: const BorderSide(
                            color: mainColor,
                            width: 2.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  VSpace(15.h),
                  SizedBox(
                    width: deviceWidth(context) * .9,
                    child: TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Password must be provided";
                        } else {
                          return null;
                        }
                      },
                      controller: passwordController,
                      obscureText: obscurePassword,
                      decoration: InputDecoration(
                        suffixIcon: TextButton(
                          onPressed: showPassword,
                          child: Styles.bold(
                            obscurePassword ? "SHOW" : "HIDE",
                            color: grey,
                            fontSize: 10.sp,
                          ),
                        ),
                        labelText: "Password",
                        contentPadding: const EdgeInsets.all(15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            10.sp,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            10.sp,
                          ),
                          borderSide: const BorderSide(
                            color: mainColor,
                            width: 2.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  VSpace(15.h),
                  Container(
                    alignment: Alignment.centerLeft,
                    width: deviceWidth(context) * .9,
                    child: InkWell(
                      onTap: () =>
                          Navigator.of(context).pushNamed(forgotPassword),
                      child: Text(
                        "Forgot Password",
                        style: TextStyle(
                          color: mainColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  VSpace(100.h),
                  SizedBox(
                    width: deviceWidth(context) * .9,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (loginFormKey.currentState!.validate()) {
                          setState(() {
                            loading = true;
                          });
                          Provider.of<AuthProvider>(context, listen: false)
                              .login(
                                  emailController.text, passwordController.text)
                              .then((value) {
                            if (value == null) {
                              setState(() {
                                loading = false;
                              });
                              showSnackbar(
                                context,
                                "Login successfull, you will be redirected shortly.",
                                duration: const Duration(
                                  seconds: 3,
                                ),
                              );

                              Future.delayed(const Duration(seconds: 3), () {
                                Navigator.of(context)
                                    .pushReplacementNamed(homePage);
                              });
                            } else {
                              setState(() {
                                loading = false;
                              });
                              showSnackbar(context, value);
                            }
                          });
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(mainColor),
                      ),
                      child: Text(
                        "LOGIN",
                        style: TextStyle(color: white, fontSize: 15.sp),
                      ),
                    ),
                  ),
                  VSpace(
                    20.h,
                  )
                ],
              ),
            ),
          ),
        ),
      )),
    ));
  }
}
