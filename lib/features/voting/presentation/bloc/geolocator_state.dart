// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'geolocator_bloc.dart';

abstract class GeolocatorState extends Equatable {
  const GeolocatorState();

  @override
  List<Object> get props => [];
}

class GeolocatorBlocInitial extends GeolocatorState {}

class LoadingLocation extends GeolocatorState {}

class LocationError extends GeolocatorState {
  final String message;
  const LocationError({
    required this.message,
  });
  @override
  List<Object> get props => super.props..add(message);
}

class LocationLoaded extends GeolocatorState {
  final CurrentLocationParams currentLocation;
  const LocationLoaded({
    required this.currentLocation,
  });

  @override
  List<Object> get props => super.props..add(currentLocation);

  @override
  String toString() => 'LocationLoaded(currentLocation: $currentLocation)';
}
