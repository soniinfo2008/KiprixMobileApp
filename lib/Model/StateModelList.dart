// To parse this JSON data, do
//
//     final stateModelList = stateModelListFromJson(jsonString);

import 'dart:convert';

StateModelList stateModelListFromJson(String str) => StateModelList.fromJson(json.decode(str));

String stateModelListToJson(StateModelList data) => json.encode(data.toJson());

class StateModelList {
  String status;
  String message;
  List<States> data;

  StateModelList({
    required this.status,
    required this.message,
    required this.data,
  });

  factory StateModelList.fromJson(Map<String, dynamic> json) => StateModelList(
    status: json["status"],
    message: json["message"],
    data: List<States>.from(json["data"].map((x) => States.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class States {
  int id;
  String name;
  int countryId;
  CountryCode countryCode;
  String fipsCode;
  String iso2;
  dynamic type;
  String latitude;
  String longitude;
  DateTime createdAt;
  DateTime updatedAt;
  int flag;
  String wikiDataId;

  States({
    required this.id,
    required this.name,
    required this.countryId,
    required this.countryCode,
    required this.fipsCode,
    required this.iso2,
    required this.type,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    required this.updatedAt,
    required this.flag,
    required this.wikiDataId,
  });

  factory States.fromJson(Map<String, dynamic> json) => States(
    id: json["id"],
    name: json["name"],
    countryId: json["country_id"],
    countryCode: countryCodeValues.map[json["country_code"]]!,
    fipsCode: json["fips_code"],
    iso2: json["iso2"],
    type: json["type"],
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
    "country_id": countryId,
    "country_code": countryCodeValues.reverse[countryCode],
    "fips_code": fipsCode,
    "iso2": iso2,
    "type": type,
    "latitude": latitude,
    "longitude": longitude,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "flag": flag,
    "wikiDataId": wikiDataId,
  };
}

enum CountryCode {
  MU
}

final countryCodeValues = EnumValues({
  "MU": CountryCode.MU
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
