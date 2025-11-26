
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kirpix/Model/BrandList.dart';
import 'package:http/http.dart'as http;
import 'package:kirpix/Model/CategoryList.dart';

import '../Utils/Constant/ApiConfig/ApiEndPoints.dart';
import '../Utils/Constant/AppTheme.dart';

class CategoryController extends GetxController{

  var nodata = false.obs;
  var isLoading = true.obs;
  var categoryList = <Category>[].obs;
  @override
  void onInit() {

    getData();
    super.onInit();
  }

  void getData() async {
    try {
      isLoading(true);
      var datas = await getCategory();
      if (datas != null) {

        categoryList.value=datas.data;
      }
    } finally {

      isLoading(false);
    }
  }

  getCategory() async {
    final uri = ApiEndPoints.categoryList;
    final response = await http.post(Uri.parse(uri));
    if (response.statusCode == 200) {
      nodata(false);
      return CategoryList.fromJson(jsonDecode(response.body));
    } else {
      nodata(true);
      // Get.snackbar("Exception...!", "Server Code:" +response.statusCode.toString(),snackPosition: SnackPosition.TOP,backgroundColor: AppTheme.apptheme_color.withOpacity(0.10),colorText: AppTheme.apptheme_color,borderColor:AppTheme.apptheme_color,borderWidth: 1,margin: EdgeInsets.only(bottom: 20,left: 10.0,right: 10.0));
      throw Exception('Failed to load data${response.statusCode}');
    }
  }


}