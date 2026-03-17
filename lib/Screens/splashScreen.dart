import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:janpro/Screens/Homepage.dart';
import 'package:janpro/Screens/Loginscreen.dart';
import 'package:janpro/Utitlity/SPManager.dart';
import 'package:janpro/Utitlity/UtilityFile.dart';
import 'package:janpro/Utitlity/custom_color.dart';
import 'package:janpro/Utitlity/sizeConfig.dart';

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
    //        scaleController = AnimationController(
    //     vsync: this,
    //     duration: Duration(milliseconds: 800),
    //   )..addStatusListener(
    //       (status) {
    //         if (status == AnimationStatus.completed) {
    //       // Navigator.push(
    //       //       context,
    //       //       PageRouteBuilder(
    //       //         pageBuilder: (context, animation1, animation2) =>
    //       //             HomePage(),
    //       //         transitionDuration: Duration(seconds: 0),
    //       //       ),
    //       //     );

    // Navigator.pushReplacement(
    //             context, MaterialPageRoute(builder: (context) => HomePage()));
    //     //  getstatus();
    Timer(
      Duration(milliseconds: 300),
      () {
        setState(() {
          _isScaled = true;
        });
        //scaleController.reset();
      },
    );
    //         }
    //       },
    //     );

    //   scaleAnimation =
    //       Tween<double>(begin: 0.0, end: 6).animate(scaleController);

    //   Timer(Duration(milliseconds: 600), () {
    //     setState(() {
    //       _opacity = 1.0;
    //       _value = false;
    //     });
    //   });
    //   Timer(Duration(milliseconds: 600), () {
    //     setState(() {
    //       scaleController.forward();
    //     });
    //   });

    getstatus();
  }

  getstatus() async {
    String? gettotken = await SPManager().getAuthToken();
    print("Auth TOKEN ON SPLASH $gettotken");
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
    // TODO: implement dispose
    print("object");

    scaleController.dispose();

    super.dispose();
  }

// @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [

//           Center(
//             child: AnimatedOpacity(
//               curve: Curves.fastLinearToSlowEaseIn,
//               duration: Duration(seconds: 0),
//               opacity: _opacity,
//               child: AnimatedContainer(
//                 curve: Curves.fastLinearToSlowEaseIn,
//                 duration: Duration(milliseconds: 0),
//                 height: _value ? 100 : 200,
//                 width: _value ? 100 : 200,
//                 decoration: BoxDecoration(
//                   // boxShadow: [
//                   //   BoxShadow(
//                   //     color: Colors.deepPurpleAccent.withOpacity(.2),
//                   //     blurRadius: 100,
//                   //     spreadRadius: 10,
//                   //   ),
//                   // ],
//                   color: customcolor.blue,
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: AnimatedBuilder(
//                   animation: scaleAnimation,
//                   builder: (c, child) => Transform.scale(
//                     scale: scaleAnimation.value,
//                     child: Material(
//       type: MaterialType.transparency,
//       child: Container(
//         width: SizeConfig.blockSizeHorizontal*100,
//         height: SizeConfig.blockSizeVertical*100,
//         color: customcolor.blue,

//       ),
//     )
//                   ),
//                 ),
//               ),
//             ),
//           ),
//            Center(
//              child: Padding(
//                      padding: const EdgeInsets.all(40.0),
//                      child: Image.asset('assets/images/mainlogo.png',width: 150,height: 150,),
//                    ),
//            ),
//         ],
//       ),
//     );
//   }
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
    // Material(
    //   type: MaterialType.transparency,
    //   child: Container(

    //     color: customcolor.blue,

    //     child: Stack(
    //       children: [
    //         Column(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           crossAxisAlignment: CrossAxisAlignment.center,
    //           children: <Widget>[
    //             Center(child: Image.asset('assets/images/mainlogo.png',width: SizeConfig.blockSizeHorizontal*50,)),

    //           ],
    //         ),

    //       ],
    //     ),
    //   ),
    // );
  }
}
