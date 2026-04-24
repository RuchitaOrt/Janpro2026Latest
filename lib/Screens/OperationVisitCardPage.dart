import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:janpro/Utitlity/custom_color.dart';
import 'package:page_transition/page_transition.dart';

import '../Utitlity/APIManager.dart';
import '../Utitlity/AppDrawer.dart';
import '../Utitlity/GlobalLists.dart';
import '../Utitlity/SPManager.dart';
import '../Utitlity/ShowDialog.dart';
import '../Utitlity/appbar.dart';
import '../Utitlity/customBottomNavigationBar.dart';
import '../Utitlity/internetConnection.dart';
import '../model/OperationVisitView.dart';
import 'Homepage.dart';
import 'operation_visit_page.dart';
import 'package:intl/intl.dart';

class OperationVisitCardPage extends StatefulWidget {
  OperationVisitCardPage({super.key});

  @override
  State<OperationVisitCardPage> createState() => _OperationVisitCardPageState();
}

class _OperationVisitCardPageState extends State<OperationVisitCardPage> {
  String? roles = "0";
  String? role = "0";

  @override
  void initState() {
    getrole();
    super.initState();
  }

  getrole() async {
    roles = await SPManager().getroleid();
    log('role id check$roles');
    visitview();
  }

  final GlobalKey<State> _viewoperation = new GlobalKey<State>();
  final GlobalKey<ScaffoldState> _scaffoldKey2 = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => HomePage(),
          ),
        );
        return await false;
      },
      child: Scaffold(
        key: _scaffoldKey2,
        backgroundColor: Colors.grey.shade100,
        bottomNavigationBar: CustomBottomNavigationBar(index: -1),
        resizeToAvoidBottomInset: false,
        floatingActionButton: FloatingActionButton(
          //Floating action button on Scaffold
          backgroundColor: customcolor.white,
          onPressed: () {
            Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.fade,
                  child: HomePage(),
                  duration: Duration(milliseconds: 300),
                ));
          },
          child: Image.asset(
            "assets/images/greyhome.png",
            color: customcolor.greytext,
            width: 20,
            height: 20,
          ), //icon inside button
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        endDrawer: Theme(
          data: Theme.of(context).copyWith(
              canvasColor: customcolor.blue, primaryColor: customcolor.blue),
          child: AppDrawerfilter(roles.toString()),
        ),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(148),
          child: AppbarComman(
              setStyleStr: 'Visit Records',
              onPressedBack: () {},
              onPressedNotify: () {},
              onPressedSearch: () {},
              onPressedSort: () {},
              onPressedmenu: () {
                log('drawer role $roles');
                _scaffoldKey2.currentState!.openEndDrawer();
              }),
        ),
       
       
        body:isVisitViewLoaded?Center(child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: customcolor.blue,),
            SizedBox(height: 15),
                Text("Loading, please wait...",
                    style: TextStyle(
                        color:   Colors.black))
          ],
        )): Stack(
          children: [
            GlobalLists.opersationvisitview.length == 0
                ? Center(
                    child: SizedBox(
                    child: Text('No Visit Record'),
                  ))
                : 
                ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: GlobalLists.opersationvisitview.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 6,
                        margin: EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.location_on_outlined,
                                          color: customcolor.blue),
                                      SizedBox(width: 8),
                                      Text(
                                        GlobalLists
                                            .opersationvisitview[index].siteId
                                            .toString(),
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue.shade800,
                                        ),
                                      ),
                                    ],
                                  ),
                                  ClipRRect(
                                    child: GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (_) => Dialog(
                                            backgroundColor: Colors.transparent,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              child: GlobalLists
                                                              .opersationvisitview[
                                                                  index]
                                                              .supportingImage ==
                                                          "" ||
                                                      GlobalLists
                                                              .opersationvisitview[
                                                                  index]
                                                              .supportingImage ==
                                                          null
                                                  ? Container(
                                                      height: 200,
                                                      width: double.infinity,
                                                      child: Center(
                                                          child: Text(
                                                        'No Image Uploaded',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      )))
                                                  : Image.network(
                                                      GlobalLists
                                                          .opersationvisitview[
                                                              index]
                                                          .supportingImage
                                                          .toString(),
                                                      fit: BoxFit.contain),
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 4,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Image.network(
                                          GlobalLists.opersationvisitview[index]
                                              .supportingImage
                                              .toString(),
                                          height: 50,
                                          width: 50,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Icon(Icons.broken_image,
                                                      size: 50,
                                                      color: Colors.blue),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              Row(
                                children: [
                                  Icon(Icons.calendar_today_outlined,
                                      size: 18, color: Colors.grey),
                                  SizedBox(width: 6),
                                  Text(
                                      formatDate(GlobalLists
                                          .opersationvisitview[index].date
                                          .toString()),
                                      style: TextStyle(color: Colors.black87)),
                                  SizedBox(width: 20),
                                  Icon(Icons.access_time_outlined,
                                      size: 18, color: Colors.grey),
                                  SizedBox(width: 6),
                                  Text(
                                      formatTime(GlobalLists
                                          .opersationvisitview[index].time
                                          .toString()),
                                      style: TextStyle(color: Colors.black87)),
                                ],
                              ),
                              SizedBox(height: 12),
                              Text("Purpose of Visit",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w600)),
                              SizedBox(height: 4),
                              Text(
                                  GlobalLists
                                      .opersationvisitview[index].visitRemarks
                                      .toString(),
                                  style: TextStyle(color: Colors.black87)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  if(roles==GlobalLists.operationmanagerrole||roles==GlobalLists.operationrole)
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                margin: EdgeInsets.all(16), // Add some spacing
                child: ElevatedButton.icon(
                  onPressed: () {
                    print('roles$roles');
                    print('GlobalLists.operationmanagerrole${GlobalLists.operationmanagerrole}');

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OperationVisitPage(roles,false,"")),
                    );
                  },
                  icon: Icon(Icons.add, color: Colors.white),
                  label:
                      Text("Add Visit", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: customcolor.blue, // Match your FAB color
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(50), // Circular shape like FAB
                    ),
                    elevation: 6, // Shadow like FAB
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  navigatTovist() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OperationVisitPage(roles,false,"")),
    );
  }

  String formatTime(String time24) {
    try {
      final parsedTime = DateFormat("HH:mm").parse(time24);
      return DateFormat("hh:mm a").format(parsedTime); // e.g., 04:32 PM
    } catch (e) {
      return time24; // fallback in case of error
    }
  }

  String formatDate(String date) {
    try {
      final parsedDate = DateTime.parse(date); // '2025-07-17'
      return DateFormat('dd MMM yyyy').format(parsedDate); // 17 Jul 2025
      // return DateFormat('EEEE, dd MMMM yyyy').format(parsedDate); // Thursday, 17 July 2025
    } catch (e) {
      return date; // fallback
    }
  }
