
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart'as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Model/HomeListModel.dart';
import '../Model/ShoppingFolderList.dart';
import '../Utils/Constant/ApiConfig/ApiEndPoints.dart';
import '../Utils/Constant/AppTheme.dart';
import '../Utils/Constant/Const.dart';
import '../View/ServerConnection.dart';
import 'ShoppingListAddController.dart';

class HomeController extends GetxController{
  ShoppingListAddController shoppingListAddController=Get.put(ShoppingListAddController());

  var isLoading = true.obs;
  var homeSliderList = <HomeSlider>[].obs;
  var homecustomImageadList = <SponsoredAd>[].obs;
  var trendingProduct = <TrendingProduct>[].obs;
  static SharedPreferences? _prefs;
  var isLoadingDetails = true.obs;
  var slFolderList = <SFolder>[].obs;
  var userName="".obs;



  static init() async {
    _prefs = await SharedPreferences.getInstance();

  }


  @override
  Future<void> onInit() async {
    _prefs = await SharedPreferences.getInstance();
    int? userId=_prefs!.getInt(Const.customerId);
    if (_prefs!.getInt(Const.customerId) != null) {
      getHomeFolderData(userId!);
      shoppingListAddController.getData(userId);
      getName();
    }else{
      userName.value="Hey, User";
    }
    getData();
    super.onInit();
  }

  void getData() async {
    try {
      isLoading(true);
      var homes = await getHData();
      if (homes != null) {
        homeSliderList.value=homes.data.sliders;
        trendingProduct.value=homes.data.trendingProducts;
        homecustomImageadList.value=homes.data.sponsoredAds;
      }
    } finally {
      isLoading(false);
    }
  }

  getHData() async {
    //trendingProductsLimit
    var map = new Map<String, dynamic>();
    map['trendingProductsLimit'] = "5";

    final uri = ApiEndPoints.homeListData;
    final response = await http.post(Uri.parse(uri),body: map);
    if (response.statusCode == 200) {
      return HomeListModel.fromJson(jsonDecode(response.body));
    } else {
      Get.to(ServerConnection());
      Get.snackbar("Sorry...!", "No data found...!",snackPosition: SnackPosition.TOP,backgroundColor: AppTheme.apptheme_color.withOpacity(0.10),colorText: AppTheme.apptheme_color,borderColor:AppTheme.apptheme_color,borderWidth: 1,margin: EdgeInsets.only(bottom: 20,left: 10.0,right: 10.0));
      throw Exception('Failed to load data${response.statusCode}');
    }
  }

  void getHomeFolderData(int id) async {

    try {
      isLoading(true);
      var sfl = await getHSDetails(id);
      if (sfl != null) {
        slFolderList.value=sfl.data;

      }
    } finally {
      isLoading(false);
    }
  }

  //getList
  getHSDetails(int userId) async {
    var map = new Map<String, dynamic>();
    map['customer_id'] = userId.toString();


    final uri = ApiEndPoints.shoppingList;
    final response = await http.post(Uri.parse(uri), body: map);
    if (response.statusCode == 200) {
      return ShoppingFolderList.fromJson(jsonDecode(response.body));
    } else {
      //Get.snackbar("Exception...!", "Server Code:" +response.statusCode.toString(),snackPosition: SnackPosition.TOP,backgroundColor: AppTheme.apptheme_color.withOpacity(0.10),colorText: AppTheme.apptheme_color,borderColor:AppTheme.apptheme_color,borderWidth: 1,margin: EdgeInsets.only(bottom: 20,left: 10.0,right: 10.0));
      throw Exception('Failed to load data${response.statusCode}');
    }
  }

  getName() async {
    _prefs = await SharedPreferences.getInstance();

    String body = json
        .encode({'customer_id': _prefs!.getInt(Const.customerId).toString()});

    final response = await http.post(
      Uri.parse(ApiEndPoints.getProfile),
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['status'] == "success") {
        userName.value = "Hey, "+data['data']['prefered_name'] ?? "User";

      } else {
      }
    } else {
      throw Exception('Failed to load image');
    }
  }


}