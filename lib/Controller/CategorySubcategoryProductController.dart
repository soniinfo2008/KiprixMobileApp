
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kirpix/Model/BrandList.dart';
import 'package:http/http.dart'as http;
import 'package:kirpix/Model/CategoryList.dart';

import '../Model/CategorySubcategoryProductList.dart';
import '../Utils/Constant/ApiConfig/ApiEndPoints.dart';
import '../Utils/Constant/AppTheme.dart';

class CategorySubcategoryProductController extends GetxController{

  var isLoading = true.obs;
  var noDataFlag = false.obs;
  var productList = <ScProduct>[].obs;
  var min=0.obs;
  var max=0.obs;


  @override
  void onInit() {
    super.onInit();
  }

  void getData(String categoryID, String subCategoryID, String brandId,String minvalue,String maxvalue,String orderby) async {
    try {
      productList.clear();
      isLoading(true);
      var datas = await getProduct(categoryID,subCategoryID,brandId,minvalue,maxvalue,orderby);
      if (datas != null) {
        productList.value=datas.data;
        min.value=datas.min;
        max.value=datas.maxPrice;
        print("zdfdf--> "+productList.length.toString());
      }
    } finally {
      isLoading(false);
    }
  }

  getProduct(String categoryID,String subCategoryID ,String brandId,String min,String max,String orderby) async {

    var map = new Map<String, dynamic>();
    map['customer_latitude'] = '';
    map['customer_longitude'] = '';
    map['category_id'] = categoryID;
    map['sub_category_id'] = subCategoryID;
    map['min_price'] = min;
    map['max_price'] = max;
    map['brand_id'] = '';
    map['vendor_id'] = brandId;//shopId
    map['order_by'] = orderby;


    final uri = ApiEndPoints.csProductList;


    final response = await http.post(Uri.parse(uri), body: map);
    if (response.statusCode == 200) {
      return CategorySubcategoryProductList.fromJson(jsonDecode(response.body));
    } else {
      noDataFlag(true);
      Get.snackbar("Sorry...!", "No data found...!",snackPosition: SnackPosition.TOP,backgroundColor: AppTheme.apptheme_color.withOpacity(0.10),colorText: AppTheme.apptheme_color,borderColor:AppTheme.apptheme_color,borderWidth: 1,margin: EdgeInsets.only(bottom: 20,left: 10.0,right: 10.0));
      throw Exception('Failed to load data${response.statusCode}');
    }
  }


}