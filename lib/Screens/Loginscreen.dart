import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:janpro/Screens/Homepage.dart';
import 'package:janpro/Utitlity/APIManager.dart';
import 'package:janpro/Utitlity/FormTextField.dart';
import 'package:janpro/Utitlity/GlobalLists.dart';
import 'package:janpro/Utitlity/SPManager.dart';
import 'package:janpro/Utitlity/ShowDialog.dart';
import 'package:janpro/Utitlity/custom_color.dart';
import 'package:janpro/Utitlity/internetConnection.dart';
import 'package:janpro/Utitlity/sizeConfig.dart';
import 'package:janpro/model/LoginResponse.dart';

import '../main.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var emailcontroller = TextEditingController();
  var passcontroller = TextEditingController();
  var focusotp = FocusNode();
  bool ismobileenter = false;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  bool timerstart = true;
  bool showresendotp = false;
  final GlobalKey<State> _keyLoaderotp = new GlobalKey<State>();
  final interval = const Duration(seconds: 1);
  bool issendotpclick = false;
  bool showtimer = false;
  bool otprecieved = false;
  bool passwordVisible = true;
  final int timerMaxSeconds = 180;

  // final int timerMaxSeconds60 = 60;

  int currentSeconds = 0;
  Timer? _timer;

  String get timerText =>
      '${((timerMaxSeconds - currentSeconds) ~/ 60).toString().padLeft(2, '0')}: ${((timerMaxSeconds - currentSeconds) % 60).toString().padLeft(2, '0')}';

  startTimeout([int? milliseconds]) {
    var duration = interval;
    _timer = Timer.periodic(duration, (timer) {
      setState(() {
        timerstart = true;
        print(timer.tick);
        currentSeconds = timer.tick;
        if (timer.tick >= timerMaxSeconds) {
          timer.cancel();
          timerstart = false;
        }
      });
    });
    print(_timer);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return await false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true, // card not moves upward
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: customcolor.blue,
              ),
            ),
            Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: SizeConfig.blockSizeVertical * 14,
                    //  right: SizeConfig.blockSizeHorizontal * 14
                  ),
                  child: Image.asset(
                    'assets/images/mainlogo.png',
                    width: 240,
                    height: 140,
                  ),
                )),
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: SizeConfig.blockSizeVertical * 58,
                  width: SizeConfig.blockSizeHorizontal * 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40)),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 30, top: 30, right: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                                height: 30,
                              ),
                              Text(
                                "Login",
                                textAlign: TextAlign.left,
                                style: AppFonts.headerStyle(
                                    fontSize: 28,
                                    color: customcolor.black,
                                    fontWeight: FontWeight.w400),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Stack(
                                children: [
                                  FormTextField(
                                    textcontroller: emailcontroller,
                                    placeholderStr: "Email",
                                    lengthofmobile: 100,
                                    textInputType: TextInputType.emailAddress,
                                    onchange: (val) {},
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              FormTextField(
                                obscuretext: passwordVisible,
                                textcontroller: passcontroller,
                                textInputType: TextInputType.text,
                                focusNode: focusotp,
                                placeholderStr: "Password",
                                suffixWidget: IconButton(
                                  icon: Icon(
                                    passwordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: customcolor.blue,
                                  ),
                                  onPressed: () {
                                    setState(
                                      () {
                                        passwordVisible = !passwordVisible;
                                      },
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Visibility(
                                      visible: false,
                                      child: GestureDetector(
                                        onTap: () {},
                                        child: Text(
                                          'Forget password',
                                          style: AppFonts.headerStyle(
                                              fontSize: 12,
                                              color: customcolor.blue,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Column(
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: customcolor.blue,
                                  minimumSize: Size(
                                      SizeConfig.blockSizeHorizontal * 80,
                                      SizeConfig.blockSizeVertical * 6),
                                  textStyle: AppFonts.headerStyle(
                                      fontSize: 15,
                                      color: customcolor.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                onPressed: () {
                                  String mobile_patttern =
                                      r'(^(?:[+0]9)?[0-9]{10}$)';
                                  RegExp regexmobile =
                                      new RegExp(mobile_patttern);

                                  dologinApi();
                                },
                                child:doLoginLoader?CircularProgressIndicator(color: customcolor.white,): Text(
                                  'Login',
                                  style: AppFonts.headerStyle(
                                      fontSize: 14,
                                      color: customcolor.white,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                height: 60,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
bool doLoginLoader=false;
  dologinApi() async {
    print('dologinApi }');
    var status1 = await ConnectionDetector.checkInternetConnection();

    if (status1) {
       print('status1 }');
      if (emailcontroller.text.trim().isEmpty ||
          emailcontroller.text.trim().isEmpty) {
        ShowDialogs.showToast("Please enter details");
      } else {
        // ShowDialogs.showLoadingDialog(context, _keyLoader);
setState(() {
  doLoginLoader=true;
});
        var map = new Map<String, dynamic>();

        var fcmtoken = await SPManager().getfcmAuthToken();
        map['emp_email_id'] = emailcontroller.text.trim().toString();
        map['password'] = passcontroller.text.trim().toString();
        map['fcm_token'] = fcmtoken;
        print("FCM TOKEN ON Login $fcmtoken");

        APIManager().apiRequest(context, API.login, (response) async {
          LoginResponse resp = response;
          print('called API ${resp}');
          if (resp.status == 1) {
            setState(() {
  doLoginLoader=false;
});
            // Navigator.of(this.context).pop();
            ShowDialogs.showToast(resp.msg);
            log('resp.msg ${resp.msg}');
            SPManager().setAuthToken(resp.token);
             SPManager().setRMID(resp.data.rm_id);
            SPManager().setsupervisorid(resp.data.id.toString());
            GlobalLists.role = resp.data.empType.toString();
            log(GlobalLists.role, name: 'role');
            SPManager().setroleid(resp.data.empType.toString());
            SPManager().setclientid(resp.data.id.toString());

            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) => HomePage(),
              ),
            );
          } else {
            ShowDialogs.showToast(resp.msg);
            setState(() {
  doLoginLoader=false;
});
            // Navigator.of(this.context).pop();
          }
        }, (error) {
          print('ERR msg is $error');
          ShowDialogs.showToast("Invalid Credential");
          setState(() {
  doLoginLoader=false;
});
          // Navigator.of(this.context).pop();
        }, false, "", jsonval: map);
      }
    } else {
      print('Please check internet connection');
      ShowDialogs.showToast("Please check internet connection");
    }
  }
}
