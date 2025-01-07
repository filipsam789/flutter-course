import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:new_flutter_project/models/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MapScreen extends StatefulWidget {
  final Location location;

  const MapScreen({required this.location});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;
  Position? _currentPosition;
  final Set<Marker> _markers = {};
  List<LatLng> coordinates = [];
  final Map<PolylineId, Polyline> _polylinesMap = {};

  @override
  void initState() {
    super.initState();
    _getCurrentLocation().then((value) => {
          getPolylinePoints(value!)
              .then((value) => {generatePolyLineFromPoints(value)})
        });
  }

  Future<Position?> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return null;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = position;
      _addMarker(position.latitude, position.longitude);
      _addMarker(widget.location.latitude, widget.location.longitude);
    });

    return position;
  }

  Future<List<LatLng>> getPolylinePoints(Position position) async {
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: 'MY_API_KEY',
      request: PolylineRequest(
        origin: PointLatLng(position.latitude, position.longitude),
        destination:
            PointLatLng(widget.location.latitude, widget.location.longitude),
        mode: TravelMode.driving,
      ),
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    return polylineCoordinates;
  }

  void _addMarker(double latitude, double longitude) {
    _markers.add(Marker(
      markerId: MarkerId('$latitude,$longitude'),
      position: LatLng(latitude, longitude),
      infoWindow: InfoWindow(title: 'Location'),
    ));
  }

  void generatePolyLineFromPoints(List<LatLng> polylineCoordinates) async {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.black,
        points: polylineCoordinates,
        width: 8);
    setState(() {
      _polylinesMap[id] = polyline;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.location.name),
      ),
      body: (_currentPosition != null)
          ? GoogleMap(
              initialCameraPosition: CameraPosition(
                target:
                    LatLng(widget.location.latitude, widget.location.longitude),
                zoom: 14,
              ),
              markers: _markers,
              polylines: Set<Polyline>.of(_polylinesMap.values),
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
              },
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
