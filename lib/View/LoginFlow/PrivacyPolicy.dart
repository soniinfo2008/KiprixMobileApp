import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:kirpix/Utils/Constant/ApiConfig/ApiEndPoints.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart'as http;
import '../../AppBarWithBack.dart';
import '../../Utils/Constant/AppTheme.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({Key? key}) : super(key: key);

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  String text="";
  @override

  void initState() {
    getPrivacy();
    super.initState();

  }




  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppTheme.back_color,
      appBar: AppBarBack(title: '',),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: HtmlWidget(
            text,
          ),
        ),
      ),
    );
  }

  getPrivacy() async {
    var request = http.Request('POST', Uri.parse(ApiEndPoints.privacyPolicy));


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
