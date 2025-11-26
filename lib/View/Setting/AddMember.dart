import 'dart:async';
import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kirpix/Controller/MemberController.dart';
import 'package:kirpix/Utils/Constant/analytics_service.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';
import '../../AppBarWithBack.dart';
import '../../Controller/CountryStateCityController.dart';
import '../../Utils/Constant/ApiConfig/ApiEndPoints.dart';
import '../../Utils/Constant/AppTheme.dart';
import 'package:http/http.dart' as http;

class AddMember extends StatefulWidget {
  String Type = "";
  String userId = "";
  String emailId = "";
  String firstName = "";
  String lastName = "";
  String prfName = "";
  String phoneNumber = "";
  String address1 = "";
  String address2 = "";
  String memberId = "";

  AddMember(
    String this.Type,
    String this.userId,
    String this.emailId,
    String this.firstName,
    String this.lastName,
    String this.prfName,
    String this.phoneNumber,
    String this.address1,
    String this.address2,
    String this.memberId,
  );

  @override
  State<AddMember> createState() => _AddMemberState();
}

class _AddMemberState extends State<AddMember> {
  MemberController memberController = Get.put(MemberController());
  CountryStateCityController countryStateCityController =
      Get.put(CountryStateCityController());
  AnalyticsService analyticsService=AnalyticsService();

  final List<String> accountType = ['Select Gender', 'Male', 'Female'];
  final List<String> StatusType = [
    'Select Marital status',
    'Married',
    'Unmarried',
    'Single'
  ];
  String GenderValue = "Select Gender";
  String MaritalValue = "Select Marital status";
  DateTime date = DateTime.now();
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  bool _isLoading = false;
  bool editVisible = true;
  String? selectedValue = null;

  TextEditingController cntname = TextEditingController();
  TextEditingController cntlastname = TextEditingController();
  TextEditingController cntpefname = TextEditingController();
  TextEditingController cntgender = TextEditingController();
  TextEditingController DOBcontroller = TextEditingController();
  TextEditingController cntEmail = TextEditingController();
  TextEditingController cntPhone = TextEditingController();
  TextEditingController cntstreet1 = TextEditingController();
  TextEditingController cntstreet2 = TextEditingController();
  TextEditingController cntRegion = TextEditingController();
  TextEditingController cntzipcode = TextEditingController();
  TextEditingController cntcountry = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? dropdownValueTapeTestOne = null;
  String? dropdownValueTapeTesttwo = null;
  String? dropdownValueTapeTestthree = null;
  String SelectedCountryId = "";
  String SelectedSateId = "";
  String SelectedCityId = "";

