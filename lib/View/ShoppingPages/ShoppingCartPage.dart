import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../AppBarWithBack.dart';
import '../../Utils/Constant/AppTheme.dart';

class ShoppingCartPage extends StatefulWidget {
  const ShoppingCartPage({Key? key}) : super(key: key);

  @override
  State<ShoppingCartPage> createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.back_color,
        appBar: AppBarBack(title: '',),
        body:Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset("assets/svg/pngwing.svg"),
              Text('Your shopping list is Empty! ',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: AppTheme.dark_font_color,
                    fontSize: 20,
                    fontWeight: FontWeight.w700),),
              Text('comparing wide range of products, we have best suitable deal for you. ',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: AppTheme.dark_font_secondary,
                    fontSize: 16,
                    fontWeight: FontWeight.w400),),
              SizedBox(height: 20,),
              Text(' * or Continue Shopping',
                style: TextStyle(
                    color: AppTheme.apptheme_color,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),),
            ],
          ),
        ),
    );
  }
}
