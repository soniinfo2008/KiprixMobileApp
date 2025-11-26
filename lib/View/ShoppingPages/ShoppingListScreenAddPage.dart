import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:kirpix/View/Setting/AddMember.dart';
import 'dart:math' as math;
import '../../AppBarWithBack.dart';
import '../../Controller/ShoppingListAddController.dart';
import '../../Controller/UnderFolderShoppingController.dart';
import '../../Utils/Constant/ApiConfig/ApiEndPoints.dart';
import '../../Utils/Constant/AppTheme.dart';
import '../../Widgets/ImageUtility.dart';
import '../../Widgets/Shadow.dart';
import '../Search/CustomSearchPage.dart';
import 'ShoppingCartPage.dart';
import 'package:http/http.dart'as http;

class ShoppingListScreenAddPage extends StatefulWidget {
  final String userID;
  final String shoppingFolderId;
  final String shoppingFolderTitle;
  final bool is_shared;

  ShoppingListScreenAddPage(String this.userID, String this.shoppingFolderId,
      String this.shoppingFolderTitle, bool this.is_shared);

  @override
  State<ShoppingListScreenAddPage> createState() =>
      _ShoppingListScreenAddPageState();
}

class _ShoppingListScreenAddPageState extends State<ShoppingListScreenAddPage> {
  UnderShoppingController underShoppingController =
      Get.put(UnderShoppingController());
  ShoppingListAddController shoppingListAddController = Get.put(ShoppingListAddController());
  List<int> quantity = [];
  int pageIndex = 0;
  List<bool> itemschecked = [];

  bool isVisible = false;

  double setHeight = 75.0;
  var angle = 180;
  late int selectedIndex = -1;
  String selectedMemberId = "";
  TextEditingController cnt_newShoppingName = TextEditingController();
  TextEditingController cntsearch = TextEditingController();


  void _toggleCategory(int index, bool bool) {
    itemschecked[index]=bool;


    setState(() {
      setHeight = 75.0;
      isVisible = false;
      angle = 180;
    });
  }

