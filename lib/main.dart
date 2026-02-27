// ignore_for_file: depend_on_referenced_packages, unrelated_type_equality_checks, avoid_print, library_private_types_in_public_api, deprecated_member_use, use_super_parameters, unused_import, strict_top_level_inference

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:janpro/Screens/Attendance.dart';
import 'package:janpro/Screens/Complaint.dart';
import 'package:janpro/Screens/Homepage.dart';
import 'package:janpro/Screens/Loginscreen.dart';
import 'package:janpro/Screens/Rating.dart';
import 'package:janpro/Screens/SpecialActivity.dart';
import 'package:janpro/Screens/Training.dart';
import 'package:janpro/Screens/WorkflowstatusOperation.dart';
import 'package:janpro/Screens/splashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:janpro/Screens/view_remark_attendance.dart';
import 'package:janpro/Utitlity/GlobalLists.dart';
import 'package:janpro/Utitlity/SPManager.dart';
import 'package:janpro/model/Note.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:workmanager/workmanager.dart';
import 'DBHelper/syncs_offline.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:connectivity_plus/connectivity_plus.dart';

/// single top-level channel used everywhere
const AndroidNotificationChannel kCustomChannel = AndroidNotificationChannel(
  'custom_sound_channel_2', // id
  'Custom Sound Channel', // name
  description: 'Channel with custom sound',
  importance: Importance.high,
  sound: RawResourceAndroidNotificationSound('custom_notification_2'),
);

/// Initialize the [FlutterLocalNotificationsPlugin] package.
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// Background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Ensure Firebase is initialized in background isolate
  await Firebase.initializeApp();

  // create channel in background as well (harmless if already exists)
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.createNotificationChannel(kCustomChannel);

  if (message.notification != null) {
    await flutterLocalNotificationsPlugin.show(
     id: message.hashCode,
     title:  message.notification?.title,
    body:   message.notification?.body,
   notificationDetails:    NotificationDetails(
        android: AndroidNotificationDetails(
          kCustomChannel.id,
          kCustomChannel.name,
          channelDescription: kCustomChannel.description,
          icon: '@mipmap/ic_launcher',
          sound: kCustomChannel.sound,
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();

  // Firebase first
  await Firebase.initializeApp();

  // register background handler (use the RemoteMessage signature)
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Initialize local notifications
  const AndroidInitializationSettings androidInitSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initSettings = InitializationSettings(
    android: androidInitSettings,
    iOS: DarwinInitializationSettings(),
  );

  await flutterLocalNotificationsPlugin.initialize(
  settings:   initSettings,
    // onDidReceiveNotificationResponse handled later in app state if needed
  );

  // Create channel before any notifications are shown
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.createNotificationChannel(kCustomChannel);

  // initialize workmanager once
  setupWorkmanager();

  // request notification permission BEFORE runApp (Android 13+ / iOS)
  await requestNotificationPermission();

  // initial sync if connected
  if (await isConnected()) {
    syncOfflineRequests();
  }

  // listen for connectivity and auto-sync (keeps your existing behavior)
  Connectivity().onConnectivityChanged.listen((result) {
    if (result != ConnectivityResult.none) {
      syncOfflineRequests();
    }
  });

  runApp(const MyApp());
}

Future<bool> isConnected() async {
  final result = await Connectivity().checkConnectivity();
  return result != ConnectivityResult.none;
}

// Add this in your `main.dart` or initialization file
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == 'complaint_reminder') {
      // implement the periodic reminder job if needed
    }
    return Future.value(true);
  });
}

Future<void> requestNotificationPermission() async {
  if (Platform.isAndroid) {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    final sdkInt = androidInfo.version.sdkInt;

    if (sdkInt >= 33) {
      final status = await Permission.notification.status;
      if (!status.isGranted) {
        final result = await Permission.notification.request();
        log('Android 13+ notification permission granted: ${result.isGranted}');
      } else {
        log('Android 13+ notification permission already granted.');
      }
    } else {
      log('Notification permission not needed on Android SDK < 33.');
    }
  }

  if (Platform.isIOS) {
    final settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    log('iOS notification permission status: ${settings.authorizationStatus}');
  }
}

