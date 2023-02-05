// ignore_for_file: public_member_api_docs, sort_constructors_first
class CurrentLocationParams {
  final String longitude;
  final String latitude;
  CurrentLocationParams({
    required this.longitude,
    required this.latitude,
  });

  @override
  String toString() =>
      'CurrentLocationParams(longitude: $longitude, latitude: $latitude)';
}
