import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../AppBarWithBack.dart';
import '../../Utils/Constant/ApiConfig/ApiEndPoints.dart';
import '../../Utils/Constant/AppTheme.dart';
import '../../Utils/Constant/Const.dart';
import '../../Widgets/Shadow.dart';

class ContactPage extends StatefulWidget {
  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  static SharedPreferences? _prefs;
  String mobile1 = "+230 55555551";
  String mobile2 = "+230 55555552";
  String mail1 = "support@kiprix.mu";
  String mail2 = "adverts@kiprix.mu";

  void initState() {
    // TODO: implement initState
    _getImageUrl();
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.back_color,
      appBar: AppBarBack(
        title: '',
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Contact Us",
                      style: TextStyle(
                          color: AppTheme.dark_font_secondary,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  Container(
                      width: Get.width,
                      height: 105,
                      decoration: CustomDecorations()
                          .BackgroundDecorationwithRadiusTen(),
                      child: Column(
                        children: [
                        /*  InkWell(
                            onTap: () {
                              launchPhoneNumber(mobile1);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(13.0),
                              child: Row(
                                children: [
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        child: Icon(
                                          Icons.call,
                                          size: 24.0,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        child: Text(
                                          mobile1,
                                          style: TextStyle(
                                              color: AppTheme.dark_font_color,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  SvgPicture.asset(
                                    'assets/svg/right_arrow.svg',
                                    height: 24.0,
                                    width: 24.0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Divider(
                            height: 0.8,
                            thickness: 0.9,
                            indent: 1,
                            color: AppTheme.grayText,
                          ),
                          InkWell(
                            onTap: () {
                              launchPhoneNumber(mobile2);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(13.0),
                              child: Row(
                                children: [
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        child: Icon(
                                          Icons.call,
                                          size: 24.0,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        child: Text(
                                          mobile2,
                                          style: TextStyle(
                                              color: AppTheme.dark_font_color,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  SvgPicture.asset(
                                    'assets/svg/right_arrow.svg',
                                    height: 24.0,
                                    width: 24.0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Divider(
                            height: 0.8,
                            thickness: 0.9,
                            indent: 1,
                            color: AppTheme.grayText,
                          ),*/
                          InkWell(
                            onTap: () {
                              launchMailApp(mail1,"Queries, Support or Advert Space");
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(13.0),
                              child: Row(
                                children: [
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        child: Icon(
                                          Icons.mail,
                                          size: 24.0,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        child: Text(
                                          mail1,
                                          style: TextStyle(
                                              color: AppTheme.dark_font_color,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  SvgPicture.asset(
                                    'assets/svg/right_arrow.svg',
                                    height: 24.0,
                                    width: 24.0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Divider(
                            height: 0.8,
                            thickness: 0.9,
                            indent: 1,
                            color: AppTheme.grayText,
                          ),
                          InkWell(
                            onTap: () {
                              launchMailApp(mail2,"Queries, Support or Advert Space");
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(13.0),
                              child: Row(
                                children: [
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        child: Icon(
                                          Icons.mail,
                                          size: 24.0,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        child: Text(
                                          mail2,
                                          style: TextStyle(
                                              color: AppTheme.dark_font_color,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  SvgPicture.asset(
                                    'assets/svg/right_arrow.svg',
                                    height: 24.0,
                                    width: 24.0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _getImageUrl() async {
    int? userId;
    _prefs = await SharedPreferences.getInstance();
    if (_prefs?.getInt(Const.customerId) != null) {
      userId = _prefs?.getInt(Const.customerId);
      String body = json
          .encode({'customer_id': userId.toString()});

      final response = await http.post(
        Uri.parse(ApiEndPoints.getProfile),
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['status'] == "success") {
          mail1 = data['customer_support']['customer_support_email'] ?? "";
          mail2 = data['customer_support']['customer_support_email1'] ?? "";
          mobile1 = data['customer_support']['customer_support_contact'] ?? "";
          mobile2 = data['customer_support']['customer_support_contact1'] ?? "";

          setState(() {});
        } else {
          print('error');
        }
      } else {
        throw Exception('Failed to load image');
      }
    }



  }

  void launchMailApp(String mail1,String emailSubject) async {

    final Uri _emailLaunchUri = Uri(
      scheme: 'mailto',
      path: mail1,
      queryParameters: {'subject': '$emailSubject'},
    );

    if (await canLaunch(_emailLaunchUri.toString())) {
      await launch(_emailLaunchUri.toString());
    } else {
      // Handle the exception if the mail app is not installed
      print('Could not launch the mail app');
    }
  }

  void launchPhoneNumber(String phoneNumber) async {
    final Uri _phoneLaunchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );

    if (await canLaunch(_phoneLaunchUri.toString())) {
      await launch(_phoneLaunchUri.toString());
    } else {
      // Handle the exception if the phone app is not installed
      print('Could not launch the phone app');
    }
  }
}