bool isVisitViewLoaded=false;
  void visitview() async {
    var status1 = await ConnectionDetector.checkInternetConnection();
    role = await SPManager().getsupervisorid();

    if (status1) {
      setState(() {
        isVisitViewLoaded=true;
      });
      // ShowDialogs.showLoadingDialog(context, _viewoperation);
      String today = DateTime.now()
          .toLocal()
          .toString()
          .split(' ')[0]
          .split('-')
          .reversed
          .join('-'); // dd-MM-yyyy

      var map = {"emp_id": role};

      log("Site Dropdown Request: $map");

      APIManager().apiRequest(context, API.visitview, (response) async {
        OperationVisitView resp = response;
        if (resp.status == 1) {
          setState(() {
            // GlobalLists.opersationvisitview = resp.data ?? [];
            log('GlobalLists.opersationvisitview ${GlobalLists.opersationvisitview}');
          });
   setState(() {
        isVisitViewLoaded=false;
      });
          // Navigator.pop(context);
        } else {
          ShowDialogs.showToast(resp.msg.toString());
             setState(() {
        isVisitViewLoaded=false;
      });
          // Navigator.pop(context);
        }
      }, (error) {
           setState(() {
        isVisitViewLoaded=false;
      });
        // Navigator.pop(context);
        print('API Error: $error');
      }, false, "", jsonval: map);
    } else {
      ShowDialogs.showToast("Please check internet connection");
    }
  }



}
