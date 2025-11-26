// To parse this JSON data, do
//
//     final eventDetailsList = eventDetailsListFromJson(jsonString);

import 'dart:convert';

EventDetailsList eventDetailsListFromJson(String str) => EventDetailsList.fromJson(json.decode(str));

String eventDetailsListToJson(EventDetailsList data) => json.encode(data.toJson());

class EventDetailsList {
  String status;
  String message;
  Data data;

  EventDetailsList({
    required this.status,
    required this.message,
    required this.data,
  });

  factory EventDetailsList.fromJson(Map<String, dynamic> json) => EventDetailsList(
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
  int eventId;
  String eventTitle;
  String eventImage;
  String eventDescription;
  dynamic eventAddress;
  DateTime eventDate;
  DateTime eventEndDate;

  Data({
    required this.eventId,
    required this.eventTitle,
    required this.eventImage,
    required this.eventDescription,
    required this.eventAddress,
    required this.eventDate,
    required this.eventEndDate,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    eventId: json["event_id"],
    eventTitle: json["event_title"],
    eventImage: json["event_image"],
    eventDescription: json["event_description"],
    eventAddress: json["event_address"],
    eventDate: DateTime.parse(json["event_date"]),
    eventEndDate: DateTime.parse(json["event_end_date"]),
  );

  Map<String, dynamic> toJson() => {
    "event_id": eventId,
    "event_title": eventTitle,
    "event_image": eventImage,
    "event_description": eventDescription,
    "event_address": eventAddress,
    "event_date": eventDate.toIso8601String(),
    "event_end_date": eventEndDate.toIso8601String(),
  };
}
