import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:kirpix/Controller/HomeController.dart';
import 'package:kirpix/Controller/MemberController.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Controller/ShoppingListAddController.dart';
import '../Utils/Constant/ApiConfig/ApiEndPoints.dart';
import '../Utils/Constant/AppTheme.dart';
import '../Utils/Constant/Const.dart';
import '../View/LoginFlow/LoginScreen.dart';
import '../View/Search/CustomSearchPage.dart';
import '../View/Setting/AddMember.dart';
import '../View/ShoppingPages/ShoppingListScreenAddPage.dart';
import '../Widgets/Shadow.dart';
import 'package:http/http.dart' as http;

class ShoppingListPage extends StatefulWidget {
  const ShoppingListPage({Key? key}) : super(key: key);

  @override
  State<ShoppingListPage> createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  ShoppingListAddController shoppingListAddController =
      Get.put(ShoppingListAddController());
  HomeController homeController = Get.put(HomeController());
  late int selectedIndex = -1;
  String selectedMemberId = "";
  TextEditingController cnt_newShoppingName = TextEditingController();
  static SharedPreferences? _prefs;
  bool _isLoading = false;

  static init() async {
    _prefs = await SharedPreferences.getInstance();

  }

  bool _apiCalled = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration(seconds: 2),
          () {
        shoppingListAddController
            .getData(_prefs!.getInt(Const.customerId) as int);
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    init();

    return RefreshIndicator(
      onRefresh: () {
        return Future.delayed(
          Duration(seconds: 1),
          () {
            shoppingListAddController
                .getData(_prefs!.getInt(Const.customerId) as int);
            setState(() {});
          },
        );
      },
      child: OverlayLoaderWithAppIcon(
        isLoading: _isLoading,
        overlayBackgroundColor: Colors.black,
        circularProgressColor: Color(0xff7dca2e),
        appIcon: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/images/appicon.png'),
        ),
        child: Column(
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
            SizedBox(
              height: 20,
            ),
            if (_prefs?.getInt(Const.customerId) != null) ...[
              Expanded(
                child: Obx(() {
                  if (shoppingListAddController.isLoading.value)
                    return shoppingListAddController.noDataFlag == true
                        ? Center(child: CircularProgressIndicator())
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
                                  'Please wait...',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.dark_font_secondary,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          );
                  else {
                    return shoppingListAddController.noDataFlag != true
                        ? ListView.builder(
                        shrinkWrap: true,
                        itemCount:
                        shoppingListAddController.slFolderList.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0, right: 20.0, bottom: 8.0),
                            child: GestureDetector(
                              onLongPress: () {
                                //
                              },
                              onTap: () {
                                String userID = _prefs!
                                    .getInt(Const.customerId)
                                    .toString();
                                Get.to(ShoppingListScreenAddPage(
                                    userID,
                                    shoppingListAddController
                                        .slFolderList[index]
                                        .shoppingFolderId
                                        .toString(),
                                    shoppingListAddController
                                        .slFolderList[index]
                                        .shoppingFolderTitle,
                                    shoppingListAddController
                                        .slFolderList[index].is_shared));
                              },
                              child: Container(
                                  width: Get.width,
                                  height: 60,
                                  decoration: CustomDecorations()
                                      .BackgroundDecorationwithRadiusTen(),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 13.0, bottom: 13.0),
                                    child: Row(
                                      children: [
                                        Row(
                                          children: <Widget>[
                                            Container(
                                              padding: EdgeInsets.only(
                                                  left: 11.0,
                                                  right: 8.0,
                                                  top: 8.0,
                                                  bottom: 8.0),
                                              child: SvgPicture.asset(
                                                'assets/svg/groups.svg',
                                                height: 24.0,
                                                width: 24.0,
                                              ),
                                            ),
                                            Container(
                                              child: Text(
                                                shoppingListAddController
                                                    .slFolderList[index]
                                                    .shoppingFolderTitle,
                                                style: TextStyle(
                                                    color: AppTheme
                                                        .dark_font_color,
                                                    fontSize: 16,
                                                    fontWeight:
                                                    FontWeight.w500),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Spacer(),
                                        Row(
                                          children: [
                                            shoppingListAddController
                                                .slFolderList[index]
                                                .is_shared
                                                ? GestureDetector(
                                              onTap: () {
                                                shoppingListAddController
                                                    .getMemberData(_prefs!
                                                    .getInt(Const
                                                    .customerId)
                                                    .toString());

                                                _shareMemberList(context,shoppingListAddController.slFolderList[index].shoppingFolderId);
                                              },
                                              child: Image.asset(
                                                'assets/images/frameShare.png',
                                                height: 32.0,
                                                width: 32.0,
                                              ),
                                            ):SizedBox(),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                            //    _isLoading=true;
                                                setState(() {

                                                });
                                                showCustomAlertDialog(
                                                  context, shoppingListAddController.slFolderList[index].shoppingFolderId.toString());

                                              },
                                              child:  Padding(
                                                padding: const EdgeInsets.only(top: 5.0),
                                                child: Image.asset(
                                                  'assets/images/framedelete.png',
                                                  height: 26.0,
                                                  width: 40.0,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
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
                                  'No Record Found...',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.dark_font_secondary,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          );
                  }
                }),
              ),
            ] else ...[
               Expanded(
                child: Center(
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
                        'No Record Found....',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.dark_font_secondary,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
            Padding(
              padding: const EdgeInsets.only(
                  bottom: 15.0, left: 20.0, right: 20.0, top: 10.0),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (_prefs!.getInt(Const.customerId) != null) {
                        _addNewShoppingList(context);
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
                      decoration: CustomDecorations().buttonwithRadiusTen(10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Add New Shopping List',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
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
            ),
          ],
        ),
      ),
    );
  }

  showCustomAlertDialog(BuildContext context1, String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete"),
          content: Text("Are you sure you want to delete this shopping list."),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  child: Text("Delete"),
                  onPressed: () async {
                    deletedList(_prefs!.getInt(Const.customerId).toString(),id);
                    Navigator.pop(context);

                  },
                ),
                TextButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.pop(context); // Close dialog
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _addNewShoppingList(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        barrierColor: Colors.black.withAlpha(1),
        context: context,
        isScrollControlled: true,
        isDismissible: true,
        builder: (BuildContext context) {
          return DraggableScrollableSheet(
            maxChildSize: 0.55,
            initialChildSize: 0.55,
            minChildSize: 0.55,
            builder: (context, scrollController) {
              return StatefulBuilder(builder: (context, setStateInsheet) {
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
                                            keyboardType: TextInputType.name,
                                            autofocus: true,
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
                                                  setStateInsheet(() {
                                                    _apiCalled = false;
                                                  });
                                                  Timer(Duration(seconds: 4),
                                                      () {
                                                    setStateInsheet(() {
                                                      _apiCalled = true;
                                                    });
                                                  });
                                                  Navigator.pop(context);
                                                  addNewList(_prefs!
                                                      .getInt(Const.customerId)
                                                      .toString());
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
                            height: 20,
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

  void _shareMemberList(BuildContext context, int shoppingFolderId) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        barrierColor: Colors.black.withAlpha(1),
        context: context,
        isScrollControlled: true,
        isDismissible: true,
        builder: (BuildContext context) {
          return DraggableScrollableSheet(
            maxChildSize: 0.70,
            initialChildSize: 0.50,
            minChildSize: 0.50,
            builder: (context, scrollController) {
              return StatefulBuilder(
                  builder: (context, setStateInsideBottomSheet) {
                return Container(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
/*
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
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(14.0),
                                        child: Text(
                                          'Share With Member',
                                          maxLines: 1,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              color: AppTheme.dark_font_color),
                                        ),
                                      ),
                                      Obx(() =>
                                          ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: shoppingListAddController
                                                  .mmList.length,
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

                                                    GestureDetector(
                                                        onTap: () {
                                                          selectedIndex = index;
                                                          selectedMemberId = shoppingListAddController.mmList[index].memberId.toString();
                                                          setStateInsideBottomSheet(() {
                                                            print(
                                                                selectedIndex);
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
                                                            padding: const EdgeInsets
                                                                .only(
                                                                right: 14.0,
                                                                left: 14.0),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment
                                                                  .start,
                                                              children: [
                                                                SvgPicture
                                                                    .asset(
                                                                  'assets/svg/dot_symbol.svg',
                                                                  color: selectedIndex ==
                                                                      index
                                                                      ? AppTheme
                                                                      .apptheme_color
                                                                      : AppTheme
                                                                      .dark_font_secondary,),

                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                      .all(
                                                                      10.0),
                                                                  child: Column(
                                                                    crossAxisAlignment: CrossAxisAlignment
                                                                        .start,
                                                                    children: [
                                                                      Text(
                                                                          shoppingListAddController
                                                                              .mmList[index]
                                                                              .fullName,
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
                                                                      Text(
                                                                          shoppingListAddController
                                                                              .mmList[
                                                                          index]
                                                                              .phoneNumber,
                                                                          style:
                                                                          TextStyle(
                                                                            fontSize: 16,
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
                                                                    ],
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
                                                    ),


                                                  ],
                                                );
                                              })),
                                    ],
                                  )),
                              SizedBox(
                                height: 20,
                              ),
                              GestureDetector(
                                onTap: (){
                                  Navigator.pop(context);
                                  String userID= _prefs!.getInt(Const.customerId).toString();
                                  ShareFolderToMember(userID,shoppingFolderId.toString() ,selectedMemberId);
                                  setStateInsideBottomSheet(() {

                                  });
                                },
                                child: Container(
                                  height: 52,
                                  width: Get.width,
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
                                  child: SizedBox(
                                    child: Text(
                                      'Share Now',
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
                              ),
                              SizedBox(height: 10,),
                              GestureDetector(
                                onTap: (){
                                  Navigator.pop(context);
                                  String userID= _prefs!.getInt(Const.customerId).toString();
                                  Get.to(AddMember("add",userID,"","","","","","",""));

                                  setStateInsideBottomSheet(() {

                                  });
                                },
                                child: Container(
                                  height: 52,
                                  width: Get.width,
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
                                  child: SizedBox(
                                    child: Text(
                                      'Add Member',
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
                              ),
                            ],
                          ),
*/

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
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(14.0),
                                    child: Text(
                                      'Share With Member',
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: AppTheme.dark_font_color),
                                    ),
                                  ),
                                  Obx(() => ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: shoppingListAddController
                                          .mmList.length,
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
                                            GestureDetector(
                                                onTap: () {
                                                  selectedIndex = index;
                                                  selectedMemberId =
                                                      shoppingListAddController
                                                          .mmList[index]
                                                          .memberId
                                                          .toString();
                                                  setStateInsideBottomSheet(() {
                                                    print(selectedIndex);
                                                  });
                                                },
                                                child: Container(
                                                  color: selectedIndex == index
                                                      ? AppTheme.back_color
                                                      : Colors.transparent,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
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
                                                                  .all(10.0),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                  shoppingListAddController
                                                                          .mmList[
                                                                              index]
                                                                          .first_name +
                                                                      "" +
                                                                      shoppingListAddController
                                                                          .mmList[
                                                                              index]
                                                                          .last_name,
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
                                                              Text(
                                                                  shoppingListAddController
                                                                      .mmList[
                                                                          index]
                                                                      .phoneNumber,
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
                                                            ],
                                                          ),
                                                        ),
                                                        Spacer(),
                                                        selectedIndex == index
                                                            ? SvgPicture.asset(
                                                                'assets/svg/ticksquare.svg')
                                                            : SizedBox(),
                                                      ],
                                                    ),
                                                  ),
                                                )),
                                          ],
                                        );
                                      })),
                                ],
                              )),
                          SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              String userID =
                                  _prefs!.getInt(Const.customerId).toString();
                              ShareFolderToMember(
                                  userID,
                                  shoppingFolderId.toString(),
                                  selectedMemberId);
                              setStateInsideBottomSheet(() {});
                            },
                            child: Container(
                              height: 52,
                              width: Get.width,
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
                              child: SizedBox(
                                child: Text(
                                  'Share Now',
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
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              String userID =
                                  _prefs!.getInt(Const.customerId).toString();
                              Get.to(AddMember("add", userID, "", "", "", "",
                                  "", "", "", ""));

                              setStateInsideBottomSheet(() {});
                            },
                            child: Container(
                              height: 52,
                              width: Get.width,
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
                              child: SizedBox(
                                child: Text(
                                  'Add Member',
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

  ShareFolderToMember(String custId, String folderId, String memberId) async {
    var map = new Map<String, dynamic>();
    map['folder_id'] = folderId;
    map['customer_id'] = custId;
    map['to_share_customer_id'] = memberId;

    final uri = ApiEndPoints.shareFolder;
    final response = await http.post(Uri.parse(uri), body: map);

    Map<String, dynamic> data = jsonDecode(response.body);
    if (data['status'] == 'success') {
      Get.snackbar(data['status'], data['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppTheme.apptheme_color.withOpacity(0.10),
          colorText: AppTheme.apptheme_color,
          borderColor: AppTheme.apptheme_color,
          borderWidth: 1,
          margin: EdgeInsets.only(bottom: 20, left: 10.0, right: 10.0));
    } else {
      Get.snackbar(data['status'], data['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppTheme.apptheme_color.withOpacity(0.10),
          colorText: AppTheme.apptheme_color,
          borderColor: AppTheme.apptheme_color,
          borderWidth: 1,
          margin: EdgeInsets.only(bottom: 20, left: 10.0, right: 10.0));

      throw Exception('Failed to load data${response.statusCode}');
    }
  }

  Future<void> addNewList(String userId) async {
    String body = json.encode({
      'shopping_title': cnt_newShoppingName.text,
      'customer_id': userId,
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
      shoppingListAddController
          .getData(_prefs!.getInt(Const.customerId) as int);
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

  Future<void> deletedList(String userId, String id) async {
    String body = json.encode({
      'shopping_id': id,
      'customer_id': userId,
    });

    final response = await http.post(
      Uri.parse(ApiEndPoints.deleteShoppingList),
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    Map<String, dynamic> data = jsonDecode(response.body);
    if (data['status'] == "success") {
      setState(() {});
      _isLoading = false;
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
}

class CustomDialog extends StatelessWidget {
  String msg = "";

  CustomDialog(String this.msg);

  dialogContent(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: const Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // To make the card compact
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(17.0),
            child: Text(
              "Alert !",
              style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.danger_),
            ),
          ),
          Divider(
            height: 0.8,
            thickness: 0.9,
            indent: 1,
            color: AppTheme.grayText,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              msg,
              style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.dark_font_color),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 17.0, right: 17.0, bottom: 17.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 0.50, color: Color(0xFFDFE2E5)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Cancel',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF484848),
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      color: AppTheme.apptheme_color,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 0.50, color: Color(0xFFDFE2E5)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (BuildContext context) => LoginScreen()));
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Login',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
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
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }
}
