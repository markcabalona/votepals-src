part of 'geolocator_bloc.dart';

abstract class GeolocatorEvent extends Equatable {
  const GeolocatorEvent();

  @override
  List<Object> get props => [];
}


class FetchCurrentLocation extends GeolocatorEvent{

}