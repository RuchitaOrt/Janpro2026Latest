// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'dart:ui';
// import 'package:page_transition/page_transition.dart';
// import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

// import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
// import 'package:grouped_list/grouped_list.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:janpro/Screens/Attendance.dart';
// import 'package:janpro/Screens/Homepage.dart';
// import 'package:janpro/Screens/Training.dart';
// import 'package:janpro/Utitlity/APIManager.dart';
// import 'package:janpro/Utitlity/AppDrawer.dart';
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
// import 'package:janpro/model/GetComplaintResponse.dart' as supercomp;
// import 'package:janpro/model/GetDependentResponse.dart';
// import 'package:janpro/model/MasterBlockResponse.dart';
// import 'package:janpro/model/MasterareaResponse.dart';
// import 'package:janpro/model/TicketllistResponse.dart';
// import 'package:janpro/model/UnitComplaintResponse.dart' as unitcom;
// import 'package:janpro/model/ClientsiteDashboardResponse.dart' as clientdash;
// import 'package:janpro/model/UnitclientMasterResponse.dart';
// import 'package:janpro/model/UpdateTATResponse.dart';
// import 'package:percent_indicator/circular_percent_indicator.dart';
// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart' as date;
// import 'package:responsive_flutter/responsive_flutter.dart';

// import 'dart:math' as math;

// import 'package:syncfusion_flutter_core/theme.dart';
// import 'package:syncfusion_flutter_sliders/sliders.dart';
// import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
// import 'package:http_parser/http_parser.dart';
// import 'package:http/http.dart' as http;

// class Complaint extends StatefulWidget {
//   bool isnotify;
//   String roleid;
//   String siteid;
//   String clientid;
//   String date;
//   String initalid;
//   String status;
//   Complaint(this.isnotify, this.roleid, this.siteid, this.clientid, this.date,
//       this.initalid, this.status);

//   @override
//   _ComplaintState createState() => _ComplaintState();
// }

// class _ComplaintState extends State<Complaint> with TickerProviderStateMixin {
//   ItemScrollController _scrollController = ItemScrollController();

// //  ItemScrollController itemScrollController = ItemScrollController();
// //  ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
//   var statuscontroller = new TextEditingController();
//   final List<double> values = [0.5, 5.0, 10.0, 15.0];
//   int selectedIndex = 0;
//   String selectedValue = "Pending";
//   late TabController _tabController;
//   final GlobalKey<State> _keyLoader = new GlobalKey<State>();
//   var selectedDateTime;

//   //bool isoptionopen=false;
//   List<String> options = [
//     "TAT",
//     "Dependent",
//     "Resolved",
//   ];
//   var datecontroller = new TextEditingController();
//   var datetatcontroller = new TextEditingController();
//   double containerHeight = 0;
//   int maintag = 0;
//   String _isSelected = "";
//   List _dependentelements = [];
//   List _pendingelements = [];
//   List _resolvedelements = [];
//   bool isexpanded = false;
//   bool isexpandedcomplaint = false;
//   var duration = "";
//   late DateTime selectedtime;
//   String attendanceclientid = "";
//   String attendancesiteid = "";
//   String siteidconfig = "";
//   String complainttype = "";
//   String blockid = "";
// //   {'name': 'Ground Floor -Washroom', 'subname':'With Instabug, it’s easy for beta testers to send you detail-rich bug reports and feedback, and even easier for you to reproduce and debug issues.','group': 'Today'},
// //   {'name': 'Basemenr',  'subname':'With Instabug, it’s easy for beta testers to send you detail-rich bug reports and feedback, and even easier for you to reproduce and debug issues.','group': '19-07-2023'},
// //   {'name': 'Ground Floor -Washroom', 'subname':'With Instabug, it’s easy for beta testers to send you detail-rich bug reports and feedback, and even easier for you to reproduce and debug issues.', 'group': 'Today'},
// //   {'name': 'Basement',  'subname':'With Instabug, it’s easy for beta testers to send you detail-rich bug reports and feedback, and even easier for you to reproduce and debug issues.','group': '19-07-2023'},
// //   {'name': 'Ground Floor -Washroom', 'subname':'With Instabug, it’s easy for beta testers to send you detail-rich bug reports and feedback, and even easier for you to reproduce and debug issues.', 'group': '20-07-2023'},
// //   {'name': 'Cabin', 'subname':'With Instabug, it’s easy for beta testers to send you detail-rich bug reports and feedback, and even easier for you to reproduce and debug issues.', 'group': '21-07-2023'},
// // ];
//   double _value = 5.0;
//   var complainttypecontroller = new TextEditingController();
//   var complaintcontroller = new TextEditingController();
//   var clientcontroller = new TextEditingController();
//   var imagecontroller = new TextEditingController();
//   int initialindex = 0;
//   List<DropdownMenuItem<String>> _dropDownItem() {
//     List<String> ddl = ["NONE", "1 YEAR", "2 YEAR"];

//     return ddl
//         .map((value) => DropdownMenuItem(
//               value: value,
//               child: Text(value),
//             ))
//         .toList();
//   }

//   String? role = "1";
//   List<unitcom.DatumElement> mainlisttab = [];
//   ItemScrollController _supervisorcontroller = ItemScrollController();
//   GlobalKey _listKey = GlobalKey();
//   List<String> clientlist = ["Client 1", "Client 2"];
//   List<String> masterarealist = ["Cleaning", "Grooming", "Salary", "Equipment"];
//   List<String> masterblocklist = [
//     "Basement",
//     "First Floor",
//     "Second Floor",
//     "THird Floor"
//   ];

//   List<String> complaintlist = ["Lobby", "Washroom", "Cabin", "Meeting Room"];

//   bool isexpandedmasterarea = false;
//   bool isexpandedmasterblock = false;
//   var masterareacontroller = new TextEditingController();
//   var masterblockcontroller = new TextEditingController();
//   List<String> result = [];
//   File? _imageFile;
//   dynamic _pickImageError;
//   File? image;
//   String? _fileName;
//   List<PlatformFile>? _paths;
//   String? _directoryPath;
//   String? _extension;
//   bool _loadingPath = false;
//   FileType _pickingType = FileType.custom;
//   String areaid = "";
// // late ItemScrollController itemScrollController ;
// // late ScrollOffsetController scrollOffsetController ;
// // late ItemPositionsListener itemPositionsListener;
// // late ScrollOffsetListener scrollOffsetListener ;
// // ScrollController _scrollController= ScrollController();

//   @override
//   void initState() {
//     super.initState();
//     setState(() {
//       if (widget.isnotify) {
//         role = widget.roleid;

//         GlobalLists.siteid = widget.siteid;
//         datecontroller.text = widget.date;
//         _tabController = new TabController(
//             vsync: this,
//             length: 3,
//             initialIndex: widget.status == "Pending"
//                 ? 0
//                 : widget.status == "Dependent"
//                     ? 1
//                     : widget.status == "Resolved"
//                         ? 2
//                         : 0);
//       } else {
//         _tabController = new TabController(vsync: this, length: 3);

//         var datefrom = DateFormat('dd-MM-yyyy').format(DateTime.now());
//         datecontroller.text = datefrom;
//       }
//     });

//     getrole();
//   }

//   getrole() async {
//     role = await SPManager().getroleid();
//     if (role == GlobalLists.unitrole ||
//         role == GlobalLists.headrole ||
//         role == GlobalLists.clientrole ||
//         role == GlobalLists.operationrole ||
//         role == GlobalLists.operationmanagerrole) {
//       setState(() {
//         // mainlisttab.add(MainList("IMAX","1"));
//         //  mainlisttab.add(MainList("Cinipol","1"));
//         //   mainlisttab.add(MainList("Cinimax","0"));
//       });
//     }
//     if (role == GlobalLists.unitrole ||
//         role == GlobalLists.operationrole ||
//         role == GlobalLists.headrole ||
//         role == GlobalLists.clientrole ||
//         role == GlobalLists.operationmanagerrole) {
//       print("unit");
//       getunitcomplaintApi();
//     } else {
//       getcomplaintApi();
//     }
//     if (role == GlobalLists.clientrole) {
//       clientdashboardApi();
//       clientticketmasterApi();
//     }

// //    setState(() {
// //            if(itemScrollController.isAttached){
// //   itemScrollController.scrollTo(
// //       index: 4,
// //       duration: Duration(seconds: 2),
// //       curve: Curves.easeInOutCubic);
// // }
// //       //  _scrollController.jumpTo(4);
// //      });
//   }
// //  void _scrollToIndex(int index) {
// //     // Calculate the scroll offset for the desired index
// //     double offset = index * 300; // Adjust this value according to your item size

// //     // Scroll to the calculated offset with animation
// //     _scrollController.animateTo(
// //       offset,
// //       duration: Duration(seconds: 1), // Adjust the duration as needed
// //       curve: Curves.easeInOut, // Adjust the curve as needed
// //     );
// //   }
//   final GlobalKey<ScaffoldState> _scaffoldKey1 = new GlobalKey<ScaffoldState>();
//   GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
//       GlobalKey<RefreshIndicatorState>();

//   Future<void> refreshData() async {
//     // Simulating an API request or data refresh
//     setState(() {
//       print("APICall");
//       //     var  datefrom =
//       //                                   DateFormat('dd-MM-yyyy').format(DateTime.now());
//       // datecontroller.text=datefrom;
//       getrole();

