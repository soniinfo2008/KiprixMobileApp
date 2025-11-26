import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kirpix/Utils/Constant/ApiConfig/ApiEndPoints.dart';

import '../Controller/BrandController.dart';
import '../Controller/CategoryController.dart';
import '../Utils/Constant/AppTheme.dart';
import '../View/Product/ProductPage.dart';
import '../View/Search/CustomSearchPage.dart';
import '../Widgets/ImageUtility.dart';
import '../Widgets/Shadow.dart';

class ComparwithKiprix extends StatefulWidget {
  const ComparwithKiprix({Key? key}) : super(key: key);

  @override
  State<ComparwithKiprix> createState() => _ComparwithKiprixState();
}

class _ComparwithKiprixState extends State<ComparwithKiprix> {
  BrandController brandController = Get.put(BrandController());
  CategoryController categoryController = Get.put(CategoryController());

  bool visibleBlockProduct = true, visibleBlockBrand = false;
  var greencolor1 = Color(0xFF9BC838);
  var greencolor2 = Color(0xFF4F9D01);
  var whitecolor1 = Color(0xFFFFFFFF);
  var whitecolor2 = Color(0xFFFFFFFF);

  int _selectedCategoryIndex = -1;

  void _toggleCategory(int index) {

      if (_selectedCategoryIndex == index) {
        // If clicked on the same category again, close it
        _selectedCategoryIndex = -1;
      } else {
        _selectedCategoryIndex = index;
      }
      setState(() {
    });
  }
  @override
  Widget build(BuildContext context) {
    return  Column(
        children: [

          Container(
            width: Get.width,
            height: 65,
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
            child: GestureDetector(
              onTap: () {
                Get.to(CustomSearchPage());
              },
              child: Padding(
                padding: const EdgeInsets.all(13.0),
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  height: 40,
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
                  child: Row(
                    children: [
                      Image(
                        image: AssetImage("assets/images/Search.png"),
                        height: 20,
                        width: 20,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Search',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.grayText,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: Get.width,
            height: 55,
            color: Colors.white,
            child: Center(
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: GestureDetector(
                        onTap: () {
                          visibleBlockProduct = true;
                          visibleBlockBrand = false;
                          greencolor1 = Color(0xFF9BC838);
                          greencolor2 = Color(0xFF4F9D01);
                          whitecolor1 = Color(0xFFFFFFFF);
                          whitecolor2 = Color(0xFFFFFFFF);
                          categoryController.getData();
                          setState(() {});
                        },
                        child: Container(
                          width: Get.width,
                          height: 40,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: ShapeDecoration(
                            gradient: LinearGradient(
                              begin: Alignment(0.00, -1.00),
                              end: Alignment(0, 1),
                              colors: [greencolor1, greencolor2],
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/images/brand.png",
                                height: 20,
                                width: 20,
                                color: whitecolor1,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Products',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: whitecolor1,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: GestureDetector(
                        onTap: () {

                          visibleBlockProduct = false;
                          visibleBlockBrand = true;
                          greencolor1 = Color(0xFFFFFFFF);
                          greencolor2 = Color(0xFFFFFFFF);
                          whitecolor1 = Color(0xFF9BC838);
                          whitecolor2 = Color(0xFF4F9D01);
                          brandController.getData();
                          setState(() {});
                        },
                        child: Container(
                          width: Get.width,
                          height: 40,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: ShapeDecoration(
                            gradient: LinearGradient(
                              begin: Alignment(0.00, -1.00),
                              end: Alignment(0, 1),
                              colors: [whitecolor1, whitecolor2],
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/images/group.png",
                                height: 20,
                                width: 20,
                                color: greencolor1,
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Text(
                                'Vendor Section',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: greencolor1,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  //category
                  Visibility(
                    visible: visibleBlockProduct,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10.0, bottom: 20),
                      child: Container(
                        width: Get.width,
                        decoration: CustomDecorations()
                            .BackgroundDecorationwithRadiusTen(),
                        child: Obx(() {
                          if (categoryController.isLoading.value)
                            return Center(child: CircularProgressIndicator());
                          else {
                            return categoryController.nodata!=true?
                            ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: categoryController.categoryList.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 14.0, right: 14.0),
                                            child: GestureDetector(
                                              onTap: () {
                                                _toggleCategory(index);
                                              },
                                              child: Row(
                                                children: [
                                                  CachedNetworkImage(
                                                    height: 70,
                                                    width: 50,
                                                    imageUrl: ImageUtility.ImageUrl( categoryController
                                                            .categoryList[index]
                                                            .categoryImage),
                                                    progressIndicatorBuilder: (context, url, downloadProgress) =>Container(
                                                      width: 50,
                                                      height: 50,
                                                      child:  Image.asset(
                                                        "assets/images/appicon.png",
                                                        height: 50,
                                                        width: 50,
                                                      ),
                                                    ),

                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Image.asset(
                                                      "assets/images/appicon.png",
                                                      height: 50,
                                                      width: 50,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: Text(
                                                      categoryController
                                                          .categoryList[index]
                                                          .categoryName,
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: AppTheme
                                                              .dark_font_color),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {

                                                      _toggleCategory(index);

                                                    },
                                                    child: Image.asset(
                                                      "assets/images/icon _arrow down.png",
                                                      height: 14,
                                                      width: 10,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          if (_selectedCategoryIndex == index)...[
                                          ListView.builder(
                                            physics: NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: categoryController.categoryList[index].subcategory.length,
                                              itemBuilder:
                                                  (context, subIndex) {
                                                return categoryController.categoryList[index].subcategory.length!=0 ?Column(
                                                        children: [
                                                          Divider(height: 0.8, thickness: 0.9, indent: 1, color: AppTheme.grayText,),
                                                          GestureDetector(
                                                            onTap:(){
                                                              Get.to(ProductPage(categoryController.categoryList[index].categoryId.toString(),categoryController.categoryList[index].subcategory[subIndex].subcategoryId.toString(),""));
                                                            },
                                                            child: Container(
                                                              color: AppTheme.back_color,
                                                              child: Padding(
                                                                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                                                                child: Row(
                                                                  children: [
                                                                    SizedBox(
                                                                      width: 30,
                                                                    ),
                                                                    CachedNetworkImage(
                                                                      height:
                                                                          60,
                                                                      width: 50,
                                                                      imageUrl: ImageUtility.ImageUrl(categoryController.categoryList[index].subcategory[subIndex].subCategoryImage),
                                                                      progressIndicatorBuilder: (context,
                                                                              url,
                                                                              downloadProgress) =>  Container(
                                                                                  width: 40,
                                                                                  height: 40,
                                                                                  child:  CircularProgressIndicator(),
                                                                                ),

                                                                      errorWidget: (context, url, error) => Image.asset("assets/images/appicon.png",
                                                                        height: 60,
                                                                        width: 50,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    Text(
                                                                      categoryController.categoryList[index].subcategory[subIndex].subCategoryName,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          color:
                                                                              AppTheme.dark_font_color),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    : SizedBox();
                                              })
                                         ]
                                        ],
                                      ),
                                      if (index != categoryController.categoryList.length - 1) ...[
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
                                }):Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/svg/nodata_found.gif",
                                    height: 150,
                                    width: 150,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      'No Record Found...',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppTheme.dark_font_secondary,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                        }),
                      ),
                    ),
                  ),

                  //// brand List
                  Visibility(
                    visible: visibleBlockBrand,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Container(
                        width: Get.width,
                        decoration: CustomDecorations()
                            .BackgroundDecorationwithRadiusTen(),
                        child: Obx(() {
                          if (brandController.isLoading.value)
                            return Center(child: CircularProgressIndicator());
                          else {
                            return brandController.brandList.isNotEmpty
                                ? ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: brandController.brandList.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Get.to(ProductPage(
                                          "",
                                          "",
                                          brandController
                                              .brandList[index].shopId
                                              .toString()));
                                    },
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 14.0,
                                            right: 14.0,
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  CachedNetworkImage(
                                                    height: 50,
                                                    width: 60,
                                                    imageUrl:
                                                    ImageUtility.ImageUrl(
                                                        brandController
                                                            .brandList[
                                                        index]
                                                            .image),
                                                    progressIndicatorBuilder:
                                                        (context, url,
                                                        downloadProgress) =>
                                                        Container(
                                                          width: 50,
                                                          height: 50,
                                                          child: Image.asset(
                                                            "assets/images/appicon.png",
                                                            height: 50,
                                                            width: 50,
                                                          ),
                                                        ),
                                                    errorWidget: (context,
                                                        url, error) =>
                                                        Image.asset(
                                                          "assets/images/appicon.png",
                                                          height: 50,
                                                          width: 50,
                                                        ),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: Text(
                                                      brandController
                                                          .brandList[index]
                                                          .shopName,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                          FontWeight.w500,
                                                          color: AppTheme
                                                              .dark_font_color),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (index !=
                                            brandController.brandList.length -
                                                1) ...[
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
                                    ),
                                  );
                                })
                                : Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/svg/nodata_found.gif",
                                    height: 150,
                                    width: 150,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      'No Record Found...',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppTheme.dark_font_secondary,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )

        ],
      );
  }


}
