// To parse this JSON data, do
//
//     final categorySubcategoryProductList = categorySubcategoryProductListFromJson(jsonString);

import 'dart:convert';

CategorySubcategoryProductList categorySubcategoryProductListFromJson(String str) => CategorySubcategoryProductList.fromJson(json.decode(str));

String categorySubcategoryProductListToJson(CategorySubcategoryProductList data) => json.encode(data.toJson());

class CategorySubcategoryProductList {
  String status;
  String message;
  int min;
  int maxPrice;
  List<ScProduct> data;

  CategorySubcategoryProductList({
    required this.status,
    required this.message,
    required this.min,
    required this.maxPrice,
    required this.data,
  });

  factory CategorySubcategoryProductList.fromJson(Map<String, dynamic> json) => CategorySubcategoryProductList(
    status: json["status"],
    message: json["message"],
    min: json["min"],
    maxPrice: json["max_price"],
    data: List<ScProduct>.from(json["data"].map((x) => ScProduct.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "min": min,
    "max_price": maxPrice,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class ScProduct {
  int categoryId;
  String categoryName;
  int subcategoryId;
  String subcategoryName;
  int brandId;
  String brandName;
  int shopId;
  String shopName;
  String shopImage;
  String addressLine1;
  String addressLine2;
  int stateId;
  String state;
  int cityId;
  String city;
  String latitude;
  String longitude;
  int productId;
  String productName;
  String productImage;
  dynamic price;
  dynamic rate_end_date;
  dynamic mrpPrice;
  String shortDescription;
  String description;
  int status;
  String distanceKm;
  String distanceMeter;
  List<Outlet> outlets;

  ScProduct({
    required this.categoryId,
    required this.categoryName,
    required this.subcategoryId,
    required this.subcategoryName,
    required this.brandId,
    required this.brandName,
    required this.shopId,
    required this.shopName,
    required this.shopImage,
    required this.addressLine1,
    required this.addressLine2,
    required this.stateId,
    required this.state,
    required this.cityId,
    required this.city,
    required this.latitude,
    required this.longitude,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.price,
    required this.rate_end_date,
    required this.mrpPrice,
    required this.shortDescription,
    required this.description,
    required this.status,
    required this.distanceKm,
    required this.distanceMeter,
    required this.outlets,
  });

  factory ScProduct.fromJson(Map<String, dynamic> json) => ScProduct(
    categoryId: json["category_id"] ?? 0,
    categoryName: json["category_name"] ?? '',
    subcategoryId: json["subcategory_id"] ?? 0,
    subcategoryName: json["subcategory_name"] ?? '',
    brandId: json["brand_id"] ?? 0,
    brandName: json["brand_name"] ?? '',
    shopId: json["shop_id"] ?? 0,
    shopName: json["shop_name"] ?? '',
    shopImage: json["shops_image"] ?? '',
    addressLine1: json["address_line1"] ?? '',
    addressLine2: json["address_line2"] ?? '',
    stateId: json["state_id"] ?? 0,
    state: json["state"] ?? '',
    cityId: json["city_id"] ?? 0,
    city: json["city"] ?? '',
    latitude: json["latitude"] ?? '',
    longitude: json["longitude"] ?? '',
    productId: json["product_id"] ?? 0,
    productName: json["product_name"] ?? '',
    productImage: json["product_image"] ?? '',
    price: json["price"] ?? 0.0, // Default to 0.0 for double
    mrpPrice: json["mrp_price"] ?? 0.0,
    rate_end_date: json['rate_end_date']?? '',
    shortDescription: json["short_description"] ?? '',
    description: json["description"] ?? '',
    status: json["status"] ?? 0,
    distanceKm: json["distance_km"] ?? 0.0,
    distanceMeter: json["distance_meter"] ?? 0.0,
    outlets: json["outlets"] != null
        ? List<Outlet>.from(json["outlets"].map((x) => Outlet.fromJson(x)))
        : [], // Default to an empty list for `outlets`
  );


  Map<String, dynamic> toJson() => {
    "category_id": categoryId,
    "category_name": categoryName,
    "subcategory_id": subcategoryId,
    "subcategory_name": subcategoryName,
    "brand_id": brandId,
    "brand_name": brandName,
    "shop_id": shopId,
    "shop_name": shopName,
    "shop_image": shopImage,
    "address_line1": addressLine1,
    "address_line2": addressLine2,
    "state_id": stateId,
    "state": state,
    "city_id": cityId,
    "city": city,
    "latitude": latitude,
    "longitude": longitude,
    "product_id": productId,
    "product_name": productName,
    "product_image": productImage,
    "price": price,
    "rate_end_date":rate_end_date ?? "",
    "mrp_price": mrpPrice,
    "short_description": shortDescription,
    "description": description,
    "status": status,
    "distance_km": distanceKm,
    "distance_meter": distanceMeter,
    "outlets": List<dynamic>.from(outlets.map((x) => x.toJson())),
  };
}

class Outlet {
  String outletName;
  String ownerName;
  String image;
  String addressLine1;
  String addressLine2;
  String postalCode;

  Outlet({
    required this.outletName,
    required this.ownerName,
    required this.image,
    required this.addressLine1,
    required this.addressLine2,
    required this.postalCode,

  });

  factory Outlet.fromJson(Map<String, dynamic> json) => Outlet(
    outletName: json["outlet_name"],
    ownerName: json["owner_name"],
    image: json["image"],
    addressLine1: json["address_line1"],
    addressLine2: json["address_line2"] ?? '',
    postalCode: json["postal_code"],
  );

  Map<String, dynamic> toJson() => {
    "outlet_name": outletName,
    "owner_name": ownerName,
    "image": image,
    "address_line1": addressLine1,
    "address_line2": addressLine2,
    "postal_code": postalCode,

  };
}
