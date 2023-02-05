@JS('window')
library launch_url;

import 'package:js/js.dart';

// @JS('getCurrentPosition') //Geolocation API's getCurrentPosition
// external void getCurrentPosition(
//     Function Function(Geoposition pos) success);
@JS('open') //Geolocation API's getCurrentPosition
// ignore: use_function_type_syntax_for_parameters
external void customLaunchUrl(String url);
