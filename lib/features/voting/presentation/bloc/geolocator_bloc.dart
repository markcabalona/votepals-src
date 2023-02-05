// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:js/js.dart';
import 'package:votepals/core/utils/location.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:votepals/features/voting/domain/params/current_location_params.dart';

part 'geolocator_event.dart';
part 'geolocator_state.dart';

class GeolocatorBloc extends Bloc<GeolocatorEvent, GeolocatorState> {
  GeolocatorBloc() : super(GeolocatorBlocInitial()) {
    on<FetchCurrentLocation>((event, emit) async {
      emit(LoadingLocation());

      getCurrentPosition(
        allowInterop((pos) {
          if (pos.coords == null) {
            _updateState(
              const LocationError(
                message: 'Permission to access location is denied',
              ),
            );
            return null;
          }
          if (pos.coords!.latitude == null && pos.coords!.longitude == null) {
            _updateState(
              const LocationError(
                message: 'Permission to access location is denied',
              ),
            );
            return null;
          }
          _updateState(
            LocationLoaded(
              currentLocation: CurrentLocationParams(
                longitude: pos.coords!.longitude?.toString() ?? '',
                latitude: pos.coords!.latitude?.toString() ?? '',
              ),
            ),
          );
        }),
        allowInterop((error) {
          _updateState(
            const LocationError(
              message: 'Permission to access location is denied',
            ),
          );
        }),
      );
    });
  }

  // somehow calling emit inside the getCurrentPosition throws an error
  _updateState(GeolocatorState state){
    // ignore: invalid_use_of_visible_for_testing_member
    emit(state);
  }
}
