import 'dart:ui';

import 'package:flutter/cupertino.dart';


class customcolor {
  
   // static const textyellow = const Color(0xffFFAE00);
   static const textyellow = const Color(0xffFF961F);
   static const textblue = const Color(0xff5C83B8);
static const tabblue = const Color(0xff146FF8);
  
 static const skyblue = Color(0xffDEEBFF);
   
  static const darkorange = const Color(0xffE88535);
  static const ligthgrey = const Color(0xffB6B4B4);
  static const darkgrey = const Color(0xff969494);
  static const black = const Color(0xff000000);
  static const white = const Color(0xffFFFFFF);
  static const appbarcolor = const Color(0xffFF961F);
  static const textorangecolor = const Color(0xffFF961F);
  static const blue = const Color(0xff003DA5);
  static const green = const Color(0xff78BE21);
  static const lightgreen = const Color(0xffEBFED3);
  
  static const purple = const Color(0xff5B0097);
  static const greybg = const Color(0xffEFEFEF);
  static const greyhome = const Color(0x0000001F);
  static const greyborder = const Color(0xffE4E0E0);
  static const greytext = const Color(0xffB4B4B4);
  static const gradientgrey = const Color(0xffA4A4A4);
  static const gradientblack = const Color(0xff242424);
  static const greypara = const Color(0xff707070);
  static const pricevalue = const Color(0x00000080);
  static const pink = const Color(0xffFFCDA2);
  static const bg = const Color(0xffFFF5EC);
   static const hinttext = const Color(0xffBCBCBC);
     static const skybluebg = const Color(0xffF1F6FF);
     static const red = const Color(0xffFB4242);
     static const yellow = const Color(0xffFFBB34);

     static const title=const Color(0xff222222);
     static const subtitle=const Color(0xff707070);
     
     
}

class AppFonts {
    static String regular = "Montserrat-Regular";
  static String semibold = "Montserrat-SemiBold";
  
  static String semibolditalic = "Montserrat-SemiBoldItalic";
  static String light = "Montserrat-Light";
  static String medium = "Montserrat-Mediun";


  //Didot
  //  static String didotheading = "Didot LT Std Italic";
  //   static String didotmediun = "Didot-Medium";
  //    static String didotregular = "Didot-Regular";
  //    static String didotbold ="Didot-LT-Std-Bold";
    
    
     static String didot ="LibreBodoni";//"Bodoni";//"LibreBodoni";//"Didot";//

  // GoogleFonts.gfsDidot(

     static TextStyle headerStyle({
    required double fontSize,
    Color? color,
    required FontWeight fontWeight,
  }) =>
  // GoogleFonts.gfsDidot(
  //  //letterSpacing: 1,
  //    fontSize: fontSize,
  //         color: color ,
  //         fontWeight: fontWeight,
  // );
// GoogleFonts.gfsLibreBodoni(
    
        //textStyle: 
        TextStyle(
          // letterSpacing: 1,
          fontFamily: AppFonts.didot,
          fontSize: fontSize,
          color: color ,
          fontWeight: fontWeight,
        // ),
      );
         static TextStyle headerwithletterStyle({
    required double fontSize,
    double? letterSpacing,
    Color? color,
    required FontWeight fontWeight,
  }) =>
  // GoogleFonts.gfsDidot(
  //  //letterSpacing: 1,
  //    fontSize: fontSize,
  //         color: color ,
  //         fontWeight: fontWeight,
  // );
// GoogleFonts.gfsLibreBodoni(
    
        //textStyle: 
        TextStyle(
          letterSpacing: letterSpacing,
          fontFamily: AppFonts.didot,
          fontSize: fontSize,
          color: color ,
          fontWeight: fontWeight,
        // ),
      );

}
  

class textstyleclass {
  static TextStyle unselectedtext(BuildContext? context) {
    return TextStyle(
        color: customcolor.greytext,
        fontWeight: FontWeight.w400,
        fontSize: 16,
        fontFamily: AppFonts.semibold);
  }

