import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
// import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart' hide CarouselController;
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:kirpix/Model/HomeListModel.dart';
import 'package:kirpix/Utils/Constant/ApiConfig/ApiEndPoints.dart';
import 'package:kirpix/Utils/Constant/AppTheme.dart';
import 'package:kirpix/View/Search/CustomSearchPage.dart';
import 'package:kirpix/Widgets/ImageUtility.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../Controller/HomeController.dart';
import '../Controller/ShoppingListAddController.dart';
import '../InternetConnection/ConnectionManagerController.dart';
import '../Utils/Constant/Const.dart';
import '../View/Product/ViewMoreProduct.dart';
import '../Widgets/Shadow.dart';
import 'ShoppingListPage.dart';

class MainHome extends StatefulWidget {
  const MainHome({Key? key}) : super(key: key);

  @override
  State<MainHome> createState() => _MainHomeState();
}


PackageInfo _packageInfo = PackageInfo(
  appName: 'Unknown',
  packageName: 'Unknown',
  version: 'Unknown',
  buildNumber: 'Unknown',
  buildSignature: 'Unknown',
);

class _MainHomeState extends State<MainHome> {
  ConnectionManagerController _controller =
  Get.put(ConnectionManagerController());
  HomeController homeController = Get.put(HomeController());
  ShoppingListAddController shoppingListAddController =
  Get.put(ShoppingListAddController());
   // CarouselController _carouselController = CarouselController();
  int _currentIndex = 0;
  TextEditingController cnt_newShoppingName = TextEditingController();
  static SharedPreferences? _prefs;
  late int selectedIndex = -1;
  String selectedFolderId = "";
  bool isVisible = false;
  int qtyup = 1;
  bool _apiCalled = true;

