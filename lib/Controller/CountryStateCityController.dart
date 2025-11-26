
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kirpix/Model/BrandList.dart';
import 'package:http/http.dart'as http;
import '../Model/CityModelList.dart';
import '../Model/CountryModelList.dart';
import '../Model/StateModelList.dart';
import '../Utils/Constant/ApiConfig/ApiEndPoints.dart';
import '../Utils/Constant/AppTheme.dart';

class CountryStateCityController extends GetxController{

  var isLoading = true.obs;
  var countryList = <Country>[].obs;
  var stateList = <States>[].obs;
  var cityList = <Cityies>[].obs;
  var listCountry = <String>[].obs;
  var listState = <String>[].obs;
  var listCity = <String>[].obs;

  @override
  void onInit() {

    getCountry();
    super.onInit();
  }

  void getCountry() async {
    listCountry.clear();
    try {
      isLoading(true);
      var cnt = await getCnt();
      if (cnt != null) {
        countryList.value=cnt.data;

        for(int i=0;i<countryList.length;i++) {
          listCountry.add(countryList[i].name);
        }
        update();

      }
    } finally {
      isLoading(false);
    }
  }

  getCnt() async {
    final uri = ApiEndPoints.country;
    final response = await http.post(Uri.parse(uri));
    if (response.statusCode == 200) {
      return CountryModelList.fromJson(jsonDecode(response.body));
    } else {
      Get.snackbar("Sorry...!", "No data found...!",snackPosition: SnackPosition.TOP,backgroundColor: AppTheme.apptheme_color.withOpacity(0.10),colorText: AppTheme.apptheme_color,borderColor:AppTheme.apptheme_color,borderWidth: 1,margin: EdgeInsets.only(bottom: 20,left: 10.0,right: 10.0));
      throw Exception('Failed to load data${response.statusCode}');
    }
  }


  void getState(String countryId) async {
    listState.clear();
    try {
      isLoading(true);
      var cnt = await getStat(countryId);
      if (cnt != null) {
        stateList.value=cnt.data;

        for(int i=0;i<stateList.length;i++) {
          listState.add(stateList[i].name);
        }
        update();

      }
    } finally {
      isLoading(false);
    }
  }

  getStat(String countryId) async {
    var map = new Map<String, dynamic>();
    map['country_id'] = countryId;


    final uri = ApiEndPoints.states;
    final response = await http.post(Uri.parse(uri),body: map);
    if (response.statusCode == 200) {
      return StateModelList.fromJson(jsonDecode(response.body));
    } else {
      Get.snackbar("Sorry...!", "No data found...!",snackPosition: SnackPosition.TOP,backgroundColor: AppTheme.apptheme_color.withOpacity(0.10),colorText: AppTheme.apptheme_color,borderColor:AppTheme.apptheme_color,borderWidth: 1,margin: EdgeInsets.only(bottom: 20,left: 10.0,right: 10.0));
      throw Exception('Failed to load data${response.statusCode}');
    }
  }


  void getCity(String stateId) async {
    listCity.clear();
    try {
      isLoading(true);
      var cnt = await getcityList(stateId);
      if (cnt != null) {
        cityList.value=cnt.data;

        for(int i=0;i<cityList.length;i++) {
          listCity.add(cityList[i].name);
        }
        update();

      }
    } finally {
      isLoading(false);
    }
  }

  getcityList(String stateId) async {
    var map = new Map<String, dynamic>();
    map['state_id'] = stateId;


    final uri = ApiEndPoints.city;
    final response = await http.post(Uri.parse(uri),body: map);
    if (response.statusCode == 200) {
      return CityModelList.fromJson(jsonDecode(response.body));
    } else {
      Get.snackbar("Sorry...!", "No data found...!",snackPosition: SnackPosition.TOP,backgroundColor: AppTheme.apptheme_color.withOpacity(0.10),colorText: AppTheme.apptheme_color,borderColor:AppTheme.apptheme_color,borderWidth: 1,margin: EdgeInsets.only(bottom: 20,left: 10.0,right: 10.0));
      throw Exception('Failed to load data${response.statusCode}');
    }
  }



}