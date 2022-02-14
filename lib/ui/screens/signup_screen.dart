import 'package:chat_app/helpers/route_generator.dart';
import 'package:chat_app/ui/shared/busy_overlay.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';

import '../../helpers/screen_factors.dart';
import '../../helpers/snackbar_helper.dart';
import '../../providers/auth_provider.dart';
import '../shared/colors.dart';
import '../shared/space.dart';
import '../shared/styles.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  String passwordTrailing = "SHOW";
  bool obscurePassword = true;
  bool loading = false;
  String phone = "";

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
                  key: signupFormKey,
                  child: Column(
                    children: [
                      VSpace(100.h),
                      Styles.bold(
                        "Register",
                        fontSize: 24.sp,
                      ),
                      VSpace(10.h),
                      InkWell(
                        onTap: () => Navigator.of(context).pushNamed(login),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  text: "Already have an account? ",
                                  style:
                                      TextStyle(color: black, fontSize: 14.sp)),
                              TextSpan(
                                  text: "Login",
                                  style: TextStyle(
                                      color: mainColor, fontSize: 14.sp))
                            ],
                          ),
                        ),
                      ),
                      VSpace(30.h),
                      SizedBox(
                        width: deviceWidth(context) * .9,
                        child: TextFormField(
                          keyboardType: TextInputType.name,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Full name must be provided";
                            } else {
                              return null;
                            }
                          },
                          controller: nameController,
                          decoration: InputDecoration(
                            labelText: "Full name",
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
                        child: InternationalPhoneNumberInput(
                          onInputChanged: (PhoneNumber number) {
                            phone = number.phoneNumber!;
                            print(number.phoneNumber);
                          },
                          selectorConfig: const SelectorConfig(
                            selectorType: PhoneInputSelectorType.DIALOG,
                          ),
                          initialValue: PhoneNumber(isoCode: "NG"),
                          ignoreBlank: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Invalid phone number";
                            } else {
                              return null;
                            }
                          },
                          autoValidateMode: AutovalidateMode.disabled,
                          selectorTextStyle:
                              const TextStyle(color: Colors.black),
                          textFieldController: phoneController,
                          formatInput: true,
                          keyboardType: const TextInputType.numberWithOptions(
                              signed: true, decimal: true),
                          inputDecoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            labelText: "Phone number",
                            labelStyle: const TextStyle(
                              color: Colors.grey,
                            ),
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
                            } else if (value.length < 6) {
                              return "Password must contain more then six characters";
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
                      VSpace(100.h),
                      SizedBox(
                        width: deviceWidth(context) * .9,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            if (signupFormKey.currentState!.validate()) {
                              setState(() {
                                loading = true;
                              });
                              Provider.of<AuthProvider>(context, listen: false)
                                  .signUp(
                                      emailController.text,
                                      passwordController.text,
                                      phone,
                                      nameController.text)
                                  .then((value) {
                                if (value == null) {
                                  setState(() {
                                    loading = false;
                                  });
                                  showSnackbar(
                                    context,
                                    "Account created successfull, you will be redirected shortly.",
                                    duration: const Duration(
                                      seconds: 3,
                                    ),
                                  );

                                  Future.delayed(const Duration(seconds: 3),
                                      () {
                                    Navigator.of(context).pushNamed(login);
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
                            backgroundColor:
                                MaterialStateProperty.all(mainColor),
                          ),
                          child: Text(
                            "SIGN UP",
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
          ),
        ),
      ),
    );
  }
}
