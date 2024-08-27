import 'package:location/location.dart';

get_location() async {
  Location location = new Location();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;
  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    print('Request For Service');
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      print('Service Enable');
      return false;
    } else {
      print('Service Not Enable');
    }
  }

  _permissionGranted = await location.hasPermission();
  print('Permission Granted $_permissionGranted');

  if (_permissionGranted == PermissionStatus.deniedForever) {
    return Future.value(false);
  } else if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      // print('Location Block');
      return Future.value(false);
    }
  } else {
    // print('Location Granted');
    _locationData = await location.getLocation();

    // print(_locationData);
    return Future.value(
        {"lat": _locationData.latitude, "long": _locationData.longitude});
  }
}

get_permission() async {
  Location location = Location();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  _serviceEnabled = await location.serviceEnabled();
  // print('Service Enabled $_serviceEnabled');
  if (!_serviceEnabled) {
    print('Request For Service');
    _serviceEnabled = await location.requestService();
    print('Service Enabled $_serviceEnabled');
    if (!_serviceEnabled) {
      print('Service Enable');
      return;
    } else {
      print('Service Not Enable');
    }
  }
  _permissionGranted = await location.requestPermission();
  print('Permission yoo $_permissionGranted');
}
