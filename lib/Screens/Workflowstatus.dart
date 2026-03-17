// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'dart:ui';

// import 'package:buttons_tabbar/buttons_tabbar.dart';
// import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:intl/intl.dart';
// import 'package:janpro/Screens/Attendance.dart';
// import 'package:janpro/Screens/Homepage.dart';
// import 'package:janpro/Utitlity/APIManager.dart';
// import 'package:janpro/Utitlity/AppDrawer.dart';
// import 'package:janpro/Utitlity/Dropbutton.dart';
// import 'package:janpro/Utitlity/FormTextField.dart';
// import 'package:janpro/Utitlity/FormTextFieldButton.dart';
// import 'package:janpro/Utitlity/GlobalLists.dart';
// import 'package:janpro/Utitlity/SPManager.dart';
// import 'package:janpro/Utitlity/ShowDialog.dart';
// import 'package:janpro/Utitlity/appbar.dart';
// import 'package:janpro/Utitlity/button.dart';
// import 'package:janpro/Utitlity/customBottomNavigationBar.dart';
// import 'package:janpro/Utitlity/custom_color.dart';
// import 'package:janpro/Utitlity/internetConnection.dart';
// import 'package:janpro/Utitlity/sizeConfig.dart';
// import 'package:janpro/model/OperationalWorkflowResponse.dart' as operwf;
// import 'package:janpro/model/UpdatedworkflowResponse.dart';
// import 'package:janpro/model/WorkfowstatusResponse.dart';
// import 'package:page_transition/page_transition.dart';
// import 'package:percent_indicator/circular_percent_indicator.dart';
// import 'package:chips_choice/chips_choice.dart';

// import 'package:responsive_flutter/responsive_flutter.dart';
// import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';

// import 'dart:math' as math;

// // import 'package:syncfusion_flutter_sliders/sliders.dart';

// class PendingTask {
//   final String? maintaskname;
//   final String? masterareaid;
//   final String? masterblockid;
//   final List<Checklist>? listvalue;
//   final List? multipleSelected;
//   bool? isenabledclick;

//   PendingTask({
//     this.maintaskname,
//     this.listvalue,
//     this.multipleSelected,
//     this.isenabledclick,
//     this.masterareaid,
//     this.masterblockid,
//   });
// }

// class OperationalPendingTask {
//   final String? maintaskname;
//   final String? masterareaid;
//   final String? masterblockid;
//   final List<operwf.Checklist>? listvalue;
//   final List? multipleSelected;
//   bool? isenabledclick;

//   OperationalPendingTask({
//     this.maintaskname,
//     this.listvalue,
//     this.multipleSelected,
//     this.isenabledclick,
//     this.masterareaid,
//     this.masterblockid,
//   });
// }

// class Workflowstatus extends StatefulWidget {
//   final String shiftid;

//   Workflowstatus(this.shiftid);

//   @override
//   _WorkflowstatusState createState() => _WorkflowstatusState();
// }

// class _WorkflowstatusState extends State<Workflowstatus>
//     with TickerProviderStateMixin {
//   bool expand = true;

//   int selectedindex = 0;
//   int selectedindexmain = 0;

//   // bool enabled = false;
//   int? tapped;
//   var statuscontroller = new TextEditingController();
//   var namecontroller = new TextEditingController();
//   List<Tab> tabs = <Tab>[];
//   List<MasterAreaWiseList> listtab = [];
//   List<operwf.MasterAreaWiseList> operationlisttab = [];
//   late List<Tab> tabsmain = <Tab>[];
//   bool isdataloaded = false;
//   String _isSelected = "";

//   var mobilecontroller = new TextEditingController();
//   final GlobalKey<State> _keyLoader = new GlobalKey<State>();
//   double yOffset = 0;
//   double xOffset = 0;
//   double pageScale = 1;
//   String selectedValue = "Pending";
//   late TabController _tabController;
//   var selectedDateTime;
//   late TabController _tabControllermain;
//   double _value = 40.0;
//   List<Widget> listoftabwiget = [];
//   List<Widget> listoftabwigetmain = [];

//   List mainlist = [];
//   bool isoptionopen = false;
//   int maintag = 0;
//   var datecontroller = new TextEditingController();
//   final GlobalKey<ScaffoldState> _scaffoldKey1 = new GlobalKey<ScaffoldState>();
//   List<String> options = [
//     "TAT",
//     "Dependent",
//     "Resolved",
//   ];

//   // int currentvisibletimeindex=0;
//   String card_startcurrentdatevalue = "";
//   String card_endcurrentdatevalue = "";
//   String card_superviorfirtvalue = "";
//   String card_percentvalue = "";
//   List<operwf.Datum> mainlisttab = [];
//   List<String>? formValue1;
//   int tag = 0;

//   Future<void> refreshData() async {
//     // Simulating an API request or data refresh
//     setState(() {
//       print("APICall");
//       //     var  datefrom =
//       //                                   DateFormat('dd-MM-yyyy').format(DateTime.now());
//       // datecontroller.text=datefrom;
//       getrole();

//       //  _tabController = new TabController(vsync: this, length: 3);
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     var datefrom = DateFormat('dd-MM-yyyy').format(DateTime.now());
//     datecontroller.text = datefrom;
// //   _tabControllermain=new TabController(length: 1,vsync: this );
// // if(_tabControllermain.length>0)
// // {
// //       _tabControllermain.addListener(() {
// //         print("callinginit");
// //       setState(() {
// //         tag=0;
// //         selectedindex=0;
// //     });
// //      });
// //}
//     getrole();
//   }

//   String role = "";

//   getrole() async {
//     role = (await SPManager().getroleid())!;
//     if (role == GlobalLists.operationrole ||
//         role == GlobalLists.headrole ||
//         role == GlobalLists.reginalmanagerrole ||
//         role == GlobalLists.clientrole ||
//         role == GlobalLists.operationmanagerrole) {
//       operationlworkflowstatusApi();
//     } else {
//       workflowstatusApi(widget.shiftid);
//     }
//     if (role == GlobalLists.unitrole ||
//         role == GlobalLists.headrole ||
//         role == GlobalLists.reginalmanagerrole ||
//         role == GlobalLists.clientrole ||
//         role == GlobalLists.operationrole ||
//         role == GlobalLists.operationmanagerrole) {
//       // setState(() {

//       //     mainlisttab.add(MainList("IMAX","1"));
//       //      mainlisttab.add(MainList("Cinipol","1"));
//       //       mainlisttab.add(MainList("Cinimax","0"));

//       // });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         Navigator.push(
//           context,
//           PageRouteBuilder(
//             pageBuilder: (context, animation1, animation2) => HomePage(),
//           ),
//         );
//         return await false;
//       },
//       child: Scaffold(
//         backgroundColor: customcolor.greybg,
//         resizeToAvoidBottomInset: false,

//         floatingActionButton: FloatingActionButton(
//           //Floating action button on Scaffold
//           backgroundColor: customcolor.white,
//           onPressed: () {
//             Navigator.push(
//                 context,
//                 PageTransition(
//                   type: PageTransitionType.fade,
//                   child: HomePage(),
//                   duration: Duration(milliseconds: 300),
//                 ));
//           },
//           child: Image.asset(
//             "assets/images/greyhome.png",
//             color: customcolor.greytext,
//             width: 20,
//             height: 20,
//           ), //icon inside button
//         ),
//         floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//         //floating action button position to center
//         appBar: PreferredSize(
//           preferredSize: Size.fromHeight(148),
//           child: AppbarComman(
//               setStyleStr: 'home',
//               onPressedBack: () {},
//               onPressedNotify: () {},
//               onPressedSearch: () {},
//               onPressedSort: () {},
//               onPressedmenu: () {
//                 _scaffoldKey1.currentState!.openEndDrawer();
//               }),
//         ),
//         endDrawer: Theme(
//           data: Theme.of(context).copyWith(
//               canvasColor: customcolor.blue, primaryColor: customcolor.blue),
//           child: AppDrawerfilter(role),
//         ),
//         key: _scaffoldKey1,
//         bottomNavigationBar: CustomBottomNavigationBar(index: 1),
//         body: SingleChildScrollView(
//           child: Stack(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(
//                     left: 10, right: 10, top: 20, bottom: 20),
//                 child: Container(
//                   //height: SizeConfig.blockSizeVertical*100,
//                   child: ListView(
//                     shrinkWrap: true,
//                     physics: ScrollPhysics(),
//                     children: [
//                       //r SizedBox(height:10),
//                       Container(
//                         // color: customcolor.blue,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Container(
//                               child: Text(
//                                 "WORKFLOW",
//                                 style: AppFonts.headerStyle(
//                                     fontSize: ResponsiveFlutter.of(context)
//                                         .fontSize(2.3),
//                                     color: customcolor.title,
//                                     fontWeight: FontWeight.normal),
//                               ),
//                             ),
//                             (role == GlobalLists.unitrole ||
//                                     role == GlobalLists.headrole ||
//                                     role == GlobalLists.reginalmanagerrole ||
//                                     role == GlobalLists.clientrole ||
//                                     role == GlobalLists.operationrole ||
//                                     role == GlobalLists.operationmanagerrole ||
//                                     role == GlobalLists.supervisorrole)
//                                 ? new Container(
//                                     decoration: BoxDecoration(
//                                         color: Colors.white,
//                                         borderRadius:
//                                             BorderRadius.circular(20)),
//                                     width: SizeConfig.blockSizeHorizontal * 32,
//                                     height: 30,
//                                     // padding: EdgeInsets.only(left: 6,bottom: 5,top:3,right: 5),
//                                     child: new Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       children: <Widget>[
//                                         // new Expanded(child: new Text("Bemerkung",)),
//                                         new Expanded(
//                                           child: new TextField(
//                                             textAlignVertical:
//                                                 TextAlignVertical.center,
//                                             textAlign: TextAlign.center,
//                                             style: AppFonts.headerStyle(
//                                                 fontSize: ResponsiveFlutter.of(
//                                                         context)
//                                                     .fontSize(1.6),
//                                                 color: customcolor.black,
//                                                 fontWeight: FontWeight.w300),
//                                             readOnly: true,
//                                             onTap: () async {
//                                               DateTime? pickedDate =
//                                                   await showDatePicker(
//                                                       context: context,
//                                                       initialDate:
//                                                           selectedDateTime ??
//                                                               DateTime.now(),
//                                                       firstDate: DateTime(1950),
//                                                       lastDate: DateTime(2050));

//                                               if (pickedDate != null) {
//                                                 var datefrom =
//                                                     DateFormat('dd-MM-yyyy')
//                                                         .format(pickedDate);
//                                                 datecontroller.text = datefrom;
//                                                 print(datecontroller.text);
//                                                 setState(() =>
//                                                     selectedDateTime =
//                                                         pickedDate);
//                                                 if (role ==
//                                                         GlobalLists.unitrole ||
//                                                     role ==
//                                                         GlobalLists
//                                                             .operationrole ||
//                                                     role ==
//                                                         GlobalLists.headrole ||
//                                                     role ==
//                                                         GlobalLists
//                                                             .reginalmanagerrole ||
//                                                     role ==
//                                                         GlobalLists
//                                                             .clientrole ||
//                                                     role ==
//                                                         GlobalLists
//                                                             .operationmanagerrole) {
//                                                   print("unit");
//                                                   operationlworkflowstatusApi();
//                                                 } else {
//                                                   workflowstatusApi(
//                                                       widget.shiftid);
//                                                 }
//                                               }
//                                             },
//                                             controller: datecontroller,
//                                             decoration: InputDecoration(
//                                               border: InputBorder.none,
//                                               contentPadding: EdgeInsets.zero,
//                                               isDense: true,
//                                             ),
//                                           ),
//                                         ),
//                                         GestureDetector(
//                                           onTap: () async {
//                                             DateTime? pickedDate =
//                                                 await showDatePicker(
//                                                     context: context,
//                                                     initialDate:
//                                                         selectedDateTime ??
//                                                             DateTime.now(),
//                                                     firstDate: DateTime(1950),
//                                                     lastDate: DateTime(2050));