//       _tabController = new TabController(vsync: this, length: 3);
//     });
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
//         key: _scaffoldKey1,
//         endDrawer: Theme(
//           data: Theme.of(context).copyWith(
//               canvasColor: customcolor.blue, primaryColor: customcolor.blue),
//           child: AppDrawerfilter(role),
//         ),
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
//               setStyleStr: 'Complaints',
//               onPressedBack: () {},
//               onPressedNotify: () {},
//               onPressedSearch: () {},
//               onPressedSort: () {},
//               onPressedmenu: () {
//                 _scaffoldKey1.currentState!.openEndDrawer();
//               }),
//         ),
//         bottomNavigationBar: CustomBottomNavigationBar(index: 2),
//         body: Stack(
//           children: [
//             SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.only(
//                     left: 10, right: 10, top: 20, bottom: 20),
//                 child: Container(
//                     child: (role == GlobalLists.unitrole ||
//                             role == GlobalLists.headrole ||
//                             role == GlobalLists.clientrole ||
//                             role == GlobalLists.operationrole ||
//                             role == GlobalLists.operationmanagerrole)
//                         ? unitcomplaint()
//                         : supervisorcompliant()),
//               ),
//             ),
//             (role == GlobalLists.clientrole)
//                 ? Align(
//                     alignment: Alignment.bottomRight,
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: FloatingActionButton(
//                         backgroundColor: customcolor.blue,
//                         onPressed: () {
//                           // Add your action for the center button here
//                           clientcontroller.text = "";
//                           complaintcontroller.text = "";
//                           complainttypecontroller.text = "";
//                           masterareacontroller.text = "";
//                           masterblockcontroller.text = "";
//                           areaid = "";
//                           blockid = "";
//                           attendanceclientid = "";
//                           attendancesiteid = "";
//                           result = [];
//                           isexpanded = false;
//                           isexpandedcomplaint = false;
//                           isexpandedmasterarea = false;
//                           isexpandedmasterblock = false;
//                           imagecontroller.text = "";
//                           addcomplaint(context);
//                         },
//                         child: Icon(
//                           Icons.add,
//                           color: customcolor.white,
//                         ),
//                       ),
//                     ),
//                   )
//                 : Container()
//           ],
//         ),
//       ),
//     );
//   }

//   Widget unitcomplaint() {
//     return CustomRefreshIndicator(
//       key: refreshIndicatorKey,
//       builder: (
//         BuildContext context,
//         Widget child,
//         IndicatorController controller,
//       ) {
//         return Stack(
//           alignment: Alignment.topCenter,
//           children: <Widget>[
//             if (!controller.isIdle)
//               Positioned(
//                 top: 35.0 * controller.value,
//                 child: SizedBox(
//                   height: 30,
//                   width: 30,
//                   child: CircularProgressIndicator(
//                     value: !controller.isLoading
//                         ? controller.value.clamp(0.0, 1.0)
//                         : null,
//                   ),
//                 ),
//               ),
//             Transform.translate(
//               offset: Offset(0, 100.0 * controller.value),
//               child: child,
//             ),
//           ],
//         );
//       },
//       onRefresh: refreshData,
//       child: ListView(
//         //physics: AlwaysScrollabelScrollPhysics(),
//         shrinkWrap: true,
//         // physics: ScrollPhysics(),
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Container(
//                 child: Text(
//                   "COMPLAINTS",
//                   style: AppFonts.headerStyle(
//                       fontSize: 17.sp,
//                       color: customcolor.title,
//                       fontWeight: FontWeight.normal),
//                 ),
//               ),
//               (role == GlobalLists.unitrole ||
//                       role == GlobalLists.headrole ||
//                       role == GlobalLists.clientrole ||
//                       role == GlobalLists.operationrole ||
//                       role == GlobalLists.supervisorrole ||
//                       role == GlobalLists.operationmanagerrole)
//                   ? new Container(
//                       decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(20)),
//                       width: SizeConfig.blockSizeHorizontal * 32,
//                       height: 30,
//                       // padding: EdgeInsets.only(left: 6,bottom: 5,top:3,right: 5),
//                       child: new Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: <Widget>[
//                           // new Expanded(child: new Text("Bemerkung",)),
//                           new Expanded(
//                             child: new TextField(
//                               textAlignVertical: TextAlignVertical.center,
//                               textAlign: TextAlign.center,
//                               style: AppFonts.headerStyle(
//                                   fontSize: ResponsiveFlutter.of(context)
//                                       .fontSize(1.6),
//                                   color: customcolor.black,
//                                   fontWeight: FontWeight.w300),
//                               readOnly: true,
//                               onTap: () async {
//                                 DateTime? pickedDate = await showDatePicker(
//                                     context: context,
//                                     initialDate:
//                                         selectedDateTime ?? DateTime.now(),
//                                     firstDate: DateTime(1950),
//                                     lastDate: DateTime(2050));

//                                 if (pickedDate != null) {
//                                   var datefrom = DateFormat('dd-MM-yyyy')
//                                       .format(pickedDate);
//                                   datecontroller.text = datefrom;
//                                   print(datecontroller.text);
//                                   setState(() => selectedDateTime = pickedDate);
//                                   if (role == GlobalLists.unitrole ||
//                                       role == GlobalLists.operationrole ||
//                                       role == GlobalLists.headrole ||
//                                       role == GlobalLists.clientrole ||
//                                       role ==
//                                           GlobalLists.operationmanagerrole) {
//                                     print("unit");
//                                     getunitcomplaintApi();
//                                   } else {
//                                     getcomplaintApi();
//                                   }
//                                 }
//                               },
//                               controller: datecontroller,
//                               decoration: InputDecoration(
//                                 border: InputBorder.none,
//                                 contentPadding: EdgeInsets.zero,
//                                 isDense: true,
//                               ),
//                             ),
//                           ),
//                           GestureDetector(
//                             onTap: () async {
//                               DateTime? pickedDate = await showDatePicker(
//                                   context: context,
//                                   initialDate:
//                                       selectedDateTime ?? DateTime.now(),
//                                   firstDate: DateTime(1950),
//                                   lastDate: DateTime(2050));

//                               if (pickedDate != null) {
//                                 var datefrom =
//                                     DateFormat('dd-MM-yyyy').format(pickedDate);
//                                 datecontroller.text = datefrom;
//                                 print(datecontroller.text);
//                                 setState(() => selectedDateTime = pickedDate);
//                                 if (role == GlobalLists.unitrole ||
//                                     role == GlobalLists.operationrole ||
//                                     role == GlobalLists.headrole ||
//                                     role == GlobalLists.clientrole ||
//                                     role == GlobalLists.operationmanagerrole) {
//                                   print("unit");
//                                   getunitcomplaintApi();
//                                 } else {
//                                   getcomplaintApi();
//                                 }
//                               }
//                             },
//                             child: Padding(
//                               padding: EdgeInsets.only(bottom: 1, right: 5),
//                               child: Image.asset(
//                                 'assets/images/calendar.png',
//                                 width: 22,
//                                 height: 22,
//                                 alignment: Alignment.center,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     )
//                   : Container()
//             ],
//           ),
//           mainlisttab.length > 0
//               ? Padding(
//                   padding: const EdgeInsets.only(top: 14, bottom: 14),
//                   child: Container(
//                     height: 25,
//                     child: ListView(
//                       scrollDirection: Axis.horizontal,
//                       shrinkWrap: true,
//                       physics: ScrollPhysics(),
//                       children: _buildChoicemainList(),
//                     ),
//                   )
//                   //  Wrap(
//                   //   direction: Axis.horizontal,
//                   //      spacing: 5.0,
//                   //      runSpacing: 3.0,
//                   //      children: _buildChoicemainList(),
//                   //    ),
//                   )
//               : Container(),
//           mainlisttab.length > 0 ? unitcomplainttabs() : Container()
//         ],
//       ),
//     );
//   }

//   Widget unitcomplainttabs() {
//     return Container(
//       height: SizeConfig.blockSizeVertical * 90,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Center(
//             child: TabBar(
//               isScrollable: true,
//               indicatorSize: TabBarIndicatorSize.tab,
//               indicatorWeight: 2,
//               unselectedLabelColor: customcolor.black,
//               indicatorColor: customcolor.blue,

//               labelColor: customcolor.blue,
//               indicatorPadding: EdgeInsets.only(top: 10, bottom: 10),
//               // indicator: BoxDecoration(
//               //   color: customcolor.darkorange,
//               //   // borderRadius: BorderRadius.all(
//               //   //   Radius.circular(1),
//               //   // ),
//               // ),
//               tabs: [
//                 Tab(
//                   text: "Pending",
//                 ),
//                 Tab(
//                   text: "Dependent",
//                 ),
//                 Tab(
//                   text: "Resolved",
//                 ),
//               ],
//               controller: _tabController,
//             ),
//           ),
//           Expanded(
//             flex: 3,
//             child: TabBarView(
//                 physics: ScrollPhysics(),
//                 controller: _tabController,
//                 children: [
//                   unitcomplaintdetail(mainlisttab[maintag].pendingdata, "1"),
//                   unitcomplaintdetail(mainlisttab[maintag].dependentdata, "2"),
//                   unitcomplaintdetail(mainlisttab[maintag].resolvedata, "3")
//                 ]),
//           ),
//         ],
//       ),
//     );
//   }

//   _buildChoicemainList() {
//     List<Widget> choices = [];
//     mainlisttab.forEachIndexed((item, value) {
//       choices.add(Container(
//         height: 25,
//         child: Padding(
//           padding: const EdgeInsets.only(right: 5),
//           child: ChoiceChip(
//             label: Padding(
//               padding: const EdgeInsets.only(
//                 bottom: 5,
//               ),
//               child: Text(
//                 item.clientName,
//                 style: AppFonts.headerStyle(
//                     fontSize: 12,
//                     color: maintag == value
//                         ? customcolor.white
//                         : item.clientName == "1"
//                             ? customcolor.red
//                             : customcolor.greytext,
//                     fontWeight: FontWeight.bold),
//               ),
//             ),
//             side: BorderSide(
//                 width: 0.5,
//                 color: maintag == value
//                     ? customcolor.white
//                     : item.clientName == "1"
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
//               });
//             },
//           ),
//         ),
//       ));
//     });
//     return choices;
//   }

//   Widget supervisorcompliant() {
//     return CustomRefreshIndicator(
//       key: refreshIndicatorKey,
//       builder: (
//         BuildContext context,
//         Widget child,
//         IndicatorController controller,
//       ) {
//         return Stack(
//           alignment: Alignment.topCenter,
//           children: <Widget>[
//             if (!controller.isIdle)
//               Positioned(
//                 top: 35.0 * controller.value,
//                 child: SizedBox(
//                   height: 30,
//                   width: 30,
//                   child: CircularProgressIndicator(
//                     value: !controller.isLoading
//                         ? controller.value.clamp(0.0, 1.0)
//                         : null,
//                   ),
//                 ),
//               ),
//             Transform.translate(
//               offset: Offset(0, 100.0 * controller.value),
//               child: child,
//             ),
//           ],
//         );
//       },
//       onRefresh: refreshData,
//       child: ListView(
//         shrinkWrap: true,

//         // physics: ScrollPhysics(),

//         children: [
//           //                     Container(child: Text("Complaints", style

//           //                   :

//           //                    AppFonts.headerStyle(fontSize:17.sp,

//           // color: customcolor.black,fontWeight: FontWeight.w600  ),

//           //                   ),

//           //                   ),

//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Container(
//                 child: Text(
//                   "COMPLAINTS",
//                   style: AppFonts.headerStyle(
//                       fontSize: 17.sp,
//                       color: customcolor.title,
//                       fontWeight: FontWeight.normal),
//                 ),
//               ),
//               (role == GlobalLists.unitrole ||
//                       role == GlobalLists.headrole ||
//                       role == GlobalLists.clientrole ||
//                       role == GlobalLists.operationrole ||
//                       role == GlobalLists.supervisorrole ||
//                       role == GlobalLists.operationmanagerrole)
//                   ? new Container(
//                       decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(20)),

//                       width: SizeConfig.blockSizeHorizontal * 32,

//                       height: 30,

//                       // padding: EdgeInsets.only(left: 6,bottom: 5,top:3,right: 5),

//                       child: new Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: <Widget>[
//                           // new Expanded(child: new Text("Bemerkung",)),

//                           new Expanded(
//                             child: new TextField(
//                               textAlignVertical: TextAlignVertical.center,
//                               textAlign: TextAlign.center,
//                               style: AppFonts.headerStyle(
//                                   fontSize: ResponsiveFlutter.of(context)
//                                       .fontSize(1.6),
//                                   color: customcolor.black,
//                                   fontWeight: FontWeight.w300),
//                               readOnly: true,
//                               onTap: () async {
//                                 DateTime? pickedDate = await showDatePicker(
//                                     context: context,
//                                     initialDate:
//                                         selectedDateTime ?? DateTime.now(),
//                                     firstDate: DateTime(1950),
//                                     lastDate: DateTime(2050));

//                                 if (pickedDate != null) {
//                                   var datefrom = DateFormat('dd-MM-yyyy')
//                                       .format(pickedDate);

//                                   datecontroller.text = datefrom;

//                                   print(datecontroller.text);

//                                   setState(() => selectedDateTime = pickedDate);

//                                   if (role == GlobalLists.unitrole ||
//                                       role == GlobalLists.operationrole ||
//                                       role == GlobalLists.headrole ||
//                                       role == GlobalLists.clientrole ||
//                                       role ==
//                                           GlobalLists.operationmanagerrole) {
//                                     print("unit");

//                                     getunitcomplaintApi();
//                                   } else {
//                                     getcomplaintApi();
//                                   }
//                                 }
//                               },
//                               controller: datecontroller,
//                               decoration: InputDecoration(
//                                 border: InputBorder.none,
//                                 contentPadding: EdgeInsets.zero,
//                                 isDense: true,
//                               ),
//                             ),
//                           ),

//                           GestureDetector(
//                             onTap: () async {
//                               DateTime? pickedDate = await showDatePicker(
//                                   context: context,
//                                   initialDate:
//                                       selectedDateTime ?? DateTime.now(),
//                                   firstDate: DateTime(1950),
//                                   lastDate: DateTime(2050));

//                               if (pickedDate != null) {
//                                 var datefrom =
//                                     DateFormat('dd-MM-yyyy').format(pickedDate);

//                                 datecontroller.text = datefrom;

//                                 print(datecontroller.text);

//                                 setState(() => selectedDateTime = pickedDate);

//                                 if (role == GlobalLists.unitrole ||
//                                     role == GlobalLists.operationrole ||
//                                     role == GlobalLists.headrole ||
//                                     role == GlobalLists.clientrole ||
//                                     role == GlobalLists.operationmanagerrole) {
//                                   print("unit");

//                                   getunitcomplaintApi();
//                                 } else {
//                                   getcomplaintApi();
//                                 }
//                               }
//                             },
//                             child: Padding(
//                               padding: EdgeInsets.only(bottom: 1, right: 5),
//                               child: Image.asset(
//                                 'assets/images/calendar.png',
//                                 width: 22,
//                                 height: 22,
//                                 alignment: Alignment.center,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     )
//                   : Container()
//             ],
//           ),

//           SizedBox(
//             height: 10,
//           ),

//           Container(
//             height: SizeConfig.blockSizeVertical * 94,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Center(
//                   child: TabBar(
//                     isScrollable: true,

//                     indicatorSize: TabBarIndicatorSize.label,

//                     indicatorWeight: 2,

//                     unselectedLabelColor: customcolor.black,

//                     indicatorColor: customcolor.blue,

//                     labelColor: customcolor.blue,

//                     indicatorPadding: EdgeInsets.only(top: 10, bottom: 10),

//                     // indicator: BoxDecoration(

//                     //   color: customcolor.darkorange,

//                     //   // borderRadius: BorderRadius.all(

//                     //   //   Radius.circular(1),

//                     //   // ),

//                     // ),

//                     tabs: [
//                       Tab(
//                         text: "Pending",
//                       ),
//                       Tab(
//                         text: "Dependent",
//                       ),
//                       Tab(
//                         text: "Resolved",
//                       ),
//                     ],

//                     controller: _tabController,
//                   ),
//                 ),
//                 Expanded(
//                   flex: 3,
//                   child: TabBarView(
//                       physics: ScrollPhysics(),
//                       controller: _tabController,
//                       children: [
//                         complaintdetail(GlobalLists.pendingcomlist, "1"),
//                         complaintdetail(GlobalLists.dependentcomlist, "2"),
//                         complaintdetail(GlobalLists.resolvedlist, "3")
//                       ]),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _scrollToIndex(int index) {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       // Initialize the scroll controller with the list's state
//       _supervisorcontroller.jumpTo(index: index);
//     });
//     // final RenderBox? renderBox = _listKey.currentContext!.findRenderObject() as RenderBox?;
//     // double offset = 0.0;
//     // if (renderBox != null) {
//     //   for (int i = 0; i < index; i++) {
//     //     offset =offset+ renderBox.size.height; // Accumulate the size of each item
//     //   }
//     //   print("OFFSET");
//     //   //0 0
//     //   //462 1
//     //   //925   2
//     //   //1387.92 3
//     //   //1850.56 4
//     //   print(offset);
//     //   _supervisorcontroller.animateTo(
//     //     offset,
//     //     duration: Duration(milliseconds: 500),
//     //     curve: Curves.easeInOut,
//     //   );
//     //   // _supervisorcontroller.jumpTo(4);
//     // }
//     // _supervisorcontroller.scrollTo(
//     //         index: index,
//     //         duration: Duration(seconds: 1), // Adjust duration as needed
//     //         curve: Curves.easeInOut, // Adjust curve as needed
//     //       );
//   }

//   complaintdetail(List<supercomp.DependentdatumElement> _elements, String tab) {
//     //  print("initialindexvalue");
//     //  print(widget.initalid);
//     // for(int i=0;i<_elements.length;i++)
//     // {
//     //   if(_elements[i].id.toString()==widget.initalid)
//     //   {
//     //    setState(() {
//     print("initialindexmatch");

//     //  itemScrollController.jumpTo(index: 4);
//     //       initialindex=i;
//     //        print(initialindex);
//     //    });
//     //   }
//     // }
//     // ItemScrollController _scrollsuperController = ItemScrollController();
//     // _supervisorcontroller = ItemScrollController();
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 200),
//       child: ScrollablePositionedList.builder(
//         scrollDirection: Axis.vertical,
//         //  key: _listKey,
//         itemScrollController: _supervisorcontroller,
//         //     itemScrollController: itemScrollController,
//         // itemPositionsListener: itemPositionsListener,

//         //  itemScrollController: _scrollsuperController,
//         //  initialScrollIndex: 10,
//         shrinkWrap: true,
//         physics: ScrollPhysics(),
//         itemCount: _elements.length,
//         itemBuilder: (c, element) {
//           return Stack(
//             children: [
//               GestureDetector(
//                 onTap: () {},
//                 child: Card(
//                   // elevation: 8.0,
//                   margin:
//                       new EdgeInsets.symmetric(horizontal: 2.0, vertical: 6.0),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(15)),
//                   ),
//                   child: GestureDetector(
//                     onTap: () {},
//                     child: Column(
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.all(8),
//                           child: Column(
//                             children: [
//                               Padding(
//                                 padding:
//                                     const EdgeInsets.only(left: 5, right: 5),
//                                 child: Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Row(
//                                       children: [
//                                         GestureDetector(
//                                           onTap: () {
//                                             if (_elements[element].image1 !=
//                                                     "" ||
//                                                 _elements[element].image1 !=
//                                                     null) {
//                                               showimage(
//                                                   "Complaints",
//                                                   _elements[element].image1,
//                                                   _elements[element].image2);
//                                             }
//                                           },
//                                           child: Image.network(
//                                             "${_elements[element].image1}",
//                                             width:
//                                                 SizeConfig.blockSizeHorizontal *
//                                                     10,
//                                             height:
//                                                 SizeConfig.safeBlockVertical *
//                                                     5,
//                                             errorBuilder: (BuildContext context,
//                                                 Object exception,
//                                                 StackTrace? stackTrace) {
//                                               return Icon(
//                                                 Icons.error_outline,
//                                                 size: SizeConfig
//                                                         .blockSizeHorizontal *
//                                                     10,
//                                               );
//                                             },
//                                           ),
//                                         ),
//                                         // Image.asset( 'assets/images/image1.png',width: SizeConfig.blockSizeHorizontal*10,),
//                                         SizedBox(
//                                           width:
//                                               SizeConfig.blockSizeHorizontal *
//                                                   2,
//                                         ),
//                                         Container(
//                                           width:
//                                               SizeConfig.blockSizeHorizontal *
//                                                   38,
//                                           child: Column(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.start,
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               Text(
//                                                 "${_elements[element].complainantName}",
//                                                 style: AppFonts.headerStyle(
//                                                     fontSize:
//                                                         ResponsiveFlutter.of(
//                                                                 context)
//                                                             .fontSize(2),
//                                                     color: customcolor.black,
//                                                     fontWeight:
//                                                         FontWeight.w500),
//                                               ),
//                                               SizedBox(
//                                                 height: 5,
//                                               ),
//                                               _elements[element]
//                                                           .complainantName ==
//                                                       "Cleaning"
//                                                   ? Text(
//                                                       "${_elements[element].masterAreaName}-${_elements[element].masterBlockName}",
//                                                       style: AppFonts.headerStyle(
//                                                           fontSize:
//                                                               ResponsiveFlutter
//                                                                       .of(
//                                                                           context)
//                                                                   .fontSize(
//                                                                       1.4),
//                                                           color:
//                                                               customcolor.black,
//                                                           fontWeight:
//                                                               FontWeight.w400),
//                                                     )
//                                                   : Container(),
//                                             ],
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     Flexible(
//                                         child: ElevatedButton(
//                                       style: ElevatedButton.styleFrom(
//                                         shape: RoundedRectangleBorder(
//                                             borderRadius:
//                                                 BorderRadius.circular(15)),
//                                         primary: tab == "3"
//                                             ? customcolor.green
//                                             : tab == "2"
//                                                 ? customcolor.tabblue
//                                                 : _elements[element].status ==
//                                                         "Not Acknowleged"
//                                                     ? customcolor.yellow
//                                                     : (_elements[element]
//                                                                     .status ==
//                                                                 "In-Progress" ||
//                                                             _elements[element]
//                                                                     .status ==
//                                                                 "In Progress")
//                                                         ? customcolor.darkorange
//                                                         : customcolor.red,
//                                         minimumSize: Size(
//                                             SizeConfig.blockSizeHorizontal * 34,
//                                             SizeConfig.blockSizeVertical * 3),
//                                         textStyle: AppFonts.headerStyle(
//                                             fontSize: 15,
//                                             color: customcolor.black,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                       onPressed: () {},
//                                       child: Text(
//                                         tab == "3"
//                                             ? "Resolved"
//                                             : tab == "2"
//                                                 ? "Dependent"
//                                                 : _elements[element]
//                                                     .status, //=="Pending"?"Not Acknowledge":"Escalted",
//                                         style: AppFonts.headerStyle(
//                                             fontSize: 12,
//                                             color: customcolor.white,
//                                             fontWeight: FontWeight.w400),
//                                       ),
//                                     )),
//                                     //
//                                   ],
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: 1,
//                               ),
//                               Container(
//                                 width: SizeConfig.blockSizeHorizontal * 100,
//                                 child: Card(
//                                     color: customcolor.skybluebg,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.all(
//                                         Radius.circular(10),
//                                       ),
//                                     ),
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(10.0),
//                                       child: Column(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             "${_elements[element].comment}",
//                                             style: AppFonts.headerStyle(
//                                                 fontSize: ResponsiveFlutter.of(
//                                                         context)
//                                                     .fontSize(1.4),
//                                                 color: customcolor.black,
//                                                 fontWeight: FontWeight.w400),
//                                             overflow: TextOverflow.ellipsis,
//                                             maxLines: 3,
//                                           ),
//                                           // SizedBox(height: 5,),
//                                         ],
//                                       ),
//                                     )),
//                               ),
//                               SizedBox(
//                                 height: 4,
//                               ),
//                               Padding(
//                                 padding:
//                                     const EdgeInsets.only(left: 5, right: 5),
//                                 child: Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     RichText(
//                                       textAlign: TextAlign.justify,
//                                       text: TextSpan(
//                                         children: [
//                                           TextSpan(
//                                             text: "Logged at-",
//                                             style: AppFonts.headerStyle(
//                                                 fontSize: 12,
//                                                 color: customcolor.black,
//                                                 fontWeight: FontWeight.normal),
//                                           ),
//                                           TextSpan(
//                                             text:
//                                                 "${_elements[element].loggedAt}",
//                                             style: AppFonts.headerStyle(
//                                                 fontSize: 14,
//                                                 color: customcolor.tabblue,
//                                                 fontWeight: FontWeight.w500),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     tab == "2"
//                                         ? Container()
//                                         : _elements[element].turnAroundTime ==
//                                                 ""
//                                             ? Container()
//                                             : Padding(
//                                                 padding: const EdgeInsets.only(
//                                                     left: 5, right: 3),
//                                                 child: Row(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment
//                                                           .spaceBetween,
//                                                   children: [
//                                                     RichText(
//                                                       textAlign:
//                                                           TextAlign.justify,
//                                                       text: TextSpan(
//                                                         children: [
//                                                           TextSpan(
//                                                             text: "TAT - ",
//                                                             style: AppFonts.headerStyle(
//                                                                 fontSize: 12,
//                                                                 color:
//                                                                     customcolor
//                                                                         .black,
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .normal),
//                                                           ),
//                                                           TextSpan(
//                                                             text:
//                                                                 "${_elements[element].turnAroundTime}",
//                                                             style: AppFonts
//                                                                 .headerStyle(
//                                                                     fontSize:
//                                                                         14,
//                                                                     color: tab ==
//                                                                             "3"
//                                                                         ? customcolor
//                                                                             .green
//                                                                         : (_elements[element].status == "In-Progress" ||
//                                                                                 _elements[element].status ==
//                                                                                     "In Progress")
//                                                                             ? customcolor
//                                                                                 .darkorange
//                                                                             : customcolor
//                                                                                 .blue,
//                                                                     fontWeight:
//                                                                         FontWeight
//                                                                             .bold),
//                                                           ),
//                                                           TextSpan(
//                                                             text:
//                                                                 " (${_elements[element].tatDate.toString()})",
//                                                             style: AppFonts
//                                                                 .headerStyle(
//                                                                     fontSize:
//                                                                         12,
//                                                                     color: tab ==
//                                                                             "3"
//                                                                         ? customcolor
//                                                                             .green
//                                                                         : (_elements[element].status == "In-Progress" ||
//                                                                                 _elements[element].status ==
//                                                                                     "In Progress")
//                                                                             ? customcolor
//                                                                                 .darkorange
//                                                                             : customcolor
//                                                                                 .blue,
//                                                                     fontWeight:
//                                                                         FontWeight
//                                                                             .bold),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                   ],
//                                 ),
//                               ),

// //
//                             ],
//                           ),
//                         ),
//                         (role == GlobalLists.headrole ||
//                                 role == GlobalLists.operationrole ||
//                                 role == GlobalLists.supervisorrole ||
//                                 role == GlobalLists.operationmanagerrole)
//                             ? tab == "1"
//                                 ? Column(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Divider(),
//                                       GestureDetector(
//                                         onTap: () {},
//                                         child: Padding(
//                                           padding: const EdgeInsets.only(
//                                               top: 4, bottom: 4),
//                                           child: Center(
//                                             child:
//                                                 _elements[element].status ==
//                                                         "Not Acknowleged"
//                                                     ? IntrinsicHeight(
//                                                         child: Row(
//                                                           mainAxisAlignment:
//                                                               MainAxisAlignment
//                                                                   .center,
//                                                           children: [
//                                                             Container(
//                                                               width: SizeConfig
//                                                                       .blockSizeHorizontal *
//                                                                   40,
//                                                               child:
//                                                                   GestureDetector(
//                                                                 onTap: () {
//                                                                   addtimer(
//                                                                       context,
//                                                                       "add",
//                                                                       _elements[
//                                                                               element]
//                                                                           .id
//                                                                           .toString());
//                                                                 },
//                                                                 child: Center(
//                                                                   child: Text(
//                                                                     'Add Turn Around Time',
//                                                                     style: AppFonts.headerStyle(
//                                                                         fontSize:
//                                                                             ResponsiveFlutter.of(context).fontSize(
//                                                                                 1.8),
//                                                                         color: customcolor
//                                                                             .tabblue,
//                                                                         fontWeight:
//                                                                             FontWeight.normal),
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                             Container(
//                                                               width: SizeConfig
//                                                                       .blockSizeHorizontal *
//                                                                   5,
//                                                               child:
//                                                                   VerticalDivider(
//                                                                 color: customcolor
//                                                                     .greyborder,
//                                                                 thickness: 1,
//                                                               ),
//                                                             ),
//                                                             Container(
//                                                               width: SizeConfig
//                                                                       .blockSizeHorizontal *
//                                                                   40,
//                                                               child:
//                                                                   GestureDetector(
//                                                                 onTap: () {
//                                                                   getoperationdependentApi(
//                                                                       _elements[
//                                                                               element]
//                                                                           .id
//                                                                           .toString());
//                                                                 },
//                                                                 child: Center(
//                                                                   child: Text(
//                                                                     'Mark as Dependent',
//                                                                     style: AppFonts.headerStyle(
//                                                                         fontSize:
//                                                                             ResponsiveFlutter.of(context).fontSize(
//                                                                                 1.8),
//                                                                         color: customcolor
//                                                                             .tabblue,
//                                                                         fontWeight:
//                                                                             FontWeight.normal),
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                       )
//                                                     : (_elements[element]
//                                                                     .status ==
//                                                                 "Escalated" ||
//                                                             _elements[element]
//                                                                     .status ==
//                                                                 "In-Progress" ||
//                                                             _elements[element]
//                                                                     .status ==
//                                                                 "In Progress" ||
//                                                             _elements[element]
//                                                                     .status ==
//                                                                 "Critical")
//                                                         ? Row(
//                                                             mainAxisAlignment:
//                                                                 MainAxisAlignment
//                                                                     .center,
//                                                             children: [
//                                                               GestureDetector(
//                                                                 onTap: () {
//                                                                   addtimer(
//                                                                       context,
//                                                                       "edit",
//                                                                       _elements[
//                                                                               element]
//                                                                           .id
//                                                                           .toString());
//                                                                 },
//                                                                 child: Text(
//                                                                   'Edit Turn Around Time',
//                                                                   style: AppFonts.headerStyle(
//                                                                       fontSize: ResponsiveFlutter.of(
//                                                                               context)
//                                                                           .fontSize(
//                                                                               1.8),
//                                                                       color: customcolor
//                                                                           .tabblue,
//                                                                       fontWeight:
//                                                                           FontWeight
//                                                                               .normal),
//                                                                 ),
//                                                               ),
//                                                             ],
//                                                           )
//                                                         : Container(),
//                                           ),
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         height: 10,
//                                       ),
//                                       Container(
//                                         decoration: BoxDecoration(
//                                           border: Border(
//                                             bottom: BorderSide(
//                                                 color: customcolor.greybg),
//                                           ),
//                                         ),
//                                       ),
//                                       _elements[element].status ==
//                                               "Not Acknowleged"
//                                           ? Container()
//                                           : Container(
//                                               decoration: BoxDecoration(
//                                                 color: customcolor.green,
//                                                 borderRadius: BorderRadius.only(
//                                                   bottomLeft:
//                                                       Radius.circular(15),
//                                                   bottomRight:
//                                                       Radius.circular(15),
//                                                 ),
//                                               ),
//                                               // height: 40,
//                                               child: SwipeActionCell(
//                                                 fullSwipeFactor: 0.1,
//                                                 // firstActionWillCoverAllSpaceOnDeleting: false,
//                                                 // backgroundColor:customcolor.green,
//                                                 //  icon: Icon(Icons.check, color: Colors.green),
//                                                 selectedForegroundColor:
//                                                     customcolor.green,
//                                                 backgroundColor:
//                                                     customcolor.greybg,
//                                                 key: ObjectKey(0),
//                                                 leadingActions: [
//                                                   SwipeAction(
//                                                     icon: Icon(
//                                                       Icons.check,
//                                                       color: customcolor.green,
//                                                     ),
//                                                     performsFirstActionWithFullSwipe:
//                                                         true,
//                                                     onTap: (CompletionHandler
//                                                         handler) async {
//                                                       // Handle swipe action
//                                                       setState(() {
//                                                         print("Resolvef");
//                                                         getoperationalresolvedApi(
//                                                             _elements[element]
//                                                                 .id
//                                                                 .toString());
// //.then((value) {
// //                         if(value!=null)
// //                         {
//                                                         handler(true);
// //        ShowDialogs().confirmationdone(context,"Complaint Resolved \nSuccessfully");

// //     Timer(
// //             Duration(seconds: 1),
// //                 () =>  Navigator.pop(context));
// //                         }
// //                       });
//                                                       });
//                                                     },
//                                                     color: customcolor.green,
//                                                   ),
//                                                 ],
//                                                 child: Container(
//                                                   decoration: BoxDecoration(
//                                                     color: Colors.white,
//                                                     borderRadius:
//                                                         BorderRadius.only(
//                                                       bottomLeft:
//                                                           Radius.circular(15),
//                                                       bottomRight:
//                                                           Radius.circular(15),
//                                                     ),
//                                                   ),
//                                                   height: 40,
//                                                   child: Row(
//                                                     children: [
//                                                       Container(
//                                                         width: SizeConfig
//                                                                 .safeBlockHorizontal *
//                                                             15,
//                                                         decoration:
//                                                             BoxDecoration(
//                                                           color:
//                                                               customcolor.green,
//                                                           borderRadius:
//                                                               BorderRadius.only(
//                                                             bottomLeft:
//                                                                 Radius.circular(
//                                                                     10),
//                                                           ),
//                                                         ),
//                                                         height: 40,
//                                                         child: Icon(
//                                                           Icons.arrow_forward,
//                                                           color:
//                                                               customcolor.white,
//                                                         ),
//                                                       ),
//                                                       SizedBox(
//                                                         width: SizeConfig
//                                                                 .blockSizeHorizontal *
//                                                             5,
//                                                       ),
//                                                       Center(
//                                                         child: Text(
//                                                           'Swipe if complaint is resolved >>',
//                                                           style: AppFonts.headerStyle(
//                                                               fontSize:
//                                                                   ResponsiveFlutter.of(
//                                                                           context)
//                                                                       .fontSize(
//                                                                           2),
//                                                               color: customcolor
//                                                                   .greytext,
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .normal),
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                     ],
//                                   )
//                                 :
//                                 //22feb
//                                 //dependent
//                                 tab == "2"
//                                     ? Column(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           _elements[element].status ==
//                                                   "Not Acknowleged"
//                                               ? Container()
//                                               : Container(
//                                                   decoration: BoxDecoration(
//                                                     color: customcolor.green,
//                                                     borderRadius:
//                                                         BorderRadius.only(
//                                                       bottomLeft:
//                                                           Radius.circular(15),
//                                                       bottomRight:
//                                                           Radius.circular(15),
//                                                     ),
//                                                   ),
//                                                   // height: 40,
//                                                   child: SwipeActionCell(
//                                                     fullSwipeFactor: 0.1,
//                                                     // firstActionWillCoverAllSpaceOnDeleting: false,
//                                                     // backgroundColor:customcolor.green,
//                                                     //  icon: Icon(Icons.check, color: Colors.green),
//                                                     selectedForegroundColor:
//                                                         customcolor.green,
//                                                     backgroundColor:
//                                                         customcolor.greybg,
//                                                     key: ObjectKey(0),
//                                                     leadingActions: [
//                                                       SwipeAction(
//                                                         icon: Icon(
//                                                           Icons.check,
//                                                           color:
//                                                               customcolor.green,
//                                                         ),
//                                                         performsFirstActionWithFullSwipe:
//                                                             true,
//                                                         onTap:
//                                                             (CompletionHandler
//                                                                 handler) async {
//                                                           // Handle swipe action
//                                                           setState(() {
//                                                             print("Resolvef");
//                                                             getoperationalresolvedApi(
//                                                                 _elements[
//                                                                         element]
//                                                                     .id
//                                                                     .toString());
// //.then((value) {
// //                         if(value!=null)
// //                         {
//                                                             handler(true);
// //        ShowDialogs().confirmationdone(context,"Complaint Resolved \nSuccessfully");

