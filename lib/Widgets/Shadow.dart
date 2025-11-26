
import 'package:flutter/material.dart';

class CustomDecorations {
  //0 radius
  ShapeDecoration baseBackgroundDecoration() {
    return ShapeDecoration(
      color: Colors.white,
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
    );
  }

  //15 radius
  ShapeDecoration BackgroundDecorationwithRedius() {
    return ShapeDecoration(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      shadows: [
        BoxShadow(
          color: Color(0xFFC6C6C6).withOpacity(0.75),
          blurRadius: 4,
          offset: Offset(0, 0),
          spreadRadius: 0,
        )
      ],
    );
  }

  //five  radius
  ShapeDecoration BackgroundDecorationwithRadiusFive() {
    return ShapeDecoration(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      shadows: [
        BoxShadow(
          color: Color(0xFFC6C6C6).withOpacity(0.65),
          blurRadius: 4,
          offset: Offset(0, 0),
          spreadRadius: 0,
        )
      ],
    );
  }
  //ten radius
  ShapeDecoration BackgroundDecorationwithRadiusTen() {
    return ShapeDecoration(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      shadows: [
        BoxShadow(
          color: Color(0xFFC6C6C6).withOpacity(0.75),
          blurRadius: 4,
          offset: Offset(0, 0),
          spreadRadius: 0,
        )
      ],
    );
  }

  //ten radius Gradient
  ShapeDecoration buttonwithRadiusTen(double radius) {
    return ShapeDecoration(
      gradient: LinearGradient(
        begin: Alignment(0.00, -1.00),
        end: Alignment(0, 1),
        colors: [Color(0xFF9BC838), Color(0xFF4F9D01)],
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
      shadows: [
        BoxShadow(
          color: Color(0x19C94210),
          blurRadius: 30,
          offset: Offset(0, 10),
          spreadRadius: 0,
        )
      ],
    );
  }
}
