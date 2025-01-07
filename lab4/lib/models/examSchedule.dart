import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:new_flutter_project/models/location.dart';

class ExamSchedule {
  final String id;
  final String subject;
  final DateTime dateTime;
  final Location location;

  ExamSchedule({
    required this.id,
    required this.subject,
    required this.dateTime,
    required this.location,
  });

  static Future<ExamSchedule> fromMap(Map<String, dynamic> map) async {
    DocumentReference locationRef =
        map['location']; // This is the location reference
    DocumentSnapshot locationSnapshot = await locationRef.get();
    Location location =
        Location.fromMap(locationSnapshot.data() as Map<String, dynamic>);

    return ExamSchedule(
      id: map['id'],
      subject: map['subject'],
      dateTime: (map['dateTime'] as Timestamp)
          .toDate(), // Convert Timestamp to DateTime
      location: location,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'subject': subject,
      'dateTime': dateTime.toIso8601String(),
      'location': location.toMap(),
    };
  }
}
