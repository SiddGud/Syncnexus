import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:worker_app/models/lat_long_model.dart';
part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit() : super(LocationLoading()) {
    checkForPermission();
    isLocationEnabled();
    listenForLocationChanges();
  }

  bool permissionGranted = false;

  void isLocationEnabled() async {
    final isLocationOn =
        await Permission.locationWhenInUse.serviceStatus.isEnabled;

    if (isLocationOn) {
      emit(LocationOn(locationGranted: permissionGranted));
    } else {
      emit(LocationDisabled(locationGranted: permissionGranted));
    }
  }

  Future<LatLong> getLocation() async {
    try {
      Position tempPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      double lat = tempPosition.latitude;
      double long = tempPosition.longitude;
      return LatLong(lat: lat, long: long);
    } catch (e) {
      emit(LocationDisabled(locationGranted: permissionGranted));
      return LatLong(lat: 15.5937, long: 80.9629);
    }
  }

  void requestPermission() async {
    if (await Permission.location.isPermanentlyDenied) {
      openAppSettings();
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    }

    Permission.locationWhenInUse.request().then((permissionStatus) {
      if (permissionStatus == PermissionStatus.denied ||
          permissionStatus == PermissionStatus.permanentlyDenied) {
        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      } else if (permissionStatus == PermissionStatus.granted ||
          permissionStatus == PermissionStatus.limited) {
        permissionGranted = true;
      }
    });
  }

  void listenForLocationChanges() {
    Future.delayed(const Duration(seconds: 5)).then((_) {
      isLocationEnabled();
      listenForLocationChanges();
    });
  }

  Future<void> checkForPermission() async {
    if (await Permission.location.isGranted) {
      emit(LocationPermissionGranted());
      permissionGranted = true;
      return;
    }

    // requestPermission();

    // if (await Permission.location.isDenied) {
    //   Permission.locationWhenInUse.request().then(
    //     (value) {
    //       emit(LocationPermissionDenied());
    //       if (value == PermissionStatus.denied) {
    //         openAppSettings();
    //         SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    //       }
    //     },
    //   );
    // }

    // if (await Permission.location.isPermanentlyDenied) {
    //   Permission.locationWhenInUse.request().then(
    //     (value) {
    //       if (value == PermissionStatus.denied) {
    //         emit(LocationPermissionDenied());
    //         openAppSettings();
    //         SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    //       }
    //     },
    //   );
    // }
  }
}
