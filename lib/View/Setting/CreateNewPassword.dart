import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';
import 'package:http/http.dart' as http;
import '../../AppBarWithBack.dart';
import '../../Utils/Constant/ApiConfig/ApiEndPoints.dart';
import '../../Utils/Constant/AppTheme.dart';

class CreateNewPassword extends StatefulWidget {
  final String userId;
  CreateNewPassword(String this.userId);

  @override
  State<CreateNewPassword> createState() => _CreateNewPasswordState();
}

class _CreateNewPasswordState extends State<CreateNewPassword> {
  bool firstBlock = false;
  bool secondBlock = true;
  bool _showOldPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController oldPassword = new TextEditingController();
  TextEditingController newPassword = new TextEditingController();
  TextEditingController confirmPassword = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    OtpFieldController otpController = OtpFieldController();

    return OverlayLoaderWithAppIcon(
      isLoading: _isLoading,
      overlayBackgroundColor: Colors.black,
      circularProgressColor: Color(0xff7dca2e),
      appIcon: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset('assets/images/appicon.png'),
      ),
      child: Form(
        key: _formKey,
        child: Scaffold(
          backgroundColor: AppTheme.back_color,
          appBar: AppBarBack(
            title: '',
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Visibility(
                  visible: firstBlock,
                  child: Column(
                    children: [
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
                          "A reset code has been sent to your email",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: AppTheme.dark_font_color,
                              fontSize: 15,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Text(
                          "Enter Code",
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
                      OTPTextField(
                          keyboardType: TextInputType.number,
                          controller: otpController,
                          length: 4,
                          width: MediaQuery.of(context).size.width,
                          textFieldAlignment: MainAxisAlignment.spaceAround,
                          otpFieldStyle: OtpFieldStyle(
                              backgroundColor: Colors.white,
                              borderColor: AppTheme.apptheme_color,
                              enabledBorderColor: AppTheme.broder_color,
                              errorBorderColor: Colors.red,
                              disabledBorderColor: AppTheme.broder_color),
                          fieldWidth: 50,
                          fieldStyle: FieldStyle.box,
                          outlineBorderRadius: 10,
                          style: TextStyle(fontSize: 14),
                          onChanged: (pin) {
                            print("Changed: " + pin);
                          },
                          onCompleted: (pin) {
                            print("Completed: " + pin);
                          }),
                      SizedBox(height: 20.0),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            GestureDetector(
                              onTap: () {
                                firstBlock = false;
                                secondBlock = true;
                                setState(() {});
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
                                    colors: [
                                      Color(0xFF9BC838),
                                      Color(0xFF4F9D01)
                                    ],
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
                                      'Submit OTP',
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
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: secondBlock,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: Text(
                            "Create new password",
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
                            "Good to see you again, enter your details below to continue.",
                            style: TextStyle(
                                color: AppTheme.dark_font_color,
                                fontSize: 15,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Text(
                            'Old Password',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.dark_font_color),
                          ),
                        ),
                        SizedBox(height: 10.0),
                        TextFormField(
                          controller: oldPassword,
                          keyboardType: TextInputType.visiblePassword,
                          style: new TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                          obscureText: !_showOldPassword,
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              hintText: '**********',
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 17.0, horizontal: 10.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _showOldPassword = !_showOldPassword;
                                  });
                                },
                                child: Icon(
                                  _showOldPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                              )),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Old Password';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20.0),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Text(
                            'New Password',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.dark_font_color),
                          ),
                        ),
                        SizedBox(height: 10.0),
                        TextFormField(
                          controller: newPassword,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: !_showNewPassword,
                          style: new TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              hintText: '**********',
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 17.0, horizontal: 10.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _showNewPassword = !_showNewPassword;
                                  });
                                },
                                child: Icon(
                                  _showNewPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                              )),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter New Password';
                            }
                            if (oldPassword.text == value) {
                              return "Password New Password and Old Password Same";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20.0),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Text(
                            'Confirm Password',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.dark_font_color),
                          ),
                        ),
                        SizedBox(height: 10.0),
                        TextFormField(
                          controller: confirmPassword,
                          obscureText: !_showConfirmPassword,
                          keyboardType: TextInputType.visiblePassword,
                          style: new TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              hintText: '***********',
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 17.0, horizontal: 10.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _showConfirmPassword =
                                        !_showConfirmPassword;
                                  });
                                },
                                child: Icon(
                                  _showConfirmPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                              )),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Confirm Password';
                            }
                            if (newPassword.text != value) {
                              return "Password does not match";
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
                                height: 40,
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (_formKey.currentState!.validate()) {
                                    _isLoading = true;
                                    createNewPassword(
                                        oldPassword.value, newPassword.value);
                                    setState(() {});
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
                                      colors: [
                                        Color(0xFF9BC838),
                                        Color(0xFF4F9D01)
                                      ],
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Submit',
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
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> createNewPassword(
      TextEditingValue valueoldpass, TextEditingValue newPass) async {
    print("email " + valueoldpass.text);
    print("pass " + newPass.text);
    print("pass --=" + widget.userId);
    String body = json.encode({
      'customer_id': widget.userId,
      'old_password': valueoldpass.text,
      'new_password': newPass.text,
    });

    final response = await http.post(
      Uri.parse(ApiEndPoints.newPassword),
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode == 200) {
      _isLoading = false;
      Navigator.pop(context);
      setState(() {});
      // print("reset pass response --=" + response);
      Get.snackbar("success  ", "Password reset successfully",
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppTheme.apptheme_color.withOpacity(0.10),
          colorText: AppTheme.apptheme_color,
          borderColor: AppTheme.apptheme_color,
          borderWidth: 1,
          margin: EdgeInsets.only(bottom: 20, left: 10.0, right: 10.0));
    } else {
      print('error');
      Get.snackbar("Failure", "Old password is incorrect",
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppTheme.apptheme_color.withOpacity(0.10),
          colorText: AppTheme.apptheme_color,
          borderColor: AppTheme.apptheme_color,
          borderWidth: 1,
          margin: EdgeInsets.only(bottom: 20, left: 10.0, right: 10.0));
      _isLoading = false;
      setState(() {});
    }
  }
}