//                                             if (pickedDate != null) {
//                                               var datefrom =
//                                                   DateFormat('dd-MM-yyyy')
//                                                       .format(pickedDate);
//                                               datecontroller.text = datefrom;
//                                               setState(() => selectedDateTime =
//                                                   pickedDate);
//                                               print(datecontroller.text);
//                                               if (role ==
//                                                       GlobalLists.unitrole ||
//                                                   role ==
//                                                       GlobalLists
//                                                           .operationrole ||
//                                                   role ==
//                                                       GlobalLists.headrole ||
//                                                   role ==
//                                                       GlobalLists
//                                                           .reginalmanagerrole ||
//                                                   role ==
//                                                       GlobalLists.clientrole ||
//                                                   role ==
//                                                       GlobalLists
//                                                           .operationmanagerrole) {
//                                                 print("unit");
//                                                 operationlworkflowstatusApi();
//                                               } else {
//                                                 workflowstatusApi(
//                                                     widget.shiftid);
//                                               }
//                                             }
//                                           },
//                                           child: Padding(
//                                             padding: EdgeInsets.only(
//                                                 bottom: 1, right: 5),
//                                             child: Image.asset(
//                                               'assets/images/calendar.png',
//                                               width: 22,
//                                               height: 22,
//                                               alignment: Alignment.center,
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   )
//                                 : Container()
//                           ],
//                         ),
//                       ),
//                       SizedBox(
//                         height: 5,
//                       ),
//                       (role == GlobalLists.headrole ||
//                               role == GlobalLists.reginalmanagerrole ||
//                               role == GlobalLists.clientrole ||
//                               role == GlobalLists.operationrole ||
//                               role == GlobalLists.operationmanagerrole)
//                           ? isdataloaded == false
//                               ? Container()
//                               : headmodule()
//                           : isdataloaded == false
//                               ? Container()
//                               : supervisormodule()
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget headmodule() {
//     print("again");

//     return mainlisttab.length == 0
//         ? Container()
//         : CustomRefreshIndicator(
//             // key: refreshIndicatorKey,
//             builder: (
//               BuildContext context,
//               Widget child,
//               IndicatorController controller,
//             ) {
//               return Stack(
//                 alignment: Alignment.topCenter,
//                 children: <Widget>[
//                   if (!controller.isIdle)
//                     Positioned(
//                       top: 35.0 * controller.value,
//                       child: SizedBox(
//                         height: 30,
//                         width: 30,
//                         child: CircularProgressIndicator(
//                           value: !controller.isLoading
//                               ? controller.value.clamp(0.0, 1.0)
//                               : null,
//                         ),
//                       ),
//                     ),
//                   Transform.translate(
//                     offset: Offset(0, 100.0 * controller.value),
//                     child: child,
//                   ),
//                 ],
//               );
//             },
//             onRefresh: refreshData,
//             child: ListView(
//               shrinkWrap: true,
//               //  physics: ScrollPhysics(),
//               children: [
//                 mainlisttab.length > 0
//                     ? Padding(
//                         padding: const EdgeInsets.only(top: 10, bottom: 10),
//                         child: Container(
//                           height: 25,
//                           child: ListView(
//                             scrollDirection: Axis.horizontal,
//                             shrinkWrap: true,
//                             physics: ScrollPhysics(),
//                             children: _buildChoicemainList(),
//                           ),
//                         )

//                         // Wrap(
//                         //    spacing: 5.0,
//                         //    runSpacing: 3.0,
//                         //    children: _buildChoicemainList(),
//                         //  ),
//                         )
//                     : Container(),
//                 //  mainlisttab[maintag].details.length>0?Container():
//                 opertaionmodule(),
//               ],
//             ),
//           );
//   }

//   //tab
//   _buildChoicemainList() {
//     List<Widget> choices = [];
//     mainlisttab.forEachIndexed((item, value) {
//       choices.add(Container(
//         height: 25,
//         child: Padding(
//           padding: const EdgeInsets.only(right: 5),
//           child: ChoiceChip(
//             label: Padding(
//               padding: const EdgeInsets.only(bottom: 5),
//               child: Text(
//                 item.clientName,
//                 style: AppFonts.headerStyle(
//                     fontSize: 12,
//                     color: maintag == value
//                         ? customcolor.white
//                         : item.pendingstatus == 0
//                             ? customcolor.red
//                             : customcolor.greytext,
//                     fontWeight: FontWeight.bold),
//               ),
//             ),
//             side: BorderSide(
//                 width: 0.5,
//                 color: maintag == value
//                     ? customcolor.white
//                     : item.pendingstatus == 0
//                         ? customcolor.red
//                         : customcolor.white),
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.only(
//                     bottomLeft: Radius.circular(10),
//                     bottomRight: Radius.circular(10))),
//             labelStyle: AppFonts.headerStyle(
//                 fontSize: 12,
//                 color:
//                     maintag == value ? customcolor.blue : customcolor.greytext,
//                 fontWeight: FontWeight.bold),
//             selectedColor: customcolor.tabblue,
//             backgroundColor: customcolor.white,
//             selected: maintag == value,
//             onSelected: (selected) {
//               setState(() {
//                 _isSelected = item.clientName;
//                 maintag = value;
//                 tag = 0;
//                 tabsmain = <Tab>[];
//                 //initialIndex: 1

//                 //  int selectedvalue =  mainlisttab[maintag].details.indexWhere((item) => item.id.toString() == mainlisttab[maintag].masterArea[tabindexmain].id.toString());

//                 // _tabController = new TabController(vsync: this, length: 1);
//                 selectedindex = 0;
//                 for (int i = 0; i < mainlisttab[maintag].details.length; i++) {
//                   tabsmain.add(
//                     // new Tab(
//                     //  text: "${mainlisttab[maintag].details[i].startTimeStr}-${mainlisttab[maintag].details[i].endTimeStr}",

//                     // ),
//                     Tab(
//                       child: Text(
//                         "${mainlisttab[maintag].details[i].startTimeStr}-${mainlisttab[maintag].details[i].endTimeStr}",
//                         style: TextStyle(
//                             color: mainlisttab[maintag].details[i].status ==
//                                     "Pending"
//                                 ? customcolor.red
//                                 : mainlisttab[maintag].details[i].status ==
//                                         "Completed"
//                                     ? customcolor.green
//                                     : customcolor.blue),
//                       ),
//                     ),
//                   );
//                   card_startcurrentdatevalue = mainlisttab[maintag]
//                       .details[selectedindex]
//                       .startTimeStr
//                       .toString();
//                   card_endcurrentdatevalue = mainlisttab[maintag]
//                       .details[selectedindex]
//                       .endTimeStr
//                       .toString();
//                   card_superviorfirtvalue = mainlisttab[maintag]
//                       .details[selectedindex]
//                       .supervisorName
//                       .toString();
//                   card_percentvalue = mainlisttab[maintag]
//                       .details[selectedindex]
//                       .percentage
//                       .toString();
//                   print("selectedindextag");
//                   if (mainlisttab[maintag].details[i].currentTime == true) {
//                     print("selectedindextagselect");
//                     selectedindex = i;
//                     print(selectedindex);
//                     card_startcurrentdatevalue =
//                         mainlisttab[maintag].details[i].startTimeStr.toString();
//                     card_endcurrentdatevalue =
//                         mainlisttab[maintag].details[i].endTimeStr.toString();
//                     card_superviorfirtvalue = mainlisttab[maintag]
//                         .details[i]
//                         .supervisorName
//                         .toString();
//                     card_percentvalue =
//                         mainlisttab[maintag].details[i].percentage.toString();
//                   }
//                 }
//                 print("selectedindextagselect1");
//                 print(selectedindex);
//                 _tabControllermain = new TabController(
//                     vsync: this,
//                     length: mainlisttab[maintag].details.length,
//                     initialIndex: selectedindex);
//                 print(_tabControllermain.length);
//               });
//             },
//           ),
//         ),
//       ));
//     });
//     return choices;
//   }

//   Widget supervisormodule() {
//     return GlobalLists.workflowstatuslist.length == 0
//         ? Container()
//         : CustomRefreshIndicator(
//             builder: (
//               BuildContext context,
//               Widget child,
//               IndicatorController controller,
//             ) {
//               return Stack(
//                 alignment: Alignment.topCenter,
//                 children: <Widget>[
//                   if (!controller.isIdle)
//                     Positioned(
//                       top: 35.0 * controller.value,
//                       child: SizedBox(
//                         height: 30,
//                         width: 30,
//                         child: CircularProgressIndicator(
//                           value: !controller.isLoading
//                               ? controller.value.clamp(0.0, 1.0)
//                               : null,
//                         ),
//                       ),
//                     ),
//                   Transform.translate(
//                     offset: Offset(0, 100.0 * controller.value),
//                     child: child,
//                   ),
//                 ],
//               );
//             },
//             onRefresh: refreshData,
//             child: ListView(
//               shrinkWrap: true,
//               //  physics: ScrollPhysics(),
//               children: [
//                 Container(
//                   height: SizeConfig.blockSizeVertical * 80,
//                   //to make half scroll replace 100 with 63
//                   decoration: BoxDecoration(
//                     // color: Colors.blue,
//                     shape: BoxShape.rectangle,
//                     borderRadius: BorderRadius.circular(10),
//                     border: Border.all(
//                       color: customcolor.greyborder,
//                       width: 0.4,
//                     ),
//                   ),

//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Container(
//                         height: 30,
//                         child: ButtonsTabBar(
//                           labelStyle: AppFonts.headerStyle(
//                               fontSize: 12,
//                               color:
//                                   //  GlobalLists.workflowstatuslist[selectedindex].status=="Pending"?
//                                   // customcolor.red:
//                                   customcolor.blue,
//                               fontWeight: FontWeight.normal),
//                           unselectedLabelStyle: AppFonts.headerStyle(
//                               fontSize: 12,
//                               color:
//                                   // GlobalLists.workflowstatuslist[selectedindex].status=="Pending"?customcolor.red:
//                                   customcolor.greytext,
//                               fontWeight: FontWeight.normal),

//                           height: 150,

//                           onTap: (val) {
//                             setState(() {
//                               print("ontap");
//                               print(val.toString());
//                               selectedindex = val; //20feb
//                               //checksupervisorissuehere
//                               tag = 0;
//                               card_startcurrentdatevalue = GlobalLists
//                                   .workflowstatuslist[selectedindex].startTime;
//                               card_endcurrentdatevalue = GlobalLists
//                                   .workflowstatuslist[selectedindex].endTime;
//                               card_superviorfirtvalue =
//                                   "${GlobalLists.workflowstatuslist[selectedindex].clientName} - ${GlobalLists.workflowstatuslist[selectedindex].siteName}";
//                               card_percentvalue = GlobalLists
//                                   .workflowstatuslist[selectedindex].percentage
//                                   .toString();
//                               print("pretest");
//                               print("val.toString()");
//                             });
//                           },

//                           //   indicator:
//                           // //  _tabControllermain.index==selectedindex?
//                           decoration: BoxDecoration(
//                               color: customcolor.blue.withOpacity(0.2),
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(10))
//                               //  BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight:Radius.circular(10) )
//                               ),
//                           unselectedDecoration: BoxDecoration(
//                               color: customcolor.white,
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(10))
//                               // borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight:Radius.circular(10) )
//                               ),

