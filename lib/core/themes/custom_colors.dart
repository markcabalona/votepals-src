import 'package:flutter/animation.dart';

abstract class CustomColors {
  static const primary = CustomColor(0xffd76754);
  static const secondary = CustomColor(0xff6981a6);

  static const dark = CustomColor(0xff000000);

  static const gray = CustomColor(0xffa6a6a6);
  static const lightGray = CustomColor(0xfff2f2f2);

  static const white = CustomColor(0xffffffff);
}

class CustomColor extends Color {
  const CustomColor(super.value);
}
