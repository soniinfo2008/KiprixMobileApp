// To parse this JSON data, do
//
//     final categoryList = categoryListFromJson(jsonString);

import 'dart:convert';

CategoryList categoryListFromJson(String str) => CategoryList.fromJson(json.decode(str));

String categoryListToJson(CategoryList data) => json.encode(data.toJson());

class CategoryList {
  String status;
  String message;
  List<Category> data;

  CategoryList({
    required this.status,
    required this.message,
    required this.data,
  });

  factory CategoryList.fromJson(Map<String, dynamic> json) => CategoryList(
    status: json["status"],
    message: json["message"],
    data: List<Category>.from(json["data"].map((x) => Category.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Category {
  int categoryId;
  String categoryName;
  String categoryImage;
  int categoryStatus;
  List<Subcategory> subcategory;

  Category({
    required this.categoryId,
    required this.categoryName,
    required this.categoryImage,
    required this.categoryStatus,
    required this.subcategory,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    categoryId: json["category_id"],
    categoryName: json["category_name"]?? '',
    categoryImage: json["image"]?? '',
    categoryStatus: json["status"]?? '',
    subcategory: List<Subcategory>.from(json["subcategories"].map((x) => Subcategory.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "category_id": categoryId,
    "category_name": categoryName,
    "image": categoryImage,
    "status": categoryStatus,
    "subcategories": List<dynamic>.from(subcategory.map((x) => x.toJson())),
  };
}

class Subcategory {
  int subcategoryId;
  String subCategoryName;
  String subCategoryImage;

  Subcategory({
    required this.subcategoryId,
    required this.subCategoryName,
    required this.subCategoryImage,
  });

  factory Subcategory.fromJson(Map<String, dynamic> json) => Subcategory(
    subcategoryId: json["subcategory_id"],
    subCategoryName: json["subcategory_name"] ?? '',
    subCategoryImage: json["image"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "subcategory_id ": subcategoryId,
    "subcategory_name ": subCategoryName,
    "image": subCategoryImage,
  };
}