//                           tabs: tabsmain,

//                           controller: _tabControllermain,
//                         ),
//                       ),
//                       isdataloaded
//                           ? Padding(
//                               padding: const EdgeInsets.all(6.0),
//                               child: Stack(
//                                 children: [
//                                   Padding(
//                                       padding: EdgeInsets.only(
//                                         right: 0.0,
//                                         left: 0.0,
//                                         top: 15,
//                                         bottom: 4,
//                                       ),
//                                       child: GestureDetector(
//                                         onTap: () {},
//                                         child: Material(
//                                           elevation: 0,
//                                           borderRadius:
//                                               BorderRadius.circular(10),
//                                           child: Container(
//                                             width:
//                                                 SizeConfig.blockSizeHorizontal *
//                                                     100,
//                                             decoration: BoxDecoration(
//                                               borderRadius:
//                                                   BorderRadius.circular(10),
//                                             ),
//                                             child: Padding(
//                                               padding:
//                                                   const EdgeInsets.all(10.0),
//                                               child: Column(
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.start,
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment.start,
//                                                 children: [
//                                                   // SizedBox(height: 20,),
//                                                   Row(
//                                                     crossAxisAlignment:
//                                                         CrossAxisAlignment
//                                                             .start,
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment
//                                                             .spaceBetween,
//                                                     children: [
//                                                       Padding(
//                                                         padding:
//                                                             const EdgeInsets
//                                                                 .only(top: 10),
//                                                         child: Container(
//                                                           width: SizeConfig
//                                                                   .blockSizeHorizontal *
//                                                               60,
//                                                           child: Column(
//                                                             crossAxisAlignment:
//                                                                 CrossAxisAlignment
//                                                                     .start,
//                                                             mainAxisAlignment:
//                                                                 MainAxisAlignment
//                                                                     .start,
//                                                             children: [
//                                                               Text(
//                                                                 "${card_startcurrentdatevalue}-${card_endcurrentdatevalue}",
//                                                                 //  "${GlobalLists.workflowstatuslist[selectedindex].startTime} - ${GlobalLists.workflowstatuslist[selectedindex].endTime}",
//                                                                 maxLines: 2,
//                                                                 textAlign:
//                                                                     TextAlign
//                                                                         .start,
//                                                                 overflow:
//                                                                     TextOverflow
//                                                                         .ellipsis,

//                                                                 style: AppFonts.headerStyle(
//                                                                     fontSize: ResponsiveFlutter.of(
//                                                                             context)
//                                                                         .fontSize(
//                                                                             2.2),
//                                                                     color:
//                                                                         customcolor
//                                                                             .blue,
//                                                                     fontWeight:
//                                                                         FontWeight
//                                                                             .w600),
//                                                               ),
//                                                               SizedBox(
//                                                                 height: 10,
//                                                               ),
//                                                               Text(
//                                                                 "${card_superviorfirtvalue}",
//                                                                 //"${GlobalLists.workflowstatuslist[selectedindex].clientName} - ${GlobalLists.workflowstatuslist[selectedindex].siteName}",
//                                                                 maxLines: 2,
//                                                                 textAlign:
//                                                                     TextAlign
//                                                                         .start,
//                                                                 overflow:
//                                                                     TextOverflow
//                                                                         .ellipsis,

//                                                                 style: AppFonts.headerStyle(
//                                                                     fontSize: ResponsiveFlutter.of(
//                                                                             context)
//                                                                         .fontSize(
//                                                                             1.6),
//                                                                     color: customcolor
//                                                                         .black,
//                                                                     fontWeight:
//                                                                         FontWeight
//                                                                             .w400),
//                                                               ),
//                                                             ],
//                                                           ),
//                                                         ),
//                                                       ),
//                                                       Column(
//                                                         crossAxisAlignment:
//                                                             CrossAxisAlignment
//                                                                 .end,
//                                                         mainAxisAlignment:
//                                                             MainAxisAlignment
//                                                                 .start,
//                                                         children: [
//                                                           Container(
//                                                             // color: customcolor.appbarcolor,
//                                                             child:
//                                                                 CircularPercentIndicator(
//                                                               animationDuration:
//                                                                   500,
//                                                               //   radius: 35.0,
//                                                               lineWidth: 4.0,
//                                                               radius: 34.0,
//                                                               //   lineWidth: 5.0,
//                                                               animation: true,
//                                                               percent:
//                                                                   // 0.0,
//                                                                   double.parse(
//                                                                               card_percentvalue) >
//                                                                           100.0
//                                                                       ? 0.0
//                                                                       : double.parse(
//                                                                               card_percentvalue) /
//                                                                           100,
//                                                               //GlobalLists.workflowstatuslist[selectedindex].percentage>100.0?0.0: GlobalLists.workflowstatuslist[selectedindex].percentage/100,
//                                                               center: new Text(
//                                                                 //"",
//                                                                 "${double.parse(card_percentvalue).toStringAsFixed(0)}%",
//                                                                 //"${GlobalLists.workflowstatuslist[selectedindex].percentage.toStringAsFixed(0)}%",
//                                                                 style: AppFonts.headerStyle(
//                                                                     fontSize:
//                                                                         15,
//                                                                     color: customcolor
//                                                                         .yellow,
//                                                                     fontWeight:
//                                                                         FontWeight
//                                                                             .bold),
//                                                               ),

//                                                               circularStrokeCap:
//                                                                   CircularStrokeCap
//                                                                       .round,
//                                                               progressColor:
//                                                                   customcolor
//                                                                       .textblue,
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ],
//                                                   ),

//                                                   // Container(
//                                                   //   height: 5,
//                                                   // ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       )),

//                                   //
//                                 ],
//                               ),
//                             )
//                           : Container(),
//                       //  StatefulBuilder(builder: (thisLowerContext, innerSetState) {
//                       Expanded(
//                         flex: 3,
//                         child: TabBarView(
//                           physics: ScrollPhysics(),
//                           controller: _tabControllermain,
//                           children:
//                               List.generate(tabsmain.length, (tabindexmain) {
//                             //15feb
//                             return Column(
//                               // shrinkWrap: true,
//                               // physics: ScrollPhysics(),
//                               children: [
//                                 SizedBox(
//                                   height: 10,
//                                 ),
//                                 Container(
//                                   height: SizeConfig.blockSizeVertical * 55,
//                                   child: masterarea(tabindexmain),
//                                 )
//                               ],
//                             );
//                           }),
//                         ),
//                       )
//                       //  }
//                       //   ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           );
//   }

//   //unitmodule
//   Widget opertaionmodule() {
//     return ListView(
//       shrinkWrap: true,
//       physics: ScrollPhysics(),
//       children: [
//         Container(
//           height: SizeConfig.blockSizeVertical * 100,
//           //to make half scroll replace 100 with 63
//           decoration: BoxDecoration(
//             //color: Colors.white,
//             shape: BoxShape.rectangle,
//             borderRadius: BorderRadius.circular(10),
//             border: Border.all(
//               color: customcolor.greyborder,
//               width: 0.4,
//             ),
//           ),

//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 height: 30,
//                 child: ButtonsTabBar(
//                   labelStyle: AppFonts.headerStyle(
//                       fontSize: 12,
//                       color:
//                           //   mainlisttab[maintag].details[selectedindex].status=="Pending"? customcolor.red:
//                           customcolor.blue,
//                       fontWeight: FontWeight.normal),
//                   unselectedLabelStyle: AppFonts.headerStyle(
//                       fontSize: 12,
//                       color:
//                           //   mainlisttab[maintag].details[selectedindex].status=="Pending"? customcolor.red:
//                           customcolor.greytext,
//                       fontWeight: FontWeight.normal),

//                   height: 150,

//                   onTap: (val) {
//                     setState(() {
//                       print("ontap");
//                       print(val.toString());
//                       selectedindex = val; //21feb
//                       tag = 0;
//                       print("ontaptag");
//                       print(tag);
//                       card_startcurrentdatevalue = mainlisttab[maintag]
//                           .details[selectedindex]
//                           .startTimeStr
//                           .toString();
//                       card_endcurrentdatevalue = mainlisttab[maintag]
//                           .details[selectedindex]
//                           .endTimeStr
//                           .toString();
//                       card_superviorfirtvalue = mainlisttab[maintag]
//                           .details[selectedindex]
//                           .supervisorName
//                           .toString();
//                       card_percentvalue = mainlisttab[maintag]
//                           .details[selectedindex]
//                           .percentage
//                           .toString();
//                     });
//                   },

//                   //   indicator:
//                   // //  _tabControllermain.index==selectedindex?
//                   decoration: BoxDecoration(
//                       // border: Border.all(color:
//                       //mainlisttab[maintag].details[selectedindex].status=="Pending"?
//                       //  customcolor.red
//                       //:customcolor.bg
//                       //),
//                       color:
//                           //  mainlisttab[maintag].details[selectedindex].status=="Pending"? customcolor.red:
//                           customcolor.blue.withOpacity(0.2),
//                       // border: Border.all(color:  customcolor.red,),
//                       borderRadius: BorderRadius.all(
//                         Radius.circular(10),
//                       )
//                       //  BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight:Radius.circular(10) )
//                       ),
//                   unselectedDecoration: BoxDecoration(
//                       color: customcolor.white,
//                       borderRadius: BorderRadius.all(Radius.circular(10))
//                       // borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight:Radius.circular(10) )
//                       ),

//                   tabs: tabsmain,

