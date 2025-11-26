
// ignore_for_file: depend_on_referenced_packages, unrelated_type_equality_checks, avoid_print, library_private_types_in_public_api, deprecated_member_use, use_super_parameters

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:janpro/Utitlity/GlobalLists.dart';
import 'package:janpro/Utitlity/SPManager.dart';
import 'package:janpro/model/Note.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:workmanager/workmanager.dart';
import 'DBHelper/syncs_offline.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:connectivity_plus/connectivity_plus.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  description: 'Channel with sound',
  importance: Importance.high,
  sound: RawResourceAndroidNotificationSound('custom_notification_2'),
);

/// Initialize the [FlutterLocalNotificationsPlugin] package.
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'custom_sound_channel_2',
    'Custom Sound Notifications',
    description: 'Channel with custom sound',
    importance: Importance.high,
    sound: RawResourceAndroidNotificationSound('custom_notification_2'),
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  if (message.notification != null) {
    flutterLocalNotificationsPlugin.show(
      message.hashCode,
      message.notification?.title,
      message.notification?.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          icon: '@mipmap/ic_launcher',
          sound: channel.sound,
        ),
      ),
    );
  }
}

Future<void> main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  setupWorkmanager(); // Initialize Workmanager
  // await NotificationService().initialize();
  await Firebase.initializeApp();
  // Initial check
  if (await isConnected()) {
    syncOfflineRequests();

  } else {

  }

  // Auto-sync on network comeback
  Connectivity().onConnectivityChanged.listen((result) {
    if (result != ConnectivityResult.none) {
      syncOfflineRequests();
      log('on syncOfflineRequests is connected');
    }
  });

  setupWorkmanager();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,

  ]);
  runApp(MyApp());
  await requestNotificationPermission();
}

Future<bool> isConnected() async {
  final result = await Connectivity().checkConnectivity();
  return result != ConnectivityResult.none;
}

// Add this in your `main.dart` or initialization file
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == 'complaint_reminder') {

    }
    return true;
  });
}

Future<void> requestNotificationPermission() async {
  if (Platform.isAndroid) {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    final sdkInt = androidInfo.version.sdkInt ;

    if (sdkInt >= 33) {
      final status = await Permission.notification.status;
      if (!status.isGranted) {
        final result = await Permission.notification.request();
        print(
            'Android 13+ notification permission granted: ${result.isGranted}');
      } else {
        print('Android 13+ notification permission already granted.');
      }
    } else {
      print('Notification permission not needed on Android SDK < 33.');
    }
  }

  if (Platform.isIOS) {
    final settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    print(
        'iOS notification permission status: ${settings.authorizationStatus}');
  }
}

