import 'package:chat_app/helpers/snackbar_helper.dart';
import 'package:chat_app/providers/auth_provider.dart';
import 'package:chat_app/ui/shared/busy_overlay.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../helpers/screen_factors.dart';
import '../shared/colors.dart';
import '../shared/space.dart';
import '../shared/styles.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  bool loading = false;

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
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  VSpace(100.sp),
                  Styles.bold(
                    "Reset Password",
                    fontSize: 24.sp,
                  ),
                  VSpace(20.h),
                  Text(
                    "Input your email and a password reset\nlink will be sent to you",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: black,
                      fontSize: 14.sp,
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
                  VSpace(100.h),
                  SizedBox(
                    width: deviceWidth(context) * .9,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          setState(() {
                            loading = true;
                          });
                          Provider.of<AuthProvider>(context, listen: false)
                              .fogotPassword(emailController.text)
                              .then(
                                (value) => value.fold(
                                  (l) {
                                    setState(() {
                                      loading = false;
                                    });
                                    showSnackbar(context, l);
                                  },
                                  (r) {
                                    setState(() {
                                      loading = false;
                                    });
                                    showSnackbar(context, r);
                                  },
                                ),
                              );
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(mainColor),
                      ),
                      child: Text(
                        "SEND PASSWORD RESET LINK",
                        style: TextStyle(color: white, fontSize: 15.sp),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      )),
    ));
  }
}