//                   controller: _tabControllermain,
//                 ),
//               ),
//               isdataloaded
//                   ? Padding(
//                       padding: const EdgeInsets.all(6.0),
//                       child: Stack(
//                         children: [
//                           Padding(
//                               padding: EdgeInsets.only(
//                                 right: 0.0,
//                                 left: 0.0,
//                                 top: 15,
//                                 bottom: 4,
//                               ),
//                               child: GestureDetector(
//                                 onTap: () {},
//                                 child: Material(
//                                   elevation: 0,
//                                   borderRadius: BorderRadius.circular(10),
//                                   child: Container(
//                                     width: SizeConfig.blockSizeHorizontal * 100,
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(10),
//                                     ),
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(10.0),
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                         children: [
//                                           // SizedBox(height: 20,),
//                                           Row(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceBetween,
//                                             children: [
//                                               Padding(
//                                                 padding: const EdgeInsets.only(
//                                                     top: 10),
//                                                 child: Container(
//                                                   width: SizeConfig
//                                                           .blockSizeHorizontal *
//                                                       50,
//                                                   child: Column(
//                                                     crossAxisAlignment:
//                                                         CrossAxisAlignment
//                                                             .start,
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment.start,
//                                                     children: [
//                                                       Text(
//                                                         "${card_startcurrentdatevalue}-${card_endcurrentdatevalue}",
//                                                         // "${mainlisttab[maintag].details[selectedindex].startTimeStr} - ${mainlisttab[maintag].details[selectedindex].endTimeStr}",
//                                                         maxLines: 2,
//                                                         textAlign:
//                                                             TextAlign.start,
//                                                         overflow: TextOverflow
//                                                             .ellipsis,

//                                                         style: AppFonts.headerStyle(
//                                                             fontSize:
//                                                                 ResponsiveFlutter.of(
//                                                                         context)
//                                                                     .fontSize(
//                                                                         2.2),
//                                                             color: customcolor
//                                                                 .blue,
//                                                             fontWeight:
//                                                                 FontWeight
//                                                                     .w600),
//                                                       ),
//                                                       SizedBox(
//                                                         height: 10,
//                                                       ),
//                                                       (role ==
//                                                                   GlobalLists
//                                                                       .headrole ||
//                                                               role ==
//                                                                   GlobalLists
//                                                                       .reginalmanagerrole ||
//                                                               role ==
//                                                                   GlobalLists
//                                                                       .clientrole ||
//                                                               role ==
//                                                                   GlobalLists
//                                                                       .operationrole ||
//                                                               role ==
//                                                                   GlobalLists
//                                                                       .operationmanagerrole)
//                                                           ? Text(
//                                                               "$card_superviorfirtvalue",
//                                                               //  "${mainlisttab[maintag].details[selectedindex].supervisorName}",
//                                                               maxLines: 2,
//                                                               textAlign:
//                                                                   TextAlign
//                                                                       .start,
//                                                               overflow:
//                                                                   TextOverflow
//                                                                       .ellipsis,

//                                                               style: AppFonts.headerStyle(
//                                                                   fontSize: ResponsiveFlutter.of(
//                                                                           context)
//                                                                       .fontSize(
//                                                                           2.2),
//                                                                   color:
//                                                                       customcolor
//                                                                           .black,
//                                                                   fontWeight:
//                                                                       FontWeight
//                                                                           .w400),
//                                                             )
//                                                           : Container(),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ),
//                                               Column(
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.end,
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment.start,
//                                                 children: [
//                                                   Container(
//                                                     // color: customcolor.appbarcolor,
//                                                     child:
//                                                         CircularPercentIndicator(
//                                                       animationDuration: 500,
//                                                       //   radius: 35.0,
//                                                       lineWidth: 4.0,
//                                                       radius: 34.0,
//                                                       //   lineWidth: 5.0,
//                                                       animation: true,
//                                                       percent:
//                                                           //0.0,
//                                                           //double.parse(card_percentvalue)>100.0?0.0:double.parse(card_percentvalue)/100,
//                                                           double.parse(
//                                                                       card_percentvalue) >
//                                                                   100.0
//                                                               ? 0.0
//                                                               : double.parse(
//                                                                       card_percentvalue) /
//                                                                   100,
//                                                       //  mainlisttab[maintag].details[selectedindex].percentage>100.0?0.0: mainlisttab[maintag].details[selectedindex].percentage/100,
//                                                       center: new Text(
//                                                         // "",
//                                                         "${double.parse(card_percentvalue).toStringAsFixed(0)}%",
//                                                         //  "${mainlisttab[maintag].details[selectedindex].percentage.toStringAsFixed(0)}%",
//                                                         style: AppFonts
//                                                             .headerStyle(
//                                                                 fontSize: 15,
//                                                                 color:
//                                                                     customcolor
//                                                                         .yellow,
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .bold),
//                                                       ),

//                                                       circularStrokeCap:
//                                                           CircularStrokeCap
//                                                               .round,
//                                                       progressColor:
//                                                           customcolor.blue,
//                                                     ),
//                                                   ),
//                                                   (role ==
//                                                               GlobalLists
//                                                                   .headrole ||
//                                                           role ==
//                                                               GlobalLists
//                                                                   .reginalmanagerrole ||
//                                                           role ==
//                                                               GlobalLists
//                                                                   .clientrole ||
//                                                           role ==
//                                                               GlobalLists
//                                                                   .operationrole ||
//                                                           role ==
//                                                               GlobalLists
//                                                                   .operationmanagerrole)
//                                                       ? SizedBox(
//                                                           height: 0,
//                                                         )
//                                                       : SizedBox(
//                                                           height: 7,
//                                                         ),
//                                                   (role ==
//                                                               GlobalLists
//                                                                   .headrole ||
//                                                           role ==
//                                                               GlobalLists
//                                                                   .reginalmanagerrole ||
//                                                           role ==
//                                                               GlobalLists
//                                                                   .clientrole ||
//                                                           role ==
//                                                               GlobalLists
//                                                                   .operationrole ||
//                                                           role ==
//                                                               GlobalLists
//                                                                   .operationmanagerrole)
//                                                       ? Container()
//                                                       : Text(
//                                                           "${mainlisttab[maintag].details[0].uncheckCount.toString()} Task Pending",
//                                                           maxLines: 2,
//                                                           textAlign:
//                                                               TextAlign.start,
//                                                           overflow: TextOverflow
//                                                               .ellipsis,
//                                                           style: AppFonts.headerStyle(
//                                                               fontSize:
//                                                                   ResponsiveFlutter.of(
//                                                                           context)
//                                                                       .fontSize(
//                                                                           2),
//                                                               color: customcolor
//                                                                   .appbarcolor,
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .bold),
//                                                         ),
//                                                 ],
//                                               ),
//                                             ],
//                                           ),

//                                           // Container(
//                                           //   height: 5,
//                                           // ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               )),
//                           //
//                         ],
//                       ),
//                     )
//                   : Container(),
//               //  StatefulBuilder(builder: (thisLowerContext, innerSetState) {
//               Expanded(
//                 flex: 3,
//                 child: TabBarView(
//                   physics: ScrollPhysics(),
//                   controller: _tabControllermain,
//                   children: List.generate(tabsmain.length, (tabindexmain) {
//                     // setState(() {
//                     // tag=0;
//                     // });
//                     return Column(
//                       //  shrinkWrap: true,
//                       //  physics: ScrollPhysics(),
//                       children: [
//                         SizedBox(
//                           height: 10,
//                         ),
//                         // Container()
//                         //7dec
//                         Container(
//                             height: SizeConfig.blockSizeVertical * 55,
//                             child: operationmasterarea(tabindexmain))
//                       ],
//                     );
//                   }),
//                 ),
//               )
//               //  }
//               //   ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   masterarea(int tabindexmain) {
//     //selectedindexmain=1;
//     print("MASTERARE");
//     print(tabindexmain);
//     tabs = [];
//     listtab = [];
//     String status = "";

//     _tabController = new TabController(
//       vsync: this,
//       length:
//           //      5
//           GlobalLists
//               .workflowstatuslist[tabindexmain].masterAreaWiseList.length,
//     );

//     print("TABCONTROLE ${_tabController.index.toString()}");
//     print("selectedindexmain ${selectedindexmain.toString()}");
//     for (int j = 0;
//         j <
//             GlobalLists
//                 .workflowstatuslist[tabindexmain].masterAreaWiseList.length;
//         j++) {
//       setState(() {
//         listtab.add(
//             GlobalLists.workflowstatuslist[tabindexmain].masterAreaWiseList[j]);
//         status = GlobalLists
//             .workflowstatuslist[tabindexmain].masterAreaWiseList[j].status;
//         tabs.add(
//           new Tab(
//             ///    text: GlobalLists.workflowstatuslist[tabindexmain].masterAreaWiseList[j].masterAreaName,
//             child: Container(
//               // height: 35,
//               width: SizeConfig.blockSizeHorizontal * 25,
//               decoration: j == selectedindexmain
//                   ? BoxDecoration(
//                       color: customcolor.blue,
//                       borderRadius: BorderRadius.all(Radius.circular(20)),
//                     )
//                   : BoxDecoration(
//                       color: GlobalLists.workflowstatuslist[tabindexmain]
//                                   .masterAreaWiseList[j].status ==
//                               "Pending"
//                           ? customcolor.darkorange
//                           : customcolor.blue.withOpacity(0.2),
//                       borderRadius: BorderRadius.all(Radius.circular(20)),
//                     ),
//               child: Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: Text(
//                     "${GlobalLists.workflowstatuslist[tabindexmain].masterAreaWiseList[j].masterAreaName}",
//                     style: AppFonts.headerStyle(
//                         fontSize: 12,
//                         color: customcolor.white,
//                         fontWeight: FontWeight.normal),
//                   )),
//             ),
//           ),
//         );
//       });
//       print("forloop");
//       print("tab of masrter");
//       print(tabs.length);
//       //  print(GlobalLists.workflowstatuslist[i].masterAreaWiseList[j]);
//       for (int k = 0;
//           k <
//               GlobalLists.workflowstatuslist[tabindexmain].masterAreaWiseList[j]
//                   .blockData.length;
//           k++) {
//         setState(() {
//           mainlist.add(PendingTask(
//             maintaskname: GlobalLists.workflowstatuslist[tabindexmain]
//                 .masterAreaWiseList[j].blockData[k].masterAreaName,
//             listvalue: GlobalLists.workflowstatuslist[tabindexmain]
//                 .masterAreaWiseList[j].blockData[k].checklist,
//             multipleSelected: [],
//             isenabledclick: false,
//             masterareaid: GlobalLists.workflowstatuslist[tabindexmain]
//                 .masterAreaWiseList[j].blockData[k].masterArea
//                 .toString(),
//             masterblockid: GlobalLists.workflowstatuslist[tabindexmain]
//                 .masterAreaWiseList[j].blockData[k].masterBlock
//                 .toString(),
//           ));
//         });
//       }
//     }

//     return isdataloaded == false
//         ? Container()
//         : Padding(
//             padding: const EdgeInsets.only(left: 6, right: 6, bottom: 6),
//             child: ListView(
//               shrinkWrap: true,
//               physics: ScrollPhysics(),
//               children: [
//                 //card was here in supervisor

//                 // SizedBox(height: 10,),
//                 Container(
//                   child: Text(
//                     "Master Area",
//                     style: AppFonts.headerStyle(
//                         fontSize: ResponsiveFlutter.of(context).fontSize(2.2),
//                         color: customcolor.black,
//                         fontWeight: FontWeight.w400),
//                   ),
//                 ),

//                 //priority
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Container(
//                   alignment: Alignment.centerLeft,
//                   child: Wrap(
//                     spacing: 5.0,
//                     runSpacing: 3.0,
//                     children: _buildChoiceList(),
//                   ),
//                 ),
//                 //}),
//                 expandedheader(tag, tabindexmain),
//                 Container(
//                   // height: SizeConfig.blockSizeVertical*40,
//                   decoration: BoxDecoration(
//                     //color: Colors.white,
//                     shape: BoxShape.rectangle,
//                     borderRadius: BorderRadius.circular(10),
//                     border: Border.all(
//                       color: customcolor.greyborder,
//                       width: 0.4,
//                     ),
//                   ),

//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       //                     StatefulBuilder(
//                       //         builder: (BuildContext context, StateSetter setStateDialgoue) {
//                       // return
//                       //                        Container(
//                       //                                           alignment: Alignment.centerLeft,
//                       //                                           child:
//                       //                                           Wrap(
//                       //   spacing: 5.0,
//                       //   runSpacing: 3.0,
//                       //   children: _buildChoiceList(),
//                       // ),

//                       //                                         ),
//                       //                       //}),
//                       //                                       expandedheader(tag,tabindexmain),
// //
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           );
//   }

// //operation masteraree
//   operationmasterarea(int tabindexmain) {
//     //selectedindexmain=1;
//     print("operationMASTERARE");
//     // print(tabindexmain);
//     tabs = [];
//     operationlisttab = [];
//     String status = "";

// //  print("length tab ${mainlisttab[maintag].details[tabindexmain].masterAreaWiseList.length.toString()}");
//     _tabController = new TabController(
//       vsync: this,
//       length:
//           //      5
//           mainlisttab[maintag].details[tabindexmain].masterAreaWiseList.length,
//     );