// //     Timer(
// //             Duration(seconds: 1),
// //                 () =>  Navigator.pop(context));
// //                         }
// //                       });
//                                                           });
//                                                         },
//                                                         color:
//                                                             customcolor.green,
//                                                       ),
//                                                     ],
//                                                     child: Container(
//                                                       decoration: BoxDecoration(
//                                                         color: Colors.white,
//                                                         borderRadius:
//                                                             BorderRadius.only(
//                                                           bottomLeft:
//                                                               Radius.circular(
//                                                                   15),
//                                                           bottomRight:
//                                                               Radius.circular(
//                                                                   15),
//                                                         ),
//                                                       ),
//                                                       height: 40,
//                                                       child: Row(
//                                                         children: [
//                                                           Container(
//                                                             width: SizeConfig
//                                                                     .safeBlockHorizontal *
//                                                                 15,
//                                                             decoration:
//                                                                 BoxDecoration(
//                                                               color: customcolor
//                                                                   .green,
//                                                               borderRadius:
//                                                                   BorderRadius
//                                                                       .only(
//                                                                 bottomLeft: Radius
//                                                                     .circular(
//                                                                         10),
//                                                               ),
//                                                             ),
//                                                             height: 40,
//                                                             child: Icon(
//                                                               Icons
//                                                                   .arrow_forward,
//                                                               color: customcolor
//                                                                   .white,
//                                                             ),
//                                                           ),
//                                                           SizedBox(
//                                                             width: SizeConfig
//                                                                     .blockSizeHorizontal *
//                                                                 5,
//                                                           ),
//                                                           Center(
//                                                             child: Text(
//                                                               'Swipe if complaint is resolved >>',
//                                                               style: AppFonts.headerStyle(
//                                                                   fontSize: ResponsiveFlutter.of(
//                                                                           context)
//                                                                       .fontSize(
//                                                                           2),
//                                                                   color: customcolor
//                                                                       .greytext,
//                                                                   fontWeight:
//                                                                       FontWeight
//                                                                           .normal),
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                         ],
//                                       )
//                                     : Container()
//                             : SizedBox(
//                                 height: 0,
//                               )
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
// //                   element['isoptionopen']?
// //                                             //optionsDropdown(element['id'].toString(),element)
// //                                             Align(
// //         alignment: Alignment.topRight,
// //         child: Padding(
// //           padding: const EdgeInsets.only(top:0),
// //           child: Container(
// //           //  padding: EdgeInsets.only(top: 5, left: 80, right: 1),
// //             height: 115,
// //             width: 130,
// //             decoration: BoxDecoration(
// //                 color: Colors.transparent, borderRadius: BorderRadius.circular(10)),
// //             child: Card(
// //               elevation: 5,
// //               child: Padding(
// //                   padding: EdgeInsets.only(top: 5, left: 10, right: 5),
// //                   child: ListView.builder(
// //                       itemCount: options.length,
// //                       //  physics: ClampingScrollPhysics(),
// //                       shrinkWrap: true,
// //                       itemBuilder: (BuildContext context, int index) {
// //                         return Column(
// //                           mainAxisAlignment: MainAxisAlignment.start,
// //                           crossAxisAlignment: CrossAxisAlignment.start,
// //                           children: [
// //                             GestureDetector(
// //                               onTap: () {
// //                                 setState(() {
// //                                   element['status'] = options[index];

// //                                   element['isoptionopen'] = false;
// //                                   if(element['status']=="Dependent")
// //                                   {
// //                                     getdependentApi(element['id'].toString());
// //                                   }else if(element['status']=="Resolved")
// //                                   {
// //                                     getresolvedApi(element['id'].toString());
// //                                   }else if(element['status']=="TAT")
// //                                   {

// //                                     _value=(element['TAT_duration']==0.0||element['TAT_duration']==null)?5.0:double.parse(element['TAT_duration']);
// //                                     print("_value");
// //                                     print(_value);
// //                                     confirmationtat(context,element['id'].toString());
// //                                   }

// //                                 });
// //                               },
// //                               child: Container(
// //                                 color: Colors.white,
// //                                 width: SizeConfig.blockSizeHorizontal * 100,
// //                                 child: Text(
// //                                   options[index],
// //                                   textAlign: TextAlign.left,
// //                                   style:

// //                                     AppFonts.headerStyle(fontSize:14,
// // color: customcolor.black,fontWeight: FontWeight.normal  ),

