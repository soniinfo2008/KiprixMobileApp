import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kirpix/View/LoginFlow/LoginScreen.dart';
import 'package:kirpix/View/Setting/ProfileMain.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'Utils/Constant/ApiConfig/ApiEndPoints.dart';
import 'Utils/Constant/AppTheme.dart';
import 'DrawerPages/ProfilePage.dart';
import 'Utils/Constant/Const.dart';
import 'Widgets/Shadow.dart';

class AppBars extends StatelessWidget implements PreferredSizeWidget {
  final String? title;

  static String? profile = "";

  AppBars({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(70);
  static SharedPreferences? _prefs;
  static String liveImage = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
      preferredSize: preferredSize,
      child: Container(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 40),
        decoration: CustomDecorations().baseBackgroundDecoration(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image(
                image: AssetImage("assets/images/logo.png"),
                height: 50,
                width: 120,
              ),
            ),
            GestureDetector(
              onTap: () {
                if (_prefs?.getInt(Const.customerId) != null) {
                  int? userId = _prefs?.getInt(Const.customerId);
                  Get.to(ProfileMain(userId.toString()));
                }else{
                  Get.to(LoginScreen());
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 5.0,
                      spreadRadius: 1.0,
                    )
                  ],
                ),
                child: FutureBuilder<String>(
                  future: _getImageUrl(),
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasError) {
                        return ClipOval(
                          child: CachedNetworkImage(
                            width: 45.0,
                            height: 45.0,
                            fit: BoxFit.fill,
                            imageUrl: "" ?? "",
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) => Image.asset(
                              "assets/images/hat-man.png",
                              width: 45.0,
                              height: 45.0,
                            ),
                            errorWidget: (context, url, error) => Image.asset(
                              "assets/images/hat-man.png",
                              width: 45.0,
                              height: 45.0,
                            ),
                          ),
                        );
                      } else {
                        return ClipOval(
                          child: CachedNetworkImage(
                            width: 45.0,
                            height: 45.0,
                            fit: BoxFit.fill,
                            imageUrl: snapshot.data! ?? "",
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) => Image.asset(
                              "assets/images/hat-man.png",
                              width: 45.0,
                              height: 45.0,
                            ),
                            errorWidget: (context, url, error) => Image.asset(
                              "assets/images/hat-man.png",
                              width: 45.0,
                              height: 45.0,
                            ),
                          ),
                        );
                      }
                    } else {
                      return ClipOval(
                        child: CachedNetworkImage(
                          width: 45.0,
                          height: 45.0,
                          fit: BoxFit.fill,
                          imageUrl: _prefs?.getString(Const.customerImage) ?? "",
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) => Image.asset(
                            "assets/images/hat-man.png",
                            width: 45.0,
                            height: 45.0,
                          ),
                          errorWidget: (context, url, error) => Image.asset(
                            "assets/images/hat-man.png",
                            width: 45.0,
                            height: 45.0,
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }

/*
  static void GetUserProfile(int? userId) async {

    String body = json.encode({
      'customer_id': userId
    });

    final response = await http.post(
      Uri.parse(ApiEndPoints.getProfile),
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    Map<String, dynamic> data = jsonDecode(response.body);
    if (data['status'] == "success") {
      liveImage=ApiEndPoints.imagePath+""+data['data']['profile_picture']?? "";
      _prefs?.setString(Const.customerImage,liveImage);

    } else {
    }
  }*/

  Future<String> _getImageUrl() async {
    _prefs = await SharedPreferences.getInstance();
    print("appbar page==>" +
        Const.customerId +
        "<===> " +
        _prefs!.getInt(Const.customerId).toString());

    String body = json
        .encode({'customer_id': _prefs!.getInt(Const.customerId).toString()});

    final response = await http.post(
      Uri.parse(ApiEndPoints.getProfile),
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['status'] == "success") {
        liveImage =
            ApiEndPoints.imagePath + "" + data['data']['profile_picture'] ?? "";
        _prefs?.setString(Const.customerImage, liveImage);
        return liveImage;
      } else {
        return liveImage;
      }
    } else {
      throw Exception('Failed to load image');
    }
  }
}
