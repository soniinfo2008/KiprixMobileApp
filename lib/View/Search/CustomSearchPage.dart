import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:kirpix/Model/CustomSearchModelList.dart';
import 'package:kirpix/Utils/Constant/ApiConfig/ApiEndPoints.dart';
import 'package:kirpix/Utils/Constant/analytics_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../AppBarWithBack.dart';
import '../../Controller/CustomSearchController.dart';
import '../../Controller/HomeController.dart';
import '../../DrawerPages/ShoppingListPage.dart';
import '../../Utils/Constant/AppTheme.dart';
import '../../Utils/Constant/Const.dart';
import '../../Widgets/ImageUtility.dart';
import '../../Widgets/Shadow.dart';
import 'package:http/http.dart'as http;

import '../Product/ProductPage.dart';

class CustomSearchPage extends StatefulWidget {
  const CustomSearchPage({Key? key}) : super(key: key);

  @override
  State<CustomSearchPage> createState() => _CustomSearchPageState();
}

class _CustomSearchPageState extends State<CustomSearchPage> {
  CustomSearchController searchController = Get.put(CustomSearchController());
  HomeController homeController = Get.put(HomeController());
  bool _apiCalled = true;
  AnalyticsService analyticsService=AnalyticsService();

  int _currentIndex = 0;
  TextEditingController cnt_newShoppingName = TextEditingController();
  TextEditingController cntsearch = TextEditingController();
  static SharedPreferences? _prefs;
  late int selectedIndex=-1;
  String selectedFolderId="";
  static init() async {
    _prefs = await SharedPreferences.getInstance();

  }

