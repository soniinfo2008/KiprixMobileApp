import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:get/utils.dart';
import 'package:http/http.dart' as http;
import 'package:kirpix/Utils/Constant/Const.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Model/MemberListModel.dart';
import '../Model/ShoppingFolderList.dart';
import '../Utils/Constant/ApiConfig/ApiEndPoints.dart';
import '../Utils/Constant/AppTheme.dart';


class ShoppingListAddController extends GetxController {

  var isLoading = true.obs;
  var isLoadingDetails = true.obs;
  var slFolderList = <SFolder>[].obs;
  var noDataFlag = false.obs;
  var mmList = <Member>[].obs;
  static SharedPreferences? _prefs;


  @override
  void onInit() {

    super.onInit();
  }

  void getData(int id) async {
    getMemberData(id.toString());
    try {
      isLoading(true);
      var sfl = await getSFDetails(id);
      if (sfl != null) {
        slFolderList.value=sfl.data;

      }
    } finally {
      isLoading(false);
    }
  }



  //getList
  getSFDetails(int userId) async {
    var map = new Map<String, dynamic>();
    map['customer_id'] = userId.toString();


    final uri = ApiEndPoints.shoppingList;
    final response = await http.post(Uri.parse(uri), body: map);
    if (response.statusCode == 200) {
      noDataFlag(false);
      return ShoppingFolderList.fromJson(jsonDecode(response.body));

    } else {
       noDataFlag(true);
     // Get.snackbar("Exception...!", "Server Code:" +response.statusCode.toString(),snackPosition: SnackPosition.TOP,backgroundColor: AppTheme.apptheme_color.withOpacity(0.10),colorText: AppTheme.apptheme_color,borderColor:AppTheme.apptheme_color,borderWidth: 1,margin: EdgeInsets.only(bottom: 20,left: 10.0,right: 10.0));
      throw Exception('Failed to load data${response.statusCode}');
    }
  }


  void getMemberData(String userId) async {
    try {
      isLoadingDetails(true);
      var mList = await getList(userId);
      if (mList != null) {
        mmList.value=mList.data;

      }
    } finally {
      isLoadingDetails(false);
    }
  }


  getList(String userId) async {

    var map = new Map<String, dynamic>();
    map['customer_id'] = userId;

    final uri = ApiEndPoints.memberList;
    final response = await http.post(Uri.parse(uri),body: map);
    Map<String, dynamic> data = jsonDecode(response.body);
    if (response.statusCode==200) {
      if (data['status'] == "success") {
        // nodata(false);
        return MemberListModel.fromJson(jsonDecode(response.body));
      }else {
        //nodata(true);
      }
    } else {

      Get.snackbar(data['status'], data['message'],snackPosition: SnackPosition.TOP,backgroundColor: AppTheme.apptheme_color.withOpacity(0.10),colorText: AppTheme.apptheme_color,borderColor:AppTheme.apptheme_color,borderWidth: 1,margin: EdgeInsets.only(bottom: 20,left: 10.0,right: 10.0));
      throw Exception('Failed to load data${response.statusCode}');
    }
  }

  void reorderList(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = slFolderList.removeAt(oldIndex);
    slFolderList.insert(newIndex, item);
    update(); // Make sure to call update to rebuild the UI
  }

}