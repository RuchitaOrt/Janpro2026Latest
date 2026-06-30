import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geocoding/geocoding.dart';

import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:janpro/Screens/Homepage.dart';
import 'package:janpro/Screens/Rating.dart';
import 'package:janpro/Utitlity/APIManager.dart';
import 'package:janpro/Utitlity/AppDrawer.dart';
import 'package:janpro/Utitlity/FormTextField.dart';
import 'package:janpro/Utitlity/FormTextFieldButton.dart';
import 'package:janpro/Utitlity/GlobalLists.dart';
import 'package:janpro/Utitlity/ResponsiveFlutter.dart';
import 'package:janpro/Utitlity/SPManager.dart';
import 'package:janpro/Utitlity/ShowDialog.dart';
import 'package:janpro/Utitlity/appbar.dart';
import 'package:janpro/Utitlity/button.dart';
import 'package:janpro/Utitlity/customBottomNavigationBar.dart';
import 'package:janpro/Utitlity/custom_color.dart';
import 'package:janpro/Utitlity/internetConnection.dart';
import 'package:janpro/Utitlity/linechart.dart';
import 'package:janpro/Utitlity/sizeConfig.dart';
import 'package:janpro/main.dart';
import 'package:janpro/model/AddAttendanceResponse.dart' as addattten;
import 'package:janpro/model/AddratingResponse.dart' as addrating;
import 'package:janpro/model/AttendencelistResponse.dart';
import 'package:janpro/model/RatinglistResponse.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart' as permishan;



import 'dart:math' as math;

import '../DBHelper/db_helper.dart';
import '../const/global.dart';

class Ratingclass {
  final String name;

  final String value;

  Ratingclass(this.name, this.value);
}

class MainList {
  final String name;
  final String priority;

  MainList(this.name, this.priority);
}

class RateList {
  final String master_area;
  final String master_block;
  final String rating;

  RateList(this.master_area, this.master_block, this.rating);
}

class RatingDetails extends StatefulWidget {
  final String clientname;
  final bool isratingview;

  RatingDetails(this.clientname, this.isratingview);

  @override
  _RatingDetailsState createState() => _RatingDetailsState();
}

