// To parse this JSON data, do
//
//     final homeListModel = homeListModelFromJson(jsonString);

import 'dart:convert';

HomeListModel homeListModelFromJson(String str) => HomeListModel.fromJson(json.decode(str));

String homeListModelToJson(HomeListModel data) => json.encode(data.toJson());

class HomeListModel {
  String status;
  String message;
  HData data;

  HomeListModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory HomeListModel.fromJson(Map<String, dynamic> json) => HomeListModel(
    status: json["status"],
    message: json["message"],
    data: HData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.toJson(),
  };
}

class HData {
  List<HomeSlider> sliders;
  List<SponsoredAd> sponsoredAds;
  List<TrendingProduct> trendingProducts;

  HData({
    required this.sliders,
    required this.sponsoredAds,
    required this.trendingProducts,
  });

  factory HData.fromJson(Map<String, dynamic> json) => HData(
    sliders: List<HomeSlider>.from(json["sliders"].map((x) => HomeSlider.fromJson(x))),
    sponsoredAds: List<SponsoredAd>.from(json["sponsored_ads"].map((x) => SponsoredAd.fromJson(x))),
    trendingProducts: List<TrendingProduct>.from(json["trending_products"].map((x) => TrendingProduct.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "sliders": List<dynamic>.from(sliders.map((x) => x.toJson())),
    "sponsored_ads": List<dynamic>.from(sponsoredAds.map((x) => x.toJson())),
    "trending_products": List<dynamic>.from(trendingProducts.map((x) => x.toJson())),
  };
}


class SponsoredAd {
  int adId;
  int cityId;
  String adAdvertiserName;
  String adTitle;
  String adDescription;
  String adImageUrl;
  String adClickUrl;
  DateTime adStartDate;
  DateTime adEndDate;
  String adBudget;
  int status;

  SponsoredAd({
    required this.adId,
    required this.cityId,
    required this.adAdvertiserName,
    required this.adTitle,
    required this.adDescription,
    required this.adImageUrl,
    required this.adClickUrl,
    required this.adStartDate,
    required this.adEndDate,
    required this.adBudget,
    required this.status,
  });

  factory SponsoredAd.fromJson(Map<String, dynamic> json) => SponsoredAd(
    adId: json["ad_id"],
    cityId: json["city_id"] ?? 0,
    adAdvertiserName: json["ad_advertiser_name"],
    adTitle: json["ad_title"],
    adDescription: json["ad_description"],
    adImageUrl: json["ad_image_url"]??"",
    adClickUrl: json["ad_click_url"],
    adStartDate: DateTime.parse(json["ad_start_date"]),
    adEndDate: DateTime.parse(json["ad_end_date"]),
    adBudget: json["ad_budget"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "ad_id": adId,
    "city_id": cityId,
    "ad_advertiser_name": adAdvertiserName,
    "ad_title": adTitle,
    "ad_description": adDescription,
    "ad_image_url": adImageUrl,
    "ad_click_url": adClickUrl,
    "ad_start_date": adStartDate.toIso8601String(),
    "ad_end_date": adEndDate.toIso8601String(),
    "ad_budget": adBudget,
    "status": status,
  };
}

class HomeSlider {
  int sliderId;
  String sliderImage;

  HomeSlider({
    required this.sliderId,
    required this.sliderImage,
  });

  factory HomeSlider.fromJson(Map<String, dynamic> json) => HomeSlider(
    sliderId: json["slider_id"],
    sliderImage: json["slider_image"]??"",
  );

  Map<String, dynamic> toJson() => {
    "slider_id": sliderId,
    "slider_image": sliderImage,
  };
}

class TrendingProduct {
  dynamic count;
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
  String shortDescription;
  String description;
  int productsStatus;
  List<Outlet> outlets;

  TrendingProduct({
    required this.count,
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
    required this.shortDescription,
    required this.description,
    required this.productsStatus,
    required this.outlets,
  });

  factory TrendingProduct.fromJson(Map<String, dynamic> json) => TrendingProduct(
    count: json["count"] ?? 0, // Default to 0 for integers
    categoryId: json["category_id"] ?? 0, // Default to 0 for integers
    categoryName: json["category_name"] ?? '', // Default to an empty string
    subcategoryId: json["subcategory_id"] ?? 0,
    subcategoryName: json["subcategory_name"] ?? '',
    brandId: json["brand_id"] ?? 0,
    brandName: json["brand_name"] ?? '',
    shopId: json["shop_id"] ?? 0,
    shopName: json["shop_name"] ?? '',
    shopImage: json["shop_image"] ?? '',
    addressLine1: json["address_line1"] ?? '',
    addressLine2: json["address_line2"] ?? '',
    stateId: json["state_id"] ?? 0,
    state: json["state"] ?? '',
    cityId: json["city_id"] ?? 0,
    city: json["city"] ?? '',
    latitude: json["latitude"] ?? '', // Default to an empty string for coordinates
    longitude: json["longitude"] ?? '',
    productId: json["product_id"] ?? 0,
    productName: json["product_name"] ?? '',
    productImage: json["product_image"] ?? '',
    price: json["price"] ?? 0.0, // Default to 0.0 for double
    shortDescription: json["short_description"] ?? '',
    description: json["description"] ?? '',
    productsStatus: json["products_status"] ?? 0,
    outlets: json["outlets"] != null
        ? List<Outlet>.from(json["outlets"].map((x) => Outlet.fromJson(x)))
        : [], // Default to an empty list for outlets
  );


  Map<String, dynamic> toJson() => {
    "count": count,
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
    "short_description": shortDescription,
    "description": description,
    "products_status": productsStatus,
    "outlets": List<dynamic>.from(outlets.map((x) => x.toJson())),
  };
}
class Outlet {
  int outletId;
  String outletName;
  String outletAddressLine1;
  String outletAddressLine2;
  int outletStateId;
  int outletCityId;
  String outletLatitude;
  String outletLongitude;

  Outlet({
    required this.outletId,
    required this.outletName,
    required this.outletAddressLine1,
    required this.outletAddressLine2,
    required this.outletStateId,
    required this.outletCityId,
    required this.outletLatitude,
    required this.outletLongitude,
  });

  factory Outlet.fromJson(Map<String, dynamic> json) => Outlet(
    outletId: json["outlet_id"],
    outletName: json["outlet_name"]!,
    outletAddressLine1: json["outlet_address_line1"]!,
    outletAddressLine2: json["outlet_address_line2"] ?? '',
    outletStateId: json["outlet_state_id"],
    outletCityId: json["outlet_city_id"],
    outletLatitude: json["outlet_latitude"],
    outletLongitude: json["outlet_longitude"],
  );

  Map<String, dynamic> toJson() => {
    "outlet_id": outletId,
    "outlet_name": outletName,
    "outlet_address_line1": outletAddressLine1,
    "outlet_address_line2": outletAddressLine2,
    "outlet_state_id": outletStateId,
    "outlet_city_id": outletCityId,
    "outlet_latitude": outletLatitude,
    "outlet_longitude": outletLongitude,
  };
}
