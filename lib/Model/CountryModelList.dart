// To parse this JSON data, do
//
//     final countryModelList = countryModelListFromJson(jsonString);

import 'dart:convert';

CountryModelList countryModelListFromJson(String str) => CountryModelList.fromJson(json.decode(str));

String countryModelListToJson(CountryModelList data) => json.encode(data.toJson());

class CountryModelList {
  String status;
  String message;
  List<Country> data;

  CountryModelList({
    required this.status,
    required this.message,
    required this.data,
  });

  factory CountryModelList.fromJson(Map<String, dynamic> json) => CountryModelList(
    status: json["status"],
    message: json["message"],
    data: List<Country>.from(json["data"].map((x) => Country.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Country {
  int id;
  String name;
  String iso3;
  String numericCode;
  String iso2;
  String phonecode;
  String capital;
  String currency;
  String currencyName;
  String currencySymbol;
  String tld;
  String native;
  String region;
  String subregion;
  String timezones;
  String translations;
  String latitude;
  String longitude;
  String emoji;
  String emojiU;
  int flag;
  String wikiDataId;
  int status;
  DateTime createdAt;
  DateTime updatedAt;

  Country({
    required this.id,
    required this.name,
    required this.iso3,
    required this.numericCode,
    required this.iso2,
    required this.phonecode,
    required this.capital,
    required this.currency,
    required this.currencyName,
    required this.currencySymbol,
    required this.tld,
    required this.native,
    required this.region,
    required this.subregion,
    required this.timezones,
    required this.translations,
    required this.latitude,
    required this.longitude,
    required this.emoji,
    required this.emojiU,
    required this.flag,
    required this.wikiDataId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Country.fromJson(Map<String, dynamic> json) => Country(
    id: json["id"],
    name: json["name"],
    iso3: json["iso3"],
    numericCode: json["numeric_code"],
    iso2: json["iso2"],
    phonecode: json["phonecode"],
    capital: json["capital"],
    currency: json["currency"],
    currencyName: json["currency_name"],
    currencySymbol: json["currency_symbol"],
    tld: json["tld"],
    native: json["native"],
    region: json["region"],
    subregion: json["subregion"],
    timezones: json["timezones"],
    translations: json["translations"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    emoji: json["emoji"],
    emojiU: json["emojiU"],
    flag: json["flag"],
    wikiDataId: json["wikiDataId"],
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "iso3": iso3,
    "numeric_code": numericCode,
    "iso2": iso2,
    "phonecode": phonecode,
    "capital": capital,
    "currency": currency,
    "currency_name": currencyName,
    "currency_symbol": currencySymbol,
    "tld": tld,
    "native": native,
    "region": region,
    "subregion": subregion,
    "timezones": timezones,
    "translations": translations,
    "latitude": latitude,
    "longitude": longitude,
    "emoji": emoji,
    "emojiU": emojiU,
    "flag": flag,
    "wikiDataId": wikiDataId,
    "status": status,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
