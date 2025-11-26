import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:kirpix/Utils/Constant/ApiConfig/ApiEndPoints.dart';

import '../../AppBarWithBack.dart';
import '../../Controller/EventController.dart';
import '../../Utils/Constant/AppTheme.dart';
import '../../Utils/Constant/analytics_service.dart';
import '../../Widgets/ImageUtility.dart';
import '../../Widgets/Shadow.dart';
import '../Search/CustomSearchPage.dart';
import 'EventDeatils.dart';

class EventPage extends StatefulWidget {
  const EventPage({Key? key}) : super(key: key);

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {

  EventController eventController =Get.put(EventController());
  AnalyticsService analyticsService=AnalyticsService();
  String flag="";
  String selectedDate="";
  DateTime date = DateTime.now();
  final DateFormat formatter = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    // TODO: implement initState
    //analyticsService.logEvent("Event");
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.back_color,
      appBar: AppBarBack(title: '',),
      body: Column(
        children: [
          Container(
            width: Get.width,
            height: 65,
            decoration: ShapeDecoration(
              gradient: LinearGradient(
                begin: Alignment(0.00, -1.00),
                end: Alignment(0, 1),
                colors: [Color(0xFF9BC838), Color(0xFF4F9D01)],
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
              shadows: [
                BoxShadow(
                  color: Color(0xFFC6C6C6).withOpacity(0.75),
                  blurRadius: 4,
                  offset: Offset(0, 0),
                  spreadRadius: 0,
                )
              ],
            ),
            child: Row(children: [
              GestureDetector(
                onTap:(){
                  Get.to(CustomSearchPage());
                },
                child: Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: Container(
                    width: Get.width*0.78,
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: CustomDecorations().BackgroundDecorationwithRadiusTen(),
                    child: Row(
                      children: [
                        Image(
                          image: AssetImage("assets/images/Search.png"),
                          height: 20,
                          width: 20,
                        ),
                        SizedBox(width: 10,),
                        Text(
                          'Search',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.grayText,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  _addEventFilter(context);
                },
                child: Container(
                  width: 40,
                  height: 40,
                  padding: const EdgeInsets.all(5),
                  decoration: CustomDecorations().BackgroundDecorationwithRadiusTen(),
                  child: Center(
                    child: Image(
                      image: AssetImage("assets/images/documentfilter.png"),
                      height: 24,
                      width: 24,
                    ),
                  ),
                ),
              ),
            ],),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      children: [
                        Obx(() {
                          if (eventController.isLoading.value)
                            return Center(child: CircularProgressIndicator());
                          else {
                            return eventController.evList.length!=0?
                            ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: eventController.evList.length,
                                itemBuilder: (context, index) {
                                  return  GestureDetector(
                                    onTap: () async {
                                      final response = await eventController.getEventDetails(eventController.evList[index].eventId);
                                      Get.to(EventDetails(eventController.evList[index].eventId,response));
                                      setState(() {

                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 14.0),
                                      child: Container(
                                          width: Get.width,
                                          decoration: CustomDecorations()
                                              .BackgroundDecorationwithRedius(),
                                          child: Stack(children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.only(
                                                          left: 3.0, top: 3, bottom: 3),
                                                      child: Container(
                                                        width: 90,
                                                        height: 90,
                                                        decoration: ShapeDecoration(
                                                          color: Colors.white,
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                            BorderRadius.circular(10),
                                                          ),
                                                        ),
                                                        child: Padding(
                                                            padding: const EdgeInsets.all(5.0),
                                                            child: Container(
                                                              height: 90,
                                                              width: 90,
                                                              decoration: ShapeDecoration(
                                                                image: DecorationImage(
                                                                    fit: BoxFit.fill,
                                                                    image: ImageUtility.buildImageProvider(eventController.evList[index].eventImage)),
                                                                color: Colors.white,
                                                                shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                  BorderRadius.circular(10),
                                                                ),
                                                              ),
                                                            )),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 95.0, right: 8.0, bottom: 8.0, top: 8.0),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    eventController.evList[index].eventDate,
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.w400,
                                                        color: AppTheme.apptheme_color),
                                                  ),
                                                  Text(
                                                    eventController.evList[index].eventTitle,
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w700,
                                                        color: AppTheme.dark_font_color),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Image.asset(
                                                        "assets/images/address.png",
                                                        height: 13,
                                                        width: 16,
                                                      ),
                                                      SizedBox(
                                                        width: 7,
                                                      ),
                                                      Flexible(
                                                        child: Text(
                                                          'QF2G+RCJ National Badminton QF2G +RCJ National Badminton...',
                                                          maxLines: 3,
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.w400,
                                                              color: AppTheme.dark_font_secondary),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ])),
                                    ),
                                  );
                                }): Center(
                              child:Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: 100,),
                                  Image.asset("assets/svg/nodata_found.gif",
                                    height: 150,
                                    width: 150,
                                  ),
                                  SizedBox(height: 30,),

                                  Text(
                                    'There are no events scheduled for that date.',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppTheme.dark_font_secondary,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                        }),



                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  void _addEventFilter(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        barrierColor: Colors.black.withAlpha(1),
        context: context,
        isScrollControlled: true,
        isDismissible: true,
        builder: (BuildContext context) {
          return DraggableScrollableSheet(
            maxChildSize: 0.44,
            initialChildSize: 0.44,
            minChildSize: 0.44,
            builder: (context, scrollController) {
              return StatefulBuilder(
                  builder: (context, setStateInsideBottomSheet) {
                    return Container(
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Column(
                            children: [
                              SizedBox(height: 20,),
                              Container(
                                  width: Get.width,
                                  decoration: CustomDecorations()
                                      .BackgroundDecorationwithRadiusTen(),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () {},
                                        child: Padding(
                                          padding: const EdgeInsets.all(13.0),
                                          child: Row(
                                            children: [
                                              Row(
                                                children: <Widget>[
                                                  Padding(
                                                    padding: const EdgeInsets.all(
                                                        8.0),
                                                    child: Text('Time & Date',
                                                      style: TextStyle(
                                                          color: AppTheme
                                                              .dark_font_color,
                                                          fontSize: 16,
                                                          fontWeight: FontWeight
                                                              .w700),),
                                                  ),
                                                ],
                                              ),
                                              Spacer(),
                                              SvgPicture.asset(
                                                'assets/svg/down_arrow.svg',
                                                height: 24.0,
                                                width: 24.0,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Divider(height: 0.8,
                                        thickness: 0.9,
                                        indent: 1,
                                        color: AppTheme.grayText,),
                                      Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                flag = "today";
                                                selectedDate = "";
                                                setStateInsideBottomSheet(() {

                                                });
                                              },
                                              child: Container(
                                                padding: const EdgeInsets
                                                    .symmetric(
                                                    horizontal: 10, vertical: 10),
                                                clipBehavior: Clip.antiAlias,
                                                decoration: ShapeDecoration(
                                                  color: flag == "today"
                                                      ? AppTheme.apptheme_color
                                                      : Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    side: BorderSide(width: 0.50,
                                                        color: Color(0xFFDFE2E5)),
                                                    borderRadius: BorderRadius
                                                        .circular(10),
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  mainAxisAlignment: MainAxisAlignment
                                                      .start,
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .center,
                                                  children: [
                                                    Text(
                                                      'Today',
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        color: flag == "today"
                                                            ? Colors.white
                                                            : Color(0xFF484848),
                                                        fontSize: 14,
                                                        fontWeight: FontWeight
                                                            .w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 10,),
                                            GestureDetector(
                                              onTap: () {
                                                flag = "tomorrow";
                                                selectedDate = "";
                                                setStateInsideBottomSheet(() {});
                                              },
                                              child: Container(
                                                padding: const EdgeInsets
                                                    .symmetric(
                                                    horizontal: 10, vertical: 10),
                                                clipBehavior: Clip.antiAlias,
                                                decoration: ShapeDecoration(
                                                  color: flag == "tomorrow"
                                                      ? AppTheme.apptheme_color
                                                      : Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    side: BorderSide(
                                                        width: 0.50,
                                                        color: Color(0xFFDFE2E5)),
                                                    borderRadius:
                                                    BorderRadius.circular(10),
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Tommorrow',
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        color: flag == "tomorrow"
                                                            ? Colors.white
                                                            : Color(0xFF484848),
                                                        fontSize: 14,
                                                        fontWeight: FontWeight
                                                            .w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 10,),
                                            GestureDetector(
                                              onTap: () {
                                                flag = "this_week";
                                                selectedDate = "";
                                                setStateInsideBottomSheet(() {

                                                });
                                              },
                                              child: Container(
                                                padding: const EdgeInsets
                                                    .symmetric(
                                                    horizontal: 10, vertical: 10),
                                                clipBehavior: Clip.antiAlias,
                                                decoration: ShapeDecoration(
                                                  color: flag == "this_week"
                                                      ? AppTheme.apptheme_color
                                                      : Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    side: BorderSide(width: 0.50,
                                                        color: Color(0xFFDFE2E5)),
                                                    borderRadius: BorderRadius
                                                        .circular(10),
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  mainAxisAlignment: MainAxisAlignment
                                                      .start,
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .center,
                                                  children: [
                                                    Text(
                                                      'This Week',
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        color: flag == "this_week"
                                                            ? Colors.white
                                                            : Color(0xFF484848),
                                                        fontSize: 14,
                                                        fontWeight: FontWeight
                                                            .w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),

                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 12.0,
                                            right: 12.0,
                                            left: 12.0),
                                        child:
                                        Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                flag = "month";
                                                selectedDate = "";
                                                setStateInsideBottomSheet(() {

                                                });
                                              },
                                              child: Container(
                                                padding: const EdgeInsets
                                                    .symmetric(
                                                    horizontal: 10, vertical: 10),
                                                clipBehavior: Clip.antiAlias,
                                                decoration: ShapeDecoration(
                                                  color: flag == "month"
                                                      ? AppTheme.apptheme_color
                                                      : Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    side: BorderSide(width: 0.50,
                                                        color: Color(0xFFDFE2E5)),
                                                    borderRadius: BorderRadius
                                                        .circular(10),
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  mainAxisAlignment: MainAxisAlignment
                                                      .start,
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .center,
                                                  children: [
                                                    Text(
                                                      'This Month',
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        color: flag == "month"
                                                            ? Colors.white
                                                            : Color(0xFF484848),
                                                        fontSize: 14,
                                                        fontWeight: FontWeight
                                                            .w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 10,),
                                            GestureDetector(
                                              onTap: () async {
                                                flag = "selected_date";
                                                await _selectDate(context);

                                                final String formatted = formatter
                                                    .format(date);
                                                selectedDate = formatted;
                                                setStateInsideBottomSheet(() {});
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 10, vertical: 10),
                                                clipBehavior: Clip.antiAlias,
                                                decoration: ShapeDecoration(
                                                  color: flag == "selected_date"
                                                      ? AppTheme.apptheme_color
                                                      : Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    side: BorderSide(width: 0.50,
                                                        color: Color(0xFFDFE2E5)),
                                                    borderRadius: BorderRadius
                                                        .circular(10),
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  mainAxisAlignment: MainAxisAlignment
                                                      .start,
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .center,
                                                  children: [
                                                    Icon(Iconsax.calendar_search,
                                                        size: 18,
                                                        color: AppTheme.dark_font_color.withOpacity(0.75)),
                                                    SizedBox(width: 10,),
                                                    Text(
                                                      'Choose From Calender',
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        color: flag == "selected_date"
                                                            ? Colors.white
                                                            : Color(0xFF484848),
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                              ),
                              SizedBox(height: 30,),
                              GestureDetector(
                                onTap: () {
                                  eventController.getData(flag, selectedDate);
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  height: 52,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 14),
                                  decoration: ShapeDecoration(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          width: 0.50, color: Color(0xFF7DCA2E)),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: SizedBox(
                                          child: Text(
                                            'Apply Filter',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Color(0xFF7DCA2E),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              height: 1.50,
                                              letterSpacing: 0.60,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 20,),
                              GestureDetector(
                                onTap: () {
                                  eventController.getData("", "");
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  height: 52,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 14),
                                  decoration: ShapeDecoration(
                                    color: AppTheme.apptheme_color,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          width: 0.50, color: Color(0xFF7DCA2E)),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: SizedBox(
                                          child: Text(
                                            'Clear Filter',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              height: 1.50,
                                              letterSpacing: 0.60,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      decoration: CustomDecorations()
                          .BackgroundDecorationwithRedius(),
                    );
                  });
            },
          );
        });
  }

  Future<void> _selectDate(BuildContext context) async {
    final now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      context: context,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(  // Use light theme for better contrast
            colorScheme: ColorScheme.light(
              primary: AppTheme.apptheme_color, // Header background color
              onPrimary: Colors.white,          // Header text color
              onSurface: Colors.black,          // Date text color
            ),
            dialogBackgroundColor: Colors.white,  // Background color
            textButtonTheme: TextButtonThemeData( // Buttons inside dialog
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.apptheme_color, // Button text color
              ),
            ),
          ),
          child: child ?? SizedBox.shrink(),
        );
      },
      initialDate: date ?? now,
      firstDate: DateTime.now(), // Set the first selectable date
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != date) {
      setState(() {
        date = picked;
      });
    }
  }


}