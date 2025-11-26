import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kirpix/AppBarWithBack.dart';
import 'package:kirpix/Utils/Constant/AppTheme.dart';
import 'package:http/http.dart' as http;
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';
import '../../Controller/EventController.dart';
import '../../Model/EventDetailsList.dart';
import '../../Model/EventList.dart';
import '../../Utils/Constant/analytics_service.dart';
import '../../Widgets/ImageUtility.dart';

class EventDetails extends StatefulWidget {

  final int eventID;
  final EventDetailsList quote;
  const EventDetails(int this.eventID,EventDetailsList this.quote);

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  EventController eventController=Get.put(EventController());
  AnalyticsService analyticsService=AnalyticsService();
  bool _isLoading = true;
  late Timer timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // analyticsService.logEvent("Event Details");
    timer = Timer(Duration(seconds: 1), () {
      _isLoading = false;
      setState(() {

      });
    });
  }




  @override
  Widget build(BuildContext context) {

    Map<String, String> dateInfo = getMonthAndYearFromDate(widget.quote.data.eventDate.toString());
    return OverlayLoaderWithAppIcon(
      isLoading: _isLoading,
      overlayBackgroundColor: Colors.black,
      circularProgressColor: Color(0xff7dca2e),
      appIcon: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset('assets/images/appicon.png'),
      ),
      child:Scaffold(
        backgroundColor: AppTheme.back_color,
        appBar: AppBarBack(title: ''),
        body:
        Stack(
          children: <Widget>[
            Container(
              width: Get.width,
              height: 380,
              decoration: ShapeDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image:NetworkImage(ImageUtility.ImageUrl(widget.quote.data.eventImage)),),
                // image: AssetImage('assets/images/imageBack.png')),
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(0),

                ),
              ),
              child: Image.asset('assets/images/imageBack.png', fit: BoxFit.fill,),
            ),
            Container(
              width: Get.width,
              height:Get.height,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(0),

                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 290,),
                    Text(
                      'Event',
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.dark_font_color),
                    ),
                    SizedBox(height: 5,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            widget.quote.data.eventTitle ,
                            maxLines: 2,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.dark_font_color),
                          ),
                        ),
                        Container(
                          width: 60,
                          height: 60,
                          decoration: ShapeDecoration(
                            gradient: LinearGradient(
                              begin: Alignment(0.00, -1.00),
                              end: Alignment(0, 1),
                              colors: [Color(0xFF9BC838), Color(0xFF4F9D01)],
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                getMonthFromDate(widget.quote.data.eventDate.toString()),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontFamily: 'DM Sans',
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.30,
                                ),
                              ),
                              Text(
                                subtractDayFromDate(widget.quote.data.eventDate.toString()).toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontFamily: 'DM Sans',
                                  fontWeight: FontWeight.w700,
                                ),
                              )
                            ],),
                        ),
                      ],
                    ),
                    SizedBox(height: 5,),
                    Text(
                      'Start Date:- ${subtractDayFromDate(widget.quote.data.eventDate.toString()).toString()} ${getMonthFromDate(widget.quote.data.eventDate.toString())} ${dateInfo['year']}',
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.dark_font_secondary),
                    ),
                    Text(
                      'End Date:- ${subtractDayFromDate(widget.quote.data.eventEndDate.toString()).toString()} ${getMonthFromDate(widget.quote.data.eventEndDate.toString())}  ${dateInfo['year']}',
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.dark_font_secondary),
                    ),
                    SizedBox(height: 10,),
                    // Flexible(
                    //   child: Text(
                    //     widget.quote.data.eventDescription,
                    //     style: TextStyle(
                    //         fontSize: 14,
                    //         fontWeight: FontWeight.w400,
                    //         color: AppTheme.dark_font_color),
                    //   ),
                    // ),
                    Flexible(
                        child:Html(
                            data: widget.quote.data.eventDescription,
                            style: {
                              "body": Style(
                                fontWeight: FontWeight.w400,
                                color: AppTheme.dark_font_color,
                              )
                            })),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int subtractDayFromDate(String dateString) {
    DateTime date = DateTime.parse(dateString);
    return date.day;
  }


  String getMonthFromDate(String dateString) {
    try {
      String datePart = dateString.split(' ')[0];
      DateTime date = DateTime.parse(datePart);
      String month = DateFormat.MMM().format(date).toUpperCase();
      print("Extracted Month: $month");
      return month;
    } catch (e) {
      print("Error extracting month: $e");
    }
    return "N/A";
  }


  Map<String, String> getMonthAndYearFromDate(String dateString) {
    try {

      String datePart = dateString.split(' ')[0];
      DateTime date = DateTime.parse(datePart);
      String month = DateFormat.MMM().format(date).toUpperCase();
      String year = DateFormat.y().format(date);

      print("Extracted Month: $month, Extracted Year: $year");
      return {"month": month, "year": year};
    } catch (e) {
      print("Error extracting month and year: $e");
    }

    return {"month": "N/A", "year": "N/A"};
  }

}