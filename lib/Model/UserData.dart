// To parse this JSON data, do
//
//     final userData = userDataFromJson(jsonString);

import 'dart:convert';

UserData userDataFromJson(String str) => UserData.fromJson(json.decode(str));

String userDataToJson(UserData data) => json.encode(data.toJson());

class UserData {
  String status;
  String message;
  Data data;

  UserData({
    required this.status,
    required this.message,
    required this.data,
  });

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    status: json["status"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  int customerId;
  String firstName;
  String lastName;
  String email;

  String phoneNumber;
  String token;


  Data({
    required this.customerId,
    required this.firstName,
    required this.lastName,
    required this.email,

    required this.phoneNumber,
    required this.token,

  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    customerId: json["customer_id"],
    firstName: json["first_name"]?? '',
    lastName: json["last_name"]?? '',
    email: json["email"],
    phoneNumber: json["phone_number"]?? '',
    token: json["token"]?? '',

  );

  Map<String, dynamic> toJson() => {
    "customer_id": customerId,
    "first_name": firstName,
    "last_name": lastName,
    "email": email,

    "phone_number": phoneNumber,
    "token": token,

  };
}
