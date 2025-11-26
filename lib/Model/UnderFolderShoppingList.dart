// To parse this JSON data, do
//
//     final underFolderShoppingList = underFolderShoppingListFromJson(jsonString);

import 'dart:convert';

UnderFolderShoppingList underFolderShoppingListFromJson(String str) => UnderFolderShoppingList.fromJson(json.decode(str));

String underFolderShoppingListToJson(UnderFolderShoppingList data) => json.encode(data.toJson());

class UnderFolderShoppingList {
  String status;
  String message;
  Data data;

  UnderFolderShoppingList({
    required this.status,
    required this.message,
    required this.data,
  });

  factory UnderFolderShoppingList.fromJson(Map<String, dynamic> json) => UnderFolderShoppingList(
    status: json["status"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  List<ShoppingCart> shoppingCart;
  String totalAmount;
  String purchasedAmount;
  String pendingAmount;

  Data({
    required this.shoppingCart,
    required this.totalAmount,
    required this.purchasedAmount,
    required this.pendingAmount,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    shoppingCart: List<ShoppingCart>.from(json["shopping_cart"].map((x) => ShoppingCart.fromJson(x))),
    totalAmount: json["total_amount"],
    purchasedAmount: json["purchased_amount"],
    pendingAmount: json["pending_amount"],
  );

  Map<String, dynamic> toJson() => {
    "shopping_cart": List<dynamic>.from(shoppingCart.map((x) => x.toJson())),
    "total_amount": totalAmount,
    "purchased_amount": purchasedAmount,
    "pending_amount": pendingAmount,
  };
}

class ShoppingCart {
  int Id;
  int productId;
  int productQty;
  int shopId;
  int is_Purchased;
  String productName;
  String image;
  dynamic price;
  dynamic subtotal;

  ShoppingCart({
    required this.Id,
    required this.productId,
    required this.productQty,
    required this.shopId,
    required this.is_Purchased,
    required this.productName,
    required this.image,
    required this.price,
    required this.subtotal,
  });

  factory ShoppingCart.fromJson(Map<String, dynamic> json) => ShoppingCart(
    Id: json["id"],
    productId: json["product_id"],
    productQty: json["product_qty"],
    shopId: json["shop_id"],
    is_Purchased: json["is_purchased"],
    productName: json["product_name"],
    image: json["image"],
    price: json["price"],
    subtotal: json["subtotal"],
  );

  Map<String, dynamic> toJson() => {
    "id": Id,
    "product_id": productId,
    "product_qty": productQty,
    "shop_id": shopId,
    "is_purchased": is_Purchased,
    "product_name": productName,
    "image": image,
    "price": price,
    "subtotal": subtotal,
  };
}
