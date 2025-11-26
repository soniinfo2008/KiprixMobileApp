import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kirpix/Model/BrandList.dart';
import 'package:http/http.dart' as http;
import '../Model/UnderFolderShoppingList.dart';
import '../Utils/Constant/ApiConfig/ApiEndPoints.dart';
import '../Utils/Constant/AppTheme.dart';

class UnderShoppingController extends GetxController {
  var isLoading = true.obs;
  var spCart = <ShoppingCart>[].obs;
  var noDataFlag = false.obs;
  var totalAmount = "".obs;
  var purchasedAmount = "".obs;
  var pendingAmount = "".obs;

  @override
  void onInit() {
    super.onInit();
  }

  void getData(String custId, String folderId,String search) async {
    try {
      isLoading(true);
      var carts = await getsplist(custId, folderId,search);
      if (carts != null) {
        spCart.value = carts.data.shoppingCart;
        totalAmount.value=carts.data.totalAmount.toString();
        purchasedAmount.value=carts.data.purchasedAmount.toString();
        pendingAmount.value=carts.data.pendingAmount.toString();
      }
    } finally {
      isLoading(false);
    }
  }

  getsplist(String custId, String folderId,String search) async {
    print("iddd>" + custId);

    var map = new Map<String, dynamic>();
    map['customer_id'] = custId;
    map['folder_id'] = folderId;
    map['search_text'] = search;

    final uri = ApiEndPoints.shoppingCartList;
    final response = await http.post(Uri.parse(uri), body: map);

    if (response.statusCode == 200) {
      noDataFlag(false);
      return UnderFolderShoppingList.fromJson(jsonDecode(response.body));
    } else {
      noDataFlag(true);
      Get.snackbar("Sorry...!", "No data found...!",snackPosition: SnackPosition.TOP,backgroundColor: AppTheme.apptheme_color.withOpacity(0.10),colorText: AppTheme.apptheme_color,borderColor:AppTheme.apptheme_color,borderWidth: 1,margin: EdgeInsets.only(bottom: 20,left: 10.0,right: 10.0));

      throw Exception('Failed to load data${response.statusCode}');
    }
  }

