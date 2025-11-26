
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart'as http;
import 'package:kirpix/Model/FaqModelList.dart';
import '../Utils/Constant/ApiConfig/ApiEndPoints.dart';
import '../Utils/Constant/AppTheme.dart';

class FaqController extends GetxController{

  var isLoading = true.obs;
  var faqList = <FAQList>[].obs;
  @override
  void onInit() {

    getData();
    super.onInit();
  }

  void getData() async {
    try {
      isLoading(true);
      var FAQ = await getFAQZ();
      if (FAQ != null) {
        faqList.value=FAQ.data;

      }
    } finally {
      isLoading(false);
    }
  }

  getFAQZ() async {
    final uri = ApiEndPoints.faq;
    final response = await http.post(Uri.parse(uri));
    if (response.statusCode == 200) {
      return FaqModelList.fromJson(jsonDecode(response.body));
    } else {
      Get.snackbar("Sorry...!", "No data found...!",snackPosition: SnackPosition.TOP,backgroundColor: AppTheme.apptheme_color.withOpacity(0.10),colorText: AppTheme.apptheme_color,borderColor:AppTheme.apptheme_color,borderWidth: 1,margin: EdgeInsets.only(bottom: 20,left: 10.0,right: 10.0));
      throw Exception('Failed to load data${response.statusCode}');
    }
  }


}