  @override
  void initState() {
    if (widget.Type.contains("edit")) {
      editVisible = false;
      cntname.text = widget.firstName;
      cntlastname.text = widget.lastName;
      cntpefname.text = widget.prfName;
      cntEmail.text = widget.emailId;
      cntPhone.text = widget.phoneNumber;
      cntstreet1.text = widget.address1;
      cntstreet2.text = widget.address2;
      setState(() {});
    } else {
      editVisible = true;
    }
    analyticsService.logEvent('Add Member');


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return OverlayLoaderWithAppIcon(
      isLoading: _isLoading,
      overlayBackgroundColor: Colors.black,
      circularProgressColor: Color(0xff7dca2e),
      appIcon: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset('assets/images/appicon.png'),
      ),
      child: Form(
        key: _formKey,
        child: Scaffold(
          backgroundColor: AppTheme.back_color,
          appBar: AppBarBack(
            title: '',
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Text(
                      'Email Address',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.dark_font_color),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    controller: cntEmail,
                    keyboardType: TextInputType.emailAddress,
                    style: new TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.black),
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'Ex: abc@gmail.com',
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 17.0, horizontal: 10.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    ),
                    onChanged: (value) {
                      if (value.length > 5) {
                        _isLoading = false;
                        setState(() {});
                        memberAccountAllReadyExits(cntEmail.text, "");
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Email Address.';
                      }if(!RegExp("[a-z0-9]+@[a-z0-9]+.[a-z]{2,3}").hasMatch(value)){
                        return 'Please Enter valid Email Address';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Text(
                      'Member First Name',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.dark_font_color),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    enabled: editVisible,
                    controller: cntname,
                    textCapitalization: TextCapitalization.words,
                    keyboardType: TextInputType.name,
                    maxLength: 15,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[a-zA-Z -]"))],
                    style: new TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.black),
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      counterText: "",
                      hintText: 'Enter First Name',
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 17.0, horizontal: 10.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter First Name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.0),

                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Text(
                      'Member Last Name',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.dark_font_color),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    enabled: editVisible,
                    controller: cntlastname,
                    textCapitalization: TextCapitalization.words,
                    keyboardType: TextInputType.name,
                    maxLength: 15,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[a-zA-Z -]"))],
                    style: new TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.black),
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      counterText: "",
                      hintText: 'Enter Last Name',
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 17.0, horizontal: 10.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Last Name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Text(
                      'Preferred Name',

                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.dark_font_color),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    controller: cntpefname,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[a-zA-Z -]"))],
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.words,
                    maxLength: 20,
                    style: new TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.black),
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      counterText: "",
                      hintText: 'Enter Preferred Name',
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 17.0, horizontal: 10.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    ),
                    // validator: (value) {
                    //   if (value == null || value.isEmpty) {
                    //     return 'Please Enter Preferred Name';
                    //   }
                    //   return null;
                    // },
                  ),
                  SizedBox(height: 20.0),
                  Visibility(
                    visible: editVisible,
                    child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Text(
                            'Gender',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.dark_font_color),
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Container(
                          height: 55,
                          child: InputDecorator(
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1.5, color: Color(0xffdfe2e5)),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1.5, color: Color(0xff7dca2e)),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1.5, color: Color(0xfff44336)),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1.5, color: Color(0xfff44336)),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                  isDense: true,
                                  value: GenderValue,
                                  iconEnabledColor:
                                      AppTheme.dark_font_secondary,
                                  dropdownColor: AppTheme.back_color,
                                  items: accountType
                                      .map((data) => DropdownMenuItem<String>(
                                          value: data,
                                          child: Text(
                                            data,
                                            style: TextStyle(
                                              fontSize: 14,
                                                color: AppTheme
                                                    .dark_font_secondary),
                                          )))
                                      .toList(),
                                  onChanged: (data) {
                                    setState(() {
                                      GenderValue = data!;
                                      print("valueafterchangedgender-->" +
                                          GenderValue.toString());
                                    });
                                  }),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Text(
                            'Marital status',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.dark_font_color),
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Container(
                          height: 55,
                          child: InputDecorator(
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1.5, color: Color(0xffdfe2e5)),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1.5, color: Color(0xff7dca2e)),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1.5, color: Color(0xfff44336)),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1.5, color: Color(0xfff44336)),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                  isDense: true,
                                  value: MaritalValue,
                                  iconEnabledColor:
                                      AppTheme.dark_font_secondary,
                                  dropdownColor: AppTheme.back_color,
                                  items: StatusType.map(
                                      (data) => DropdownMenuItem<String>(
                                          value: data,
                                          child: Text(
                                            data,
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: AppTheme
                                                    .dark_font_secondary),
                                          ))).toList(),
                                  onChanged: (data) {
                                    setState(() {
                                      MaritalValue = data!;
                                      print("valueafterchangedgender-->" +
                                          MaritalValue.toString());
                                    });
                                  }),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Text(
                            'Date Of Birth ',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.dark_font_color),
                          ),
                        ),
                        SizedBox(height: 10.0),
                        TextFormField(
                          enabled: editVisible,
                          controller: DOBcontroller,
                          onTap: () async {
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                            // Show Date Picker Here
                            await _selectDate(context);

                            final String formatted = formatter.format(date);
                            DOBcontroller.text = formatted;
                            setState(() {});
                          },
                          keyboardType: TextInputType.datetime,
                          style: new TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            hintText: '12-02-2023',
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 17.0, horizontal: 10.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Date';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20.0),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Text(
                      'Phone number',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.dark_font_color),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    controller: cntPhone,
                    enabled: editVisible,
                    maxLength: 8,
                    keyboardType: TextInputType.phone,
                    style: new TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.black),
                    decoration: InputDecoration(
                      counterText: "",
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'Ex: 98765432',
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 17.0, horizontal: 10.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    ),
                    validator: (value) {
                      if (RegExp(r'^5\d{7}$').hasMatch(value!)==false) {
                        return 'Wrong mobile number format(should start with 5 and be a total of 8 digits)';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Text(
                      'Street 1 ',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.dark_font_color),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    enabled: editVisible,
                    controller: cntstreet1,
                    keyboardType: TextInputType.text,
                    style: new TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.black),
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'Enter Street 1',
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 17.0, horizontal: 10.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    ),
                    // validator: (value) {
                    //   if (value == null || value.isEmpty) {
                    //     return 'Please Enter Street 1';
                    //   }
                    //   return null;
                    // },
                  ),
                  SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Text(
                      'Street 2 ',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.dark_font_color),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    enabled: editVisible,
                    controller: cntstreet2,
                    keyboardType: TextInputType.text,
                    style: new TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.black),
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'Enter Street 2',
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 17.0, horizontal: 10.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    ),
                    // validator: (value) {
                    //   if (value == null || value.isEmpty) {
                    //     return 'Please Enter Street 2';
                    //   }
                    //   return null;
                    // },
                  ),
                  SizedBox(height: 20.0),
                  Visibility(
                      visible: editVisible,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: Text(
                              'Country',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.dark_font_color),
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Container(
                            height: 55,
                            child: DropdownSearch<String>(
                              popupProps: PopupProps.menu(
                                fit: FlexFit.loose,
                                showSearchBox: true,

                                menuProps: MenuProps(
                                  backgroundColor: Colors.white,
                                  elevation: 1,
                                ),),
                              selectedItem: dropdownValueTapeTestOne,
                              //list of dropdown items

                              items: countryStateCityController.listCountry,
                              // dropdownSearchDecoration: InputDecoration(
                              //     hintText: "Select Country",
                              //     filled: true,
                              //     fillColor: Colors.white),

                              onChanged: (value) {
                                for (int i = 0;
                                    i <
                                        countryStateCityController
                                            .countryList.length;
                                    i++) {
                                  if (countryStateCityController
                                      .countryList[i].name
                                      .toString()
                                      .contains(value!)) {
                                    SelectedCountryId =
                                        countryStateCityController
                                            .countryList[i].id
                                            .toString();
                                    countryStateCityController
                                        .getState(SelectedCountryId);
                                    _isLoading = true;
                                    Timer(Duration(seconds: 4), () {
                                      _isLoading = false;
                                      setState(() {});
                                    });
                                    print('$value exists in the list.');
                                  } else {
                                    print('$value does not exist in the list.');
                                  }
                                }
                                setState(() {});
                              },
                            ),
                          ),
                          SizedBox(height: 20.0),
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: Text(
                              'State',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.dark_font_color),
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Container(
                            height: 57,
                            child: DropdownSearch<String>(
                              popupProps: PopupProps.menu(
                                fit: FlexFit.loose,
                                showSearchBox: true,

                                menuProps: MenuProps(
                                  backgroundColor: Colors.white,
                                  elevation: 1,
                                ),),
                              selectedItem: dropdownValueTapeTesttwo,
                              //list of dropdown items
                              items: countryStateCityController.listState,

                              // dropdownSearchDecoration: InputDecoration(
                              //     hintText: "Select State",
                              //     filled: true,
                              //     fillColor: Colors.white),
                              onChanged: (value) {
                                for (int i = 0;
                                    i <
                                        countryStateCityController
                                            .stateList.length;
                                    i++) {
                                  if (countryStateCityController
                                      .stateList[i].name
                                      .toString()
                                      .contains(value!)) {
                                    SelectedSateId = countryStateCityController
                                        .stateList[i].id
                                        .toString();
                                    countryStateCityController
                                        .getCity(SelectedSateId);
                                    _isLoading = true;
                                    Timer(Duration(seconds: 4), () {
                                      _isLoading = false;
                                      setState(() {});
                                    });
                                    print('$value exists in the list.');
                                  } else {
                                    print('$value does not exist in the list.');
                                  }
                                }
                                setState(() {});
                              },
                            ),
                          ),
                          SizedBox(height: 20.0),
                        ],
                      )),
                  Visibility(
                    visible: editVisible,
                    child: Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Text(
                                    'Region',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: AppTheme.dark_font_color),
                                  ),
                                ),
                                SizedBox(height: 10.0),
                                Container(
                                  height: 57,
                                  child: DropdownSearch<String>(
                                    popupProps: PopupProps.menu(
                                      fit: FlexFit.loose,
                                      showSearchBox: true,

                                      menuProps: MenuProps(
                                        backgroundColor: Colors.white,
                                        elevation: 1,
                                      ),),
                                    selectedItem: dropdownValueTapeTestthree,
                                    //list of dropdown items
                                    items: countryStateCityController.listCity,

                                    // dropdownSearchDecoration: InputDecoration(
                                    //     hintText: "Select Region",
                                    //     filled: true,
                                    //     fillColor: Colors.white),

                                    onChanged: (value) {
                                      for (int i = 0;
                                          i <
                                              countryStateCityController
                                                  .cityList.length;
                                          i++) {
                                        if (countryStateCityController
                                            .cityList[i].name
                                            .toString()
                                            .contains(value!)) {
                                          SelectedCityId =
                                              countryStateCityController
                                                  .cityList[i].id
                                                  .toString();

                                          print('$value exists in the list.');
                                        } else {
                                          print(
                                              '$value does not exist in the list.');
                                        }
                                      }
                                      setState(() {});
                                    },
                                  ),
                                ),
                              ],
                            )),
                        SizedBox(
                          width: 14,
                        ),
                        Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Text(
                                    'Zip Code',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: AppTheme.dark_font_color),
                                  ),
                                ),
                                SizedBox(height: 10.0),
                                TextFormField(
                                  controller: cntzipcode,
                                  enabled: editVisible,
                                  maxLength: 6,
                                  keyboardType: TextInputType.number,
                                  style: new TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black),
                                  decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    hintText: '123456',
                                    counterText: "",
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 17.0, horizontal: 10.0),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                  ),
                                  // validator: (value) {
                                  //   if (value == null || value.isEmpty) {
                                  //     return 'Please Enter Zip Code';
                                  //   }
                                  //   return null;
                                  // },
                                ),
                              ],
                            )),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.0),
                  GestureDetector(
                    onTap: () {
                      if (widget.Type.contains("edit")) {
                        _isLoading = true;
                        updateAccount();
                        setState(() {});
                      } else {
                        if (_formKey.currentState!.validate()) {
                            if (SelectedCountryId.isNotEmpty) {
                              if (SelectedSateId.isNotEmpty) {
                              if (SelectedCityId.isNotEmpty) {
                                  _isLoading = true;
                                  addnewMemberAccount();
                                  setState(() {});
                              } else {
                                Get.snackbar("Please Select Region", "",
                                    snackPosition: SnackPosition.TOP,
                                    backgroundColor:
                                    AppTheme.apptheme_color.withOpacity(0.50),
                                    colorText: AppTheme.back_color,
                                    borderColor: AppTheme.apptheme_color,
                                    borderWidth: 1,
                                    margin: EdgeInsets.only(
                                        bottom: 20, left: 10.0, right: 10.0));
                              }
                              } else {
                                Get.snackbar("Please Select State", "",
                                    snackPosition: SnackPosition.TOP,
                                    backgroundColor:
                                    AppTheme.apptheme_color.withOpacity(0.50),
                                    colorText: AppTheme.back_color,
                                    borderColor: AppTheme.apptheme_color,
                                    borderWidth: 1,
                                    margin: EdgeInsets.only(
                                        bottom: 20, left: 10.0, right: 10.0));
                              }
                            } else {
                              Get.snackbar("Please Select Country", "",
                                  snackPosition: SnackPosition.TOP,
                                  backgroundColor:
                                  AppTheme.apptheme_color.withOpacity(0.50),
                                  colorText: AppTheme.back_color,
                                  borderColor: AppTheme.apptheme_color,
                                  borderWidth: 1,
                                  margin: EdgeInsets.only(
                                      bottom: 20, left: 10.0, right: 10.0));
                            }
                        }
                      }
                    },
                    child: Container(
                      width: Get.width,
                      height: 50,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      decoration: ShapeDecoration(
                        gradient: LinearGradient(
                          begin: Alignment(0.00, -1.00),
                          end: Alignment(0, 1),
                          colors: [Color(0xFF9BC838), Color(0xFF4F9D01)],
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        shadows: [
                          BoxShadow(
                            color: Color(0x19C94210),
                            blurRadius: 30,
                            offset: Offset(0, 10),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Update/Add Member',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
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
        ),
      ),
    );
  }
  validateEmail(String? value) {
    String pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = RegExp(pattern);
    if (value == null)
      return 'Email Required';
    else if(value.isEmpty)
      return 'Email Required';
    else if(!regex.hasMatch(value))
      return 'Enter a valid email address';
    else
      return null;
  }

  Future<void> _selectDate(BuildContext context) async {
    final now = DateTime.now();
    final DateTime? picked = await showDatePicker(
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        context: context,
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData(
              primarySwatch: Colors.grey,
              splashColor: Colors.black,
              textTheme: TextTheme(
                titleMedium: TextStyle(color: Colors.black),
                labelLarge: TextStyle(color: Colors.black),
              ),
              dialogBackgroundColor: Colors.white,
            ),
            child: child ?? Text(""),
          );
        },
        initialDate: date ?? now,
        firstDate: DateTime(1900),
        lastDate: now);
    if (picked != null && picked != date) {
      setState(() {
        date = picked;
        print("sdfdf==>" + date.toString());
      });
    }
  }

  Future<void> addnewMemberAccount() async {
    print("SelectedSateId-->1" + cntname.text);
    print("SelectedSateId-->2" + cntlastname.text);
    print("SelectedSateId-->3" + cntpefname.text);
    print("SelectedSateId-->4" + cntEmail.text);
    print("SelectedSateId-->5" + GenderValue);
    print("SelectedSateId-->6" + cntPhone.text);
    print("SelectedSateId-->7" + cntstreet1.text);
    print("SelectedSateId-->8" + cntstreet2.text);
    print("SelectedSateId-->9" + cntzipcode.text);
    print("SelectedSateId-->10" + SelectedCountryId);
    print("SelectedSateId-->11" + SelectedSateId);
    print("SelectedSateId-->12" + SelectedCityId);
    print("SelectedSateId-->13" + DOBcontroller.text);
    print("SelectedSateId-->14" + widget.userId);
    print("SelectedSateId-->15" + MaritalValue);

    var request =
        http.MultipartRequest('POST', Uri.parse(ApiEndPoints.addNewMember));
    request.fields.addAll({
      'first_name': cntname.text,
      'last_name': cntlastname.text,
      'prefered_name': cntpefname.text,
      'email': cntEmail.text,
      'gender': GenderValue,
      'phone': cntPhone.text,
      'address_line1': cntstreet1.text,
      'address_line2': cntstreet2.text,
      'postal_code': cntzipcode.text,
      'country': SelectedCountryId,
      'state': SelectedSateId,
      'city': SelectedCityId,
      'birth_date': DOBcontroller.text,
      'customer_id': widget.userId,
      'marital_status': MaritalValue
    });

    http.StreamedResponse response = await request.send();
    print(response.statusCode);
    print("dfddfdfdfdfdfdfdf");
    if (response.statusCode == 200) {
      _isLoading = false;
      setState(() {});
      Get.snackbar("success", "Member inserted successfully",
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppTheme.apptheme_color.withOpacity(0.10),
          colorText: AppTheme.apptheme_color,
          borderColor: AppTheme.apptheme_color,
          borderWidth: 1,
          margin: EdgeInsets.only(bottom: 20, left: 10.0, right: 10.0));
      Navigator.pop(context);
      memberController.getData(widget.userId);
    } else {
      print(response.reasonPhrase);
      Get.snackbar("Failure", "Email ID Already Exist...",
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppTheme.apptheme_color.withOpacity(0.10),
          colorText: AppTheme.apptheme_color,
          borderColor: AppTheme.apptheme_color,
          borderWidth: 1,
          margin: EdgeInsets.only(bottom: 20, left: 10.0, right: 10.0));
      _isLoading = false;
      setState(() {});
    }
  }

  //update

  Future<void> updateAccount() async {
    var request =
        http.MultipartRequest('POST', Uri.parse(ApiEndPoints.updateMember));
    request.fields.addAll({
      'prefered_name': cntpefname.text,
      'customer_id': widget.userId,
      'email':cntEmail.text,
      'member_id': widget.memberId
    });

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      _isLoading = false;
      setState(() {});
      Get.snackbar("success", "Member Updated successfully",
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppTheme.apptheme_color.withOpacity(0.10),
          colorText: AppTheme.apptheme_color,
          borderColor: AppTheme.apptheme_color,
          borderWidth: 1,
          margin: EdgeInsets.only(bottom: 20, left: 10.0, right: 10.0));
      Navigator.pop(context);
      memberController.getData(widget.userId);
    } else {
      print('error');
      Get.snackbar("Failure", "Email ID Already Exist...",
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppTheme.apptheme_color.withOpacity(0.10),
          colorText: AppTheme.apptheme_color,
          borderColor: AppTheme.apptheme_color,
          borderWidth: 1,
          margin: EdgeInsets.only(bottom: 20, left: 10.0, right: 10.0));
      _isLoading = false;
      setState(() {});
    }
  }

  Future<void> memberAccountAllReadyExits(String text, String flag) async {
    print("enasivl_hf==>2" + text);

    var map = new Map<String, dynamic>();
    map['customer_id'] = widget.userId;
    map['email'] = text;
    map['flag'] = flag;

    final uri = ApiEndPoints.memberEmailExist;
    final response = await http.post(Uri.parse(uri), body: map);
    Map<String, dynamic> data = jsonDecode(response.body);
    print("asfsdfsdf==>>"+data.toString());
    if (data['status'] == 'success') {
      _isLoading = false;
      setState(() {});
    } else {
      // open popup
      _isLoading = false;
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return MemberExitDialog(
                data['data']['email'],data['message'], widget.userId, text);
          });
    }
  }
}