void setupWorkmanager() {
  Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
}

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  log('Notification bg');
  await Firebase.initializeApp();
  if (message.containsKey('data')) {
    log('in bg');
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  dynamic globalvalue;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey(
    debugLabel: "Main Navigator",
  );

  // use global flutterLocalNotificationsPlugin (do not redeclare locally)

  @override
  void initState() {
    super.initState();
    settoken();
    requestNotificationPermissions();
    initLocalNotificationUpdated();

    // handle case app launched from terminated state via notification
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        showNotification(
          message.data.isNotEmpty
              ? {
                  'notification': {
                    'title': message.notification?.title ?? '',
                    'body': message.notification?.body ?? '',
                  },
                  'data': message.data,
                }
              : message,
        );
        handleNavigationFromMessage(message);
      }
    });

    // foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      globalvalue = message;
      log('Foreground message received: ${message.messageId}');
      showForegroundNotification(message);
    });

    // click on notification when app in background -> opened
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      handleNavigationFromMessage(message);
      configLocalNotification();
    });

    configLocalNotification();
  }

  Future<void> initLocalNotificationUpdated() async {
    var androidSettings = AndroidInitializationSettings('@mipmap/janprologo');
    var iosSettings = DarwinInitializationSettings();

    var initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(
     settings:  initSettings,
      onDidReceiveNotificationResponse: (details) {
        var payload = details.payload;
        if (payload != null) {
          selectNotification1(payload);
        }
      },
    );
  }

  Future<void> configLocalNotification() async {
    var details = await flutterLocalNotificationsPlugin
        .getNotificationAppLaunchDetails();

    if (details != null && details.didNotificationLaunchApp) {
      String? payload = details.notificationResponse?.payload;
      if (payload != null) {
        selectNotification1(payload);
      }
    }
  }

  void showForegroundNotification(RemoteMessage message) async {
    var title = message.notification?.title;
    var body = message.notification?.body;

    final android = AndroidNotificationDetails(
      kCustomChannel.id,
      kCustomChannel.name,
      channelDescription: kCustomChannel.description,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      sound: kCustomChannel.sound,
      styleInformation: BigTextStyleInformation(body ?? ''),
      icon: '@mipmap/janprologo',
    );

    final platform = NotificationDetails(android: android);

    var type = message.data['type'];
    Note newNote = Note(
      type: type ?? '',
      status: message.data['status'] ?? '',
      id: message.data['id'].toString(),
      client_site_name: message.data['client_site_name'] ?? '',
      date: message.data['date'] ?? "",
      emp_id: message.data['emp_id'] ?? "",
      isclient: message.data['isclient'] == true ||
          message.data['isclient'] == "true" ? true : false,

      shift_end_time: message.data['shift_end_time'] ?? '',
      shift_id: message.data['shift_id'] ?? '',
      shift_start_time: message.data['shift_start_time'] ?? '',
      siteid: message.data['siteid'] ?? '',
    );

    String payload = newNote.toJsonString();

    await flutterLocalNotificationsPlugin.show(
     id:  0,
     title:  title,
      body: body,
     notificationDetails: platform,
      payload: payload,
    );
  }

  void showNotification(message) async {
    // normalize message structure for both RemoteMessage and Map cases
    String title = '';
    String body = '';
    dynamic payload;

    if (message is RemoteMessage) {
      title = message.notification?.title ?? '';
      body = message.notification?.body ?? '';
      payload = jsonEncode({
        'notification': {'title': title, 'body': body},
        'data': message.data,
      });
    } else if (message is Map) {
      title = message['notification']?['title']?.toString() ?? '';
      body = message['notification']?['body']?.toString() ?? '';
      payload = jsonEncode(message);
    }

    var androidDetails = AndroidNotificationDetails(
      kCustomChannel.id,
      kCustomChannel.name,
      channelDescription: kCustomChannel.description,
      channelShowBadge: true,
      enableVibration: true,
      importance: Importance.max,
      priority: Priority.high,
      sound: kCustomChannel.sound,
      playSound: true,
      styleInformation: BigTextStyleInformation(body),
      icon: '@mipmap/ic_launcher',
    );

    var iosDetails = DarwinNotificationDetails();

    var platform = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await flutterLocalNotificationsPlugin.show(
   id:  0,
     title:  title,
      body: body,
     notificationDetails: platform,
      payload: payload,
    );
  }

  Future selectNotificationonlisten(dynamic message) async {
    message = globalvalue;
    handleNavigationFromMessage(message);
    return Future.value(message);
  }

  Future selectNotification1(dynamic message) async {
    Map valueMap = json.decode(message);
    handleNavigationFromPayload(valueMap);
  }

  void handleNavigationFromMessage(RemoteMessage message) {
    if (message.data['type'] == null) return;

    navigatorKey.currentState?.pop();

    var type = message.data['type'];

    if (type == "complaint") {
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => Complaint(
            true,
            message.data['emp_type'],
            message.data['site_id'],
            message.data['emp_id'],
            message.data['date'],
            message.data['id'],
            message.data['status'],
            message.data['client_site_name'],
            false,
          ),
        ),
      );
    } else if (type == "workflow") {
      GlobalLists.clientid = message.data['emp_id'];
      GlobalLists.siteid = message.data['site_id'];

      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => WorkflowstatusOperation(
            message.data['shift_id'],
            true,
            message.data['shift_start_time'],
            message.data['shift_end_time'],
            message.data['client_site_name'],
            "",
          ),
        ),
      );
    } else if (type == "attendance_new") {
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => Attendance(message.data['client_site_name']),
        ),
      );
    } else if (type == "training") {
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => Training(message.data['client_site_name']),
        ),
      );
    } else if (type == "specialactivity") {
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => SpecialActivity(message.data['client_site_name']),
        ),
      );
    } else if (type == "rating") {
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => Rating(message.data['client_site_name']),
        ),
      );
    } else {
      navigatorKey.currentState?.push(
        MaterialPageRoute(builder: (_) => HomePage()),
      );
    }
  }

  void handleNavigationFromPayload(Map valueMap) {
    String type = valueMap['type'];

    log('valueMap["type"] $type');

    if (type == "complaint") {
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => Complaint(
            true,
            valueMap['emp_type'],
            valueMap['site_id'],
            valueMap['emp_id'],
            valueMap['date'],
            valueMap['id'],
            valueMap['status'],
            valueMap['client_site_name'],
            false,
          ),
        ),
      );
    } else if (type == "workflow") {
      GlobalLists.clientid = valueMap['emp_id'];
      GlobalLists.siteid = valueMap['site_id'];

      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => WorkflowstatusOperation(
            valueMap['shift_id'],
            true,
            valueMap['shift_start_time'],
            valueMap['shift_end_time'],
            valueMap['client_site_name'],
            "",
          ),
        ),
      );
    } else if (type == "attendance_new") {
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => Attendance(valueMap['client_site_name']),
        ),
      );
    } else if (type == "training") {
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => Training(valueMap['client_site_name']),
        ),
      );
    } else if (type == "specialactivity") {
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => SpecialActivity(valueMap['client_site_name']),
        ),
      );
    }
    else if (type == "Roster Finalized"||type == "Roster Reviewed"||type == "Roster Review Due"||type == "Discrepancy Reported"||type == "Roster Approved") {
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => Attendance(
            valueMap['client_site_name']
            
          ),
        ),
      );
    }
    
     else if (type == "rating") {
      navigatorKey.currentState?.push(
        MaterialPageRoute(builder: (_) => Rating(valueMap['client_site_name'])),
      );
    } else {
      navigatorKey.currentState?.push(
        MaterialPageRoute(builder: (_) => HomePage()),
      );
    }
  }

  void requestNotificationPermissions() {
    FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  settoken() async {
    if (Platform.isIOS) {
      await FirebaseMessaging.instance.getAPNSToken();
    }

    final FirebaseMessaging fcm = FirebaseMessaging.instance;
    String? token = await fcm.getToken();
    log('token : $token');
    await SPManager().setfcmAuthToken(token ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (context, child) {
        return MaterialApp(
          title: 'JanPro',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: false,
            fontFamily: "Linotype Didot",
            primarySwatch: Colors.blue,
          ),
          home: SplashScreen(),
          routes: {'Login': (_) => LoginScreen()},
          navigatorKey: navigatorKey,
        );
      },
    );
  }
}