// //                                 ),
// //                               ),
// //                             ),
// //                             SizedBox(
// //                               height: 5,
// //                             ),
// //                             Divider(
// //                               color: customcolor.greytext,
// //                             )
// //                           ],
// //                         );
// //                       })),
// //             ),
// //           ),
// //         ),
// //       )
// //                                             :Container()
//             ],
//           );
//         },
//       ),
//     );
//   }

//   unitcomplaintdetail(
//       List<unitcom.DependentdatumElement> _elements, String tab) {
//     //  print("initialindex");
//     //  print(widget.initalid);
//     // for(int i=0;i<_elements.length;i++)
//     // {
//     //   if(_elements[i].id.toString()==widget.initalid)
//     //   {
//     //    setState(() {
//     //     print(initialindex);
//     //       initialindex=i;
//     //        print(initialindex);
//     //    });
//     //   }
//     // }
//     _scrollController = ItemScrollController();

//     return Padding(
//       padding: const EdgeInsets.only(bottom: 200),
//       child: ScrollablePositionedList.builder(
//         // itemScrollController: itemScrollController,
//         // scrollOffsetController: scrollOffsetController,
//         // itemPositionsListener: itemPositionsListener,
//         // scrollOffsetListener: scrollOffsetListener,
//         itemScrollController: _scrollController,
//         initialScrollIndex: 0,

//         shrinkWrap: true,
//         physics: ScrollPhysics(),
//         itemCount: _elements.length,
//         itemBuilder: (c, element) {
//           return Stack(
//             children: [
//               GestureDetector(
//                 onTap: () {},
//                 child: Card(
//                   // elevation: 8.0,
//                   margin:
//                       new EdgeInsets.symmetric(horizontal: 2.0, vertical: 6.0),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(15)),
//                   ),
//                   child: GestureDetector(
//                     onTap: () {},
//                     child: Padding(
//                       padding: const EdgeInsets.all(0),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Row(
//                                   children: [
//                                     GestureDetector(
//                                       onTap: () {
//                                         if (_elements[element].image1 != "" ||
//                                             _elements[element].image1 != null) {
//                                           showimage(
//                                               "Complaints",
//                                               _elements[element].image1,
//                                               _elements[element].image2);
//                                         }
//                                       },
//                                       child: Image.network(
//                                         "${_elements[element].image1}",
//                                         width:
//                                             SizeConfig.blockSizeHorizontal * 10,
//                                         errorBuilder: (BuildContext context,
//                                             Object exception,
//                                             StackTrace? stackTrace) {
//                                           return Icon(
//                                             Icons.error_outline,
//                                             size:
//                                                 SizeConfig.blockSizeHorizontal *
//                                                     10,
//                                           );
//                                         },
//                                       ),
//                                     ),
//                                     // Image.asset( 'assets/images/image1.png',width: SizeConfig.blockSizeHorizontal*10,),
//                                     SizedBox(
//                                       width: SizeConfig.blockSizeHorizontal * 2,
//                                     ),
//                                     Container(
//                                       width:
//                                           SizeConfig.blockSizeHorizontal * 38,
//                                       child: Column(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             "${_elements[element].complainantName}",
//                                             style: AppFonts.headerStyle(
//                                                 fontSize: ResponsiveFlutter.of(
//                                                         context)
//                                                     .fontSize(2),
//                                                 color: customcolor.black,
//                                                 fontWeight: FontWeight.w500),
//                                           ),
//                                           SizedBox(
//                                             height: 5,
//                                           ),
//                                           _elements[element].complainantName ==
//                                                   "Cleaning"
//                                               ? Container(
//                                                   width: SizeConfig
//                                                           .blockSizeHorizontal *
//                                                       40,
//                                                   child: Text(
//                                                     "${_elements[element].masterAreaName}-${_elements[element].masterBlockName}",
//                                                     style: AppFonts.headerStyle(
//                                                         fontSize:
//                                                             ResponsiveFlutter
//                                                                     .of(context)
//                                                                 .fontSize(1.4),
//                                                         color:
//                                                             customcolor.black,
//                                                         fontWeight:
//                                                             FontWeight.w400),
//                                                   ),
//                                                 )
//                                               : Container(),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 Flexible(
//                                     child: ElevatedButton(
//                                   style: ElevatedButton.styleFrom(
//                                     shape: RoundedRectangleBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(15)),
//                                     primary: tab == "3"
//                                         ? customcolor.green
//                                         : tab == "2"
//                                             ? customcolor.tabblue
//                                             : _elements[element].status ==
//                                                     "Not Acknowleged"
//                                                 ? customcolor.yellow
//                                                 : (_elements[element].status ==
//                                                             "In-Progress" ||
//                                                         _elements[element]
//                                                                 .status ==
//                                                             "In Progress")
//                                                     ? customcolor.darkorange
//                                                     : customcolor.red,
//                                     minimumSize: Size(
//                                         SizeConfig.blockSizeHorizontal * 34,
//                                         SizeConfig.blockSizeVertical * 3),
//                                     textStyle: AppFonts.headerStyle(
//                                         fontSize: 15,
//                                         color: customcolor.black,
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                   onPressed: () {},
//                                   child: Text(
//                                     tab == "3"
//                                         ? "Resolved"
//                                         : tab == "2"
//                                             ? "Dependent"
//                                             : _elements[element]
//                                                 .status, //=="Pending"?"Not Acknowledge":"Escalted",
//                                     style: AppFonts.headerStyle(
//                                         fontSize: 12,
//                                         color: customcolor.white,
//                                         fontWeight: FontWeight.w400),
//                                   ),
//                                 )),
//                                 //
//                               ],
//                             ),
//                           ),
//                           SizedBox(
//                             height: 1,
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(left: 3, right: 3),
//                             child: Stack(
//                               children: [
//                                 Container(
//                                   width: SizeConfig.blockSizeHorizontal * 90,
//                                   child: Card(
//                                       color: customcolor.skybluebg,
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.all(
//                                           Radius.circular(10),
//                                         ),
//                                       ),
//                                       child: Padding(
//                                         padding: const EdgeInsets.all(10.0),
//                                         child: Column(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.center,
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               "${_elements[element].comment}",
//                                               style: AppFonts.headerStyle(
//                                                   fontSize:
//                                                       ResponsiveFlutter.of(
//                                                               context)
//                                                           .fontSize(1.4),
//                                                   color: customcolor.black,
//                                                   fontWeight: FontWeight.w400),
//                                               overflow: TextOverflow.ellipsis,
//                                               maxLines: 3,
//                                             ),
//                                             // SizedBox(height: 5,),
//                                           ],
//                                         ),
//                                       )),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(
//                                 left: 12, right: 8, bottom: 8, top: 8),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 RichText(
//                                   textAlign: TextAlign.justify,
//                                   text: TextSpan(
//                                     children: [
//                                       TextSpan(
//                                         text: "Logged at-",
//                                         style: AppFonts.headerStyle(
//                                             fontSize: 12,
//                                             color: customcolor.black,
//                                             fontWeight: FontWeight.normal),
//                                       ),
//                                       TextSpan(
//                                         text: "${_elements[element].loggedAt}",
//                                         style: AppFonts.headerStyle(
//                                             fontSize: 14,
//                                             color: customcolor.tabblue,
//                                             fontWeight: FontWeight.w500),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 tab == "2"
//                                     ? Container()
//                                     : _elements[element].turnAroundTime == ""
//                                         ? Container()
//                                         : Padding(
//                                             padding: const EdgeInsets.only(
//                                                 left: 12, right: 3),
//                                             child: Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment
//                                                       .spaceBetween,
//                                               children: [
//                                                 RichText(
//                                                   textAlign: TextAlign.justify,
//                                                   text: TextSpan(
//                                                     children: [
//                                                       TextSpan(
//                                                         text: "TAT - ",
//                                                         style: AppFonts
//                                                             .headerStyle(
//                                                                 fontSize: 12,
//                                                                 color:
//                                                                     customcolor
//                                                                         .black,
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .normal),
//                                                       ),
//                                                       TextSpan(
//                                                         text:
//                                                             "${_elements[element].turnAroundTime}",
//                                                         style: AppFonts
//                                                             .headerStyle(
//                                                                 fontSize: 14,
//                                                                 color: tab ==
//                                                                         "3"
//                                                                     ? customcolor
//                                                                         .green
//                                                                     : (_elements[element].status ==
//                                                                                 "In-Progress" ||
//                                                                             _elements[element].status ==
//                                                                                 "In Progress")
//                                                                         ? customcolor
//                                                                             .darkorange
//                                                                         : customcolor
//                                                                             .blue,
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .bold),
//                                                       ),
//                                                       TextSpan(
//                                                         text: _elements[element]
//                                                                     .tatDate ==
//                                                                 null
//                                                             ? ""
//                                                             : " (${_elements[element].tatDate.toString()})",
//                                                         style: AppFonts
//                                                             .headerStyle(
//                                                                 fontSize: 12,
//                                                                 color: tab ==
//                                                                         "3"
//                                                                     ? customcolor
//                                                                         .green
//                                                                     : (_elements[element].status ==
//                                                                                 "In-Progress" ||
//                                                                             _elements[element].status ==
//                                                                                 "In Progress")
//                                                                         ? customcolor
//                                                                             .darkorange
//                                                                         : customcolor
//                                                                             .blue,
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .bold),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                               ],
//                             ),
//                           ),

//                           (role == GlobalLists.headrole ||
//                                   role == GlobalLists.operationrole ||
//                                   role == GlobalLists.operationmanagerrole)
//                               ? tab == "1"
//                                   ? Column(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.start,
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Divider(),
//                                         GestureDetector(
//                                           onTap: () {},
//                                           child: Padding(
//                                             padding: const EdgeInsets.only(
//                                                 top: 4, bottom: 4),
//                                             child: Center(
//                                               child: _elements[element]
//                                                           .status ==
//                                                       "Not Acknowleged"
//                                                   ? IntrinsicHeight(
//                                                       child: Row(
//                                                         mainAxisAlignment:
//                                                             MainAxisAlignment
//                                                                 .center,
//                                                         children: [
//                                                           Container(
//                                                             width: SizeConfig
//                                                                     .blockSizeHorizontal *
//                                                                 40,
//                                                             child:
//                                                                 GestureDetector(
//                                                               onTap: () {
//                                                                 addtimer(
//                                                                     context,
//                                                                     "add",
//                                                                     _elements[
//                                                                             element]
//                                                                         .id
//                                                                         .toString());
//                                                               },
//                                                               child: Center(
//                                                                 child: Text(
//                                                                   'Add Turn Around Time',
//                                                                   style: AppFonts.headerStyle(
//                                                                       fontSize: ResponsiveFlutter.of(
//                                                                               context)
//                                                                           .fontSize(
//                                                                               1.8),
//                                                                       color: customcolor
//                                                                           .tabblue,
//                                                                       fontWeight:
//                                                                           FontWeight
//                                                                               .normal),
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ),
//                                                           Container(
//                                                             width: SizeConfig
//                                                                     .blockSizeHorizontal *
//                                                                 5,
//                                                             child:
//                                                                 VerticalDivider(
//                                                               color: customcolor
//                                                                   .greyborder,
//                                                               thickness: 1,
//                                                             ),
//                                                           ),
//                                                           Container(
//                                                             width: SizeConfig
//                                                                     .blockSizeHorizontal *
//                                                                 40,
//                                                             child:
//                                                                 GestureDetector(
//                                                               onTap: () {
//                                                                 getoperationdependentApi(
//                                                                     _elements[
//                                                                             element]
//                                                                         .id
//                                                                         .toString());
//                                                               },
//                                                               child: Center(
//                                                                 child: Text(
//                                                                   'Mark as Dependent',
//                                                                   style: AppFonts.headerStyle(
//                                                                       fontSize: ResponsiveFlutter.of(
//                                                                               context)
//                                                                           .fontSize(
//                                                                               1.8),
//                                                                       color: customcolor
//                                                                           .tabblue,
//                                                                       fontWeight:
//                                                                           FontWeight
//                                                                               .normal),
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     )
//                                                   : (_elements[element]
//                                                                   .status ==
//                                                               "Escalated" ||
//                                                           _elements[element]
//                                                                   .status ==
//                                                               "In-Progress" ||
//                                                           _elements[element]
//                                                                   .status ==
//                                                               "In Progress" ||
//                                                           _elements[element]
//                                                                   .status ==
//                                                               "Critical")
//                                                       ? Row(
//                                                           mainAxisAlignment:
//                                                               MainAxisAlignment
//                                                                   .center,
//                                                           children: [
//                                                             GestureDetector(
//                                                               onTap: () {
//                                                                 addtimer(
//                                                                     context,
//                                                                     "edit",
//                                                                     _elements[
//                                                                             element]
//                                                                         .id
//                                                                         .toString());
//                                                               },
//                                                               child: Text(
//                                                                 'Edit Turn Around Time',
//                                                                 style: AppFonts.headerStyle(
//                                                                     fontSize: ResponsiveFlutter.of(
//                                                                             context)
//                                                                         .fontSize(
//                                                                             1.8),
//                                                                     color: customcolor
//                                                                         .tabblue,
//                                                                     fontWeight:
//                                                                         FontWeight
//                                                                             .normal),
//                                                               ),
//                                                             ),
//                                                           ],
//                                                         )
//                                                       : Container(),
//                                             ),
//                                           ),
//                                         ),
//                                         SizedBox(
//                                           height: 10,
//                                         ),
//                                         Container(
//                                           decoration: BoxDecoration(
//                                             border: Border(
//                                               bottom: BorderSide(
//                                                   color: customcolor.greybg),
//                                             ),
//                                           ),
//                                         ),
//                                         _elements[element].status ==
//                                                 "Not Acknowleged"
//                                             ? Container()
//                                             : Container(
//                                                 decoration: BoxDecoration(
//                                                   color: customcolor.green,
//                                                   borderRadius:
//                                                       BorderRadius.only(
//                                                     bottomLeft:
//                                                         Radius.circular(15),
//                                                     bottomRight:
//                                                         Radius.circular(15),
//                                                   ),
//                                                 ),
//                                                 // height: 40,
//                                                 child: SwipeActionCell(
//                                                   fullSwipeFactor: 0.1,
//                                                   // firstActionWillCoverAllSpaceOnDeleting: false,
//                                                   // backgroundColor:customcolor.green,
//                                                   //  icon: Icon(Icons.check, color: Colors.green),
//                                                   selectedForegroundColor:
//                                                       customcolor.green,
//                                                   backgroundColor:
//                                                       customcolor.greybg,
//                                                   key: ObjectKey(0),
//                                                   leadingActions: [
//                                                     SwipeAction(
//                                                       icon: Icon(
//                                                         Icons.check,
//                                                         color:
//                                                             customcolor.green,
//                                                       ),
//                                                       performsFirstActionWithFullSwipe:
//                                                           true,
//                                                       onTap: (CompletionHandler
//                                                           handler) async {
//                                                         // Handle swipe action
//                                                         setState(() {
//                                                           print("Resolvef");
//                                                           getoperationalresolvedApi(
//                                                               _elements[element]
//                                                                   .id
//                                                                   .toString());
// //.then((value) {
// //                         if(value!=null)
// //                         {
//                                                           handler(true);
// //        ShowDialogs().confirmationdone(context,"Complaint Resolved \nSuccessfully");

