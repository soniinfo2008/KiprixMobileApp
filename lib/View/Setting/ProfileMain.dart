import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kirpix/Utils/Constant/ApiConfig/ApiEndPoints.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';
import 'package:http/http.dart' as http;
import '../../AppBarWithBack.dart';
import '../../Controller/CountryStateCityController.dart';
import '../../Utils/Constant/AppTheme.dart';
import '../../Utils/Constant/CustomDialogBox.dart';
import '../../Utils/Constant/analytics_service.dart';

class ProfileMain extends StatefulWidget {
  final String userId;

  ProfileMain(String this.userId);

  @override
  State<ProfileMain> createState() => _ProfileMainState();
}

class _ProfileMainState extends State<ProfileMain> {
  CountryStateCityController countryStateCityController = Get.put(CountryStateCityController());

  AnalyticsService analyticsService = AnalyticsService();

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
  TextEditingController cntzipcode = TextEditingController();

  // Focus Nodes
  FocusNode nameFocusNode = FocusNode();
  FocusNode lastNameFocusNode = FocusNode();
  FocusNode preferredNameFocusNode = FocusNode();
  FocusNode phoneFocusNode = FocusNode();
  FocusNode street1FocusNode = FocusNode();
  FocusNode street2FocusNode = FocusNode();
  FocusNode zipCodeFocusNode = FocusNode();

  final _formKey = GlobalKey<FormState>();
  String? dropdownValueTapeTestOne = null;
  String? dropdownValueTapeTesttwo = null;
  String? dropdownValueTapeTestthree = null;
  String SelectedCountryId = "";
  String SelectedSateId = "";
  String SelectedCityId = "";

  List<File> baseimage = [];
  String liveImage = "";

  @override
  void initState() {
    _isLoading = true;
    GetUserProfile();
    super.initState();
  }

  @override
  void dispose() {
    // Dispose all focus nodes
    nameFocusNode.dispose();
    lastNameFocusNode.dispose();
    preferredNameFocusNode.dispose();
    phoneFocusNode.dispose();
    street1FocusNode.dispose();
    street2FocusNode.dispose();
    zipCodeFocusNode.dispose();
    super.dispose();
  }

  // Dropdown change handlers with focus management
  void onCountryChanged(String? value) {
    // Close keyboard when dropdown is interacted with
    FocusManager.instance.primaryFocus?.unfocus();

    if (value != null) {
      for (int i = 0; i < countryStateCityController.countryList.length; i++) {
        if (countryStateCityController.countryList[i].name.toString().contains(value)) {
          SelectedCountryId = countryStateCityController.countryList[i].id.toString();
          countryStateCityController.getState(SelectedCountryId);
          dropdownValueTapeTesttwo = "";
          dropdownValueTapeTestthree = "";
          _isLoading = true;
          Timer(Duration(seconds: 4), () {
            _isLoading = false;
            setState(() {});
          });
        }
      }
      setState(() {
        dropdownValueTapeTestOne = value;
      });
    }
  }

  void onStateChanged(String? value) {
    // Close keyboard when dropdown is interacted with
    FocusManager.instance.primaryFocus?.unfocus();

    if (value != null) {
      for (int i = 0; i < countryStateCityController.stateList.length; i++) {
        if (countryStateCityController.stateList[i].name.toString().contains(value)) {
          SelectedSateId = countryStateCityController.stateList[i].id.toString();
          countryStateCityController.getCity(SelectedSateId);
          _isLoading = true;
          Timer(Duration(seconds: 4), () {
            _isLoading = false;
            setState(() {});
          });
        }
      }
      setState(() {
        dropdownValueTapeTesttwo = value;
      });
    }
  }

  void onCityChanged(String? value) {
    // Close keyboard when dropdown is interacted with
    FocusManager.instance.primaryFocus?.unfocus();

    if (value != null) {
      for (int i = 0; i < countryStateCityController.cityList.length; i++) {
        if (countryStateCityController.cityList[i].name.toString().contains(value)) {
          SelectedCityId = countryStateCityController.cityList[i].id.toString();
        }
      }
      setState(() {
        dropdownValueTapeTestthree = value;
      });
    }
  }

