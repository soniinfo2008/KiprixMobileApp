import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kirpix/Utils/Constant/analytics_service.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../HomeScreen.dart';
import '../../Model/UserData.dart';
import '../../Utils/Constant/ApiConfig/ApiEndPoints.dart';
import '../../Utils/Constant/AppTheme.dart';
import '../../Utils/Constant/Const.dart';

class OTPScreen extends StatefulWidget {
  final String text;
  final String type;

  OTPScreen(this.text,this.type);

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  AnalyticsService analyticsService =AnalyticsService();
  var userOTP = '';
  bool otpSecond = true;
  int secondsRemaining = 60;
  bool enableResend = false;
  late Timer timer;
  late UserData data;
  bool _isLoading = false;
  static SharedPreferences? _prefs;

  static init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  @override
  initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (secondsRemaining != 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        setState(() {
          enableResend = true;
          otpSecond = false;
        });
      }
    });
  }

  void _resendCode() {
    //other code here
    setState(() {
      secondsRemaining = 60;
      enableResend = false;
      otpSecond = true;
    });
  }

  @override
  dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    init();
    OtpFieldController otpController = OtpFieldController();
    return OverlayLoaderWithAppIcon(
      isLoading: _isLoading,
      overlayBackgroundColor: Colors.black,
      circularProgressColor: Color(0xff7dca2e),
      appIcon:  Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset('assets/images/appicon.png'),
      ),
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
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                                color: AppTheme.grayText,
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
                        "Verfiy OTP",
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
                        "A verfication code has been sent to your email",
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
                        "Enter code",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppTheme.dark_font_color,
                            fontSize: 15,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    SizedBox(height: 40.0),
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
                          userOTP = pin;
                        }),
                    Visibility(
                      visible: otpSecond,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Text(
                          '$secondsRemaining seconds remaining',
                          style: TextStyle(
                              color: AppTheme.dark_font_color,
                              fontSize: 12,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
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
                              _isLoading=true;
                              verifyOTP();

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
                        ],
                      ),
                    ),
                    Visibility(
                      visible: enableResend,
                      child: RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'DMSans_Regular',
                                color: AppTheme.dark_font_color),
                            text: "Didn't receive the code? "),
                        TextSpan(
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'DMSans_Regular',
                                color: Colors.blueAccent),
                            text: "Resend",
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                resendOTP();
                              }),
                      ])),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }

  Future<void> resendOTP() async {
    DateTime currentTime = DateTime.now();

    // Format the time
    String formattedDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(currentTime);
    print("datetime "+formattedDateTime);
    _resendCode();
    print('email' + widget.text);
    print('email' + widget.type);

    String body = json.encode({
      'email': widget.text,
      'otp_type': widget.type,
      'otp_time' : formattedDateTime,
    });

    final response = await http.post(
      Uri.parse(ApiEndPoints.resendOTP),
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    Map<String, dynamic> data = jsonDecode(response.body);
    if (data['status'] == "success") {
      setState(() {});
      Get.snackbar(data['status'], data['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppTheme.apptheme_color.withOpacity(0.10),
          colorText: AppTheme.apptheme_color,
          borderColor: AppTheme.apptheme_color,
          borderWidth: 1,
          margin: EdgeInsets.only(bottom: 20, left: 10.0, right: 10.0));
    } else {
      print('error');
    }
  }

  Future<void> verifyOTP() async {
    DateTime currentTime = DateTime.now();

    // Format the time
    String formattedDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(currentTime);
    print("datetime "+formattedDateTime);
    String body = json.encode({
      'email': widget.text,
      'otp': userOTP,
      'otp_time' : formattedDateTime,
      'firebase_token' :  _prefs?.getString(Const.fBToken),
    });

    final response = await http.post(
      Uri.parse(ApiEndPoints.verifyOTP),
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    Map<String, dynamic> data1 = jsonDecode(response.body);
    if (data1['status'] == "success") {

      data = UserData.fromJson(jsonDecode(response.body));
      Get.snackbar(data.status, data.message,
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppTheme.apptheme_color.withOpacity(0.10),
          colorText: AppTheme.apptheme_color,
          borderColor: AppTheme.apptheme_color,
          borderWidth: 1,
          margin: EdgeInsets.only(bottom: 20, left: 10.0, right: 10.0));
      _prefs?.setInt(Const.customerId, data.data.customerId);
      _prefs?.setString(Const.customerIdStr, data.data.customerId.toString());
      _prefs?.setString(Const.firstName, data.data.firstName);
      _prefs?.setString(Const.lastName, data.data.lastName);
      _prefs?.setString(Const.phoneNumber, data.data.phoneNumber);
      _prefs?.setString(Const.token, data.data.token);
      analyticsService.setUserId(data.data.customerId);
      setState(() {

      });
      Navigator.of(context).pop();
      Navigator
          .of(context)
          .pushReplacement(
          MaterialPageRoute(
              builder: (BuildContext context) => HomeScreen()
          )
      );

    } else {
      Get.snackbar(data1['status'], data1['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor:
          AppTheme.apptheme_color.withOpacity(0.10),
          colorText: AppTheme.apptheme_color,
          borderColor: AppTheme.apptheme_color,
          borderWidth: 1,
          margin: EdgeInsets.only(
              bottom: 20, left: 10.0, right: 10.0));
      _isLoading=false;
      setState(() {
      });
      print('error');
    }
  }
}
