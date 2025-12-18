import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kirpix/Utils/Constant/analytics_service.dart';
import 'package:kirpix/View/LoginFlow/CreateAccount.dart';
import 'package:kirpix/View/LoginFlow/ForgotPassword.dart';
import 'package:http/http.dart' as http;
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../HomeScreen.dart';
import '../../Model/UserData.dart';
import '../../Utils/Constant/ApiConfig/ApiEndPoints.dart';
import '../../Utils/Constant/AppTheme.dart';
import '../../Utils/Constant/Const.dart';
import 'OTPScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AnalyticsService analyticsService = AnalyticsService();
  bool _isLoading = false;
  bool _showPassword = false;
  String _message = '';
  TextEditingController cntEmail = TextEditingController();
  TextEditingController cntPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _initSharedPreferences();
  }

  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  void setMessage(String message) {
    setState(() {
      _message = message;
    });
  }

  Future<void> _setDefaultEventParameters() async {
    if (kIsWeb) {
      setMessage(
        '"setDefaultEventParameters()" is not supported on web platform',
      );
    } else {
      setMessage('setDefaultEventParameters succeeded');
    }
  }

  @override
  Widget build(BuildContext context) {
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
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Text(
                          "Login to your account",
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
                          "Good to see you again, enter your details below to continue ordering.",
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
                          'Email Address',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.dark_font_color),
                        ),
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
                          if (!RegExp("[a-z0-9]+@[a-z0-9]+.[a-z]{2,3}")
                              .hasMatch(value)) {
                            return 'Please Enter valid Email Address';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: Text(
                              'Password',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.dark_font_color),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.to(ForgotPassword());
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: Text(
                                'Reset Password',
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.blueAccent.shade700),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0),
                      TextFormField(
                        controller: cntPassword,
                        keyboardType: TextInputType.visiblePassword,
                        style: new TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                        obscureText: !_showPassword,
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
                                _showPassword = !_showPassword;
                              });
                            },
                            child: Icon(
                              _showPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Password';
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
                                  setState(() {});
                                  loginCall(cntEmail.value, cntPassword.value);
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Login',
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

  Future<void> loginCall(
      TextEditingValue valueEmail, TextEditingValue valuePass) async {
    DateTime currentTime = DateTime.now();

    // Format the time
    String formattedDateTime =
    DateFormat('yyyy-MM-dd HH:mm:ss').format(currentTime);
    print("datetime " + formattedDateTime);
    print("email " + valueEmail.text);
    print("pass " + valuePass.text);
    String body = json.encode({
      'email': valueEmail.text,
      'password': valuePass.text,
      'otp_time': formattedDateTime,
    });

    try {
      final response = await http.post(
        Uri.parse(ApiEndPoints.login),
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        _isLoading = false;
        setState(() {});

        if (data['status'] == 'success') {
          // Check if user is authorized
          bool isAuthorized = data['data']['authorized'] ?? false;
          var userData = data['data'];

          if (isAuthorized) {
            // User is authorized, save data and navigate to HomeScreen
            await _saveUserData(userData);

            Get.snackbar(
              data['status'],
              'Login successful!',
              snackPosition: SnackPosition.TOP,
              backgroundColor: AppTheme.apptheme_color.withOpacity(0.10),
              colorText: AppTheme.apptheme_color,
              borderColor: AppTheme.apptheme_color,
              borderWidth: 1,
              margin: EdgeInsets.only(bottom: 20, left: 10.0, right: 10.0),
            );

            // Navigate to HomeScreen
            Get.offAll(() => HomeScreen());
          } else {
            // User not authorized, navigate to OTP screen
            Get.snackbar(
              data['status'],
              data['message'],
              snackPosition: SnackPosition.TOP,
              backgroundColor: AppTheme.apptheme_color.withOpacity(0.10),
              colorText: AppTheme.apptheme_color,
              borderColor: AppTheme.apptheme_color,
              borderWidth: 1,
              margin: EdgeInsets.only(bottom: 20, left: 10.0, right: 10.0),
            );

            // Navigate to OTP screen with email
            Get.to(() => OTPScreen(valueEmail.text, 'login'));
          }
        } else {
          Get.snackbar(
            data['status'] ?? 'Error',
            data['message'] ?? 'Something went wrong',
            snackPosition: SnackPosition.TOP,
            backgroundColor: AppTheme.apptheme_color.withOpacity(0.10),
            colorText: AppTheme.apptheme_color,
            borderColor: AppTheme.apptheme_color,
            borderWidth: 1,
            margin: EdgeInsets.only(bottom: 20, left: 10.0, right: 10.0),
          );
        }
      } else {
        Get.snackbar(
          'Error',
          'Server error: ${response.statusCode}',
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppTheme.apptheme_color.withOpacity(0.10),
          colorText: AppTheme.apptheme_color,
          borderColor: AppTheme.apptheme_color,
          borderWidth: 1,
          margin: EdgeInsets.only(bottom: 20, left: 10.0, right: 10.0),
        );
        _isLoading = false;
        setState(() {});
      }
    } catch (e) {
      print('Error: $e');
      Get.snackbar(
        'Error',
        'Network error occurred',
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppTheme.apptheme_color.withOpacity(0.10),
        colorText: AppTheme.apptheme_color,
        borderColor: AppTheme.apptheme_color,
        borderWidth: 1,
        margin: EdgeInsets.only(bottom: 20, left: 10.0, right: 10.0),
      );
      _isLoading = false;
      setState(() {});
    }
  }

  Future<void> _saveUserData(Map<String, dynamic> userData) async {
    try {
      // Save user data to SharedPreferences
      await _prefs.setInt(Const.customerId, userData['customer_id']);
      await _prefs.setString(
          Const.customerIdStr, userData['customer_id'].toString());
      await _prefs.setString(Const.firstName, userData['first_name'] ?? '');
      await _prefs.setString(Const.lastName, userData['last_name'] ?? '');
      await _prefs.setString(
          Const.preferedName, userData['prefered_name'] ?? '');
      await _prefs.setString(Const.email, userData['email'] ?? '');
      await _prefs.setString(
          Const.phoneNumber, userData['phone_number'] ?? '');

      // Set analytics user ID
      analyticsService.setUserId(userData['customer_id']);

      print('User data saved successfully');
    } catch (e) {
      print('Error saving user data: $e');
    }
  }

  validateEmail(String? value) {
    String pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = RegExp(pattern);
    if (value == null) return 'Email Required';
    else if (value.isEmpty) return 'Email Required';
    else if (!regex.hasMatch(value)) return 'Enter a valid email address';
    else
      return null;
  }
}
