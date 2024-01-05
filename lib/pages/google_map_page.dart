import 'package:flutter/material.dart';
import 'package:google_map_and_live_location_tracking/provider/location_provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class GoogleMapPage extends StatefulWidget {
  const GoogleMapPage({Key? key}) : super(key: key);

  @override
  _GoogleMapPageState createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<LocationProvider>(context, listen: false).initalization();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Live Location Tracking',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: googleMapUI(),
    );
  }

  Widget googleMapUI() {
    return Consumer<LocationProvider>(builder: (consumerContext, model, child) {
      if (model.locationPosition != null) {
        return Column(
          children: [
            Expanded(
              child: GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                    // target: LatLng(28.7041, 77.1025),
                    target: model.locationPosition,
                    zoom: 18,
                  ),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  markers: Set<Marker>.of(model.markers.values),
                  onMapCreated: (GoogleMapController controller) {}),
            ),
          ],
        );
      }

      return Container(
        child: Center(
          child: CircularProgressIndicator(
            color: Colors.blue,
          ),
        ),
      );
    });
  }
}