  deleteSpFolder(String custId, String folderId) async {

    var map = new Map<String, dynamic>();
    map['customer_id'] = custId;
    map['folder_id'] = folderId;

    final uri = ApiEndPoints.removeAllShoppingCart;
    final response = await http.post(Uri.parse(uri), body: map);

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      getData(custId,folderId,"");

      // Get.snackbar( data['status'], data['message'],
      //     snackPosition: SnackPosition.TOP,
      //     backgroundColor: AppTheme.apptheme_color.withOpacity(0.80),colorText: AppTheme.back_color,borderColor:AppTheme.apptheme_color,borderWidth: 1);
    } else {
      // Get.snackbar("Exception...!", "Server Code:",snackPosition: SnackPosition.TOP,backgroundColor: AppTheme.danger_.withOpacity(0.10),colorText: AppTheme.apptheme_color,borderColor:AppTheme.apptheme_color,borderWidth: 1,margin: EdgeInsets.only(bottom: 20,left: 10.0,right: 10.0));

      throw Exception('Failed to load data${response.statusCode}');
    }
  }

  //delete cart
  deleteCart(String custId, String folderId,String proId,String cartId) async {

    var map = new Map<String, dynamic>();
    map['customer_id'] = custId;
    map['folder_id'] = folderId;
    map['product_id'] = proId;
    map['cart_id'] = cartId;

    final uri = ApiEndPoints.shoppingRemoveCartItem;
    final response = await http.post(Uri.parse(uri), body: map);

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      getData(custId,folderId,"");

      // Get.snackbar( data['status'], data['message'],
      //     snackPosition: SnackPosition.TOP,
      //     backgroundColor: AppTheme.apptheme_color.withOpacity(0.80),colorText: AppTheme.back_color,borderColor:AppTheme.apptheme_color,borderWidth: 1);
    } else {
      // Get.snackbar("Exception...!", "Server Code:",snackPosition: SnackPosition.TOP,backgroundColor: AppTheme.danger_.withOpacity(0.10),colorText: AppTheme.apptheme_color,borderColor:AppTheme.apptheme_color,borderWidth: 1,margin: EdgeInsets.only(bottom: 20,left: 10.0,right: 10.0));

      throw Exception('Failed to load data${response.statusCode}');
    }
  }


  resetCart(String custId, String folderId) async {

    var map = new Map<String, dynamic>();
    map['customer_id'] = custId;
    map['folder_id'] = folderId;

    final uri = ApiEndPoints.restItemShoppingCart;
    final response = await http.post(Uri.parse(uri), body: map);

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      getData(custId,folderId,"");
      // Get.snackbar( data['status'], data['message'],
      //     snackPosition: SnackPosition.TOP,
      //     backgroundColor: AppTheme.apptheme_color.withOpacity(0.80),colorText: AppTheme.back_color,borderColor:AppTheme.apptheme_color,borderWidth: 1);

    } else {
      Get.snackbar("Sorry...!", "No data found...!",snackPosition: SnackPosition.TOP,backgroundColor: AppTheme.danger_.withOpacity(0.10),colorText: AppTheme.apptheme_color,borderColor:AppTheme.apptheme_color,borderWidth: 1,margin: EdgeInsets.only(bottom: 20,left: 10.0,right: 10.0));

      throw Exception('Failed to load data${response.statusCode}');
    }
  }

  updateCartItem(String custId, String folderId,String qnty,String proId,String shopID) async {


    var map = new Map<String, dynamic>();
    map['product_id'] = proId;
    map['product_qty'] = qnty;
    map['customer_id'] = custId;
    map['folder_id'] = folderId;
    map['shop_id'] = shopID;

    final uri = ApiEndPoints.updateQtyShoppingCart;
    final response = await http.post(Uri.parse(uri), body: map);

    Map<String, dynamic> data = jsonDecode(response.body);
    if (data['status'] =='success') {
      getData(custId,folderId,"");

      // Get.snackbar( data['status'], data['message'],
      //     snackPosition: SnackPosition.TOP,
      //     backgroundColor: AppTheme.apptheme_color.withOpacity(0.80),colorText: AppTheme.back_color,borderColor:AppTheme.apptheme_color,borderWidth: 1);

    } else {
      // Get.snackbar("Exception...!", "Server Code:",snackPosition: SnackPosition.TOP,backgroundColor: AppTheme.apptheme_color.withOpacity(0.10),colorText: AppTheme.apptheme_color,borderColor:AppTheme.apptheme_color,borderWidth: 1,margin: EdgeInsets.only(bottom: 20,left: 10.0,right: 10.0));

      throw Exception('Failed to load data${response.statusCode}');
    }
  }

  updatePurchase(String is_pur,String custId, String folderId,String qnty,String proId,String shopID) async {
    var map = new Map<String, dynamic>();
    map['product_id'] = proId;
    map['is_purchased'] = is_pur;
    map['customer_id'] = custId;
    map['folder_id'] = folderId;
    map['shop_id'] = shopID;

    final uri = ApiEndPoints.updatePurchaseShoppingCart;
    final response = await http.post(Uri.parse(uri), body: map);

    Map<String, dynamic> data = jsonDecode(response.body);
    if (data['status'] =='success') {
      getData(custId,folderId,"");
      // Get.snackbar( data['status'], data['message'],
      //     snackPosition: SnackPosition.TOP,
      //     backgroundColor: AppTheme.apptheme_color.withOpacity(0.80),colorText: AppTheme.back_color,borderColor:AppTheme.apptheme_color,borderWidth: 1);


    } else {
      // Get.snackbar( data['status'], data['message'],
      //     snackPosition: SnackPosition.TOP,
      //     backgroundColor:Colors.red.withOpacity(0.80),colorText: AppTheme.back_color,borderColor:AppTheme.apptheme_color,borderWidth: 1);
       // Get.snackbar(data['status'], data['message'],snackPosition: SnackPosition.TOP,backgroundColor: Colors.red.withOpacity(0.80),colorText: Colors.white,borderColor:Colors.red,borderWidth: 1,margin: EdgeInsets.only(bottom: 20,left: 10.0,right: 10.0));

      throw Exception('Failed to load data${response.statusCode}');
    }
  }
}

