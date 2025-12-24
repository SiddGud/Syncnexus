part of "location_cubit.dart";

abstract class LocationState {}

final class LocationLoading extends LocationState {}

final class LocationPermissionDenied extends LocationState {}

final class LocationPermissionGranted extends LocationState {}

final class LocationOn extends LocationState {
  LocationOn({required this.locationGranted});
  bool locationGranted;
}

final class LocationDisabled extends LocationState {
  LocationDisabled({required this.locationGranted});
  bool locationGranted;
}
