
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kirpix/Model/BrandList.dart';
import 'package:http/http.dart'as http;
import '../Model/CustomSearchModelList.dart';
import '../Model/SearchAdd.dart';
import '../Utils/Constant/ApiConfig/ApiEndPoints.dart';
import '../Utils/Constant/AppTheme.dart';

class CustomSearchController extends GetxController{

  var isLoading = true.obs;
  var issecLoading = true.obs;
  var isData = true.obs;
  var brandList = <SearchBrand>[].obs;
  var categoriesList = <SearchBrand>[].obs;
  var subcategoriesList = <SearchBrand>[].obs;
  var productsList = <Product>[].obs;
  var addsdataList = <Addata>[].obs;
  @override
  void onInit() {

    getcontains();
    super.onInit();
  }

  void getData(String type) async {
    try {
      isLoading(true);
      var search = await getSearch(type);
      if (search != null) {
        brandList.value=search.results.brands;
        categoriesList.value=search.results.categories;
        subcategoriesList.value=search.results.subcategories;
        productsList.value=search.results.products;

      }
    } finally {
      isLoading(false);
    }
  }

  getSearch(String type) async {
    var map = new Map<String, dynamic>();
    map['search_text'] = type;

    final uri = ApiEndPoints.globalSearch;
    final response = await http.post(Uri.parse(uri), body: map);


    if (response.statusCode == 200) {
      isData(true);
      return CustomSearchModelList.fromJson(jsonDecode(response.body));
    } else {
      isData(false);
      //Get.snackbar("Exception...!", "Server Code:" +response.statusCode.toString(),snackPosition: SnackPosition.TOP,backgroundColor: AppTheme.apptheme_color.withOpacity(0.10),colorText: AppTheme.apptheme_color,borderColor:AppTheme.apptheme_color,borderWidth: 1,margin: EdgeInsets.only(bottom: 20,left: 10.0,right: 10.0));
      throw Exception('Failed to load data${response.statusCode}');
    }
  }



  void getcontains() async {
    try {
      issecLoading(true);
      var search = await getSearchAdd();
      if (search != null) {
        addsdataList.value=search.data;


      }
    } finally {
      issecLoading(false);
    }
  }

  getSearchAdd() async {

    final uri = ApiEndPoints.globalSearchAdds;
    final response = await http.post(Uri.parse(uri));


    if (response.statusCode == 200) {
      return SearchAdd.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load data${response.statusCode}');
    }
  }

}