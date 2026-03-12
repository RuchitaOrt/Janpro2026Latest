// /*
// // Add at the top of Complaint.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/data/latest_all.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
// FlutterLocalNotificationsPlugin();

// void initializeNotifications() {
//   tz.initializeTimeZones();
//   const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
//   //final iosInit = DarwinInitializationSettings();
//   final settings = InitializationSettings(android: androidInit*/
// /*, iOS: iosInit*/ /*
// );
//   flutterLocalNotificationsPlugin.initialize(settings);
// }

// void scheduleReminderNotification({
//   required String title,
//   required String body,
//   required Duration delay,
// }) async {
//   const androidDetails = AndroidNotificationDetails(
//     'reminder_channel',
//     'Complaint Reminders',
//     '',
//     //channelDescription: 'Reminders for complaint TAT',

//     importance: Importance.max,
//     priority: Priority.high,
//   );

//   const notificationDetails = NotificationDetails(android: androidDetails);

//   await flutterLocalNotificationsPlugin.zonedSchedule(
//     0,
//     title,
//     body,
//     tz.TZDateTime.now(tz.local).add(delay),
//     notificationDetails,
//     androidAllowWhileIdle: true,
//     uiLocalNotificationDateInterpretation:
//     UILocalNotificationDateInterpretation.absoluteTime,
//     matchDateTimeComponents: DateTimeComponents.time,
//   );
// }

// // Inside your existing function where complaint is successfully added:
// void handleComplaintSuccess(BuildContext context, String complaintType) {
//   final tatDurations = {
//     "Billing": Duration(hours: 3),
//     "Cleaning": Duration(minutes: 15),
//     "Compliance": Duration(hours: 3),
//     "Equipment": Duration(hours: 3),
//     "Grooming Appearance": Duration(minutes: 15),
//     "Grooming Uniform": Duration(minutes: 15),
//     "Salary": Duration(hours: 1),
//     "Other": Duration(hours: 3),
//   };

//   final tat = tatDurations[complaintType] ?? Duration(hours: 1);
//   final delay = tat - Duration(seconds: 10);
//   //final delay = tat - Duration(minutes: 3);

//   scheduleReminderNotification(
//     title: 'Complaint Reminder',
//     body: 'TAT for $complaintType complaint is about to expire.',
//     delay: delay,
//   );

//   // You can call this function inside addcomplaintApi after submission is successful
// }



// */

// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/data/latest_all.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// void initializeNotifications() {
//   tz.initializeTimeZones();
//   const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
//   final settings = InitializationSettings(android: androidInit);
//   flutterLocalNotificationsPlugin.initialize(settings);
// }

// void scheduleReminderNotification({
//   required String title,
//   required String body,
//   required Duration delay,
// }) async {
//   const androidDetails = AndroidNotificationDetails(
//     'reminder_channel',
//     'Complaint Reminders',
//     importance: Importance.max,
//     priority: Priority.high,
//   );

//   const notificationDetails = NotificationDetails(android: androidDetails);

//   await flutterLocalNotificationsPlugin.zonedSchedule(
//     0,
//     title,
//     body,
//     tz.TZDateTime.now(tz.local).add(delay),
//     notificationDetails,
//     androidAllowWhileIdle: true,
//     uiLocalNotificationDateInterpretation:
//         UILocalNotificationDateInterpretation.absoluteTime,
//     matchDateTimeComponents: DateTimeComponents.time,
//   );
// }

// class ComplaintScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // Initialize notifications
//     initializeNotifications();

//     return Scaffold(
//       appBar: AppBar(title: Text("Complaint Page")),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () {
//                 // Call the function to schedule a reminder notification
//                 final tatDurations = {
//                   "Billing": Duration(hours: 3),
//                   "Cleaning": Duration(minutes: 15),
//                   "Compliance": Duration(hours: 3),
//                   "Equipment": Duration(hours: 3),
//                   "Grooming Appearance": Duration(minutes: 15),
//                   "Grooming Uniform": Duration(minutes: 15),
//                   "Salary": Duration(hours: 1),
//                   "Other": Duration(hours: 3),
//                 };

//                 // Test with a dummy complaint type
//                 final complaintType = "Cleaning";
//                 final tat = tatDurations[complaintType] ?? Duration(hours: 1);
//                 final delay = tat - Duration(seconds: 10);

//                 scheduleReminderNotification(
//                   title: 'Complaint Reminder',
//                   body: 'TAT for $complaintType complaint is about to expire.',
//                   delay: delay,
//                 );
//               },
//               child: Text('Test Reminder Notification'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