//     print("TABCONTROLE ${_tabController.index.toString()}");
//     print("selectedindexmain ${selectedindexmain.toString()}");
//     for (int j = 0;
//         j <
//             mainlisttab[maintag]
//                 .details[tabindexmain]
//                 .masterAreaWiseList
//                 .length;
//         j++) {
//       setState(() {
//         operationlisttab.add(
//             mainlisttab[maintag].details[tabindexmain].masterAreaWiseList[j]);
//         status = mainlisttab[maintag]
//             .details[tabindexmain]
//             .masterAreaWiseList[j]
//             .pendingArea
//             .toString();
//         tabs.add(
//           new Tab(
//             ///    text: GlobalLists.workflowstatuslist[tabindexmain].masterAreaWiseList[j].masterAreaName,
//             child: Container(
//               // height: 35,
//               width: SizeConfig.blockSizeHorizontal * 25,
//               decoration: j == selectedindexmain
//                   ? BoxDecoration(
//                       color: customcolor.blue,
//                       borderRadius: BorderRadius.all(Radius.circular(20)),
//                     )
//                   : BoxDecoration(
//                       color: mainlisttab[maintag]
//                                   .details[tabindexmain]
//                                   .masterAreaWiseList[j]
//                                   .status ==
//                               "Pending"
//                           ? customcolor.darkorange
//                           : customcolor.blue.withOpacity(0.2),
//                       borderRadius: BorderRadius.all(Radius.circular(20)),
//                     ),
//               child: Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: Text(
//                     "${mainlisttab[maintag].details[tabindexmain].masterAreaWiseList[j].masterAreaName}",
//                     style: AppFonts.headerStyle(
//                         fontSize: 12,
//                         color: customcolor.white,
//                         fontWeight: FontWeight.normal),
//                   )),
//             ),
//           ),
//         );
//       });
//       print("forloop");
//       print("tab of masrter");
//       print(tabs.length);
//       //  print(GlobalLists.workflowstatuslist[i].masterAreaWiseList[j]);
//       for (int k = 0;
//           k <
//               mainlisttab[maintag]
//                   .details[tabindexmain]
//                   .masterAreaWiseList[j]
//                   .blockData
//                   .length;
//           k++) {
//         setState(() {
//           mainlist.add(OperationalPendingTask(
//             maintaskname: mainlisttab[maintag]
//                 .details[tabindexmain]
//                 .masterAreaWiseList[j]
//                 .blockData[k]
//                 .masterAreaName,
//             listvalue: mainlisttab[maintag]
//                 .details[tabindexmain]
//                 .masterAreaWiseList[j]
//                 .blockData[k]
//                 .checklist,
//             multipleSelected: [],
//             isenabledclick: false,
//             masterareaid: mainlisttab[maintag]
//                 .details[tabindexmain]
//                 .masterAreaWiseList[j]
//                 .blockData[k]
//                 .masterArea
//                 .toString(),
//             masterblockid: mainlisttab[maintag]
//                 .details[tabindexmain]
//                 .masterAreaWiseList[j]
//                 .blockData[k]
//                 .masterBlock
//                 .toString(),
//           ));
//         });
//       }
//     }

//     return isdataloaded == false
//         ? Container()
//         : Padding(
//             padding: const EdgeInsets.only(left: 6, right: 6, bottom: 6),
//             child: ListView(
//               shrinkWrap: true,
//               physics: ScrollPhysics(),
//               children: [
//                 //card was here in supervisor

//                 // SizedBox(height: 10,),
//                 Container(
//                   child: Text(
//                     "Master Area",
//                     style: AppFonts.headerStyle(
//                         fontSize: ResponsiveFlutter.of(context).fontSize(2.2),
//                         color: customcolor.black,
//                         fontWeight: FontWeight.w400),
//                   ),
//                 ),

//                 //priority
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Container(
//                   // height: SizeConfig.blockSizeVertical*45,
//                   decoration: BoxDecoration(
//                     //color: Colors.white,
//                     shape: BoxShape.rectangle,
//                     borderRadius: BorderRadius.circular(10),
//                     border: Border.all(
//                       color: customcolor.greyborder,
//                       width: 0.4,
//                     ),
//                   ),

//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       //                     StatefulBuilder(
//                       //         builder: (BuildContext context, StateSetter setStateDialgoue) {
//                       // return
//                       Container(
//                         alignment: Alignment.centerLeft,
//                         child: Wrap(
//                           spacing: 5.0,
//                           runSpacing: 3.0,
//                           children: _buildoperationChoiceList(),
//                         ),
//                       ),
//                       //}),
//                       //7dec
//                       operationexpandedheader(tabindexmain, tag)

// //
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           );
//   }

