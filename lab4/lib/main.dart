import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:new_flutter_project/screens/calendarScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:timezone/data/latest.dart';
import 'package:timezone/timezone.dart';
import 'firebase_options.dart';
import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message: ${message.messageId}');
}

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
Future<void> main() async {
  initializeTimeZones();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
  } else {
    print('User declined or has not granted permission');
  }

  String? token = await messaging.getToken();
  print("FCM Token: $token");

  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
    print("New FCM Token: $newToken");
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Received a message: ${message.notification?.title}');
    print('Message data: ${message.data}');

    _showLocalNotification(flutterLocalNotificationsPlugin, message);
  });

  runApp(const MyApp());
}

Future<void> _showLocalNotification(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    RemoteMessage message) async {
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'your_channel_id',
    'your_channel_name',
    importance: Importance.max,
    priority: Priority.high,
  );

  const NotificationDetails platformDetails = NotificationDetails(
    android: androidDetails,
  );

  await flutterLocalNotificationsPlugin.show(
    Random().nextInt(100000),
    message.notification?.title,
    message.notification?.body,
    platformDetails,
  );
}

Future<void> scheduleExamNotification(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    DateTime examDate,
    String examSubject) async {
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'exam_channel_id',
    'exam_channel_name',
    importance: Importance.max,
    priority: Priority.high,
  );

  const NotificationDetails platformDetails = NotificationDetails(
    android: androidDetails,
  );

  await flutterLocalNotificationsPlugin.zonedSchedule(
      Random().nextInt(100000),
      'Reminder: $examSubject',
      'You have an exam tomorrow!',
      TZDateTime.from(examDate.subtract(const Duration(days: 1)), tz.local),
      platformDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exam Schedules',
      initialRoute: '/',
      routes: {
        '/': (context) => CalendarScreen(),
      },
    );
  }
}
