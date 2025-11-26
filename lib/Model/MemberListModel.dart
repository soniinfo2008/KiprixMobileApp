// To parse this JSON data, do
//
//     final MemberListModel = MemberListModelFromJson(jsonString);

import 'dart:convert';

MemberListModel MemberListModelFromJson(String str) => MemberListModel.fromJson(json.decode(str));

String MemberListModelToJson(MemberListModel data) => json.encode(data.toJson());

class MemberListModel {
  String status;
  String message;
  List<Member> data;

  MemberListModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory MemberListModel.fromJson(Map<String, dynamic> json) => MemberListModel(
    status: json["status"],
    message: json["message"],
    data: List<Member>.from(json["data"].map((x) => Member.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Member {
  int memberId;
  String first_name;
  String last_name;
  String preferedName;
  String email;
  String phoneNumber;
  int memberParentId;
  String addressLine1;
  String addressLine2;
  String name;
  int city;
  String postalCode;
  DateTime dateOfBirth;

  Member({
    required this.memberId,
    required this.first_name,
    required this.last_name,
    required this.preferedName,
    required this.email,
    required this.phoneNumber,
    required this.memberParentId,
    required this.addressLine1,
    required this.addressLine2,
    required this.name,
    required this.city,
    required this.postalCode,
    required this.dateOfBirth,
  });

  factory Member.fromJson(Map<String, dynamic> json) => Member(
    memberId: json["member_id"],
    first_name: json["first_name"],
    last_name: json["last_name"],
    preferedName: json["prefered_name"]??"",
    email: json["email"],
    phoneNumber: json["phone_number"],
    memberParentId: json["member_parent_id"],
    addressLine1: json["address_line1"]??"",
    addressLine2: json["address_line2"]??"",
    name: json["name"],
    city: json["city"],
    postalCode: json["postal_code"]??"",
    dateOfBirth: DateTime.parse(json["date_of_birth"]),
  );

  Map<String, dynamic> toJson() => {
    "member_id": memberId,
    "first_name": first_name,
    "last_name": last_name,
    "prefered_name": preferedName,
    "email": email,
    "phone_number": phoneNumber,
    "member_parent_id": memberParentId,
    "address_line1": addressLine1,
    "address_line2": addressLine2,
    "name": name,
    "city": city,
    "postal_code": postalCode,
    "date_of_birth": "${dateOfBirth.year.toString().padLeft(4, '0')}-${dateOfBirth.month.toString().padLeft(2, '0')}-${dateOfBirth.day.toString().padLeft(2, '0')}",

  };
}

