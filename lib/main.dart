import 'dart:async';
import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:kirpix/HomeScreen.dart';
import 'package:kirpix/Utils/Constant/analytics_service.dart';
import 'package:kirpix/View/OnboardingPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'InternetConnection/ControllerBinding.dart';
import 'Utils/Constant/Const.dart';

// Global variables
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  importance: Importance.high,
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase once at the start
  try {
    await Firebase.initializeApp();
    print('✅ Firebase initialized successfully');
  } catch (e) {
    print('❌ Firebase initialization failed: $e');
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Kiprix',
      debugShowCheckedModeBanner: false,
      initialBinding: ControllerBinding(),
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'DMSans_Regular',
        textTheme: const TextTheme(titleMedium: TextStyle(fontSize: 14)),
        scaffoldBackgroundColor: const Color(0xFFFFFAEF),
        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1.5, color: Color(0xff7dca2e)),
            borderRadius: BorderRadius.circular(15.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1.5, color: Color(0xffdfe2e5)),
            borderRadius: BorderRadius.circular(15.0),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1.5, color: Color(0xfff44336)),
            borderRadius: BorderRadius.circular(15.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1.5, color: Color(0xfff44336)),
            borderRadius: BorderRadius.circular(15.0),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1.5, color: Color(0xffdfe2e5)),
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
      ),
      navigatorObservers: [AnalyticsService().getAnalyticObserver()],
      home: MyHomePage(),
    );
  }
}

// Background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message ${message.messageId}');

  // Show notification
  flutterLocalNotificationsPlugin.show(
    message.data.hashCode,
    message.data['title'],
    message.data['body'],
    NotificationDetails(
      android: AndroidNotificationDetails(
        channel.id,
        channel.name,
      ),
    ),
  );
}

class MyHomePage extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<MyHomePage> {
  static SharedPreferences? _prefs;

  static init(BuildContext context) async {
    _prefs = await SharedPreferences.getInstance();
    if (_prefs!.getInt(Const.customerId) != null) {
      Timer(
        Duration(seconds: 3),
            () => Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => HomeScreen(),
            settings: RouteSettings(name: 'HomePage'),
          ),
              (Route<dynamic> route) => false,
        ),
      );
    } else {
      Timer(
        Duration(seconds: 3),
            () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => OnboardingPage(),
            settings: RouteSettings(name: 'OnboardingPage'),
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    initializeApp();
  }

  Future<void> initializeApp() async {
    await initializeNotifications();
    await getToken();
    init(context);
  }

  Future<void> initializeNotifications() async {
    try {
      // Initialize local notifications
      var initialzationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
      var initializationSettings = InitializationSettings(android: initialzationSettingsAndroid);

      final DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings(
        defaultPresentAlert: true,
        requestAlertPermission: true,
      );

      var initializationSettingIOS = InitializationSettings(iOS: initializationSettingsDarwin);

      if (Platform.isAndroid) {
        await flutterLocalNotificationsPlugin.initialize(initializationSettings);
      } else {
        await flutterLocalNotificationsPlugin.initialize(initializationSettingIOS);
      }

      // Setup Firebase messaging
      await setupFirebaseMessaging();

    } catch (e) {
      print('Error initializing notifications: $e');
    }
  }

  Future<void> setupFirebaseMessaging() async {
    try {
      // Set background message handler
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      // Create notification channel for Android
      if (Platform.isAndroid) {
        await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
            ?.createNotificationChannel(channel);
      }

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;

        if (notification != null && android != null) {
          flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                icon: android.smallIcon,
              ),
            ),
          );
        }
      });

      // Request permissions
      if (Platform.isIOS) {
        await FirebaseMessaging.instance.requestPermission(
          alert: true,
          badge: true,
          sound: true,
        );
      }

    } catch (e) {
      print('Error setting up Firebase messaging: $e');
    }
  }

  Future<void> getToken() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = await FirebaseMessaging.instance.getToken();
      print("FCM Token: $token");

      if (token != null) {
        prefs.setString(Const.fBToken, token);
      }
    } catch (e) {
      print('Error getting FCM token: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    transform: Matrix4.translationValues(0, -20, 0),
                    child: Image.asset(
                      "assets/svg/circleanimation.gif",
                      height: 40,
                      width: 40,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 200),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    transform: Matrix4.translationValues(-20, 0, 0),
                    child: Image.asset(
                      "assets/svg/circleanimation.gif",
                      height: 40,
                      width: 40,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 300),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    transform: Matrix4.translationValues(20, 0, 0),
                    child: Image.asset(
                      "assets/svg/circleanimation.gif",
                      height: 40,
                      width: 40,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 100),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    transform: Matrix4.translationValues(-20, 0, 0),
                    child: Image.asset(
                      "assets/svg/circleanimation.gif",
                      height: 40,
                      width: 40,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Center(
            child: Image(
              image: AssetImage("assets/images/kiprix_full_logo.png"),
              height: 200,
              width: 200,
            ),
          ),
        ],
      ),
    );
  }
}