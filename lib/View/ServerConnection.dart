import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../Utils/Constant/AppTheme.dart';

class ServerConnection extends StatefulWidget {
  const ServerConnection({Key? key}) : super(key: key);

  @override
  State<ServerConnection> createState() => _ServerConnectionState();
}

class _ServerConnectionState extends State<ServerConnection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.back_color,
      body:Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/Cloud-Server.png"),
            Text('Connecting to the Server',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: AppTheme.dark_font_color,
                  fontSize: 20,
                  fontWeight: FontWeight.w700),),
            Text('the currently service not available',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: AppTheme.dark_font_secondary,
                  fontSize: 16,
                  fontWeight: FontWeight.w400),),
            SizedBox(height: 20,),

          ],
        ),
      ),
    );
  }
}
