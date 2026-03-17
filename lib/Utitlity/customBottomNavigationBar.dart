// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:janpro/Screens/Attendance.dart';
import 'package:janpro/Screens/Complaint.dart';
import 'package:janpro/Screens/Homepage.dart';
import 'package:janpro/Screens/Profile.dart';
import 'package:janpro/Screens/Rating.dart';
import 'package:janpro/Screens/WorkflowstatusOperation.dart';
import 'package:janpro/Utitlity/GlobalLists.dart';
import 'package:janpro/Utitlity/SPManager.dart';
import 'package:page_transition/page_transition.dart';
import 'package:janpro/Utitlity/custom_color.dart';
import 'package:janpro/Utitlity/sizeConfig.dart';
//supervisor 1
//unit 2
//head 3
//operation 4
//client 5

class CustomBottomNavigationBar extends StatefulWidget {
  final int? index;

  CustomBottomNavigationBar({this.index});

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _selectedIndex = 0;
  String? role = "1";

  Map<DateTime, List> _events = {};

  @override
  void initState() {
    super.initState();
    getrole();
    _selectedIndex = widget.index!;
  }

  getrole() async {
    role = await SPManager().getroleid();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
   

    return Material(
      elevation: 20,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          topLeft: Radius.circular(30),
        ),
        side: BorderSide(width: 0.5, color: customcolor.greyborder),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(30),
          topLeft: Radius.circular(30),
        ),
        child: BottomAppBar(
          //bottom navigation bar on scaffold
          color: customcolor.white,
          elevation: 10,
          shape: CircularNotchedRectangle(),
          //shape of notch
          notchMargin: 5,
          //notche margin between floating button and bottom appbar
          child: Padding(
            padding:
                const EdgeInsets.only(left: 5, right: 20, top: 10, bottom: 5),
            child: role == GlobalLists.unitrole
                ? Row(
                    //children inside bottom appbar
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          _onItemTapped(0);
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.fade,
                              child: Attendance("OverAll"),
                              duration: Duration(milliseconds: 300),
                            ),
                          );
                        },
                        child: Container(
                            color: Colors.transparent,
                            height: SizeConfig.blockSizeHorizontal * 14,
                            child: Column(
                              children: [
                                _selectedIndex == 0
                                    ? Image.asset(
                                        "assets/images/blueattendance.png",
                                        width: 20,
                                        height: 20,
                                      )
                                    : Image.asset(
                                        "assets/images/greyattendance.png",
                                        width: 20,
                                        height: 20,
                                      ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  "Attendance",
                                  style: AppFonts.headerStyle(
                                      fontSize: 12,
                                      color: _selectedIndex == 0
                                          ? customcolor.tabblue
                                          : customcolor.hinttext,
                                      fontWeight: FontWeight.normal),
                                )
                              ],
                            )),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: SizeConfig.blockSizeHorizontal * 4,
                            top: SizeConfig.blockSizeVertical * 0.5),
                        child: GestureDetector(
                          onTap: () {
                            _onItemTapped(4);
                            Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.fade,
                                  child: HomePage(),
                                  duration: Duration(milliseconds: 300),
                                ));
                          },
                          child: Container(
                              color: Colors.transparent,
                              height: SizeConfig.blockSizeHorizontal * 14,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: SizeConfig.blockSizeHorizontal * 7,
                                  ),
                                  Text(
                                    "Home",
                                    style: AppFonts.headerStyle(
                                        fontSize: 12,
                                        color: _selectedIndex == 4
                                            ? customcolor.tabblue
                                            : customcolor.hinttext,
                                        fontWeight: FontWeight.normal),
                                  )
                                ],
                              )),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _onItemTapped(1);
                          Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.fade,
                                child: Complaint(
                                    false, "", "", "", "", "", "", "", false),
                                duration: Duration(milliseconds: 300),
                              ));
                        },
                        child: Container(
                            color: Colors.transparent,
                            height: SizeConfig.blockSizeHorizontal * 14,
                            child: Column(
                              children: [
                                _selectedIndex == 2
                                    ? Image.asset(
                                        "assets/images/blueticket.png",
                                        width: 20,
                                        height: 20,
                                      )
                                    : Image.asset(
                                        "assets/images/greyticket.png",
                                        width: 20,
                                        height: 20,
                                      ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  "Complaints",
                                  style: AppFonts.headerStyle(
                                      fontSize: 12,
                                      color: _selectedIndex == 2
                                          ? customcolor.tabblue
                                          : customcolor.hinttext,
                                      fontWeight: FontWeight.normal),
                                )
                              ],
                            )),
                      ),
                    ],
                  )
                : Row(
                    //children inside bottom appbar
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          _onItemTapped(0);
                          Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.fade,
                                child: Attendance("OverAll"),
                                duration: Duration(milliseconds: 300),

                                // AllCategory()
                              ));
                        },
                        child: Container(
                            color: Colors.transparent,
                            height: SizeConfig.blockSizeHorizontal * 14,
                            child: Column(
                              children: [
                                _selectedIndex == 0
                                    ? Image.asset(
                                        "assets/images/blueattendance.png",
                                        width: 20,
                                        height: 20,
                                      )
                                    : Image.asset(
                                        "assets/images/greyattendance.png",
                                        width: 20,
                                        height: 20,
                                      ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  "Attendance",
                                  style: AppFonts.headerStyle(
                                      fontSize: 12,
                                      color: _selectedIndex == 0
                                          ? customcolor.tabblue
                                          : customcolor.hinttext,
                                      fontWeight: FontWeight.normal),
                                )
                              ],
                            )),
                      ),
                      GestureDetector(
                        onTap: () {
                          _onItemTapped(1);
                          if (role == GlobalLists.operationrole ||
                              role == GlobalLists.headrole ||
                              role == GlobalLists.reginalmanagerrole ||
                              role == GlobalLists.clientrole ||
                              role == GlobalLists.operationmanagerrole) {
                            Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.fade,
                                  child: WorkflowstatusOperation(
                                      "", false, "", "", "", ""),
                                  duration: Duration(milliseconds: 300),
                                ));
                          } else {
//                              if(GlobalLists.shiftid=="")
//                                             {
// ShowDialogs.showToast("No Shift Available");
//                                             }else{
                            Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.fade,
                                  child: WorkflowstatusOperation(
                                      GlobalLists.shiftid,
                                      false,
                                      "",
                                      "",
                                      "",
                                      ""),
                                  duration: Duration(milliseconds: 300),
                                  //Workflowstatus(GlobalLists.shiftid)
                                ));
                            //}
                          }
                        },
                        child: Container(
                            color: Colors.transparent,
                            height: SizeConfig.blockSizeHorizontal * 14,
                            child: Column(
                              children: [
                                _selectedIndex == 1
                                    ? Image.asset(
                                        "assets/images/blueworkflow.png",
                                        width: 20,
                                        height: 20,
                                      )
                                    : Image.asset(
                                        "assets/images/greyworkflow.png",
                                        width: 20,
                                        height: 20,
                                      ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  "WorkFlow",
                                  style: AppFonts.headerStyle(
                                      fontSize: 12,
                                      color: _selectedIndex == 1
                                          ? customcolor.tabblue
                                          : customcolor.hinttext,
                                      fontWeight: FontWeight.normal),
                                )
                              ],
                            )),
                      ),
                      GestureDetector(
                        onTap: () {
                          _onItemTapped(4);
                          Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.fade,
                                  duration: Duration(milliseconds: 300),
                                  child: HomePage()));
                        },
                        child: Container(
                            color: Colors.transparent,
                            height: SizeConfig.blockSizeHorizontal * 14,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: SizeConfig.blockSizeHorizontal * 7,
                                ),
                                Text(
                                  "Home",
                                  style: AppFonts.headerStyle(
                                      fontSize: 12,
                                      color: _selectedIndex == 4
                                          ? customcolor.tabblue
                                          : customcolor.hinttext,
                                      fontWeight: FontWeight.normal),
                                )
                              ],
                            )),
                      ),
                      GestureDetector(
                        onTap: () {
                          _onItemTapped(2);
                          Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.fade,
                                child: Complaint(
                                    false, "", "", "", "", "", "", "", false),
                                duration: Duration(milliseconds: 300),
                              ));
                        },
                        child: Container(
                            color: Colors.transparent,
                            height: SizeConfig.blockSizeHorizontal * 14,
                            child: Column(
                              children: [
                                _selectedIndex == 2
                                    ? Image.asset(
                                        "assets/images/blueticket.png",
                                        width: 20,
                                        height: 20,
                                      )
                                    : Image.asset(
                                        "assets/images/greyticket.png",
                                        width: 20,
                                        height: 20,
                                      ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  "Complaints",
                                  style: AppFonts.headerStyle(
                                      fontSize: 12,
                                      color: _selectedIndex == 2
                                          ? customcolor.tabblue
                                          : customcolor.hinttext,
                                      fontWeight: FontWeight.normal),
                                )
                              ],
                            )),
                      ),
                      (role == GlobalLists.headrole ||
                              role == GlobalLists.reginalmanagerrole ||
                              role == GlobalLists.clientrole ||
                              role == GlobalLists.operationrole ||
                              role == GlobalLists.operationmanagerrole)
                          ? GestureDetector(
                              onTap: () {
                                _onItemTapped(3);
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.fade,
                                        duration: Duration(milliseconds: 300),
                                        child: Rating("")));
                              },
                              child: Container(
                                  color: Colors.transparent,
                                  height: SizeConfig.blockSizeHorizontal * 14,
                                  child: Column(
                                    children: [
                                      _selectedIndex == 3
                                          ? Image.asset(
                                              "assets/images/ratingblue.png",
                                              width: 20,
                                              height: 20,
                                            )
                                          : Image.asset(
                                              "assets/images/ratinggrey.png",
                                              width: 20,
                                              height: 20,
                                            ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        "Rating",
                                        style: AppFonts.headerStyle(
                                            fontSize: 12,
                                            color: _selectedIndex == 3
                                                ? customcolor.tabblue
                                                : customcolor.hinttext,
                                            fontWeight: FontWeight.normal),
                                      )
                                    ],
                                  )),
                            )
                          : GestureDetector(
                              onTap: () {
                                _onItemTapped(3);
                                Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.fade,
                                      child: Profile(),
                                      duration: Duration(milliseconds: 300),
                                    ));
                              },
                              child: Container(
                                  color: Colors.transparent,
                                  height: SizeConfig.blockSizeHorizontal * 14,
                                  child: Column(
                                    children: [
                                      _selectedIndex == 3
                                          ? Image.asset(
                                              "assets/images/blueprofile.png",
                                              width: 20,
                                              height: 20,
                                            )
                                          : Image.asset(
                                              "assets/images/greyprofile.png",
                                              width: 20,
                                              height: 20,
                                            ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        "Profile",
                                        style: AppFonts.headerStyle(
                                            fontSize: 12,
                                            color: _selectedIndex == 3
                                                ? customcolor.tabblue
                                                : customcolor.hinttext,
                                            fontWeight: FontWeight.normal),
                                      )
                                    ],
                                  )),
                            ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
