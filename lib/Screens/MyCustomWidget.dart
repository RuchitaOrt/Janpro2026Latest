// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:janpro/Screens/Homepage.dart';
// import 'package:janpro/Utitlity/UtilityFile.dart';
// import 'package:janpro/Utitlity/sizeConfig.dart';

// class ScaleAnimationExample extends StatefulWidget {
//   @override
//   _ScaleAnimationExampleState createState() => _ScaleAnimationExampleState();
// }

// class _ScaleAnimationExampleState extends State<ScaleAnimationExample> {
//   bool _isScaled = false;

//   void _toggleScale() {
//     setState(() {
//       _isScaled = !_isScaled;
//     });
//   }
// @override
//   void initState() {
//      Utility().loadAPIConfig(context);
//     // TODO: implement initState
//     // Timer(
//     //           Duration(seconds: 1),
//     //           () {
//     //          setState(() {
//     //             _isScaled=true;
//     //          });
//     //         //  Navigator.push(
//     //         //   context,
//     //         //   PageRouteBuilder(
//     //         //     pageBuilder: (context, animation1, animation2) =>
//     //         //         HomePage(),
//     //         //     transitionDuration: Duration(seconds: 0),
//     //         //   ),
//     //         // );
          
            
//     //           },

//     //         );

//              Timer(
//             Duration(seconds: 2),
//                 () => Navigator.push(
//               context,
//               PageRouteBuilder(
//                 pageBuilder: (context, animation1, animation2) =>
//                     HomePage(),
//                 transitionDuration: Duration(seconds: 0),
//               ),
//             ));
           
//     super.initState();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
     
//       body: Center(
//         child: GestureDetector(
//           onTap: _toggleScale,
//           child: Container(
//             // duration: Duration(seconds: 1),
//             // curve: Curves.easeInOut,
//             // width: _isScaled ? 800 : 100,
//             // height: _isScaled ? 800 : 100,
//             color: Colors.blue,
//             child: Center(
//               child: Text(
//                 'Scaled Content',
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


// // void main() {
// //   runApp(MaterialApp(R
// //     home: ScaleAnimationExample(),
// //   ));
// // }


// // import 'dart:async';
// // import 'package:animations/animations.dart';
// // import 'package:flutter/material.dart';
// // import 'package:janpro/Screens/Loginscreen.dart';
// // import 'package:janpro/Utitlity/custom_color.dart';
// // import 'package:janpro/Utitlity/sizeConfig.dart';


// // class SecondClass extends StatefulWidget {
// //   @override
// //   _SecondClassState createState() => _SecondClassState();
// // }

// // class _SecondClassState extends State<SecondClass>
// //     with TickerProviderStateMixin {
// //   late AnimationController scaleController;
// //   late Animation<double> scaleAnimation;

// //   double _opacity = 0;
// //   bool _value = true;

// //   @override
// //   void initState() {
// //     super.initState();

// //     scaleController = AnimationController(
// //       vsync: this,
// //       duration: Duration(milliseconds: 800),
// //     )..addStatusListener(
// //         (status) {
// //           if (status == AnimationStatus.completed) {
// //              Timer(
// //               Duration(milliseconds: 300),
// //               () {
// //                 scaleController.reset();
// //               },
// //             );
// //         Navigator.push(

// //               context,
// //               PageRouteBuilder(
// //                 pageBuilder: (context, animation1, animation2) =>
// //                     LoginScreen(),
// //                 transitionDuration: Duration(seconds: 0),
// //               ),
// //             );
           
// //           }
// //         },
// //       );

// //     scaleAnimation =
// //         Tween<double>(begin: 0.0, end: 6).animate(scaleController);

// //     Timer(Duration(milliseconds: 600), () {
// //       setState(() {
// //         _opacity = 1.0;
// //         _value = false;
// //       });
// //     });
// //     Timer(Duration(milliseconds: 600), () {
// //       setState(() {
// //         scaleController.forward();
// //       });
// //     });
// //   }

// //   @override
// //   void dispose() {
// //     // TODO: implement dispose
// //     scaleController.dispose();
// //     super.dispose();
// //   }


// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: Stack(
// //         children: [
         
// //           Center(
// //             child: AnimatedOpacity(
// //               curve: Curves.fastLinearToSlowEaseIn,
// //               duration: Duration(seconds: 0),
// //               opacity: _opacity,
// //               child: AnimatedContainer(
// //                 curve: Curves.fastLinearToSlowEaseIn,
// //                 duration: Duration(milliseconds: 0),
// //                 height: _value ? 100 : 200,
// //                 width: _value ? 100 : 200,
// //                 decoration: BoxDecoration(
// //                   // boxShadow: [
// //                   //   BoxShadow(
// //                   //     color: Colors.deepPurpleAccent.withOpacity(.2),
// //                   //     blurRadius: 100,
// //                   //     spreadRadius: 10,
// //                   //   ),
// //                   // ],
// //                   color: customcolor.blue,
// //                   borderRadius: BorderRadius.circular(20),
// //                 ),
// //                 child: AnimatedBuilder(
// //                   animation: scaleAnimation,
// //                   builder: (c, child) => Transform.scale(
// //                     scale: scaleAnimation.value,
// //                     child: Material(
// //       type: MaterialType.transparency,
// //       child: Container(
// //         width: SizeConfig.blockSizeHorizontal*100,
// //         height: SizeConfig.blockSizeVertical*100,
// //         color: customcolor.blue,
        
       
// //       ),
// //     )
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           ),
// //            Center(
// //              child: Padding(
// //                      padding: const EdgeInsets.all(40.0),
// //                      child: Image.asset('assets/images/mainlogo.png',width: 150,height: 150,),
// //                    ),
// //            ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // class ThisIsFadeRoute extends PageRouteBuilder {
// //   final Widget page;
// //   final Widget route;

// //   ThisIsFadeRoute({required this.page, required this.route})
// //       : super(
// //           pageBuilder: (
// //             BuildContext context,
// //             Animation<double> animation,
// //             Animation<double> secondaryAnimation,
// //           ) =>
// //               page,
// //           transitionsBuilder: (
// //             BuildContext context,
// //             Animation<double> animation,
// //             Animation<double> secondaryAnimation,
// //             Widget child,
// //           ) =>
// //               FadeTransition(
// //             opacity: animation,
// //             child: route,
// //           ),
// //         );
// // }

// // class ThirdPage extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Go Back'),
// //         centerTitle: true,
// //         brightness: Brightness.dark,
// //         backgroundColor: Colors.deepPurpleAccent,
// //       ),
// //     );
// //   }
// // }