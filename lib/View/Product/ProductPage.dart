import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:kirpix/Model/CategorySubcategoryProductList.dart';
import 'package:kirpix/Utils/Constant/ApiConfig/ApiEndPoints.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../AppBarWithBack.dart';
import '../../Controller/CategorySubcategoryProductController.dart';
import '../../Controller/ShoppingListAddController.dart';
import '../../Controller/TrendingProductController.dart';
import '../../DrawerPages/ShoppingListPage.dart';
import '../../Utils/Constant/AppTheme.dart';
import '../../Utils/Constant/Const.dart';
import '../../Utils/Constant/analytics_service.dart';
import '../../Widgets/ImageUtility.dart';
import '../../Widgets/Shadow.dart';
import '../Search/CustomSearchPage.dart';
import 'package:http/http.dart' as http;

class ProductPage extends StatefulWidget {
  final String categoryID;
  final String subCategoryID;
  final String brandId;

  ProductPage(
      String this.categoryID, String this.subCategoryID, String this.brandId);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {

  CategorySubcategoryProductController categorySubcategoryProductController =
  Get.put(CategorySubcategoryProductController());
  TrendingProductController homeController =
  Get.put(TrendingProductController());
  ShoppingListAddController shoppingListAddController =
  Get.put(ShoppingListAddController());

  TextEditingController cnt_newShoppingName = TextEditingController();

  static SharedPreferences? _prefs;
  late int selectedIndex = -1;
  String selectedFolderId = "";
  bool _apiCalled = true;
  bool flag1 = false;
  bool flag2 = false;
  String orderby = '';
  String CurrentDate=DateTime.now().toString();

  AnalyticsService analyticsService = AnalyticsService();

  static init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    // TODO: implement initState
    categorySubcategoryProductController.getData(
        widget.categoryID, widget.subCategoryID, widget.brandId, "", "", "");
    // analyticsService.logEvent("Product Page");
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
      body: Column(
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
                  color: Color(0xFFC6C6C6).withOpacity(0.75),
                  blurRadius: 4,
                  offset: Offset(0, 0),
                  spreadRadius: 0,
                )
              ],
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Get.to(CustomSearchPage());
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: Container(
                      width: Get.width * 0.78,
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: CustomDecorations()
                          .BackgroundDecorationwithRadiusTen(),
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
                GestureDetector(
                  onTap: () {
                    _addProductFilter(context);
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    padding: const EdgeInsets.all(5),
                    decoration:
                    CustomDecorations().BackgroundDecorationwithRadiusTen(),
                    child: Center(
                      child: Image(
                        image: AssetImage("assets/images/documentfilter.png"),
                        height: 24,
                        width: 24,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (categorySubcategoryProductController.isLoading.value)
                return Center(child: CircularProgressIndicator());
              else {
                return categorySubcategoryProductController.noDataFlag != true
                    ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: categorySubcategoryProductController
                        .productList.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          // addtrending(categorySubcategoryProductController.productList[index]);
                          _viewProductDetails(
                              context,
                              categorySubcategoryProductController
                                  .productList[index]);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 14.0, left: 14.0, right: 14.0),
                          child: Container(
                              width: Get.width,
                              decoration: CustomDecorations()
                                  .BackgroundDecorationwithRedius(),
                              child: Column(
                                children: [
                                  Stack(children: [
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding:
                                              const EdgeInsets.only(
                                                  left: 3.0,
                                                  top: 3,
                                                  bottom: 3),
                                              child: Container(
                                                  width: 90,
                                                  height: 90,
                                                  decoration:
                                                  ShapeDecoration(
                                                    color: Colors.white,
                                                    shape:
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(10),
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                    const EdgeInsets
                                                        .all(5.0),
                                                    child:
                                                    CachedNetworkImage(
                                                      height: 90,
                                                      width: 90,
                                                      imageUrl: ImageUtility.ImageUrl( categorySubcategoryProductController.productList[index].productImage),
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
                                                  )),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            Padding(
                                              padding:
                                              const EdgeInsets.only(
                                                  left: 10.0,
                                                  right: 7,
                                                  top: 5,
                                                  bottom: 8.0),
                                              child: Row(
                                                children: [
                                                  SvgPicture.asset(
                                                    "assets/svg/vector_map.svg",
                                                    height: 15,
                                                    width: 10,
                                                  ),
                                                  SizedBox(
                                                    width: 4,
                                                  ),
                                                  Text(
                                                    "18KM",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                        FontWeight.w700,
                                                        color: AppTheme
                                                            .dark_font_color2),
                                                  ),
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets
                                                        .all(5.0),
                                                    child: Container(
                                                      height: 15,
                                                      width: 1.5,
                                                      color:
                                                      AppTheme.grayText,
                                                    ),
                                                  ),
                                                  Text(
                                                    "Rs ${categorySubcategoryProductController.productList[index].price}",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                        FontWeight.w700,
                                                        color: AppTheme
                                                            .apptheme_color),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                if (_prefs!.getInt(
                                                    Const.customerId) !=
                                                    null) {
                                                  _addNewShoppingList(
                                                      context,
                                                      categorySubcategoryProductController
                                                          .productList[
                                                      index]);
                                                } else {
                                                  showDialog(
                                                      context: context,
                                                      barrierDismissible:
                                                      false,
                                                      builder: (BuildContext
                                                      context) {
                                                        return CustomDialog(
                                                            "Please log in if you wish to create a shopping list.");
                                                      });
                                                }
                                              },
                                              child: Visibility(
                                                visible: true,
                                                child: Padding(
                                                  padding:
                                                  const EdgeInsets.only(
                                                      left: 100.0,
                                                      right: 5,
                                                      top: 35,
                                                      bottom: 7),
                                                  child: Image.asset(
                                                    "assets/images/fav_icon.png",
                                                    height: 30,
                                                    width: 30,
                                                  ),
                                                ),
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
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            categorySubcategoryProductController
                                                .productList[index]
                                                .productName
                                                .length >
                                                15
                                                ? categorySubcategoryProductController
                                                .productList[index]
                                                .productName
                                                .substring(0, 11) +
                                                '...'
                                                : categorySubcategoryProductController
                                                .productList[index]
                                                .productName,
                                            maxLines: 1,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                                color: AppTheme
                                                    .dark_font_color),
                                          ),
                                          SizedBox(
                                            height: 8.0,
                                          ),
                                          Html(
                                              data: categorySubcategoryProductController
                                                  .productList[index]
                                                  .shortDescription,
                                              style: {
                                                "body": Style(
                                                  maxLines: 1,
                                                  fontWeight: FontWeight.w400,
                                                  color: AppTheme
                                                      .dark_font_color,
                                                )
                                              }),
                                          Padding(
                                            padding: const EdgeInsets.only(top:20.0),
                                            child: Text("End Date :- ${categorySubcategoryProductController
                                                .productList[index]
                                                .rate_end_date}",style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black
                                            ),),
                                          )
                                        ],
                                      ),
                                    ),
                                  ]),
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
                                                          categorySubcategoryProductController
                                                              .productList[index].shopImage)),
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
                                                      categorySubcategoryProductController
                                                          .productList[
                                                      index]
                                                          .shopName,
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
                                                    categorySubcategoryProductController.productList[index].addressLine1 +
                                                        "," +
                                                        categorySubcategoryProductController
                                                            .productList[
                                                        index]
                                                            .city +
                                                        "," +
                                                        categorySubcategoryProductController
                                                            .productList[
                                                        index]
                                                            .state,
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
                              )),
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
                );
              }
            }),
          ),

        ],
      ),
    );
  }

  void _addProductFilter(BuildContext context) {
    flag1 = false;
    flag2 = false;
    double min = categorySubcategoryProductController.min.toDouble();
    double max = categorySubcategoryProductController.max.toDouble();

    print("min and max value $min $max");
// Check if min is less than or equal to max
    if (min > max) {

      // If not, set min to a default value and adjust max accordingly
      min =0.0;
      max =100.0; // or any other appropriate default value
    }

    int min_price = 0;
    int max_price = 0;

    RangeValues values = RangeValues(min, max);
    RangeLabels labels = RangeLabels(min.toString(), max.toString());
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        barrierColor: Colors.black.withAlpha(1),
        context: context,
        isScrollControlled: true,
        isDismissible: true,
        builder: (BuildContext context) {
          return DraggableScrollableSheet(
            maxChildSize: 0.36,
            initialChildSize: 0.36,
            minChildSize: 0.36,
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
                                  decoration: CustomDecorations()
                                      .BackgroundDecorationwithRadiusTen(),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(13.0),
                                          child: Row(
                                            children: [
                                              Row(
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets.all(8.0),
                                                    child: Text(
                                                      'Price',
                                                      style: TextStyle(
                                                          color: AppTheme
                                                              .dark_font_color,
                                                          fontSize: 16,
                                                          fontWeight:
                                                          FontWeight.w700),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Spacer(),
                                              SvgPicture.asset(
                                                'assets/svg/down_arrow.svg',
                                                height: 24.0,
                                                width: 24.0,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Divider(
                                        height: 0.8,
                                        thickness: 0.9,
                                        indent: 1,
                                        color: AppTheme.grayText,
                                      ),
                                      //range silder
                                      Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                        children: [
                                          RangeSlider(
                                            divisions: 5,
                                            values: values,
                                            labels: labels,
                                            onChanged: (value) {
                                              setStateInsideBottomSheet(() {
                                                values = value;
                                                labels = RangeLabels(
                                                    "Rs.${value.start.toInt().toString()}",
                                                    "Rs.${value.end.toInt().toString()}"
                                                );
                                                min_price = value.start.toInt();
                                                max_price = value.end.toInt();
                                              });
                                            },
                                            min: min,
                                            max: max,
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                              /* SizedBox(
                            height: 20,
                          ),
                          Container(
                              width: Get.width,
                              decoration: CustomDecorations()
                                  .BackgroundDecorationwithRadiusTen(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () {},
                                    child: Padding(
                                      padding: const EdgeInsets.all(13.0),
                                      child: Row(
                                        children: [
                                          Row(
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  'Sorting',
                                                  style: TextStyle(
                                                      color: AppTheme
                                                          .dark_font_color,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Spacer(),
                                          SvgPicture.asset(
                                            'assets/svg/down_arrow.svg',
                                            height: 24.0,
                                            width: 24.0,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Divider(
                                    height: 0.8,
                                    thickness: 0.9,
                                    indent: 1,
                                    color: AppTheme.grayText,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setStateInsideBottomSheet(() {
                                        flag1 = true;
                                        flag2 = false;
                                        orderby = 'ASC';
                                      });
                                    },
                                    child: Container(
                                      color: flag1
                                          ? AppTheme.back_color
                                          : Colors.transparent,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            right: 14.0, left: 14.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            SvgPicture.asset(
                                              'assets/svg/dot_symbol.svg',
                                              color: flag1
                                                  ? AppTheme.apptheme_color
                                                  : AppTheme
                                                      .dark_font_secondary,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(14.0),
                                              child: Text("Ascending",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: flag1
                                                        ? AppTheme
                                                            .apptheme_color
                                                        : AppTheme
                                                            .dark_font_color,
                                                    fontWeight: FontWeight.w500,
                                                  )),
                                            ),
                                            Spacer(),
                                            flag1
                                                ? SvgPicture.asset(
                                                    'assets/svg/ticksquare.svg')
                                                : SizedBox(),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Divider(
                                    height: 0.8,
                                    thickness: 0.9,
                                    indent: 1,
                                    color: AppTheme.grayText,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setStateInsideBottomSheet(() {
                                        flag1 = false;
                                        flag2 = true;
                                        orderby = 'DESC';
                                      });
                                    },
                                    child: Container(
                                      color: flag2
                                          ? AppTheme.back_color
                                          : Colors.transparent,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            right: 14.0, left: 14.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            SvgPicture.asset(
                                              'assets/svg/dot_symbol.svg',
                                              color: flag2
                                                  ? AppTheme.apptheme_color
                                                  : AppTheme
                                                      .dark_font_secondary,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(14.0),
                                              child: Text("Descending",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: flag2
                                                        ? AppTheme
                                                            .apptheme_color
                                                        : AppTheme
                                                            .dark_font_color,
                                                    fontWeight: FontWeight.w500,
                                                  )),
                                            ),
                                            Spacer(),
                                            flag2
                                                ? SvgPicture.asset(
                                                    'assets/svg/ticksquare.svg')
                                                : SizedBox(),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )),*/
                              SizedBox(
                                height: 30,
                              ),
                              GestureDetector(
                                onTap: () {
                                  // min_price
                                  // max_price
                                  //orderby
                                  if (min_price == 0 && max_price == 0) {
                                    Navigator.pop(context);
                                  } else {
                                    categorySubcategoryProductController.getData(
                                        widget.categoryID,
                                        widget.subCategoryID,
                                        widget.brandId,
                                        min_price.toString(),
                                        max_price.toString(),
                                        "ASC");
                                    Navigator.pop(context);
                                  }
                                },
                                child: Container(
                                  height: 52,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 14),
                                  decoration: ShapeDecoration(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          width: 0.50, color: Color(0xFF7DCA2E)),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: SizedBox(
                                          child: Text(
                                            'Apply Filter',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Color(0xFF7DCA2E),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              height: 1.50,
                                              letterSpacing: 0.60,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              GestureDetector(
                                onTap: () {
                                  // min_price
                                  // max_price
                                  //orderby

                                  categorySubcategoryProductController.getData(
                                      widget.categoryID,
                                      widget.subCategoryID,
                                      widget.brandId,
                                      "",
                                      "",
                                      "");
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  height: 52,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 14),
                                  decoration: ShapeDecoration(
                                    color: AppTheme.apptheme_color,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          width: 0.50, color: Color(0xFF7DCA2E)),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: SizedBox(
                                          child: Text(
                                            'Clear Filter',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              height: 1.50,
                                              letterSpacing: 0.60,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      decoration:
                      CustomDecorations().BackgroundDecorationwithRedius(),
                    );
                  });
            },
          );
        });
  }

  void _viewProductDetails(BuildContext context, ScProduct productList) {
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
                        SizedBox(
                          height: 7,
                        ),
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
                                decoration:
                                CustomDecorations().buttonwithRadiusTen(15),
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
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                            width: Get.width,
                            decoration: CustomDecorations()
                                .BackgroundDecorationwithRadiusTen(),
                            child: Stack(children: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                                                  borderRadius:
                                                  BorderRadius.circular(10),
                                                ),
                                              ),
                                              child: Padding(
                                                padding:
                                                const EdgeInsets.all(5.0),
                                                child: Image.network(
                                                  ImageUtility.ImageUrl(
                                                      productList.productImage),
                                                ),
                                              )),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 100.0,
                                    right: 8.0,
                                    bottom: 8.0,
                                    top: 8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      productList.productName,
                                      maxLines: 3,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: AppTheme.dark_font_color),
                                    ),
                                    Text(
                                      productList.shortDescription,
                                      maxLines: 3,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: AppTheme.dark_font_color),
                                    ),
                                  ],
                                ),
                              ),
                            ])),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          width: Get.width,
                          decoration: CustomDecorations()
                              .BackgroundDecorationwithRadiusTen(),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 24.0,
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
                                          "assets/images/brand.png",
                                          height: 20,
                                          width: 20,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          'Brand',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color:
                                              AppTheme.dark_font_secondary),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Padding(
                                      padding:
                                      const EdgeInsets.only(left: 25.0),
                                      child: Text(
                                        productList.brandName,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: AppTheme.apptheme_color),
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
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          "assets/images/address.png",
                                          height: 20,
                                          width: 20,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          'Address',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color:
                                              AppTheme.dark_font_secondary),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Padding(
                                      padding:
                                      const EdgeInsets.only(left: 25.0),
                                      child: Text(
                                        productList.addressLine1 +
                                            "," +
                                            productList.city +
                                            "," +
                                            productList.state,
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: AppTheme.dark_font_color),
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
                                            itemCount: productList.outlets.length,
                                            itemBuilder: (context, index) {
                                              var i=index+1;
                                              return Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets.only(left: 25.0),
                                                    child: Text(
                                                      i.toString()+". "+productList.outlets[index].outletName,
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.w600,
                                                          color: AppTheme.dark_font_color),
                                                    ),
                                                  ), Padding(
                                                    padding:
                                                    const EdgeInsets.only(left: 25.0),
                                                    child: Text(
                                                      "- "+productList.outlets[index].addressLine1,
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
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          "assets/images/description.png",
                                          height: 20,
                                          width: 20,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          'Description',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color:
                                              AppTheme.dark_font_secondary),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Padding(
                                      padding:
                                      const EdgeInsets.only(left: 25.0),
                                      child: Html(
                                          data: productList.description,
                                          style: {
                                            "body": Style(
                                              fontWeight: FontWeight.w400,
                                              color: AppTheme.dark_font_color,
                                              fontSize: FontSize(12.0),
                                            )
                                          }),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
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
                                      "Rs." + productList.price.toString(),
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
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: Container(
                                width: Get.width,
                                height: 50,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 15),
                                decoration:
                                CustomDecorations().buttonwithRadiusTen(10),
                                child: GestureDetector(
                                  onTap: () {
                                    if (_prefs!.getInt(Const.customerId) !=
                                        null) {
                                      _addNewShoppingList(context, productList);
                                    } else {
                                      showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (BuildContext context) {
                                            return CustomDialog(
                                                "Please log in if you wish to create a shopping list.");
                                          });
                                    }
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        "assets/svg/fav_icon.svg",
                                        height: 20,
                                        width: 20,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
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
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
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

  void _addNewShoppingList(BuildContext context, ScProduct productList) {
    int qtyup = 1;
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
                                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
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
                                            _apiCalled
                                                ? GestureDetector(
                                              onTap: () {
                                                if (cnt_newShoppingName
                                                    .text.isNotEmpty) {
                                                  addNewList();
                                                  setStateInsideBottomSheet(
                                                          () {
                                                        _apiCalled = false;
                                                      });

                                                  Timer(Duration(seconds: 4),
                                                          () {
                                                        setStateInsideBottomSheet(
                                                                () {
                                                              _apiCalled = true;
                                                            });
                                                      });
                                                } else {
                                                  Get.snackbar(
                                                    "Alert",
                                                    'Please Enter Shopping Title',
                                                    // Message to display
                                                    snackPosition:
                                                    SnackPosition.BOTTOM,
                                                    // Choose the position
                                                    backgroundColor:
                                                    Colors.black87,
                                                    // Background color
                                                    colorText: Colors
                                                        .white, // Text color
                                                  );
                                                }
                                              },
                                              child: Container(
                                                width: 65,
                                                height: 30,
                                                decoration:
                                                CustomDecorations()
                                                    .buttonwithRadiusTen(
                                                    10),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .center,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .center,
                                                  children: [
                                                    Text(
                                                      'Add',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.white,
                                                        fontWeight:
                                                        FontWeight.w700,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                                : SizedBox(
                                              height: 30,
                                              width: 30,
                                              child:
                                              CircularProgressIndicator(),
                                            )
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
                                          SizedBox(
                                            width: 7.0,
                                          ),
                                          Container(
                                            child: Image.network(
                                              ImageUtility.ImageUrl(
                                                  productList.productImage),
                                              height: 52.0,
                                              width: 52.0,
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.fromLTRB(
                                                    8.0, 0.0, 8.0, 2.0),
                                                //12 char only
                                                child: Text(
                                                  productList.productName.length >
                                                      22
                                                      ? productList.productName
                                                      .substring(0, 20) +
                                                      '...'
                                                      : productList.productName,
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                      color:
                                                      AppTheme.dark_font_color,
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w700),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.fromLTRB(
                                                    8.0, 2.0, 8.0, 2.0),
                                                child: Text(
                                                  'Rs.' +
                                                      productList.price.toString(),
                                                  style: TextStyle(
                                                      color:
                                                      AppTheme.apptheme_color,
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w700),
                                                ),
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
                                              height: 24,
                                              width: 24,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Text(
                                            qtyup.toString(),
                                            style: TextStyle(
                                                color: AppTheme.dark_font_secondary,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
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
                                              height: 24,
                                              width: 24,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 15,
                                          )
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
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(14.0),
                                            child: Text("Your Shoping List",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                )),
                                          ),
                                        ],
                                      ),
                                      Obx(
                                            () => ListView.builder(
                                            shrinkWrap: true,
                                            itemCount:
                                            homeController.slFolderList.length,
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
                                                  homeController.slFolderList[index]
                                                      .is_shared
                                                      ? GestureDetector(
                                                      onTap: () {
                                                        selectedIndex = index;
                                                        selectedFolderId =
                                                            homeController
                                                                .slFolderList[
                                                            index]
                                                                .shoppingFolderId
                                                                .toString();
                                                        setStateInsideBottomSheet(
                                                                () {
                                                              print(selectedIndex);
                                                            });
                                                      },
                                                      child: Container(
                                                        color: selectedIndex ==
                                                            index
                                                            ? AppTheme
                                                            .back_color
                                                            : Colors
                                                            .transparent,
                                                        child: Padding(
                                                          padding:
                                                          const EdgeInsets
                                                              .only(
                                                              right: 14.0,
                                                              left: 14.0),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                            children: [
                                                              SvgPicture.asset(
                                                                'assets/svg/dot_symbol.svg',
                                                                color: selectedIndex == index
                                                                    ? AppTheme
                                                                    .apptheme_color
                                                                    : AppTheme
                                                                    .dark_font_secondary,
                                                              ),
                                                              Padding(
                                                                padding:
                                                                const EdgeInsets
                                                                    .all(
                                                                    14.0),
                                                                child: Text(
                                                                    homeController
                                                                        .slFolderList[
                                                                    index]
                                                                        .shoppingFolderTitle,
                                                                    style:
                                                                    TextStyle(
                                                                      fontSize:
                                                                      16,
                                                                      color: selectedIndex ==
                                                                          index
                                                                          ? AppTheme
                                                                          .apptheme_color
                                                                          : AppTheme
                                                                          .dark_font_color,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                    )),
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
                                                      ))
                                                      : SizedBox(),
                                                ],
                                              );
                                            }),
                                      ),
                                    ],
                                  )),
                              SizedBox(
                                height: 14,
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (selectedFolderId.isNotEmpty) {
                                    Navigator.pop(context);
                                    addProductIntoShoppingFolder(
                                        productList.productId,
                                        productList.shopId,
                                        selectedFolderId,
                                        qtyup);
                                  } else {
                                    Get.snackbar(
                                      "Alert",
                                      'Please Select Your Shopping Folder',
                                      // Message to display
                                      snackPosition: SnackPosition.TOP,
                                      // Choose the position
                                      backgroundColor: Colors.black87,
                                      // Background color
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
                                        color: Color(0xFFC6C6C6).withOpacity(0.75),
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
                  });
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

      cnt_newShoppingName.text = "";
      homeController.getHomeFolderData(_prefs!.getInt(Const.customerId)!);
      shoppingListAddController
          .getData(_prefs!.getInt(Const.customerId) as int);

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

  Future<void> addProductIntoShoppingFolder(
      int productId, int shopId, String selectedIndex, int qtyup) async {
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

  Future<void> addtrending(ScProduct productList) async {
    String body = json.encode({
      'product_id': productList.productId,
      'city_id': productList.cityId.toString(),
    });

    final response = await http.post(
      Uri.parse(ApiEndPoints.insertTrendingProducts),
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    Map<String, dynamic> data = jsonDecode(response.body);
    if (data['status'] == "success") {
      print(data['message']);
    } else {
      print('error');
    }
  }
}