@JS('navigator.geolocation')
library jslocation;


import 'dart:html';

import 'package:js/js.dart';

// @JS()
// @anonymous
// class GeolocationPosition {
//   external factory GeolocationPosition({GeolocationCoordinates coords});
//   external GeolocationCoordinates get coords;
// }

@JS()
@anonymous
class GeolocationCoordinates {
  external factory GeolocationCoordinates({
    double latitude,
    double longitude,
  });
  external double get latitude;
  external double get longitude;
}

// @JS('getCurrentPosition') //Geolocation API's getCurrentPosition
// external void getCurrentPosition(
//     Function Function(Geoposition pos) success);
@JS('getCurrentPosition') //Geolocation API's getCurrentPosition
// ignore: use_function_type_syntax_for_parameters
external void getCurrentPosition(success(Geoposition pos), error(error));
