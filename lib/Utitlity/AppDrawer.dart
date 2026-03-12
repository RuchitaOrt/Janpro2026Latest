import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:janpro/Screens/AttendanceTrend.dart';
import 'package:janpro/Screens/Janitormaster.dart';
import 'package:janpro/Screens/Loginscreen.dart';
import 'package:janpro/Screens/Profile.dart';
import 'package:janpro/Screens/SpecialActivity.dart';
import 'package:janpro/Screens/Training.dart';
import 'package:janpro/Utitlity/APIManager.dart';
import 'package:janpro/Utitlity/GlobalLists.dart';
import 'package:janpro/Utitlity/SPManager.dart';
import 'package:janpro/Utitlity/ShowDialog.dart';
import 'package:janpro/Utitlity/custom_color.dart';
import 'package:janpro/Utitlity/internetConnection.dart';
import 'package:janpro/Utitlity/sizeConfig.dart';
import 'package:janpro/model/LogoutResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Screens/OperationVisitCardPage.dart';
import '../Screens/client_operation_visti_card.dart';
import '../Screens/client_visit_view.dart';
import '../Screens/operation_visit_page.dart';

class AppDrawerfilter extends StatefulWidget {
  final String? role;

  AppDrawerfilter(this.role) : super();
  @override
  _AppDrawerfilterState createState() => _AppDrawerfilterState();
}

class _AppDrawerfilterState extends State<AppDrawerfilter> {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  @override
  void initState() {
    super.initState();
    print("PRASAD");
    log(widget.role.toString(), name: 'role');
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Drawer(
      //  ScaffoldState().openDrawer() ,
      child: Container(
        color: customcolor.blue,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 0),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
                shrinkWrap: true,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.close, color: customcolor.white),
                    ),
                  ),
                  SizedBox(height: 40),
                  (widget.role == GlobalLists.headrole ||
                          widget.role == GlobalLists.reginalmanagerrole ||
                          widget.role == GlobalLists.clientrole ||
                          widget.role == GlobalLists.operationrole ||
                          widget.role == GlobalLists.operationmanagerrole)
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        Training(""),
                                  ),
                                );
                              },
                              child: Text(
                                "Training",
                                style: AppFonts.headerStyle(
                                  fontSize: 14,
                                  color: customcolor.white,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Divider(color: customcolor.white),
                            SizedBox(height: 10),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        SpecialActivity(""),
                                  ),
                                );
                              },
                              child: Text(
                                "Special Activity",
                                style: AppFonts.headerStyle(
                                  fontSize: 14,
                                  color: customcolor.white,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            // SizedBox(
                            //   height: 10,
                            // ),
                            // Divider(
                            //   color: customcolor.white,
                            // ),
                            SizedBox(height: 10),
                            widget.role == GlobalLists.operationmanagerrole ||
                                    widget.role == GlobalLists.operationrole ||
                                    widget.role == GlobalLists.headrole ||
                                    widget.role ==
                                        GlobalLists.reginalmanagerrole ||
                                    widget.role == GlobalLists.clientrole
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Divider(color: customcolor.white),
                                      SizedBox(height: 10),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  //  widget.role ==
                                                  // GlobalLists.clientrole?ClientVisitView():
                                                  ClientVisitView(),
                                              // OperationVisitCardPage()
                                            ),
                                          );
                                        },
                                        child: Text(
                                          "Operations Visit",
                                          style: AppFonts.headerStyle(
                                            fontSize: 14,
                                            color: customcolor.white,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                    ],
                                  )
                                : SizedBox(),

                            Divider(color: customcolor.white),
                            SizedBox(height: 10),
                          ],
                        )
                      : Container(),

                  (widget.role == GlobalLists.supervisorrole ||
                          widget.role == GlobalLists.unitrole ||
                          widget.role == GlobalLists.operationrole ||
                          widget.role == GlobalLists.operationmanagerrole)
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        Janitormaster(""),
                                  ),
                                );
                              },
                              child: Text(
                                "Janitor's Master",
                                style: AppFonts.headerStyle(
                                  fontSize: 14,
                                  color: customcolor.white,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Divider(color: customcolor.white),
                            SizedBox(height: 10),
                          ],
                        )
                      : Container(),
                  (widget.role == GlobalLists.operationrole ||
                          widget.role == GlobalLists.operationmanagerrole ||
                          widget.role == GlobalLists.headrole ||
                          widget.role == GlobalLists.clientrole ||
                          widget.role == GlobalLists.reginalmanagerrole)
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        AttendanceTrend(""),
                                  ),
                                );
                              },
                              child: Text(
                                "Attendance Trends",
                                style: AppFonts.headerStyle(
                                  fontSize: 14,
                                  color: customcolor.white,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Divider(color: customcolor.white),
                            SizedBox(height: 10),
                          ],
                        )
                      : Container(),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => Profile(),
                        ),
                      );
                    },
                    child: Text(
                      "Profile",
                      style: AppFonts.headerStyle(
                        fontSize: 14,
                        color: customcolor.white,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Divider(color: customcolor.white),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      dologoutApi();
                    },
                    child: Text(
                      "Logout",
                      style: AppFonts.headerStyle(
                        fontSize: 14,
                        color: customcolor.white,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Divider(color: customcolor.white),
                  SizedBox(height: 10),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 30,
                child: Center(
                  child: Text(
                    "Version 2.0.0",
                    style: TextStyle(color: customcolor.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      // ),
    );
  }

  dologoutApi() async {
    var status1 = await ConnectionDetector.checkInternetConnection();

    if (status1) {
      var map = new Map<String, dynamic>();

      var token = await SPManager().getAuthToken();

      map['token'] = token;

      APIManager().apiRequest(
        context,
        API.logout,
        (response) async {
          LogoutResponse resp = response;

          if (resp.status == 1) {
            // Navigator.of(this.context).pop();
            ShowDialogs.showToast(resp.msg);
            SPManager().setAuthToken("");

            // --- CLEAR AUTH TOKEN & DASHBOARD CACHE ---
            final prefs = await SharedPreferences.getInstance();
            await prefs.remove(
              'unit_dashboard_cache',
            ); // remove cached dashboard
            await prefs.remove('clientdashboardApi');
            await prefs.remove("dashboardApi");
            await SPManager().setAuthToken("");

            // --- RESET GLOBAL FLAGS ---
            setState(() {
              GlobalLists.isloadedAttendance = false;
              GlobalLists.isloadedWokeflow = false;
            });
            GlobalLists.clearAll();

            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) => LoginScreen(),
              ),
            );
            setState(() {
              GlobalLists.isloadedAttendance = false;
              GlobalLists.isloadedWokeflow = false;
            });
            GlobalLists.clearAll();
          } else {
            ShowDialogs.showToast(resp.msg);
            // Navigator.of(this.context).pop();
          }
        },
        (error) {
          print('ERR msg is $error');
          // Navigator.of(this.context).pop();
        },
        false,
        "",
        jsonval: map,
      );
    } else {
      ShowDialogs.showToast("Please check internet connection");
    }
  }
}