  static TextStyle selectedcount(BuildContext? context) {
    return TextStyle(
        color: customcolor.darkorange,
        fontWeight: FontWeight.w300,
        fontSize: 12,
        fontFamily: AppFonts.regular);
  }

  static TextStyle selectedtext(BuildContext context) {
    return TextStyle(
        color: customcolor.white,
        fontWeight: FontWeight.w700,
        fontSize: 16,
        fontFamily: AppFonts.semibold);
  }

  static TextStyle titletext(BuildContext context) {
    return TextStyle(
        color: customcolor.darkorange,
        fontSize: 17,
        fontFamily: AppFonts.semibold,
        fontWeight: FontWeight.w400);
  }

  static TextStyle selheadingtabtext(BuildContext context) {
    return TextStyle(
        color: customcolor.darkorange,
        fontSize: 14,
        fontFamily: AppFonts.semibold,
        fontWeight: FontWeight.w400);
  }

  static TextStyle unselheadingtabtext(BuildContext context) {
    return TextStyle(
        color: customcolor.darkgrey,
        fontSize: 14,
        fontFamily: AppFonts.semibold,
        fontWeight: FontWeight.w400);
  }

  static TextStyle headingtext(BuildContext context) {
    return TextStyle(
        color: customcolor.darkorange,
        fontSize: 20,
        fontFamily: AppFonts.semibold,
        fontWeight: FontWeight.w500);
  }

  static TextStyle personaltitletext(BuildContext context) {
    return TextStyle(
        color: customcolor.darkorange,
        fontSize: 15,
        fontFamily: AppFonts.medium,
        fontWeight: FontWeight.w400);
  }
}

// import 'dart:ui';
 
// import 'package:flutter/cupertino.dart';
// import 'package:google_fonts/google_fonts.dart';
 
// class customcolor {
 
//    // static const textyellow = const Color(0xffFFAE00);
//    static const textyellow = const Color(0xffFF961F);
//    static const textblue = const Color(0xff5C83B8);
// static const tabblue = const Color(0xff146FF8);
 
//  static const skyblue = Color(0xffDEEBFF);
   
//   static const darkorange = const Color(0xffE88535);
//   static const ligthgrey = const Color(0xffB6B4B4);
//   static const darkgrey = const Color(0xff969494);
//   static const black = const Color(0xff000000);
//   static const white = const Color(0xffFFFFFF);
//   static const appbarcolor = const Color(0xffFF961F);
//   static const textorangecolor = const Color(0xffFF961F);
//   static const blue = const Color(0xff003DA5);
//   static const green = const Color(0xff78BE21);
//   static const lightgreen = const Color(0xffEBFED3);
 
//   static const purple = const Color(0xff5B0097);
//   static const greybg = const Color(0xffEFEFEF);
//   static const greyhome = const Color(0x0000001F);
//   static const greyborder = const Color(0xffE4E0E0);
//   static const greytext = const Color(0xffB4B4B4);
//   static const gradientgrey = const Color(0xffA4A4A4);
//   static const gradientblack = const Color(0xff242424);
//   static const greypara = const Color(0xff707070);
//   static const pricevalue = const Color(0x00000080);
//   static const pink = const Color(0xffFFCDA2);
//   static const bg = const Color(0xffFFF5EC);
//    static const hinttext = const Color(0xffBCBCBC);
//      static const skybluebg = const Color(0xffF1F6FF);
//      static const red = const Color(0xffFB4242);
//      static const yellow = const Color(0xffFFBB34);
 
//      static const title=const Color(0xff222222);
//      static const subtitle=const Color(0xff707070);
     
     
// }
 
// class AppFonts {
//     static String regular = "Montserrat-Regular";
//   static String semibold = "Montserrat-SemiBold";
 
