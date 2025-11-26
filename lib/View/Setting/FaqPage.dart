import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:kirpix/Controller/FaqController.dart';

import '../../AppBarWithBack.dart';
import '../../Utils/Constant/AppTheme.dart';
import '../../Widgets/Shadow.dart';

class FAQPage extends StatefulWidget {


  @override
  State<FAQPage> createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {

  FaqController faqController = Get.put(FaqController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.back_color,
      appBar: AppBarBack(title: '',),
      body: SingleChildScrollView(
        child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                'FAQ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppTheme.dark_font_secondary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 14.0, right: 14.0, bottom: 10),
              child: Obx(() {
                if (faqController.isLoading.value)
                  return Center(child: CircularProgressIndicator());
                else {
                  return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: faqController.faqList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 14.0),
                          child: Container(
                            width: Get.width,
                            decoration: CustomDecorations()
                                .BackgroundDecorationwithRadiusTen(),
                            child:ExpansionTile(
                              title:  Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Row(
                                  children: [
                                    SvgPicture.asset('assets/svg/dot_symbol.svg'),
                                    SizedBox(width: 8.0,),
                                    Text(
                                      faqController.faqList[index].faqTitle,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight:
                                          FontWeight.w700,
                                          color: AppTheme
                                              .dark_font_color),
                                    ),
                                  ],
                                ),
                              ),
                              children: <Widget>[
                                Divider(
                                  height: 0.8,
                                  thickness: 0.9,
                                  indent: 1,
                                  color: AppTheme.grayText,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top:8.0,bottom:8.0,left: 14.0,right: 14.0),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Container(
                                      child: HtmlWidget(
                                        faqController.faqList[index].faqDescription,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ) /*Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    _toggleCategory(index);

                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(14.0),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset('assets/svg/dot_symbol.svg'),
                                        SizedBox(width: 8.0,),
                                        Text(
                                          faqController.faqList[index].faqTitle,
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight:
                                              FontWeight.w700,
                                              color: AppTheme
                                                  .dark_font_color),
                                        ),
                                        Spacer(),
                                        Image.asset(
                                          "assets/images/icon _arrow down.png",
                                          height: 14,
                                          width: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                if (_selectedCategoryIndex == index)...[
                                  Divider(
                                    height: 0.8,
                                    thickness: 0.9,
                                    indent: 1,
                                    color: AppTheme.grayText,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 14.0,right: 14.0,bottom: 14.0,top: 5),
                                    child: HtmlWidget(
                                      faqController.faqList[index].faqDescription,

                                    ),
                                  ),
                                ]
                              ],
                            ),*/
                          ),
                        );
                      });
                }
              }),
            ),
          ],
        )
      ),
    );
  }
}