  Padding buildbottomLayout(BuildContext context){
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0, 0.0, 0.0),
      child: AnimatedContainer(
        duration: new Duration(milliseconds: 0),
        height: setHeight,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Obx(()=> Column(
              children: [
                Divider(
                  height: 0.8,
                  thickness: 0.9,
                  indent: 1,
                  color: AppTheme.broder_color,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 8.0, bottom: 0.0, left: 20, right: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {

                          if (isVisible) {
                            setState(() {
                              setHeight = 75.0;
                              isVisible = false;
                              angle = 180;
                            });
                          } else {
                            setState(() {
                              setHeight = 195.0;
                              isVisible = true;
                              angle = 0;
                            });
                          }
                        },
                        child: Row(
                          children: [
                            Text(
                              'Total',
                              maxLines: 1,
                              style: TextStyle(
                                  color: AppTheme.dark_font_color,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700),
                            ),
                            Transform.rotate(
                              angle: angle * math.pi / 180,
                              child: IconButton(
                                icon: Icon(
                                  Icons.arrow_drop_down_outlined,
                                  color: AppTheme.dark_font_color,
                                ),
                                onPressed: null,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        decoration: ShapeDecoration(
                          gradient: LinearGradient(
                            begin: Alignment(0.00, -1.00),
                            end: Alignment(0, 1),
                            colors:widget.is_shared? [Color(0xFF9BC838), Color(0xFF4F9D01)]:[Color(0xff818181), Color(0xff818181)],
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                if(widget.is_shared) {
                                  quantity.clear();
                                  underShoppingController.resetCart(
                                      widget.userID, widget.shoppingFolderId);
                                }
                              },
                              child: Text(
                                'Reset Items',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 7,
                ),
                Visibility(
                  visible: isVisible,
                  child: Container(
                    child: Column(
                      children: [
                        Divider(
                          height: 0.8,
                          thickness: 0.9,
                          indent: 1,
                          color: AppTheme.broder_color,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    8.0, 8.0, 25.0, 8.0),
                                child: Text(
                                  'Basket Total',
                                  textAlign: TextAlign.end,
                                  maxLines: 1,
                                  style: TextStyle(
                                      color: AppTheme.dark_font_color,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                            Container(
                              height: 40,
                              width: 1,
                              color: AppTheme.broder_color,
                            ),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Rs.${underShoppingController.totalAmount.toString()}',
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  style: TextStyle(
                                      color: AppTheme.apptheme_color,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          height: 0.8,
                          thickness: 0.9,
                          indent: 1,
                          color: AppTheme.broder_color,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    8.0, 8.0, 25.0, 8.0),
                                child: Text(
                                  'Total Purchased',
                                  textAlign: TextAlign.end,
                                  maxLines: 1,
                                  style: TextStyle(
                                      color: AppTheme.dark_font_color,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                            Container(
                              height: 40,
                              width: 1,
                              color: AppTheme.broder_color,
                            ),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    'Rs.${underShoppingController.purchasedAmount.toString()}',
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  style: TextStyle(
                                      color: AppTheme.apptheme_color,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          height: 0.8,
                          thickness: 0.9,
                          indent: 1,
                          color: AppTheme.broder_color,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    8.0, 8.0, 25.0, 8.0),
                                child: Text(
                                  'Pending Total',
                                  textAlign: TextAlign.end,
                                  maxLines: 1,
                                  style: TextStyle(
                                      color: AppTheme.dark_font_color,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                            Container(
                              height: 40,
                              width: 1,
                              color: AppTheme.broder_color,
                            ),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Rs.${underShoppingController.pendingAmount.toString()}',
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  style: TextStyle(
                                      color: AppTheme.apptheme_color,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          height: 0.8,
                          thickness: 0.9,
                          indent: 1,
                          color: AppTheme.broder_color,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    underShoppingController.getData(widget.userID, widget.shoppingFolderId,"");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.back_color,
      appBar: AppBarBack(
        title: '',
      ),
      body: SingleChildScrollView(
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
            Column(children: [
              Container(
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.to(ShoppingCartPage());
                        },
                        child: Row(
                          children: <Widget>[
                            Obx(
                              () => Container(
                                child: Text(
                                  '${widget.shoppingFolderTitle} (${underShoppingController.spCart.length.toString()})',
                                  style: TextStyle(
                                      color: AppTheme.dark_font_color,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      Row(
                        children: [
                          widget.is_shared?GestureDetector(
                            onTap: () {
                              shoppingListAddController.getMemberData(widget.userID);
                              _shareMemberList(context);
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
                          widget.is_shared?GestureDetector(
                            onTap: () {
                              if (underShoppingController.spCart.length != 0) {
                                showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return DeleteDialog(
                                          "Are you sure you want to delete all item..",
                                          widget.userID,
                                          widget.shoppingFolderId);
                                    });
                              } else {
                                Get.snackbar("Sorry...!", "No Data Found",
                                    snackPosition: SnackPosition.TOP,
                                    backgroundColor: AppTheme.apptheme_color
                                        .withOpacity(0.10),
                                    colorText: AppTheme.apptheme_color,
                                    borderColor: AppTheme.apptheme_color,
                                    borderWidth: 1,
                                    margin: EdgeInsets.only(
                                        bottom: 20, left: 10.0, right: 10.0));
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Image.asset(
                                'assets/images/frameRemove.png',
                                height: 26.0,
                                width: 52.0,
                              ),
                            ),
                          ):SizedBox(),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      )
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
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: Get.width,
                    height: 40,
                    decoration:
                        CustomDecorations().BackgroundDecorationwithRadiusTen(),
                    child:Container(
                      width: Get.width * 0.90,
                      height: 45,
                      child: TextField(
                        controller: cntsearch,
                        keyboardType: TextInputType.text,
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
                          hintText: 'Search in this list',
                          prefixIcon: Icon(Icons.search),

                        ),
                        onChanged: (value){
                          if(value.length>3){
                            underShoppingController.getData(widget.userID, widget.shoppingFolderId,value);
                          }
                        },

                      ),
                    ),
                  ),
                ),
              ),
             Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Container(
                      width: Get.width,
                      decoration: CustomDecorations()
                          .baseBackgroundDecoration(),
                      child: Obx(() {

                        if (underShoppingController.isLoading.value)
                          return Center(child: CircularProgressIndicator());
                        else {
                          return
                          ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: underShoppingController.spCart.length,
                              itemBuilder: (context, index) {
                                quantity.add(underShoppingController.spCart[index].productQty);
                                itemschecked.add(false);
                                return Column(
                                  children: [
                                    Container(
                                      decoration: ShapeDecoration(
                                        color: underShoppingController.spCart[index].is_Purchased==0?Colors.transparent:Colors.green.withOpacity(0.15),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(0),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Row(
                                          children: [
                                            Row(
                                              children: <Widget>[
                                                Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                    border: Border.all(
                                                      width: 1,
                                                      color:
                                                          AppTheme.broder_color,
                                                      style: BorderStyle.solid,
                                                    ),
                                                  ),
                                                  child: Stack(
                                                    children: [

                                                      Padding(
                                                        padding:
                                                            const EdgeInsets.all(
                                                                2.0),
                                                        child: CachedNetworkImage(
                                                          height: 50,
                                                          width: 50,
                                                          imageUrl:ImageUtility.ImageUrl(
                                                              underShoppingController
                                                                  .spCart[index]
                                                                  .image),
                                                          progressIndicatorBuilder:
                                                              (context, url,
                                                                      downloadProgress) =>
                                                                  Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(10.0),
                                                            child: CircularProgressIndicator(
                                                                value:
                                                                    downloadProgress
                                                                        .progress),
                                                          ),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              Image.asset(
                                                            "assets/images/appicon.png",
                                                            height: 50,
                                                            width: 50,
                                                          ),
                                                        ),
                                                      ),

                                                    ],
                                                  ),
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          8.0, 0.0, 8.0, 2.0),
                                                      //12 char only
                                                      child: Text(
                                                        underShoppingController.spCart[index].productName.length > 10
                                                            ? underShoppingController.spCart[index].productName.substring(0, 10) + '...'
                                                            : underShoppingController.spCart[index].productName,
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                            color: AppTheme
                                                                .dark_font_color,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          8.0, 2.0, 8.0, 2.0),
                                                      child: Text(
                                                        "Rs." +
                                                            underShoppingController
                                                                .spCart[index]
                                                                .price
                                                                .toString()+" X "+ quantity[index].toString(),
                                                        style: TextStyle(
                                                            color: AppTheme
                                                                .dark_font_color,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                      ),
                                                    ),

                                                  ],
                                                ),
                                              ],
                                            ),
                                            Spacer(),
                                            Row(
                                              children: [
                                                itemschecked[index] != false?
                                                Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30.0),
                                                    border: Border.all(
                                                      width: 1,
                                                      color: Colors.green,
                                                      style: BorderStyle.solid,
                                                    ),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      //minus button
                                                      GestureDetector(
                                                        onTap: () {
                                                          if (quantity[index] > 1) {
                                                            quantity[index]--;
                                                          }
                                                          setState(() {});
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5.0),
                                                          child: Icon(
                                                            Icons.remove,
                                                            color: AppTheme
                                                                .dark_font_secondary,
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(7.0),
                                                        child: Text(
                                                          quantity[index].toString(),
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                              color: AppTheme
                                                                  .dark_font_color,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                        ),
                                                      ),
                                                      //plus button
                                                     GestureDetector(
                                                        onTap: () {
                                                          if (quantity[index] >= 0 &&
                                                              quantity[index] < 20) {
                                                            quantity[index]++;
                                                          }
                                                          setState(() {});
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5.0),
                                                          child: Icon(
                                                            Icons.add,
                                                            color: AppTheme
                                                                .dark_font_secondary,
                                                          ),
                                                        ),
                                                      )

                                                    ],
                                                  ),
                                                ):SizedBox(),

                                                itemschecked[index] != true ?GestureDetector(
                                                  onTap:(){
                                                    if(widget.is_shared)
                                                    if(underShoppingController.spCart[index].is_Purchased!=1){
                                                    underShoppingController.updatePurchase("1",widget.userID,widget.shoppingFolderId,quantity[index].toString(),underShoppingController.spCart[index].productId.toString(),underShoppingController.spCart[index].shopId.toString());
                                                    }else{

                                                      underShoppingController.updatePurchase("0",widget.userID,widget.shoppingFolderId,quantity[index].toString(),underShoppingController.spCart[index].productId.toString(),underShoppingController.spCart[index].shopId.toString());
                                                    }
                                                  },
                                                  child: Image.asset(
                                                    underShoppingController.spCart[index].is_Purchased==1 ? 'assets/images/purchased.png':'assets/images/unpurchased.png',
                                                    height: 28,
                                                    width: 28,
                                                  ),
                                                ):SizedBox(),


                                                SizedBox(
                                                  width: 5.0,
                                                ),

                                                widget.is_shared?GestureDetector(
                                                  onTap:(){
                                                    //update cart

                                                    _toggleCategory(index,false);
                                                    underShoppingController.updateCartItem(widget.userID,widget.shoppingFolderId,quantity[index].toString(),underShoppingController.spCart[index].productId.toString(),underShoppingController.spCart[index].shopId.toString());

                                                    setState(() {

                                                    });
                                                  },
                                                  child: itemschecked[index] != false?
                                                  Icon(Iconsax.tick_circle,
                                                      size: 30,
                                                      color: AppTheme
                                                          .dark_font_color
                                                          .withOpacity(0.75)):
                                                      //green button
                                                  GestureDetector(
                                                      onTap:(){
                                                        if(widget.is_shared){
                                                          _toggleCategory(index, true);
                                                          //bottom visibility gone

                                                        }
                                                  }, child: underShoppingController.spCart[index].is_Purchased==0?SvgPicture.asset('assets/svg/closecircle_edit_color.svg',height: 33,width: 33,):SizedBox()),
                                                ):GestureDetector(
                                                  onTap:(){
                                                    //update cart

                                                  },
                                                  child: Icon(Iconsax.tick_circle,
                                                      size: 30,
                                                      color: AppTheme
                                                          .dark_font_color
                                                          .withOpacity(0.75))
                                                ),
                                                SizedBox(
                                                  width: 5.0,
                                                ),

                                                //cross circle
                                                widget.is_shared?GestureDetector(
                                                  onTap:(){
                                                  //delete one item
                                                  //   shoppingRemoveCartItem
                                                    underShoppingController.deleteCart(widget.userID,widget.shoppingFolderId,underShoppingController.spCart[index].productId.toString(),underShoppingController.spCart[index].Id.toString());
                                                  },
                                                  child: Icon(
                                                    Iconsax.close_circle,
                                                    size: 30,
                                                    color: AppTheme
                                                        .dark_font_color
                                                        .withOpacity(0.75),
                                                  ),
                                                ):GestureDetector(
                                                  onTap:(){
                                                   },
                                                  child: Icon(
                                                    Iconsax.close_circle,
                                                    size: 30,
                                                    color: AppTheme
                                                        .dark_font_color
                                                        .withOpacity(0.75),
                                                  ),
                                                ),
                                              ],
                                            ),

                                          ],
                                        ),
                                      ),
                                    ),
                                    if (index !=
                                        underShoppingController.spCart.length -
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
                                );


                              });

                        }
                      }),
                    ),
                  ),
                ],
              ),

              /*
                  Container(
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Row(
                            children: <Widget>[
                              Container(
                                decoration:BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all(
                                    width: 1,
                                    color: AppTheme.broder_color,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                child: Image.asset(
                                  'assets/images/product2.png',
                                  height: 52.0,
                                  width: 52.0,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(8.0,0.0,8.0,2.0),
                                    //12 char only
                                    child: Text('Sanvaliya',
                                      maxLines: 1,
                                      style: TextStyle(
                                          color: AppTheme.dark_font_color,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700),),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(8.0,2.0,8.0,2.0),
                                    child: Text('\$299',
                                      style: TextStyle(
                                          color: AppTheme.dark_font_color,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700),),
                                  ),
                                ],
                              ),



                            ],
                          ),
                          Spacer(),
                          Row(
                            children: [
                              Container(
                                decoration:BoxDecoration(
                                  borderRadius: BorderRadius.circular(30.0),
                                  border: Border.all(
                                    width: 1,
                                    color: Colors.green,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: (){
                                        quantity = quantity-1;
                                        setState(() {

                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(7.0),
                                        child: Icon(Icons.remove,color: AppTheme.dark_font_secondary,),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(7.0),
                                      child: Text(quantity.toString(),
                                        maxLines: 1,
                                        style: TextStyle(
                                            color: AppTheme.dark_font_color,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700),),
                                    ),
                                    GestureDetector(
                                      onTap: (){
                                        quantity = quantity+1;
                                        setState(() {

                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(7.0),
                                        child: Icon(Icons.add,color: AppTheme.dark_font_secondary,),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(width: 5.0,),
                              Icon(Iconsax.tick_circle,size: 30,color: AppTheme.dark_font_color.withOpacity(0.75)),
                              SizedBox(width: 5.0,),
                              Icon(Iconsax.close_circle,size: 30,color: AppTheme.dark_font_color.withOpacity(0.75)),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Divider(height: 0.8,thickness: 0.9,indent: 1,color: AppTheme.broder_color,),

*/
            ]),
          ],
        ),
      ),
      bottomNavigationBar: buildbottomLayout(context),
    );
  }

  void _shareMemberList(BuildContext context) {
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
                                                                SvgPicture.asset('assets/svg/dot_symbol.svg', color: selectedIndex ==
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
                                                                              .first_name +""+shoppingListAddController
                                                                              .mmList[index]
                                                                              .last_name,
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

                                  ShareFolderToMember(widget.userID, widget.shoppingFolderId,selectedMemberId);
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

                                  Get.to(AddMember("add",widget.userID,"","","","","","","",""));

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


  ShareFolderToMember(String custId, String folderId,String memberId) async {
    var map = new Map<String, dynamic>();
    map['folder_id'] = folderId;
    map['customer_id'] = custId;
    map['to_share_customer_id'] = memberId;

    final uri = ApiEndPoints.shareFolder;
    final response = await http.post(Uri.parse(uri), body: map);

    Map<String, dynamic> data = jsonDecode(response.body);
    if (data['status'] =='success') {

      Get.snackbar( data['status'], data['message'],snackPosition: SnackPosition.TOP,backgroundColor: AppTheme.apptheme_color.withOpacity(0.10),colorText: AppTheme.apptheme_color,borderColor:AppTheme.apptheme_color,borderWidth: 1,margin: EdgeInsets.only(bottom: 20,left: 10.0,right: 10.0));

    } else {
       Get.snackbar(data['status'], data['message'],snackPosition: SnackPosition.TOP,backgroundColor: AppTheme.apptheme_color.withOpacity(0.10),colorText: AppTheme.apptheme_color,borderColor:AppTheme.apptheme_color,borderWidth: 1,margin: EdgeInsets.only(bottom: 20,left: 10.0,right: 10.0));

      throw Exception('Failed to load data${response.statusCode}');
    }
  }

}

class DeleteDialog extends StatelessWidget {
  String msg = "";
  String userId = "";
  String folderId = "";

  DeleteDialog(String this.msg, String this.userId, String this.folderId);

  dialogContent(BuildContext context) {
    UnderShoppingController underShoppingController =
        Get.put(UnderShoppingController());

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
                      color: AppTheme.danger_,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 0.50, color: Color(0xFFDFE2E5)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        underShoppingController.deleteSpFolder(
                            userId, folderId);
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Delete',
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
