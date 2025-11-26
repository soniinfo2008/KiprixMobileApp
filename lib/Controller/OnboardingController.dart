import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:get/utils.dart';
import 'package:http/http.dart' as http;
import '../Model/OnboardingInfo.dart';
import '../Utils/Constant/ApiConfig/ApiEndPoints.dart';
import '../Utils/Constant/AppTheme.dart';
import '../Widgets/ImageUtility.dart';

class OnboardingController extends GetxController {
  var selectedPageIndex = 0.obs;
  var isLoading = true.obs;
  var onboardingPages = <OnboardingInfo>[].obs;

  bool get isLastPage => selectedPageIndex.value == onboardingPages.length - 1;
  var pageController = PageController();

  forwardAction() {
    if (isLastPage) {
      //go to home page
    } else
      pageController.nextPage(duration: 300.milliseconds, curve: Curves.ease);
  }

  @override
  void onInit() {
    getMainData();
    super.onInit();
  }

  getMainData() async {
    final uri = ApiEndPoints.onBordingScreenList;
    final response = await http.post(Uri.parse(uri));
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      var decodedResponse = data['data'];
      onboardingPages.add(OnboardingInfo(ImageUtility.ImageUrl(data['data'][0]['image_name']), data['data'][0]['image_title']));
      onboardingPages.add(OnboardingInfo(ImageUtility.ImageUrl(data['data'][1]['image_name']), data['data'][1]['image_title']));
      onboardingPages.add(OnboardingInfo(ImageUtility.ImageUrl(data['data'][2]['image_name']), data['data'][2]['image_title']));
      update();
      isLoading(false);
    } else {
      Get.snackbar(
          "Sorry...!", "No data found",
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppTheme.apptheme_color.withOpacity(0.10),
          colorText: AppTheme.apptheme_color,
          borderColor: AppTheme.apptheme_color,
          borderWidth: 1,
          margin: EdgeInsets.only(bottom: 20, left: 10.0, right: 10.0));
      throw Exception('Failed to load data${response.statusCode}');
    }
  }
}
