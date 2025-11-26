import 'package:flutter/material.dart';

import 'Utils/Constant/AppTheme.dart';

class AppBarBack extends StatelessWidget  implements PreferredSizeWidget {

  final String? title;

  AppBarBack({ Key? key, required this.title, }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(50);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Image(
          image: AssetImage("assets/images/logo.png"),
          height: 60,
          width: 120,
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.black,),

          color: AppTheme.light_font_color,
          onPressed: () { Navigator.pop(context); },
        ),

      ),
    );
  }
}
