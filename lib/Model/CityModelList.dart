// To parse this JSON data, do
//
//     final cityModelList = cityModelListFromJson(jsonString);

import 'dart:convert';

CityModelList cityModelListFromJson(String str) => CityModelList.fromJson(json.decode(str));

String cityModelListToJson(CityModelList data) => json.encode(data.toJson());

class CityModelList {
  String status;
  String message;
  List<Cityies> data;

  CityModelList({
    required this.status,
    required this.message,
    required this.data,
  });

  factory CityModelList.fromJson(Map<String, dynamic> json) => CityModelList(
    status: json["status"],
    message: json["message"],
    data: List<Cityies>.from(json["data"].map((x) => Cityies.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Cityies {
  int id;
  String name;
  int stateId;
  String stateCode;
  int countryId;
  String countryCode;
  String latitude;
  String longitude;
  DateTime createdAt;
  DateTime updatedAt;
  int flag;
  String wikiDataId;

  Cityies({
    required this.id,
    required this.name,
    required this.stateId,
    required this.stateCode,
    required this.countryId,
    required this.countryCode,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    required this.updatedAt,
    required this.flag,
    required this.wikiDataId,
  });

  factory Cityies.fromJson(Map<String, dynamic> json) => Cityies(
    id: json["id"],
    name: json["name"],
    stateId: json["state_id"],
    stateCode: json["state_code"],
    countryId: json["country_id"],
    countryCode: json["country_code"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    flag: json["flag"],
    wikiDataId: json["wikiDataId"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "state_id": stateId,
    "state_code": stateCode,
    "country_id": countryId,
    "country_code": countryCode,
    "latitude": latitude,
    "longitude": longitude,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "flag": flag,
    "wikiDataId": wikiDataId,
  };
}
