// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/timezone.dart' as tz;
// import 'package:timezone/data/latest.dart' as tz;

// class NotificationService {
//   static final NotificationService _instance = NotificationService._internal();
//   factory NotificationService() => _instance;
//   NotificationService._internal();

//   final FlutterLocalNotificationsPlugin notificationsPlugin =
//   FlutterLocalNotificationsPlugin();

//   Future<void> initialize() async {
//     tz.initializeTimeZones();
//     const AndroidInitializationSettings initializationSettingsAndroid =
//     AndroidInitializationSettings('@mipmap/ic_launcher');

//     final InitializationSettings initializationSettings =
//     InitializationSettings(
//       android: initializationSettingsAndroid,
//     );

//     await notificationsPlugin.initialize(initializationSettings);
//   }

//   Future<void> scheduleNotification({
//     required int id,
//     required String title,
//     required String body,
//     required Duration duration,
//   }) async {
//     await notificationsPlugin.zonedSchedule(
//       id,
//       title,
//       body,
//       tz.TZDateTime.now(tz.local).add(duration),
//       NotificationDetails(
//         android: AndroidNotificationDetails(
//           'complaint_channel',
//           'Complaint Reminders',
         
//           importance: Importance.max,
//           priority: Priority.high,
//           playSound: true,
//           enableVibration: true,
//           timeoutAfter: duration.inMilliseconds,
//         ),
//       ),
//       androidAllowWhileIdle: true,
//       uiLocalNotificationDateInterpretation:
//       UILocalNotificationDateInterpretation.absoluteTime,
//     );
//   }
// }

// // models/ticket_model.dart
// class Ticket {
//   final int id;
//   final String complainantName;
//   final String comment;
//   // Add other fields as needed from your API response

//   Ticket({
//     required this.id,
//     required this.complainantName,
//     required this.comment,
//     // Initialize other fields
//   });

//   factory Ticket.fromJson(Map<String, dynamic> json) {
//     return Ticket(
//       id: json['id'],
//       complainantName: json['complainant_name'] ?? '',
//       comment: json['comment'] ?? '',
//       // Map other fields
//     );
//   }
// }