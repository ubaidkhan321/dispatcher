import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import '../../helpers/api.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class ShopsLocations extends StatefulWidget {
  //THIS IS ROUTE ID
  final String id;
  const ShopsLocations({Key? key, required this.id}) : super(key: key);

  @override
  _ShopsLocationsState createState() => _ShopsLocationsState();
}

class _ShopsLocationsState extends State<ShopsLocations> {
  List _customer = [];

  final Completer _controller = Completer();
  List location = [];
  double init_lat = 24.914762;
  double init_long = 67.032053;

  LatLng _currentLocation = LatLng(0, 0);

  bool _saving = false;
  CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(24.867315, 67.0815446),
    zoom: 10.09,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(24.866759, 67.084284),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  List<Marker> _marker = [];

  List<Marker> _list = [];

  Future<void> _fetchCustomer(text) async {
    setState(() {
      _saving = true;
    });
    String routes_id_ = await widget.id;
    var res = await api.get_customers(
        '', '', text, routes_id_.toString(), '', '', '');
    if (res['code_status'] == true) {
      setState(() {
        _saving = false;
      });
      _customer = res['customers'];
      print('_customer:${_customer}');

      for (var i = 0; i < _customer.length; i++) {
        if (_customer[i]['name'] != 'test') {
          double _lat = double.parse(_customer[i]['latitude'].toString());
          double _long = double.parse(_customer[i]['longitude'].toString());
          // setState(
          //   () {

          //     // location = res['customers'];
          //   },
          // );

          _list.add(Marker(
            markerId: MarkerId('${_customer[i]}'),
            position: LatLng(_lat, _long),
            infoWindow: InfoWindow(
              title: '${_customer[i]['name']}',
              snippet: '${_customer[i]['name']} Shop',
              anchor: Offset(0.5, 1.0),
              onTap: () => setState(() {
                lat = _lat;
                long = _long;
                print('waqas:$lat');
                print('waqas:${_customer[i]['name']}');
              }),
            ),
          ));
          print(_list);
          setState(() {
            _marker.addAll(_list);
          });
        }
      }
    }
    // print(location);
  }

  getPoliline() async {
    print('loc_lat:${_currentLocation.latitude}');
    print('loc_long:${_currentLocation.longitude}');
    // PolylineResult result = await polyLinePoints.getRouteBetweenCoordinates(
    //   "AIzaSyAxoTbY8_b8Pbmy9Q3woI2gs624zrN22g0",
    //   // PointLatLng(_currentLocation.latitude, _currentLocation.longitude),
    //   PointLatLng(24.915534, 67.032397),
    //   PointLatLng(24.915034, 67.032697),
    //   travelMode: TravelMode.transit,
    // );
    double lat = double.parse(_currentLocation.latitude.toStringAsFixed(6));
    double long = double.parse(_currentLocation.longitude.toStringAsFixed(6));
    PolylineResult result = await polyLinePoints.getRouteBetweenCoordinates(
      "AIzaSyAxoTbY8_b8Pbmy9Q3woI2gs624zrN22g0",
      PointLatLng(lat, long),
      PointLatLng(24.9150346, 67.0326974),
      travelMode: TravelMode.transit,
    );
    print('result:${result.status}');
    setState(() {
      result.points.forEach((PointLatLng points) {
        polylineCoordinates.add(LatLng(points.latitude, points.longitude));
      });
    });
    // if (result.points.isNotEmpty) {
    //   setState(() {
    //     result.points.forEach((PointLatLng points) {
    //       print('points:$points');
    //       polylineCoordinates.add(LatLng(points.latitude, points.longitude));
    //     });
    //   });
    //   print(polylineCoordinates);
    //   print("polyline end");
    //   setState(() {});
    // } else {
    //   print("empty");
    // }
  }

  @override
  void initState() {
    super.initState();

    _fetchCustomer('');
    DefaultAssetBundle.of(context)
        .loadString('assets/map_theme/retro_theme.json')
        .then((value) => mapTheme = value);
    print(widget.id);
    initLocation();

    // print('The data');
    // print(location);
  }

  double lat = 0;
  double long = 0;
  String mapTheme = '';

  List<LatLng> polylineCoordinates = [];
  PolylinePoints polyLinePoints = PolylinePoints();

  @override
  Widget build(BuildContext context) {
    Polyline _polyline = Polyline(
        polylineId: PolylineId('_polylineId'),
        points: [
          LatLng(_currentLocation.latitude, _currentLocation.longitude),
          LatLng(lat, long)
        ]);
    // if (!_marker.isEmpty) {

    // }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Image(
          height: 60,
          fit: BoxFit.contain,
          image: AssetImage(
            'assets/images/distrho_logo.png',
          ),
        ),
        centerTitle: true,
        // actions: [
        //     PopupMenuButton(itemBuilder: ((context) => [
        //       PopupMenuItem(
        //         onTap: (){
        //           setState(() {
        //              print("Silver");
        //              _controller.future.then((value) =>
        //           DefaultAssetBundle.of(context).
        //           loadString('assets/map_theme/silver_theme.json').
        //           then((string) => value.setMapStyle(string)));
        //           });

        //         },
        //         child: Text('Silver')),
        //          PopupMenuItem(
        //         onTap: (){
        //            setState(() {
        //               print("Retro");
        //               _controller.future.then((value) =>
        //           DefaultAssetBundle.of(context).
        //           loadString('assets/map_theme/retro_theme.json').
        //           then((string) => value.setMapStyle(string)));
        //           });

        //         },
        //         child: Text('Retro')),
        //          PopupMenuItem(
        //         onTap: (){
        //            setState(() {
        //             print("Night");
        //                _controller.future.then((value) =>
        //           DefaultAssetBundle.of(context).
        //           loadString('assets/map_theme/night_theme.json').
        //           then((string) => value.setMapStyle(string)));
        //           });

        //         },
        //         child: Text('Night')),
        //         PopupMenuItem(
        //         onTap: (){
        //            setState(() {
        //             print("Aubergine");
        //                _controller.future.then((value) =>
        //           DefaultAssetBundle.of(context).
        //           loadString('assets/map_theme/aubergine_theme.json').
        //           then((string) => value.setMapStyle(string)));
        //           });

        //         },
        //         child: Text('Aubergine')),

        //   ]))],
      ),
      body: ModalProgressHUD(
        inAsyncCall: _saving,
        child: GoogleMap(
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          // mapType: MapType.normal,
          initialCameraPosition: _kGooglePlex,
          markers: Set<Marker>.of(_marker),
          polylines: {
            Polyline(
                polylineId: const PolylineId("route"),
                points: polylineCoordinates,
                color: Colors.red)
            // _polyline
          },
          onMapCreated: (GoogleMapController controller) {
            // _controller.complete(controller);
            controller.setMapStyle(mapTheme);
          },

          // markers: markers.values.toSet(),
        ),
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: _goToTheLake,
      //   label: Text('To the lake!'),
      //   icon: Icon(Icons.directions_boat),
      // ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }

  Future<void> initLocation() async {
    Location _locationService = Location();
    await _locationService.requestPermission();
    final hasPermission = await _locationService.serviceEnabled();
    if (hasPermission) {
      final locationData = await _locationService.getLocation();
      setState(() {
        _currentLocation = LatLng(
          locationData.latitude ?? 0.0,
          locationData.longitude ?? 0.0,
        );
      });
    }
    getPoliline();
  }
}
