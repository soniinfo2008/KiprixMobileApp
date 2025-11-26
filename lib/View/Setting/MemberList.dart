import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:kirpix/View/Setting/AddMember.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../AppBarWithBack.dart';
import '../../Controller/MemberController.dart';
import '../../Utils/Constant/AppTheme.dart';
import '../../Utils/Constant/Const.dart';
import '../../Widgets/Shadow.dart';

class MemberList extends StatefulWidget {
  final String userId;
  MemberList(String this.userId);

  @override
  State<MemberList> createState() => _MemberListState();
}

class _MemberListState extends State<MemberList> {
  MemberController _memberController=Get.put(MemberController());
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _memberController.getData(widget.userId);
    setState(() {

    });

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
      child: Scaffold(
        backgroundColor: AppTheme.back_color,
        appBar: AppBarBack(title: '',),
        body:_memberController.nodata==false?
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              children: [
                SizedBox(height: 10,),
                Container(
                    width: Get.width,
                    decoration: CustomDecorations().BackgroundDecorationwithRadiusTen(),
                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Text(
                            'Member List',
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.dark_font_color
                            ),
                          ),
                        ),
                        Divider(
                          height: 0.8,
                          thickness: 0.9,
                          indent: 1,
                          color: AppTheme.grayText,
                        ),
                        Obx(() {
                          if (_memberController.isLoading.value)
                            return Center(child: CircularProgressIndicator());
                          else {
                            return ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: _memberController.mmList.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [

                                      Padding(
                                        padding: const EdgeInsets.only(left: 18.0,right: 10,top: 8.0,bottom: 8.0),
                                        child: Row(
                                          children: [
                                            SvgPicture.asset('assets/svg/dot_symbol.svg'),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 10.0),
                                                  child: Text(
                                                    _memberController.mmList[index].first_name+" "+_memberController.mmList[index].last_name,
                                                    style: TextStyle(
                                                        color: AppTheme.dark_font_color,
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w600),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 10.0),
                                                  child: Text(
                                                    _memberController.mmList[index].phoneNumber,
                                                    style: TextStyle(
                                                        color: AppTheme.dark_font_secondary,
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.w500),
                                                  ),
                                                ),

                                              ],
                                            ),
                                            Spacer(),

                                            Row(
                                              children: [
                                                GestureDetector(
                                                    onTap: () {
                                                      Get.to(AddMember("edit",widget.userId,_memberController.mmList[index].email,_memberController.mmList[index].first_name,_memberController.mmList[index].last_name,_memberController.mmList[index].preferedName,_memberController.mmList[index].phoneNumber,_memberController.mmList[index].addressLine1,_memberController.mmList[index].addressLine2,_memberController.mmList[index].memberId.toString()));
                                                    },
                                                    child: SvgPicture.asset(
                                                        'assets/svg/closecircle_edit.svg')),
                                                GestureDetector(
                                                    onTap: () {
                                                      _isLoading=true;
                                                      setState(() {

                                                      });
                                                      _memberController.deleteMember(widget.userId,_memberController.mmList[index].memberId);
                                                      Timer(Duration(seconds: 5), () {
                                                        _isLoading=false;
                                                        setState(() {

                                                        });
                                                      });
                                                      // showDialog(
                                                      //     context: context,
                                                      //     barrierDismissible: false,
                                                      //     builder: (BuildContext context) {
                                                      //       return DeleteDialog(widget.userId,_memberController.mmList[index].fullName,_memberController.mmList[index].memberId);
                                                      //     });
                                                    },
                                                    child: SvgPicture.asset(
                                                        'assets/svg/closecircle_delete.svg')),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (index != _memberController.mmList.length - 1) ...[
                                        Divider(
                                          height: 0.8,
                                          thickness: 0.9,
                                          indent: 1,
                                          color: AppTheme.grayText,
                                        ),
                                      ] else ...[
                                        Container()
                                      ],
                                    ],
                                  );
                                });
                          }
                        }),






                      ],
                    )
                ),
                SizedBox(height: 20,),

              ],
            ),
          )
        ):
        Center(
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/svg/nodata_found.gif",
                height: 150,
                width: 150,
              ),
              SizedBox(height: 30,),
              Text(
                'Ooops!',
                style: TextStyle(
                  fontSize: 20,
                  color: AppTheme.dark_font_secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Unfortunately the service you are selecting is\nindomitable for your region, you can not find it.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.dark_font_secondary,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar:  GestureDetector(
          onTap: (){
            Get.to(AddMember("add",widget.userId,"","","","","","","",""));
          },
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Container(
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 0.50, color: Color(0xFF7DCA2E)),
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
                        'Add Member',
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
        ),
      ),
    );
  }
}

class DeleteDialog extends StatelessWidget {
  MemberController _memberController = Get.put(MemberController());
  final String userId,fullName;
  final int memberId;
  DeleteDialog(String this.userId, String this.fullName, int this.memberId);

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
              "Delete Member",
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Divider(height: 0.8,thickness: 0.9,indent: 1,color: AppTheme.grayText,),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Are you sure you want to delete,\n$fullName from your member list.",
              style: TextStyle(
                  fontSize:14.0,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.dark_font_color
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 17.0,right: 17.0,bottom: 17.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 0.50, color: Color(0xFFDFE2E5)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Cancel',
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
                SizedBox(width: 15,),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: (){
                        _memberController.deleteMember(userId,memberId);
                         Navigator.pop(context);

                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      clipBehavior: Clip.antiAlias,
                      decoration: ShapeDecoration(
                        color: Colors.red,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(width: 0.50, color: Color(0xFFDFE2E5)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Delete',
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
}


