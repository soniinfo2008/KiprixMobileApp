// To parse this JSON data, do
//
//     final searchAdd = searchAddFromJson(jsonString);

import 'dart:convert';

SearchAdd searchAddFromJson(String str) => SearchAdd.fromJson(json.decode(str));

String searchAddToJson(SearchAdd data) => json.encode(data.toJson());

class SearchAdd {
  String status;
  String message;
  List<Addata> data;

  SearchAdd({
    required this.status,
    required this.message,
    required this.data,
  });

  factory SearchAdd.fromJson(Map<String, dynamic> json) => SearchAdd(
    status: json["status"],
    message: json["message"],
    data: List<Addata>.from(json["data"].map((x) => Addata.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Addata {
  int adId;
  int cityId;
  int positionId;
  String adAdvertiserName;
  String adTitle;
  String adDescription;
  String adImageUrl;
  String? image;
  String adClickUrl;
  DateTime adStartDate;
  DateTime adEndDate;
  String adBudget;
  int status;

  Addata({
    required this.adId,
    required this.cityId,
    required this.positionId,
    required this.adAdvertiserName,
    required this.adTitle,
    required this.adDescription,
    required this.adImageUrl,
    required this.image,
    required this.adClickUrl,
    required this.adStartDate,
    required this.adEndDate,
    required this.adBudget,
    required this.status,
  });

  factory Addata.fromJson(Map<String, dynamic> json) => Addata(
    adId: json["ad_id"],
    cityId: json["city_id"],
    positionId: json["position_id"],
    adAdvertiserName: json["ad_advertiser_name"],
    adTitle: json["ad_title"],
    adDescription: json["ad_description"],
    adImageUrl: json["ad_image_url"],
    image: json["image"],
    adClickUrl: json["ad_click_url"],
    adStartDate: DateTime.parse(json["ad_start_date"]),
    adEndDate: DateTime.parse(json["ad_end_date"]),
    adBudget: json["ad_budget"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "ad_id": adId,
    "city_id": cityId,
    "position_id": positionId,
    "ad_advertiser_name": adAdvertiserName,
    "ad_title": adTitle,
    "ad_description": adDescription,
    "ad_image_url": adImageUrl,
    "image": image,
    "ad_click_url": adClickUrl,
    "ad_start_date": adStartDate.toIso8601String(),
    "ad_end_date": adEndDate.toIso8601String(),
    "ad_budget": adBudget,
    "status": status,
  };
}