  static init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    startAutoSwipe();
    versionCheck(context);
    // checkForUpdate();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      //  showUpdateDialog(context);
    });
  }

  @override
  void dispose() {
    stopAutoSwipe();
    super.dispose();
  }

  void versionCheck(BuildContext context) async {
    try {

      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      var version = packageInfo.version;

      final response = await http.post(
        Uri.parse(ApiEndPoints.versionCheck),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "appVersion": version,
        }),
      );

      print("Local Version--> $version");

      if (response.statusCode == 200) {

        final responseData = jsonDecode(response.body);
        var message = responseData['message'];
        var appLink = responseData['appLink'];
        var latestVersion = responseData['app_version'];
        var databaseVersion=responseData['current_version'];

        if (_isVersionGreaterThan(databaseVersion, version)) {
          showUpdateDialog(context, appLink);
        }
        print("Response received successfully --> $message $appLink $databaseVersion");
      } else {
        print("Something went wrong: ${response.statusCode}");
      }

    } catch (e) {
      print("An error occurred: $e");
    }

  }

  bool _isVersionGreaterThan(String version1, String version2) {

    List<String> version1Parts = version1.split('.');
    List<String> version2Parts = version2.split('.');

    for (int i = 0; i < version1Parts.length; i++) {
      int part1 = int.parse(version1Parts[i]);
      int part2 = int.parse(version2Parts[i]);
      if (part1 > part2) {
        return true;
      } else if (part1 < part2) {
        return false;
      }
    }
    return false;
  }

  showUpdateDialog(BuildContext context,String link) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: Text("Update Available"),
            content: Text(
              "Hey there! We've just released a new update for the app which includes some great new features - so make sure you force update the app to get the latest and greatest!",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    child: Text("Force Update"),
                    onPressed: () async {
                      _launchUrl(link);
                      Navigator.pop(context);
                      // exit(0);
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void startAutoSwipe() {
    Future.delayed(Duration(seconds: 3)).then((value) {
      // _carouselController.nextPage(
      //   duration: Duration(milliseconds: 800),
      //   curve: Curves.ease,
      // );
      startAutoSwipe();
    });
  }

  void stopAutoSwipe() {
     // _carouselController.stopAutoPlay();
    setState(() {});
  }

  AlertDialog checkForUpdate() {
    return AlertDialog();
  }

  @override
  Widget build(BuildContext context) {
    init();
    double screenWidth = MediaQuery.of(context).size.width;
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(Duration(seconds: 1));
        homeController.getData();
        homeController.getName();
        setState(() {});
      },
      child: Scaffold(
        backgroundColor: AppTheme.back_color,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Obx(() => _controller.connectionType.value == 0
                  ? Container(
                width: Get.width,
                color: Colors.red,
                padding: EdgeInsets.all(13.0),
                child: Text(
                  _controller.connectionType.value == 1
                      ? "Wifi Connected"
                      : _controller.connectionType.value == 2
                      ? 'Mobile Data Connected'
                      : 'No Internet',
                  style: const TextStyle(fontSize: 14),
                ),
              )
                  : SizedBox()),
              Padding(
                padding: const EdgeInsets.all(13.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      homeController.userName.toString(),
                      style: TextStyle(
                          color: AppTheme.dark_font_color,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    // Text(
                    //   "Local Build",
                    //   style: TextStyle(
                    //       color: AppTheme.dark_font_color,
                    //       fontSize: 20,
                    //       fontWeight: FontWeight.w700),
                    // ),
                    Text(
                      "Discover prices of all your favourite products",
                      style: TextStyle(
                          color: AppTheme.dark_font_color,
                          fontSize: 20,
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(CustomSearchPage());
                      },
                      child: Container(
                        width: Get.width,
                        height: 40,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
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
                    Obx(() {
                      return homeController.homeSliderList.isEmpty
                          ? SizedBox()  // When the list is empty, render an empty SizedBox
                          : SizedBox(height: 12);  // When the list is not empty, render SizedBox with height
                    }),
                    Obx(() {
                      return homeController.homeSliderList.isNotEmpty
                          ? Text(
                        "Top Deals",                                                             
                        style: TextStyle(
                            color: AppTheme.dark_font_color,
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      )
                          : SizedBox();
                    }),
                    SizedBox(
                      height: 8,
                    ),
                    Obx(() {
                      return homeController.homeSliderList.isNotEmpty
                          ? getSilder()  // Render the slider if the list is not empty
                          : SizedBox();  // Render an empty box if the list is empty
                    }),
                    SizedBox(
                      height: 10,
                    ),
                    homeController.homecustomImageadList.isNotEmpty
                        ? Text(
                      "Sponsored",
                      style: TextStyle(
                          color: AppTheme.dark_font_color,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    )
                        : SizedBox(),
                    Obx(() {
                      return homeController.homecustomImageadList.isNotEmpty
                          ? Container(
                        height: 80,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: List.generate(
                            homeController.homecustomImageadList.length,
                                (int index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: GestureDetector(
                                  onTap: () {
                                    _launch(homeController
                                        .homecustomImageadList[index].adClickUrl);
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.all(Radius.circular(15)),
                                    child: CachedNetworkImage(
                                      imageUrl: ImageUtility.ImageUrl(
                                          homeController.homecustomImageadList[index]
                                              .adImageUrl),
                                      fit: BoxFit.fill,
                                      progressIndicatorBuilder:
                                          (context, url, downloadProgress) => Container(
                                        width: Get.width,
                                        height: Get.height,
                                        decoration: ShapeDecoration(
                                          color: AppTheme.grayText,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15),
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
                                      ),
                                      errorWidget: (context, url, error) => Container(
                                        width: Get.width,
                                        height: Get.height,
                                        decoration: ShapeDecoration(
                                          color: AppTheme.grayText,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15),
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
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      )
                         :SizedBox();
                    }),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Text(
                          "Trending Products",
                          style: TextStyle(
                              color: AppTheme.dark_font_color,
                              fontSize: 16,
                              fontWeight: FontWeight.w700),
                        ),
                        Spacer(),
                        Row(
                          children: [
                            SvgPicture.asset('assets/svg/dot_symbol.svg'),
                            SizedBox(
                              width: 5,
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.to(ViewMoreProduct());
                              },
                              child: Text(
                                "View more",
                                style: TextStyle(
                                    color: AppTheme.dark_font_secondary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Obx(() {
                      if (homeController.isLoading.value)
                        return Center(child: CircularProgressIndicator());
                      else if (homeController.trendingProduct.isEmpty) {
                        return Center(
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
                      } else {
                        return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: homeController.trendingProduct.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {

                                  _viewProductDetails(context,homeController.trendingProduct[index]);

                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 14.0),
                                  child: Container(
                                    width: screenWidth,
                                    decoration: CustomDecorations().BackgroundDecorationwithRedius(),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(10),
                                                child: CachedNetworkImage(
                                                  height: screenWidth * 0.22,
                                                  width: screenWidth * 0.22,
                                                  imageUrl: ImageUtility.ImageUrl(homeController
                                                      .trendingProduct[
                                                  index]
                                                      .productImage),
                                                  fit: BoxFit.fill,
                                                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                                                      Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                                                  errorWidget: (context, url, error) => Image.asset(
                                                    "assets/images/appicon.png",
                                                    height: screenWidth * 0.2,
                                                    width: screenWidth * 0.2,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 10),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      homeController
                                                          .trendingProduct[
                                                      index]
                                                          .productName,
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w700,
                                                        color: AppTheme.dark_font_color,
                                                      ),
                                                    ),
                                                    // Text(
                                                    //   homeController
                                                    //       .trendingProduct[
                                                    //   index]
                                                    //       .shortDescription,
                                                    //   maxLines: 1,
                                                    //   overflow: TextOverflow.ellipsis,
                                                    //   style: TextStyle(
                                                    //     fontSize: 12,
                                                    //     fontWeight: FontWeight.w700,
                                                    //     color: AppTheme.dark_font_color,
                                                    //   ),
                                                    // ),
                                                    Html(
                                                      data: homeController.trendingProduct[index].shortDescription,
                                                      style: {
                                                        "body": Style(
                                                          fontSize: FontSize(12.0),
                                                          fontWeight: FontWeight.w700,
                                                          color: AppTheme.dark_font_color,
                                                          textOverflow: TextOverflow.ellipsis,
                                                          maxLines: 1
                                                        )
                                                      },
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Column(
                                                children: [
                                                  GestureDetector(
                                                    onTap: (){
                                                      if (_prefs!.getInt(Const
                                                          .customerId) !=
                                                          null) {
                                                        _addNewShoppingList(
                                                            context,
                                                            homeController.trendingProduct[index]);
                                                      } else {
                                                        showDialog(
                                                            context: context,
                                                            barrierDismissible:
                                                            false,
                                                            builder:
                                                                (BuildContext
                                                            context) {
                                                              return CustomDialog(
                                                                  "Please log in if you wish to create a shopping list.");
                                                            });
                                                      }
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                                      child: Image.asset(
                                                        "assets/images/fav_icon.png",
                                                        height: screenWidth * 0.08,
                                                        width: screenWidth * 0.08,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 35,),
                                                  Text(
                                                    "Rs. ${homeController.trendingProduct[index].price}",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w700,
                                                      color: AppTheme.apptheme_color,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Divider(height: 1, thickness: 1, color: AppTheme.broder_color),
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Row(
                                            children: [
                                              ClipOval(
                                                child: CachedNetworkImage(
                                                  width: screenWidth * 0.08,
                                                  height: screenWidth * 0.08,
                                                  imageUrl: ImageUtility.ImageUrl(homeController.trendingProduct[index].shopImage),
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                              Expanded(child: Text(
                                                homeController.trendingProduct[index]
                                                    .shopName,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: Color(0xFF4E5157),
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              )),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                      }
                    }),
                  ],
                ),
              ),
            ],
          ),


        ),
      ),
    );
  }

  void _viewProductDetails(
      BuildContext context, TrendingProduct trendingProduct) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        barrierColor: Colors.black.withAlpha(1),
        context: context,
        isScrollControlled: true,
        isDismissible: true,
        builder: (BuildContext context) {
          return DraggableScrollableSheet(
            maxChildSize: 0.87,
            initialChildSize: 0.87,
            minChildSize: 0.87,
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
                                                        trendingProduct
                                                            .productImage)),
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
                                      trendingProduct.productName,
                                      maxLines: 3,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: AppTheme.dark_font_color),
                                    ),
                                    Text(
                                      trendingProduct.shortDescription,
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
                                        trendingProduct.brandName,
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
                                        trendingProduct.addressLine1 +
                                            "," +
                                            trendingProduct.city +
                                            "," +
                                            trendingProduct.state,
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
                                                color: AppTheme.icon_color),
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
                                            physics:
                                            NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount:
                                            trendingProduct.outlets.length,
                                            itemBuilder: (context, index) {
                                              var i = index + 1;
                                              return Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets.only(
                                                        left: 25.0),
                                                    child: Text(
                                                      i.toString() +
                                                          ". " +
                                                          trendingProduct
                                                              .outlets[index]
                                                              .outletName,
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                          FontWeight.w600,
                                                          color: AppTheme
                                                              .dark_font_color),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets.only(
                                                        left: 25.0),
                                                    child: Text(
                                                      "- " +
                                                          trendingProduct
                                                              .outlets[index]
                                                              .outletAddressLine1,
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                          FontWeight.w400,
                                                          color: AppTheme
                                                              .dark_font_color),
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
                                          data: trendingProduct.description,
                                          style: {
                                            "body": Style(
                                              maxLines: 1,
                                              fontWeight: FontWeight.w400,
                                              color: AppTheme.dark_font_color,
                                              fontSize: FontSize(12.0),
                                            )
                                          }),
                                    )
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
                                      "Rs." + trendingProduct.price.toString(),
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
                              child: GestureDetector(
                                onTap: () {
                                  if (_prefs!.getInt(Const.customerId) !=
                                      null) {
                                    _addNewShoppingList(
                                        context, trendingProduct);
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

  getSilder() {
    return Obx(
      () => Stack(alignment: Alignment.bottomCenter, children: [
        // CarouselSlider(
        //     // carouselController: _carouselController,
        //     options: CarouselOptions(
        //       viewportFraction: 1,
        //       aspectRatio: 20 / 10,
        //       initialPage: 0,
        //       enlargeCenterPage: true,
        //       autoPlayInterval: Duration(seconds: 5),
        //       autoPlayAnimationDuration: Duration(milliseconds: 800),
        //       autoPlayCurve: Curves.fastOutSlowIn,
        //       onPageChanged: (index, reason) {
        //         setState(() {
        //           _currentIndex = index;
        //         });
        //       },
        //     ),
        //     items: List.generate(homeController.homeSliderList.length,
        //         (int index) {
        //       return ClipRRect(
        //         borderRadius: BorderRadius.all(Radius.circular(20)),
        //         child: CachedNetworkImage(
        //           imageUrl: ImageUtility.ImageUrl(homeController.homeSliderList[index].sliderImage),
        //           fit: BoxFit.fill, // Placeholder image
        //           progressIndicatorBuilder: (context, url, downloadProgress) => Container(
        //             width: Get.width,
        //             height: Get.height,
        //             decoration: ShapeDecoration(
        //               color: AppTheme.grayText,
        //               shape: RoundedRectangleBorder(
        //                 borderRadius: BorderRadius.circular(15),
        //               ),
        //               shadows: [
        //                 BoxShadow(
        //                   color: Color(0xFFC6C6C6).withOpacity(0.75),
        //                   blurRadius: 4,
        //                   offset: Offset(0, 0),
        //                   spreadRadius: 0,
        //                 )
        //               ],
        //             ),
        //           ),
        //           errorWidget: (context, url, error) => Container(
        //             width: Get.width,
        //             height: Get.height,
        //             decoration: ShapeDecoration(
        //               color: AppTheme.grayText,
        //               shape: RoundedRectangleBorder(
        //                 borderRadius: BorderRadius.circular(15),
        //               ),
        //               shadows: [
        //                 BoxShadow(
        //                   color: Color(0xFFC6C6C6).withOpacity(0.75),
        //                   blurRadius: 4,
        //                   offset: Offset(0, 0),
        //                   spreadRadius: 0,
        //                 )
        //               ],
        //             ),
        //             child: Image.asset('assets/images/imagenotfound.jpg', fit: BoxFit.fill), // Placeholder in case of error
        //           ),
        //         ),
        //       );
        //     })),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: homeController.homeSliderList.asMap().entries.map((entry) {
            return GestureDetector(
              // onTap: () => _carouselController.animateToPage(entry.key),
              child: Container(
                width: 8.0,
                height: 8.0,
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black)
                        .withOpacity(_currentIndex == entry.key ? 0.9 : 0.4)),
              ),
            );
          }).toList(),
        ),
      ]),
    );
  }

  void _addNewShoppingList(
      BuildContext context, TrendingProduct trendingProduct) {
    homeController.getHomeFolderData(_prefs!.getInt(Const.customerId)!);
    shoppingListAddController.getData(_prefs!.getInt(Const.customerId) as int);
    int qtyup = 1;
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
                                                  Navigator.pop(context);
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
                                          SizedBox(
                                            width: 7.0,
                                          ),
                                          Container(
                                            child: Image.network(
                                              ImageUtility.ImageUrl(
                                                  trendingProduct.productImage),
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
                                                  trendingProduct
                                                      .productName.length >
                                                      22
                                                      ? trendingProduct.productName
                                                      .substring(0, 20) +
                                                      '...'
                                                      : trendingProduct.productName,
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
                                                      trendingProduct.price
                                                          .toString(),
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
                                        trendingProduct.productId,
                                        trendingProduct.shopId,
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
      _apiCalled = true;
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
    } else {}
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

  void _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
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