void setupWorkmanager() {
  Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: false,
  );
}

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  print('Notification bg');
  await Firebase.initializeApp();
  //  configLocalNotification();
  if (message.containsKey('data')) {
    // navigateToScreen(message);
    print('in bg');
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  dynamic globalvalue;
  final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey(debugLabel: "Main Navigator");

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    settoken();
    requestNotificationPermissions();
    initLocalNotificationUpdated();

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        showNotification(message);
        handleNavigationFromMessage(message);
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      globalvalue = message;
      showForegroundNotification(message);
    });

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
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        var payload = details.payload;
        if (payload != null) {
          selectNotification1(payload);
        }
      },
    );
  }

  Future<void> configLocalNotification() async {
    var details =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

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
      'custom_sound_channel_2',
      'Custom Sound Channel',
      channelDescription: 'Channel with sound',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('custom_notification_2'),
      styleInformation: BigTextStyleInformation(body ?? ''),
      icon: '@mipmap/janprologo',
    );

    final platform = NotificationDetails(android: android);

    var type = message.data['type'];
    Note newNote = Note(
      type: type.toString(),
      status: message.data['status'],
      id: message.data['id'].toString(),
      client_site_name: message.data['client_site_name'],
      date: message.data['date'],
      emp_id: message.data['emp_id'],
      isclient: message.data['isclient'],
      shift_end_time: message.data['shift_end_time'],
      shift_id: message.data['shift_id'],
      shift_start_time: message.data['shift_start_time'],
      siteid: message.data['siteid'],
    );

    String payload = newNote.toJsonString();

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platform,
      payload: payload,
    );
  }

  void showNotification(message) async {
    var androidDetails = AndroidNotificationDetails(
      'custom_sound_channel_2',
      'Custom Sound Channel',
      channelDescription: 'Channel with sound',
      channelShowBadge: true,
      enableVibration: true,
      importance: Importance.max,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound('custom_notification_2'),
      playSound: true,
      styleInformation:
          BigTextStyleInformation(message['notification']['body']),
    );

    var iosDetails = DarwinNotificationDetails();

    var platform = NotificationDetails(
        android: androidDetails, iOS: iosDetails);

    flutterLocalNotificationsPlugin.show(
      0,
      message['notification']['title'].toString(),
      message['notification']['body'].toString(),
      platform,
      payload: jsonEncode(message),
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
      navigatorKey.currentState?.push(MaterialPageRoute(
          builder: (_) => Complaint(
              true,
              message.data['emp_type'],
              message.data['site_id'],
              message.data['emp_id'],
              message.data['date'],
              message.data['id'],
              message.data['status'],
              message.data['client_site_name'],
              false)));
    } else if (type == "workflow") {
      GlobalLists.clientid = message.data['emp_id'];
      GlobalLists.siteid = message.data['site_id'];

      navigatorKey.currentState?.push(MaterialPageRoute(
          builder: (_) => WorkflowstatusOperation(
                message.data['shift_id'],
                true,
                message.data['shift_start_time'],
                message.data['shift_end_time'],
                message.data['client_site_name'],
                "",
              )));
    } else if (type == "attendance_new") {
      navigatorKey.currentState?.push(MaterialPageRoute(
          builder: (_) => Attendance(message.data['client_site_name'])));
    } else if (type == "training") {
      navigatorKey.currentState?.push(MaterialPageRoute(
          builder: (_) => Training(message.data['client_site_name'])));
    } else if (type == "specialactivity") {
      navigatorKey.currentState?.push(MaterialPageRoute(
          builder: (_) => SpecialActivity(message.data['client_site_name'])));
    } else if (type == "rating") {
      navigatorKey.currentState?.push(MaterialPageRoute(
          builder: (_) => Rating(message.data['client_site_name'])));
    } else {
      navigatorKey.currentState
          ?.push(MaterialPageRoute(builder: (_) => HomePage()));
    }
  }

  void handleNavigationFromPayload(Map valueMap) {
    String type = valueMap['type'];

    if (type == "complaint") {
      navigatorKey.currentState?.push(MaterialPageRoute(
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
              )));
    } else if (type == "workflow") {
      GlobalLists.clientid = valueMap['emp_id'];
      GlobalLists.siteid = valueMap['site_id'];

      navigatorKey.currentState?.push(MaterialPageRoute(
          builder: (_) => WorkflowstatusOperation(
                valueMap['shift_id'],
                true,
                valueMap['shift_start_time'],
                valueMap['shift_end_time'],
                valueMap['client_site_name'],
                "",
              )));
    } else if (type == "attendance_new") {
      navigatorKey.currentState?.push(MaterialPageRoute(
          builder: (_) => Attendance(valueMap['client_site_name'])));
    } else if (type == "training") {
      navigatorKey.currentState?.push(MaterialPageRoute(
          builder: (_) => Training(valueMap['client_site_name'])));
    } else if (type == "specialactivity") {
      navigatorKey.currentState?.push(MaterialPageRoute(
          builder: (_) => SpecialActivity(valueMap['client_site_name'])));
    } else if (type == "rating") {
      navigatorKey.currentState?.push(MaterialPageRoute(
          builder: (_) => Rating(valueMap['client_site_name'])));
    } else {
      navigatorKey.currentState
          ?.push(MaterialPageRoute(builder: (_) => HomePage()));
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
        routes: {
          'Login': (_) => LoginScreen(),
        },
        navigatorKey: navigatorKey,
      );
    },
  );
}
}
