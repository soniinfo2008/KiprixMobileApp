import 'package:flutter/material.dart';


class AppTheme{


  static final Color apptheme_color = const Color(0xff7dca2e);
  static final Color dark_font_color = const Color(0xff4e5157);
  static final Color dark_font_secondary = const Color(0xff818181);
  static final Color light_font_color = const Color(0xffffffff);
  static final Color back_color = const Color(0xfff8fbff);
  static final Color broder_color = const Color(0xffdfe2e5);
  static final Color grayText = const Color(0xffd0d0d0);
  static final Color danger_ = const Color(0xffff2221);
  static final Color dark_font_color2 = const Color(0xff818181);
  static final Color icon_color = const Color(0xffdfe2e5);




  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

}