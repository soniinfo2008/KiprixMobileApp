import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kirpix/HomeScreen.dart';
import 'package:kirpix/Utils/Constant/analytics_service.dart';
import 'package:kirpix/View/LoginFlow/OTPScreen.dart';
import 'package:kirpix/View/LoginFlow/PrivacyPolicy.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';
import 'package:http/http.dart'as http;

import '../../Model/UserData.dart';
import '../../Utils/Constant/ApiConfig/ApiEndPoints.dart';
import '../../Utils/Constant/AppTheme.dart';
import 'TermsCondition.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({Key? key}) : super(key: key);

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  AnalyticsService analyticsService=AnalyticsService();
  bool _isLoading = false;
  bool _showPassword = false;
  bool _showPassword2 = false;
  TextEditingController cntEmail = TextEditingController();
  TextEditingController cntPassword = TextEditingController();
  TextEditingController cntComfirmPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool chackvalue= false;



  @override
  void initState() {
    super.initState();

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
                          "Create an account",
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
                          "Welcome friend, enter your details so lets get started in comparing products.",
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
                          if(!RegExp("[a-z0-9]+@[a-z0-9]+.[a-z]{2,3}").hasMatch(value)){
                            return 'Please Enter valid Email Address';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20.0),
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
                      SizedBox(height: 10.0),
                      TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        controller: cntPassword,
                        style: new TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                        obscureText: !_showPassword,
                        decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            hintText: '***********',
                            contentPadding: const EdgeInsets.symmetric(vertical: 17.0, horizontal: 10.0),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.0),),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _showPassword = !_showPassword;
                                });
                              },
                              child: Icon(
                                _showPassword ? Icons.visibility : Icons.visibility_off,
                              ),)
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
                        keyboardType: TextInputType.visiblePassword,
                        controller: cntComfirmPassword,
                        style: new TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                        obscureText: !_showPassword2,
                        decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            hintText: '***********',
                            contentPadding: const EdgeInsets.symmetric(vertical: 17.0, horizontal: 10.0),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.0),),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _showPassword2 = !_showPassword2;
                                });
                              },
                              child: Icon(
                                _showPassword2 ? Icons.visibility : Icons.visibility_off,
                              ),)
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Confirm Password';
                          }
                          if(cntPassword.text!=value){
                            return "Password does not match";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3),
                            ),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            value: this.chackvalue,
                            onChanged: (newValue) {
                              print(newValue);
                              setState(() {
                                this.chackvalue = newValue!;
                              });

                            },
                            /// Set your color here

                            fillColor: MaterialStateProperty.all(Colors.grey),
                          ),
                          Flexible(
                            child: RichText(
                                text: TextSpan(children: [
                              TextSpan(
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'DMSans_Regular',
                                      color: AppTheme.dark_font_color),
                                  text: "I agree to the "),
                              TextSpan(
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'DMSans_Regular',
                                      color: Colors.blueAccent),
                                  text: "terms and conditions",
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Get.to(TermsCondition());
                                    }),
                              TextSpan(
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'DMSans_Regular',
                                      color: AppTheme.dark_font_color),
                                  text: " and "),
                              TextSpan(
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'DMSans_Regular',
                                      color: Colors.blueAccent),
                                  text: "privacy policy",
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Get.to(PrivacyPolicy());
                                    }),
                              TextSpan(
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'DMSans_Regular',
                                      color: AppTheme.dark_font_color),
                                  text:
                                      " of kiprix,subscribe for latest offer and etc. "),
                            ])),
                          ),
                        ],
                      ),
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
                                  if(this.chackvalue) {
                                    _isLoading = true;
                                    analyticsService.logEvent("Login");
                                    createNewAccount(cntEmail.value, cntPassword.value);
                                    setState(() {

                                    });
                                  }else{
                                      Get.snackbar("Alert", "Please Check Terms and Conditions",snackPosition: SnackPosition.TOP,backgroundColor: AppTheme.apptheme_color.withOpacity(0.10),colorText: AppTheme.apptheme_color,borderColor:AppTheme.apptheme_color,borderWidth: 1,margin: EdgeInsets.only(bottom: 20,left: 10.0,right: 10.0));

                                  }
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
                                      'Get OTP',
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

  Future<void> createNewAccount(TextEditingValue valueEmail, TextEditingValue valuePass) async  {
    DateTime currentTime = DateTime.now();

    // Format the time
    String formattedDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(currentTime);
    print("datetime "+formattedDateTime);

    print("email "+valueEmail.text);
    print("pass "+valuePass.text);
    String body = json.encode({
      'email' : valueEmail.text,
      'password' : valuePass.text,
      'otp_time' : formattedDateTime,
    });

    final response = await http.post(Uri.parse(ApiEndPoints.newUserRegister),headers:{"Content-Type": "application/json"},body: body,);
    Map<String, dynamic> data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      _isLoading=false;
      setState(() {

      });
      Get.snackbar(data['status'], data['message'],snackPosition: SnackPosition.TOP,backgroundColor: AppTheme.apptheme_color.withOpacity(0.10),colorText: AppTheme.apptheme_color,borderColor:AppTheme.apptheme_color,borderWidth: 1,margin: EdgeInsets.only(bottom: 20,left: 10.0,right: 10.0));
      Get.to(OTPScreen(valueEmail.text,'registration'));

    } else {
      Get.snackbar(data['status'], data['message'],snackPosition: SnackPosition.TOP,backgroundColor: AppTheme.apptheme_color.withOpacity(0.10),colorText: AppTheme.apptheme_color,borderColor:AppTheme.apptheme_color,borderWidth: 1,margin: EdgeInsets.only(bottom: 20,left: 10.0,right: 10.0));
      _isLoading=false;
      setState(() {

      });
    }

  }

}
