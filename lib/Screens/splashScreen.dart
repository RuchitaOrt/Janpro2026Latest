import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:janpro/Screens/Homepage.dart';
import 'package:janpro/Screens/Loginscreen.dart';
import 'package:janpro/Utitlity/SPManager.dart';
import 'package:janpro/Utitlity/UtilityFile.dart';
import 'package:janpro/Utitlity/custom_color.dart';
import 'package:janpro/Utitlity/sizeConfig.dart';
import 'package:http/http.dart' as http;
import 'package:in_app_update/in_app_update.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController scaleController;
  late Animation<double> scaleAnimation;

  double _opacity = 0;
  bool _value = true;
  bool _isScaled = false;

  @override
  void initState() {
    super.initState();
    requestNotificationPermissions();
    Utility().loadAPIConfig(context);

   
    Timer(
      Duration(milliseconds: 300),
      () {
        setState(() {
          _isScaled = true;
        });
        //scaleController.reset();
      },
    );
 
  
   
    getstatus();
  }

  getstatus() async {
    String? gettotken = await SPManager().getAuthToken();
      // await checkForUpdates();
  
    if (gettotken == "") {
      Timer(
          Duration(seconds: 1),
          () => Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) =>
                      LoginScreen(),
                  transitionDuration: Duration(seconds: 0),
                ),
              ));
    } else {
      Timer(
          Duration(seconds: 1),
          () => Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) => HomePage(),
                  transitionDuration: Duration(seconds: 0),
                ),
              ));
    }
  }

  void requestNotificationPermissions() {
    FirebaseMessaging.instance
        .requestPermission(
      alert: true,
      badge: true,
      sound: true,
    )
        .then((settings) {
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('User granted permission');
      } else if (settings.authorizationStatus ==
          AuthorizationStatus.provisional) {
        print('User granted provisional permission');
      } else {
        print('User declined or has not accepted permission');
      }
    });
  }

  @override
  void dispose() {


    scaleController.dispose();
    super.dispose();
  }
 Future<void> checkForUpdates() async {
    if (Platform.isAndroid) {
      checkAndroidUpdate();
    } else if (Platform.isIOS) {
      checkIOSUpdate();
    }
  }


  Future<void> checkAndroidUpdate() async {
  
    try {
      final info = await InAppUpdate.checkForUpdate();
      log("Android update info: $info");
      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        await InAppUpdate.performImmediateUpdate();
      }
    } catch (e) {
      log("Android update error: $e");
      // fallback dialog
      showAndroidFallbackDialog();
    }
  }

  void showAndroidFallbackDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text("Update Available"),
          content: Text("A new version is available. Please update the app."),
          actions: [
            TextButton(
              child: Text("UPDATE"),
              onPressed: () async {
                const playStoreUrl =
                    "https://play.google.com/store/apps/details?id=com.ort.janpro";
                launchUrl(Uri.parse(playStoreUrl),
                    mode: LaunchMode.externalApplication);
              },
            )
          ],
        );
      },
    );
  }


  Future<void> checkIOSUpdate() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String currentVersion = packageInfo.version;
      String bundleId = packageInfo.packageName;

      // Apple lookup API
      final url =
          Uri.parse("https://itunes.apple.com/lookup?bundleId=$bundleId");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        if (json["resultCount"] > 0) {
          String storeVersion = json["results"][0]["version"];

          if (storeVersion != currentVersion) {
            showIOSUpdateDialog();
          }
        }
      }
    } catch (e) {
      log("iOS Update Check Error: $e");
    }
  }

  void showIOSUpdateDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text("Update Available"),
          content: Text(
              "A new version of the app is available on the App Store. Please update."),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text("UPDATE"),
              onPressed: () async {
                const appStoreUrl =
                    "https://apps.apple.com/app/id000000000"; // ← replace with your real iOS App ID

                launchUrl(Uri.parse(appStoreUrl),
                    mode: LaunchMode.externalApplication);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: GestureDetector(
          child: AnimatedContainer(
            decoration: BoxDecoration(
              shape: _isScaled ? BoxShape.rectangle : BoxShape.circle,
              color: customcolor.blue,
            ),
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            width: _isScaled ? 1200 : 100,
            height: _isScaled ? 1200 : 100,
            child: Center(
                child: Container(
                    decoration: BoxDecoration(shape: BoxShape.circle),
                    child: Image.asset(
                      'assets/images/mainlogo.png',
                      width: SizeConfig.blockSizeHorizontal * 50,
                    ))),
          ),
        ),
      ),
    );
   
  }
}
