import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:new_flutter_project/main.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:new_flutter_project/models/examSchedule.dart';
import 'package:new_flutter_project/screens/MapScreen.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late Map<String, List<ExamSchedule>> _events = {};
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _fetchExamSchedules();
  }

  Future<void> _fetchExamSchedules() async {
    var snapshot =
        await FirebaseFirestore.instance.collection('examSchedules').get();
    Map<String, List<ExamSchedule>> events = {};

    for (var doc in snapshot.docs) {
      var data = doc.data();
      var exam = await ExamSchedule.fromMap(data);
      var date =
          DateTime(exam.dateTime.year, exam.dateTime.month, exam.dateTime.day);
      var dateKey = date.toIso8601String().substring(0, 10);

      if (!events.containsKey(dateKey)) {
        events[dateKey] = [];
      }
      events[dateKey]!.add(exam);
      try {
        await scheduleExamNotification(
          flutterLocalNotificationsPlugin,
          exam.dateTime,
          exam.subject,
        );
      } catch (e) {
        print('Error scheduling notifications: $e');
      }
    }

    setState(() {
      _events = events;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exam Calendar'),
      ),
      body: TableCalendar(
        focusedDay: _focusedDay,
        firstDay: DateTime(_focusedDay.year, _focusedDay.month - 1, 1),
        lastDay: DateTime(_focusedDay.year, _focusedDay.month + 1, 0),
        calendarFormat: CalendarFormat.month,
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });

          var dateKey = selectedDay.toIso8601String().substring(0, 10);
          var events = _events[dateKey] ?? [];

          if (events.isNotEmpty) {
            _showExamPopup(context, _events[dateKey]!);
          }
        },
        eventLoader: (day) {
          var dateKey = day.toIso8601String().substring(0, 10);
          return _events[dateKey] ?? [];
        },
        calendarStyle: const CalendarStyle(
            todayDecoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            selectedDecoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            markerDecoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            )),
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
        ),
      ),
    );
  }

  void _showExamPopup(BuildContext context, List<ExamSchedule> exams) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Exam Details'),
          content: SingleChildScrollView(
            child: Column(
              children: exams.map((exam) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Subject: ${exam.subject}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Time: ${DateFormat('HH:mm').format(exam.dateTime)}',
                      ),
                      Text(
                        'Location: ${exam.location.name}',
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  MapScreen(location: exam.location),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[100],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('View on Map'),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