// //commentedno
//   expandedheader(int tabindexmain, int tabindex) {
//     print("mainlistRU");
//     // print(mainlist.length);
//     // print(tabindexmain.toString());
//     //   print("tag $tabindex.toString()");
//     // print(mainlist[index].multipleSelected);
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         SizedBox(
//           height: 15,
//         ),
//         Container(
//           child: Text(
//             "Master Blocks",
//             style: AppFonts.headerStyle(
//                 fontSize: ResponsiveFlutter.of(context).fontSize(2.2),
//                 color: customcolor.black,
//                 fontWeight: FontWeight.w400),
//           ),
//         ),

//         //priority
//         SizedBox(
//           height: 10,
//         ),
//         StatefulBuilder(
//             builder: (BuildContext context, StateSetter setStateDialgoue) {
//           return ListView.builder(
//             shrinkWrap: true,
//             physics: ScrollPhysics(),
//             itemBuilder: (BuildContext context, int index) {
//               return GestureDetector(
//                 onTap: () {
//                   setStateDialgoue(() {
//                     expand =
//                         ((tapped == null) || ((index == tapped) || !expand))
//                             ? !expand
//                             : expand;

//                     /// This tracks which index was tapped
//                     tapped = index;
//                     debugPrint('current expand state: $expand');
//                     print("drop");

//                     // print(GlobalLists.workflowstatuslist[tabindex].blocksData[index].masterBlock);
//                   });
//                 },
//                 child: Card(
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.all(
//                           Radius.circular(5),
//                         ),
//                         side: BorderSide(
//                             color: GlobalLists
//                                         .workflowstatuslist[tabindex]
//                                         .masterAreaWiseList[tabindexmain]
//                                         .blockData[index]
//                                         .blockPending ==
//                                     0
//                                 ? customcolor.red
//                                 : customcolor.green //changes7feb
//                             )),
//                     child:
//                         //  Container(child: Text(
//                         //   // tabindex.toString())
//                         //    GlobalLists.workflowstatuslist[tabindex].masterAreaWiseList[tabindexmain].blockData[index].masterBlockName),
//                         //   )
//                         GlobalLists
//                                     .workflowstatuslist[tabindex]
//                                     .masterAreaWiseList[tabindexmain]
//                                     .blockData
//                                     .length >
//                                 0
//                             ? expandableListView(
//                                 index,
//                                 tabindex,
//                                 GlobalLists
//                                     .workflowstatuslist[tabindex]
//                                     .masterAreaWiseList[tabindexmain]
//                                     .blockData[index]
//                                     .masterBlockName,
//                                 //  mainlist[index].maintaskname,
//                                 GlobalLists
//                                     .workflowstatuslist[tabindex]
//                                     .masterAreaWiseList[tabindexmain]
//                                     .blockData[index]
//                                     .checklist,
//                                 // mainlist[index].listvalue,
//                                 [],
//                                 //true
//                                 index == tapped ? expand : false,
//                                 GlobalLists
//                                     .workflowstatuslist[tabindex]
//                                     .masterAreaWiseList[tabindexmain]
//                                     .blockData[index]
//                                     .masterArea
//                                     .toString(),
//                                 GlobalLists
//                                     .workflowstatuslist[tabindex]
//                                     .masterAreaWiseList[tabindexmain]
//                                     .blockData[index]
//                                     .masterBlock
//                                     .toString(),
//                                 tabindexmain)
//                             : Container()),
//               );
//             },
//             itemCount: GlobalLists.workflowstatuslist[tabindex]
//                 .masterAreaWiseList[tabindexmain].blockData.length,
//           );
//         }),
//       ],
//     );
//   }

// //opertatio
//   operationexpandedheader(int tabindexmain, int tabindex) {
//     print("RUCHITARANE $tabindex");
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         SizedBox(
//           height: 15,
//         ),
//         Container(
//           child: Text(
//             "Master Blocks",
//             style: AppFonts.headerStyle(
//                 fontSize: ResponsiveFlutter.of(context).fontSize(2.2),
//                 color: customcolor.black,
//                 fontWeight: FontWeight.w400),
//           ),
//         ),

//         //priority
//         SizedBox(
//           height: 10,
//         ),
//         StatefulBuilder(
//             builder: (BuildContext context, StateSetter setStateDialgoue) {
//           return ListView.builder(
//             shrinkWrap: true,
//             physics: ScrollPhysics(),
//             itemBuilder: (BuildContext context, int index) {
//               return GestureDetector(
//                 onTap: () {
//                   setStateDialgoue(() {
//                     expand =
//                         ((tapped == null) || ((index == tapped) || !expand))
//                             ? !expand
//                             : expand;

//                     /// This tracks which index was tapped
//                     tapped = index;
//                     debugPrint('current expand state: $expand');
//                     print("drop");

//                     // print(GlobalLists.workflowstatuslist[tabindex].blocksData[index].masterBlock);
//                   });
//                 },
//                 child: Card(
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.all(
//                           Radius.circular(5),
//                         ),
//                         side: BorderSide(
//                             color: mainlisttab[maintag]
//                                         .details[tabindexmain]
//                                         .masterAreaWiseList[tag]
//                                         .blockData[index]
//                                         .blockPending ==
//                                     0
//                                 ? customcolor.red
//                                 : customcolor.green) //changes7feb

//                         ),
//                     child:
//                         //Container(child: Text("data"),)
//                         mainlisttab[maintag]
//                                     .details[tabindexmain]
//                                     .masterAreaWiseList[tag]
//                                     .blockData
//                                     .length >
//                                 0
//                             ? expandableoperationListView(
//                                 index,
//                                 tag,
//                                 mainlisttab[maintag]
//                                     .details[tabindexmain]
//                                     .masterAreaWiseList[tag]
//                                     .blockData[index]
//                                     .masterBlockName,
//                                 //  mainlist[index].maintaskname,
//                                 mainlisttab[maintag]
//                                     .details[tabindexmain]
//                                     .masterAreaWiseList[tag]
//                                     .blockData[index]
//                                     .checklist,
//                                 // mainlist[index].listvalue,
//                                 mainlist[index].multipleSelected,
//                                 //true
//                                 index == tapped ? expand : false,
//                                 mainlisttab[maintag]
//                                     .details[tabindexmain]
//                                     .masterAreaWiseList[tag]
//                                     .blockData[index]
//                                     .masterArea
//                                     .toString(),
//                                 mainlisttab[maintag]
//                                     .details[tabindexmain]
//                                     .masterAreaWiseList[tag]
//                                     .blockData[index]
//                                     .masterBlock
//                                     .toString(),
//                                 tabindexmain)
//                             : Container()),
//               );
//             },
//             itemCount: mainlisttab[maintag]
//                 .details[tabindexmain]
//                 .masterAreaWiseList[tag]
//                 .blockData
//                 .length,
//           );
//         }),
//       ],
//     );
//   }

//   Widget expandableListView(
//       int indexvalue,
//       int tabindex,
//       String title,
//       List<Checklist> checkboxeslist,
//       List multipleSelectedlist,
//       bool isExpanded,
//       String masterareaid,
//       String bloackareaid,
//       int tabindexmain) {
//     selectedindexmain = tabindex;
//     card_startcurrentdatevalue =
//         GlobalLists.workflowstatuslist[selectedindexmain].startTime;
//     card_endcurrentdatevalue =
//         GlobalLists.workflowstatuslist[selectedindexmain].endTime;
//     card_superviorfirtvalue =
//         "${GlobalLists.workflowstatuslist[selectedindexmain].clientName} - ${GlobalLists.workflowstatuslist[selectedindexmain].siteName}";
//     card_percentvalue =
//         GlobalLists.workflowstatuslist[selectedindexmain].percentage.toString();

//     print("R U CHITA");
//     _tabControllermain.addListener(() {
//       print("callinginit");
//       setState(() {
//         tag = 0;
//         selectedindex = 0;
//       });
//     });

//     print(selectedindexmain);

//     print("isexpanded1");

//     print("isexpanded");
//     print(isExpanded);
//     print(title);
//     debugPrint('List item build $indexvalue $isExpanded');
//     debugPrint('List item build $checkboxeslist');

//     return StatefulBuilder(
//         builder: (BuildContext context, StateSetter setStateDialgoue) {
//       return Container(
//         color: customcolor.white,
//         margin: EdgeInsets.symmetric(vertical: 2.0),
//         child: Column(
//           children: <Widget>[
// //
//             Container(
//               color: Colors.white,
//               padding: EdgeInsets.only(left: 20, right: 10, top: 2, bottom: 2),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                   Row(
//                     children: [
//                       // Image.network(img, width: 25, height: 25, errorBuilder:
//                       //     (BuildContext context, Object exception,
//                       //         StackTrace? stackTrace) {
//                       //   return Container();
//                       // }),
//                       // SizedBox(
//                       //   width: 15,
//                       // ),
//                       Container(
//                         width: SizeConfig.blockSizeHorizontal * 70,
//                         child: Text(
//                           title,
//                           style: AppFonts.headerStyle(
//                               fontSize: 16,
//                               color: GlobalLists
//                                           .workflowstatuslist[tabindex]
//                                           .masterAreaWiseList[tabindexmain]
//                                           .blockData[indexvalue]
//                                           .blockPending ==
//                                       0
//                                   ? customcolor.red
//                                   : customcolor.green,
//                               //changes7feb
//                               fontWeight: FontWeight.w400),
//                         ),
//                       ),
//                     ],
//                   ),
//                   Icon(
//                     isExpanded
//                         ? Icons.keyboard_arrow_up
//                         : Icons.keyboard_arrow_down,
//                     color: Colors.black,
//                     size: 30.0,
//                   ),
//                 ],
//               ),
//             ),

//             ExpandableContainer(
//               expanded: isExpanded,
//               expandedHeight: (role == GlobalLists.headrole ||
//                       role == GlobalLists.reginalmanagerrole ||
//                       role == GlobalLists.clientrole ||
//                       role == GlobalLists.operationrole ||
//                       role == GlobalLists.operationmanagerrole)
//                   ? checkboxeslist.length <= 2
//                       ? SizeConfig.blockSizeHorizontal * 20
//                       : SizeConfig.blockSizeHorizontal * 40
//                   : checkboxeslist.length <= 3
//                       ? SizeConfig.blockSizeHorizontal * 40
//                       : SizeConfig.blockSizeHorizontal * 70,
//               child: Scrollbar(
//                 thumbVisibility: true,
//                 // thumbVisibility: true,
//                 child: ListView(
//                   shrinkWrap: true,
//                   physics: ScrollPhysics(),
//                   children: [
//                     //      Padding(
//                     //   padding: const EdgeInsets.only(left: 5,right:5),
//                     //   child: Divider(color: customcolor.greytext,thickness: 0.5,),
//                     // ),
//                     Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: (role == GlobalLists.headrole ||
//                               role == GlobalLists.reginalmanagerrole ||
//                               role == GlobalLists.clientrole ||
//                               role == GlobalLists.operationrole ||
//                               role == GlobalLists.operationmanagerrole)
//                           ? List.generate(
//                               checkboxeslist.length,
//                               (indexcheck) => ListTileTheme(
//                                 horizontalTitleGap: 0,
//                                 minVerticalPadding: 0,
//                                 child: Theme(
//                                     data: ThemeData(
//                                         unselectedWidgetColor:
//                                             customcolor.greytext),
//                                     child:
//                                         //mainlist[indexvalue].isenabledclick?
//                                         Padding(
//                                       padding: const EdgeInsets.only(
//                                           top: 8, bottom: 8),
//                                       child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Container(
//                                             width:
//                                                 SizeConfig.blockSizeHorizontal *
//                                                     65,
//                                             child: Text(
//                                               checkboxeslist[indexcheck]
//                                                   .pointerName,
//                                               maxLines: 1,
//                                               style: AppFonts.headerStyle(
//                                                   fontSize: 12,
//                                                   color: Colors.black,
//                                                   fontWeight:
//                                                       FontWeight.normal),
//                                             ),
//                                           ),
//                                           Text(
//                                             checkboxeslist[indexcheck]
//                                                         .checked ==
//                                                     true
//                                                 ? "Completed"
//                                                 : "Pending",
//                                             style: AppFonts.headerStyle(
//                                                 fontSize: 12,
//                                                 color:
//                                                     checkboxeslist[indexcheck]
//                                                                 .checked ==
//                                                             true
//                                                         ? customcolor.green
//                                                         : customcolor.red,
//                                                 fontWeight: FontWeight.normal),
//                                           ),
//                                         ],
//                                       ),
//                                     )),
//                               ),
//                             )
//                           : List.generate(
//                               checkboxeslist.length,
//                               (indexcheck) => ListTileTheme(
//                                 contentPadding: EdgeInsets.all(0),
//                                 horizontalTitleGap: 0,
//                                 dense: true,
//                                 minVerticalPadding: -4,
//                                 child: Theme(
//                                     data: ThemeData(
//                                         unselectedWidgetColor:
//                                             customcolor.greytext),
//                                     child:
//                                         //mainlist[indexvalue].isenabledclick?
//                                         CheckboxListTile(
//                                       activeColor: customcolor.green,
//                                       visualDensity: VisualDensity.compact,
//                                       controlAffinity:
//                                           ListTileControlAffinity.leading,
//                                       contentPadding: EdgeInsets.all(0),
//                                       dense: true,
//                                       title: Text(
//                                         checkboxeslist[indexcheck].pointerName,
//                                         style: AppFonts.headerStyle(
//                                             fontSize: 14,
//                                             color: checkboxeslist[indexcheck]
//                                                         .checked ==
//                                                     true
//                                                 ? customcolor.green
//                                                 : Colors.black,
//                                             fontWeight: FontWeight.normal),
//                                       ),
//                                       value: checkboxeslist[indexcheck].checked,
//                                       onChanged: (value) {
//                                         setStateDialgoue(() {
//                                           if (checkboxeslist[indexcheck]
//                                               .finalCheck) {
//                                           } else {
//                                             checkboxeslist[indexcheck].checked =
//                                                 value!;
//                                           }
//                                           print("multipleSelectedlist");
//                                           print(multipleSelectedlist);
//                                           print(checkboxeslist[indexcheck]);

//                                           if (multipleSelectedlist.contains(
//                                               checkboxeslist[indexcheck])) {
//                                             multipleSelectedlist.remove(
//                                                 checkboxeslist[indexcheck]);
//                                           } else {
//                                             multipleSelectedlist.add(
//                                                 checkboxeslist[indexcheck]);
//                                           }
//                                         });
//                                       },
//                                     )),
//                               ),
//                             ),
//                     ),

//                     (role == GlobalLists.headrole ||
//                             role == GlobalLists.reginalmanagerrole ||
//                             role == GlobalLists.clientrole ||
//                             role == GlobalLists.operationrole ||
//                             role == GlobalLists.operationmanagerrole)
//                         ? Container()
//                         : Column(
//                             children: [
//                               SizedBox(
//                                 height: 15,
//                               ),
//                               MyElevatedButton(
//                                 setStyleStr: 'home',
//                                 width: 120,
//                                 height: SizeConfig.blockSizeVertical * 6,
//                                 onPressed: () {
//                                   print("multipleSelectedlist");
//                                   // print(multipleSelectedlist.checklistId.toString());
//                                   List<String> checkedid = [];
//                                   List<String> uncheckedid = [];
//                                   //  for(int i=0;i<multipleSelectedlist.length;i++)
//                                   //  {
//                                   //   checkedid.add(multipleSelectedlist[i].id.toString());
//                                   //  }
//                                   for (int i = 0;
//                                       i < checkboxeslist.length;
//                                       i++) {
//                                     if (!checkboxeslist[i].checked) {
//                                       uncheckedid
//                                           .add(checkboxeslist[i].id.toString());
//                                     } else {
//                                       checkedid
//                                           .add(checkboxeslist[i].id.toString());
//                                     }
//                                   }
//                                   print("checkedid");
//                                   print("Calledupdate");
//                                   print("check $checkedid");
//                                   print("uncheck $uncheckedid");
//                                   print(masterareaid);
//                                   print(bloackareaid);
//                                   updatedworkflowstatusApi(
//                                       widget.shiftid,
//                                       checkedid,
//                                       uncheckedid,
//                                       masterareaid,
//                                       bloackareaid);
//                                 },
//                                 borderRadius: BorderRadius.circular(5),
//                                 colorvalue: customcolor.blue,
//                                 child: Text('Update'),
//                               ),
//                             ],
//                           ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                   ],
//                 ),
//               ),
//             )
//           ],
//         ),
//       );
//     });
//   }

//   Widget expandableoperationListView(
//       int indexvalue,
//       int tabindex,
//       String title,
//       List<operwf.Checklist> checkboxeslist,
//       List multipleSelectedlist,
//       bool isExpanded,
//       String masterareaid,
//       String bloackareaid,
//       int tabindexmain) {
//     selectedindexmain = tabindex;
//     card_startcurrentdatevalue =
//         mainlisttab[maintag].details[tabindexmain].startTimeStr.toString();
//     card_endcurrentdatevalue =
//         mainlisttab[maintag].details[tabindexmain].endTimeStr.toString();
//     card_superviorfirtvalue =
//         mainlisttab[maintag].details[tabindexmain].supervisorName.toString();
//     card_percentvalue =
//         mainlisttab[maintag].details[tabindexmain].percentage.toString();
//     print(selectedindexmain);
//     _tabControllermain.addListener(() {
//       print("callinginit");
//       setState(() {
//         tag = 0;
//         selectedindex = 0;
//       });
//     });
//     print("RANGA");
//     print("maintag $maintag");
//     print("tabindexmain $tabindexmain");
//     print("index $tabindex");
//     print(selectedindexmain);
//     print("isexpanded1");

//     print("isexpanded");
//     print(isExpanded);
//     print(title);
//     debugPrint('List item build $indexvalue $isExpanded');
//     debugPrint('List item build $checkboxeslist');

//     return StatefulBuilder(
//         builder: (BuildContext context, StateSetter setStateDialgoue) {
//       return Container(
//         color: customcolor.white,
//         margin: EdgeInsets.symmetric(vertical: 2.0),
//         child: Column(
//           children: <Widget>[
// //
//             Container(
//               color: Colors.white,
//               padding: EdgeInsets.only(left: 20, right: 10, top: 2, bottom: 2),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                   Row(
//                     children: [
//                       // Image.network(img, width: 25, height: 25, errorBuilder:
//                       //     (BuildContext context, Object exception,
//                       //         StackTrace? stackTrace) {
//                       //   return Container();
//                       // }),
//                       // SizedBox(
//                       //   width: 15,
//                       // ),
//                       Container(
//                         width: SizeConfig.blockSizeHorizontal * 70,
//                         child: Text(
//                           title,
//                           style: AppFonts.headerStyle(
//                               fontSize: 16,
//                               color: mainlisttab[maintag]
//                                           .details[tabindexmain]
//                                           .masterAreaWiseList[tabindex]
//                                           .blockData[indexvalue]
//                                           .blockPending ==
//                                       0
//                                   ? customcolor.red
//                                   : customcolor.green,
//                               //changes7feb
//                               fontWeight: FontWeight.w400),
//                         ),
//                       ),
//                     ],
//                   ),
//                   Icon(
//                     isExpanded
//                         ? Icons.keyboard_arrow_up
//                         : Icons.keyboard_arrow_down,
//                     color: Colors.black,
//                     size: 30.0,
//                   ),
//                 ],
//               ),
//             ),

//             ExpandableContainer(
//               expanded: isExpanded,
//               expandedHeight: (role == GlobalLists.headrole ||
//                       role == GlobalLists.reginalmanagerrole ||
//                       role == GlobalLists.clientrole ||
//                       role == GlobalLists.operationrole ||
//                       role == GlobalLists.operationmanagerrole)
//                   ? checkboxeslist.length <= 2
//                       ? SizeConfig.blockSizeHorizontal * 20
//                       : SizeConfig.blockSizeHorizontal * 40
//                   : checkboxeslist.length <= 2
//                       ? SizeConfig.blockSizeHorizontal * 40
//                       : SizeConfig.blockSizeHorizontal * 70,
//               child: Scrollbar(
//                 thumbVisibility: true,
//                 // thumbVisibility: true,
//                 child: ListView(
//                   shrinkWrap: true,
//                   physics: ScrollPhysics(),
//                   children: [
//                     //      Padding(
//                     //   padding: const EdgeInsets.only(left: 5,right:5),
//                     //   child: Divider(color: customcolor.greytext,thickness: 0.5,),
//                     // ),
//                     Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: (role == GlobalLists.headrole ||
//                               role == GlobalLists.reginalmanagerrole ||
//                               role == GlobalLists.clientrole ||
//                               role == GlobalLists.operationrole ||
//                               role == GlobalLists.operationmanagerrole)
//                           ? List.generate(
//                               checkboxeslist.length,
//                               (indexcheck) => ListTileTheme(
//                                 horizontalTitleGap: 0,
//                                 minVerticalPadding: 0,
//                                 child: Theme(
//                                     data: ThemeData(
//                                         unselectedWidgetColor:
//                                             customcolor.greytext),
//                                     child:
//                                         //mainlist[indexvalue].isenabledclick?
//                                         Padding(
//                                       padding: const EdgeInsets.only(
//                                           top: 8, bottom: 8, left: 8),
//                                       child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Container(
//                                             width:
//                                                 SizeConfig.blockSizeHorizontal *
//                                                     65,
//                                             child: Text(
//                                               checkboxeslist[indexcheck]
//                                                   .pointerName,
//                                               style: AppFonts.headerStyle(
//                                                   fontSize: 12,
//                                                   color: Colors.black,
//                                                   fontWeight:
//                                                       FontWeight.normal),
//                                             ),
//                                           ),
//                                           Text(
//                                             checkboxeslist[indexcheck]
//                                                         .checked ==
//                                                     true
//                                                 ? "Completed"
//                                                 : "Pending",
//                                             style: AppFonts.headerStyle(
//                                                 fontSize: 12,
//                                                 color:
//                                                     checkboxeslist[indexcheck]
//                                                                 .checked ==
//                                                             true
//                                                         ? customcolor.green
//                                                         : customcolor.red,
//                                                 fontWeight: FontWeight.normal),
//                                           ),
//                                         ],
//                                       ),
//                                     )),
//                               ),
//                             )
//                           : List.generate(
//                               checkboxeslist.length,
//                               (indexcheck) => ListTileTheme(
//                                 horizontalTitleGap: 0,
//                                 minVerticalPadding: 0,
//                                 child: Theme(
//                                     data: ThemeData(
//                                         unselectedWidgetColor:
//                                             customcolor.greytext),
//                                     child:
//                                         //mainlist[indexvalue].isenabledclick?
//                                         CheckboxListTile(
//                                       activeColor: customcolor.green,
//                                       controlAffinity:
//                                           ListTileControlAffinity.leading,
//                                       contentPadding: EdgeInsets.zero,
//                                       dense: true,
//                                       title: Text(
//                                         checkboxeslist[indexcheck].pointerName,
//                                         style: AppFonts.headerStyle(
//                                             fontSize: 14,
//                                             color: checkboxeslist[indexcheck]
//                                                         .checked ==
//                                                     true
//                                                 ? customcolor.green
//                                                 : Colors.black,
//                                             fontWeight: FontWeight.normal),
//                                       ),
//                                       value: checkboxeslist[indexcheck].checked,
//                                       onChanged: (value) {
//                                         setStateDialgoue(() {
//                                           checkboxeslist[indexcheck].checked =
//                                               value!;
//                                           print("multipleSelectedlist");
//                                           print(multipleSelectedlist);
//                                           print(checkboxeslist[indexcheck]);

//                                           if (multipleSelectedlist.contains(
//                                               checkboxeslist[indexcheck])) {
//                                             multipleSelectedlist.remove(
//                                                 checkboxeslist[indexcheck]);
//                                           } else {
//                                             multipleSelectedlist.add(
//                                                 checkboxeslist[indexcheck]);
//                                           }
//                                         });
//                                       },
//                                     )),
//                               ),
//                             ),
//                     ),

//                     (role == GlobalLists.headrole ||
//                             role == GlobalLists.reginalmanagerrole ||
//                             role == GlobalLists.clientrole ||
//                             role == GlobalLists.operationrole ||
//                             role == GlobalLists.operationmanagerrole)
//                         ? Container()
//                         : Column(
//                             children: [
//                               SizedBox(
//                                 height: 15,
//                               ),
//                               MyElevatedButton(
//                                 setStyleStr: 'home',
//                                 width: 120,
//                                 height: SizeConfig.blockSizeVertical * 6,
//                                 onPressed: () {
//                                   print("multipleSelectedlist");
//                                   // print(multipleSelectedlist.checklistId.toString());
//                                   List<String> checkedid = [];
//                                   List<String> uncheckedid = [];
//                                   //  for(int i=0;i<multipleSelectedlist.length;i++)
//                                   //  {
//                                   //   checkedid.add(multipleSelectedlist[i].id.toString());
//                                   //  }
//                                   for (int i = 0;
//                                       i < checkboxeslist.length;
//                                       i++) {
//                                     if (!checkboxeslist[i].checked) {
//                                       uncheckedid
//                                           .add(checkboxeslist[i].id.toString());
//                                     } else {
//                                       checkedid
//                                           .add(checkboxeslist[i].id.toString());
//                                     }
//                                   }
//                                   print("checkedid");
//                                   print("Calledupdate");
//                                   print("check $checkedid");
//                                   print("uncheck $uncheckedid");
//                                   print(masterareaid);
//                                   print(bloackareaid);
//                                   updatedworkflowstatusApi(
//                                       widget.shiftid,
//                                       checkedid,
//                                       uncheckedid,
//                                       masterareaid,
//                                       bloackareaid);
//                                 },
//                                 borderRadius: BorderRadius.circular(5),
//                                 colorvalue: customcolor.blue,
//                                 child: Text('Update'),
//                               ),
//                             ],
//                           ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                   ],
//                 ),
//               ),
//             )
//           ],
//         ),
//       );
//     });
//   }

//   _buildChoiceList() {
//     List<Widget> choices = [];
//     listtab.forEachIndexed((item, value) {
//       choices.add(Container(
//         //  color: customcolor.darkorange,
//         child: ChoiceChip(
//           label: Text(item.masterAreaName),

//           labelStyle: AppFonts.headerStyle(
//               fontSize: ResponsiveFlutter.of(context).fontSize(1.6),
//               color: tag == value
//                   ? customcolor.white
//                   : item.status == "Pending"
//                       ? customcolor.white
//                       : item.status == "Completed"
//                           ? customcolor.green
//                           : customcolor.white,
//               fontWeight: FontWeight.w600),

//           // selectedShadowColor: customcolor.blue,
//           //shape: StadiumBorder(side: BorderSide(color:tag == value?customcolor.blue:customcolor.bg )),
//           selectedColor:
//               //  item.status=="Pending"?
//               //   customcolor.red:
//               //   item.status=="Completed"?customcolor.green.withOpacity(0.2):
//               customcolor.blue,

//           backgroundColor: tag == value
//               ? customcolor.blue
//               : item.status == "Pending"
//                   ? customcolor.red
//                   : item.status == "Completed"
//                       ? customcolor.green.withOpacity(0.2)
//                       : customcolor.blue,
//           selected: tag == value,
//           onSelected: (selected) {
//             setState(() {
//               _isSelected = item.masterAreaName;
//               tag = value;
//             });
//           },
//         ),
//       ));
//     });
//     return choices;
//   }

// //operation
//   _buildoperationChoiceList() {
//     List<Widget> choices = [];
//     operationlisttab.forEachIndexed((item, value) {
//       choices.add(Container(
//         //  color: customcolor.darkorange,
//         child: ChoiceChip(
//           label: Text(item.masterAreaName),
//           labelStyle: AppFonts.headerStyle(
//               fontSize: ResponsiveFlutter.of(context).fontSize(1.6),
//               color: tag == value
//                   ? customcolor.white
//                   : item.status == "Pending"
//                       ? customcolor.white
//                       : item.status == "Completed"
//                           ? customcolor.green
//                           : customcolor.white,
//               fontWeight: FontWeight.w600),

//           // selectedColor:customcolor.blue,
//           //shape: StadiumBorder(side: BorderSide(color:tag == value?customcolor.blue:customcolor.bg )),
//           selectedColor:
//               //  item.status=="Pending"?
//               //   customcolor.red:
//               //   item.status=="Completed"?customcolor.green.withOpacity(0.2):
//               customcolor.blue,
//           backgroundColor: item.status == "Pending"
//               ? customcolor.red
//               : item.status == "Completed"
//                   ? customcolor.green.withOpacity(0.2)
//                   : customcolor.blue,
//           selected: tag == value,
//           onSelected: (selected) {
//             setState(() {
//               _isSelected = item.masterAreaName;
//               tag = value;
//               // print(tagvalue);
//             });
//           },
//         ),
//       ));
//     });
//     return choices;
//   }

//   workflowstatusApi(String shiftid) async {
//     var status1 = await ConnectionDetector.checkInternetConnection();

//     if (status1) {
//       ShowDialogs.showLoadingDialog(context, _keyLoader);
//       setState(() {
//         GlobalLists.workflowstatuslist = [];
//       });

//       var now = new DateTime.now();
//       var formatter = new DateFormat('yyyy-MM-dd');
//       String formattedDate = formatter.format(now);
//       print(formattedDate); // 2016-01-25
//       var map = new Map<String, dynamic>();
//       print("shiftid");
//       print(shiftid);
//       map['shift_id'] = shiftid;

//       map['client_id'] = GlobalLists.clientid;

//       map['site_id'] = GlobalLists.siteid;
//       map['today_date'] = datecontroller.text; //"18-12-2023";//formattedDate;

//       // map['workflow_type'] ="Regular";
//       APIManager().apiRequest(context, API.workflowstatus, (response) async {
//         WorkfowstatusResponse resp = response;
//         print('called API ${resp}');
//         if (resp.status == 1) {
//           //  ShowDialogs.showToast(resp.msg);
//           setState(() {
//             GlobalLists.workflowstatuslist = resp.data;
//             tabsmain = <Tab>[];
//             selectedindex = 0;
//             card_startcurrentdatevalue =
//                 GlobalLists.workflowstatuslist[selectedindex].startTime;
//             card_endcurrentdatevalue =
//                 GlobalLists.workflowstatuslist[selectedindex].endTime;
//             card_superviorfirtvalue =
//                 "${GlobalLists.workflowstatuslist[selectedindex].clientName} - ${GlobalLists.workflowstatuslist[selectedindex].siteName}";
//             card_percentvalue = GlobalLists
//                 .workflowstatuslist[selectedindex].percentage
//                 .toString();
//             for (int i = 0; i < GlobalLists.workflowstatuslist.length; i++) {
//               if (GlobalLists.workflowstatuslist[i].currentTime == true) {
//                 print("selectedindextagselect");
//                 selectedindex = i;
//                 print(selectedindex);
//                 card_startcurrentdatevalue =
//                     GlobalLists.workflowstatuslist[selectedindex].startTime;
//                 card_endcurrentdatevalue =
//                     GlobalLists.workflowstatuslist[selectedindex].endTime;
//                 card_superviorfirtvalue =
//                     "${GlobalLists.workflowstatuslist[selectedindex].clientName} - ${GlobalLists.workflowstatuslist[selectedindex].siteName}";
//                 card_percentvalue = GlobalLists
//                     .workflowstatuslist[selectedindex].percentage
//                     .toString();
//                 //  currentvisibletimeindex=i;
//               }
//             }

//             _tabControllermain = new TabController(
//                 vsync: this,
//                 length: GlobalLists.workflowstatuslist.length,
//                 initialIndex: selectedindex);
//             _tabController = new TabController(vsync: this, length: 5);
//             for (int i = 0; i < GlobalLists.workflowstatuslist.length; i++) {
//               tabsmain.add(
//                 new Tab(
//                   child: Text(
//                     "${GlobalLists.workflowstatuslist[i].startTime} -${GlobalLists.workflowstatuslist[i].endTime}",
//                     style: TextStyle(
//                         color: GlobalLists.workflowstatuslist[i].status ==
//                                 "Pending"
//                             ? customcolor.red
//                             : GlobalLists.workflowstatuslist[i].status ==
//                                     "Completed"
//                                 ? customcolor.green
//                                 : customcolor.blue),
//                   ),
//                 ),
//               );

//               print("forloop");
//               print("tab of tabcontrooelr");
//               print(
//                   GlobalLists.workflowstatuslist[i].masterAreaWiseList.length);

//               for (int j = 0;
//                   j <
//                       GlobalLists
//                           .workflowstatuslist[i].masterAreaWiseList.length;
//                   j++) {
//                 setState(() {
//                   //      tabs.add(
//                   //   new Tab(
//                   //    text: GlobalLists.workflowstatuslist[i].masterAreaWiseList[j].masterAreaName,
//                   //   ),
//                   // );
//                 });
//                 print("forloop");
//                 print("tab of masrter");
//                 print(tabs.length);
//               }
//             }
//             isdataloaded = true;

//             //tablist();

//             Navigator.of(this.context).pop();
//           });
//         } else {
//           ShowDialogs.showToast(resp.msg);
//           Navigator.of(this.context).pop();
//         }
//       }, (error) {
//         print('ERR msg is $error');
//         Navigator.of(this.context).pop();
//         ShowDialogs.showToast("Server Not Responding");
//       }, false, "", jsonval: map);
//     } else {
//       ShowDialogs.showToast("Please check internet connection");
//     }
//   }

//   //operationalworkfloe
//   operationlworkflowstatusApi() async {
//     var status1 = await ConnectionDetector.checkInternetConnection();

//     if (status1) {
//       ShowDialogs.showLoadingDialog(context, _keyLoader);

//       var map = new Map<String, dynamic>();

//       var clientid = await SPManager().getclientid();
//       print(clientid);
//       if (role == GlobalLists.clientrole) {
//         map['clientid'] = clientid;
//         map['today_date'] = datecontroller.text;
//       } else {
//         map['today_date'] = datecontroller.text;
//       }

//       APIManager().apiRequest(context, API.operationalworkflow,
//           (response) async {
//         operwf.OperationalWorkflowResponse resp = response;
//         print('called API ${resp}');
//         if (resp.status == 1) {
//           //  ShowDialogs.showToast(resp.msg);
//           setState(() {
//             mainlisttab = resp.data;
//             GlobalLists.operationalworkflowstatuslist = resp.data;
//             tabsmain = <Tab>[];
//             selectedindex = 0;
//             card_startcurrentdatevalue = mainlisttab[maintag]
//                 .details[selectedindex]
//                 .startTimeStr
//                 .toString();
//             card_endcurrentdatevalue = mainlisttab[maintag]
//                 .details[selectedindex]
//                 .endTimeStr
//                 .toString();
//             card_superviorfirtvalue = mainlisttab[maintag]
//                 .details[selectedindex]
//                 .supervisorName
//                 .toString();
//             card_percentvalue = mainlisttab[maintag]
//                 .details[selectedindex]
//                 .percentage
//                 .toString();
// //  card_startcurrentdatevalue=mainlisttab[maintag].details[0].startTimeStr.toString();
// //                card_endcurrentdatevalue=mainlisttab[maintag].details[0].endTimeStr.toString();
// //                card_superviorfirtvalue=mainlisttab[maintag].details[0].supervisorName.toString();
// //                card_percentvalue=mainlisttab[maintag].details[0].percentage.toString();
//             for (int i = 0; i < mainlisttab[maintag].details.length; i++) {
//               if (mainlisttab[maintag].details[i].currentTime == true) {
//                 print("selectedindextagselect");
//                 selectedindex = i;
//                 //  currentvisibletimeindex=i;
//                 print(selectedindex);
//                 card_startcurrentdatevalue = mainlisttab[maintag]
//                     .details[selectedindex]
//                     .startTimeStr
//                     .toString();
//                 card_endcurrentdatevalue = mainlisttab[maintag]
//                     .details[selectedindex]
//                     .endTimeStr
//                     .toString();
//                 card_superviorfirtvalue = mainlisttab[maintag]
//                     .details[selectedindex]
//                     .supervisorName
//                     .toString();
//                 card_percentvalue = mainlisttab[maintag]
//                     .details[selectedindex]
//                     .percentage
//                     .toString();
//                 //  card_startcurrentdatevalue=mainlisttab[maintag].details[i].startTimeStr.toString();
//                 //  card_endcurrentdatevalue=mainlisttab[maintag].details[i].endTimeStr.toString();
//                 //  card_superviorfirtvalue=mainlisttab[maintag].details[i].supervisorName.toString();
//                 //  card_percentvalue=mainlisttab[maintag].details[i].percentage.toString();
//               }
//             }

//             _tabControllermain = new TabController(
//                 vsync: this,
//                 length: mainlisttab[maintag].details.length,
//                 initialIndex: selectedindex);
//             print(_tabControllermain.length);
//             // _tabController = new TabController(vsync: this, length: 1);
//             for (int i = 0; i < mainlisttab[maintag].details.length; i++) {
//               tabsmain.add(
//                 // new Tab(
//                 //  text: "${mainlisttab[maintag].details[i].startTimeStr}-${mainlisttab[maintag].details[i].endTimeStr}",

//                 // ),
//                 Tab(
//                   child: Text(
//                     "${mainlisttab[maintag].details[i].startTimeStr}-${mainlisttab[maintag].details[i].endTimeStr}",
//                     style: TextStyle(
//                         color:
//                             mainlisttab[maintag].details[i].status == "Pending"
//                                 ? customcolor.red
//                                 : mainlisttab[maintag].details[i].status ==
//                                         "Completed"
//                                     ? customcolor.green
//                                     : customcolor.blue),
//                   ),
//                 ),
//               );
//               if (mainlisttab[maintag].details[i].currentTime == true) {
//                 print("selectedindextagselect");
//                 selectedindex = i;
//                 print(selectedindex);
//                 //    currentvisibletimeindex=i;
//                 //     card_startcurrentdatevalue=mainlisttab[maintag].details[i].startTimeStr.toString();
//                 //  card_endcurrentdatevalue=mainlisttab[maintag].details[i].endTimeStr.toString();
//                 //  card_superviorfirtvalue=mainlisttab[maintag].details[i].supervisorName.toString();
//                 //  card_percentvalue=mainlisttab[maintag].details[i].percentage.toString();
//               }
//             }
// //

//             isdataloaded = true;

//             //tablist();

//             Navigator.of(this.context).pop();
//           });
//         } else {
//           ShowDialogs.showToast(resp.msg);
//           Navigator.of(this.context).pop();
//         }
//       }, (error) {
//         print('ERR msg is $error');
//         Navigator.of(this.context).pop();
//         ShowDialogs.showToast("Server Not Responding");
//       }, false, "", jsonval: map);
//     } else {
//       ShowDialogs.showToast("Please check internet connection");
//     }
//   }

// //updatedworkflowstatus

//   updatedworkflowstatusApi(String shiftid, List<String> checklistid,
//       List<String> unchecklistid, String masterid, String blockid) async {
//     var status1 = await ConnectionDetector.checkInternetConnection();

//     if (status1) {
//       ShowDialogs.showLoadingDialog(context, _keyLoader);

//       var map = new Map<String, dynamic>();
// //String checklist="";
//       //  for(int i=0;i<checklistid.length;i++)
//       //  {
//       //   map['check_list_id'] =checklistid[i] ;
//       //  }

//       // String checklist = checklistid.join(', ');
//       // print(checklist);
//       // map['shift_id'] =shiftid ;

//       //   map['master_area_id'] =masterid ;
//       //    map['master_block_id'] =blockid ;

//       //   //  for(int i=0;i<checklistid.length;i++)
//       //   //  {
//       //     map['check_list_id'] =[2,1];//checklistid;//"${[checklist]}";//checklistid[i] ;

//       dynamic jsonbody = {
//         "shift_id": shiftid,
//         "master_area_id": masterid,
//         "master_block_id": blockid,
//         "check_list_id": checklistid,
//         "uncheck_list_id": unchecklistid,
//       };
//       // }
//       // map['check_list_id1']="2";
//       //  map['check_list_id2']="1";
//       // map['check_list_id'] =checklistid[i] ;

//       APIManager().apiRequest(context, API.updatedworkflowstatus,
//           (response) async {
//         UpdatedworkflowResponse resp = response;
//         print('called API ${resp}');
//         if (resp.status == 1) {
//           ShowDialogs.showToast(resp.msg);
//           Navigator.of(this.context).pop();
//           //  workflowstatusApi(shiftid);
//           Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (BuildContext context) =>
//                       Workflowstatus(GlobalLists.shiftid)));
//         } else {
//           ShowDialogs.showToast(resp.msg);
//           Navigator.of(this.context).pop();
//         }
//       }, (error) {
//         print('ERR msg is $error');
//       }, false, "", parameter: jsonbody);
//     } else {
//       ShowDialogs.showToast("Please check internet connection");
//     }
//   }
// }

// class ExpandableContainer extends StatelessWidget {
//   final bool expanded;
//   final double collapsedHeight;
//   final double expandedHeight;
//   final Widget child;

//   ExpandableContainer({
//     required this.child,
//     this.collapsedHeight = 0.0,
//     this.expandedHeight = 300.0,
//     this.expanded = true,
//   });

//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     return AnimatedContainer(
//       duration: Duration(milliseconds: 500),
//       curve: Curves.easeInOut,
//       width: screenWidth,
//       height: expanded ? expandedHeight : collapsedHeight,
//       child: Padding(
//         padding: const EdgeInsets.only(left: 10, right: 20),
//         // child: Divider(
//         //   color: customcolor.greyborder,
//         // ),
//         child: Container(
//           //  color: Colors.black,
//           child: child,
//           // decoration: BoxDecoration(
//           //     border: Border.all(width: 0.2, color: customcolor.greyborder)),
//         ),
//       ),
//     );
//   }
// }
