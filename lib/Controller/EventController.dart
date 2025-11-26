
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart'as http;

import '../Model/EventDetailsList.dart';
import '../Model/EventList.dart';
import '../Utils/Constant/ApiConfig/ApiEndPoints.dart';
import '../Utils/Constant/AppTheme.dart';

class EventController extends GetxController{

  var isLoading = true.obs;
  var isLoadingDetails = true.obs;
  var evList = <Event>[].obs;
  @override
  void onInit() {

    getData("","");
    super.onInit();
  }

  void getData(String flag,String selectedDate) async {
    try {
      isLoading(true);
      evList.clear();
      var brands = await getEvent(flag,selectedDate);
      if (brands != null) {
        evList.value=brands.data;

      }
    } finally {
      isLoading(false);
    }
  }

  getEvent(String flag,String selectedDate) async {
    print("flag=>"+flag);
    print("selectedDate=>"+selectedDate);
    var map = new Map<String, dynamic>();
    map['flag'] =flag;
    map['selected_date'] = selectedDate;

    final uri = ApiEndPoints.eventList;
    final response = await http.post(Uri.parse(uri),body: map);
    if (response.statusCode == 200) {
      return EventList.fromJson(jsonDecode(response.body));
    } else {
      Get.snackbar("", "There are no events scheduled for that date.",snackPosition: SnackPosition.TOP,backgroundColor: AppTheme.apptheme_color.withOpacity(0.10),colorText: AppTheme.apptheme_color,borderColor:AppTheme.apptheme_color,borderWidth: 1,margin: EdgeInsets.only(bottom: 20,left: 10.0,right: 10.0));
      throw Exception('Failed to load data${response.statusCode}');
    }
  }

  getEventDetails(int eventId) async {
    var map = new Map<String, dynamic>();
    map['event_id'] = eventId.toString();

    final uri = ApiEndPoints.eventDetails;
    final response = await http.post(Uri.parse(uri), body: map);
    if (response.statusCode == 200) {
      return EventDetailsList.fromJson(jsonDecode(response.body));
    } else {
      Get.snackbar("", "There are no events scheduled for that date.",snackPosition: SnackPosition.TOP,backgroundColor: AppTheme.apptheme_color.withOpacity(0.10),colorText: AppTheme.apptheme_color,borderColor:AppTheme.apptheme_color,borderWidth: 1,margin: EdgeInsets.only(bottom: 20,left: 10.0,right: 10.0));
      throw Exception('Failed to load data${response.statusCode}');
    }
  }
}