  // Custom Dropdown Widget
  Widget _buildCustomDropdown({
    required String? selectedItem,
    required List<String> items,
    required Function(String?) onChanged,
    String hintText = 'Select',
  }) {
    return Container(
      height: 55,
      child: DropdownSearch<String>(
        popupProps: PopupProps.menu(
          fit: FlexFit.loose,
          showSearchBox: true,
          menuProps: MenuProps(
            backgroundColor: Colors.white,
            elevation: 1,
          ),
          searchFieldProps: TextFieldProps(
            decoration: InputDecoration(
              hintText: 'Search...',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        selectedItem: selectedItem,
        items: items,
        onChanged: (value) {
          // Close keyboard before handling the change
          FocusManager.instance.primaryFocus?.unfocus();
          onChanged(value);
        },
        dropdownBuilder: (context, selectedItem) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              selectedItem ?? hintText,
              style: TextStyle(
                fontSize: 14,
                color: selectedItem == null ? Colors.grey : Colors.black,
              ),
            ),
          );
        },
      ),
    );
  }

  // Widget for required field labels with red asterisk
  Widget _buildRequiredFieldLabel(String text) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: text,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppTheme.dark_font_color,
            ),
          ),
          TextSpan(
            text: ' *',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    setValue(File result) {
      baseimage.clear();
      baseimage.add(result);
      setState(() {});
    }

    return OverlayLoaderWithAppIcon(
      isLoading: _isLoading,
      overlayBackgroundColor: Colors.black,
      circularProgressColor: Color(0xff7dca2e),
      appIcon: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset('assets/images/appicon.png'),
      ),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        behavior: HitTestBehavior.translucent,
        child: Scaffold(
          backgroundColor: AppTheme.back_color,
          appBar: AppBarBack(
            title: '',
          ),
          body: Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              shadows: [
                                BoxShadow(
                                  color: Color(0xFFC6C6C6),
                                  blurRadius: 4,
                                  offset: Offset(0, 0),
                                  spreadRadius: 0,
                                )
                              ],
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 5,
                                  top: 5,
                                  child: Container(
                                    width: 70,
                                    height: 70,
                                    decoration: ShapeDecoration(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: baseimage.isEmpty
                                          ? CachedNetworkImage(
                                        imageUrl: liveImage,
                                        placeholder: (context, url) => CircularProgressIndicator(),
                                        errorWidget: (context, url, error) => Image.asset("assets/images/appicon.png"),
                                        fit: BoxFit.cover,
                                      )
                                          : Image.file(baseimage[0], fit: BoxFit.cover),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 52,
                                  top: 52,
                                  child: GestureDetector(
                                    onTap: () async {
                                      File result = await showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return CustomDialogBox(
                                              title: "Select Action :",
                                              descriptions: "Hii all this is a custom dialog in flutter and  you will be use in your flutter applications",
                                              text: "Yes",
                                            );
                                          });
                                      setValue(result);
                                    },
                                    child: Container(
                                      width: 24,
                                      height: 24,
                                      clipBehavior: Clip.antiAlias,
                                      decoration: ShapeDecoration(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(24),
                                        ),
                                        shadows: [
                                          BoxShadow(
                                            color: Color(0xFFC6C6C6),
                                            blurRadius: 1,
                                            offset: Offset(0, 0),
                                            spreadRadius: 0,
                                          )
                                        ],
                                      ),
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            left: 8,
                                            top: 8,
                                            child: Container(
                                                width: 10,
                                                height: 10,
                                                child: SvgPicture.asset('assets/svg/icon _edit.svg')),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: _buildRequiredFieldLabel('First Name'),
                              ),
                              SizedBox(height: 10.0),
                              TextFormField(
                                enabled: editVisible,
                                controller: cntname,
                                focusNode: nameFocusNode,
                                inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[a-zA-Z -]"))],
                                textCapitalization: TextCapitalization.words,
                                keyboardType: TextInputType.name,
                                maxLength: 50,
                                style: new TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black),
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  counterText: "",
                                  hintText: 'Enter First Name',
                                  contentPadding: const EdgeInsets.symmetric(vertical: 17.0, horizontal: 10.0),
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
                                child: _buildRequiredFieldLabel('Last Name'),
                              ),
                              SizedBox(height: 10.0),
                              TextFormField(
                                enabled: editVisible,
                                controller: cntlastname,
                                focusNode: lastNameFocusNode,
                                inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[a-zA-Z -]"))],
                                textCapitalization: TextCapitalization.words,
                                keyboardType: TextInputType.name,
                                maxLength: 50,
                                style: new TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black),
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  counterText: "",
                                  hintText: 'Enter Last Name',
                                  contentPadding: const EdgeInsets.symmetric(vertical: 17.0, horizontal: 10.0),
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
                                focusNode: preferredNameFocusNode,
                                keyboardType: TextInputType.name,
                                textCapitalization: TextCapitalization.words,
                                maxLength: 20,
                                style: new TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black),
                                inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[a-zA-Z -]"))],
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  counterText: "",
                                  hintText: 'Enter Preferred Name',
                                  contentPadding: const EdgeInsets.symmetric(vertical: 17.0, horizontal: 10.0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20.0),
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: _buildRequiredFieldLabel('Email Address'),
                              ),
                              SizedBox(height: 10.0),
                              TextFormField(
                                controller: cntEmail,
                                enabled: false,
                                keyboardType: TextInputType.emailAddress,
                                style: new TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black),
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  hintText: 'Ex: abc@gmail.com',
                                  contentPadding: const EdgeInsets.symmetric(vertical: 17.0, horizontal: 10.0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter Email Address';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 20.0),

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15.0),
                                    child: _buildRequiredFieldLabel('Gender'),
                                  ),
                                  SizedBox(height: 10.0),
                                  Container(
                                    height: 55,
                                    child: InputDecorator(
                                      decoration: InputDecoration(
                                        fillColor: Colors.white,
                                        filled: true,
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(width: 1.5, color: Color(0xffdfe2e5)),
                                          borderRadius: BorderRadius.circular(15.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(width: 1.5, color: Color(0xff7dca2e)),
                                          borderRadius: BorderRadius.circular(15.0),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(width: 1.5, color: Color(0xfff44336)),
                                          borderRadius: BorderRadius.circular(15.0),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(width: 1.5, color: Color(0xfff44336)),
                                          borderRadius: BorderRadius.circular(15.0),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(right: 8.0),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                              isDense: true,
                                              value: GenderValue,
                                              iconEnabledColor: AppTheme.dark_font_secondary,
                                              dropdownColor: AppTheme.back_color,
                                              items: accountType
                                                  .map((data) => DropdownMenuItem<String>(
                                                  value: data,
                                                  child: Text(
                                                    data,
                                                    style: TextStyle(fontSize: 14, color: AppTheme.dark_font_secondary),
                                                  )))
                                                  .toList(),
                                              onChanged: (data) {
                                                FocusManager.instance.primaryFocus?.unfocus();
                                                setState(() {
                                                  GenderValue = data!;
                                                });
                                              }),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20.0),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15.0),
                                    child: _buildRequiredFieldLabel('Marital status'),
                                  ),
                                  SizedBox(height: 10.0),
                                  Container(
                                    height: 55,
                                    child: InputDecorator(
                                      decoration: InputDecoration(
                                        fillColor: Colors.white,
                                        filled: true,
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(width: 1.5, color: Color(0xffdfe2e5)),
                                          borderRadius: BorderRadius.circular(15.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(width: 1.5, color: Color(0xff7dca2e)),
                                          borderRadius: BorderRadius.circular(15.0),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(width: 1.5, color: Color(0xfff44336)),
                                          borderRadius: BorderRadius.circular(15.0),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(width: 1.5, color: Color(0xfff44336)),
                                          borderRadius: BorderRadius.circular(15.0),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(right: 8.0),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                              isDense: true,
                                              value: MaritalValue,
                                              iconEnabledColor: AppTheme.dark_font_secondary,
                                              dropdownColor: AppTheme.back_color,
                                              items: StatusType.map((data) => DropdownMenuItem<String>(
                                                  value: data,
                                                  child: Text(
                                                    data,
                                                    style: TextStyle(fontSize: 14, color: AppTheme.dark_font_secondary),
                                                  ))).toList(),
                                              onChanged: (data) {
                                                FocusManager.instance.primaryFocus?.unfocus();
                                                setState(() {
                                                  MaritalValue = data!;
                                                });
                                              }),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20.0),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15.0),
                                    child: _buildRequiredFieldLabel('Date Of Birth'),
                                  ),
                                  SizedBox(height: 10.0),
                                  TextFormField(
                                    enabled: editVisible,
                                    controller: DOBcontroller,
                                    onTap: () async {
                                      FocusScope.of(context).requestFocus(new FocusNode());
                                      await _selectDate(context);
                                      final String formatted = formatter.format(date);
                                      DOBcontroller.text = formatted;
                                      setState(() {});
                                    },
                                    keyboardType: TextInputType.datetime,
                                    style: new TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black),
                                    decoration: InputDecoration(
                                      fillColor: Colors.white,
                                      filled: true,
                                      hintText: '12-02-2023',
                                      contentPadding: const EdgeInsets.symmetric(vertical: 17.0, horizontal: 10.0),
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
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: _buildRequiredFieldLabel('Phone number'),
                              ),
                              SizedBox(height: 10.0),
                              TextFormField(
                                controller: cntPhone,
                                enabled: editVisible,
                                focusNode: phoneFocusNode,
                                maxLength: 8,
                                keyboardType: TextInputType.phone,
                                style: new TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black),
                                decoration: InputDecoration(
                                  counterText: "",
                                  fillColor: Colors.white,
                                  filled: true,
                                  hintText: 'Ex: 98765432',
                                  contentPadding: const EdgeInsets.symmetric(vertical: 17.0, horizontal: 10.0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                ),
                                validator: (value) {
                                  if (RegExp(r'^5\d{7}$').hasMatch(value!) == false) {
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
                                focusNode: street1FocusNode,
                                keyboardType: TextInputType.text,
                                style: new TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black),
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  hintText: 'Enter Street 1',
                                  contentPadding: const EdgeInsets.symmetric(vertical: 17.0, horizontal: 10.0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                ),
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
                                focusNode: street2FocusNode,
                                keyboardType: TextInputType.text,
                                style: new TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black),
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  hintText: 'Enter Street 2',
                                  contentPadding: const EdgeInsets.symmetric(vertical: 17.0, horizontal: 10.0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20.0),
                              Column(
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
                                  _buildCustomDropdown(
                                    selectedItem: dropdownValueTapeTestOne,
                                    items: countryStateCityController.listCountry,
                                    onChanged: onCountryChanged,
                                    hintText: 'Select Country',
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
                                  _buildCustomDropdown(
                                    selectedItem: dropdownValueTapeTesttwo,
                                    items: countryStateCityController.listState,
                                    onChanged: onStateChanged,
                                    hintText: 'Select State',
                                  ),
                                  SizedBox(height: 20.0),
                                ],
                              ),
                              Row(
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
                                          _buildCustomDropdown(
                                            selectedItem: dropdownValueTapeTestthree,
                                            items: countryStateCityController.listCity,
                                            onChanged: onCityChanged,
                                            hintText: 'Select Region',
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
                                            focusNode: zipCodeFocusNode,
                                            maxLength: 6,
                                            keyboardType: TextInputType.number,
                                            style: new TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey),
                                            decoration: InputDecoration(
                                              fillColor: Colors.white,
                                              filled: true,
                                              hintText: '123456',
                                              counterText: "",
                                              contentPadding: const EdgeInsets.symmetric(vertical: 17.0, horizontal: 10.0),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(4.0),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )),
                                ],
                              ),
                              SizedBox(height: 20.0),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Fixed Bottom Button
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(14.0),
                  decoration: BoxDecoration(
                    color: AppTheme.back_color,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  child: GestureDetector(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        if (SelectedCountryId.isNotEmpty) {
                          if (SelectedSateId.isNotEmpty) {
                            if (SelectedCityId.isNotEmpty) {
                              _isLoading = true;
                              updateUser();
                              setState(() {});
                            } else {
                              Get.snackbar("Please Select Region", "",
                                  snackPosition: SnackPosition.TOP,
                                  backgroundColor: AppTheme.apptheme_color.withOpacity(0.50),
                                  colorText: AppTheme.back_color,
                                  borderColor: AppTheme.apptheme_color,
                                  borderWidth: 1,
                                  margin: EdgeInsets.only(bottom: 20, left: 10.0, right: 10.0));
                            }
                          } else {
                            Get.snackbar("Please Select State", "",
                                snackPosition: SnackPosition.TOP,
                                backgroundColor: AppTheme.apptheme_color.withOpacity(0.50),
                                colorText: AppTheme.back_color,
                                borderColor: AppTheme.apptheme_color,
                                borderWidth: 1,
                                margin: EdgeInsets.only(bottom: 20, left: 10.0, right: 10.0));
                          }
                        } else {
                          Get.snackbar("Please Select Country", "",
                              snackPosition: SnackPosition.TOP,
                              backgroundColor: AppTheme.apptheme_color.withOpacity(0.50),
                              colorText: AppTheme.back_color,
                              borderColor: AppTheme.apptheme_color,
                              borderWidth: 1,
                              margin: EdgeInsets.only(bottom: 20, left: 10.0, right: 10.0));
                        }
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
                            'Update Profile',
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
              hintColor: Colors.black,
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
      });
    }
  }

  updateUser() async {
    var request = http.MultipartRequest('POST', Uri.parse(ApiEndPoints.customerProfile));
    request.fields.addAll({
      'first_name': cntname.text,
      'last_name': cntlastname.text,
      'prefered_name': cntpefname.text,
      'email': cntEmail.text,
      'phone_number': cntPhone.text,
      'address_line1': cntstreet1.text,
      'address_line2': cntstreet2.text,
      'country': SelectedCountryId,
      'state': SelectedSateId,
      'city': SelectedCityId,
      'postal_code': cntzipcode.text,
      'customer_id': widget.userId,
      'date_of_birth': DOBcontroller.text,
      'gender': GenderValue,
      'marital_status': MaritalValue,
    });
    if (baseimage.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath('profile_picture', baseimage[0].path));
    }
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      _isLoading = false;
      setState(() {});
      Get.snackbar("success", "Profile Updated Successfully",
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppTheme.apptheme_color.withOpacity(0.10),
          colorText: AppTheme.apptheme_color,
          borderColor: AppTheme.apptheme_color,
          borderWidth: 1,
          margin: EdgeInsets.only(bottom: 20, left: 10.0, right: 10.0));
      Navigator.pop(context);
    } else {
      _isLoading = false;
      setState(() {});
      Get.snackbar("Sorry...!", "Profile Not Updated",
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppTheme.apptheme_color.withOpacity(0.10),
          colorText: AppTheme.apptheme_color,
          borderColor: AppTheme.apptheme_color,
          borderWidth: 1,
          margin: EdgeInsets.only(bottom: 20, left: 10.0, right: 10.0));
    }
  }

  Future<void> GetUserProfile() async {
    print('userId==>' + widget.userId);

    String body = json.encode({
      'customer_id': widget.userId
    });

    final response = await http.post(
      Uri.parse(ApiEndPoints.getProfile),
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    Map<String, dynamic> data = jsonDecode(response.body);
    if (data['status'] == "success") {
      _isLoading = false;
      cntEmail.text = data['data']['email'].toString() ?? "";

      if (data['data']['gender'] != null) {
        cntname.text = data['data']['first_name'].toString();
        cntlastname.text = data['data']['last_name'].toString();
        cntpefname.text = data['data']['prefered_name'] ?? "";
        DOBcontroller.text = data['data']['date_of_birth'].toString();
        cntPhone.text = data['data']['phone_number'].toString();
        cntstreet1.text = data['data']['address_line1'] ?? "";
        cntstreet2.text = data['data']['address_line2'] ?? "";
        cntzipcode.text = data['data']['postal_code'] ?? "";
        GenderValue = data['data']['gender'].toString();
        MaritalValue = data['data']['marital_status'].toString();
        dropdownValueTapeTestOne = data['data']['country'].toString();
        dropdownValueTapeTesttwo = data['data']['state'].toString();
        dropdownValueTapeTestthree = data['data']['city'].toString();
        SelectedCountryId = data['data']['country_id'].toString();
        SelectedSateId = data['data']['state_id'].toString();
        SelectedCityId = data['data']['city_id'].toString();
      }
      liveImage = ApiEndPoints.imagePath + "" + data['data']['profile_picture'] ?? "";
      setState(() {});
    } else {
      print('error');
    }
  }
}