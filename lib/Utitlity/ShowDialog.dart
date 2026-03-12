
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:janpro/Screens/Homepage.dart';
import 'package:janpro/Screens/Loginscreen.dart';
import 'package:janpro/Utitlity/ResponsiveFlutter.dart';
import 'package:janpro/Utitlity/custom_color.dart';
import 'package:janpro/Utitlity/sizeConfig.dart';

class ShowDialogs {
  // static Future<void> showLoadingDialog(BuildContext context, GlobalKey key,
  //     {String message = "Loading, please wait...",
  //     bool setForLightScreen = false}) async {
  //   Future.delayed(
  //     Duration(microseconds: 300),
  //     () {
  //       showLoadingDialogWithDelay(context, key, message, setForLightScreen);
  //     },
  //   );
  // }

  static Widget norecordwidget(double left, double heigth) {
    return Container(
        child:
         Padding(
      padding: EdgeInsets.only(
        left: left,
        top: heigth,
      ),
      child: Text("No records found"),
    )
    );
  }

  static Future<void> showCustomLoadingDialog(
      BuildContext context, String message, GlobalKey key,
      {bool setForLightScreen = false}) async {
    Future.delayed(
      Duration(microseconds: 300),
      () {
        showLoadingDialogWithDelay(context, key, message, setForLightScreen);
      },
    );
  }

  confirmationtatdone(BuildContext context, String status, String time) {
    showModalBottomSheet(
        isDismissible: false,
        
        backgroundColor: Colors.white,
        isScrollControlled: true,
        elevation: 5.0,
        barrierColor: Colors.black.withOpacity(0.7),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(20.0),
              topRight: const Radius.circular(20.0)),
        ),
        context: context,
        builder: (builder) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setStateDialgoue) {
            return new Container(
              height: SizeConfig.blockSizeVertical * 35 +
                  MediaQuery.of(context).viewInsets.bottom,
              color: Colors.white,
              margin: EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 2),
              padding: EdgeInsets.all(5),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 5,
                      ),
                      Center(
                        child: Container(
                          width: 50,
                          child: Divider(
                            thickness: 4,
                            color: customcolor.greytext,
                            height: 2,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      HomePage()));
                        },
                        child: Image.asset(
                          'assets/images/tickmark.png',
                          width: 100,
                          height: 100,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        "${status}",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: customcolor.black,
                            fontSize: 22,
                            fontFamily: AppFonts.semibold,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "${time}",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: customcolor.darkorange,
                            fontSize: 18,
                            fontFamily: AppFonts.semibold,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ],
              ),
            );
          });
        });
  }