  @override
  void initState() {
    // TODO: implement initState
    searchController.isLoading(false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    init();
    return Scaffold(
        backgroundColor: AppTheme.back_color,
        appBar: AppBarBack(
          title: '',
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            Container(
              width: Get.width,
              height: 65,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              decoration: ShapeDecoration(
                gradient: LinearGradient(
                  begin: Alignment(0.00, -1.00),
                  end: Alignment(0, 1),
                  colors: [Color(0xFF9BC838), Color(0xFF4F9D01)],
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                shadows: [
                  BoxShadow(
                    color: Color(0x19C94210),
                    blurRadius: 30,
                    offset: Offset(0, 10),
                    spreadRadius: 0,
                  )
                ],
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                    },
                    child: Container(
                      width: Get.width * 0.90,
                      height: 45,
                      child: TextField(
                        controller: cntsearch,
                        keyboardType: TextInputType.text,
                      autofocus: true,
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1.5, color: Color(0xff7dca2e)),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1.5, color: Color(0xffdfe2e5)),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1.5, color: Color(0xfff44336)),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1.5, color: Color(0xfff44336)),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1.5, color: Color(0xffdfe2e5)),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                        hintText: 'Search',
                        prefixIcon: Icon(Icons.search),

                        ),
                        onChanged: (value){
                          if(value.length>=3){
                            searchController.getData(value);
                            // analyticsService.SerachEvent(value);
                          }
                        },

                      ),
                    ),
                  ),
                ],
              ),
            ),
           /* SizedBox(
              height: 20,
            ),
            Obx(() {
              if (searchController.isLoading.value)
                return Center(child: CircularProgressIndicator());
              else {
                return Padding(
                  padding: EdgeInsets.only(left: 14.0, right: 14.0),
                  child: Container(
                    width: Get.width,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      shadows: [
                        BoxShadow(
                          color: Color(0xFFC6C6C6),
                          blurRadius: 4,
                          offset: Offset(0, 0),
                          spreadRadius: 0,
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Category',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: AppTheme.dark_font_color),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          height: 0.8,
                          thickness: 0.9,
                          indent: 1,
                          color: AppTheme.grayText,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: searchController.categoriesList.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Container(
                                  height: 35,
                                  width: 100,
                                  decoration: ShapeDecoration(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          width: 0.50,
                                          color: Color(0xFFDFE2E5)),
                                      borderRadius:
                                      BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 45,
                                        height: 35,
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: [
                                            CachedNetworkImage(
                                              height: 45,
                                              width: 35,
                                              imageUrl: ApiEndPoints.imagePath +
                                                  "" + searchController
                                                  .categoriesList[index]
                                                  .image,
                                              progressIndicatorBuilder: (context,
                                                  url,
                                                  downloadProgress) =>
                                                  Padding(
                                                    padding: const EdgeInsets.all(10.0),
                                                    child: CircularProgressIndicator(
                                                        value:
                                                        downloadProgress
                                                            .progress),
                                                  ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                  Image.asset(
                                                    "assets/images/appicon.png",
                                                    height: 70,
                                                    width: 50,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 8.0),
                                        child: Text(
                                          searchController
                                              .categoriesList[index]
                                              .categoryName
                                              .toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: AppTheme.dark_font_color,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),



                 ] ),
              ) );
              }
            }),*/


            Obx(() {
              if (searchController.issecLoading.value)
                return Center(child: CircularProgressIndicator());
                // return SizedBox(height: 10,);
              else {
                return searchController.addsdataList.length!=0?
             Padding(
                  padding: EdgeInsets.only(left: 14.0, right: 14.0,),
                  child: Column(
                    children: [
                      searchController.addsdataList.isNotEmpty
                          ? Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Text(
                              "Sponsored",
                              style: TextStyle(
                                  color: AppTheme.dark_font_color,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      )
                          : SizedBox(),
                      Container(
                        height: 80,
                        child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: new List.generate(
                                searchController.addsdataList.length,
                                    (int index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        _launch(searchController.addsdataList[index].adClickUrl);
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        child: CachedNetworkImage(
                                            imageUrl: ImageUtility.ImageUrl(searchController.addsdataList[index]
                                                .adImageUrl),
                                            fit: BoxFit.fill,
                                            progressIndicatorBuilder: (context,
                                                url, downloadProgress) =>
                                                Container(
                                                  width: Get.width,
                                                  height: Get.height,
                                                  decoration: ShapeDecoration(
                                                    color: AppTheme.grayText,
                                                    shape:
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          15),
                                                    ),
                                                    shadows: [
                                                      BoxShadow(
                                                        color: Color(0xFFC6C6C6)
                                                            .withOpacity(0.75),
                                                        blurRadius: 4,
                                                        offset: Offset(0, 0),
                                                        spreadRadius: 0,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                            errorWidget: (context, url,
                                                error) =>
                                                Container(
                                                  width: Get.width,
                                                  height: Get.height,
                                                  decoration: ShapeDecoration(
                                                    color: AppTheme.grayText,
                                                    shape:
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          15),
                                                    ),
                                                    shadows: [
                                                      BoxShadow(
                                                        color: Color(0xFFC6C6C6)
                                                            .withOpacity(0.75),
                                                        blurRadius: 4,
                                                        offset: Offset(0, 0),
                                                        spreadRadius: 0,
                                                      )
                                                    ],
                                                  ),
                                                )),
                                      ),
                                    ),
                                  );
                                })),
                      ),
                    ],
                  )
                ):SizedBox();
              }
            }),

            Obx(() {
              if (searchController.isLoading.value)
                // return Center(child: CircularProgressIndicator());
                return SizedBox(height: 20,);
              else {
                return searchController.subcategoriesList.length!=0?
                searchController.isData.value?Padding(
                  padding: EdgeInsets.only(left: 14.0, right: 14.0,top:15.0),
                  child: Container(
                    width: Get.width,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      shadows: [
                        BoxShadow(
                          color: Color(0xFFC6C6C6),
                          blurRadius: 4,
                          offset: Offset(0, 0),
                          spreadRadius: 0,
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Sub Category',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: AppTheme.dark_font_color),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          height: 0.8,
                          thickness: 0.9,
                          indent: 1,
                          color: AppTheme.grayText,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: searchController.subcategoriesList.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5.0, right: 5.0),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child:  GestureDetector(
                                        onTap:(){
                                          Get.to(ProductPage(searchController.subcategoriesList[index].categoryId.toString(),searchController.subcategoriesList[index].subcategoryId.toString(),""));
                                        },
                                        child: Container(
                                          height: 35,
                                          clipBehavior: Clip.antiAlias,
                                          decoration: ShapeDecoration(
                                            color: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                  width: 0.50,
                                                  color: Color(0xFFDFE2E5)),
                                              borderRadius:
                                              BorderRadius.circular(10),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: 45,
                                                height: 35,
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                                  children: [
                                                    CachedNetworkImage(
                                                      height: 45,
                                                      width: 35,
                                                      imageUrl: ImageUtility.ImageUrl(searchController
                                                          .subcategoriesList[index]
                                                          .image),
                                                      progressIndicatorBuilder: (context,
                                                          url,
                                                          downloadProgress) =>
                                                          Padding(
                                                            padding: const EdgeInsets.all(10.0),
                                                            child: CircularProgressIndicator(
                                                                value:
                                                                downloadProgress
                                                                    .progress),
                                                          ),
                                                      errorWidget:
                                                          (context, url, error) =>
                                                          Image.asset(
                                                            "assets/images/appicon.png",
                                                            height: 70,
                                                            width: 50,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 8.0),
                                                child: Text(
                                                  searchController
                                                      .subcategoriesList[index]
                                                      .subcategoryName
                                                      .toString(),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: AppTheme.dark_font_color,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),

                      ],
                    ),
                  ),
                ):SizedBox():SizedBox();
              }
            }),
/*
            Obx(() {
              if (searchController.isLoading.value)
                return SizedBox(height: 20,);
              else {
                return searchController.brandList.length!=0?
                searchController.isData.value?Padding(
                  padding: EdgeInsets.only(left: 14.0, right: 14.0 ,top: 15.0),
                  child: Container(
                    width: Get.width,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      shadows: [
                        BoxShadow(
                          color: Color(0xFFC6C6C6),
                          blurRadius: 4,
                          offset: Offset(0, 0),
                          spreadRadius: 0,
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Brand',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: AppTheme.dark_font_color),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          height: 0.8,
                          thickness: 0.9,
                          indent: 1,
                          color: AppTheme.grayText,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: searchController.brandList.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    left: 5.0, right: 5.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: GestureDetector(
                                    onTap:(){
                                      Get.to(ProductPage("","",searchController.brandList[index].brandId.toString()));
                                    },
                                    child: Container(
                                      height: 35,
                                      clipBehavior: Clip.antiAlias,
                                      decoration: ShapeDecoration(
                                        color: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              width: 0.50,
                                              color: Color(0xFFDFE2E5)),
                                          borderRadius:
                                          BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 45,
                                            height: 35,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: [
                                                CachedNetworkImage(
                                                  height: 45,
                                                  width: 35,
                                                  imageUrl: ImageUtility.ImageUrl(searchController
                                                      .brandList[index]
                                                      .image),
                                                  progressIndicatorBuilder: (context,
                                                      url,
                                                      downloadProgress) =>
                                                      Padding(
                                                        padding: const EdgeInsets.all(10.0),
                                                        child: CircularProgressIndicator(
                                                            value:
                                                            downloadProgress
                                                                .progress),
                                                      ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                      Image.asset(
                                                        "assets/images/appicon.png",
                                                        height: 70,
                                                        width: 50,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8.0),
                                            child: Text(
                                              searchController
                                                  .brandList[index]
                                                  .brandName
                                                  .toString(),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: AppTheme.dark_font_color,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),

                      ],
                    ),
                  ),
                ):SizedBox():SizedBox();
              }
            }),*/


            Obx(() {
              if (searchController.isLoading.value)
                return Center(child: CircularProgressIndicator());
              else {
                return searchController.productsList.length!=0?
                searchController.isData.value?
                Padding(
                  padding: EdgeInsets.only(left: 14.0, right: 14.0,top:15),
                  child: Container(
                    width: Get.width,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      shadows: [
                        BoxShadow(
                          color: Color(0xFFC6C6C6),
                          blurRadius: 4,
                          offset: Offset(0, 0),
                          spreadRadius: 0,
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Product',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: AppTheme.dark_font_color),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          height: 0.8,
                          thickness: 0.9,
                          indent: 1,
                          color: AppTheme.grayText,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: searchController.productsList.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                _viewProductDetails(context, searchController.productsList[index]);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 14.0),
                                child: Column(
                                  children: [
                                    Stack(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment
                                                    .start,
                                                mainAxisAlignment: MainAxisAlignment
                                                    .center,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .only(left: 3.0,
                                                        top: 3,
                                                        bottom: 3),
                                                    child: Container(
                                                        width: 90,
                                                        height: 90,
                                                        decoration: ShapeDecoration(
                                                          color: Colors.white,
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius
                                                                .circular(10),
                                                          ),
                                                        ),
                                                        child: Padding(
                                                          padding: const EdgeInsets
                                                              .all(5.0),
                                                          child: CachedNetworkImage(
                                                            height: 90,
                                                            width: 90,
                                                            imageUrl: ImageUtility.ImageUrl(
                                                                searchController.productsList[index]
                                                                    .productImage),
                                                            progressIndicatorBuilder: (
                                                                context,
                                                                url,
                                                                downloadProgress) =>
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                      .all(10.0),
                                                                  child: CircularProgressIndicator(
                                                                      value: downloadProgress
                                                                          .progress),
                                                                ),
                                                            errorWidget:
                                                                (context, url,
                                                                error) =>
                                                                Image.asset(
                                                                  "assets/images/appicon.png",
                                                                  height: 70,
                                                                  width: 50,
                                                                ),
                                                          ),
                                                        )
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                                children: [
                                                 /* Padding(
                                                    padding: const EdgeInsets
                                                        .only(left: 10.0,
                                                        right: 5,
                                                        top: 7,
                                                        bottom: 8.0),
                                                    child: Text(
                                                      "Rs." + searchController.productsList[index]
                                                          .price.toString(),
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w700,
                                                          color: AppTheme
                                                              .apptheme_color
                                                      ),
                                                    ),

                                                  ),*/
                                                  GestureDetector(
                                                    onTap: () {
                                                      if (_prefs!.getInt(Const.customerId) != null) {

                                                        _addNewShoppingList(context, searchController.productsList[index]);

                                                      } else {
                                                        showDialog(context: context, barrierDismissible: false, builder: (BuildContext context) {
                                                          return CustomDialog("Please log in if you wish to create a shopping list.");
                                                        });
                                                      }
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .only(left: 30.0,
                                                          right: 5,
                                                          top: 45,bottom: 10),
                                                      child: Image.asset(
                                                        "assets/images/fav_icon.png",
                                                        height: 30, width: 30,),
                                                    ),
                                                  ),


                                                ],
                                              ),

                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 95.0,
                                                right: 8.0,
                                                bottom: 8.0,
                                                top: 8.0),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .start,
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Flexible(
                                                      child: Text(
                                                        searchController.productsList[index].productName.length > 30
                                                            ? searchController.productsList[index].productName.substring(0, 25) + '...'
                                                            : searchController.productsList[index].productName,
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w700,
                                                          color: AppTheme.dark_font_color,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      "Rs." + searchController.productsList[index].price.toString(),
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w700,
                                                        color: AppTheme.apptheme_color,
                                                      ),
                                                    ),
                                                  ],
                                                ),

                                                Padding(
                                                  padding: const EdgeInsets
                                                      .only(
                                                      top: 10.0, bottom: 5.0),
                                                  child: Text(
                                                    searchController.productsList[index]
                                                        .shortDescription,
                                                    maxLines: 2,
                                                    overflow: TextOverflow
                                                        .ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight: FontWeight
                                                            .w400,
                                                        color: AppTheme
                                                            .dark_font_color
                                                    ),
                                                  ),
                                                ),

                                              ],
                                            ),
                                          ),

                                        ]
                                    ),
                                    Divider(
                                      height: 1,
                                      thickness: 1,
                                      color: AppTheme.broder_color,
                                    ),
                                    Container(
                                      height: 50,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Padding(
                                              padding:
                                              const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: 35,
                                                    height: 35,
                                                    decoration:
                                                    ShapeDecoration(
                                                      image: DecorationImage(
                                                        image: NetworkImage(ImageUtility.ImageUrl(
                                                            searchController.productsList[index].shopImage)),
                                                        fit: BoxFit.fill,
                                                      ),
                                                      shape:
                                                      RoundedRectangleBorder(
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(40),
                                                      ),
                                                      shadows: [
                                                        BoxShadow(
                                                          color: Color(
                                                              0xFFC6C6C6),
                                                          blurRadius: 4,
                                                          offset:
                                                          Offset(0, 0),
                                                          spreadRadius: 0,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Flexible(
                                                    child: Padding(
                                                      padding:
                                                      const EdgeInsets
                                                          .only(
                                                          left: 8.0),
                                                      child: Text(
                                                        searchController.productsList[index].shopName,
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          color: Color(
                                                              0xFF4E5157),
                                                          fontSize: 11,
                                                          fontWeight:
                                                          FontWeight.w500,
                                                          height: 1.20,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Row(
                                              children: [
                                                Flexible(
                                                  child: Padding(
                                                    padding:
                                                    const EdgeInsets.only(
                                                        right: 8.0),
                                                    child: Text(
                                                      searchController.productsList[index].addressLine1 +
                                                          "," +
                                                          searchController.productsList[index].city +
                                                          "," +
                                                          searchController.productsList[index].state,
                                                      maxLines: 3,
                                                      overflow: TextOverflow
                                                          .ellipsis,
                                                      style: TextStyle(
                                                        color:
                                                        Color(0xFF4E5157),
                                                        fontSize: 11,
                                                        fontWeight:
                                                        FontWeight.w500,
                                                        height: 1.20,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (index !=searchController.productsList.length - 1) ...[
                              Divider(
                                height: 0.8,
                                thickness: 0.9,
                                indent: 1,
                                color: AppTheme.grayText,
                              ),
                            ] else ...[
                              Container()
                            ]
                          ],
                        );
                      }),

                      ],
                    ),
                  ),
                ):SizedBox():SizedBox();
              }
            }),

            Obx(()=>Padding(
                padding: const EdgeInsets.all(10.0),
                child: searchController.isData.value? SizedBox():Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/svg/nodata_found.gif",
                        height: 150,
                        width: 150,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        'Ooops!',
                        style: TextStyle(
                          fontSize: 20,
                          color: AppTheme.dark_font_secondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Padding(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          'The requested product, brand, or category could not be found. Please consider trying a different search.',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.dark_font_secondary,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ]),
        ));
  }

  void _viewProductDetails(BuildContext context, Product productsList) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        barrierColor: Colors.black.withAlpha(1),
        context: context,
        isScrollControlled: true,
        isDismissible: true,
        builder: (BuildContext context) {
          return DraggableScrollableSheet(
            maxChildSize: 0.95,
            initialChildSize: 0.95,
            minChildSize: 0.95,
            builder: (context, scrollController) {
              return Container(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        SizedBox(height: 7,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                decoration: CustomDecorations().buttonwithRadiusTen(15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Close',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                          ],
                        ),
                        SizedBox(height: 10,),
                        Container(
                            width: Get.width,
                            decoration: CustomDecorations()
                                .BackgroundDecorationwithRadiusTen(),
                            child: Stack(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        mainAxisAlignment: MainAxisAlignment
                                            .start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 3.0, top: 3),
                                            child: Center(
                                              child: Container(
                                                  width: 100,
                                                  height: 100,
                                                  decoration: ShapeDecoration(
                                                    color: Colors.white,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius
                                                          .circular(10),
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .all(5.0),
                                                    child:CachedNetworkImage(
                                                      height: 90,
                                                      width: 90,
                                                      imageUrl: ImageUtility.ImageUrl(productsList.productImage),
                                                      progressIndicatorBuilder:
                                                          (context, url,
                                                          downloadProgress) =>
                                                          Container(
                                                            decoration: BoxDecoration(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                    .circular(
                                                                    5.0))),
                                                            child: Image.asset(
                                                              "assets/svg/yBmIbzTali.gif",
                                                              height: 90,
                                                              width: 90,
                                                            ),
                                                          ),
                                                      errorWidget: (context,
                                                          url, error) =>
                                                          Image.asset(
                                                            "assets/images/appicon.png",
                                                            height: 70,
                                                            width: 50,
                                                          ),
                                                    ),
                                                  )

                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 100.0,
                                        right: 8.0,
                                        bottom: 8.0,
                                        top: 8.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment
                                          .start,
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: [
                                        Text(
                                          productsList.productName,
                                          maxLines: 3,
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                              color: AppTheme.dark_font_color
                                          ),
                                        ),
                                        Text(
                                          productsList.shortDescription,
                                          maxLines: 3,
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              color: AppTheme.dark_font_color
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),

                                ]
                            )
                        ),
                        SizedBox(height: 15,),
                        Container(
                          width: Get.width,
                          decoration: CustomDecorations()
                              .BackgroundDecorationwithRadiusTen(),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 24.0,
                                    right: 24.0,
                                    top: 14,
                                    bottom: 14),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          "assets/images/brand.png", height: 20,
                                          width: 20,),
                                        SizedBox(width: 5,),
                                        Text(
                                          'Brand',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: AppTheme
                                                  .dark_font_secondary
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5.0,),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 25.0),
                                      child: Text(
                                        productsList.brandName,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: AppTheme.apptheme_color
                                        ),
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                              Divider(height: 0.8,
                                thickness: 0.9,
                                indent: 1,
                                color: AppTheme.grayText,),
                              Padding(
                                padding: const EdgeInsets.only(left: 24.0,
                                    right: 24.0,
                                    top: 14,
                                    bottom: 14),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset("assets/images/address.png",
                                          height: 20, width: 20,),
                                        SizedBox(width: 5,),
                                        Text(
                                          'Address',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: AppTheme
                                                  .dark_font_secondary
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5.0,),

                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 25.0),
                                      child: Text(
                                        productsList.addressLine1 + "," +
                                            productsList.city + "," +
                                            productsList.state,

                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: AppTheme.dark_font_color
                                        ),
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                              Divider(
                                height: 0.8,
                                thickness: 0.9,
                                indent: 1,
                                color: AppTheme.grayText,
                              ),
                              Padding(
                                  padding: const EdgeInsets.only(
                                      left: 24.0,
                                      right: 24.0,
                                      top: 14,
                                      bottom: 14),
                                  child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Image.asset(
                                                "assets/images/member.png",
                                                height: 20,
                                                width: 20,
                                                color:AppTheme.icon_color
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Outlets',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  color: AppTheme
                                                      .dark_font_secondary),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5.0,
                                        ),
                                        ListView.builder(
                                            physics: NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: productsList.outlets.length,
                                            itemBuilder: (context, index) {
                                              var i=index+1;
                                              return Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets.only(left: 25.0),
                                                    child: Text(
                                                      i.toString()+". "+productsList.outlets[index].outletName,
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.w600,
                                                          color: AppTheme.dark_font_color),
                                                    ),
                                                  ), Padding(
                                                    padding:
                                                    const EdgeInsets.only(left: 25.0),
                                                    child: Text(
                                                      "- "+productsList.outlets[index].addressLine1,
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.w400,
                                                          color: AppTheme.dark_font_color),
                                                    ),
                                                  ),
                                                ],
                                              );

                                            })
                                      ])),
                              Divider(height: 0.8,
                                thickness: 0.9,
                                indent: 1,
                                color: AppTheme.grayText,),
                              Padding(
                                padding: const EdgeInsets.only(left: 24.0,
                                    right: 24.0,
                                    top: 14,
                                    bottom: 14),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          "assets/images/description.png",
                                          height: 20, width: 20,),
                                        SizedBox(width: 5,),
                                        Text(
                                          'Description',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: AppTheme
                                                  .dark_font_secondary
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5.0,),

                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 25.0),
                                      child: Html(data: productsList.description, style: {
                                        "body": Style(
                                          fontWeight: FontWeight.w400,
                                          color: AppTheme.dark_font_color,
                                          fontSize: FontSize(12.0),
                                        )
                                      }
                                      ),
                                    ),

                                  ],
                                ),
                              )

                            ],
                          ),
                        ),
                        SizedBox(height: 20,),
                        Row(
                          children: [

                            Expanded(
                              child: Container(
                                width: Get.width,
                                height: 50,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 15),
                                decoration: CustomDecorations()
                                    .BackgroundDecorationwithRadiusTen(),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Rs." + productsList.price.toString(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppTheme.apptheme_color,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),),
                            SizedBox(width: 20,),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  if (_prefs!.getInt(Const.customerId) != null) {
                                    _addNewShoppingList(context,productsList);

                                  } else {
                                    showDialog(context: context, barrierDismissible: false, builder: (BuildContext context) {
                                      return CustomDialog("Please log in if you wish to create a shopping list.");
                                    });
                                  }
                                },
                                child: Container(
                                  width: Get.width,
                                  height: 50,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 15),
                                  decoration: CustomDecorations()
                                      .buttonwithRadiusTen(10),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment
                                        .center,
                                    children: [
                                      SvgPicture.asset(
                                        "assets/svg/fav_icon.svg", height: 20,
                                        width: 20,),
                                      SizedBox(width: 5,),
                                      Text(
                                        'Add item',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: AppTheme.light_font_color,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),),

                          ],
                        ),

                        SizedBox(height: 20,),

                      ],
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: AppTheme.back_color,

                  /// To set a shadow behind the parent container
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xd3545556),
                      blurRadius: 1,
                      offset: Offset(0, 0),
                      spreadRadius: 0,
                    )
                  ],

                  /// To set radius of top left and top right
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(0.0),
                    topRight: Radius.circular(0.0),
                  ),
                ),
              );
            },
          );
        });
  }

  void _addNewShoppingList(BuildContext context, Product productsList, ) {
    homeController.getHomeFolderData(_prefs!.getInt(Const.customerId)!);

    int qtyup=1;
    /* void increment(){

      setState(() {
        if(qtyup>=0&&qtyup<10) {
          qtyup++;
        }
      });
    }
    void decrement(){

      setState(() {
        if(qtyup>1) {
          qtyup--;
        }
      });
    }*/
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        barrierColor: Colors.black.withAlpha(1),
        context: context,
        isScrollControlled: true,
        isDismissible: true,
        builder: (BuildContext context) {
          return DraggableScrollableSheet(
            maxChildSize: 0.70,
            initialChildSize: 0.70,
            minChildSize: 0.70,
            builder: (context, scrollController) {
              return StatefulBuilder(
                  builder: (context, setStateInsideBottomSheet) {
                    return Container(
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                  width: Get.width,
                                  height: Get.height * 0.15,
                                  decoration: CustomDecorations()
                                      .BackgroundDecorationwithRadiusTen(),
                                  child: Stack(children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(14.0),
                                          child: Text(
                                            'Create New Shoping List',
                                            maxLines: 1,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                                color: AppTheme.dark_font_color),
                                          ),
                                        ),
                                        Divider(
                                          height: 0.8,
                                          thickness: 0.9,
                                          indent: 1,
                                          color: AppTheme.grayText,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .start,
                                          children: [
                                            Container(
                                              width: Get.width * 0.70,
                                              child: TextFormField(
                                                controller: cnt_newShoppingName,
                                                keyboardType:
                                                TextInputType.emailAddress,
                                                style: new TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black),
                                                decoration: InputDecoration(
                                                  hintText:
                                                  'ex: Daily Needs || Necessary',
                                                  contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 17.0,
                                                      horizontal: 10.0),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        width: 0,
                                                        color: Color(0xffffffff)),
                                                    borderRadius:
                                                    BorderRadius.circular(0.0),
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        width: 0,
                                                        color: Color(0xffffffff)),
                                                    borderRadius:
                                                    BorderRadius.circular(0),
                                                  ),
                                                  errorBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        width: 0,
                                                        color: Color(0xffffffff)),
                                                    borderRadius:
                                                    BorderRadius.circular(0),
                                                  ),
                                                ),
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Please Enter Title';
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                            _apiCalled?
                                            GestureDetector(
                                              onTap: () {
                                                if(cnt_newShoppingName.text.isNotEmpty) {
                                                  addNewList();
                                                  setStateInsideBottomSheet(() {
                                                    _apiCalled=false;
                                                  });
                                                  Navigator.pop(context);
                                                }else{
                                                  Get.snackbar(
                                                    "Alert",
                                                    'Please Enter Shopping Title', // Message to display
                                                    snackPosition: SnackPosition.TOP, // Choose the position
                                                    backgroundColor: Colors.black87, // Background color
                                                    colorText: Colors.white, // Text color
                                                  );
                                                }
                                              },
                                              child: Container(
                                                width: 65,
                                                height: 30,
                                                decoration: CustomDecorations()
                                                    .buttonwithRadiusTen(10),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Add',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.white,
                                                        fontWeight: FontWeight
                                                            .w700,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ):
                                            SizedBox(
                                              height: 30,
                                              width: 30,
                                              child: CircularProgressIndicator(),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ])),
                              SizedBox(
                                height: 14,
                              ),
                              Container(
                                  width: Get.width,
                                  height: Get.height * 0.10,
                                  decoration: CustomDecorations()
                                      .BackgroundDecorationwithRadiusTen(),
                                  child: Row(
                                    children: [
                                      Row(
                                        children: <Widget>[
                                          SizedBox(width: 7.0,),
                                          Container(
                                            child: Image.network(ImageUtility.ImageUrl(productsList.productImage),
                                              height: 52.0,
                                              width: 52.0,
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            mainAxisAlignment: MainAxisAlignment
                                                .center,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets
                                                    .fromLTRB(
                                                    8.0, 0.0, 8.0, 2.0),
                                                //12 char only
                                                child: Text(
                                                  productsList.productName
                                                      .length > 22
                                                      ? productsList
                                                      .productName.substring(
                                                      0, 20) + '...'
                                                      : productsList
                                                      .productName,
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                      color: AppTheme
                                                          .dark_font_color,
                                                      fontSize: 14,
                                                      fontWeight: FontWeight
                                                          .w700),),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets
                                                    .fromLTRB(
                                                    8.0, 2.0, 8.0, 2.0),
                                                child: Text('Rs.' +
                                                    productsList.mrpPrice
                                                        .toString(),
                                                  style: TextStyle(
                                                      color: AppTheme
                                                          .apptheme_color,
                                                      fontSize: 14,
                                                      fontWeight: FontWeight
                                                          .w700),),
                                              ),
                                            ],
                                          ),


                                        ],
                                      ),
                                      Spacer(),
                                      Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              setStateInsideBottomSheet(() {
                                                if (qtyup > 1) {
                                                  qtyup--;
                                                }
                                              });
                                            },
                                            child: SvgPicture.asset(
                                              'assets/svg/minus_with_round.svg',
                                              height: 24, width: 24,),
                                          ),
                                          SizedBox(width: 15,),
                                          Text(qtyup.toString(),
                                            style: TextStyle(
                                                color: AppTheme
                                                    .dark_font_secondary,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700),),
                                          SizedBox(width: 15,),
                                          GestureDetector(
                                            onTap: () {
                                              setStateInsideBottomSheet(() {
                                                if (qtyup >= 0 && qtyup < 10) {
                                                  qtyup++;
                                                }
                                              });
                                            },
                                            child: SvgPicture.asset(
                                              'assets/svg/plus_with_round.svg',
                                              height: 24, width: 24,),),
                                          SizedBox(width: 15,)
                                        ],
                                      )
                                    ],
                                  )),
                              SizedBox(
                                height: 14,
                              ),

                              Container(
                                  width: Get.width,
                                  decoration: CustomDecorations()
                                      .BackgroundDecorationwithRadiusTen(),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(14.0),
                                            child: Text(
                                                "Your Shoping List",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                )
                                            ),
                                          ),
                                        ],
                                      ),
                                      Obx(() =>
                                          ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: homeController.slFolderList.length,
                                              physics: NeverScrollableScrollPhysics(),
                                              itemBuilder: (context, index) {
                                                return Column(
                                                  children: [
                                                    Divider(
                                                      height: 0.8,
                                                      thickness: 0.9,
                                                      indent: 1,
                                                      color: AppTheme.grayText,
                                                    ),

                                                    homeController
                                                        .slFolderList[index].is_shared?GestureDetector(
                                                        onTap: () {
                                                          selectedIndex = index;
                                                          selectedFolderId = homeController.slFolderList[index].shoppingFolderId.toString();
                                                          setStateInsideBottomSheet(() {
                                                            print(selectedIndex);
                                                          });
                                                        },

                                                        child: Container(
                                                          color: selectedIndex ==
                                                              index ? AppTheme
                                                              .back_color : Colors
                                                              .transparent,
                                                          child: Padding(
                                                            padding: const EdgeInsets
                                                                .only(
                                                                right: 14.0,
                                                                left: 14.0),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment
                                                                  .start,
                                                              children: [
                                                                SvgPicture.asset(
                                                                  'assets/svg/dot_symbol.svg',
                                                                  color: selectedIndex ==
                                                                      index
                                                                      ? AppTheme
                                                                      .apptheme_color
                                                                      : AppTheme
                                                                      .dark_font_secondary,),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                      .all(14.0),
                                                                  child: Text(
                                                                      homeController
                                                                          .slFolderList[index]
                                                                          .shoppingFolderTitle,
                                                                      style: TextStyle(
                                                                        fontSize: 16,
                                                                        color: selectedIndex ==
                                                                            index
                                                                            ? AppTheme
                                                                            .apptheme_color
                                                                            : AppTheme
                                                                            .dark_font_color,
                                                                        fontWeight: FontWeight
                                                                            .w500,
                                                                      )
                                                                  ),
                                                                ),
                                                                Spacer(),

                                                                selectedIndex ==
                                                                    index
                                                                    ? SvgPicture
                                                                    .asset(
                                                                    'assets/svg/ticksquare.svg')
                                                                    : SizedBox(),
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                    ):SizedBox(),


                                                  ],
                                                );
                                              }),
                                      ),


                                    ],
                                  )
                              ),

                              SizedBox(
                                height: 14,
                              ),

                              GestureDetector(
                                onTap: () {
                                  if(selectedFolderId.isNotEmpty) {
                                    Navigator.pop(context);
                                    addProductIntoShoppingFolder(
                                        productsList.productId,
                                        /*productsList.shopId*/1, selectedFolderId,
                                        qtyup);
                                  }else{
                                    Get.snackbar(
                                      "Alert",
                                      'Please Select Your Shopping Folder', // Message to display
                                      snackPosition: SnackPosition.TOP, // Choose the position
                                      backgroundColor: Colors.black87, // Background color
                                      colorText: Colors.white, // Text color
                                    );
                                  }
                                },
                                child: Container(
                                  width: Get.width,
                                  height: 50,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 15),
                                  decoration: ShapeDecoration(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: BorderSide(
                                        width: 1,
                                        color: Colors.green,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                    shadows: [
                                      BoxShadow(
                                        color: Color(0xFFC6C6C6).withOpacity(
                                            0.75),
                                        blurRadius: 4,
                                        offset: Offset(0, 0),
                                        spreadRadius: 0,
                                      )
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Add Item",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppTheme.apptheme_color,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      decoration:
                      CustomDecorations().BackgroundDecorationwithRedius(),
                    );

                  }
              );
            },
          );
        });

  }

  Future<void> addNewList() async {

    String body = json.encode({
      'shopping_title': cnt_newShoppingName.text,
      'customer_id': _prefs!.getInt(Const.customerId),
    });

    final response = await http.post(
      Uri.parse(ApiEndPoints.addNewShoppingList),
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    Map<String, dynamic> data = jsonDecode(response.body);
    if (data['status'] == "success") {
      setState(() {});
      _apiCalled = true;
      cnt_newShoppingName.text="";
      homeController.getHomeFolderData(_prefs!.getInt(Const.customerId)!);
      Get.snackbar(data['status'], data['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppTheme.apptheme_color.withOpacity(0.10),
          colorText: AppTheme.apptheme_color,
          borderColor: AppTheme.apptheme_color,
          borderWidth: 1,
          margin: EdgeInsets.only(bottom: 20, left: 10.0, right: 10.0));
    } else {
      print('error');
    }
  }

  Future<void> addProductIntoShoppingFolder(int productId,int shopId,String selectedIndex, int qtyup) async {
      String body = json.encode({
      'product_id': productId,
      'product_qty': qtyup.toString(),
      'customer_id': _prefs!.getInt(Const.customerId),
      'shop_id': shopId,
      'folder_id': selectedIndex,
    });


    final response = await http.post(
      Uri.parse(ApiEndPoints.insertShoppingCart),
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    Map<String, dynamic> data = jsonDecode(response.body);
    if (data['status'] == "success") {
      setState(() {});
      Get.snackbar(data['status'], data['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppTheme.apptheme_color.withOpacity(0.10),
          colorText: AppTheme.apptheme_color,
          borderColor: AppTheme.apptheme_color,
          borderWidth: 1,
          margin: EdgeInsets.only(bottom: 20, left: 10.0, right: 10.0));
    } else {
      print('error');
    }
  }

  _launch(String url) async {
    String urls = url.toString();
    if (await canLaunch(urls)) {
      await launch(urls);
    } else {
      throw 'Could not launch $urls';
    }
  }
}
