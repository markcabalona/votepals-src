import 'package:flutter/cupertino.dart';

abstract class CustomPaddings {
  static const small = 8.0;
  static const medium = 12.0;
  static const large = 16.0;
}

abstract class HorizontalSpacers {
  static const small = SizedBox(width: CustomPaddings.small);
  static const medium = SizedBox(width: CustomPaddings.medium);
  static const large = SizedBox(width: CustomPaddings.large);
}

abstract class VerticalSpacers {
  static const small = SizedBox(height: CustomPaddings.small);
  static const medium = SizedBox(height: CustomPaddings.medium);
  static const large = SizedBox(height: CustomPaddings.large);
  static const xLarge = SizedBox(height: CustomPaddings.large * 2);
  static const xxLarge = SizedBox(height: CustomPaddings.large * 3);
  static const xxxLarge = SizedBox(height: CustomPaddings.large * 4);
}