class MemberExitDialog extends StatelessWidget {
  final String name;
  final String msg;
  final String userId;
  final String email;

  MemberExitDialog(String this.name, String this.msg,  String this.userId, String this.email);

  dialogContent(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: const Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // To make the card compact
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(17.0),
            child: Text(
              "Member Already Exit",
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Divider(
            height: 0.8,
            thickness: 0.9,
            indent: 1,
            color: AppTheme.grayText,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
             msg,
              style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.dark_font_color),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 17.0, right: 17.0, bottom: 17.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 0.50, color: Color(0xFFDFE2E5)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        memberAccountAllReadyExits(userId, email, "No", context);
                        Navigator.pop(context);
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'No',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF484848),
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      memberAccountAllReadyExits(userId, email, "Yes", context);
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      clipBehavior: Clip.antiAlias,
                      decoration: ShapeDecoration(
                        color: AppTheme.apptheme_color,
                        shape: RoundedRectangleBorder(
                          side:
                              BorderSide(width: 0.50, color: Color(0xFFDFE2E5)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Yes',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  MemberController memberController = Get.put(MemberController());

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  Future<void> memberAccountAllReadyExits(
      String userId, String text, String flag, BuildContext context) async {
    print("enasivl_hf==>dialod" + text);

    var map = new Map<String, dynamic>();
    map['customer_id'] = userId;
    map['email'] = text;
    map['flag'] = flag;

    final uri = ApiEndPoints.memberEmailExist;
    final response = await http.post(Uri.parse(uri), body: map);
    Map<String, dynamic> data = jsonDecode(response.body);
    print("sdfsfdfd===>" + data['message']);
    if (response.statusCode == 200) {
      memberController.getData(userId);
      Get.snackbar("success", data['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppTheme.apptheme_color.withOpacity(0.10),
          colorText: AppTheme.apptheme_color,
          borderColor: AppTheme.apptheme_color,
          borderWidth: 1,
          margin: EdgeInsets.only(bottom: 20, left: 10.0, right: 10.0));
    } else {
      // open popup
    }
  }
}