//confirmation
  confirmationdone(BuildContext context, String status) {
    showModalBottomSheet(
        isDismissible: false,
        backgroundColor: Colors.white,
        isScrollControlled: true,
        elevation: 5.0,
        barrierColor: Colors.black.withOpacity(0.7),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(20.0),
              topRight: const Radius.circular(20.0)),
        ),
        context: context,
        builder: (builder) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setStateDialgoue) {
            return new Container(
              height: SizeConfig.blockSizeVertical * 35 +
                  MediaQuery.of(context).viewInsets.bottom,
              color: Colors.white,
              margin: EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 2),
              padding: EdgeInsets.all(5),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 5,
                      ),
                      Center(
                        child: Container(
                          width: 50,
                          child: Divider(
                            thickness: 4,
                            color: customcolor.greytext,
                            height: 2,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      HomePage()));
                        },
                        child: Image.asset(
                          'assets/images/tickmark.png',
                          width: 100,
                          height: 100,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        "${status}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: customcolor.black,
                            fontSize: 22,
                            fontFamily: AppFonts.semibold,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ],
              ),
            );
          });
        });
  }

  unAthorizedTokenErrorDialog(BuildContext context, {String? message}) {
    // set up the button
    Widget okButton = ElevatedButton(
        child: Text("OK"),
        onPressed: () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => LoginScreen()));
        });

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Set In The City"),
      content: Text(message!),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static Widget showEmptyView(BuildContext context, String dialogTitle,
      String dialogMessage, Function onYesTap) {
    return Container(
      width: SizeConfig.blockSizeHorizontal * 100,
      // color: Theme.of(context).backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Image.asset('$imageShow'),
          SizedBox(
            height: 10,
          ),
          Text(
            '$dialogTitle',
            style: TextStyle(
                color: customcolor.ligthgrey,
                fontWeight: FontWeight.w400,
                fontSize: 14),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            '$dialogMessage',
            style: TextStyle(
                color: customcolor.ligthgrey,
                fontWeight: FontWeight.w400,
                fontSize: 14),
          ),
          SizedBox(
            height: 20,
          ),
          // RaisedButton(
          //     padding: EdgeInsets.fromLTRB(30.0, 0, 30.0, 0.0),
          //     shape: new RoundedRectangleBorder(
          //         borderRadius: new BorderRadius.circular(15.0)),
          //     color: Colors.white,
          //     child: Text(
          //       'Retry',
          //       style: TextStyle(
          //         color: customcolor.brown,
          //         fontSize: 14.0,
          //       ),
          //     ),
          //     onPressed: onYesTap),
        ],
      ),
    );
  }

  static Future<void> showLoadingDialogcontainer(BuildContext context,
      {String message = "Loading, please wait...",
      bool setForLightScreen = false}) async {
    Future.delayed(
      Duration(microseconds: 300),
      () {
        showLoadingDialogWithDelaycontainer(
            context, message, setForLightScreen);
      },
    );
  }

  static Future<void> showLoadingDialogWithDelay(BuildContext context,
      GlobalKey key, String message, bool setForLightScreen) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Material(
            key: key,
            type: MaterialType.transparency,
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //  CircularProgressIndicator()
                SpinKitCircle(
                    color: setForLightScreen ? Colors.black : Colors.white),
                SizedBox(height: 15),
                Text(message,
                    style: TextStyle(
                        color: setForLightScreen ? Colors.black : Colors.white))
              ],
            )),
          );
        });
  }

  static Future<void> showLoadingDialogWithDelaycontainer(
      BuildContext context, String message, bool setForLightScreen) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Material(
            //  key: key,
            type: MaterialType.transparency,
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //  CircularProgressIndicator()
                SpinKitCircle(
                    color: setForLightScreen ? Colors.black : Colors.white),
                SizedBox(height: 15),
                Text(message,
                    style: TextStyle(
                        color: setForLightScreen ? Colors.black : Colors.white))
              ],
            )),
          );
        });
  }

  static void showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        textColor: customcolor.darkorange,
        backgroundColor: Colors.white,
        fontSize: 14.0);
  }

  static void showSimpleDialog(
      BuildContext context, String dialogTitle, String dialogMessage) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(dialogTitle),
          content: new Text(dialogMessage),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new ElevatedButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static Future<bool> returnShowSMDialog(
      BuildContext context, String dialogTitle, String dialogMessage) async {
    bool status = await showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          titlePadding: EdgeInsets.zero,
          title: Container(
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Colors.orange,
            ),
            child: Center(
              child: Text(
                dialogTitle,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          content: Container(
            //height: 140.0,
            //width: double.infinity-10.0,
            //margin: EdgeInsets.zero,
            padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  child: Text(dialogMessage),
                ),
                SizedBox(
                  height: 20.0,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    //padding: EdgeInsets.fromLTRB(60.0, 10.0, 60.0, 10.0),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0))),
                    // shape: new RoundedRectangleBorder(
                    //     borderRadius: new BorderRadius.circular(30.0)),
                    // color: Colors.orange,
                    child: Text(
                      'OK',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                  ),
                ),
              ],
            ),
          ),
          // actions: <Widget>[
          //   // usually buttons at the bottom of the dialog
          //   new FlatButton(
          //     child: new Text("Close"),
          //     onPressed: () {
          //       Navigator.of(context).pop();
          //     },
          //   ),
          // ],
        );
      },
    );

    return status;
  }

  static Future<bool> showConfirmDialog(BuildContext context,
      String dialogTitle, String dialogMessage, Function() onyes) async {
    bool yesNo = await showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          contentPadding: EdgeInsets.zero,
          titlePadding: EdgeInsets.zero,
          title: Container(
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: customcolor.white,
              borderRadius: new BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 15.0,
                ),
                Container(
                  child: Text(
                    '$dialogMessage',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: customcolor.blue,
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
              ],
            ),
          ),
          content: Container(
            height: 80,
            //width: double.infinity-10.0,
            //  color: customcolor.greybackground1,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.only(
                  bottomLeft: Radius.circular(15.0),
                  bottomRight: Radius.circular(15.0)),
            ),
            margin: EdgeInsets.zero,
            // padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ignore: deprecated_member_use
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(15.0))),
                      // shape: new RoundedRectangleBorder(
                      //     borderRadius: new BorderRadius.circular(15.0)),
                      // color: Colors.white,
                      child: Text(
                        'Yes',
                        style: TextStyle(
                          color: customcolor.blue,
                          fontSize: 14.0,
                        ),
                      ),
                      onPressed: onyes,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    // ignore: deprecated_member_use
                    ElevatedButton(
                      //padding: EdgeInsets.fromLTRB(60.0, 10.0, 60.0, 10.0),

                      style: ElevatedButton.styleFrom(
                          backgroundColor: customcolor.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(15.0))),
                      // shape: new RoundedRectangleBorder(
                      //     borderRadius: new BorderRadius.circular(15.0)),
                      // color: customcolor.appbarcolor,
                      child: Text(
                        'No',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
    return yesNo;
  }

  static Future<bool> showConfirmDialogdelete(BuildContext context,
      String dialogTitle, String dialogMessage, Function() onYesTap) async {
    bool yesNo = await showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          contentPadding: EdgeInsets.zero,
          titlePadding: EdgeInsets.zero,

          content: Container(
            height: 180,
            //width: double.infinity-10.0,
            //  color: customcolor.greybackground1,
            decoration: BoxDecoration(
              color: customcolor.greybg,
              borderRadius: new BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                  bottomLeft: Radius.circular(15.0),
                  bottomRight: Radius.circular(15.0)),
            ),
            margin: EdgeInsets.zero,
            padding: EdgeInsets.fromLTRB(10.0, 10.0, 20.0, 10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    '$dialogMessage',
                    style: TextStyle(color: customcolor.black, fontSize: 14),
                  ),
                ),
                SizedBox(
                  height: 25.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(30.0, 0, 30.0, 0.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(15.0))),
                        // shape: new RoundedRectangleBorder(
                        //     borderRadius: new BorderRadius.circular(15.0)),
                        // color: Colors.white,
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: customcolor.darkorange,
                            fontSize: 14.0,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(30.0, 0, 30.0, 0.0),
                      child: ElevatedButton(
                        //padding: EdgeInsets.fromLTRB(60.0, 10.0, 60.0, 10.0),

                        // shape: new RoundedRectangleBorder(
                        //     borderRadius: new BorderRadius.circular(15.0)),
                        // color: customcolor.darkorange,

                        style: ElevatedButton.styleFrom(
                            backgroundColor: customcolor.darkorange,
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(15.0))),
                        child: Text(
                          'Yes, Remove',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                          ),
                        ),
                        onPressed: onYesTap,
                        // onPressed: () async {
                        //   // storage.delete(key: "token");

                        //   Navigator.of(context).pushAndRemoveUntil(
                        //     // the new route
                        //     MaterialPageRoute(
                        //       builder: (BuildContext context) => Login(),
                        //     ),
                        //     (Route route) => false,
                        //   );
                        // },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // actions: <Widget>[
          // usually buttons at the bottom of the dialog
        );
      },
    );
    return yesNo;
  }

  static void showSMDialog(
      BuildContext context, String dialogTitle, String dialogMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          titlePadding: EdgeInsets.zero,
          title: Container(
            padding: EdgeInsets.all(3.0),
            // decoration: BoxDecoration(
            //   color: Colors.blue,
            // ),
            // child: Center(
            //   child: Text(
            //     dialogTitle,
            //     style: TextStyle(
            //       color: Colors.white,
            //     ),
            //   ),
            // ),
          ),
          content: Container(
            //height: 140.0,
            //width: double.infinity-10.0,
            //margin: EdgeInsets.zero,
            padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Card(
                  color: customcolor.skybluebg,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                    child: Text(
                      "${dialogMessage}",
                      style: AppFonts.headerStyle(
                          fontSize: ResponsiveFlutter.of(context).fontSize(1.4),
                          color: customcolor.black,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                ElevatedButton(
                  //padding: EdgeInsets.fromLTRB(60.0, 10.0, 60.0, 10.0),
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(SizeConfig.blockSizeHorizontal * 28,
                          SizeConfig.blockSizeVertical * 3),
                      backgroundColor: customcolor.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0))),
                  // shape: new RoundedRectangleBorder(
                  //     borderRadius: new BorderRadius.circular(30.0)),
                  // color: Colors.orange,
                  child: Text(
                    'Back',
                    style: TextStyle(
                      color: customcolor.white,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
          // actions: <Widget>[
          //   // usually buttons at the bottom of the dialog
          //   new FlatButton(
          //     child: new Text("Close"),
          //     onPressed: () {
          //       Navigator.of(context).pop();
          //     },
          //   ),
          // ],
        );
      },
    );
  }
}
