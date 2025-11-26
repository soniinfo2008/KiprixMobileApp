import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';



class CustomDialogBox extends StatefulWidget {
  final String? title, descriptions, text;
  final Image? img;


  const CustomDialogBox({Key? key, this.title, this.descriptions, this.text, this.img}) : super(key: key);

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
  static  double horizontal_padding = 12.0;
  static  double vertical_padding = 12.0;

  static  double padding =20;
  static  double avatarRadius =45;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }


  contentBox(context){
    return Stack(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(left: padding,top: avatarRadius + padding, right: padding,bottom: padding),
          margin: EdgeInsets.only(top: avatarRadius),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(padding),
              boxShadow: [
                BoxShadow(color: Colors.black,offset: Offset(0,10),
                    blurRadius: 10
                ),
              ]
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(widget.title!,style: TextStyle(fontSize: 22,fontWeight: FontWeight.w600),),
              SizedBox(height: 15,),
              TextButton(
                  onPressed: () async {

                    final ImagePicker _picker = ImagePicker();
                    final img = await _picker.pickImage(source: ImageSource.gallery,imageQuality: 40);

                    File imagefile = File(img!.path); //convert Path to File
                    /* File imageFile = new File(img!.path);
                    // List<int> imageBytes = imageFile.readAsBytesSync();
                    Uint8List imagebytes = await  imageFile.readAsBytesSync();

                    String base64Image = base64Encode(imagebytes);*/
                    Navigator.of(context).pop(imagefile);
                  },
                  child: Text("Select Image From Gallery",style: TextStyle(fontSize: 18),)),
              TextButton(
                  onPressed: () async {

                    final ImagePicker _picker = ImagePicker();
                    final img = await _picker.pickImage(source: ImageSource.camera,imageQuality: 40,);
                    File imagefile = File(img!.path); //convert Path to File
                    // Uint8List imagebytes = await imagefile.readAsBytes();
                    // final bytes = await imagefile.readAsBytes();
                    Navigator.of(context).pop(imagefile);

                  },
                  child: Text("Capture Image From Camera",style: TextStyle(fontSize: 18),)),
              // Text(widget.descriptions!,style: TextStyle(fontSize: 14),textAlign: TextAlign.center,),
              SizedBox(height: 22,),

              /*Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                    child: Text(widget.text!,style: TextStyle(fontSize: 18),)),
              ),*/

            ],
          ),
        ),
        Positioned(
          left: padding,
          right: padding,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: avatarRadius,
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(avatarRadius)),
                child: Image.asset("assets/images/appicon.png")
            ),
          ),
        ),

      ],
    );
  }
}