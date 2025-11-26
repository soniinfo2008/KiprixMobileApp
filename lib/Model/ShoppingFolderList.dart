// To parse this JSON data, do
//
//     final shoppingFolderList = shoppingFolderListFromJson(jsonString);

import 'dart:convert';

ShoppingFolderList shoppingFolderListFromJson(String str) => ShoppingFolderList.fromJson(json.decode(str));

String shoppingFolderListToJson(ShoppingFolderList data) => json.encode(data.toJson());

class ShoppingFolderList {
  String status;
  String message;
  List<SFolder> data;

  ShoppingFolderList({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ShoppingFolderList.fromJson(Map<String, dynamic> json) => ShoppingFolderList(
    status: json["status"],
    message: json["message"],
    data: List<SFolder>.from(json["data"].map((x) => SFolder.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class SFolder {
  int shoppingFolderId;
  String shoppingFolderTitle;
  bool is_shared;

  SFolder({
    required this.shoppingFolderId,
    required this.shoppingFolderTitle,
    required this.is_shared,
  });

  factory SFolder.fromJson(Map<String, dynamic> json) => SFolder(
    shoppingFolderId: json["shopping_folder_id"],
    shoppingFolderTitle: json["shopping_folder_title"],
    is_shared: json["is_shared"],
  );

  Map<String, dynamic> toJson() => {
    "shopping_folder_id": shoppingFolderId,
    "shopping_folder_title": shoppingFolderTitle,
    "is_shared": is_shared,
  };
}
