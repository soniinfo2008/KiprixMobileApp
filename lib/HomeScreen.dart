import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:kirpix/AppBars.dart';
import 'package:kirpix/DrawerPages/ComparWithKiprix.dart';
import 'package:kirpix/DrawerPages/MainHome.dart';
import 'package:kirpix/Utils/Constant/AppTheme.dart';
import 'package:kirpix/DrawerPages/ProfilePage.dart';
import 'package:kirpix/Widgets/Shadow.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'DrawerPages/ShoppingListPage.dart';
import 'InternetConnection/ConnectionManagerController.dart';
import 'Utils/Constant/analytics_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ConnectionManagerController connectionManagerController = Get.put(ConnectionManagerController());
  static bool _navigationStatus = false;
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static List pageName = ['Home Page', 'kiprix', 'shopping List', 'More'];

  // Refresh controllers for each page
  final RefreshController homeRefreshController = RefreshController();
  final RefreshController kiprixRefreshController = RefreshController();
  final RefreshController shoppingRefreshController = RefreshController();
  final RefreshController profileRefreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    analytics.setAnalyticsCollectionEnabled(true);
  }

  int pageIndex = 0;

  // Wrap each page with RefreshIndicator
  final List<Widget> pages = [
    RefreshIndicator(
      child: const MainHome(),
      onRefresh: () async {
        // Add your refresh logic for MainHome here
        await Future.delayed(const Duration(seconds: 2));
        // You can call methods to refresh MainHome data here
      },
    ),
    RefreshIndicator(
      child: const ComparwithKiprix(),
      onRefresh: () async {
        // Add your refresh logic for ComparwithKiprix here
        await Future.delayed(const Duration(seconds: 2));
        // You can call methods to refresh ComparwithKiprix data here
      },
    ),
    RefreshIndicator(
      child: const ShoppingListPage(),
      onRefresh: () async {
        // Add your refresh logic for ShoppingListPage here
        await Future.delayed(const Duration(seconds: 2));
        // You can call methods to refresh ShoppingListPage data here
      },
    ),
    RefreshIndicator(
      child: const ProfilePage(),
      onRefresh: () async {
        // Add your refresh logic for ProfilePage here
        await Future.delayed(const Duration(seconds: 2));
        // You can call methods to refresh ProfilePage data here
      },
    ),
  ];

  // Alternative approach using GlobalKey for each page if you need more control
  final GlobalKey<RefreshIndicatorState> homeRefreshKey = GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> kiprixRefreshKey = GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> shoppingRefreshKey = GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> profileRefreshKey = GlobalKey<RefreshIndicatorState>();

  Padding buildMyNavBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0, 0.0, 0.0),
      child: Container(
        height: 80,
        decoration: CustomDecorations().BackgroundDecorationwithRedius(),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  IconButton(
                      enableFeedback: false,
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onPressed: () {
                        analytics.logEvent(
                          name: 'pages_tracked',
                          parameters: {
                            'page_name': pageName[0],
                          },
                        );
                        setState(() {
                          pageIndex = 0;
                        });
                      },
                      icon: pageIndex == 0
                          ? SvgPicture.asset(
                        'assets/svg/Home.svg',
                        color: AppTheme.apptheme_color,
                        height: 24,
                        width: 24,
                      )
                          : SvgPicture.asset(
                        'assets/svg/Homegray.svg',
                        color: AppTheme.dark_font_secondary,
                        height: 24,
                        width: 24,
                      )),
                  Text(
                    "Home",
                    style: TextStyle(
                      color: pageIndex == 0
                          ? AppTheme.apptheme_color
                          : AppTheme.dark_font_secondary,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  IconButton(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      enableFeedback: false,
                      onPressed: () {
                        analytics.logEvent(
                          name: 'pages_tracked',
                          parameters: {
                            'page_name': pageName[1],
                          },
                        );
                        setState(() {
                          pageIndex = 1;
                        });
                      },
                      icon: pageIndex == 1
                          ? Image.asset(
                        'assets/images/logopreview_apptheme.png',
                        height: 24,
                        width: 24,
                      )
                          : Image.asset(
                        'assets/images/logopreview_gray.png',
                        height: 24,
                        width: 24,
                      )),
                  Text(
                    "Kiprix",
                    style: TextStyle(
                      color: pageIndex == 1
                          ? AppTheme.apptheme_color
                          : AppTheme.dark_font_secondary,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),


              Column(
                children: [
                  IconButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    enableFeedback: false,


                    onPressed: () {
                      analytics.logEvent(
                        name: 'pages_tracked',
                        parameters: {
                          'page_name': pageName[2],
                        },
                      );
                      setState(() {
                        pageIndex = 2;
                      });
                    },
                    icon: pageIndex == 2
                        ? SvgPicture.asset(
                      'assets/svg/Heart.svg',
                      color: AppTheme.apptheme_color,
                      height: 24,
                      width: 24,
                    )
                        : SvgPicture.asset(
                      'assets/svg/Heart.svg',
                      color: AppTheme.dark_font_secondary,
                      height: 24,
                      width: 24,
                    ),
                  ),
                  Text(
                    "Shopping List",
                    style: TextStyle(
                      color: pageIndex == 2
                          ? AppTheme.apptheme_color
                          : AppTheme.dark_font_secondary,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  IconButton(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      enableFeedback: false,
                      onPressed: () {
                        analytics.logEvent(
                          name: 'pages_tracked',
                          parameters: {
                            'page_name': pageName[3],
                          },
                        );
                        setState(() {
                          pageIndex = 3;
                        });
                      },
                      icon: pageIndex == 3
                          ? SvgPicture.asset(
                        'assets/svg/Category.svg',
                        color: AppTheme.apptheme_color,
                        height: 24,
                        width: 24,
                      )
                          : SvgPicture.asset(
                        'assets/svg/Category_gray.svg',
                        color: AppTheme.dark_font_secondary,
                        height: 24,
                        width: 24,
                      )),
                  Text(
                    "More",
                    style: TextStyle(
                      color: pageIndex == 3
                          ? AppTheme.apptheme_color
                          : AppTheme.dark_font_secondary,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  late DateTime currentBackPressTime;

  Future<void> checkForUpdate() async {
    try {
      await InAppUpdate.checkForUpdate();
      // If no exception is thrown, an update is available.
      print('Update available.');
      performUpdate();
    } on PlatformException catch (e) {
      if (e.code == 'UPDATE_NOT_AVAILABLE') {
        // No update is available.
        print('No update available.');
      } else {
        // Handle other exceptions.
        print('Error checking for update: $e');
      }
    }
  }

  // Method to handle refresh for each page
  Future<void> _handleRefresh(int pageIndex) async {
    switch (pageIndex) {
      case 0: // Home Page
        analytics.logEvent(name: 'refresh_home_page');
        // Add your Home page refresh logic here
        await Future.delayed(const Duration(seconds: 2));
        break;
      case 1: // Kiprix Page
        analytics.logEvent(name: 'refresh_kiprix_page');
        // Add your Kiprix page refresh logic here
        await Future.delayed(const Duration(seconds: 2));
        break;
      case 2: // Shopping List Page
        analytics.logEvent(name: 'refresh_shopping_page');
        // Add your Shopping List page refresh logic here
        await Future.delayed(const Duration(seconds: 2));
        break;
      case 3: // Profile Page
        analytics.logEvent(name: 'refresh_profile_page');
        // Add your Profile page refresh logic here
        await Future.delayed(const Duration(seconds: 2));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    checkForUpdate();
    return Scaffold(
      backgroundColor: AppTheme.back_color,
      appBar: AppBars(title: ''),
      body: DoubleBackToCloseApp(
        snackBar: const SnackBar(
          content: Text('Tap back again to leave'),
        ),
        child: Obx(
              () => connectionManagerController.connectionType.value == 0
              ? Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/images/no_internet_connection.jpg"),
                Text(
                  'No internet connection',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: AppTheme.dark_font_color,
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                ),
                Text(
                  'Check your connection than refresh the page.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: AppTheme.dark_font_secondary,
                      fontSize: 16,
                      fontWeight: FontWeight.w400),
                ),
                const SizedBox(height: 20),
              ],
            ),
          )
              : RefreshIndicator(
            onRefresh: () => _handleRefresh(pageIndex),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: MediaQuery.of(context).size.height -
                    kToolbarHeight - // AppBar height
                    80 - // Bottom navigation bar height
                    MediaQuery.of(context).padding.top - // Status bar
                    MediaQuery.of(context).padding.bottom, // Bottom padding
                child: pages[pageIndex],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: buildMyNavBar(context),
    );
  }

  Future<void> performUpdate() async {
    try {
      await InAppUpdate.performImmediateUpdate();
    } catch (e) {
      print('Error performing update: $e');
    }
  }
}

class RefreshController {}

class UpdateDialog extends StatelessWidget {
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
              "Update",
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
              "Kiprix advises that you upgrade to the latest version. You can continue shopping within the application while the updating process takes place.",
              style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.dark_font_color),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 17.0, right: 17.0, bottom: 17.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: SizedBox(),
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                        // performUpdate();
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Update',
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