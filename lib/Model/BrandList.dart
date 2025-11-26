// To parse this JSON data, do
//
//     final brandList = brandListFromJson(jsonString);

import 'dart:convert';

BrandList brandListFromJson(String str) => BrandList.fromJson(json.decode(str));

String brandListToJson(BrandList data) => json.encode(data.toJson());

class BrandList {
  String status;
  String message;
  List<Brand> data;

  BrandList({
    required this.status,
    required this.message,
    required this.data,
  });

  factory BrandList.fromJson(Map<String, dynamic> json) => BrandList(
    status: json["status"],
    message: json["message"],
    data: List<Brand>.from(json["data"].map((x) => Brand.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Brand {
  int shopId;
  String shopName;
  String ownerName;
  String image;
  String email;
  String phoneNumber;
  String addressLine1;
  dynamic addressLine2;
  int cityId;
  int stateId;
  String postalCode;
  String latitude;
  String longitude;
  int countryId;
  DateTime registrationDate;
  int status;
  int isDeleted;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;
  String publicId;
  int version;

  Brand({
    required this.shopId,
    required this.shopName,
    required this.ownerName,
    required this.image,
    required this.email,
    required this.phoneNumber,
    required this.addressLine1,
    required this.addressLine2,
    required this.cityId,
    required this.stateId,
    required this.postalCode,
    required this.latitude,
    required this.longitude,
    required this.countryId,
    required this.registrationDate,
    required this.status,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.publicId,
    required this.version,
  });

  factory Brand.fromJson(Map<String, dynamic> json) => Brand(
    shopId: json["shop_id"] ?? 0,
    shopName: json["shop_name"] ?? '',
    ownerName: json["owner_name"] ?? '',
    image: json["image"] ?? '',
    email: json["email"] ?? '',
    phoneNumber: json["phone_number"] ?? '',
    addressLine1: json["address_line1"] ?? '',
    addressLine2: json["address_line2"] ?? '',
    cityId: json["city_id"] ?? 0,
    stateId: json["state_id"] ?? 0,
    postalCode: json["postal_code"] ?? '',
    latitude: json["latitude"] ?? '',
    longitude: json["longitude"] ?? '',
    countryId: json["country_id"] ?? 0,
    registrationDate: json["registration_date"] != null
        ? DateTime.parse(json["registration_date"])
        : DateTime.now(),
    status: json["status"] ?? 0,
    isDeleted: json["is_deleted"] ?? 0,
    createdAt: json["created_at"] != null
        ? DateTime.parse(json["created_at"])
        : DateTime.now(),
    updatedAt: json["updated_at"] != null
        ? DateTime.parse(json["updated_at"])
        : DateTime.now(),
    deletedAt: json["deleted_at"]?? '',
    publicId: json["public_id"] ?? '',
    version: json["version"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "shop_id": shopId,
    "shop_name": shopName,
    "owner_name": ownerName,
    "image": image,
    "email": email,
    "phone_number": phoneNumber,
    "address_line1": addressLine1,
    "address_line2": addressLine2,
    "city_id": cityId,
    "state_id": stateId,
    "postal_code": postalCode,
    "latitude": latitude,
    "longitude": longitude,
    "country_id": countryId,
    "registration_date": registrationDate.toIso8601String(),
    "status": status,
    "is_deleted": isDeleted,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "deleted_at": deletedAt,
    "public_id": publicId,
    "version": version,
  };
}
