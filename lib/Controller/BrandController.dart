
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kirpix/Model/BrandList.dart';
import 'package:http/http.dart'as http;
import '../Utils/Constant/ApiConfig/ApiEndPoints.dart';
import '../Utils/Constant/AppTheme.dart';

class BrandController extends GetxController{

  var noData = false.obs;
  var isLoading = true.obs;
  var brandList = <Brand>[].obs;
  @override
  void onInit() {

    getData();
    super.onInit();
  }

  void getData() async {
    try {
      isLoading(true);
      var brands = await getBrand();
      if (brands != null) {

        brandList.value=brands.data;

      }
    } finally {
      isLoading(false);
    }
  }

  getBrand() async {
    final uri = ApiEndPoints.brandList;
    final response = await http.post(Uri.parse(uri));
    if (response.statusCode == 200) {
      noData(false);
      return BrandList.fromJson(jsonDecode(response.body));
    } else {
      noData(true);
      Get.snackbar("Sorry...!", "No data found..!",snackPosition: SnackPosition.TOP,backgroundColor: AppTheme.apptheme_color.withOpacity(0.10),colorText: AppTheme.apptheme_color,borderColor:AppTheme.apptheme_color,borderWidth: 1,margin: EdgeInsets.only(bottom: 20,left: 10.0,right: 10.0));
      throw Exception('Failed to load data${response.statusCode}');
    }
  }

/*  getBrand() {

    final body = {
      "device_id": reg_id
    };
    final jsonString = json.encode(body);
    final uri = ApiEndPoints.Achivevment;

    final response = await http.post(Uri.parse(uri), body: jsonString);
    if (response.statusCode == 200) {
      return AchievementList.fromJson(jsonDecode(response.body));
    } else{
      Get.snackbar("Exception...!", "Server Status:" +response.statusCode.toString(),snackPosition: SnackPosition.TOP,backgroundColor: Colors.white,colorText: AppTheme.apptheme_color);
      throw Exception('Failed to load data${response.statusCode}');
    }

  }*/
}