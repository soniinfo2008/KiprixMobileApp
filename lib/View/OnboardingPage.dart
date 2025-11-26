import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:http/http.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import '../Controller/OnboardingController.dart';
import '../HomeScreen.dart';
import '../Utils/Constant/AppTheme.dart';
import '../Widgets/ImageUtility.dart';
import 'LoginFlow/CreateAccount.dart';
import 'LoginFlow/LoginScreen.dart';

class OnboardingPage extends StatelessWidget {
  final OnboardingController _controller =Get.put(OnboardingController());

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[

            Obx(() {
              if (_controller.isLoading.value)
                return Center(child: CircularProgressIndicator());
              else {
                return PageView.builder(
                    controller: _controller.pageController,
                    onPageChanged: _controller.selectedPageIndex,
                    itemCount: _controller.onboardingPages.length,
                    itemBuilder: (context, index) {
                      return Container(
                        height: Get.height * 0.8,
                        child: Column(
                          children: [

                            SizedBox(height: 70),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),

                                child: Text(
                                  _controller.onboardingPages[index]
                                      .description,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 24,
                                      fontWeight: FontWeight.w700),

                                ),
                              ),
                            ),
                            SizedBox(height: 9),
                            Image.network(_controller.onboardingPages[index].imageAsset),


                          ],
                        ),
                      );
                    });
            }
            }),
            Padding(
              padding: const EdgeInsets.only(top:15.0,left: 15.0,right: 15.0),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image(image:AssetImage("assets/images/logo.png"),
                          height: 60,
                          width: 120,
                        ),
                        GestureDetector(
                          onTap: (){
                            Navigator.pushAndRemoveUntil(
                                context ,
                                MaterialPageRoute(builder: (BuildContext context) => HomeScreen(),settings: RouteSettings(name: 'HomePage')),
                                    (Route<dynamic> route) => false);
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
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              _controller.onboardingPages.length,
                                  (index) => Obx(() {
                                return Container(
                                  margin: const EdgeInsets.all(4),
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: _controller.selectedPageIndex.value == index
                                        ? AppTheme.apptheme_color
                                        : Colors.grey,
                                    shape: BoxShape.circle,
                                  ),
                                );
                              }),
                            ),
                          ),
                          SizedBox(height: 40,),
                          GestureDetector(
                            onTap: (){
                              Get.to(CreateAccount());
                            },
                            child: Container(
                              width: Get.width,
                              height: 50,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
                                    'Create an account',
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


                          SizedBox(height: 15,),
                          GestureDetector(
                            onTap: (){
                              Get.to(LoginScreen());
                            },
                            child: Container(
                              width: Get.width,
                              height: 50,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
                                    'Login',
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
          ],
        )
      ),

    );
  }






}



