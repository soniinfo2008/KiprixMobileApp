
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kirpix/Model/BrandList.dart';
import 'package:http/http.dart'as http;
import '../Model/MemberListModel.dart';
import '../Utils/Constant/ApiConfig/ApiEndPoints.dart';
import '../Utils/Constant/AppTheme.dart';

class MemberController extends GetxController{

  var isLoading = true.obs;
  var nodata = false.obs;
  var mmList = <Member>[].obs;
  @override
  void onInit() {

    super.onInit();
  }

  void getData(String userId) async {
    mmList.clear();
    try {
      isLoading(true);
      var mList = await getList(userId);
      if (mList != null) {
        mmList.value=mList.data;

      }
    } finally {
      isLoading(false);
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

  deleteMember(String userId, int memberId) async {
    var map = new Map<String, dynamic>();
    map['customer_id'] = userId.toString();
    map['member_id'] = memberId.toString();


    final uri = ApiEndPoints.deleteMember;
    final response = await http.post(Uri.parse(uri), body: map);
    Map<String, dynamic> data = jsonDecode(response.body);
    if (response.statusCode==200) {

      getData(userId);
      Get.snackbar("success", data['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppTheme.apptheme_color.withOpacity(0.10),
          colorText: AppTheme.apptheme_color,
          borderColor: AppTheme.apptheme_color,
          borderWidth: 1,
          margin: EdgeInsets.only(bottom: 20, left: 10.0, right: 10.0));
    } else {
      Get.snackbar("Sorry...!", "No data found...!",snackPosition: SnackPosition.TOP,backgroundColor: AppTheme.apptheme_color.withOpacity(0.10),colorText: AppTheme.apptheme_color,borderColor:AppTheme.apptheme_color,borderWidth: 1,margin: EdgeInsets.only(bottom: 20,left: 10.0,right: 10.0));
      throw Exception('Failed to load data${response.statusCode}');
    }
  }

}