// //     Timer(
// //             Duration(seconds: 1),
// //                 () =>  Navigator.pop(context));
// //                         }
// //                       });
//                                                         });
//                                                       },
//                                                       color: customcolor.green,
//                                                     ),
//                                                   ],
//                                                   child: Container(
//                                                     decoration: BoxDecoration(
//                                                       color: Colors.white,
//                                                       borderRadius:
//                                                           BorderRadius.only(
//                                                         bottomLeft:
//                                                             Radius.circular(15),
//                                                         bottomRight:
//                                                             Radius.circular(15),
//                                                       ),
//                                                     ),
//                                                     height: 40,
//                                                     child: Row(
//                                                       children: [
//                                                         Container(
//                                                           width: SizeConfig
//                                                                   .safeBlockHorizontal *
//                                                               15,
//                                                           decoration:
//                                                               BoxDecoration(
//                                                             color: customcolor
//                                                                 .green,
//                                                             borderRadius:
//                                                                 BorderRadius
//                                                                     .only(
//                                                               bottomLeft: Radius
//                                                                   .circular(10),
//                                                             ),
//                                                           ),
//                                                           height: 40,
//                                                           child: Icon(
//                                                             Icons.arrow_forward,
//                                                             color: customcolor
//                                                                 .white,
//                                                           ),
//                                                         ),
//                                                         SizedBox(
//                                                           width: SizeConfig
//                                                                   .blockSizeHorizontal *
//                                                               5,
//                                                         ),
//                                                         Center(
//                                                           child: Text(
//                                                             'Swipe if complaint is resolved >>',
//                                                             style: AppFonts.headerStyle(
//                                                                 fontSize: ResponsiveFlutter.of(
//                                                                         context)
//                                                                     .fontSize(
//                                                                         2),
//                                                                 color: customcolor
//                                                                     .greytext,
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .normal),
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                       ],
//                                     )
//                                   :
//                                   //change 22feb
//                                   //dependenttab
//                                   tab == "2"
//                                       ? Column(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.start,
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Container(
//                                               decoration: BoxDecoration(
//                                                 border: Border(
//                                                   bottom: BorderSide(
//                                                       color:
//                                                           customcolor.greybg),
//                                                 ),
//                                               ),
//                                             ),
//                                             _elements[element].status ==
//                                                     "Not Acknowleged"
//                                                 ? Container()
//                                                 : Container(
//                                                     decoration: BoxDecoration(
//                                                       color: customcolor.green,
//                                                       borderRadius:
//                                                           BorderRadius.only(
//                                                         bottomLeft:
//                                                             Radius.circular(15),
//                                                         bottomRight:
//                                                             Radius.circular(15),
//                                                       ),
//                                                     ),
//                                                     // height: 40,
//                                                     child: SwipeActionCell(
//                                                       fullSwipeFactor: 0.1,
//                                                       // firstActionWillCoverAllSpaceOnDeleting: false,
//                                                       // backgroundColor:customcolor.green,
//                                                       //  icon: Icon(Icons.check, color: Colors.green),
//                                                       selectedForegroundColor:
//                                                           customcolor.green,
//                                                       backgroundColor:
//                                                           customcolor.greybg,
//                                                       key: ObjectKey(0),
//                                                       leadingActions: [
//                                                         SwipeAction(
//                                                           icon: Icon(
//                                                             Icons.check,
//                                                             color: customcolor
//                                                                 .green,
//                                                           ),
//                                                           performsFirstActionWithFullSwipe:
//                                                               true,
//                                                           onTap:
//                                                               (CompletionHandler
//                                                                   handler) async {
//                                                             // Handle swipe action
//                                                             setState(() {
//                                                               print("Resolvef");
//                                                               getoperationalresolvedApi(
//                                                                   _elements[
//                                                                           element]
//                                                                       .id
//                                                                       .toString());
// //.then((value) {
// //                         if(value!=null)
// //                         {
//                                                               handler(true);
// //        ShowDialogs().confirmationdone(context,"Complaint Resolved \nSuccessfully");

// //     Timer(
// //             Duration(seconds: 1),
// //                 () =>  Navigator.pop(context));
// //                         }
// //                       });
//                                                             });
//                                                           },
//                                                           color:
//                                                               customcolor.green,
//                                                         ),
//                                                       ],
//                                                       child: Container(
//                                                         decoration:
//                                                             BoxDecoration(
//                                                           color: Colors.white,
//                                                           borderRadius:
//                                                               BorderRadius.only(
//                                                             bottomLeft:
//                                                                 Radius.circular(
//                                                                     15),
//                                                             bottomRight:
//                                                                 Radius.circular(
//                                                                     15),
//                                                           ),
//                                                         ),
//                                                         height: 40,
//                                                         child: Row(
//                                                           children: [
//                                                             Container(
//                                                               width: SizeConfig
//                                                                       .safeBlockHorizontal *
//                                                                   15,
//                                                               decoration:
//                                                                   BoxDecoration(
//                                                                 color:
//                                                                     customcolor
//                                                                         .green,
//                                                                 borderRadius:
//                                                                     BorderRadius
//                                                                         .only(
//                                                                   bottomLeft: Radius
//                                                                       .circular(
//                                                                           10),
//                                                                 ),
//                                                               ),
//                                                               height: 40,
//                                                               child: Icon(
//                                                                 Icons
//                                                                     .arrow_forward,
//                                                                 color:
//                                                                     customcolor
//                                                                         .white,
//                                                               ),
//                                                             ),
//                                                             SizedBox(
//                                                               width: SizeConfig
//                                                                       .blockSizeHorizontal *
//                                                                   5,
//                                                             ),
//                                                             Center(
//                                                               child: Text(
//                                                                 'Swipe if complaint is resolved >>',
//                                                                 style: AppFonts.headerStyle(
//                                                                     fontSize: ResponsiveFlutter.of(
//                                                                             context)
//                                                                         .fontSize(
//                                                                             2),
//                                                                     color: customcolor
//                                                                         .greytext,
//                                                                     fontWeight:
//                                                                         FontWeight
//                                                                             .normal),
//                                                               ),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ),
//                                           ],
//                                         )
//                                       : Container()
//                               : SizedBox(
//                                   height: 0,
//                                 )

// //
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
// //                   element['isoptionopen']?
// //                                             //optionsDropdown(element['id'].toString(),element)
// //                                             Align(
// //         alignment: Alignment.topRight,
// //         child: Padding(
// //           padding: const EdgeInsets.only(top:0),
// //           child: Container(
// //           //  padding: EdgeInsets.only(top: 5, left: 80, right: 1),
// //             height: 115,
// //             width: 130,
// //             decoration: BoxDecoration(
// //                 color: Colors.transparent, borderRadius: BorderRadius.circular(10)),
// //             child: Card(
// //               elevation: 5,
// //               child: Padding(
// //                   padding: EdgeInsets.only(top: 5, left: 10, right: 5),
// //                   child: ListView.builder(
// //                       itemCount: options.length,
// //                       //  physics: ClampingScrollPhysics(),
// //                       shrinkWrap: true,
// //                       itemBuilder: (BuildContext context, int index) {
// //                         return Column(
// //                           mainAxisAlignment: MainAxisAlignment.start,
// //                           crossAxisAlignment: CrossAxisAlignment.start,
// //                           children: [
// //                             GestureDetector(
// //                               onTap: () {
// //                                 setState(() {
// //                                   element['status'] = options[index];

// //                                   element['isoptionopen'] = false;
// //                                   if(element['status']=="Dependent")
// //                                   {
// //                                     getdependentApi(element['id'].toString());
// //                                   }else if(element['status']=="Resolved")
// //                                   {
// //                                     getresolvedApi(element['id'].toString());
// //                                   }else if(element['status']=="TAT")
// //                                   {

// //                                     _value=(element['TAT_duration']==0.0||element['TAT_duration']==null)?5.0:double.parse(element['TAT_duration']);
// //                                     print("_value");
// //                                     print(_value);
// //                                     confirmationtat(context,element['id'].toString());
// //                                   }

// //                                 });
// //                               },
// //                               child: Container(
// //                                 color: Colors.white,
// //                                 width: SizeConfig.blockSizeHorizontal * 100,
// //                                 child: Text(
// //                                   options[index],
// //                                   textAlign: TextAlign.left,
// //                                   style:

// //                                     AppFonts.headerStyle(fontSize:14,
// // color: customcolor.black,fontWeight: FontWeight.normal  ),

// //                                 ),
// //                               ),
// //                             ),
// //                             SizedBox(
// //                               height: 5,
// //                             ),
// //                             Divider(
// //                               color: customcolor.greytext,
// //                             )
// //                           ],
// //                         );
// //                       })),
// //             ),
// //           ),
// //         ),
// //       )
// //                                             :Container()
//             ],
//           );
//         },
//       ),
//     );
//   }

//   Widget timebox() {
//     duration = "";
//     return new TimePickerSpinner(
//       is24HourMode: true,
//       normalTextStyle: TextStyle(fontSize: 20, color: Colors.grey),
//       highlightedTextStyle: TextStyle(fontSize: 20, color: Colors.black),
//       spacing: 30,
//       itemHeight: 60,
//       //  minValue: DateTime.now(),
//       isForce2Digits: true,
//       //  isForce12Hours: false,
//       //       minValue: DateTime.now(),
//       //       maxValue: DateTime(DateTime.now().year, 12, 31, 23, 59),
//       onTimeChange: (time) {
//         setState(() {
//           // _dateTime = time;
//           print("time");
//           print(time.hour);
//           print(time.minute);
//           selectedtime = time;
//         });
//       },
//     );
//   }

//   addtimer(BuildContext context, String comingfrom, String id) {
//     showModalBottomSheet(
//         backgroundColor: Colors.white,
//         isDismissible: false,
//         enableDrag: false,

//         // isScrollControlled: false,
//         elevation: 5.0,
//         barrierColor: Colors.black.withOpacity(0.7),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.only(
//               topLeft: const Radius.circular(20.0),
//               topRight: const Radius.circular(20.0)),
//         ),
//         context: context,
//         builder: (builder) {
//           return StatefulBuilder(
//               builder: (BuildContext context, StateSetter setStateDialgoue) {
//             return new Container(
//               height: SizeConfig.blockSizeVertical * 55 +
//                   MediaQuery.of(context).viewInsets.bottom,
//               color: Colors.white,
//               margin: EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 2),
//               padding: EdgeInsets.all(5),
//               child: Stack(
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       SizedBox(
//                         height: 5,
//                       ),
//                       Center(
//                         child: Container(
//                           width: 50,
//                           child: Divider(
//                             thickness: 4,
//                             color: customcolor.greytext,
//                             height: 2,
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 15,
//                       ),
//                       Text(
//                         "Select Turn Around Date",
//                         style: AppFonts.headerStyle(
//                             fontSize:
//                                 ResponsiveFlutter.of(context).fontSize(2.1),
//                             color: customcolor.black,
//                             fontWeight: FontWeight.w300),
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       GestureDetector(
//                         onTap: () async {
//                           DateTime? pickedDate = await showDatePicker(
//                               context: context,
//                               initialDate: selectedDateTime ?? DateTime.now(),
//                               firstDate: DateTime.now(),
//                               lastDate: DateTime(2050));

//                           if (pickedDate != null) {
//                             var datefrom =
//                                 DateFormat('dd-MM-yyyy').format(pickedDate);
//                             datetatcontroller.text = datefrom;
//                             print(datetatcontroller.text);
//                             setState(() => selectedDateTime = pickedDate);
//                           }
//                         },
//                         child: FormTextField(
//                           isEnable: false,
//                           textcontroller: datetatcontroller,
//                           placeholderStr: "Date of TAT",
//                           suffixWidget: Padding(
//                             padding: EdgeInsets.only(right: 20),
//                             child: Image.asset(
//                               "assets/images/calendar.png",
//                               width: 20,
//                               height: 20,
//                             ),
//                           ),
//                           textInputType: TextInputType.text,
//                           onchange: (val) {},
//                         ),
//                       ),
//                       SizedBox(
//                         height: 20,
//                       ),
//                       Text(
//                         "Select Turn Around Time",
//                         style: AppFonts.headerStyle(
//                             fontSize:
//                                 ResponsiveFlutter.of(context).fontSize(2.1),
//                             color: customcolor.black,
//                             fontWeight: FontWeight.w300),
//                       ),
//                       timebox(),
//                       SizedBox(
//                         height: 5,
//                       ),
//                       GestureDetector(
//                         onTap: () {
//                           print("SELEC");
//                           // Navigator.pop(context);
//                           var todaydate =
//                               DateFormat('dd-MM-yyyy').format(DateTime.now());

//                           if (datetatcontroller.text.contains(todaydate)) {
//                             print("SELEC1");
//                             if (selectedtime.isAfter(DateTime.now())) {
//                               setState(() {
//                                 duration =
//                                     "${selectedtime.hour}:${selectedtime.minute}";
//                               });
//                             } else {
//                               ShowDialogs.showToast(
//                                   "Please Select Correct Time");
//                             }
//                           } else {
//                             print("SELEC2");
//                             setState(() {
//                               duration =
//                                   "${selectedtime.hour}:${selectedtime.minute}";
//                             });
//                           }
//                           if (duration != "") {
//                             if (comingfrom == "add") {
//                               if (datetatcontroller.text.isEmpty) {
//                                 ShowDialogs.showToast("Please Select Date");
//                               } else {
//                                 Navigator.pop(context);

//                                 gettatApi(id, duration);
//                               }
//                             } else if (comingfrom == "edit") {
//                               if (datetatcontroller.text.isEmpty) {
//                                 ShowDialogs.showToast("Please Select Date");
//                               } else {
//                                 Navigator.pop(context);
//                                 operationalupdatetatApi(id, duration);
//                               }
//                             }
//                           }
//                         },
//                         child: Align(
//                           alignment: Alignment.bottomRight,
//                           child: Image.asset(
//                             'assets/images/next.png',
//                             width: 50,
//                             height: 50,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             );
//           });
//         });
//   }

//   //clientwisedashboad
//   clientdashboardApi() async {
//     var status1 = await ConnectionDetector.checkInternetConnection();

//     if (status1) {
//       ShowDialogs.showLoadingDialog(context, _keyLoader);

//       var map = new Map<String, dynamic>();

//       var supervisorid = await SPManager().getsupervisorid();
//       print(supervisorid);
//       var clientid = await SPManager().getclientid();

//       map['clientid'] = clientid;

//       print("UNIT");

//       APIManager().apiRequest(context, API.clientsitedependentdashboard,
//           (response) async {
//         clientdash.ClientsiteDashboardResponse resp = response;
//         print("UNIT");
//         print(resp.status.toString());
//         print('called API ${resp}');
//         if (resp.status == 1) {
//           setState(() {
//             GlobalLists.complaintclientlist = resp.data;
//           });
//           Navigator.of(this.context).pop();
//           //  ShowDialogs.showToast(resp.msg);
//         } else {
//           ShowDialogs.showToast(resp.msg);
//           Navigator.of(this.context).pop();
//         }
//       }, (error) {
//         print('ERR msg is $error');
//         Navigator.of(this.context).pop();
//       }, false, "", jsonval: map);
//     } else {
//       ShowDialogs.showToast("Please check internet connection");
//     }
//   }

//   Widget optionsDropdown(String id, dynamic element) {
//     //building index 1, plant 2,stocks 3
//     return Align(
//       alignment: Alignment.topRight,
//       child: Container(
//         //  padding: EdgeInsets.only(top: 5, left: 80, right: 1),
//         height: 115,
//         width: 130,
//         decoration: BoxDecoration(
//             color: Colors.transparent, borderRadius: BorderRadius.circular(10)),
//         child: Card(
//           elevation: 5,
//           child: Padding(
//               padding: EdgeInsets.only(top: 5, left: 10, right: 5),
//               child: ListView.builder(
//                   itemCount: options.length,
//                   //  physics: ClampingScrollPhysics(),
//                   shrinkWrap: true,
//                   itemBuilder: (BuildContext context, int index) {
//                     return Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               statuscontroller.text = options[index];

//                               element['isoptionopen'] = false;
//                               if (statuscontroller.text == "Dependent") {
//                                 getdependentApi(id);
//                               } else if (statuscontroller.text == "Resolved") {
//                                 getresolvedApi(id);
//                               } else if (statuscontroller.text == "TAT") {
//                                 confirmationtat(context, id);
//                               }
//                             });
//                           },
//                           child: Container(
//                             color: Colors.white,
//                             width: SizeConfig.blockSizeHorizontal * 100,
//                             child: Text(
//                               options[index],
//                               textAlign: TextAlign.left,
//                               style: AppFonts.headerStyle(
//                                   fontSize: 14,
//                                   color: customcolor.black,
//                                   fontWeight: FontWeight.normal),
//                             ),
//                           ),
//                         ),
//                         SizedBox(
//                           height: 5,
//                         ),
//                         Divider(
//                           color: customcolor.greytext,
//                         )
//                       ],
//                     );
//                   })),
//         ),
//       ),
//     );
//   }

//   addcomplaint(
//     BuildContext context,
//   ) {
//     showModalBottomSheet(
//         backgroundColor: Colors.white,
//         isScrollControlled: true,
//         elevation: 5.0,
//         barrierColor: Colors.black.withOpacity(0.7),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.only(
//               topLeft: const Radius.circular(20.0),
//               topRight: const Radius.circular(20.0)),
//         ),
//         context: context,
//         builder: (builder) {
//           return StatefulBuilder(
//               builder: (BuildContext context, StateSetter setStateDialgoue) {
//             return new Container(
//               height: complainttypecontroller.text == "Cleaning"
//                   ? masterareacontroller.text == ""
//                       ? SizeConfig.blockSizeVertical * 66 +
//                           MediaQuery.of(context).viewInsets.bottom
//                       : SizeConfig.blockSizeVertical * 75 +
//                           MediaQuery.of(context).viewInsets.bottom
//                   : SizeConfig.blockSizeVertical * 56 +
//                       MediaQuery.of(context).viewInsets.bottom,
//               color: Colors.white,
//               margin: EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 2),
//               padding: EdgeInsets.all(5),
//               child: Stack(
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       SizedBox(
//                         height: 5,
//                       ),
//                       Center(
//                         child: Container(
//                           width: 50,
//                           child: Divider(
//                             thickness: 4,
//                             color: customcolor.greytext,
//                             height: 2,
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 20,
//                       ),
//                       Text(
//                         "Add Complaints",
//                         textAlign: TextAlign.left,
//                         style: AppFonts.headerStyle(
//                             fontSize: 22,
//                             color: customcolor.black,
//                             fontWeight: FontWeight.w400),
//                       ),
//                       SizedBox(
//                         height: 15,
//                       ),
//                       Column(
//                         children: [
//                           GestureDetector(
//                             onTap: () {
//                               setStateDialgoue(() {
//                                 isexpanded = !isexpanded;
//                                 isexpandedmasterblock = false;
//                                 isexpandedcomplaint = false;
//                                 isexpandedmasterarea = false;
//                               });
//                             },
//                             child: FormTextField(
//                               isEnable: false,
//                               textcontroller: clientcontroller,
//                               placeholderStr: "Select Client",
//                               suffixWidget: Padding(
//                                 padding: EdgeInsets.only(right: 20),
//                                 child: Image.asset(
//                                   "assets/images/dropdown.png",
//                                   width: 10,
//                                   height: 10,
//                                 ),
//                               ),
//                               textInputType: TextInputType.text,
//                               onchange: (val) {},
//                             ),
//                           ),
//                         ],
//                       ),
//                       Stack(
//                         children: [
//                           Column(
//                             children: [
//                               SizedBox(
//                                 height: 20,
//                               ),
//                               GestureDetector(
//                                 onTap: () {
//                                   setStateDialgoue(() {
//                                     isexpandedcomplaint = !isexpandedcomplaint;
//                                     isexpandedmasterblock = false;
//                                     isexpanded = false;
//                                     isexpandedmasterarea = false;
//                                   });
//                                 },
//                                 child: FormTextField(
//                                   isEnable: false,
//                                   textcontroller: complainttypecontroller,
//                                   placeholderStr: "Select Complaint Type",
//                                   suffixWidget: Padding(
//                                     padding: EdgeInsets.only(right: 20),
//                                     child: Image.asset(
//                                       "assets/images/dropdown.png",
//                                       width: 10,
//                                       height: 10,
//                                     ),
//                                   ),
//                                   textInputType: TextInputType.text,
//                                   onchange: (val) {},
//                                 ),
//                               ),
//                               Stack(
//                                 children: [
//                                   Column(
//                                     children: [
//                                       complainttypecontroller.text == "Cleaning"
//                                           ? Column(
//                                               children: [
//                                                 SizedBox(
//                                                   height: 20,
//                                                 ),
//                                                 GestureDetector(
//                                                   onTap: () {
//                                                     setStateDialgoue(() {
//                                                       isexpandedmasterarea =
//                                                           !isexpandedmasterarea;
//                                                       isexpandedmasterblock =
//                                                           false;
//                                                       isexpandedcomplaint =
//                                                           false;
//                                                       isexpanded = false;
//                                                     });
//                                                   },
//                                                   child: FormTextField(
//                                                     isEnable: false,
//                                                     textcontroller:
//                                                         masterareacontroller,
//                                                     placeholderStr:
//                                                         "Master Area",
//                                                     textInputType:
//                                                         TextInputType.text,
//                                                     onchange: (val) {},
//                                                     suffixWidget: Padding(
//                                                       padding: EdgeInsets.only(
//                                                           right: 20),
//                                                       child: Image.asset(
//                                                         "assets/images/dropdown.png",
//                                                         width: 10,
//                                                         height: 10,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ],
//                                             )
//                                           : Container(),
//                                       Stack(
//                                         children: [
//                                           Column(
//                                             children: [
//                                               masterareacontroller.text != ""
//                                                   ? Column(
//                                                       children: [
//                                                         SizedBox(
//                                                           height: 20,
//                                                         ),
//                                                         GestureDetector(
//                                                           onTap: () {
//                                                             setStateDialgoue(
//                                                                 () {
//                                                               isexpandedmasterblock =
//                                                                   !isexpandedmasterblock;
//                                                               isexpanded =
//                                                                   false;
//                                                               isexpandedcomplaint =
//                                                                   false;
//                                                               isexpandedmasterarea =
//                                                                   false;
//                                                             });
//                                                           },
//                                                           child: FormTextField(
//                                                             isEnable: false,
//                                                             textcontroller:
//                                                                 masterblockcontroller,
//                                                             placeholderStr:
//                                                                 "Master Block",
//                                                             textInputType:
//                                                                 TextInputType
//                                                                     .text,
//                                                             onchange: (val) {},
//                                                             suffixWidget:
//                                                                 Padding(
//                                                               padding: EdgeInsets
//                                                                   .only(
//                                                                       right:
//                                                                           20),
//                                                               child:
//                                                                   Image.asset(
//                                                                 "assets/images/dropdown.png",
//                                                                 width: 10,
//                                                                 height: 10,
//                                                               ),
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     )
//                                                   : Container(),
//                                               Stack(
//                                                 children: [
//                                                   Column(
//                                                     children: [
//                                                       SizedBox(
//                                                         height: 20,
//                                                       ),
//                                                       FormTextField(
//                                                         textcontroller:
//                                                             complaintcontroller,
//                                                         placeholderStr:
//                                                             "Write Complaint",
//                                                         textInputType:
//                                                             TextInputType.text,
//                                                         onchange: (val) {},
//                                                       ),
//                                                       SizedBox(
//                                                         height: 20,
//                                                       ),
//                                                       GestureDetector(
//                                                         onTap: () {
//                                                           _showSelectionDialog(
//                                                               context, 1);
//                                                         },
//                                                         child: FormTextField(
//                                                           isEnable: false,
//                                                           textcontroller:
//                                                               imagecontroller,
//                                                           placeholderStr:
//                                                               "Add Image", //(Upto 2 images)
//                                                           suffixWidget: Padding(
//                                                             padding:
//                                                                 EdgeInsets.only(
//                                                                     right: 20),
//                                                             child: Image.asset(
//                                                               "assets/images/addimage.png",
//                                                               width: 20,
//                                                               height: 20,
//                                                             ),
//                                                           ),
//                                                           textInputType:
//                                                               TextInputType
//                                                                   .text,
//                                                           onchange: (val) {},
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                   isexpandedmasterblock
//                                                       ? masterblockDropdown(
//                                                           setStateDialgoue)
//                                                       : Container(),
//                                                 ],
//                                               ),
//                                             ],
//                                           ),
//                                           isexpandedmasterarea
//                                               ? masterarerDropdown(
//                                                   setStateDialgoue)
//                                               : Container(),
//                                         ],
//                                       ),
//                                       SizedBox(
//                                         height: 20,
//                                       ),
//                                     ],
//                                   ),
//                                   isexpandedcomplaint
//                                       ? complaintDropdown(setStateDialgoue)
//                                       : Container()
//                                 ],
//                               ),
//                               SizedBox(
//                                 height: 10,
//                               ),
//                             ],
//                           ),
//                           isexpanded
//                               ? clientDropdown(setStateDialgoue)
//                               : Container(),
//                         ],
//                       ),
//                       GestureDetector(
//                         onTap: () {
//                           if (clientcontroller.text.isEmpty) {
//                             ShowDialogs.showToast("Please Select Client");
//                           } else if (complainttypecontroller.text.isEmpty) {
//                             ShowDialogs.showToast(
//                                 "Please Select Complaint Type");
//                           } else if (complaintcontroller.text.isEmpty) {
//                             ShowDialogs.showToast("Please Enter comment");
//                           }
// //                 else if(result.length==0)
// //                 {
// // ShowDialogs.showToast(
// //                                 "Please Upload Image");
// //                 }
//                           else {
//                             if (complainttypecontroller.text == "Cleaning") {
//                               if (masterareacontroller.text.isEmpty) {
//                                 ShowDialogs.showToast(
//                                     "Please Select Master Area");
//                               } else if (masterblockcontroller.text.isEmpty) {
//                                 ShowDialogs.showToast(
//                                     "Please Select Master Block");
//                               } else {
//                                 addcomplaintApi();
//                               }
//                             } else {
//                               addcomplaintApi();
//                             }
//                           }

//                           // Timer(
//                           //         Duration(seconds: 1),
//                           //             () =>  Navigator.pop(context));
//                           //                     ShowDialogs().confirmationdone(context,"Complaint Added \nSuccessfully");

//                           // Timer(
//                           //         Duration(seconds: 1),
//                           //             () =>  Navigator.pop(context));
//                         },
//                         child: Align(
//                           alignment: Alignment.bottomRight,
//                           child: Image.asset(
//                             'assets/images/next.png',
//                             width: 50,
//                             height: 50,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             );
//           });
//         });
//   }

//   _displayPickImageDialog(
//       BuildContext? context, OnPickImageCallback onPick) async {
//     onPick(null, null, null);
//   }

//   Future<void> _showSelectionDialog(BuildContext context, int imageno) {
//     return showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//               title: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "From where do you want to take the photo?",
//                     style: TextStyle(
//                         color: customcolor.blue,
//                         fontSize: 15,
//                         fontFamily: AppFonts.didot,
//                         fontWeight: FontWeight.w600),
//                   ),
//                 ],
//               ),
//               content: SingleChildScrollView(
//                 child: ListBody(
//                   children: <Widget>[
//                     GestureDetector(
//                       child: Text("Gallery"),
//                       onTap: () {
//                         Navigator.pop(context);
//                         if (result.length >= 2) {
//                           ShowDialogs.showToast("You have upload 2 images");
//                         } else {
//                           _openFileExplorer(imageno);
//                         }
//                       },
//                     ),
//                     Padding(padding: EdgeInsets.all(8.0)),
//                     GestureDetector(
//                       child: Text("Camera"),
//                       onTap: () async {
//                         Navigator.pop(context);
//                         if (result.length >= 2) {
//                           ShowDialogs.showToast("You have upload 2 images");
//                         } else {
//                           _onImageButtonPressed(ImageSource.camera, imageno,
//                               context: context);
//                         }
//                       },
//                     ),
//                   ],
//                 ),
//               ));
//         });
//   }

//   void _onImageButtonPressed(ImageSource source, int imageno,
//       {BuildContext? context}) async {
//     try {
//       // final pickedFile = await ImagePicker().get(
//       //   source: source,
//       //   maxWidth: null,
//       //   maxHeight: null,
//       //   imageQuality: null,
//       // );
//       final pickedFile = await ImagePicker.platform.pickImage(
//         source: source,
//         maxWidth: null,
//         maxHeight: null,
//         imageQuality: null,
//       );
//       //  final pickedFile =
//       //     await ImagePicker.pickImage(source: ImageSource.gallery);
//       // ImagePicker _picker=ImagePicker();
//       // XFile image = await ImagePicker.pickImage(source: ImageSource.gallery);
//       await _displayPickImageDialog(context,
//           (double? maxWidth, double? maxHeight, int? quality) async {});
//       setState(() {
//         print(pickedFile);
//         _imageFile = File(pickedFile!.path);
//         print(_imageFile!.path);
//         _fileName = _imageFile!.path.split('/').last;

//         result.add(_imageFile!.path);
//         imagecontroller.text = _fileName!;
//       });
//     } catch (e) {
//       setState(() {
//         _pickImageError = e;
//         print("Ruchita $e");
//       });
//     }
//   }

//   void _openFileExplorer(int imageno) async {
//     setState(() => _loadingPath = true);
//     try {
//       _directoryPath = null;
//       _paths = (await FilePicker.platform.pickFiles(
//         type: _pickingType,
//         allowMultiple: true,

//         allowedExtensions: [
//           'jpg',
//           'jpeg',
//           'png',
//         ],
//         // allowedExtensions: (_extension?.isNotEmpty ?? false)
//         //     ? _extension?.replaceAll(' ', '')?.split(',')
//         //     : null,
//       ))
//           ?.files;
//     } on PlatformException catch (e) {
//       print("Unsupported operation" + e.toString());
//     } catch (ex) {
//       print(ex);
//     }
//     if (!mounted) return;
//     setState(() {
//       _loadingPath = false;
//       _fileName = _paths != null
//           ? _paths!.map((e) => e.name).toString()
//           : 'Select Document';
//       print("File name is${_fileName}");
//       if (_paths!.length > 2) {
//         ShowDialogs.showToast("You can upload upto 2 images");
//       } else {
//         for (int i = 0; i < _paths!.length; i++) {
//           result.add(_paths![i].path!);
//         }

//         imagecontroller.text = _fileName!;
//       }
//     });
//   }

//   addcomplaintApi() async {
//     print("|||||||||||||||||||||||");
//     print("result");
//     print("|||||||||||||||||||||||");
//     var status = await ConnectionDetector.checkInternetConnection();
//     if (status) {
//       ShowDialogs.showLoadingDialog(context, _keyLoader);
//       var currenttime = DateFormat('hh:mm').format(DateTime.now());
//       var request = http.MultipartRequest(
//           "POST", Uri.parse(APIManager.clientaddcomplaint));

//       request.fields['complainant_name'] = complainttypecontroller.text;
//       request.fields['complaint_type'] = complainttype; //siteidconfig; 20feb

//       // request.fields['subject'] =complaintcontroller.text ;
//       request.fields['status'] = "Pending";
//       request.fields['client'] = attendanceclientid;
//       request.fields['site'] = attendancesiteid;
//       request.fields['comment'] = complaintcontroller.text;
//       request.fields['TAT_duration'] = currenttime;
//       request.fields['master_area'] = areaid;
//       request.fields['master_block'] = blockid;
//       print("RUCHI");
//       print(result.length);
//       if (result != []) {
//         for (int i = 0; i < result.length; i++) {
//           print("image${i + 1}");
//           request.files.add(await http.MultipartFile.fromPath(
//               'image${i + 1}', result[i],
//               contentType: new MediaType('application', 'x-tar')));
//         }
//       }
//       var headers = {
//         // "AppKey": APIManager.api_key,
//         // "Authorization": "Bearer " + token!
//       };
//       //  ``   request.headers.addAll(headers);
//       print(request.files);
//       print(request.fields);
//       var response = await request.send();

//       final respStr = await response.stream.bytesToString();
//       var res = json.decode(respStr);
//       print("response.statusCode");
//       print(response.statusCode);
//       print(res);
//       Navigator.of(_keyLoader.currentContext!).pop();
//       if (response.statusCode == 200) {
//         Timer(Duration(seconds: 1), () => Navigator.pop(context));
//         ShowDialogs()
//             .confirmationdone(context, "Complaint Added \nSuccessfully");

//         Timer(
//             Duration(seconds: 1),
//             () => Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (BuildContext context) =>
//                         Complaint(false, "", "", "", "", "", ""))));
//       } else {
//         ShowDialogs.showToast(res['msg']);
//       }
//     } else {
//       SnackBar(
//         content: Text('Please check your internet connection!'),
//       );
//     }
//   }

//   Widget clientDropdown(StateSetter setStateDialgoue) {
//     return Container(
//       height: 140,
//       decoration: BoxDecoration(
//           color: Colors.white, borderRadius: BorderRadius.circular(10)),
//       child: Card(
//         elevation: 5,
//         child: Padding(
//             padding: EdgeInsets.only(left: 10, right: 10, top: 10),
//             child: ListView.builder(
//                 itemCount: GlobalLists.complaintclientlist.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   return Column(
//                     children: [
//                       GestureDetector(
//                         onTap: () {
//                           setStateDialgoue(() {
//                             clientcontroller.text = GlobalLists
//                                 .complaintclientlist[index].clientName;

//                             isexpanded = false;

//                             attendanceclientid = GlobalLists
//                                 .complaintclientlist[index].clientId
//                                 .toString();
//                             attendancesiteid = GlobalLists
//                                 .complaintclientlist[index].siteId
//                                 .toString();

//                             //20feb
//                             siteidconfig = GlobalLists
//                                 .complaintclientlist[index].id
//                                 .toString();
//                           });
//                         },
//                         child: Padding(
//                           padding: const EdgeInsets.only(top: 3, bottom: 2),
//                           child: Container(
//                             color: Colors.white,
//                             width: SizeConfig.blockSizeHorizontal * 100,
//                             child: Text(
//                               GlobalLists.complaintclientlist[index].clientName,
//                               style: AppFonts.headerStyle(
//                                   fontSize: 14,
//                                   color: customcolor.black,
//                                   fontWeight: FontWeight.normal),
//                             ),
//                           ),
//                         ),
//                       ),
//                       Divider(color: customcolor.greybg)
//                     ],
//                   );
//                 })),
//       ),
//     );
//   }

//   //master area
//   Widget masterarerDropdown(StateSetter setStateDialgoue) {
//     return Container(
//       height: 140,
//       decoration: BoxDecoration(
//           color: Colors.white, borderRadius: BorderRadius.circular(10)),
//       child: Card(
//         elevation: 5,
//         child: Padding(
//             padding: EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
//             child: ListView.builder(
//                 itemCount: GlobalLists.masterarealist.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   return Column(
//                     children: [
//                       GestureDetector(
//                         onTap: () {
//                           setStateDialgoue(() {
//                             masterareacontroller.text =
//                                 GlobalLists.masterarealist[index].areaName;
//                             areaid = GlobalLists.masterarealist[index].areaId
//                                 .toString();
//                             isexpandedmasterarea = false;
//                             masterblockcontroller.text = "";
//                             blockid = "";
//                             masterblockareaApi();
//                             // isexpandedcomplaint=true;
//                           });
//                         },
//                         child: Container(
//                           color: Colors.white,
//                           width: SizeConfig.blockSizeHorizontal * 100,
//                           child: Text(
//                             GlobalLists.masterarealist[index].areaName,
//                             style: AppFonts.headerStyle(
//                                 fontSize: 14,
//                                 color: customcolor.black,
//                                 fontWeight: FontWeight.normal),
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 5,
//                       ),
//                       Divider(color: customcolor.greybg)
//                     ],
//                   );
//                 })),
//       ),
//     );
//   }

// //master blcok
//   Widget masterblockDropdown(StateSetter setStateDialgoue) {
//     return Container(
//       height: 140,
//       decoration: BoxDecoration(
//           color: Colors.white, borderRadius: BorderRadius.circular(10)),
//       child: Card(
//         elevation: 5,
//         child: Padding(
//             padding: EdgeInsets.only(left: 10, right: 10, bottom: 20, top: 10),
//             child: ListView.builder(
//                 itemCount: GlobalLists.masterblocklist.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   return Column(
//                     children: [
//                       GestureDetector(
//                         onTap: () {
//                           setStateDialgoue(() {
//                             masterblockcontroller.text =
//                                 GlobalLists.masterblocklist[index].blockName;
//                             blockid = GlobalLists
//                                 .masterblocklist[index].blockObj
//                                 .toString();
//                             isexpandedmasterblock = false;
//                           });
//                         },
//                         child: Container(
//                           color: Colors.white,
//                           width: SizeConfig.blockSizeHorizontal * 100,
//                           child: Text(
//                             GlobalLists.masterblocklist[index].blockName,
//                             style: AppFonts.headerStyle(
//                                 fontSize: 14,
//                                 color: customcolor.black,
//                                 fontWeight: FontWeight.normal),
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 5,
//                       ),
//                       Divider(color: customcolor.greybg)
//                     ],
//                   );
//                 })),
//       ),
//     );
//   }

//   Widget complaintDropdown(StateSetter setStateDialgoue) {
//     return Container(
//       height: 140,
//       decoration: BoxDecoration(
//           color: Colors.white, borderRadius: BorderRadius.circular(10)),
//       child: Card(
//         elevation: 5,
//         child: Padding(
//             padding: EdgeInsets.only(left: 10, right: 10, bottom: 20, top: 10),
//             child: ListView.builder(
//                 itemCount: GlobalLists.clientticketlist.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   return Column(
//                     children: [
//                       GestureDetector(
//                         onTap: () {
//                           setStateDialgoue(() {
//                             complainttypecontroller.text =
//                                 GlobalLists.clientticketlist[index].name;

//                             //20feb
//                             //here there was siteconfig
//                             complainttype = GlobalLists
//                                 .clientticketlist[index].id
//                                 .toString();
//                             isexpandedcomplaint = false;
//                             masterareacontroller.text = "";
//                             masterblockcontroller.text = "";
//                             areaid = "";
//                             blockid = "";

//                             if (complainttypecontroller.text == "Cleaning") {
//                               masterareaApi();
//                             }
//                           });
//                         },
//                         child: Container(
//                           color: Colors.white,
//                           width: SizeConfig.blockSizeHorizontal * 100,
//                           child: Text(
//                             GlobalLists.clientticketlist[index].name,
//                             style: AppFonts.headerStyle(
//                                 fontSize: 14,
//                                 color: customcolor.black,
//                                 fontWeight: FontWeight.normal),
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 5,
//                       ),
//                       Divider(color: customcolor.greybg)
//                     ],
//                   );
//                 })),
//       ),
//     );
//   }

//   attendancelist() {
//     return ListView.builder(
//       scrollDirection: Axis.vertical,
//       shrinkWrap: true,
//       physics: ScrollPhysics(),
//       itemCount: 8,
//       itemBuilder: (context, index) {
//         return Padding(
//           padding: const EdgeInsets.only(right: 2.0, bottom: 6),
//           child: Card(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.all(
//                 Radius.circular(10),
//               ),
//               side: BorderSide(width: 0.5, color: customcolor.greyborder),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Text(
//                     "IMax",
//                     style: AppFonts.headerStyle(
//                         fontSize: 17.sp,
//                         color: customcolor.black,
//                         fontWeight: FontWeight.w500),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(
//                       left: 10, right: 10, top: 2, bottom: 15),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: customcolor.skybluebg,
//                       borderRadius: BorderRadius.all(Radius.circular(10)),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceAround,
//                         children: [
//                           Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Text(
//                                 "Mobile",
//                                 style: AppFonts.headerStyle(
//                                     fontSize: ResponsiveFlutter.of(context)
//                                         .fontSize(1.5),
//                                     color: customcolor.greytext,
//                                     fontWeight: FontWeight.w600),
//                               ),
//                               Text(
//                                 "9029393922",
//                                 style: AppFonts.headerStyle(
//                                     fontSize: ResponsiveFlutter.of(context)
//                                         .fontSize(1.8),
//                                     color: customcolor.black,
//                                     fontWeight: FontWeight.w400),
//                               ),
//                             ],
//                           ),
//                           Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Text(
//                                 "Login Timing",
//                                 style: AppFonts.headerStyle(
//                                     fontSize: ResponsiveFlutter.of(context)
//                                         .fontSize(1.5),
//                                     color: customcolor.greytext,
//                                     fontWeight: FontWeight.w600),
//                               ),
//                               Text(
//                                 "11.00 - 2.00",
//                                 style: AppFonts.headerStyle(
//                                     fontSize: ResponsiveFlutter.of(context)
//                                         .fontSize(1.8),
//                                     color: customcolor.black,
//                                     fontWeight: FontWeight.w400),
//                               ),
//                             ],
//                           ),
//                           Container(
//                             // color: customcolor.appbarcolor,
//                             child: CircularPercentIndicator(
//                               radius: 25.0,
//                               lineWidth: 5.0,
//                               animation: true,
//                               percent: 0.7,
//                               center: new Text(
//                                 "70.0%",
//                                 style: AppFonts.headerStyle(
//                                     fontSize: 10,
//                                     color: customcolor.black,
//                                     fontWeight: FontWeight.bold),
//                               ),
//                               circularStrokeCap: CircularStrokeCap.round,
//                               progressColor: customcolor.blue,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   showimage(String title, String resultvalue, String resultvalue2) {
//     return showDialog(
//       context: context,
//       builder: (_) {
//         return AlertDialog(
//           scrollable: true,
//           title: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text("${title}"),
//               GestureDetector(
//                   onTap: () {
//                     Navigator.pop(context);
//                   },
//                   child: Icon(Icons.close))
//             ],
//           ),
//           content: SingleChildScrollView(
//             //MUST TO ADDED

//             physics: NeverScrollableScrollPhysics(),
//             child: Container(
//               height: resultvalue2 == ""
//                   ? SizeConfig.blockSizeVertical * 30
//                   : SizeConfig.blockSizeVertical * 58,
//               width: double.maxFinite,
//               child: ListView(
//                 shrinkWrap: true,
//                 physics: ScrollPhysics(),
//                 // mainAxisSize: MainAxisSize.min,
//                 children: [
//                   // (resultvalue=="null"||resultvalue==null ||resultvalue=="")?  Container():
//                   Image.network(
//                     resultvalue,
//                     //width: SizeConfig.blockSizeHorizontal*100,
//                     height: SizeConfig.blockSizeVertical * 28,
//                     fit: BoxFit.cover,
//                     //          loadingBuilder: (BuildContext context, Widget child,
//                     //     ImageChunkEvent? loadingProgress) {
//                     //   if (loadingProgress == null) return child;
//                     //   return Center(
//                     //     child: CircularProgressIndicator(
//                     //       value: loadingProgress.expectedTotalBytes != null
//                     //           ? loadingProgress.cumulativeBytesLoaded /
//                     //               loadingProgress.expectedTotalBytes!
//                     //           : null,
//                     //     ),
//                     //   );
//                     // },
//                     errorBuilder: (BuildContext context, Object exception,
//                         StackTrace? stackTrace) {
//                       return Icon(
//                         Icons.error_outline,
//                         size: SizeConfig.blockSizeHorizontal * 10,
//                       );
//                     },
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   resultvalue2 == ""
//                       ? Container()
//                       : Image.network(
//                           resultvalue2,
// //width: SizeConfig.blockSizeHorizontal*25,
//                           height: SizeConfig.blockSizeVertical * 28,
//                           fit: BoxFit.cover,

//                           loadingBuilder: (BuildContext context, Widget child,
//                               ImageChunkEvent? loadingProgress) {
//                             if (loadingProgress == null) return child;
//                             return Center(
//                               child: CircularProgressIndicator(
//                                 value: loadingProgress.expectedTotalBytes !=
//                                         null
//                                     ? loadingProgress.cumulativeBytesLoaded /
//                                         loadingProgress.expectedTotalBytes!
//                                     : null,
//                               ),
//                             );
//                           },
//                           errorBuilder: (BuildContext context, Object exception,
//                               StackTrace? stackTrace) {
//                             return Icon(
//                               Icons.error_outline,
//                               size: SizeConfig.blockSizeHorizontal * 10,
//                             );
//                           },
//                         ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   getcomplaintApi() async {
//     var status1 = await ConnectionDetector.checkInternetConnection();

//     if (status1) {
//       ShowDialogs.showLoadingDialog(context, _keyLoader);

//       setState(() {
//         GlobalLists.resolvedlist = [];
//         GlobalLists.pendingcomlist = [];
//         GlobalLists.dependentcomlist = [];
//       });
//       var map = new Map<String, dynamic>();

//       var supervisorid = await SPManager().getsupervisorid();
//       print(supervisorid);
//       // map['supervisor'] ="25ec3932-1b2a-47c0-b3f1-06b47030e913";//supervisorid ;
//       //  map['Site_id'] ="1";//GlobalLists.siteid ;
//       map['supervisor'] = supervisorid;
//       map['Site_id'] = GlobalLists.siteid;
//       map['today_date'] = datecontroller.text;
//       APIManager().apiRequest(context, API.getcomplaint, (response) async {
//         supercomp.GetComplaintResponse resp = response;
//         print('called API ${resp}');
//         if (resp.status == 1) {
//           Navigator.of(this.context).pop();
//           //   ShowDialogs.showToast(resp.message);
//           setState(() {
//             GlobalLists.resolvedlist = resp.data[0].resolvedata;
//             GlobalLists.pendingcomlist = resp.data[0].pendingdata;
//             GlobalLists.dependentcomlist = resp.data[0].dependentdata;

//             if (widget.isnotify) {
//               if (widget.status == "Pending") {
//                 for (int i = 0; i < GlobalLists.pendingcomlist.length; i++) {
//                   if (GlobalLists.pendingcomlist[i].id.toString() ==
//                       widget.initalid) {
//                     setState(() {
//                       print("supervisor");
//                       print(widget.initalid);
//                       initialindex = i;
//                       print(initialindex);
//                     });
//                   }
//                 }
//               } else if (widget.status == "Dependent") {
//                 for (int i = 0; i < GlobalLists.dependentcomlist.length; i++) {
//                   if (GlobalLists.dependentcomlist[i].id.toString() ==
//                       widget.initalid) {
//                     setState(() {
//                       print("supervisor");
//                       print(widget.initalid);
//                       initialindex = i;
//                       print(initialindex);
//                     });
//                   }
//                 }
//               } else if (widget.status == "Resolved") {
//                 for (int i = 0; i < GlobalLists.resolvedlist.length; i++) {
//                   if (GlobalLists.resolvedlist[i].id.toString() ==
//                       widget.initalid) {
//                     setState(() {
//                       print("supervisor");
//                       print(widget.initalid);
//                       initialindex = i;
//                       print(initialindex);
//                     });
//                   }
//                 }
//               }
//             }

//             _scrollToIndex(10);
// //  resp.pendingdata.forEach((iElement) {

//             //   _pendingelements.add({
//             //        "id": iElement.id,
//             //   "createdAt":iElement.createdAt,
//             //   "updatedAt": iElement.updatedAt,
//             //   "createdBy": iElement.createdBy,
//             //   "updatedBy": iElement.updatedBy,
//             //   "isActive": iElement.isActive,
//             //   "complainant_name": iElement.complainantName,
//             //   "complaint_type": iElement.complaintType,
//             //   "subject": iElement.subject,
//             //   "client": iElement.client,
//             //   "site": iElement.site,
//             //   "status": iElement.status,
//             //   "date": iElement.date,
//             //   "isoptionopen":false,
//             //   "TAT_duration":iElement.tatDuration
//             //     });

//             // });
//             //      resp.dependentdata.forEach((iElement) {

//             //   _dependentelements.add({
//             //        "id": iElement.id,
//             //   "createdAt":iElement.createdAt,
//             //   "updatedAt": iElement.updatedAt,
//             //   "createdBy": iElement.createdBy,
//             //   "updatedBy": iElement.updatedBy,
//             //   "isActive": iElement.isActive,
//             //   "complainant_name": iElement.complainantName,
//             //   "complaint_type": iElement.complaintType,
//             //   "subject": iElement.subject,
//             //   "client": iElement.client,
//             //   "site": iElement.site,
//             //   "status": iElement.status,
//             //   "date": iElement.date,
//             //    "isoptionopen":false,
//             //    "TAT_duration":iElement.tatDuration
//             //     });

//             // });

//             //  resp.resolvedata.forEach((iElement) {

//             //   _resolvedelements.add({
//             //        "id": iElement.id,
//             //   "createdAt":iElement.createdAt,
//             //   "updatedAt": iElement.updatedAt,
//             //   "createdBy": iElement.createdBy,
//             //   "updatedBy": iElement.updatedBy,
//             //   "isActive": iElement.isActive,
//             //   "complainant_name": iElement.complainantName,
//             //   "complaint_type": iElement.complaintType,
//             //   "subject": iElement.subject,
//             //   "client": iElement.client,
//             //   "site": iElement.site,
//             //   "status": iElement.status,
//             //   "date": iElement.date,
//             //    "isoptionopen":false,
//             //    "TAT_duration":iElement.tatDuration
//             //     });

//             // });
//           });
//         } else {
//           ShowDialogs.showToast(resp.message);
//           Navigator.of(this.context).pop();
//         }
//       }, (error) {
//         print('ERR msg is $error');
//         Navigator.of(this.context).pop();
//       }, false, "", jsonval: map);
//     } else {
//       ShowDialogs.showToast("Please check internet connection");
//     }
//   }

//   getunitcomplaintApi() async {
//     var status1 = await ConnectionDetector.checkInternetConnection();

//     if (status1) {
//       setState(() {
//         mainlisttab = [];
//       });
//       ShowDialogs.showLoadingDialog(context, _keyLoader);

//       var map = new Map<String, dynamic>();
//       var clientid = await SPManager().getclientid();
//       print(clientid);
//       var supervisorid = await SPManager().getsupervisorid();
//       print(supervisorid);
//       if (role == GlobalLists.clientrole) {
//         map['clientid'] = clientid;
//         map['date'] = datecontroller.text;
//         map['supervisor'] = supervisorid;
//       } else {
//         map['supervisor'] =
//             supervisorid; //"96305101-e856-40eb-8c9a-cba1a0c0f4cc";//supervisorid ;
//         map['date'] = datecontroller.text;
//       }

//       APIManager().apiRequest(context, API.unitcomplaint, (response) async {
//         unitcom.UnitComplaintResponse resp = response;
//         print('called API ${resp}');
//         if (resp.status == 1) {
//           Navigator.of(this.context).pop();
//           //   ShowDialogs.showToast(resp.message);
//           setState(() {
//             for (int i = 0; i < resp.data.length; i++) {
//               mainlisttab.add(resp.data[i]);
//             }
//           });
//         } else {
//           ShowDialogs.showToast(resp.message);
//           Navigator.of(this.context).pop();
//         }
//       }, (error) {
//         print('ERR msg is $error');
//         Navigator.of(this.context).pop();
//       }, false, "", jsonval: map);
//     } else {
//       ShowDialogs.showToast("Please check internet connection");
//     }
//   }

//   getdependentApi(String id) async {
//     var status1 = await ConnectionDetector.checkInternetConnection();

//     if (status1) {
//       ShowDialogs.showLoadingDialog(context, _keyLoader);

//       var map = new Map<String, dynamic>();

//       var supervisorid = await SPManager().getsupervisorid();
//       print(supervisorid);
//       map['id'] = id;
//       map['supervisor'] = supervisorid;

//       APIManager().apiRequest(context, API.getdependantcomplaint,
//           (response) async {
//         GetDependentResponse resp = response;
//         print('called API ${resp}');
//         if (resp.status == 1) {
//           Navigator.of(this.context).pop();
//           ShowDialogs.showToast(resp.msg);
//           setState(() {
//             getcomplaintApi();
//           });
//         } else {
//           ShowDialogs.showToast(resp.msg);
//           Navigator.of(this.context).pop();
//         }
//       }, (error) {
//         print('ERR msg is $error');
//       }, false, "", jsonval: map);
//     } else {
//       ShowDialogs.showToast("Please check internet connection");
//     }
//   }

// //operation
//   getoperationdependentApi(String id) async {
//     var status1 = await ConnectionDetector.checkInternetConnection();

//     if (status1) {
//       // ShowDialogs.showLoadingDialog(context, _keyLoader);

//       var map = new Map<String, dynamic>();

//       var supervisorid = await SPManager().getsupervisorid();
//       print(supervisorid);
//       map['id'] = id;
//       map['supervisor'] = supervisorid;

//       APIManager().apiRequest(context, API.getdependantcomplaint,
//           (response) async {
//         GetDependentResponse resp = response;
//         print('called API ${resp}');
//         if (resp.status == 1) {
//           // Navigator.of(this.context).pop();
//           // ShowDialogs.showToast(resp.msg);
//           setState(() {
//             ShowDialogs().confirmationdone(
//                 context, "Complaint mark as dependent \nSuccessfully");

//             Timer(Duration(seconds: 1), () => Navigator.pop(context));

//             if (role == GlobalLists.unitrole ||
//                 role == GlobalLists.operationrole ||
//                 role == GlobalLists.headrole ||
//                 role == GlobalLists.clientrole ||
//                 role == GlobalLists.operationmanagerrole) {
//               print("unit");
//               getunitcomplaintApi();
//             } else {
//               getcomplaintApi();
//             }
//           });
//         } else {
//           ShowDialogs.showToast(resp.msg);
//           // Navigator.of(this.context).pop();
//         }
//       }, (error) {
//         print('ERR msg is $error');
//       }, false, "", jsonval: map);
//     } else {
//       ShowDialogs.showToast("Please check internet connection");
//     }
//   }

//   getresolvedApi(String id) async {
//     var status1 = await ConnectionDetector.checkInternetConnection();

//     if (status1) {
//       ShowDialogs.showLoadingDialog(context, _keyLoader);

//       var map = new Map<String, dynamic>();

//       var supervisorid = await SPManager().getsupervisorid();
//       print(supervisorid);
//       map['id'] = id;
//       map['supervisor'] = supervisorid;

//       APIManager().apiRequest(context, API.getresolvedcomplaint,
//           (response) async {
//         GetDependentResponse resp = response;
//         print('called API ${resp}');
//         if (resp.status == 1) {
//           Navigator.of(this.context).pop();
//           ShowDialogs.showToast(resp.msg);
//           setState(() {
//             getcomplaintApi();
//           });
//         } else {
//           ShowDialogs.showToast(resp.msg);
//           Navigator.of(this.context).pop();
//         }
//       }, (error) {
//         print('ERR msg is $error');
//       }, false, "", jsonval: map);
//     } else {
//       ShowDialogs.showToast("Please check internet connection");
//     }
//   }

//   Future getoperationalresolvedApi(String id) async {
//     var status1 = await ConnectionDetector.checkInternetConnection();

//     if (status1) {
//       // ShowDialogs.showLoadingDialog(context, _keyLoader);

//       var map = new Map<String, dynamic>();

//       var supervisorid = await SPManager().getsupervisorid();
//       print(supervisorid);
//       map['id'] = id;
//       map['supervisor'] = supervisorid;

//       APIManager().apiRequest(context, API.getresolvedcomplaint,
//           (response) async {
//         GetDependentResponse resp = response;
//         print('called API ${resp}');
//         if (resp.status == 1) {
//           // Navigator.of(this.context).pop();
//           // ShowDialogs.showToast(resp.msg);
//           ShowDialogs().confirmationdone(
//               context, "Complaint mark as Resolved \nSuccessfully");

//           Timer(Duration(seconds: 1), () => Navigator.pop(context));
//           setState(() {
//             if (role == GlobalLists.unitrole ||
//                 role == GlobalLists.operationrole ||
//                 role == GlobalLists.headrole ||
//                 role == GlobalLists.clientrole ||
//                 role == GlobalLists.operationmanagerrole) {
//               print("unit");
//               getunitcomplaintApi();
//             } else {
//               getcomplaintApi();
//             }
//           });
//         } else {
//           ShowDialogs.showToast(resp.msg);
//           // Navigator.of(this.context).pop();
//         }
//       }, (error) {
//         print('ERR msg is $error');
//       }, false, "", jsonval: map);
//     } else {
//       ShowDialogs.showToast("Please check internet connection");
//     }
//   }

//   gettatApi(String id, String duration) async {
//     var status1 = await ConnectionDetector.checkInternetConnection();

//     if (status1) {
//       ShowDialogs.showLoadingDialog(context, _keyLoader);

//       var map = new Map<String, dynamic>();

//       var supervisorid = await SPManager().getsupervisorid();
//       print(supervisorid);
//       map['id'] = id;
//       map['supervisor'] = supervisorid;
//       map['TAT_duration'] = duration;
//       map['TAT_time'] = duration;
//       map['TAT_date'] = datetatcontroller.text;
//       APIManager().apiRequest(context, API.gettatcomplaint, (response) async {
//         GetDependentResponse resp = response;
//         print('called API ${resp}');
//         if (resp.status == 1) {
//           Navigator.of(this.context).pop();
//           //ShowDialogs.showToast(resp.msg);
//           setState(() {
//             ShowDialogs()
//                 .confirmationtatdone(context, "TAT Selected", duration);

//             Timer(Duration(seconds: 1), () => Navigator.pop(context));

//             if (role == GlobalLists.unitrole ||
//                 role == GlobalLists.operationrole ||
//                 role == GlobalLists.headrole ||
//                 role == GlobalLists.clientrole ||
//                 role == GlobalLists.operationmanagerrole) {
//               print("unit");
//               getunitcomplaintApi();
//             } else {
//               getcomplaintApi();
//             }
//           });
//         } else {
//           ShowDialogs.showToast(resp.msg);
//           Navigator.of(this.context).pop();
//         }
//       }, (error) {
//         print('ERR msg is $error');
//       }, false, "", jsonval: map);
//     } else {
//       ShowDialogs.showToast("Please check internet connection");
//     }
//   }
//   //opertionaltat

//   operationalupdatetatApi(String id, String duration) async {
//     var status1 = await ConnectionDetector.checkInternetConnection();

//     if (status1) {
//       ShowDialogs.showLoadingDialog(context, _keyLoader);

//       var map = new Map<String, dynamic>();

//       var supervisorid = await SPManager().getsupervisorid();
//       print(supervisorid);
//       map['id'] = id;

//       map['TAT_duration'] = duration;
//       map['TAT_date'] = datetatcontroller.text;
//       map['TAT_time'] = duration;

//       APIManager().apiRequest(context, API.operationalupdatetat,
//           (response) async {
//         UpdateTatResponse resp = response;
//         print('called API ${resp}');
//         if (resp.status == 1) {
//           Navigator.of(this.context).pop();
//           //ShowDialogs.showToast(resp.msg);
//           setState(() {
//             ShowDialogs()
//                 .confirmationdone(context, "Complaint Updated \nSuccessfully");

//             Timer(Duration(seconds: 1), () => Navigator.pop(context));

//             if (role == GlobalLists.unitrole ||
//                 role == GlobalLists.operationrole ||
//                 role == GlobalLists.headrole ||
//                 role == GlobalLists.clientrole ||
//                 role == GlobalLists.operationmanagerrole) {
//               print("unit");
//               getunitcomplaintApi();
//             } else {
//               getcomplaintApi();
//             }
//           });
//         } else {
//           ShowDialogs.showToast(resp.message);
//           Navigator.of(this.context).pop();
//         }
//       }, (error) {
//         print('ERR msg is $error');
//       }, false, "", jsonval: map);
//     } else {
//       ShowDialogs.showToast("Please check internet connection");
//     }
//   }

//   clientticketmasterApi() async {
//     var status1 = await ConnectionDetector.checkInternetConnection();
//     setState(() {
//       GlobalLists.clientticketlist = [];
//     });
//     if (status1) {
//       // ShowDialogs.showLoadingDialog(context, _keyLoader);

//       var map = new Map<String, dynamic>();

//       APIManager().apiRequest(context, API.tickettypelist, (response) async {
//         print("Ruchita");

//         TicketllistResponse resp = response;
//         print('called API ${resp}');
//         if (resp.status == 1) {
//           setState(() {
//             GlobalLists.clientticketlist = resp.data;
//           });
//         } else {
//           ShowDialogs.showToast(resp.message);
//           // Navigator.of(this.context).pop();
//         }
//       }, (error) {
//         print('ERR msg is $error');
//         //  Navigator.of(this.context).pop();
//       }, false, "", jsonval: map);
//     } else {
//       ShowDialogs.showToast("Please check internet connection");
//     }
//   }

//   masterareaApi() async {
//     var status1 = await ConnectionDetector.checkInternetConnection();
//     setState(() {
//       GlobalLists.masterarealist = [];
//     });
//     if (status1) {
//       // ShowDialogs.showLoadingDialog(context, _keyLoader);

//       var map = new Map<String, dynamic>();
//       map['site_config_id'] = siteidconfig;

//       APIManager().apiRequest(context, API.masterclientarea, (response) async {
//         print("Ruchita");

//         MasterareaResponse resp = response;
//         print('called API ${resp}');
//         if (resp.status == 1) {
//           setState(() {
//             GlobalLists.masterarealist = resp.data;
//           });
//         } else {
//           ShowDialogs.showToast(resp.msg);
//           // Navigator.of(this.context).pop();
//         }
//       }, (error) {
//         print('ERR msg is $error');
//         //  Navigator.of(this.context).pop();
//       }, false, "", jsonval: map);
//     } else {
//       ShowDialogs.showToast("Please check internet connection");
//     }
//   }

//   masterblockareaApi() async {
//     var status1 = await ConnectionDetector.checkInternetConnection();
//     setState(() {
//       GlobalLists.masterblocklist = [];
//     });
//     if (status1) {
//       // ShowDialogs.showLoadingDialog(context, _keyLoader);

//       var map = new Map<String, dynamic>();
//       map['site_config_id'] = siteidconfig;
//       map['Master_Area'] = areaid;

//       APIManager().apiRequest(context, API.masterclientblockarea,
//           (response) async {
//         print("Ruchita");

//         MasterBlockResponse resp = response;
//         print('called API ${resp}');
//         if (resp.status == 1) {
//           setState(() {
//             GlobalLists.masterblocklist = resp.data;
//           });
//         } else {
//           ShowDialogs.showToast(resp.msg);
//           // Navigator.of(this.context).pop();
//         }
//       }, (error) {
//         print('ERR msg is $error');
//         //  Navigator.of(this.context).pop();
//       }, false, "", jsonval: map);
//     } else {
//       ShowDialogs.showToast("Please check internet connection");
//     }
//   }

//   confirmationtat(BuildContext context, String id) {
//     showModalBottomSheet(
//         backgroundColor: Colors.white,
//         isScrollControlled: true,
//         elevation: 5.0,
//         barrierColor: Colors.black.withOpacity(0.7),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.only(
//               topLeft: const Radius.circular(20.0),
//               topRight: const Radius.circular(20.0)),
//         ),
//         context: context,
//         builder: (builder) {
//           return StatefulBuilder(
//               builder: (BuildContext context, StateSetter setStateDialgoue) {
//             return new Container(
//               height: SizeConfig.blockSizeVertical * 29 +
//                   MediaQuery.of(context).viewInsets.bottom,
//               color: Colors.white,
//               margin: EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 2),
//               padding: EdgeInsets.all(5),
//               child: Stack(
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       Text(
//                         "Select TAT",
//                         style: AppFonts.headerStyle(
//                             fontSize:
//                                 17.sp,
//                             color: customcolor.black,
//                             fontWeight: FontWeight.w600),
//                       ),
//                       SizedBox(
//                         height: 30,
//                       ),
//                       new Container(
//                         //padding: EdgeInsets.only(left: ((MediaQuery.of(context).size.width-20)/5)/2,right: ((MediaQuery.of(context).size.width-20)/5)/2),
//                         width: MediaQuery.of(context).size.width,
// //               child:Slider(
// //                 activeColor: customcolor.darkorange,
// //                 inactiveColor: customcolor.greybg,
// //    value: selectedIndex.toDouble(),
// //    min: 0,
// //    max: values.length - 1,
// //    divisions: values.length - 1,
// //    label: values[selectedIndex].toString(),
// //    onChanged: (double value) {
// //    setStateDialgoue(() {
// //         selectedIndex = value.toInt();
// //       });
// //    },
// // ),
//                         child: SfSliderTheme(
//                           data: SfSliderThemeData(
//                               trackCornerRadius: 7.5,
//                               activeTrackHeight: 10,
//                               inactiveTrackHeight: 10,
//                               overlayRadius: 0.0),
//                           child: SfSlider(
//                             labelFormatterCallback:
//                                 (dynamic actualValue, String formattedText) {
//                               switch (actualValue) {
//                                 // print(actualValue);
//                                 //            case 5:
//                                 // return ' 5\nmin';
//                                 //           case 25:
//                                 // return ' 10\nmin';
//                                 //           case 45:
//                                 // return ' 15\nmin';
//                                 //           case 65:
//                                 // return ' 20\nmin';
//                                 //           case 85:
//                                 //return 'actualValue';
//                               }
//                               return
//                                   // values[selectedIndex].toString();
//                                   '${actualValue.toString()} \nmin';
//                             },
//                             //   divisions: values.length - 1,
//                             //label: values[selectedIndex].toString(),
//                             activeColor: customcolor.darkorange,
//                             inactiveColor: customcolor.greybg,
//                             labelPlacement: LabelPlacement.onTicks,
//                             stepSize: 10,
//                             thumbIcon: Container(
//                               decoration: BoxDecoration(
//                                 color: customcolor.white,
//                                 border: Border.all(
//                                   color: customcolor.darkorange,
//                                   width: 0.4,
//                                 ),
//                                 borderRadius:
//                                     BorderRadius.all(Radius.circular(10)),
//                               ),
//                               child: Padding(
//                                 padding: const EdgeInsets.all(4.0),
//                                 child: Image.asset(
//                                   'assets/images/broom.png',
//                                   width: 30,
//                                   height: 30,
//                                 ),
//                               ),
//                             ),
//                             //                   value: selectedIndex.toDouble(),
//                             //  min: 0,
//                             //  max: values.length - 1,

//                             //  onChanged: (dynamic value) {
//                             //  setStateDialgoue(() {
//                             //       selectedIndex = value.toInt();
//                             //     });
//                             //  },
//                             min: 5.0,
//                             max: 65.0,
//                             value: _value,
//                             interval: 10,
//                             showTicks: true,
//                             showLabels: true,
//                             enableTooltip: true,

//                             minorTicksPerInterval: 0,
//                             onChanged: (dynamic value) {
//                               setStateDialgoue(() {
//                                 _value = value;
//                               });
//                             },
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 40,
//                       ),
//                       GestureDetector(
//                         onTap: () {
//                           Navigator.pop(context);
//                           gettatApi(id, _value.toString());
//                         },
//                         child: Align(
//                           alignment: Alignment.bottomRight,
//                           child: Image.asset(
//                             'assets/images/next.png',
//                             width: 50,
//                             height: 50,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             );
//           });
//         });
//   }
// }

// // class SwipeableContainer extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Swipeable Container Example'),
// //       ),
// //       body: ListView.builder(
// //         itemCount: 1,
// //         itemBuilder: (context, index) {
// //           return SwipeActionCell(
// //             key: ObjectKey(index),
// //             trailingActions: [
// //               SwipeAction(
// //                 onTap: (CompletionHandler handler) async {
// //                   // Handle swipe action
// //                   handler(true);
// //                 },
// //                 color: Colors.green,
// //                icon: Icon(Icons.check, color: Colors.green),
// //               ),
// //             ],
// //             child: Container(
// //               height: 80,
// //               color: Colors.blue,
// //               child: Center(
// //                 child: Text('Item $index', style: AppFonts.headerStyle(fontSize:17.sp,
// // color: customcolor.white,fontWeight: FontWeight.normal  ),),
// //               ),
// //             ),
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }
