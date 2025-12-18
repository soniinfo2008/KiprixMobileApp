// To parse this JSON data, do
//
//     final eventList = eventListFromJson(jsonString);

import 'dart:convert';

EventList eventListFromJson(String str) => EventList.fromJson(json.decode(str));

String eventListToJson(EventList data) => json.encode(data.toJson());

class EventList {
  String status;
  String message;
  List<Event> data;

  EventList({
    required this.status,
    required this.message,
    required this.data,
  });

  factory EventList.fromJson(Map<String, dynamic> json) => EventList(
    status: json["status"],
    message: json["message"],
    data: List<Event>.from(json["data"].map((x) => Event.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Event {
  int eventId;
  String eventTitle;
  String eventImage;
  String eventDescription;
  dynamic eventAddress;
  String eventDate;
  String eventEndDate;

  Event({
    required this.eventId,
    required this.eventTitle,
    required this.eventImage,
    required this.eventDescription,
    required this.eventAddress,
    required this.eventDate,
    required this.eventEndDate,
  });

  factory Event.fromJson(Map<String, dynamic> json) => Event(
    eventId: json["event_id"],
    eventTitle: json["event_title"],
    eventImage: json["event_image"],
    eventDescription: json["event_description"]?? '',
    eventAddress: json["event_address"],
    eventDate: json["event_date"],
    eventEndDate: json["event_end_date"],
  );

  Map<String, dynamic> toJson() => {
    "event_id": eventId,
    "event_title": eventTitle,
    "event_image": eventImage,
    "event_description": eventDescription,
    "event_address": eventAddress,
    "event_date": eventDate,
    "event_end_date": eventEndDate,
  };
}