class _RatingDetailsState extends State<RatingDetails>
    with TickerProviderStateMixin {
  var searchcontroller = new TextEditingController();
  var namecontroller = new TextEditingController();
  var sitenamecontroller = new TextEditingController();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  var mobilecontroller = new TextEditingController();
  var datecontroller = new TextEditingController();
  List<EmployeeList> unitemployeelist = [];
  String selectedValue = "Pending";
  List<Tab> tabs = <Tab>[];
  String? lat;
  String? long;
  List<String> listtab = [];
  List<String>? formValue1;
  int tag = 0;
  int maintag = 0;

  String _isSelected = "";
  List<Datum> mainlisttab = [];
  List<Ratingclass> ratinglist = [];
  late Data attendancedata;
  bool isdataloaded = false;
  List<EmployeeList> searchUserList = [];
  String? role = "1";
  late TabController _tabControllermain;
  int selectedinsidetabindex = 0;
  final List<Tab> tabsmain = <Tab>[];
  int selectedindex = 0;
  bool showAvg = false;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    var datefrom = DateFormat('dd-MM-yyyy').format(DateTime.now());
    datecontroller.text = datefrom;
    print("date ");
    getrole();
  }

  Future<void> refreshData() async {
    // Simulating an API request or data refresh
    setState(() {
      print("APICall");
      //     var  datefrom =
      //                                   DateFormat('dd-MM-yyyy').format(DateTime.now());
      // datecontroller.text=datefrom;
      getrole();
    });
  }

  getrole() async {
    role = await SPManager().getroleid();
    opertionaltainglistwiseapi();
    if (role == GlobalLists.unitrole ||
        role == GlobalLists.headrole ||
        role == GlobalLists.reginalmanagerrole ||
        role == GlobalLists.clientrole ||
        role == GlobalLists.operationrole ||
        role == GlobalLists.operationmanagerrole) {
      setState(() {
        listtab.add("3.30 - 4.00 pm");
        listtab.add("3.50 - 4.00 pm");
        listtab.add("4.30 - 5.00 pm");

        //  mainlisttab.add(MainList("OverAll","0"));
        //   mainlisttab.add(MainList("IMAX","0"));
        //    mainlisttab.add(MainList("Cinipol","0"));
        //     mainlisttab.add(MainList("Cinimax","0"));
      });

      ratinglist.add(Ratingclass("Washroom", "7"));
      ratinglist.add(Ratingclass("Cleaning", "5"));
    }
  }

  onItemChanged(String value) {
    print("in");

    setState(() {
      searchUserList.clear();

      GlobalLists.attendanceemployeelist.forEach((iElement) {
        if (iElement.name
            .toString()
            .toLowerCase()
            .contains(value.toLowerCase())) {
          searchUserList.add(iElement);
        }
      });
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey1 = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => Rating(""),
          ),
        );
        return await false;
      },
      child: Scaffold(
        key: _scaffoldKey1,
        endDrawer: Theme(
          data: Theme.of(context).copyWith(
              canvasColor: customcolor.blue, primaryColor: customcolor.blue),
          child: AppDrawerfilter(role),
        ),
        backgroundColor: customcolor.greybg,
        resizeToAvoidBottomInset: false,

        //floating action button position to center
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(148),
          child: AppbarComman(
              setStyleStr: 'Rating',
              onPressedBack: () {},
              onPressedNotify: () {},
              onPressedSearch: () {},
              onPressedSort: () {},
              onPressedmenu: () {
                _scaffoldKey1.currentState!.openEndDrawer();
              }),
        ),

        body:isRatingLoading?
        
        Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: customcolor.blue,),
            SizedBox(height: 15),
                Text("Loading, please wait...",
                    style: TextStyle(
                        color:   Colors.black))
          ],
        ))
        : Stack(
          children: [
            mainlisttab.length > 0
                ? SingleChildScrollView(
                    physics: ScrollPhysics(),
                    child: (role == GlobalLists.headrole ||
                            role == GlobalLists.reginalmanagerrole ||
                            role == GlobalLists.clientrole ||
                            role == GlobalLists.operationrole ||
                            role == GlobalLists.operationmanagerrole)
                        ? Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 20, bottom: 5),
                            child: Container(
                              child: CustomRefreshIndicator(
                                builder: (
                                  BuildContext context,
                                  Widget child,
                                  IndicatorController controller,
                                ) {
                                  return Stack(
                                    alignment: Alignment.topCenter,
                                    children: <Widget>[
                                      if (!controller.isIdle)
                                        Positioned(
                                          top: 35.0 * controller.value,
                                          child: SizedBox(
                                            height: 30,
                                            width: 30,
                                            child: CircularProgressIndicator(
                                              value: !controller.isLoading
                                                  ? controller.value
                                                      .clamp(0.0, 1.0)
                                                  : null,
                                            ),
                                          ),
                                        ),
                                      Transform.translate(
                                        offset:
                                            Offset(0, 100.0 * controller.value),
                                        child: child,
                                      ),
                                    ],
                                  );
                                },
                                onRefresh: refreshData,
                                child: ListView(
                                  shrinkWrap: true,
                                  //  physics: ScrollPhysics(),
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (BuildContext
                                                                  context) =>
                                                              Rating("")));
                                                },
                                                child: Icon(Icons.arrow_back)),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Container(
                                              child: Text(
                                                "RATING",
                                                style: AppFonts.headerStyle(
                                                    fontSize:
                                                        ResponsiveFlutter.of(
                                                                context)
                                                            .fontSize(2.3),
                                                    color: customcolor.black,
                                                    fontWeight:
                                                        FontWeight.w300),
                                              ),
                                            ),
                                          ],
                                        ),
                                        //                   (role==GlobalLists.headrole||role==GlobalLists.clientrole||role==GlobalLists.operationrole)?
                                        //                       new Container(
                                        //                                     decoration: BoxDecoration(
                                        //                               color: Colors.white, borderRadius: BorderRadius.circular(20)),
                                        //                         width:110,
                                        //                         height: 30,
                                        //                         padding: EdgeInsets.only(left: 6,bottom: 5,top:3,right: 5),
                                        //                         child: new Row(
                                        //                           mainAxisAlignment: MainAxisAlignment.center,
                                        //                           children: <Widget>[
                                        //                             // new Expanded(child: new Text("Bemerkung",)),
                                        //                             new  Expanded(
                                        //                                   child: new TextField(

                                        //                                     textAlign: TextAlign.center,
                                        //                                     style:

                                        //                                      AppFonts.headerStyle(fontSize:12,
                                        // color: customcolor.black,fontWeight: FontWeight.w300  ),
                                        //                                  readOnly: true,
                                        //                                  onTap: ()
                                        //                                  async {
                                        //                                    DateTime? pickedDate = await showDatePicker(
                                        //                 context: context,
                                        //                 initialDate: DateTime.now(),
                                        //                 firstDate: DateTime(1950),
                                        //                 lastDate: DateTime(2050));

                                        //             if (pickedDate != null) {
                                        //             var  datefrom =
                                        //                                     DateFormat('dd-MM-yyyy').format(pickedDate);
                                        //               datecontroller.text =datefrom;
                                        //               print(datecontroller.text);
                                        //             }
                                        //                                  },
                                        //                                     controller: datecontroller,
                                        // decoration: InputDecoration( border: InputBorder.none,),
                                        //                                   ),
                                        //                                 ),
                                        //                                GestureDetector(
                                        //                                   onTap: ()
                                        //                                   async {
                                        //                                         DateTime? pickedDate = await showDatePicker(
                                        //                 context: context,
                                        //                 initialDate: DateTime.now(),
                                        //                 firstDate: DateTime(1950),
                                        //                 lastDate: DateTime(2050));

                                        //             if (pickedDate != null) {
                                        //             var  datefrom =
                                        //                                     DateFormat('dd-MM-yyyy').format(pickedDate);
                                        //               datecontroller.text =datefrom;
                                        //               print(datecontroller.text);
                                        //             }
                                        //                                   },
                                        //                                    child: Padding(
                                        //                                    padding:  EdgeInsets.only(bottom: 1,right: 5),
                                        //                                    child:   Image.asset('assets/images/calendar.png',width: 22,height: 22,alignment: Alignment.center,),
                                        //                                  ),
                                        //                                  ),
                                        //                           ],
                                        //                         ),
                                        //                       ):Container()
                                      ],
                                    ),

                                    //workflow
                                    SizedBox(
                                      height: 10,
                                    ),
                                    mainlisttab.length > 0
                                        ? headmodule()
                                        : Container()
                                  ],
                                ),
                              ),
                            ),
                          )
                        : Container(),
                  )
                : Container(),
            mainlisttab.length > 0
                ? mainlisttab[maintag].pendingstatus == 0
                    ? mainlisttab[maintag].overallRating > 0
                        ? Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  right: SizeConfig.blockSizeHorizontal * 10,
                                  bottom: 10,
                                  left: SizeConfig.blockSizeHorizontal * 10),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: customcolor.blue,
                                  minimumSize: Size(
                                      SizeConfig.blockSizeHorizontal * 80,
                                      SizeConfig.blockSizeVertical * 5),
                                  textStyle: AppFonts.headerStyle(
                                      fontSize: 15,
                                      color: customcolor.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                onPressed: () {
                                  namecontroller.text = "";
                                  ratingsheet(
                                      context,
                                      mainlisttab[maintag]
                                          .overallRating
                                          .toString(),
                                      selectedinsidetabindex);
                                },
                                child: Text(
                                  'Submit',
                                  style: AppFonts.headerStyle(
                                      fontSize: 14,
                                      color: customcolor.white,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),
                          )
                        : Container()
                    : Container()
                : Container(),

            // mainlisttab[maintag].overallRating==0?   Container() :Align(alignment: Alignment.bottomRight,
            //   child:  Padding(
            //     padding:  EdgeInsets.only(right: SizeConfig.blockSizeHorizontal *10,bottom: 30,left: SizeConfig.blockSizeHorizontal * 10),
            //     child:  ElevatedButton(
            //                           style: ElevatedButton.styleFrom(
            //                               backgroundColor: customcolor.blue,
            //                               minimumSize: Size(
            //                                   SizeConfig.blockSizeHorizontal * 80,
            //                                   SizeConfig.blockSizeVertical * 5),
            //                               textStyle:
            //                                AppFonts.headerStyle(fontSize:15,
            //                       color: customcolor.black,
            //                       fontWeight: FontWeight.bold  ),
            //                              ),
            //                           onPressed: () {
            //                              ratingsheet(context);
            //                           },
            //                           child: Text(
            //                             'Submit',
            //                             style:
            //                              AppFonts.headerStyle(fontSize:14,
            //                       color: customcolor.white,
            //                       fontWeight: FontWeight.w400  ),

            //                           ),
            //                         ),
            //   ),),
          ],
        ),
      ),
    );
  }

  ratingsheet(BuildContext context, String overallrating, int tabmainindex) {
    showModalBottomSheet(
        backgroundColor: Colors.white,
        isScrollControlled: true,
        isDismissible: true,
        enableDrag: true,
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
              height: SizeConfig.blockSizeVertical * 33 +
                  MediaQuery.of(context).viewInsets.bottom,
              color: Colors.white,
              margin: EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 2),
              padding: EdgeInsets.all(5),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                        height: 30,
                      ),
                      Text(
                        "Any key issue to be addressed before next inspection ?",
                        textAlign: TextAlign.center,
                        style: AppFonts.headerStyle(
                            fontSize: 14,
                            color: customcolor.black,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      FormTextField(
                        textboxcolor: customcolor.skybluebg,
                        textcontroller: namecontroller,
                        placeholderStr: "Write your Review",
                        maxLines: 3,
                        contaninerheigth: 80,
                        textInputType: TextInputType.text,
                        onchange: (val) {},
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: customcolor.blue,
                            minimumSize: Size(
                                SizeConfig.blockSizeHorizontal * 80,
                                SizeConfig.blockSizeVertical * 5),
                            textStyle: AppFonts.headerStyle(
                                fontSize: 15,
                                color: customcolor.black,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            //    if(namecontroller.text.isEmpty)
                            //    {
                            //ShowDialogs.showToast(
                            //               "Please add review");
                            //               }else{
                            Navigator.pop(context);
                            addratingapi(
                                mainlisttab[maintag].overallRating.toString(),
                                tabmainindex,
                                namecontroller.text);
                            //  }
                          },
                          child:addRating?CircularProgressIndicator(color: customcolor.white,): Text(
                            'Done',
                            style: AppFonts.headerStyle(
                                fontSize: 14,
                                color: customcolor.white,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          });
        });
  }

  Widget headmodule() {
    return ListView(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      children: [
        Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Container(
              height: 25,
              child: ListView(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                physics: ScrollPhysics(),
                children: _buildChoicemainList(),
              ),
            )
            // Wrap(
            //    spacing: 5.0,
            //    runSpacing: 3.0,
            //    children: _buildChoicemainList(),
            //  ),
            ),
        Container(
          height: SizeConfig.blockSizeVertical * 100,
          decoration: BoxDecoration(
            //color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: customcolor.greybg,
              width: 0.4,
            ),
          ),
          child: ListView(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            // mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [maintab(maintag)],
          ),
        ),
      ],
    );
  }

  Widget maintab(int maintag) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        // mainAxisAlignment: MainAxisAlignment.start,
        shrinkWrap: true,
        physics: ScrollPhysics(),
        children: [
          ratingbox(0, "Overall Rating", 0),
          SizedBox(
            height: 10,
          ),
          Visibility(
              visible: mainlisttab[maintag].review.isEmpty ? false : true,
              child: commentsbox(0, "comments", 0)),
          //
          Container(
            height: SizeConfig.blockSizeVertical * 100,
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //client re 2march
                // TabBar(
                //   isScrollable: true,
                //   indicatorSize: TabBarIndicatorSize.label,
                //   indicatorWeight: 2,
                //   unselectedLabelColor: customcolor.black,
                //   indicatorColor: customcolor.blue,

                //   labelColor: customcolor.blue,
                //   indicatorPadding:
                //       EdgeInsets.only(top: 10, bottom: 10),
                //   // indicator: BoxDecoration(
                //   //   color: customcolor.darkorange,
                //   //   // borderRadius: BorderRadius.all(
                //   //   //   Radius.circular(1),
                //   //   // ),
                //   // ),
                //   tabs:tabs,
                //   controller: _tabController,
                // ),
//                         Expanded(
//                           flex: 3,
//                           child: TabBarView(
//                               physics: ScrollPhysics(),
//                               controller: _tabController,
//                               children:
//                                 List.generate(
//                   tabs.length,
//                   (tabindexmain)
//                   //expandedheader(tabindex),
//                   {
//                     return ListView(
//                       shrinkWrap: true,
//                       physics: ScrollPhysics(),
//                       children: [
// SizedBox(height: 10,),

//           Container(
//             // color: customcolor.skyblue,
//             height: SizeConfig.blockSizeVertical*47,
//             child: ListView.builder(
//                               scrollDirection: Axis.vertical,
//                               shrinkWrap: true,
//                               physics: ScrollPhysics(),
//                               itemCount:mainlisttab[maintag].masterArea[tabindexmain].blockData!.length,
//                               itemBuilder: (context, index) {

// selectedinsidetabindex=tabindexmain;
//                                 return Padding(
//                                   padding: const EdgeInsets.only(top: 10),
//                                   child: ratingbox(index,"",tabindexmain),
//                                 );
//                               }),
//           ),
//                                           //comm  mainlisttab[maintag].overallRating==0?   Container() :

//                                           //  mainlisttab[maintag].pendingstatus==0?
//           //     mainlisttab[maintag].overallRating>0?
//           //         Align(alignment: Alignment.bottomRight,
//           // child:  Padding(
//           //   padding:  EdgeInsets.only(right: SizeConfig.blockSizeHorizontal *10,bottom: 10,left: SizeConfig.blockSizeHorizontal * 10),
//           //   child:  ElevatedButton(
//           //                 style: ElevatedButton.styleFrom(
//           //                     backgroundColor: customcolor.blue,
//           //                     minimumSize: Size(
//           //                         SizeConfig.blockSizeHorizontal * 80,
//           //                         SizeConfig.blockSizeVertical * 5),
//           //                     textStyle:
//           //                      AppFonts.headerStyle(fontSize:15,
//           //             color: customcolor.black,
//           //             fontWeight: FontWeight.bold  ),
//           //                    ),
//           //                 onPressed: () {
//           //                   namecontroller.text="";
//           //                    ratingsheet(context,mainlisttab[maintag].overallRating.toString(),tabindexmain);
//           //                 },
//           //                 child: Text(
//           //                   'Submit',
//           //                   style:
//           //                    AppFonts.headerStyle(fontSize:14,
//           //             color: customcolor.white,
//           //             fontWeight: FontWeight.w400  ),

//           //                 ),
//           //               ),
//           // ),):Container():Container(),

//                       ],);
//                   }

//                 ),

//                           //     [
//                           //        ListView.builder(
//                           //   scrollDirection: Axis.vertical,
//                           //   shrinkWrap: true,
//                           //   physics: ScrollPhysics(),
//                           //   itemCount:ratinglist.length,
//                           //   itemBuilder: (context, index) {
//                           //     return Padding(
//                           //       padding: const EdgeInsets.only(top: 10),
//                           //       child: ratingbox(index,""),
//                           //     );
//                           //   }),

//                           //  ListView.builder(
//                           //   scrollDirection: Axis.vertical,
//                           //   shrinkWrap: true,
//                           //   physics: ScrollPhysics(),
//                           //   itemCount:1,
//                           //   itemBuilder: (context, index) {
//                           //     return Padding(
//                           //       padding: const EdgeInsets.only(top: 10),
//                           //       child: ratingbox(index,""),
//                           //     );
//                           //   }),
//                           //   ListView.builder(
//                           //   scrollDirection: Axis.vertical,
//                           //   shrinkWrap: true,
//                           //   physics: ScrollPhysics(),
//                           //   itemCount:ratinglist.length,
//                           //   itemBuilder: (context, index) {
//                           //     return Padding(
//                           //       padding: const EdgeInsets.only(top: 10),
//                           //       child: ratingbox(index,""),
//                           //     );
//                           //   }),

//                           //     ]
//                               ),
//                         ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget ratingbox(int index, String text, int tabindexmain) {
    return Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(10),
      color: customcolor.white,
      child: Padding(
        padding: const EdgeInsets.only(left: 4, right: 4, top: 16, bottom: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5, bottom: 5),
              child: Text(
                text == "Overall Rating"
                    ? "Overall Rating"
                    : mainlisttab[maintag]
                        .masterArea[tabindexmain]
                        .blockData![index]
                        .masterBlockName!,
                style: AppFonts.headerStyle(
                    fontSize: ResponsiveFlutter.of(context).fontSize(2.2),
                    color: customcolor.black,
                    fontWeight: FontWeight.w500),
              ),
            ),
            RatingBar.builder(
              // ignoreGestures: mainlisttab[maintag].pendingstatus == 1 ? true : false,
              ignoreGestures: role == GlobalLists.reginalmanagerrole ||
                      role == GlobalLists.clientrole
                  ? (mainlisttab[maintag].pendingstatus == 1 ? true : false)
                  : true,
              itemSize: SizeConfig.screenWidth / 11.5,
              initialRating: text == "Overall Rating"
                  ? double.parse(mainlisttab[maintag].overallRating.toString())
                  : double.parse(mainlisttab[maintag]
                      .masterArea[tabindexmain]
                      .blockData![index]
                      .rating
                      .toString()),
              minRating: 1,
              direction: Axis.horizontal,
              // allowHalfRating: true,
              itemCount: 10,
              itemPadding: EdgeInsets.symmetric(horizontal: 0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  if (text == "Overall Rating") {
                    mainlisttab[maintag].overallRating = rating;
                  } else {
                    //  int topsellindex = mainlisttab[maintag].masterArea[tabindexmain].blockData!.indexWhere((item) => item.id.toString() == mainlisttab[maintag].masterArea[tabindexmain].id.toString());
                    mainlisttab[maintag]
                        .masterArea[tabindexmain]
                        .blockData![index]
                        .rating = rating;
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget commentsbox(int index, String text, int tabindexmain) {
    return Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(10),
      color: customcolor.white,
      child: Padding(
        padding: const EdgeInsets.only(left: 4, right: 4, top: 16, bottom: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5, bottom: 5),
              child: Text(
                // text == "Overall Rating"
                //     ? "Overall Rating"
                //     : mainlisttab[maintag]
                //         .masterArea[tabindexmain]
                //         .blockData![index]
                //         .masterBlockName!,
                "Review",
                style: AppFonts.headerStyle(
                    fontSize: ResponsiveFlutter.of(context).fontSize(2.2),
                    color: customcolor.black,
                    fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5, bottom: 5),
              child: Text(
                mainlisttab[maintag].review,
                style: AppFonts.headerStyle(
                    fontSize: ResponsiveFlutter.of(context).fontSize(1.8),
                    color: customcolor.greytext,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildChoiceList() {
    List<Widget> choices = [];
    listtab.forEachIndexed((item, value) {
      choices.add(Container(
        child: ChoiceChip(
          label: Text(
            item,
            style: AppFonts.headerStyle(
                fontSize: 12,
                color: customcolor.black,
                fontWeight: FontWeight.bold),
          ),
          // shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20))),
          labelStyle: AppFonts.headerStyle(
              fontSize: 12,
              color: tag == value ? customcolor.blue : customcolor.greytext,
              fontWeight: FontWeight.bold),

          selectedColor: customcolor.blue.withOpacity(0.2),
          backgroundColor: customcolor.white,
          selected: tag == value,
          onSelected: (selected) {
            setState(() {
              _isSelected = item;
              tag = value;
            });
          },
        ),
      ));
    });
    return choices;
  }

  //tab
  _buildChoicemainList() {
    List<Widget> choices = [];
    mainlisttab.forEachIndexed((item, value) {
      choices.add(Container(
        height: 25,
        child: Padding(
          padding: const EdgeInsets.only(right: 5),
          child: ChoiceChip(
            label: Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Text(
                item.clientName,
                style: AppFonts.headerStyle(
                    fontSize: 12,
                    color: maintag == value
                        ? customcolor.white
                        : item.status == 0
                            ? customcolor.red
                            : customcolor.green,
                    // item.priority == "1"?customcolor.red:
                    // customcolor.greytext,
                    fontWeight: FontWeight.bold),
              ),
            ),
            side: BorderSide(
              width: 0.5,
              color: maintag == value
                  ? customcolor.white
                  : item.status == 0
                      ? customcolor.red
                      : customcolor.green,
              // item.priority == "1"?customcolor.red:
              // customcolor.white
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10))),
            labelStyle: AppFonts.headerStyle(
                fontSize: 12,
                color: maintag == value
                    ? customcolor.blue
                    : item.status == 0
                        ? customcolor.red
                        : customcolor.green,
                //customcolor.greytext,
                fontWeight: FontWeight.bold),
            selectedColor: customcolor.tabblue,
            backgroundColor: customcolor.white,
            selected: maintag == value,
            onSelected: (selected) {
              setState(() {
                _isSelected = item.clientName;
                maintag = value;
                tabs = <Tab>[];
                _tabController = new TabController(
                    vsync: this,
                    length: mainlisttab[maintag].masterArea.length);
                for (int i = 0;
                    i < mainlisttab[maintag].masterArea.length;
                    i++) {
                  tabs.add(
                    new Tab(
                      text: mainlisttab[maintag].masterArea[i].masterAreaName,
                    ),
                  );
                }
              });
            },
          ),
        ),
      ));
    });
    return choices;
  }

  

  Future<Placemark> getLocation() async {


  // Get current position
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);



  // Get placemarks (address) from coordinates
  List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude, position.longitude);

  if (placemarks.isEmpty) {
    throw Exception("No address found for this location");
  }

  Placemark first = placemarks.first;

   lat = position.latitude.toString();
   long = position.longitude.toString();

  print("${first.name} : ${first.street}, ${first.locality}, ${first.country}");

  return first;
}
  
  //addrating
bool addRating=false;
  addratingapi(String overallrating, int tabmainindex, String review) async {
    var status1 = await ConnectionDetector.checkInternetConnection();

    var rate = <RateList>[];
    for (int i = 0; i < mainlisttab[maintag].masterArea.length; i++) {
      for (int j = 0;
          j < mainlisttab[maintag].masterArea[i].blockData!.length;
          j++) {
        rate.add(RateList(
          mainlisttab[maintag]
              .masterArea[i]
              .blockData![j]
              .masterArea
              .toString(),
          mainlisttab[maintag]
              .masterArea[i]
              .blockData![j]
              .masterBlock
              .toString(),
          mainlisttab[maintag].masterArea[i].blockData![j].rating.toString(),
        ));
      }
    }

    List<Map<dynamic, dynamic>> productoption = [];
    for (var item in rate) {
      productoption.add({
        "master_area": item.master_area,
        "master_block": item.master_block,
        "rating": item.rating,
      });
    }

    var jsonbody = {
      "site_id": mainlisttab[maintag].siteId.toString(),
      "client_id": mainlisttab[maintag].clientId.toString(),
      "overall_rating": overallrating,
      "review": review,
      "master_data": productoption,
    };

    log("Rating Payload: $jsonbody");

    if (status1) {
      // ShowDialogs.showLoadingDialog(context, _keyLoader);
setState(() {
  addRating=true;
});
      APIManager().apiRequest(
        context,
        API.addrating,
        (response) async {
          addrating.AddratingResponse resp = response;
          // Navigator.of(context).pop();
setState(() {
  addRating=false;
});
          if (resp.status == 1) {
            setState(() {
              Timer(Duration(seconds: 1), () => Navigator.pop(context));
              ShowDialogs()
                  .confirmationdone(context, "Rating Done \nSuccessfully");
              Timer(
                Duration(seconds: 1),
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RatingDetails(
                      mainlisttab[maintag].clientName,
                      widget.isratingview,
                    ),
                  ),
                ),
              );
            });
          } else {
            ShowDialogs.showToast(resp.msg);
          }
        },
        (error) {
          // Navigator.of(context).pop();
          setState(() {
  addRating=false;
});
          print("API Error: $error");
        },
        true,
        "",
        parameter: jsonbody,
      );
    } else {
      /// 🔁 Save Rating API Offline
      await DBHelper.insertOfflineRequest(
        '${Global.baseUrl}/api/clientmaster/add_rating',
        jsonbody,
        supporting_image: [], // Add image path here if applicable
        isMultipart: false,
      );

      ShowDialogs.showToast("Rating saved offline. Will sync when online.");
    }
  }
bool isRatingLoading=false;
  opertionaltainglistwiseapi() async {
    var status1 = await ConnectionDetector.checkInternetConnection();

    if (status1) {
      
      setState(() {
        mainlisttab = [];
 isRatingLoading=true;
        
      });
      

      var map = new Map<String, dynamic>();
      var clientid = await SPManager().getclientid();
      var supervisorid = await SPManager().getsupervisorid();

      print(clientid);
      if (role == GlobalLists.clientrole) {
        map['clientid'] = clientid;
      } else {
        map['emp_id'] = supervisorid;
      }
      print(map);
      APIManager().apiRequest(context, API.operationalclientwiseratinglist,
          (response) async {
        RatinglistResponse resp = response;
        print('called API ${resp}');
        setState(() {
          isRatingLoading=false;
        });
        if (resp.status == 1) {
          setState(() {
            // mainlisttab=resp.data;

            for (int i = 0; i < resp.data.length; i++) {
              mainlisttab.add(resp.data[i]);
              print(resp.data[i].clientName);
              print(widget.clientname);

              if (resp.data[i].clientName == widget.clientname) {
                //  int selectindex = resp.data.indexWhere((item) => item.clientName == "RMALL - Mulund");
                setState(() {
                  maintag = i;
                });
              }
            }
            _tabController = new TabController(
                vsync: this, length: mainlisttab[maintag].masterArea.length);
            for (int i = 0; i < mainlisttab[maintag].masterArea.length; i++) {
              tabs.add(
                new Tab(
                  text: mainlisttab[maintag].masterArea[i].masterAreaName,
                ),
              );
            }
          });
          // Navigator.of(this.context).pop();
          //  ShowDialogs.showToast(resp.msg);
        } else {
          ShowDialogs.showToast(resp.msg);
          // Navigator.of(this.context).pop();
        }
      }, (error) {
         setState(() {
          isRatingLoading=false;
        });
        print('ERR msg is $error');
        //  Navigator.of(this.context).pop();
      }, false, "", jsonval: map);
    } else {
      ShowDialogs.showToast("Please check internet connection");
    }
  }
}

extension ExtendedIterable<E> on Iterable<E> {
  /// Like Iterable<T>.map but the callback has index as second argument
  Iterable<T> mapIndexed<T>(T Function(E e, int i) f) {
    var i = 0;
    return map((e) => f(e, i++));
  }

  void forEachIndexed(void Function(E e, int i) f) {
    var i = 0;
    forEach((e) => f(e, i++));
  }
}
