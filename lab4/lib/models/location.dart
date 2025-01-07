import 'package:cloud_firestore/cloud_firestore.dart';

class Location {
  String name;
  double latitude;
  double longitude;

  Location({
    required this.name, 
    required this.latitude, 
    required this.longitude
  });

  factory Location.fromMap(Map<String, dynamic> map) {
    GeoPoint geoPoint = map['coordinates']; 
    return Location(
      name: map['name'],
      latitude: geoPoint.latitude,
      longitude: geoPoint.longitude,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
