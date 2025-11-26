import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:kirpix/Utils/Constant/ApiConfig/ApiEndPoints.dart';
import 'package:kirpix/Utils/Constant/AppTheme.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart'as http;
import '../../AppBarWithBack.dart';
import '../../Widgets/Shadow.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {

  String text="";
  @override

  void initState() {
    // TODO: implement initState
    getAboutPages();
    super.initState();

  }



  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppTheme.back_color,
      appBar: AppBarBack(title: '',),
      body: SingleChildScrollView(
        child: Column(
          children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                SizedBox(height: 10,),
                Container(
                width: Get.width,
                height: 500,
                decoration: CustomDecorations().BackgroundDecorationwithRadiusTen(),
                child:Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Row(
                            children: <Widget>[
                              Container(
                                child: Image.asset(
                                  'assets/images/appicon.png',
                                  height: 28.0,
                                  width: 28.0,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                child: RichText(
                                    text: TextSpan(children: [
                                      TextSpan(
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'DMSans_Regular',
                                              color: AppTheme.dark_font_color),
                                          text: "About "),
                                      TextSpan(
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: 'DMSans_Regular',
                                            color: AppTheme.apptheme_color),
                                        text: "Kiprix",
                                      ),
                                    ])),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          height: 0.8,
                          thickness: 0.9,
                          indent: 1,
                          color: AppTheme.grayText,
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: SingleChildScrollView(
                              child: HtmlWidget(
                                text,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                SizedBox(height: 15,),
                // GestureDetector(
                //   onTap: () {
                //
                //     // Navigator.pop(context);
                //   },
                //   child: Container(
                //     height: 52,
                //     padding: const EdgeInsets.symmetric(
                //         horizontal: 10, vertical: 14),
                //     decoration: ShapeDecoration(
                //       color: Colors.white,
                //       shape: RoundedRectangleBorder(
                //         side: BorderSide(
                //             width: 0.50, color: Color(0xFF7DCA2E)),
                //         borderRadius: BorderRadius.circular(10),
                //       ),
                //       shadows: [
                //         BoxShadow(
                //           color: Color(0xFFC6C6C6).withOpacity(0.75),
                //           blurRadius: 4,
                //           offset: Offset(0, 0),
                //           spreadRadius: 0,
                //         )
                //       ],
                //     ),
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.start,
                //       children: [
                //     Image.asset(
                //     'assets/images/support.png',
                //       height: 33.0,
                //       width: 33.0,
                //     ),
                //         SizedBox(width: 10,),
                //         SizedBox(
                //           child: Text(
                //             'Support',
                //             textAlign: TextAlign.center,
                //             style: TextStyle(
                //               color: Color(0xFF7DCA2E),
                //               fontSize: 14,
                //               fontWeight: FontWeight.w500,
                //               height: 1.50,
                //               letterSpacing: 0.60,
                //             ),
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
          ],
        ),
      ),
    );
  }

  getAboutPages() async {
    var request = http.Request('POST', Uri.parse(ApiEndPoints.aboutPage));


    http.StreamedResponse response = await request.send();
    var resp = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      var parsed = jsonDecode(resp.body);
      text=parsed['data'][0]['description'];
      setState(() {

      });
      print(parsed['data'][0]['description']);
    }
    else {
      print(response.reasonPhrase);
      text="No Data found";
      setState(() {

      });
    }

  }
}
