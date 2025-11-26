import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';

import '../../HomeScreen.dart';
import '../../Utils/Constant/ApiConfig/ApiEndPoints.dart';
import '../../Utils/Constant/AppTheme.dart';
import 'CreateAccount.dart';
import 'ResetPassword.dart';
import 'package:http/http.dart' as http;

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  bool _isLoading = false;
  TextEditingController cntEmail = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return OverlayLoaderWithAppIcon(
      isLoading: _isLoading,
      overlayBackgroundColor: Colors.black,
      circularProgressColor: Color(0xff7dca2e),
      appIcon:  Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset('assets/images/appicon.png'),
      ),
      child: Form(
        key: _formKey,
        child: Scaffold(
            backgroundColor: AppTheme.back_color,
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image(
                            image: AssetImage("assets/images/logo.png"),
                            height: 60,
                            width: 120,
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.to(HomeScreen());
                            },
                            child: Text(
                              "Skip",
                              style: TextStyle(
                                  color: AppTheme.apptheme_color,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 100,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Text(
                          "Reset Password",
                          style: TextStyle(
                              color: AppTheme.dark_font_color,
                              fontSize: 24,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Text(
                          "Enter your email address to request a password reset.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: AppTheme.dark_font_color,
                              fontSize: 15,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: Text(
                              'Email Address',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.dark_font_color),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0),
                      TextFormField(
                        controller: cntEmail,
                        keyboardType: TextInputType.emailAddress,
                        style: new TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          hintText: 'Ex: abc@gmail.com',
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 17.0, horizontal: 10.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Email Address';
                          }
                          if(!RegExp("[a-z0-9]+@[a-z0-9]+.[a-z]{2,3}").hasMatch(value)){
                            return 'Please Enter valid Email Address';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20.0),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 50,
                            ),
                            GestureDetector(
                              onTap: () {
                            if (_formKey.currentState!.validate()) {
                              _isLoading = true;
                              forgetPassword();
                              setState(() {

                              });
                            }
                              },
                              child: Container(
                                width: Get.width,
                                height: 50,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 15),
                                decoration: ShapeDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment(0.00, -1.00),
                                    end: Alignment(0, 1),
                                    colors: [Color(0xFF9BC838), Color(0xFF4F9D01)],
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  shadows: [
                                    BoxShadow(
                                      color: Color(0x19C94210),
                                      blurRadius: 30,
                                      offset: Offset(0, 10),
                                      spreadRadius: 0,
                                    )
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Reset Password',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.to(CreateAccount());
                              },
                              child: Container(
                                width: Get.width,
                                height: 50,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 15),
                                decoration: ShapeDecoration(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  shadows: [
                                    BoxShadow(
                                      color: Color(0xFFC6C6C6),
                                      blurRadius: 4,
                                      offset: Offset(0, 0),
                                      spreadRadius: 0,
                                    )
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Create an account',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: AppTheme.apptheme_color,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )),
      ),
    );
  }

  Future<void> forgetPassword() async {
    DateTime currentTime = DateTime.now();

    // Format the time
    String formattedDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(currentTime);
    print('email' + cntEmail.text);

    String body = json.encode({
      'email': cntEmail.text,
      'otp_type': 'forget',
      'otp_time' : formattedDateTime,
    });

    final response = await http.post(
      Uri.parse(ApiEndPoints.resendOTP),
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    Map<String, dynamic> data = jsonDecode(response.body);
    if (data['status'] == "success") {
      _isLoading = false;
      setState(() {});
      Get.snackbar(data['status'], data['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppTheme.apptheme_color.withOpacity(0.10),
          colorText: AppTheme.apptheme_color,
          borderColor: AppTheme.apptheme_color,
          borderWidth: 1,
          margin: EdgeInsets.only(bottom: 20, left: 10.0, right: 10.0));
      Get.to(ResetPassword(data['otp'], cntEmail.text));
    } else {
      Get.snackbar(data['status'], data['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppTheme.apptheme_color.withOpacity(0.10),
          colorText: AppTheme.apptheme_color,
          borderColor: AppTheme.apptheme_color,
          borderWidth: 1,
          margin: EdgeInsets.only(bottom: 20, left: 10.0, right: 10.0));
      setState(() {});
      _isLoading = false;
    }
  }

  validateEmail(String? value) {
    String pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = RegExp(pattern);
    if (value == null)
      return 'Email Required';
    else if(value.isEmpty)
      return 'Email Required';
    else if(!regex.hasMatch(value))
      return 'Enter a valid email address';
    else
      return null;
  }
}
