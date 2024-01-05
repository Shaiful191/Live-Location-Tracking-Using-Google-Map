import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
 import 'dart:ui' as ui;

class LocationProvider with ChangeNotifier {
  LocationProvider() {
    _location = new Location();
  }

  late BitmapDescriptor _pinLocationIcon;
  BitmapDescriptor get pinLocationIcon => _pinLocationIcon;

  late Map<MarkerId, Marker> _markers;
  Map<MarkerId, Marker> get markers => _markers;

  final MarkerId markerId = MarkerId("1");

  Location? _location;
  Location get location => _location!;

  LatLng? _locationPosition;
  LatLng get locationPosition => _locationPosition!;

  bool locationServiceActive = true;

  initalization() async {
    await getUserLocation();
    await setCustomMapPin();
  }

  getUserLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();

    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();

      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    location.onLocationChanged.listen((LocationData currentLocation) {
      _locationPosition = LatLng(
        currentLocation.latitude!,
        currentLocation.longitude!,
      );

      //Live location print:
      print(_locationPosition);

      _markers = <MarkerId, Marker>{};
      Marker marker = Marker(
        markerId: markerId,
        position: LatLng(
          currentLocation.latitude!,
          currentLocation.longitude!,
        ),
        icon: pinLocationIcon,
        draggable: true,
        onDragEnd: ((newPosition) {
          _locationPosition = LatLng(
            newPosition.latitude,
            newPosition.longitude,
          );
          notifyListeners();
        }),
      );
      _markers[markerId] = marker;
      notifyListeners();
    });
  }

 

Future<Uint8List?> getBytesFromAsset(String path, int width) async {
  ByteData data = await rootBundle.load(path);
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
  ui.FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(format: ui.ImageByteFormat.png))?.buffer.asUint8List();
}



 
  setCustomMapPin() async {
     final Uint8List? markerIcon = await getBytesFromAsset('assets/map-marker-icon.png', 100);
     _pinLocationIcon = await BitmapDescriptor.fromBytes(markerIcon!);



    // _pinLocationIcon = await BitmapDescriptor.fromAssetImage(

    //   ImageConfiguration(
    //     devicePixelRatio: 2.5,
    //   ),
    //   'assets/map-marker-icon.png',
    // );
  }
}