//   static String semibolditalic = "Montserrat-SemiBoldItalic";
//   static String light = "Montserrat-Light";
//   static String medium = "Montserrat-Mediun";
 
 
//   //Didot
//   //  static String didotheading = "Didot LT Std Italic";
//   //   static String didotmediun = "Didot-Medium";
//   //    static String didotregular = "Didot-Regular";
//   //    static String didotbold ="Didot-LT-Std-Bold";
   
   
//      static String didot ="LibreBodoni";//"Bodoni";//"LibreBodoni";//"Didot";//
 
//   // GoogleFonts.gfsDidot(
 
//      static TextStyle headerStyle({
//     required double fontSize,
//     Color? color,
//     required FontWeight fontWeight,
//   }) =>
//   // GoogleFonts.gfsDidot(
//   //  //letterSpacing: 1,
//   //    fontSize: fontSize,
//   //         color: color ,
//   //         fontWeight: fontWeight,
//   // );
// // GoogleFonts.gfsLibreBodoni(
   
//         //textStyle:
//         TextStyle(
//           // letterSpacing: 1,
//           fontFamily: AppFonts.didot,
//           fontSize: fontSize,
//           color: color ,
//           fontWeight: fontWeight,
//         // ),
//       );
//          static TextStyle headerwithletterStyle({
//     required double fontSize,
//     double? letterSpacing,
//     Color? color,
//     required FontWeight fontWeight,
//   }) =>
//   // GoogleFonts.gfsDidot(
//   //  //letterSpacing: 1,
//   //    fontSize: fontSize,
//   //         color: color ,
//   //         fontWeight: fontWeight,
//   // );
// // GoogleFonts.gfsLibreBodoni(
   
//         //textStyle:
//         TextStyle(
//           letterSpacing: letterSpacing,
//           fontFamily: AppFonts.didot,
//           fontSize: fontSize,
//           color: color ,
//           fontWeight: fontWeight,
//         // ),
//       );
 
// }
 
 
// class textstyleclass {
//   static TextStyle unselectedtext(BuildContext? context) {
//     return TextStyle(
//         color: customcolor.greytext,
//         fontWeight: FontWeight.w400,
//         fontSize: 16,
//         fontFamily: AppFonts.semibold);
//   }
 
//   static TextStyle selectedcount(BuildContext? context) {
//     return TextStyle(
//         color: customcolor.darkorange,
//         fontWeight: FontWeight.w300,
//         fontSize: 12,
//         fontFamily: AppFonts.regular);
//   }
 
//   static TextStyle selectedtext(BuildContext context) {
//     return TextStyle(
//         color: customcolor.white,
//         fontWeight: FontWeight.w700,
//         fontSize: 16,
//         fontFamily: AppFonts.semibold);
//   }
 
//   static TextStyle titletext(BuildContext context) {
//     return TextStyle(
//         color: customcolor.darkorange,
//         fontSize: 17,
//         fontFamily: AppFonts.semibold,
//         fontWeight: FontWeight.w400);
//   }
 
//   static TextStyle selheadingtabtext(BuildContext context) {
//     return TextStyle(
//         color: customcolor.darkorange,
//         fontSize: 14,
//         fontFamily: AppFonts.semibold,
//         fontWeight: FontWeight.w400);
//   }
 
//   static TextStyle unselheadingtabtext(BuildContext context) {
//     return TextStyle(
//         color: customcolor.darkgrey,
//         fontSize: 14,
//         fontFamily: AppFonts.semibold,
//         fontWeight: FontWeight.w400);
//   }
 
//   static TextStyle headingtext(BuildContext context) {
//     return TextStyle(
//         color: customcolor.darkorange,
//         fontSize: 20,
//         fontFamily: AppFonts.semibold,
//         fontWeight: FontWeight.w500);
//   }
 
//   static TextStyle personaltitletext(BuildContext context) {
//     return TextStyle(
//         color: customcolor.darkorange,
//         fontSize: 15,
//         fontFamily: AppFonts.medium,
//         fontWeight: FontWeight.w400);
//   }
// }