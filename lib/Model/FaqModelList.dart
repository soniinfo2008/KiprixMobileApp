// To parse this JSON data, do
//
//     final faqModelList = faqModelListFromJson(jsonString);

import 'dart:convert';

FaqModelList faqModelListFromJson(String str) => FaqModelList.fromJson(json.decode(str));

String faqModelListToJson(FaqModelList data) => json.encode(data.toJson());

class FaqModelList {
  String status;
  String message;
  List<FAQList> data;

  FaqModelList({
    required this.status,
    required this.message,
    required this.data,
  });

  factory FaqModelList.fromJson(Map<String, dynamic> json) => FaqModelList(
    status: json["status"],
    message: json["message"],
    data: List<FAQList>.from(json["data"].map((x) => FAQList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class FAQList {
  int faqId;
  String faqTitle;
  String faqDescription;

  FAQList({
    required this.faqId,
    required this.faqTitle,
    required this.faqDescription,
  });

  factory FAQList.fromJson(Map<String, dynamic> json) => FAQList(
    faqId: json["faq_id"],
    faqTitle: json["faq_title"],
    faqDescription: json["faq_description"],
  );

  Map<String, dynamic> toJson() => {
    "faq_id": faqId,
    "faq_title": faqTitle,
    "faq_description": faqDescription,
  };
}
