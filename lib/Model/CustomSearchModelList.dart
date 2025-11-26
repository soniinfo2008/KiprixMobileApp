// To parse this JSON data, do
//
//     final customSearchModelList = customSearchModelListFromJson(jsonString);

import 'dart:convert';

CustomSearchModelList customSearchModelListFromJson(String str) => CustomSearchModelList.fromJson(json.decode(str));

String customSearchModelListToJson(CustomSearchModelList data) => json.encode(data.toJson());

class CustomSearchModelList {
  Results results;

  CustomSearchModelList({
    required this.results,
  });

  factory CustomSearchModelList.fromJson(Map<String, dynamic> json) => CustomSearchModelList(
    results: Results.fromJson(json["results"]),
  );

  Map<String, dynamic> toJson() => {
    "results": results.toJson(),
  };
}

class Results {
  List<SearchBrand> brands;
  List<SearchBrand> categories;
  List<SearchBrand> subcategories;
  List<Product> products;

  Results({
    required this.brands,
    required this.categories,
    required this.subcategories,
    required this.products,
  });

  factory Results.fromJson(Map<String, dynamic> json) => Results(
    brands: List<SearchBrand>.from(json["brands"].map((x) => SearchBrand.fromJson(x))),
    categories: List<SearchBrand>.from(json["categories"].map((x) => SearchBrand.fromJson(x))),
    subcategories: List<SearchBrand>.from(json["subcategories"].map((x) => SearchBrand.fromJson(x))),
    products: List<Product>.from(json["products"].map((x) => Product.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "brands": List<dynamic>.from(brands.map((x) => x.toJson())),
    "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
    "subcategories": List<dynamic>.from(subcategories.map((x) => x.toJson())),
    "products": List<dynamic>.from(products.map((x) => x.toJson())),
  };
}

class SearchBrand {
  int? brandId;
  String? brandName;
  String image;
  String description;
  int status;
  int? categoryId;
  String? categoryName;
  int? subcategoryId;
  String? subcategoryName;

  SearchBrand({
    this.brandId,
    this.brandName,
    required this.image,
    required this.description,
    required this.status,
    this.categoryId,
    this.categoryName,
    this.subcategoryId,
    this.subcategoryName,
  });

  factory SearchBrand.fromJson(Map<String, dynamic> json) => SearchBrand(
    brandId: json["brand_id"],
    brandName: json["brand_name"],
    image: json["image"],
    description: json["description"],
    status: json["status"],
    categoryId: json["category_id"],
    categoryName: json["category_name"],
    subcategoryId: json["subcategory_id"],
    subcategoryName: json["subcategory_name"],
  );

  Map<String, dynamic> toJson() => {
    "brand_id": brandId,
    "brand_name": brandName,
    "image": image,
    "description": description,
    "status": status,
    "category_id": categoryId,
    "category_name": categoryName,
    "subcategory_id": subcategoryId,
    "subcategory_name": subcategoryName,
  };
}

class Product {
  int categoryId;
  String categoryName;
  int subcategoryId;
  String subcategoryName;
  int brandId;
  String brandName;
  int? shopId;
  String shopName;
  String shopImage;
  String addressLine1;
  dynamic addressLine2;
  int stateId;
  String state;
  int cityId;
  String city;
  String? latitude;
  String? longitude;
  int productId;
  String productName;
  String productImage;
  dynamic price;
  dynamic mrpPrice;
  String shortDescription;
  String description;
  int status;
  List<Outlet> outlets;

  Product({
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
    required this.mrpPrice,
    required this.shortDescription,
    required this.description,
    required this.status,
    required this.outlets,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    categoryId: json["category_id"],
    categoryName: json["category_name"],
    subcategoryId: json["subcategory_id"],
    subcategoryName: json["subcategory_name"],
    brandId: json["brand_id"],
    brandName: json["brand_name"],
    shopId: json["shop_id"],
    shopName: json["shop_name"] ?? '',
    shopImage: json["shop_image"],
    addressLine1: json["address_line1"],
    addressLine2: json["address_line2"] ?? '',
    stateId: json["state_id"],
    state: json["state"],
    cityId: json["city_id"] ?? 0,
    city: json["city"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    productId: json["product_id"],
    productName: json["product_name"],
    productImage: json["product_image"],
    price: json["price"],
    mrpPrice: json["mrp_price"],
    shortDescription: json["short_description"],
    description: json["description"],
    status: json["status"],
    outlets: List<Outlet>.from(json["outlets"].map((x) => Outlet.fromJson(x))),
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
    "mrp_price": mrpPrice,
    "short_description": shortDescription,
    "description": description,
    "status": status,
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
