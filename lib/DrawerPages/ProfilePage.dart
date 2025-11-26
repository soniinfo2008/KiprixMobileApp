import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:kirpix/View/LoginFlow/AboutPage.dart';
import 'package:kirpix/View/LoginFlow/LoginScreen.dart';
import 'package:kirpix/View/LoginFlow/PrivacyPolicy.dart';
import 'package:kirpix/View/LoginFlow/ResetPassword.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../AppBarWithBack.dart';
import '../Controller/HomeController.dart';
import '../Utils/Constant/AppTheme.dart';
import '../Utils/Constant/Const.dart';
import '../View/Event/EventPage.dart';
import '../View/Setting/Contactpage.dart';
import '../View/Setting/CreateNewPassword.dart';
import '../View/Setting/FaqPage.dart';
import '../View/Setting/MemberList.dart';
import '../View/Setting/ProfileMain.dart';
import '../Widgets/Shadow.dart';
import 'ShoppingListPage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

SharedPreferences? _prefs;
PackageInfo _packageInfo = PackageInfo(
  appName: 'Unknown',
  packageName: 'Unknown',
  version: 'Unknown',
  buildNumber: 'Unknown',
  buildSignature: 'Unknown',
);





class _ProfilePageState extends State<ProfilePage> {
  HomeController homeController = Get.put(HomeController());


  @override
  void initState() {
           getData();
    super.initState();
  }
  static init() async {
    _prefs = await SharedPreferences.getInstance();
  }



  @override
  Widget build(BuildContext context) {
    init();
    return Scaffold(
        backgroundColor: AppTheme.back_color,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Account",
                    style: TextStyle(
                        color: AppTheme.dark_font_secondary,
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                Container(
                    width: Get.width,
                    height: 255,
                    decoration:
                        CustomDecorations().BackgroundDecorationwithRadiusTen(),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            if (_prefs?.getInt(Const.customerId) != null) {
                              int? userId = _prefs?.getInt(Const.customerId);
                              Get.to(ProfileMain(userId.toString()));
                            } else {
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return CustomDialog(
                                        "Please log in if you wish to view or edit your profile");
                                  });
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(13.0),
                            child: Row(
                              children: [
                                Row(
                                  children: <Widget>[
                                    Container(
                                      child: SvgPicture.asset(
                                        'assets/svg/user.svg',
                                        height: 24.0,
                                        width: 24.0,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      child: Text(
                                        'Profile',
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
                            if (_prefs?.getInt(Const.customerId) != null) {
                              int? userId = _prefs?.getInt(Const.customerId);
                              Get.to(MemberList(userId.toString()));
                            } else {
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return CustomDialog(
                                        "Please log in if you wish to add family member.");
                                  });
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(13.0),
                            child: Row(
                              children: [
                                Row(
                                  children: <Widget>[
                                    Container(
                                      child: SvgPicture.asset(
                                        'assets/svg/usertag.svg',
                                        height: 24.0,
                                        width: 24.0,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      child: Text(
                                        'Member',
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
                            Get.to(EventPage());
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(13.0),
                            child: Row(
                              children: [
                                Row(
                                  children: <Widget>[
                                    Container(
                                      child: SvgPicture.asset(
                                        'assets/svg/usertag.svg',
                                        height: 24.0,
                                        width: 24.0,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      child: Text(
                                        'Event',
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
                            if (_prefs?.getInt(Const.customerId) != null) {
                              int? userId = _prefs?.getInt(Const.customerId);
                              Get.to(CreateNewPassword(userId.toString()));
                            } else {
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return CustomDialog(
                                        "Please log in if you want reset password.");
                                  });
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(13.0),
                            child: Row(
                              children: [
                                Row(
                                  children: <Widget>[
                                    Container(
                                      child: SvgPicture.asset(
                                        'assets/svg/lock.svg',
                                        height: 24.0,
                                        width: 24.0,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      child: Text(
                                        'Reset-password',
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
                            Get.to(PrivacyPolicy());
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(13.0),
                            child: Row(
                              children: [
                                Row(
                                  children: <Widget>[
                                    Container(
                                      child: SvgPicture.asset(
                                        'assets/svg/info.svg',
                                        height: 24.0,
                                        width: 24.0,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      child: Text(
                                        'Privacy policy',
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
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Kiprix",
                    style: TextStyle(
                        color: AppTheme.dark_font_secondary,
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                Container(
                    width: Get.width,
                    height: 205,
                    decoration:
                        CustomDecorations().BackgroundDecorationwithRadiusTen(),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(13.0),
                          child: InkWell(
                            onTap: () {
                              Get.to(AboutPage());
                            },
                            child: Row(
                              children: [
                                Row(
                                  children: <Widget>[
                                    Container(
                                      child: Image.asset(
                                        'assets/images/appicon.png',
                                        height: 24.0,
                                        width: 24.0,
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
                                                fontWeight: FontWeight.w600,
                                                fontFamily: 'DMSans_Regular',
                                                color:
                                                    AppTheme.dark_font_color),
                                            text: "About "),
                                        TextSpan(
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'DMSans_Regular',
                                              color: AppTheme.apptheme_color),
                                          text: "Kiprix",
                                        ),
                                      ])),
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
                        InkWell (
                          onTap: () {
                            Get.to(FAQPage());
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(13.0),
                            child: Row(
                              children: [
                                Row(
                                  children: <Widget>[
                                    Container(
                                      child: SvgPicture.asset(
                                        'assets/svg/book1.svg',
                                        height: 24.0,
                                        width: 24.0,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      child: Text(
                                        'FAQ',
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
                        InkWell (
                          onTap: () {
                            Get.to(ContactPage());
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(13.0),
                            child: Row(
                              children: [
                                Row(
                                  children: <Widget>[
                                    Container(
                                      child: Image.asset(
                                        'assets/images/support.png',
                                        height: 24.0,
                                        width: 24.0,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      child: Text(
                                        'Contact Us',
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
                            {
                              if (_prefs?.getInt(Const.customerId) !=
                                  null) {
                                // int? userId = _prefs?.getInt(Const.customerId);
                                showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return LogoutDialog();
                                    });
                              } else {
                                Navigator.of(context).pushReplacement(MaterialPageRoute(
                                    builder: (BuildContext context) => LoginScreen()));
                              }
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(13.0),
                            child: Row(
                              children: [
                                Row(
                                  children: <Widget>[
                                    Container(
                                      child: SvgPicture.asset(
                                        'assets/svg/logout.svg',
                                        height: 24.0,
                                        width: 24.0,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      child: Text(
                                        _prefs?.getInt(Const.customerId) != null?'Logout':'Login',
                                        style: TextStyle(
                                            color: AppTheme.danger_,
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
        ),
        bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
              'version ${_packageInfo.version}(${_packageInfo.buildNumber})',
              style: TextStyle(
                  color: AppTheme.dark_font_secondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
          ),
            ),
      ]
        ),
    );
  }

  Future<void> getData() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });


  }

/* showAlertDialog(BuildContext context) {

    // set up the button
    Widget yesButton = TextButton(
      child: Text("Yes"),
      onPressed: () async {
        // SharedPreferences prefs = await SharedPreferences.getInstance();
        // prefs.clear();

        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) =>LoginScreen()
        ));
      },
    );
    Widget noButton = TextButton(
      child: Text("No"),
      onPressed:  () {
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Logout"),
      content: Text("Do you want to Logout this application?"),
      actions: [
        yesButton,
        noButton
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }*/
}

class LogoutDialog extends StatelessWidget {
  HomeController homeController=Get.put(HomeController());
  dialogContent(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: const Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // To make the card compact
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(17.0),
            child: Text(
              "Logout",
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Divider(
            height: 0.8,
            thickness: 0.9,
            indent: 1,
            color: AppTheme.grayText,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Are you sure you want to Logout",
              style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.dark_font_color),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 17.0, right: 17.0, bottom: 17.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 0.50, color: Color(0xFFDFE2E5)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Cancel',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF484848),
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      color: Colors.red,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 0.50, color: Color(0xFFDFE2E5)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        _prefs!.clear();
                        homeController.userName.value="Hey, User";
                        Navigator.of(context).pop();
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (BuildContext context) => LoginScreen()));
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Logout',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }
}
