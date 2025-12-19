
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:janpro/Screens/Attendance.dart';
import 'package:janpro/Screens/Homepage.dart';
import 'package:janpro/Utitlity/APIManager.dart';
import 'package:janpro/Utitlity/AppDrawer.dart';
import 'package:janpro/Utitlity/GlobalLists.dart';
import 'package:janpro/Utitlity/ResponsiveFlutter.dart';
import 'package:janpro/Utitlity/SPManager.dart';
import 'package:janpro/Utitlity/ShowDialog.dart';
import 'package:janpro/Utitlity/appbar.dart';
import 'package:janpro/Utitlity/button.dart';
import 'package:janpro/Utitlity/customBottomNavigationBar.dart';
import 'package:janpro/Utitlity/custom_color.dart';
import 'package:janpro/Utitlity/internetConnection.dart';
import 'package:janpro/Utitlity/sizeConfig.dart';
import 'package:janpro/model/OperationalWorkflowResponse.dart' as operwf;
import 'package:janpro/model/UpdatedworkflowResponse.dart';
import 'package:janpro/model/WorkflowoperationalDetailmodel.dart'
    as newoperdetail;
import 'package:janpro/model/Workflowoperationalmodel.dart' as newopera;
import 'package:janpro/model/WorkfowstatusResponse.dart';
import 'package:page_transition/page_transition.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
// import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../DBHelper/db_helper.dart';
import '../const/global.dart';

// import 'package:syncfusion_flutter_sliders/sliders.dart';

class PendingTask {
  final String? maintaskname;
  final String? masterareaid;
  final String? masterblockid;
  final List<Checklist>? listvalue;
  final List? multipleSelected;
  bool? isenabledclick;

  PendingTask({
    this.maintaskname,
    this.listvalue,
    this.multipleSelected,
    this.isenabledclick,
    this.masterareaid,
    this.masterblockid,
  });
}

class OperationalPendingTask {
  final String? maintaskname;
  final String? masterareaid;
  final String? masterblockid;
  final List<operwf.Checklist>? listvalue;
  final List? multipleSelected;
  bool? isenabledclick;

  OperationalPendingTask({
    this.maintaskname,
    this.listvalue,
    this.multipleSelected,
    this.isenabledclick,
    this.masterareaid,
    this.masterblockid,
  });
}

class NewOperationalPendingTask {
  final String? maintaskname;
  final String? masterareaid;
  final String? masterblockid;
  final List<newoperdetail.Checklist>? listvalue;
  final List? multipleSelected;
  bool? isenabledclick;

  NewOperationalPendingTask({
    this.maintaskname,
    this.listvalue,
    this.multipleSelected,
    this.isenabledclick,
    this.masterareaid,
    this.masterblockid,
  });
}

class WorkflowstatusOperation extends StatefulWidget {
  final String shiftid;
  final bool isnotify;
  final String selectedid;
  final String endtime;
  String clientname;
  String updateDate;

  WorkflowstatusOperation(this.shiftid, this.isnotify, this.selectedid,
      this.endtime, this.clientname, this.updateDate);

  @override
  _WorkflowstatusOperation createState() => _WorkflowstatusOperation();
}

class _WorkflowstatusOperation extends State<WorkflowstatusOperation>
    with TickerProviderStateMixin {
  bool expand = true;
  late ScrollController _scrollController;
  late ScrollController _scrollControllerbuttontab;
  int selectedindexmain = 0;

  // bool enabled = false;
  int? tapped;
  var statuscontroller = new TextEditingController();
  var namecontroller = new TextEditingController();
  List<Tab> tabs = <Tab>[];
  List<MasterAreaWiseList> listtab = [];
  List<operwf.MasterAreaWiseList> operationlisttab = [];
  List<newoperdetail.MasterAreaWiseList> detailoperationlisttab = [];

  bool isdataloaded = false;
  String _isSelected = "";

  var mobilecontroller = new TextEditingController();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  double yOffset = 0;
  double xOffset = 0;
  double pageScale = 1;
  String selectedValue = "Pending";
  late TabController _tabController;
  var selectedDateTime;

  double _value = 40.0;
  List<Widget> listoftabwiget = [];
  List<Widget> listoftabwigetmain = [];

  List mainlist = [];
  bool isoptionopen = false;

  // var datecontroller = new TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey1 = new GlobalKey<ScaffoldState>();
  List<String> options = [
    "TAT",
    "Dependent",
    "Resolved",
  ];
  // Map<String, List<newoperdetail.WorkflowoperationalDetailmodel>>
  //     GlobalLists.clientDetailsMap = {};
  // static Map<String, List<Checklist>> clientPointerMap = {};

  // int currentvisibletimeindex=0;

  String checklistdate = "";
  // List<newopera.Datum> operationalmainlisttab = [];

  // List<newoperdetail.Datum> GlobalLists.detailopeermainlisttab = [];
  List<String>? formValue1;
  int tag = 0;
  bool isUpdateButtonVisible = true;

  String finaldateselecter = '';

  Future<void> refreshData() async {
    // Simulating an API request or data refres
    setState(() {
      print("APICall NEW PAGE");
      //     var  datefrom =
      //                                   DateFormat('dd-MM-yyyy').format(DateTime.now());
      // datecontroller.text=datefrom;
      getrole();

      //  _tabController = new TabController(vsync: this, length: 3);
    });
  }

  var todaysDate = "";
  @override
  void initState() {
    super.initState();
    // var todaysDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

    // final DateFormat formatter = DateFormat('dd-MM-yyyy');

    // DateTime today = formatter.parse(
    //   formatter.format(DateTime.now()),
    // );

    // DateTime selectedDate = formatter.parse(GlobalLists.datecontroller.text);

    // if (selectedDate.isBefore(today)) {
    //   isUpdateButtonVisible = false;
    // } else {
    //   isUpdateButtonVisible = true;
    // }

    print("Anand");

    var datefrom = DateFormat('dd-MM-yyyy').format(DateTime.now());
    if (widget.updateDate.isEmpty) {
      // no date
      DateTime initDate = GlobalLists.multiday
          ? DateTime.now().subtract(const Duration(days: 1)) // yesterday
          : DateTime.now(); // today

      String datefrom = DateFormat('dd-MM-yyyy').format(initDate);

      GlobalLists.datecontroller.text = datefrom;
      checklistdate = datefrom;
      finaldateselecter = DateFormat('yyyy-MM-dd').format(initDate);
    } else {
      // update data
      DateTime date = DateTime.parse(widget.updateDate);

      // if multiday true, still shift to yesterday relative to updateDate
      DateTime initDate =
          GlobalLists.multiday ? date.subtract(const Duration(days: 1)) : date;

      String formattedDate = DateFormat('dd-MM-yyyy').format(initDate);

      GlobalLists.datecontroller.text = formattedDate;
      checklistdate = formattedDate;
      finaldateselecter = DateFormat('yyyy-MM-dd').format(initDate);
    }

    // finaldateselecter= DateFormat('yyyy-MM-dd').format(DateTime.now());
    _scrollControllerbuttontab = ScrollController();
    _scrollController = ScrollController();

//   GlobalLists.tabControllermain=new TabController(length: 1,vsync: this );
// if(GlobalLists.tabControllermain.length>0)
// {
//       GlobalLists.tabControllermain.addListener(() {
//         print("callinginit");
//       setState(() {
//         tag=0;
//         GlobalLists.selectedindex=0;
//     });
//      });
//}
    getrole();
  }

  String role = "";

  getrole() async {
    role = (await SPManager().getroleid())!;
    print("R O L E");
    print(role);
    print(widget.shiftid);
    if (role == GlobalLists.operationrole ||
        role == GlobalLists.headrole ||
        role == GlobalLists.reginalmanagerrole ||
        role == GlobalLists.operationmanagerrole) {
      print("Anand1");
      operationlManagerworkflowstatusApi();
    } else if (role == GlobalLists.clientrole) {
      operationlworkflowstatusApi();
    } else {
      //supervisor
      workflowstatusApi(widget.shiftid);
    }
  }

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
        backgroundColor: customcolor.greybg,
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
        //floating action button position to center
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(148),
          child: AppbarComman(
              setStyleStr: 'home',
              onPressedBack: () {},
              onPressedNotify: () {},
              onPressedSearch: () {},
              onPressedSort: () {},
              onPressedmenu: () {
                _scaffoldKey1.currentState!.openEndDrawer();
              }),
        ),
        endDrawer: Theme(
          data: Theme.of(context).copyWith(
              canvasColor: customcolor.blue, primaryColor: customcolor.blue),
          child: AppDrawerfilter(role),
        ),
        key: _scaffoldKey1,
        bottomNavigationBar: CustomBottomNavigationBar(index: 1),
        body:
            // isWorflowLoading?
            //Center(child: Column(
            //    mainAxisAlignment: MainAxisAlignment.center,
            //   crossAxisAlignment: CrossAxisAlignment.center,
            //   children: [
            //     CircularProgressIndicator(color: customcolor.blue,),
            //     SizedBox(height: 15),
            //         Text("Loading, please wait...",
            //             style: TextStyle(
            //                 color:   Colors.black))
            //   ],
            // )):

            ValueListenableBuilder<bool>(
                valueListenable: GlobalLists.isWorflowLoading,
                builder: (context, isLoading, _) {
                  if (isLoading) {
                    return Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: customcolor.blue,
                        ),
                        SizedBox(height: 15),
                        Text("Loading, please wait...",
                            style: TextStyle(color: Colors.black))
                      ],
                    ));
                  }
                  return Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, top: 20, bottom: 20),
                        child: Container(
                          height: SizeConfig.blockSizeVertical * 100,
                          child: SingleChildScrollView(
                            child: Column(
                              // shrinkWrap: true,
                              // physics: ScrollPhysics(),
                              children: [
                                //r SizedBox(height:10),
                                Container(
                                  // color: customcolor.blue,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        child: Text(
                                          "WORKFLOW",
                                          style: AppFonts.headerStyle(
                                              fontSize:
                                                  ResponsiveFlutter.of(context)
                                                      .fontSize(2.3),
                                              color: customcolor.title,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ),
                                      // hidedate
                                      (role == GlobalLists.unitrole ||
                                              role == GlobalLists.headrole ||
                                              role ==
                                                  GlobalLists
                                                      .reginalmanagerrole ||
                                              role == GlobalLists.clientrole ||
                                              role ==
                                                  GlobalLists.operationrole ||
                                              role ==
                                                  GlobalLists
                                                      .operationmanagerrole ||
                                              role ==
                                                  GlobalLists.supervisorrole)
                                          ? Row(
                                              children: [
                                                new Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
                                                  width: SizeConfig
                                                          .blockSizeHorizontal *
                                                      32,
                                                  height: 30,
                                                  // padding: EdgeInsets.only(left: 6,bottom: 5,top:3,right: 5),
                                                  child: new Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      // new Expanded(child: new Text("Bemerkung",)),
                                                      new Expanded(
                                                        child: new TextField(
                                                          textAlignVertical:
                                                              TextAlignVertical
                                                                  .center,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: AppFonts.headerStyle(
                                                              fontSize:
                                                                  ResponsiveFlutter.of(
                                                                          context)
                                                                      .fontSize(
                                                                          1.6),
                                                              color: customcolor
                                                                  .black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300),
                                                          readOnly: true,
                                                          onTap: () async {
                                                            DateTime? pickedDate = await showDatePicker(
                                                                context:
                                                                    context,
                                                                initialDate: selectedDateTime ??
                                                                        GlobalLists
                                                                            .multiday
                                                                    ? DateTime.now().subtract(
                                                                        const Duration(
                                                                            days:
                                                                                1))
                                                                    : DateTime
                                                                        .now(),
                                                                firstDate:
                                                                    DateTime(
                                                                        1950),
                                                                lastDate:
                                                                    DateTime(
                                                                        2050));

                                                            if (pickedDate !=
                                                                null) {
                                                              var datefrom = DateFormat(
                                                                      'dd-MM-yyyy')
                                                                  .format(
                                                                      pickedDate);
                                                              finaldateselecter =
                                                                  DateFormat(
                                                                          'yyyy-MM-dd')
                                                                      .format(
                                                                          pickedDate);
                                                              GlobalLists
                                                                  .datecontroller
                                                                  .text = datefrom;
                                                                  final DateFormat formatter = DateFormat('dd-MM-yyyy');

setState(() {
final DateFormat formatter = DateFormat('dd-MM-yyyy');

DateTime selectedDate = formatter.parse(datefrom);

DateTime today = DateTime(
  DateTime.now().year,
  DateTime.now().month,
  DateTime.now().day,
);

isUpdateButtonVisible = !selectedDate.isBefore(today);

print("isUpdateButtonVisible");
print(isUpdateButtonVisible);
print(selectedDate);
print("TODAYS $today");
print(isUpdateButtonVisible);
});
                                                              print(GlobalLists
                                                                  .datecontroller
                                                                  .text);
                                                              setState(() =>
                                                                  selectedDateTime =
                                                                      pickedDate);
                                                              if (role == GlobalLists.operationrole ||
                                                                  role ==
                                                                      GlobalLists
                                                                          .headrole ||
                                                                  role ==
                                                                      GlobalLists
                                                                          .reginalmanagerrole ||
                                                                  role ==
                                                                      GlobalLists
                                                                          .operationmanagerrole) {
                                                                operationlManagerworkflowstatusApi();
                                                              } else if (role ==
                                                                  GlobalLists
                                                                      .clientrole) {
                                                                operationlworkflowstatusApi();
                                                              } else {
                                                                workflowstatusApi(
                                                                    widget
                                                                        .shiftid);
                                                              }
                                                              

                                                            }
                                                          },
                                                          controller: GlobalLists
                                                              .datecontroller,
                                                          decoration:
                                                              InputDecoration(
                                                            border: InputBorder
                                                                .none,
                                                            contentPadding:
                                                                EdgeInsets.zero,
                                                            isDense: true,
                                                          ),
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () async {
                                                          DateTime? pickedDate =
                                                              await showDatePicker(
                                                                  context:
                                                                      context,
                                                                  initialDate:
                                                                      selectedDateTime ??
                                                                          DateTime
                                                                              .now(),
                                                                  firstDate:
                                                                      DateTime(
                                                                          1950),
                                                                  lastDate:
                                                                      DateTime(
                                                                          2050));

                                                          if (pickedDate !=
                                                              null) {
                                                            var datefrom = DateFormat(
                                                                    'dd-MM-yyyy')
                                                                .format(
                                                                    pickedDate);
                                                            GlobalLists
                                                                .datecontroller
                                                                .text = datefrom;
                                                            finaldateselecter =
                                                                DateFormat(
                                                                        'yyyy-MM-dd')
                                                                    .format(
                                                                        pickedDate);
                                                                          final DateFormat formatter = DateFormat('dd-MM-yyyy');

setState(() {
final DateFormat formatter = DateFormat('dd-MM-yyyy');

DateTime selectedDate = formatter.parse(datefrom);

DateTime today = DateTime(
  DateTime.now().year,
  DateTime.now().month,
  DateTime.now().day,
);

isUpdateButtonVisible = !selectedDate.isBefore(today);


print("isUpdateButtonVisible");
print(isUpdateButtonVisible);
print(selectedDate);
print("TODAYS $today");
print(isUpdateButtonVisible);
});
                                                            setState(() =>
                                                                selectedDateTime =
                                                                    pickedDate);
                                                            print(GlobalLists
                                                                .datecontroller
                                                                .text);
                                                            if (role == GlobalLists.operationrole ||
                                                                role ==
                                                                    GlobalLists
                                                                        .headrole ||
                                                                role ==
                                                                    GlobalLists
                                                                        .reginalmanagerrole ||
                                                                role ==
                                                                    GlobalLists
                                                                        .operationmanagerrole) {
                                                              operationlManagerworkflowstatusApi();
                                                            } else if (role ==
                                                                GlobalLists
                                                                    .clientrole) {
                                                              operationlworkflowstatusApi();
                                                            } else {
                                                              workflowstatusApi(
                                                                  widget
                                                                      .shiftid);
                                                            }
                                                          }
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  bottom: 1,
                                                                  right: 5),
                                                          child: Image.asset(
                                                            'assets/images/calendar.png',
                                                            width: 22,
                                                            height: 22,
                                                            alignment: Alignment
                                                                .center,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                GlobalLists.operationalmainlisttab
                                                            .length >
                                                        0
                                                    ? _buildChoicemainopertaionalListForTab()
                                                    : SizedBox()
                                              ],
                                            )
                                          : Container()
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                (role == GlobalLists.headrole ||
                                        role ==
                                            GlobalLists.reginalmanagerrole ||
                                        role == GlobalLists.operationrole ||
                                        role ==
                                            GlobalLists.operationmanagerrole)
                                    ? isdataloaded == false
                                        ? ShowDialogs.norecordwidget(0.0,
                                            SizeConfig.blockSizeVertical * 30)
                                        : newoperationalmodule()
                                    : (role == GlobalLists.clientrole)
                                        ? headmodule()
                                        : isdataloaded == false
                                            ? ShowDialogs.norecordwidget(
                                                0.0,
                                                SizeConfig.blockSizeVertical *
                                                    30)
                                            :GlobalLists.isShiftActive==0?ShowDialogs.norecordwidget(
                                                0.0,
                                                SizeConfig.blockSizeVertical *
                                                    30): supervisormodule()
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
      ),
    );
  }

  Widget headmodule() {
    print("headmodule");
    return GlobalLists.mainlisttabs.length == 0
        ? ShowDialogs.norecordwidget(
            // SizeConfig.blockSizeHorizontal * 30,
            //vishu 13 aug 24
            0.0,
            SizeConfig.blockSizeVertical * 30)
        : CustomRefreshIndicator(
            // key: refreshIndicatorKey,
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
                              ? controller.value.clamp(0.0, 1.0)
                              : null,
                        ),
                      ),
                    ),
                  Transform.translate(
                    offset: Offset(0, 100.0 * controller.value),
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
                GlobalLists.mainlisttabs.length > 0
                    ? Padding(
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
                        )
                    : Container(),
                //  GlobalLists.mainlisttabs[GlobalLists.maintag].details.length>0?Container():
                opertaionmodule(),
              ],
            ),
          );
  }

  Widget newoperationalmodule() {
    print("again");
    return GlobalLists.operationalmainlisttab.length == 0
        ? ShowDialogs.norecordwidget(
            // SizeConfig.blockSizeHorizontal * 30,
            // vishu 13 aug 24
            0.0,
            SizeConfig.blockSizeVertical * 30)
        : CustomRefreshIndicator(
            // key: refreshIndicatorKey,
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
                              ? controller.value.clamp(0.0, 1.0)
                              : null,
                        ),
                      ),
                    ),
                  Transform.translate(
                    offset: Offset(0, 100.0 * controller.value),
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
                GlobalLists.operationalmainlisttab.length > 0
                    ? Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: Container(
                          height: 25,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            //25june
                            // shrinkWrap: true,
                            physics: ScrollPhysics(),
                            children: _buildChoicemainopertaionalList(),
                          ),
                        )

                        // Wrap(
                        //    spacing: 5.0,
                        //    runSpacing: 3.0,
                        //    children: _buildChoicemainList(),
                        //  ),
                        )
                    : Container(),
                //  GlobalLists.mainlisttabs[GlobalLists.maintag].details.length>0?Container():
//wait
                opertaionmanagermodule(),
              ],
            ),
          );
  }

  //tab
  _buildChoicemainList() {
    List<Widget> choices = [];
    GlobalLists.mainlisttabs.forEachIndexed((item, value) {
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
                    color: GlobalLists.maintag == value
                        ? customcolor.white
                        : item.pendingstatus == 0
                            ? customcolor.red
                            : customcolor.green,
                    fontWeight: FontWeight.bold),
              ),
            ),
            side: BorderSide(
                width: 0.5,
                color: GlobalLists.maintag == value
                    ? customcolor.white
                    : item.pendingstatus == 0
                        ? customcolor.red
                        : customcolor.green),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10))),
            labelStyle: AppFonts.headerStyle(
                fontSize: 12,
                color: GlobalLists.maintag == value
                    ? customcolor.blue
                    : customcolor.greytext,
                fontWeight: FontWeight.bold),
            selectedColor: customcolor.tabblue,
            backgroundColor: customcolor.white,
            selected: GlobalLists.maintag == value,
            onSelected: (selected) {
              setState(() {
                _isSelected = item.clientName;
                GlobalLists.maintag = value;
                tag = 0;
                GlobalLists.tabsmain = <Tab>[];
                //initialIndex: 1
                //  int selectedvalue =  GlobalLists.mainlisttabs[GlobalLists.maintag].details.indexWhere((item) => item.id.toString() == GlobalLists.mainlisttabs[GlobalLists.maintag].masterArea[tabindexmain].id.toString());
                // _tabController = new TabController(vsync: this, length: 1);
                GlobalLists.selectedindex = 0;
                for (int i = 0;
                    i <
                        GlobalLists
                            .mainlisttabs[GlobalLists.maintag].details.length;
                    i++) {
                  GlobalLists.tabsmain.add(
                    // new Tab(
                    //  text: "${GlobalLists.mainlisttabs[GlobalLists.maintag].details[i].startTimeStr}-${GlobalLists.mainlisttabs[GlobalLists.maintag].details[i].endTimeStr}",

                    // ),
                    Tab(
                      child: Text(
                        "${GlobalLists.mainlisttabs[GlobalLists.maintag].details[i].startTimeStr}-${GlobalLists.mainlisttabs[GlobalLists.maintag].details[i].endTimeStr}",
                        style: TextStyle(
                            color: GlobalLists.mainlisttabs[GlobalLists.maintag]
                                        .details[i].status ==
                                    "Pending"
                                ? customcolor.red
                                : GlobalLists.mainlisttabs[GlobalLists.maintag]
                                            .details[i].status ==
                                        "Completed"
                                    ? customcolor.green
                                    : customcolor.blue),
                      ),
                    ),
                  );
                  GlobalLists.card_startcurrentdatevalue = GlobalLists
                      .mainlisttabs[GlobalLists.maintag]
                      .details[GlobalLists.selectedindex]
                      .startTimeStr
                      .toString();
                  GlobalLists.card_endcurrentdatevalue = GlobalLists
                      .mainlisttabs[GlobalLists.maintag]
                      .details[GlobalLists.selectedindex]
                      .endTimeStr
                      .toString();
                  GlobalLists.card_superviorfirtvalue = GlobalLists
                      .mainlisttabs[GlobalLists.maintag]
                      .details[GlobalLists.selectedindex]
                      .supervisorName
                      .toString();
                  GlobalLists.card_percentvalue = GlobalLists
                      .mainlisttabs[GlobalLists.maintag].totalPercentage
                      .toString();
                  print("selectedindextag");
                }
                for (int i = 0;
                    i <
                        GlobalLists
                            .mainlisttabs[GlobalLists.maintag].details.length;
                    i++) {
                  if (GlobalLists.mainlisttabs[GlobalLists.maintag].details[i]
                              .currentTime ==
                          true &&
                      GlobalLists.mainlisttabs[GlobalLists.maintag].details[i]
                              .priority_status ==
                          1) {
                    print("selectedindextagselect");
                    GlobalLists.selectedindex = i;
                    print(GlobalLists.selectedindex);
                    GlobalLists.card_startcurrentdatevalue = GlobalLists
                        .mainlisttabs[GlobalLists.maintag]
                        .details[i]
                        .startTimeStr
                        .toString();
                    GlobalLists.card_endcurrentdatevalue = GlobalLists
                        .mainlisttabs[GlobalLists.maintag].details[i].endTimeStr
                        .toString();
                    GlobalLists.card_superviorfirtvalue = GlobalLists
                        .mainlisttabs[GlobalLists.maintag]
                        .details[i]
                        .supervisorName
                        .toString();
                    GlobalLists.card_percentvalue = GlobalLists
                        .mainlisttabs[GlobalLists.maintag].totalPercentage
                        .toString();
                    break;
                  } else if (GlobalLists.mainlisttabs[GlobalLists.maintag]
                          .details[i].currentTime ==
                      true) {
                    print("selectedindextagselect");
                    GlobalLists.selectedindex = i;
                    print(GlobalLists.selectedindex);
                    GlobalLists.card_startcurrentdatevalue = GlobalLists
                        .mainlisttabs[GlobalLists.maintag]
                        .details[i]
                        .startTimeStr
                        .toString();
                    GlobalLists.card_endcurrentdatevalue = GlobalLists
                        .mainlisttabs[GlobalLists.maintag].details[i].endTimeStr
                        .toString();
                    GlobalLists.card_superviorfirtvalue = GlobalLists
                        .mainlisttabs[GlobalLists.maintag]
                        .details[i]
                        .supervisorName
                        .toString();
                    GlobalLists.card_percentvalue = GlobalLists
                        .mainlisttabs[GlobalLists.maintag].totalPercentage
                        .toString();
                    break;
                  }
                }
                print("selectedindextagselect1");
                print(GlobalLists.selectedindex);
                GlobalLists.tabControllermain = new TabController(
                    vsync: this,
                    length: GlobalLists
                        .mainlisttabs[GlobalLists.maintag].details.length,
                    initialIndex: GlobalLists.selectedindex);
                widget.clientname = item.clientName;
                print(GlobalLists.tabControllermain.length);
              });
            },
          ),
        ),
      ));
    });
    return choices;
  }

  _buildChoicemainopertaionalList() {
    List<Widget> choices = [];

    GlobalLists.operationalmainlisttab.forEachIndexed((item, value) {
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
                    color: GlobalLists.maintag == value
                        ? customcolor.white
                        : item.pendingstatus == 0
                            ? customcolor.red
                            : customcolor.green,
                    fontWeight: FontWeight.bold),
              ),
            ),
            side: BorderSide(
                width: 0.5,
                color: GlobalLists.maintag == value
                    ? customcolor.white
                    : item.pendingstatus == 0
                        ? customcolor.red
                        : customcolor.green),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10))),
            labelStyle: AppFonts.headerStyle(
                fontSize: 12,
                color: GlobalLists.maintag == value
                    ? customcolor.blue
                    : customcolor.greytext,
                fontWeight: FontWeight.bold),
            selectedColor: customcolor.tabblue,
            backgroundColor: customcolor.white,
            selected: GlobalLists.maintag == value,
            onSelected: (selected) {
              setState(() {
                _isSelected = item.clientName;
                GlobalLists.maintag = value;
                tag = 0;
                GlobalLists.tabsmain = <Tab>[];
                //initialIndex: 1

                //  int selectedvalue =  GlobalLists.mainlisttabs[GlobalLists.maintag].details.indexWhere((item) => item.id.toString() == GlobalLists.mainlisttabs[GlobalLists.maintag].masterArea[tabindexmain].id.toString());

                // _tabController = new TabController(vsync: this, length: 1);
                GlobalLists.selectedindex = 0;

                operationlManagerdetailworkflowstatusApi(
                    item.clientId.toString(), item.siteId.toString());
              });
            },
          ),
        ),
      ));
    });
    return choices;
  }

  Widget _buildChoicemainopertaionalListForTab() {
    final selectedItem =
        GlobalLists.maintag < GlobalLists.operationalmainlisttab.length
            ? GlobalLists.operationalmainlisttab[GlobalLists.maintag]
            : null;

    return Row(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () async {
            TextEditingController searchController = TextEditingController();
            List filteredList = List.from(GlobalLists.operationalmainlisttab);

            await showDialog(
              context: context,
              builder: (_) {
                return StatefulBuilder(
                  builder: (context, setStateDialog) => Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      constraints: BoxConstraints(maxHeight: 500),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: TextField(
                              controller: searchController,
                              decoration: InputDecoration(
                                hintText: "Search Client...",
                                prefixIcon: Icon(Icons.search),
                                suffixIcon: searchController.text.isNotEmpty
                                    ? IconButton(
                                        icon: Icon(Icons.cancel_outlined),
                                        onPressed: () {
                                          searchController.clear();
                                          setStateDialog(() {
                                            filteredList = List.from(
                                                GlobalLists.mainlisttabs);
                                          });
                                        },
                                      )
                                    : null,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onChanged: (query) {
                                setStateDialog(() {
                                  filteredList = GlobalLists
                                      .operationalmainlisttab
                                      .where((item) => item.clientName
                                          .toLowerCase()
                                          .contains(query.toLowerCase()))
                                      .toList();
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: filteredList.isEmpty
                                ? Center(
                                    child: Text(
                                      "No client found.",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    itemCount: filteredList.length,
                                    itemBuilder: (context, index) {
                                      final item = filteredList[index];
                                      final isSelected = item == selectedItem;
                                      final color = isSelected
                                          ? customcolor.tabblue
                                          : item.pendingstatus == 0
                                              ? customcolor.red
                                              : customcolor.green;

                                      return ListTile(
                                        title: Text(
                                          item.clientName,
                                          style: AppFonts.headerStyle(
                                            fontSize: 14,
                                            color: color,
                                            fontWeight: isSelected
                                                ? FontWeight.bold
                                                : FontWeight.w500,
                                          ),
                                        ),
                                        trailing: isSelected
                                            ? Icon(Icons.check_circle,
                                                color: customcolor.tabblue,
                                                size: 18)
                                            : null,
                                        onTap: () {
                                          Navigator.pop(context);
                                          final value = GlobalLists
                                              .operationalmainlisttab
                                              .indexOf(item);

                                          setState(() {
                                            _isSelected = item.clientName;
                                            GlobalLists.maintag = value;
                                            tag = 0;
                                            GlobalLists.tabsmain = <Tab>[];
                                            GlobalLists.selectedindex = 0;

                                            operationlManagerdetailworkflowstatusApi(
                                              item.clientId.toString(),
                                              item.siteId.toString(),
                                            );
                                          });
                                        },
                                      );
                                    },
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
          child: Align(
            alignment: Alignment.center,
            child: Container(
              width: 50,
              decoration: BoxDecoration(
                color: customcolor.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: customcolor.white, width: 1.2),
              ),
              child: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: customcolor.tabblue,
                size: 24,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget supervisormodule() {
    return GlobalLists.workflowstatuslist.length == 0
        ? Container()
        : CustomRefreshIndicator(
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
                              ? controller.value.clamp(0.0, 1.0)
                              : null,
                        ),
                      ),
                    ),
                  Transform.translate(
                    offset: Offset(0, 100.0 * controller.value),
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
                Container(
                  height: SizeConfig.blockSizeVertical * 80,
                  //to make half scroll replace 100 with 63
                  decoration: BoxDecoration(
                    // color: Colors.blue,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: customcolor.greyborder,
                      width: 0.4,
                    ),
                  ),

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 30,
                        child: ButtonsTabBar(
                          labelStyle: AppFonts.headerStyle(
                              fontSize: 12,
                              color:
                                  //  GlobalLists.workflowstatuslist[GlobalLists.selectedindex].status=="Pending"?
                                  // customcolor.red:
                                  customcolor.blue,
                              fontWeight: FontWeight.normal),
                          unselectedLabelStyle: AppFonts.headerStyle(
                              fontSize: 12,
                              color:
                                  // GlobalLists.workflowstatuslist[GlobalLists.selectedindex].status=="Pending"?customcolor.red:
                                  customcolor.greytext,
                              fontWeight: FontWeight.normal),

                          height: 150,

                          onTap: (val) {
                            setState(() {
                              print("ontap");
                              print(val.toString());
                              GlobalLists.selectedindex = val; //20feb
                              //checksupervisorissuehere
                              tag = 0;
                              GlobalLists.card_startcurrentdatevalue =
                                  GlobalLists
                                      .workflowstatuslist[
                                          GlobalLists.selectedindex]
                                      .startTime;
                              GlobalLists.card_endcurrentdatevalue = GlobalLists
                                  .workflowstatuslist[GlobalLists.selectedindex]
                                  .endTime;
                              GlobalLists.card_superviorfirtvalue =
                                  "${GlobalLists.workflowstatuslist[GlobalLists.selectedindex].clientName} - ${GlobalLists.workflowstatuslist[GlobalLists.selectedindex].siteName}";
                              GlobalLists.card_percentvalue = GlobalLists
                                  .total_supervisorercentage; //GlobalLists.workflowstatuslist[GlobalLists.selectedindex].percentage.toString();
                              print("pretest");
                              print("val.toString()");
                            });
                          },

                          //   indicator:
                          // //  GlobalLists.tabControllermain.index==GlobalLists.selectedindex?
                          decoration: BoxDecoration(
                              color: customcolor.skyblue.withOpacity(0.9),
                              //12dec
                              //  customcolor.blue.withOpacity(0.2),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))
                              //  BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight:Radius.circular(10) )
                              ),
                          unselectedDecoration: BoxDecoration(
                              color: customcolor.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))
                              // borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight:Radius.circular(10) )
                              ),

                          tabs: GlobalLists.tabsmain,

                          controller: GlobalLists.tabControllermain,
                        ),
                      ),
                      isdataloaded
                          ? Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Stack(
                                children: [
                                  Padding(
                                      padding: EdgeInsets.only(
                                        right: 0.0,
                                        left: 0.0,
                                        top: 15,
                                        bottom: 4,
                                      ),
                                      child: GestureDetector(
                                        onTap: () {},
                                        child: IntrinsicHeight(
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Material(
                                                elevation: 2,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: Container(
                                                    width: SizeConfig
                                                            .blockSizeHorizontal *
                                                        60,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "${GlobalLists.card_startcurrentdatevalue}-${GlobalLists.card_endcurrentdatevalue}",
                                                          // "${GlobalLists.mainlisttabs[GlobalLists.maintag].details[GlobalLists.selectedindex].startTimeStr} - ${GlobalLists.mainlisttabs[GlobalLists.maintag].details[GlobalLists.selectedindex].endTimeStr}",
                                                          maxLines: 2,
                                                          textAlign:
                                                              TextAlign.start,
                                                          overflow: TextOverflow
                                                              .ellipsis,

                                                          style: AppFonts.headerStyle(
                                                              fontSize:
                                                                  ResponsiveFlutter
                                                                          .of(
                                                                              context)
                                                                      .fontSize(
                                                                          2.2),
                                                              color: customcolor
                                                                  .blue,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Text(
                                                          "${GlobalLists.card_superviorfirtvalue}",
                                                          maxLines: 2,
                                                          textAlign:
                                                              TextAlign.start,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: AppFonts.headerStyle(
                                                              fontSize:
                                                                  ResponsiveFlutter.of(
                                                                          context)
                                                                      .fontSize(
                                                                          1.6),
                                                              color: customcolor
                                                                  .black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Expanded(
                                                child: Material(
                                                  elevation: 2,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: Padding(
                                                    padding: EdgeInsets.symmetric(
                                                        vertical: SizeConfig
                                                                .blockSizeHorizontal *
                                                            1.5),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          // color: customcolor.appbarcolor,
                                                          child:
                                                              CircularPercentIndicator(
                                                            animationDuration:
                                                                500,
                                                            //   radius: 35.0,
                                                            lineWidth: 4.0,
                                                            radius: 34.0,
                                                            //   lineWidth: 5.0,
                                                            animation: true,
                                                            percent:
                                                                //0.0,
                                                                //double.parse(GlobalLists.card_percentvalue)>100.0?0.0:double.parse(GlobalLists.card_percentvalue)/100,
                                                                // GlobalLists.card_percentvalue=="101.0"? 0.0:
                                                                double.parse(GlobalLists
                                                                            .card_percentvalue) >
                                                                        100.0
                                                                    ? 0.0
                                                                    : double.parse(
                                                                            GlobalLists.card_percentvalue) /
                                                                        100,
                                                            //  GlobalLists.mainlisttabs[GlobalLists.maintag].details[GlobalLists.selectedindex].percentage>100.0?0.0: GlobalLists.mainlisttabs[GlobalLists.maintag].details[GlobalLists.selectedindex].percentage/100,
                                                            center: new Text(
                                                              // "",
                                                              GlobalLists.card_percentvalue ==
                                                                      "101.0"
                                                                  ? 'NA'
                                                                  : "${double.parse(GlobalLists.card_percentvalue).toStringAsFixed(0)}%",
                                                              //  "${GlobalLists.mainlisttabs[GlobalLists.maintag].details[GlobalLists.selectedindex].percentage.toStringAsFixed(0)}%",
                                                              style: AppFonts.headerStyle(
                                                                  fontSize: 15,
                                                                  color:
                                                                      customcolor
                                                                          .yellow,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),

                                                            circularStrokeCap:
                                                                CircularStrokeCap
                                                                    .round,
                                                            progressColor:
                                                                customcolor
                                                                    .blue,
                                                          ),
                                                        ),
                                                        /* (role ==
                                                            GlobalLists
                                                                .headrole ||
                                                            role ==
                                                                GlobalLists
                                                                    .reginalmanagerrole ||
                                                            role ==
                                                                GlobalLists
                                                                    .clientrole ||
                                                            role ==
                                                                GlobalLists
                                                                    .operationrole ||
                                                            role ==
                                                                GlobalLists
                                                                    .operationmanagerrole)
                                                            ? SizedBox(
                                                          height: 0,
                                                        )
                                                            : SizedBox(
                                                          height: 7,
                                                        ),
                                                        (role == GlobalLists.headrole ||
                                                            role ==  GlobalLists .reginalmanagerrole ||
                                                            role ==  GlobalLists  .clientrole ||
                                                            role ==  GlobalLists .operationrole ||
                                                            role ==  GlobalLists .operationmanagerrole)
                                                            ? Container()
                                                            : Text(
                                                          "${GlobalLists.mainlisttabs[GlobalLists.maintag].details[0].uncheckCount.toString()} Task Pending",
                                                          maxLines: 2,
                                                          textAlign:
                                                          TextAlign.start,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: AppFonts.headerStyle(
                                                              fontSize:
                                                              ResponsiveFlutter.of(
                                                                  context)
                                                                  .fontSize(
                                                                  2),
                                                              color: customcolor
                                                                  .appbarcolor,
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold),
                                                        ),*/
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        /* child: Material(
                                          elevation: 2,
                                          borderRadius: BorderRadius.circular(10),
                                          child: Container(
                                            width: SizeConfig.blockSizeHorizontal *  100,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(10.0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment:  MainAxisAlignment.start,
                                                children: [
                                                  // SizedBox(height: 20,),
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment .start,
                                                    mainAxisAlignment: MainAxisAlignment  .spaceBetween,
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.only(top: 10),
                                                        child: Container(
                                                          width: SizeConfig.blockSizeHorizontal *60,
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                "${GlobalLists.card_startcurrentdatevalue}-${GlobalLists.card_endcurrentdatevalue}",
                                                                //  "${GlobalLists.workflowstatuslist[GlobalLists.selectedindex].startTime} - ${GlobalLists.workflowstatuslist[GlobalLists.selectedindex].endTime}",
                                                                maxLines: 2,
                                                                textAlign:  TextAlign .start,
                                                                overflow: TextOverflow .ellipsis,
                                                                style: AppFonts.headerStyle(
                                                                    fontSize: ResponsiveFlutter.of(context).fontSize( 2.2),
                                                                    color: customcolor.blue,
                                                                    fontWeight:FontWeight.w600),
                                                              ),
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              Text(
                                                                "${GlobalLists.card_superviorfirtvalue}",
                                                                //"${GlobalLists.workflowstatuslist[GlobalLists.selectedindex].clientName} - ${GlobalLists.workflowstatuslist[GlobalLists.selectedindex].siteName}",
                                                                maxLines: 2,
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,

                                                                style: AppFonts.headerStyle(
                                                                    fontSize: ResponsiveFlutter.of(
                                                                            context)
                                                                        .fontSize(
                                                                            1.6),
                                                                    color: customcolor
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment .end,
                                                        mainAxisAlignment: MainAxisAlignment .start,
                                                        children: [
                                                          Container(
                                                            // color: customcolor.appbarcolor,
                                                            child:
                                                                CircularPercentIndicator( animationDuration: 500,
                                                              //   radius: 35.0,
                                                              lineWidth: 4.0,
                                                              radius: 34.0,
                                                              //   lineWidth: 5.0,
                                                              animation: true,
                                                              percent:
                                                                  // 0.0,
                                                                  double.parse(GlobalLists.card_percentvalue) >100.0 ? 0.0   : double.parse(GlobalLists.card_percentvalue) /  100,
                                                              //GlobalLists.workflowstatuslist[GlobalLists.selectedindex].percentage>100.0?0.0: GlobalLists.workflowstatuslist[GlobalLists.selectedindex].percentage/100,
                                                              center: new Text(
                                                                //"",
                                                                "${double.parse(GlobalLists.card_percentvalue).toStringAsFixed(0)}%",
                                                                //"${GlobalLists.workflowstatuslist[GlobalLists.selectedindex].percentage.toStringAsFixed(0)}%",
                                                                style: AppFonts.headerStyle(
                                                                    fontSize:
                                                                        15,
                                                                    color: customcolor
                                                                        .yellow,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),

                                                              circularStrokeCap:
                                                                  CircularStrokeCap
                                                                      .round,
                                                              progressColor:
                                                                  customcolor
                                                                      .textblue,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),

                                                  // Container(
                                                  //   height: 5,
                                                  // ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),*/
                                      )),

                                  //
                                ],
                              ),
                            )
                          : Container(),
                      //  StatefulBuilder(builder: (thisLowerContext, innerSetState) {
                      Expanded(
                        flex: 3,
                        child: TabBarView(
                          physics: ScrollPhysics(),
                          controller: GlobalLists.tabControllermain,
                          children: List.generate(GlobalLists.tabsmain.length,
                              (tabindexmain) {
                            //15feb
                            return Column(
                              // shrinkWrap: true,
                              // physics: ScrollPhysics(),
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  height: SizeConfig.blockSizeVertical * 55,
                                  child: masterarea(tabindexmain),
                                )
                              ],
                            );
                          }),
                        ),
                      )
                      //  }
                      //   ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }

  //unitmodule
  Widget opertaionmodule() {
    return ListView(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      children: [
        Container(
          height: SizeConfig.blockSizeVertical * 100,
          //to make half scroll replace 100 with 63
          decoration: BoxDecoration(
            //color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: customcolor.greyborder,
              width: 0.4,
            ),
          ),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 30,
                child: ButtonsTabBar(
                  labelStyle: AppFonts.headerStyle(
                      fontSize: 12,
                      color:
                          //   GlobalLists.mainlisttabs[GlobalLists.maintag].details[GlobalLists.selectedindex].status=="Pending"? customcolor.red:
                          customcolor.blue,
                      fontWeight: FontWeight.normal),
                  unselectedLabelStyle: AppFonts.headerStyle(
                      fontSize: 12,
                      color:
                          //   GlobalLists.mainlisttabs[GlobalLists.maintag].details[GlobalLists.selectedindex].status=="Pending"? customcolor.red:
                          customcolor.greytext,
                      fontWeight: FontWeight.normal),

                  height: 150,

                  onTap: (val) {
                    setState(() {
                      print("ontap");
                      print(val.toString());
                      GlobalLists.selectedindex = val; //21feb
                      tag = 0;
                      print("ontaptag");
                      print(tag);
                      GlobalLists.card_startcurrentdatevalue = GlobalLists
                          .mainlisttabs[GlobalLists.maintag]
                          .details[GlobalLists.selectedindex]
                          .startTimeStr
                          .toString();
                      GlobalLists.card_endcurrentdatevalue = GlobalLists
                          .mainlisttabs[GlobalLists.maintag]
                          .details[GlobalLists.selectedindex]
                          .endTimeStr
                          .toString();
                      GlobalLists.card_superviorfirtvalue = GlobalLists
                          .mainlisttabs[GlobalLists.maintag]
                          .details[GlobalLists.selectedindex]
                          .supervisorName
                          .toString();
                      GlobalLists.card_percentvalue = GlobalLists
                          .mainlisttabs[GlobalLists.maintag].totalPercentage
                          .toString();
                    });
                  },

                  //   indicator:
                  // //  GlobalLists.tabControllermain.index==GlobalLists.selectedindex?
                  decoration: BoxDecoration(
                      // border: Border.all(color:
                      //GlobalLists.mainlisttabs[GlobalLists.maintag].details[GlobalLists.selectedindex].status=="Pending"?
                      //  customcolor.red
                      //:customcolor.bg
                      //),
                      color: customcolor.skyblue.withOpacity(0.9),
                      //12dec
                      //  GlobalLists.mainlisttabs[GlobalLists.maintag].details[GlobalLists.selectedindex].status=="Pending"? customcolor.red:
                      // customcolor.blue.withOpacity(0.2),
                      // border: Border.all(color:  customcolor.red,),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      )
                      //  BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight:Radius.circular(10) )
                      ),
                  unselectedDecoration: BoxDecoration(
                      color: customcolor.white,
                      borderRadius: BorderRadius.all(Radius.circular(10))
                      // borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight:Radius.circular(10) )
                      ),

                  tabs: GlobalLists.tabsmain,

                  controller: GlobalLists.tabControllermain,
                ),
              ),
              isdataloaded
                  ? Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Stack(
                        children: [
                          Padding(
                              padding: EdgeInsets.only(
                                right: 0.0,
                                left: 0.0,
                                top: 15,
                                bottom: 4,
                              ),
                              child: GestureDetector(
                                onTap: () {},
                                child: IntrinsicHeight(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Material(
                                        elevation: 2,
                                        borderRadius: BorderRadius.circular(10),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Container(
                                            width:
                                                SizeConfig.blockSizeHorizontal *
                                                    60,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "${GlobalLists.card_startcurrentdatevalue}-${GlobalLists.card_endcurrentdatevalue}",
                                                  // "${GlobalLists.mainlisttabs[GlobalLists.maintag].details[GlobalLists.selectedindex].startTimeStr} - ${GlobalLists.mainlisttabs[GlobalLists.maintag].details[GlobalLists.selectedindex].endTimeStr}",
                                                  maxLines: 2,
                                                  textAlign: TextAlign.start,
                                                  overflow:
                                                      TextOverflow.ellipsis,

                                                  style: AppFonts.headerStyle(
                                                      fontSize:
                                                          ResponsiveFlutter.of(
                                                                  context)
                                                              .fontSize(2.2),
                                                      color: customcolor.blue,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                (role == GlobalLists.headrole ||
                                                        role ==
                                                            GlobalLists
                                                                .reginalmanagerrole ||
                                                        role ==
                                                            GlobalLists
                                                                .clientrole ||
                                                        role ==
                                                            GlobalLists
                                                                .operationrole ||
                                                        role ==
                                                            GlobalLists
                                                                .operationmanagerrole)
                                                    ? Text(
                                                        "${GlobalLists.card_superviorfirtvalue}",
                                                        //  "${GlobalLists.mainlisttabs[GlobalLists.maintag].details[GlobalLists.selectedindex].supervisorName}",
                                                        maxLines: 2,
                                                        textAlign:
                                                            TextAlign.start,
                                                        overflow: TextOverflow
                                                            .ellipsis,

                                                        style: AppFonts.headerStyle(
                                                            fontSize:
                                                                ResponsiveFlutter.of(
                                                                        context)
                                                                    .fontSize(
                                                                        2.2),
                                                            color: customcolor
                                                                .black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      )
                                                    : Container(),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Expanded(
                                        child: Material(
                                          elevation: 2,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: SizeConfig
                                                        .blockSizeHorizontal *
                                                    1.5),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  // color: customcolor.appbarcolor,
                                                  child:
                                                      CircularPercentIndicator(
                                                    animationDuration: 500,
                                                    //   radius: 35.0,
                                                    lineWidth: 4.0,
                                                    radius: 34.0,
                                                    //   lineWidth: 5.0,
                                                    animation: true,
                                                    percent:
                                                        //0.0,
                                                        //double.parse(GlobalLists.card_percentvalue)>100.0?0.0:double.parse(GlobalLists.card_percentvalue)/100,
                                                        GlobalLists.card_percentvalue ==
                                                                "101.0"
                                                            ? 0.0
                                                            : double.parse(GlobalLists
                                                                        .card_percentvalue) >
                                                                    100.0
                                                                ? 0.0
                                                                : double.parse(
                                                                        GlobalLists
                                                                            .card_percentvalue) /
                                                                    100,
                                                    //  GlobalLists.mainlisttabs[GlobalLists.maintag].details[GlobalLists.selectedindex].percentage>100.0?0.0: GlobalLists.mainlisttabs[GlobalLists.maintag].details[GlobalLists.selectedindex].percentage/100,
                                                    center: new Text(
                                                      // "",
                                                      GlobalLists.card_percentvalue ==
                                                              "101.0"
                                                          ? 'NA'
                                                          : "${double.parse(GlobalLists.card_percentvalue).toStringAsFixed(0)}%",
                                                      //  "${GlobalLists.mainlisttabs[GlobalLists.maintag].details[GlobalLists.selectedindex].percentage.toStringAsFixed(0)}%",
                                                      style:
                                                          AppFonts.headerStyle(
                                                              fontSize: 15,
                                                              color: customcolor
                                                                  .yellow,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                    ),

                                                    circularStrokeCap:
                                                        CircularStrokeCap.round,
                                                    progressColor:
                                                        customcolor.blue,
                                                  ),
                                                ),
                                                (role == GlobalLists.headrole ||
                                                        role ==
                                                            GlobalLists
                                                                .reginalmanagerrole ||
                                                        role ==
                                                            GlobalLists
                                                                .clientrole ||
                                                        role ==
                                                            GlobalLists
                                                                .operationrole ||
                                                        role ==
                                                            GlobalLists
                                                                .operationmanagerrole)
                                                    ? SizedBox(
                                                        height: 0,
                                                      )
                                                    : SizedBox(
                                                        height: 7,
                                                      ),
                                                (role == GlobalLists.headrole ||
                                                        role ==
                                                            GlobalLists
                                                                .reginalmanagerrole ||
                                                        role ==
                                                            GlobalLists
                                                                .clientrole ||
                                                        role ==
                                                            GlobalLists
                                                                .operationrole ||
                                                        role ==
                                                            GlobalLists
                                                                .operationmanagerrole)
                                                    ? Container()
                                                    : Text(
                                                        "${GlobalLists.mainlisttabs[GlobalLists.maintag].details[0].uncheckCount.toString()} Task Pending",
                                                        maxLines: 2,
                                                        textAlign:
                                                            TextAlign.start,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: AppFonts.headerStyle(
                                                            fontSize:
                                                                ResponsiveFlutter.of(
                                                                        context)
                                                                    .fontSize(
                                                                        2),
                                                            color: customcolor
                                                                .appbarcolor,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                //
                                /*child: Material(
                                  elevation: 2,
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    width: SizeConfig.blockSizeHorizontal * 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          // SizedBox(height: 20,),
                                          Row(
                                            crossAxisAlignment:  CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10),
                                                child: Container(
                                                  width: SizeConfig
                                                          .blockSizeHorizontal *
                                                      50,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        "${GlobalLists.card_startcurrentdatevalue}-${GlobalLists.card_endcurrentdatevalue}",
                                                        // "${GlobalLists.mainlisttabs[GlobalLists.maintag].details[GlobalLists.selectedindex].startTimeStr} - ${GlobalLists.mainlisttabs[GlobalLists.maintag].details[GlobalLists.selectedindex].endTimeStr}",
                                                        maxLines: 2,
                                                        textAlign:
                                                            TextAlign.start,
                                                        overflow: TextOverflow
                                                            .ellipsis,

                                                        style: AppFonts.headerStyle(
                                                            fontSize:
                                                                ResponsiveFlutter.of(
                                                                        context)
                                                                    .fontSize(
                                                                        2.2),
                                                            color: customcolor
                                                                .blue,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      (role ==
                                                                  GlobalLists
                                                                      .headrole ||
                                                              role ==
                                                                  GlobalLists
                                                                      .reginalmanagerrole ||
                                                              role ==
                                                                  GlobalLists
                                                                      .clientrole ||
                                                              role ==
                                                                  GlobalLists
                                                                      .operationrole ||
                                                              role ==
                                                                  GlobalLists
                                                                      .operationmanagerrole)
                                                          ? Text(
                                                              "$GlobalLists.card_superviorfirtvalue",
                                                              //  "${GlobalLists.mainlisttabs[GlobalLists.maintag].details[GlobalLists.selectedindex].supervisorName}",
                                                              maxLines: 2,
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,

                                                              style: AppFonts.headerStyle(
                                                                  fontSize: ResponsiveFlutter.of(
                                                                          context)
                                                                      .fontSize(
                                                                          2.2),
                                                                  color:
                                                                      customcolor
                                                                          .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                            )
                                                          : Container(),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    // color: customcolor.appbarcolor,
                                                    child:
                                                        CircularPercentIndicator(
                                                      animationDuration: 500,
                                                      //   radius: 35.0,
                                                      lineWidth: 4.0,
                                                      radius: 34.0,
                                                      //   lineWidth: 5.0,
                                                      animation: true,
                                                      percent:
                                                          //0.0,
                                                          //double.parse(GlobalLists.card_percentvalue)>100.0?0.0:double.parse(GlobalLists.card_percentvalue)/100,
                                                      GlobalLists.card_percentvalue=="101.0"? 0.0:
                                                          double.parse(  GlobalLists.card_percentvalue) > 100.0 ? 0.0 : double.parse( GlobalLists.card_percentvalue) / 100,
                                                      //  GlobalLists.mainlisttabs[GlobalLists.maintag].details[GlobalLists.selectedindex].percentage>100.0?0.0: GlobalLists.mainlisttabs[GlobalLists.maintag].details[GlobalLists.selectedindex].percentage/100,
                                                      center: new Text(
                                                        // "",
                                                        GlobalLists.card_percentvalue=="101.0"? 'NA':
                                                        "${double.parse(GlobalLists.card_percentvalue).toStringAsFixed(0)}%",
                                                        //  "${GlobalLists.mainlisttabs[GlobalLists.maintag].details[GlobalLists.selectedindex].percentage.toStringAsFixed(0)}%",
                                                        style: AppFonts
                                                            .headerStyle(
                                                                fontSize: 15,
                                                                color:
                                                                    customcolor
                                                                        .yellow,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                      ),

                                                      circularStrokeCap:
                                                          CircularStrokeCap
                                                              .round,
                                                      progressColor:
                                                          customcolor.blue,
                                                    ),
                                                  ),
                                                  (role ==
                                                              GlobalLists
                                                                  .headrole ||
                                                          role ==
                                                              GlobalLists
                                                                  .reginalmanagerrole ||
                                                          role ==
                                                              GlobalLists
                                                                  .clientrole ||
                                                          role ==
                                                              GlobalLists
                                                                  .operationrole ||
                                                          role ==
                                                              GlobalLists
                                                                  .operationmanagerrole)
                                                      ? SizedBox(
                                                          height: 0,
                                                        )
                                                      : SizedBox(
                                                          height: 7,
                                                        ),
                                                  (role ==
                                                              GlobalLists
                                                                  .headrole ||
                                                          role ==
                                                              GlobalLists
                                                                  .reginalmanagerrole ||
                                                          role ==
                                                              GlobalLists
                                                                  .clientrole ||
                                                          role ==
                                                              GlobalLists
                                                                  .operationrole ||
                                                          role ==
                                                              GlobalLists
                                                                  .operationmanagerrole)
                                                      ? Container()
                                                      : Text(
                                                          "${GlobalLists.mainlisttabs[GlobalLists.maintag].details[0].uncheckCount.toString()} Task Pending",
                                                          maxLines: 2,
                                                          textAlign:
                                                              TextAlign.start,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: AppFonts.headerStyle(
                                                              fontSize:
                                                                  ResponsiveFlutter.of(
                                                                          context)
                                                                      .fontSize(
                                                                          2),
                                                              color: customcolor
                                                                  .appbarcolor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                ],
                                              ),
                                            ],
                                          ),

                                          // Container(
                                          //   height: 5,
                                          // ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),*/
                              )),
                          //
                        ],
                      ),
                    )
                  : Container(),
              //  StatefulBuilder(builder: (thisLowerContext, innerSetState) {
              Expanded(
                flex: 3,
                child: TabBarView(
                  physics: ScrollPhysics(),
                  controller: GlobalLists.tabControllermain,
                  children: List.generate(GlobalLists.tabsmain.length,
                      (tabindexmain) {
                    // setState(() {
                    // tag=0;
                    // });
                    return Column(
                      //  shrinkWrap: true,
                      //  physics: ScrollPhysics(),
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        // Container()
                        //7dec
                        Container(
                            height: SizeConfig.blockSizeVertical * 55,
                            child: Padding(
                                padding: const EdgeInsets.only(bottom: 85),
                                child: operationmasterarea(tabindexmain)))
                      ],
                    );
                  }),
                ),
              )
              //  }
              //   ),
            ],
          ),
        ),
      ],
    );
  }

  void scrollTabBar(int scrollAmount) {
    if (_scrollControllerbuttontab.hasClients) {
      final maxScrollExtent =
          _scrollControllerbuttontab.position.maxScrollExtent;
      final newPosition = _scrollControllerbuttontab.offset + scrollAmount;
      if (newPosition >= 0 && newPosition <= maxScrollExtent) {
        _scrollControllerbuttontab.animateTo(
          newPosition,
          duration: Duration(milliseconds: 300),
          curve: Curves.ease,
        );
      }
    }
  }

  // void _scrollToTab(int tabIndex) {
  //   print(tabIndex);
  //   final double tabWidth = MediaQuery.of(context).size.width / 10; // Total number of tabs
  //   final double targetOffset = tabIndex * tabWidth; // Calculate target offset based on tab index and tab width
  // print("PRASAD");
  // print(tabWidth);
  // print(targetOffset);
  // //int scrollTo = tabIndex * 100;
  //   GlobalLists.tabControllermain.animateTo(
  //    tabIndex,
  //     duration: Duration(milliseconds: 500), // Animation duration
  //     curve: Curves.easeInOut, // Animation curve
  //   );
  // }
  //new manager operation
  Widget opertaionmanagermodule() {
    return GlobalLists.tabsmain.length == 0
        ? ShowDialogs.norecordwidget(
            SizeConfig.blockSizeHorizontal * 30,
            // 0.0,
            SizeConfig.blockSizeVertical * 30)
        : ListView(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            controller: _scrollController,
            children: [
              //26june
              Container(
                  height: Platform.isAndroid
                      ? SizeConfig.blockSizeVertical * 64
                      : SizeConfig.blockSizeVertical * 60, //64
                  //to make half scroll replace 100 with 63
                  decoration: BoxDecoration(
                    //color: Colors.amber,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: customcolor.greybg,
                      width: 0.4,
                    ),
                  ),
                  child: newscroll()),
            ],
          );
  }

  newscroll() {
    return GlobalLists.detailopeermainlisttab.length == 0
        ? ShowDialogs.norecordwidget(
            // vishu 13 aug 24
            // SizeConfig.blockSizeHorizontal * 30,
            0.0,
            SizeConfig.blockSizeVertical * 30)
        : Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //wait1
              //1april
              Container(
                height: 30,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: _scrollControllerbuttontab,
                  child: ButtonsTabBar(
                    //ruchi12dec
                    // backgroundColor: customcolor.appbarcolor,
                    labelStyle: AppFonts.headerStyle(
                        fontSize: 12,
                        color:
                            //   GlobalLists.mainlisttabs[GlobalLists.maintag].details[GlobalLists.selectedindex].status=="Pending"? customcolor.red:
                            customcolor.blue,
                        fontWeight: FontWeight.normal),
                    unselectedLabelStyle: AppFonts.headerStyle(
                        fontSize: 12,
                        color:
                            //   GlobalLists.mainlisttabs[GlobalLists.maintag].details[GlobalLists.selectedindex].status=="Pending"? customcolor.red:
                            customcolor.greytext,
                        fontWeight: FontWeight.normal),

                    height: 150,

                    onTap: (val) {
                      setState(() {
                        print("ontap");
                        print(val.toString());
                        GlobalLists.selectedindex = val; //21feb
                        tag = 0;
                        print("ontaptag");
                        print(tag);
                        //26mar
                        GlobalLists.card_startcurrentdatevalue = GlobalLists
                            .detailopeermainlisttab[0]
                            .details[GlobalLists.selectedindex]
                            .startTimeStr
                            .toString();
                        GlobalLists.card_endcurrentdatevalue = GlobalLists
                            .detailopeermainlisttab[0]
                            .details[GlobalLists.selectedindex]
                            .endTimeStr
                            .toString();
                        GlobalLists.card_superviorfirtvalue = GlobalLists
                            .detailopeermainlisttab[0]
                            .details[GlobalLists.selectedindex]
                            .supervisorName
                            .toString();
                        GlobalLists.card_percentvalue = GlobalLists
                            .detailopeermainlisttab[0].totalPercentage
                            .toString();
                      });
                    },

                    decoration: BoxDecoration(
                        color: customcolor.skyblue.withOpacity(0.9),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        )),
                    unselectedDecoration: BoxDecoration(
                        color: customcolor.white,
                        borderRadius: BorderRadius.all(Radius.circular(10))),

                    tabs: GlobalLists.tabsmain,

                    controller: GlobalLists.tabControllermain,
                  ),
                ),
              ),
              //wait4
              isdataloaded
                  ? Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Stack(
                        children: [
                          Padding(
                              padding: EdgeInsets.only(
                                right: 0.0,
                                left: 0.0,
                                top: 15,
                                bottom: 4,
                              ),
                              child: GestureDetector(
                                onTap: () {},
                                child: IntrinsicHeight(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Material(
                                        elevation: 2,
                                        borderRadius: BorderRadius.circular(10),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Container(
                                            width:
                                                SizeConfig.blockSizeHorizontal *
                                                    60,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "${GlobalLists.card_startcurrentdatevalue}-${GlobalLists.card_endcurrentdatevalue}",
                                                  // "${GlobalLists.mainlisttabs[GlobalLists.maintag].details[GlobalLists.selectedindex].startTimeStr} - ${GlobalLists.mainlisttabs[GlobalLists.maintag].details[GlobalLists.selectedindex].endTimeStr}",
                                                  maxLines: 2,
                                                  textAlign: TextAlign.start,
                                                  overflow:
                                                      TextOverflow.ellipsis,

                                                  style: AppFonts.headerStyle(
                                                      fontSize:
                                                          ResponsiveFlutter.of(
                                                                  context)
                                                              .fontSize(2.2),
                                                      color: customcolor.blue,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                (role == GlobalLists.headrole ||
                                                        role ==
                                                            GlobalLists
                                                                .reginalmanagerrole ||
                                                        role ==
                                                            GlobalLists
                                                                .clientrole ||
                                                        role ==
                                                            GlobalLists
                                                                .operationrole ||
                                                        role ==
                                                            GlobalLists
                                                                .operationmanagerrole)
                                                    ? Text(
                                                        "${GlobalLists.card_superviorfirtvalue}",
                                                        //  "${GlobalLists.mainlisttabs[GlobalLists.maintag].details[GlobalLists.selectedindex].supervisorName}",
                                                        maxLines: 2,
                                                        textAlign:
                                                            TextAlign.start,
                                                        overflow: TextOverflow
                                                            .ellipsis,

                                                        style: AppFonts.headerStyle(
                                                            fontSize:
                                                                ResponsiveFlutter.of(
                                                                        context)
                                                                    .fontSize(
                                                                        2.2),
                                                            color: customcolor
                                                                .black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      )
                                                    : Container(),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Expanded(
                                        child: Material(
                                          elevation: 2,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: SizeConfig
                                                        .blockSizeHorizontal *
                                                    1.5),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  // color: customcolor.appbarcolor,
                                                  child:
                                                      CircularPercentIndicator(
                                                    animationDuration: 500,
                                                    //   radius: 35.0,
                                                    lineWidth: 4.0,
                                                    radius: 34.0,
                                                    //   lineWidth: 5.0,
                                                    animation: true,
                                                    percent:
                                                        //0.0,
                                                        //double.parse(GlobalLists.card_percentvalue)>100.0?0.0:double.parse(GlobalLists.card_percentvalue)/100,
                                                        // GlobalLists.card_percentvalue=="101.0"? 0.0:
                                                        double.parse(GlobalLists
                                                                    .card_percentvalue) >
                                                                100.0
                                                            ? 0.0
                                                            : double.parse(
                                                                    GlobalLists
                                                                        .card_percentvalue) /
                                                                100,
                                                    //  GlobalLists.mainlisttabs[GlobalLists.maintag].details[GlobalLists.selectedindex].percentage>100.0?0.0: GlobalLists.mainlisttabs[GlobalLists.maintag].details[GlobalLists.selectedindex].percentage/100,
                                                    center: new Text(
                                                      // "",
                                                      GlobalLists.card_percentvalue ==
                                                              "101.0"
                                                          ? 'NA'
                                                          : "${double.parse(GlobalLists.card_percentvalue).toStringAsFixed(0)}%",
                                                      //  "${GlobalLists.mainlisttabs[GlobalLists.maintag].details[GlobalLists.selectedindex].percentage.toStringAsFixed(0)}%",
                                                      style:
                                                          AppFonts.headerStyle(
                                                              fontSize: 15,
                                                              color: customcolor
                                                                  .yellow,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                    ),

                                                    circularStrokeCap:
                                                        CircularStrokeCap.round,
                                                    progressColor:
                                                        customcolor.blue,
                                                  ),
                                                ),
                                                (role == GlobalLists.headrole ||
                                                        role ==
                                                            GlobalLists
                                                                .reginalmanagerrole ||
                                                        role ==
                                                            GlobalLists
                                                                .clientrole ||
                                                        role ==
                                                            GlobalLists
                                                                .operationrole ||
                                                        role ==
                                                            GlobalLists
                                                                .operationmanagerrole)
                                                    ? SizedBox(
                                                        height: 0,
                                                      )
                                                    : SizedBox(
                                                        height: 7,
                                                      ),
                                                (role == GlobalLists.headrole ||
                                                        role ==
                                                            GlobalLists
                                                                .reginalmanagerrole ||
                                                        role ==
                                                            GlobalLists
                                                                .clientrole ||
                                                        role ==
                                                            GlobalLists
                                                                .operationrole ||
                                                        role ==
                                                            GlobalLists
                                                                .operationmanagerrole)
                                                    ? Container()
                                                    : Text(
                                                        "${GlobalLists.mainlisttabs[GlobalLists.maintag].details[0].uncheckCount.toString()} Task Pending",
                                                        maxLines: 2,
                                                        textAlign:
                                                            TextAlign.start,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: AppFonts.headerStyle(
                                                            fontSize:
                                                                ResponsiveFlutter.of(
                                                                        context)
                                                                    .fontSize(
                                                                        2),
                                                            color: customcolor
                                                                .appbarcolor,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                /*child: Material(
                                  elevation: 2,
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    width: SizeConfig.blockSizeHorizontal * 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          // SizedBox(height: 20,),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10),
                                                child: Container(
                                                  width: SizeConfig
                                                          .blockSizeHorizontal *
                                                      50,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        "${GlobalLists.card_startcurrentdatevalue}-${GlobalLists.card_endcurrentdatevalue}",
                                                        // "${GlobalLists.mainlisttabs[GlobalLists.maintag].details[GlobalLists.selectedindex].startTimeStr} - ${GlobalLists.mainlisttabs[GlobalLists.maintag].details[GlobalLists.selectedindex].endTimeStr}",
                                                        maxLines: 2,
                                                        textAlign:
                                                            TextAlign.start,
                                                        overflow: TextOverflow
                                                            .ellipsis,

                                                        style: AppFonts.headerStyle(
                                                            fontSize:
                                                                ResponsiveFlutter.of(
                                                                        context)
                                                                    .fontSize(
                                                                        2.2),
                                                            color: customcolor
                                                                .blue,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      (role ==  GlobalLists  .headrole ||
                                                              role ==  GlobalLists  .reginalmanagerrole ||
                                                              role ==  GlobalLists .clientrole ||
                                                              role == GlobalLists   .operationrole ||
                                                              role == GlobalLists .operationmanagerrole)
                                                          ? Text(
                                                              "$GlobalLists.card_superviorfirtvalue",
                                                              //  "${GlobalLists.mainlisttabs[GlobalLists.maintag].details[GlobalLists.selectedindex].supervisorName}",
                                                              maxLines: 2,
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,

                                                              style: AppFonts.headerStyle(
                                                                  fontSize: ResponsiveFlutter.of(
                                                                          context)
                                                                      .fontSize(
                                                                          2.2),
                                                                  color:
                                                                      customcolor
                                                                          .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                            )
                                                          : Container(),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    // color: customcolor.appbarcolor,
                                                    child:
                                                        CircularPercentIndicator(
                                                      animationDuration: 500,
                                                      //   radius: 35.0,
                                                      lineWidth: 4.0,
                                                      radius: 34.0,
                                                      //   lineWidth: 5.0,
                                                      animation: true,
                                                      percent:
                                                          //  0.0,
                                                          //double.parse(GlobalLists.card_percentvalue)>100.0?0.0:double.parse(GlobalLists.card_percentvalue)/100,
                                                      // GlobalLists.card_percentvalue=="101.0"? 0.0 :
                                                          double.parse(  GlobalLists.card_percentvalue) > 100.0 ? 0.0 : double.parse( GlobalLists.card_percentvalue) / 100,
                                                      //  GlobalLists.mainlisttabs[GlobalLists.maintag].details[GlobalLists.selectedindex].percentage>100.0?0.0: GlobalLists.mainlisttabs[GlobalLists.maintag].details[GlobalLists.selectedindex].percentage/100,
                                                      center: new Text(
                                                        // "",
                                                        // GlobalLists.card_percentvalue=="101.0"? 'NA':gb
                                                        "${double.parse(GlobalLists.card_percentvalue).toStringAsFixed(0)}%",
                                                        //  "${GlobalLists.mainlisttabs[GlobalLists.maintag].details[GlobalLists.selectedindex].percentage.toStringAsFixed(0)}%",
                                                        style: AppFonts
                                                            .headerStyle(
                                                                fontSize: 15,
                                                                color:
                                                                    customcolor
                                                                        .yellow,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                      ),

                                                      circularStrokeCap:
                                                          CircularStrokeCap
                                                              .round,
                                                      progressColor:
                                                          customcolor.blue,
                                                    ),
                                                  ),
                                                  (role ==
                                                              GlobalLists
                                                                  .headrole ||
                                                          role ==
                                                              GlobalLists
                                                                  .reginalmanagerrole ||
                                                          role ==
                                                              GlobalLists
                                                                  .clientrole ||
                                                          role ==
                                                              GlobalLists
                                                                  .operationrole ||
                                                          role ==
                                                              GlobalLists
                                                                  .operationmanagerrole)
                                                      ? SizedBox(
                                                          height: 0,
                                                        )
                                                      : SizedBox(
                                                          height: 7,
                                                        ),
                                                  (role ==
                                                              GlobalLists
                                                                  .headrole ||
                                                          role ==
                                                              GlobalLists
                                                                  .reginalmanagerrole ||
                                                          role ==
                                                              GlobalLists
                                                                  .clientrole ||
                                                          role ==
                                                              GlobalLists
                                                                  .operationrole ||
                                                          role ==
                                                              GlobalLists
                                                                  .operationmanagerrole)
                                                      ? Container()
                                                      : Text(
                                                          "${GlobalLists.mainlisttabs[GlobalLists.maintag].details[0].uncheckCount.toString()} Task Pending",
                                                          maxLines: 2,
                                                          textAlign:
                                                              TextAlign.start,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: AppFonts.headerStyle(
                                                              fontSize:
                                                                  ResponsiveFlutter.of(
                                                                          context)
                                                                      .fontSize(
                                                                          2),
                                                              color: customcolor
                                                                  .appbarcolor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                ],
                                              ),
                                            ],
                                          ),

                                          // Container(
                                          //   height: 5,
                                          // ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),*/
                              )),
                          //
                        ],
                      ),
                    )
                  : Container(),
              //  StatefulBuilder(builder: (thisLowerContext, innerSetState) {
              Expanded(
                flex: 3,
                child: TabBarView(
                  physics: ScrollPhysics(),
                  controller: GlobalLists.tabControllermain,
                  children: List.generate(GlobalLists.tabsmain.length,
                      (tabindexmain) {
                    // setState(() {
                    // tag=0;
                    // });
                    return Column(
                      //  shrinkWrap: true,
                      //  physics: ScrollPhysics(),
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        // Container()
                        //7dec
                        //26june
                        Container(
                            // color: customcolor.blue,
                            height: Platform.isAndroid
                                ? SizeConfig.blockSizeVertical * 42
                                : SizeConfig.blockSizeVertical * 40, //42
                            child:
                                //  Container(child: Text(" ${GlobalLists.tabsmain.length}"),)
                                //wait2
                                GlobalLists.detailopeermainlisttab.length == 0
                                    ? Container()
                                    : Padding(
                                        padding: EdgeInsets.only(bottom: 6),
                                        child: newoperationmasterarea(
                                            tabindexmain),
                                      ))
                      ],
                    );
                  }),
                ),
              )
              //  }
              //   ),
            ],
          );
  }
  // newscroll() {
  //   return GlobalLists.detailopeermainlisttab.length == 0
  //       ? ShowDialogs.norecordwidget(
  //           // vishu 13 aug 24
  //           // SizeConfig.blockSizeHorizontal * 30,
  //           0.0,
  //           SizeConfig.blockSizeVertical * 30)
  //       : Column(
  //           mainAxisAlignment: MainAxisAlignment.start,
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             //wait1
  //             //1april
  //             Container(
  //               height: 30,
  //               child: SingleChildScrollView(
  //                 scrollDirection: Axis.horizontal,
  //                 controller: _scrollControllerbuttontab,
  //                 child: ButtonsTabBar(
  //                   labelStyle: AppFonts.headerStyle(
  //                       fontSize: 12,
  //                       color:
  //                           //   GlobalLists.mainlisttabs[GlobalLists.maintag].details[GlobalLists.selectedindex].status=="Pending"? customcolor.red:
  //                           customcolor.blue,
  //                       fontWeight: FontWeight.normal),
  //                   unselectedLabelStyle: AppFonts.headerStyle(
  //                       fontSize: 12,
  //                       color:
  //                           //   GlobalLists.mainlisttabs[GlobalLists.maintag].details[GlobalLists.selectedindex].status=="Pending"? customcolor.red:
  //                           customcolor.greytext,
  //                       fontWeight: FontWeight.normal),

  //                   height: 150,

  //                   onTap: (val) {
  //                     setState(() {
  //                       print("ontap");
  //                       print(val.toString());
  //                       GlobalLists.selectedindex = val; //21feb
  //                       tag = 0;
  //                       print("ontaptag");
  //                       print(tag);
  //                       //26mar
  //                       GlobalLists.card_startcurrentdatevalue = GlobalLists
  //                           .detailopeermainlisttab[0]
  //                           .details[GlobalLists.selectedindex]
  //                           .startTimeStr
  //                           .toString();
  //                       GlobalLists.card_endcurrentdatevalue = GlobalLists
  //                           .detailopeermainlisttab[0]
  //                           .details[GlobalLists.selectedindex]
  //                           .endTimeStr
  //                           .toString();
  //                       GlobalLists.card_superviorfirtvalue = GlobalLists
  //                           .detailopeermainlisttab[0]
  //                           .details[GlobalLists.selectedindex]
  //                           .supervisorName
  //                           .toString();
  //                       GlobalLists.card_percentvalue = GlobalLists
  //                           .detailopeermainlisttab[0].totalPercentage
  //                           .toString();
  //                     });
  //                   },

  //                   //   indicator:
  //                   // //  GlobalLists.tabControllermain.index==GlobalLists.selectedindex?
  //                   decoration: BoxDecoration(

  //                       color:
  //                           //  GlobalLists.mainlisttabs[GlobalLists.maintag].details[GlobalLists.selectedindex].status=="Pending"? customcolor.red:
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

  //                   tabs: GlobalLists.tabsmain,

  //                   controller: GlobalLists.tabControllermain,
  //                 ),
  //               ),
  //             ),
  //             //wait4
  //             isdataloaded
  //                 ? Padding(
  //                     padding: const EdgeInsets.all(6.0),
  //                     child: Stack(
  //                       children: [
  //                         Padding(
  //                             padding: EdgeInsets.only(
  //                               right: 0.0,
  //                               left: 0.0,
  //                               top: 15,
  //                               bottom: 4,
  //                             ),
  //                             child: GestureDetector(
  //                               onTap: () {},
  //                               child: IntrinsicHeight(
  //                                 child: Row(
  //                                   crossAxisAlignment:
  //                                       CrossAxisAlignment.start,
  //                                   mainAxisAlignment: MainAxisAlignment.start,
  //                                   children: [
  //                                     Material(
  //                                       elevation: 2,
  //                                       borderRadius: BorderRadius.circular(10),
  //                                       child: Padding(
  //                                         padding: const EdgeInsets.all(10),
  //                                         child: Container(
  //                                           width:
  //                                               SizeConfig.blockSizeHorizontal *
  //                                                   60,
  //                                           child: Column(
  //                                             crossAxisAlignment:
  //                                                 CrossAxisAlignment.start,
  //                                             mainAxisAlignment:
  //                                                 MainAxisAlignment.start,
  //                                             children: [
  //                                               Text(
  //                                                 "${GlobalLists.card_startcurrentdatevalue}-${GlobalLists.card_endcurrentdatevalue}",
  //                                                 // "${GlobalLists.mainlisttabs[GlobalLists.maintag].details[GlobalLists.selectedindex].startTimeStr} - ${GlobalLists.mainlisttabs[GlobalLists.maintag].details[GlobalLists.selectedindex].endTimeStr}",
  //                                                 maxLines: 2,
  //                                                 textAlign: TextAlign.start,
  //                                                 overflow:
  //                                                     TextOverflow.ellipsis,

  //                                                 style: AppFonts.headerStyle(
  //                                                     fontSize:
  //                                                         ResponsiveFlutter.of(
  //                                                                 context)
  //                                                             .fontSize(2.2),
  //                                                     color: customcolor.blue,
  //                                                     fontWeight:
  //                                                         FontWeight.w600),
  //                                               ),
  //                                               SizedBox(
  //                                                 height: 10,
  //                                               ),
  //                                               (role == GlobalLists.headrole ||
  //                                                       role ==
  //                                                           GlobalLists
  //                                                               .reginalmanagerrole ||
  //                                                       role ==
  //                                                           GlobalLists
  //                                                               .clientrole ||
  //                                                       role ==
  //                                                           GlobalLists
  //                                                               .operationrole ||
  //                                                       role ==
  //                                                           GlobalLists
  //                                                               .operationmanagerrole)
  //                                                   ? Text(
  //                                                       "${GlobalLists.card_superviorfirtvalue}",
  //                                                       //  "${GlobalLists.mainlisttabs[GlobalLists.maintag].details[GlobalLists.selectedindex].supervisorName}",
  //                                                       maxLines: 2,
  //                                                       textAlign:
  //                                                           TextAlign.start,
  //                                                       overflow: TextOverflow
  //                                                           .ellipsis,

  //                                                       style: AppFonts.headerStyle(
  //                                                           fontSize:
  //                                                               ResponsiveFlutter.of(
  //                                                                       context)
  //                                                                   .fontSize(
  //                                                                       2.2),
  //                                                           color: customcolor
  //                                                               .black,
  //                                                           fontWeight:
  //                                                               FontWeight
  //                                                                   .w400),
  //                                                     )
  //                                                   : Container(),
  //                                             ],
  //                                           ),
  //                                         ),
  //                                       ),
  //                                     ),
  //                                     SizedBox(
  //                                       width: 8,
  //                                     ),
  //                                     Expanded(
  //                                       child: Material(
  //                                         elevation: 2,
  //                                         borderRadius:
  //                                             BorderRadius.circular(10),
  //                                         child: Padding(
  //                                           padding: EdgeInsets.symmetric(
  //                                               vertical: SizeConfig
  //                                                       .blockSizeHorizontal *
  //                                                   1.5),
  //                                           child: Column(
  //                                             crossAxisAlignment:
  //                                                 CrossAxisAlignment.center,
  //                                             mainAxisAlignment:
  //                                                 MainAxisAlignment.center,
  //                                             children: [
  //                                               Container(
  //                                                 // color: customcolor.appbarcolor,
  //                                                 child:
  //                                                     CircularPercentIndicator(
  //                                                   animationDuration: 500,
  //                                                   //   radius: 35.0,
  //                                                   lineWidth: 4.0,
  //                                                   radius: 34.0,
  //                                                   //   lineWidth: 5.0,
  //                                                   animation: true,
  //                                                   percent:
  //                                                       //0.0,
  //                                                       //double.parse(GlobalLists.card_percentvalue)>100.0?0.0:double.parse(GlobalLists.card_percentvalue)/100,
  //                                                       // GlobalLists.card_percentvalue=="101.0"? 0.0:
  //                                                       double.parse(GlobalLists
  //                                                                   .card_percentvalue) >
  //                                                               100.0
  //                                                           ? 0.0
  //                                                           : double.parse(
  //                                                                   GlobalLists
  //                                                                       .card_percentvalue) /
  //                                                               100,
  //                                                   //  GlobalLists.mainlisttabs[GlobalLists.maintag].details[GlobalLists.selectedindex].percentage>100.0?0.0: GlobalLists.mainlisttabs[GlobalLists.maintag].details[GlobalLists.selectedindex].percentage/100,
  //                                                   center: new Text(
  //                                                     // "",
  //                                                     GlobalLists.card_percentvalue ==
  //                                                             "101.0"
  //                                                         ? 'NA'
  //                                                         : "${double.parse(GlobalLists.card_percentvalue).toStringAsFixed(0)}%",
  //                                                     //  "${GlobalLists.mainlisttabs[GlobalLists.maintag].details[GlobalLists.selectedindex].percentage.toStringAsFixed(0)}%",
  //                                                     style:
  //                                                         AppFonts.headerStyle(
  //                                                             fontSize: 15,
  //                                                             color: customcolor
  //                                                                 .yellow,
  //                                                             fontWeight:
  //                                                                 FontWeight
  //                                                                     .bold),
  //                                                   ),

  //                                                   circularStrokeCap:
  //                                                       CircularStrokeCap.round,
  //                                                   progressColor:
  //                                                       customcolor.blue,
  //                                                 ),
  //                                               ),
  //                                               (role == GlobalLists.headrole ||
  //                                                       role ==
  //                                                           GlobalLists
  //                                                               .reginalmanagerrole ||
  //                                                       role ==
  //                                                           GlobalLists
  //                                                               .clientrole ||
  //                                                       role ==
  //                                                           GlobalLists
  //                                                               .operationrole ||
  //                                                       role ==
  //                                                           GlobalLists
  //                                                               .operationmanagerrole)
  //                                                   ? SizedBox(
  //                                                       height: 0,
  //                                                     )
  //                                                   : SizedBox(
  //                                                       height: 7,
  //                                                     ),
  //                                               (role == GlobalLists.headrole ||
  //                                                       role ==
  //                                                           GlobalLists
  //                                                               .reginalmanagerrole ||
  //                                                       role ==
  //                                                           GlobalLists
  //                                                               .clientrole ||
  //                                                       role ==
  //                                                           GlobalLists
  //                                                               .operationrole ||
  //                                                       role ==
  //                                                           GlobalLists
  //                                                               .operationmanagerrole)
  //                                                   ? Container()
  //                                                   : Text(
  //                                                       "${GlobalLists.mainlisttabs[GlobalLists.maintag].details[0].uncheckCount.toString()} Task Pending",
  //                                                       maxLines: 2,
  //                                                       textAlign:
  //                                                           TextAlign.start,
  //                                                       overflow: TextOverflow
  //                                                           .ellipsis,
  //                                                       style: AppFonts.headerStyle(
  //                                                           fontSize:
  //                                                               ResponsiveFlutter.of(
  //                                                                       context)
  //                                                                   .fontSize(
  //                                                                       2),
  //                                                           color: customcolor
  //                                                               .appbarcolor,
  //                                                           fontWeight:
  //                                                               FontWeight
  //                                                                   .bold),
  //                                                     ),
  //                                             ],
  //                                           ),
  //                                         ),
  //                                       ),
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ),
  //                               /*child: Material(
  //                                 elevation: 2,
  //                                 borderRadius: BorderRadius.circular(10),
  //                                 child: Container(
  //                                   width: SizeConfig.blockSizeHorizontal * 100,
  //                                   decoration: BoxDecoration(
  //                                     borderRadius: BorderRadius.circular(10),
  //                                   ),
  //                                   child: Padding(
  //                                     padding: const EdgeInsets.all(10.0),
  //                                     child: Column(
  //                                       crossAxisAlignment:
  //                                           CrossAxisAlignment.start,
  //                                       mainAxisAlignment:
  //                                           MainAxisAlignment.start,
  //                                       children: [
  //                                         // SizedBox(height: 20,),
  //                                         Row(
  //                                           crossAxisAlignment:
  //                                               CrossAxisAlignment.start,
  //                                           mainAxisAlignment:
  //                                               MainAxisAlignment.spaceBetween,
  //                                           children: [
  //                                             Padding(
  //                                               padding: const EdgeInsets.only(
  //                                                   top: 10),
  //                                               child: Container(
  //                                                 width: SizeConfig
  //                                                         .blockSizeHorizontal *
  //                                                     50,
  //                                                 child: Column(
  //                                                   crossAxisAlignment:
  //                                                       CrossAxisAlignment
  //                                                           .start,
  //                                                   mainAxisAlignment:
  //                                                       MainAxisAlignment.start,
  //                                                   children: [
  //                                                     Text(
  //                                                       "${GlobalLists.card_startcurrentdatevalue}-${GlobalLists.card_endcurrentdatevalue}",
  //                                                       // "${GlobalLists.mainlisttabs[GlobalLists.maintag].details[GlobalLists.selectedindex].startTimeStr} - ${GlobalLists.mainlisttabs[GlobalLists.maintag].details[GlobalLists.selectedindex].endTimeStr}",
  //                                                       maxLines: 2,
  //                                                       textAlign:
  //                                                           TextAlign.start,
  //                                                       overflow: TextOverflow
  //                                                           .ellipsis,

  //                                                       style: AppFonts.headerStyle(
  //                                                           fontSize:
  //                                                               ResponsiveFlutter.of(
  //                                                                       context)
  //                                                                   .fontSize(
  //                                                                       2.2),
  //                                                           color: customcolor
  //                                                               .blue,
  //                                                           fontWeight:
  //                                                               FontWeight
  //                                                                   .w600),
  //                                                     ),
  //                                                     SizedBox(
  //                                                       height: 10,
  //                                                     ),
  //                                                     (role ==  GlobalLists  .headrole ||
  //                                                             role ==  GlobalLists  .reginalmanagerrole ||
  //                                                             role ==  GlobalLists .clientrole ||
  //                                                             role == GlobalLists   .operationrole ||
  //                                                             role == GlobalLists .operationmanagerrole)
  //                                                         ? Text(
  //                                                             "$GlobalLists.card_superviorfirtvalue",
  //                                                             //  "${GlobalLists.mainlisttabs[GlobalLists.maintag].details[GlobalLists.selectedindex].supervisorName}",
  //                                                             maxLines: 2,
  //                                                             textAlign:
  //                                                                 TextAlign
  //                                                                     .start,
  //                                                             overflow:
  //                                                                 TextOverflow
  //                                                                     .ellipsis,

  //                                                             style: AppFonts.headerStyle(
  //                                                                 fontSize: ResponsiveFlutter.of(
  //                                                                         context)
  //                                                                     .fontSize(
  //                                                                         2.2),
  //                                                                 color:
  //                                                                     customcolor
  //                                                                         .black,
  //                                                                 fontWeight:
  //                                                                     FontWeight
  //                                                                         .w400),
  //                                                           )
  //                                                         : Container(),
  //                                                   ],
  //                                                 ),
  //                                               ),
  //                                             ),
  //                                             Column(
  //                                               crossAxisAlignment:
  //                                                   CrossAxisAlignment.end,
  //                                               mainAxisAlignment:
  //                                                   MainAxisAlignment.start,
  //                                               children: [
  //                                                 Container(
  //                                                   // color: customcolor.appbarcolor,
  //                                                   child:
  //                                                       CircularPercentIndicator(
  //                                                     animationDuration: 500,
  //                                                     //   radius: 35.0,
  //                                                     lineWidth: 4.0,
  //                                                     radius: 34.0,
  //                                                     //   lineWidth: 5.0,
  //                                                     animation: true,
  //                                                     percent:
  //                                                         //  0.0,
  //                                                         //double.parse(GlobalLists.card_percentvalue)>100.0?0.0:double.parse(GlobalLists.card_percentvalue)/100,
  //                                                     // GlobalLists.card_percentvalue=="101.0"? 0.0 :
  //                                                         double.parse(  GlobalLists.card_percentvalue) > 100.0 ? 0.0 : double.parse( GlobalLists.card_percentvalue) / 100,
  //                                                     //  GlobalLists.mainlisttabs[GlobalLists.maintag].details[GlobalLists.selectedindex].percentage>100.0?0.0: GlobalLists.mainlisttabs[GlobalLists.maintag].details[GlobalLists.selectedindex].percentage/100,
  //                                                     center: new Text(
  //                                                       // "",
  //                                                       // GlobalLists.card_percentvalue=="101.0"? 'NA':gb
  //                                                       "${double.parse(GlobalLists.card_percentvalue).toStringAsFixed(0)}%",
  //                                                       //  "${GlobalLists.mainlisttabs[GlobalLists.maintag].details[GlobalLists.selectedindex].percentage.toStringAsFixed(0)}%",
  //                                                       style: AppFonts
  //                                                           .headerStyle(
  //                                                               fontSize: 15,
  //                                                               color:
  //                                                                   customcolor
  //                                                                       .yellow,
  //                                                               fontWeight:
  //                                                                   FontWeight
  //                                                                       .bold),
  //                                                     ),

  //                                                     circularStrokeCap:
  //                                                         CircularStrokeCap
  //                                                             .round,
  //                                                     progressColor:
  //                                                         customcolor.blue,
  //                                                   ),
  //                                                 ),
  //                                                 (role ==
  //                                                             GlobalLists
  //                                                                 .headrole ||
  //                                                         role ==
  //                                                             GlobalLists
  //                                                                 .reginalmanagerrole ||
  //                                                         role ==
  //                                                             GlobalLists
  //                                                                 .clientrole ||
  //                                                         role ==
  //                                                             GlobalLists
  //                                                                 .operationrole ||
  //                                                         role ==
  //                                                             GlobalLists
  //                                                                 .operationmanagerrole)
  //                                                     ? SizedBox(
  //                                                         height: 0,
  //                                                       )
  //                                                     : SizedBox(
  //                                                         height: 7,
  //                                                       ),
  //                                                 (role ==
  //                                                             GlobalLists
  //                                                                 .headrole ||
  //                                                         role ==
  //                                                             GlobalLists
  //                                                                 .reginalmanagerrole ||
  //                                                         role ==
  //                                                             GlobalLists
  //                                                                 .clientrole ||
  //                                                         role ==
  //                                                             GlobalLists
  //                                                                 .operationrole ||
  //                                                         role ==
  //                                                             GlobalLists
  //                                                                 .operationmanagerrole)
  //                                                     ? Container()
  //                                                     : Text(
  //                                                         "${GlobalLists.mainlisttabs[GlobalLists.maintag].details[0].uncheckCount.toString()} Task Pending",
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
  //                                                                         2),
  //                                                             color: customcolor
  //                                                                 .appbarcolor,
  //                                                             fontWeight:
  //                                                                 FontWeight
  //                                                                     .bold),
  //                                                       ),
  //                                               ],
  //                                             ),
  //                                           ],
  //                                         ),

  //                                         // Container(
  //                                         //   height: 5,
  //                                         // ),
  //                                       ],
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ),*/
  //                             )),
  //                         //
  //                       ],
  //                     ),
  //                   )
  //                 : Container(),
  //             //  StatefulBuilder(builder: (thisLowerContext, innerSetState) {
  //             Expanded(
  //               flex: 3,
  //               child: TabBarView(
  //                 physics: ScrollPhysics(),
  //                 controller: GlobalLists.tabControllermain,
  //                 children: List.generate(GlobalLists.tabsmain.length,
  //                     (tabindexmain) {
  //                   // setState(() {
  //                   // tag=0;
  //                   // });
  //                   return Column(
  //                     //  shrinkWrap: true,
  //                     //  physics: ScrollPhysics(),
  //                     children: [
  //                       SizedBox(
  //                         height: 10,
  //                       ),
  //                       // Container()
  //                       //7dec
  //                       //26june
  //                       Container(
  //                           // color: customcolor.blue,
  //                           height: Platform.isAndroid
  //                               ? SizeConfig.blockSizeVertical * 42
  //                               : SizeConfig.blockSizeVertical * 40, //42
  //                           child:
  //                               //  Container(child: Text(" ${GlobalLists.tabsmain.length}"),)
  //                               //wait2
  //                               GlobalLists.detailopeermainlisttab.length == 0
  //                                   ? Container()
  //                                   : Padding(
  //                                       padding: EdgeInsets.only(bottom: 6),
  //                                       child: newoperationmasterarea(
  //                                           tabindexmain),
  //                                     ))
  //                     ],
  //                   );
  //                 }),
  //               ),
  //             )
  //             //  }
  //             //   ),
  //           ],
  //         );
  // }

  masterarea(int tabindexmain) {
    //selectedindexmain=1;
    print("MASTERARE");
    print(tabindexmain);
    tabs = [];
    listtab = [];
    String status = "";

    _tabController = new TabController(
      vsync: this,
      length:
          //      5
          GlobalLists
              .workflowstatuslist[tabindexmain].masterAreaWiseList.length,
    );

    print("TABCONTROLE ${_tabController.index.toString()}");
    print("selectedindexmain ${selectedindexmain.toString()}");
    for (int j = 0;
        j <
            GlobalLists
                .workflowstatuslist[tabindexmain].masterAreaWiseList.length;
        j++) {
      //   setState(() {
      listtab.add(
          GlobalLists.workflowstatuslist[tabindexmain].masterAreaWiseList[j]);
      status = GlobalLists
          .workflowstatuslist[tabindexmain].masterAreaWiseList[j].status;
      tabs.add(
        new Tab(
          ///    text: GlobalLists.workflowstatuslist[tabindexmain].masterAreaWiseList[j].masterAreaName,
          child: Container(
            // height: 35,
            width: SizeConfig.blockSizeHorizontal * 25,
            decoration: j == selectedindexmain
                ? BoxDecoration(
                    color: customcolor.blue,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  )
                : BoxDecoration(
                    color: GlobalLists.workflowstatuslist[tabindexmain]
                                .masterAreaWiseList[j].status ==
                            "Pending"
                        ? customcolor.darkorange
                        : customcolor.blue.withOpacity(0.2),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
            child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "${GlobalLists.workflowstatuslist[tabindexmain].masterAreaWiseList[j].masterAreaName}",
                  style: AppFonts.headerStyle(
                      fontSize: 12,
                      color: customcolor.white,
                      fontWeight: FontWeight.normal),
                )),
          ),
        ),
      );
      //  });
      print("forloop");
      print("tab of masrter");
      print(tabs.length);
      //  print(GlobalLists.workflowstatuslist[i].masterAreaWiseList[j]);
      for (int k = 0;
          k <
              GlobalLists.workflowstatuslist[tabindexmain].masterAreaWiseList[j]
                  .blockData.length;
          k++) {
        //setState(() {
        mainlist.add(PendingTask(
          maintaskname: GlobalLists.workflowstatuslist[tabindexmain]
              .masterAreaWiseList[j].blockData[k].masterAreaName,
          listvalue: GlobalLists.workflowstatuslist[tabindexmain]
              .masterAreaWiseList[j].blockData[k].checklist,
          multipleSelected: [],
          isenabledclick: false,
          masterareaid: GlobalLists.workflowstatuslist[tabindexmain]
              .masterAreaWiseList[j].blockData[k].masterArea
              .toString(),
          masterblockid: GlobalLists.workflowstatuslist[tabindexmain]
              .masterAreaWiseList[j].blockData[k].masterBlock
              .toString(),
        ));
        // });
      }
    }

    return isdataloaded == false
        ? Container()
        : Padding(
            padding: const EdgeInsets.only(left: 6, right: 6, bottom: 6),
            child: ListView(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              children: [
                //card was here in supervisor

                // SizedBox(height: 10,),
                Container(
                  child: Text(
                    "Master Area",
                    style: AppFonts.headerStyle(
                        fontSize: ResponsiveFlutter.of(context).fontSize(2.2),
                        color: customcolor.black,
                        fontWeight: FontWeight.w400),
                  ),
                ),

                //priority
                SizedBox(
                  height: 10,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Wrap(
                      spacing: 5.0,
                      runSpacing: 3.0,
                      children: _buildChoiceList(),
                    ),
                  ),
                ),
                //}),
                expandedheader(tag, tabindexmain),
                Container(
                  // height: SizeConfig.blockSizeVertical*40,
                  decoration: BoxDecoration(
                    //color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: customcolor.greyborder,
                      width: 0.4,
                    ),
                  ),

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //                     StatefulBuilder(
                      //         builder: (BuildContext context, StateSetter setStateDialgoue) {
                      // return
                      //                        Container(
                      //                                           alignment: Alignment.centerLeft,
                      //                                           child:
                      //                                           Wrap(
                      //   spacing: 5.0,
                      //   runSpacing: 3.0,
                      //   children: _buildChoiceList(),
                      // ),

                      //                                         ),
                      //                       //}),
                      //                                       expandedheader(tag,tabindexmain),
//
                    ],
                  ),
                ),
              ],
            ),
          );
  }

//new manager oper

  newoperationmasterarea(int tabindexmain) {
    //selectedindexmain=1;
    // print("operationMASTERARE");
    // print(tabindexmain);
//  tabs=[];
    detailoperationlisttab = [];
    String status = "";

//  print("length tab ${GlobalLists.mainlisttabs[GlobalLists.maintag].details[tabindexmain].masterAreaWiseList.length.toString()}");
    _tabController = new TabController(
      vsync: this,
      length:
          //      5
          GlobalLists.detailopeermainlisttab[0].details[tabindexmain]
              .masterAreaWiseList.length,
    );

    //  print("TABCONTROLE ${_tabController.index.toString()}");
    //  print("selectedindexmain ${selectedindexmain.toString()}");
    for (int j = 0;
        j <
            GlobalLists.detailopeermainlisttab[0].details[tabindexmain]
                .masterAreaWiseList.length;
        j++) {
      // setState(() {
      detailoperationlisttab.add(GlobalLists.detailopeermainlisttab[0]
          .details[tabindexmain].masterAreaWiseList[j]);
      //  status=GlobalLists.mainlisttabs[GlobalLists.maintag].details[tabindexmain].masterAreaWiseList[j].pendingArea.toString();
      tabs.add(
        new Tab(
          ///    text: GlobalLists.workflowstatuslist[tabindexmain].masterAreaWiseList[j].masterAreaName,
          child: Container(
            // height: 35,
            width: SizeConfig.blockSizeHorizontal * 25,
            decoration: j == selectedindexmain
                ? BoxDecoration(
                    color: customcolor.blue,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  )
                : BoxDecoration(
                    color: GlobalLists
                                .detailopeermainlisttab[0]
                                .details[tabindexmain]
                                .masterAreaWiseList[j]
                                .status ==
                            "Pending"
                        ? customcolor.darkorange
                        : customcolor.blue.withOpacity(0.2),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
            child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "${GlobalLists.detailopeermainlisttab[0].details[tabindexmain].masterAreaWiseList[j].masterAreaName}",
                  style: AppFonts.headerStyle(
                      fontSize: 12,
                      color: customcolor.white,
                      fontWeight: FontWeight.normal),
                )),
          ),
        ),
      );
      // });
      for (int k = 0;
          k <
              GlobalLists.detailopeermainlisttab[0].details[tabindexmain]
                  .masterAreaWiseList[j].blockData.length;
          k++) {
        //  setState(() {
        mainlist.add(NewOperationalPendingTask(
          maintaskname: GlobalLists
              .detailopeermainlisttab[0]
              .details[tabindexmain]
              .masterAreaWiseList[j]
              .blockData[k]
              .masterAreaName,
          listvalue: GlobalLists.detailopeermainlisttab[0].details[tabindexmain]
              .masterAreaWiseList[j].blockData[k].checklist,
          multipleSelected: [],
          isenabledclick: false,
          masterareaid: GlobalLists
              .detailopeermainlisttab[0]
              .details[tabindexmain]
              .masterAreaWiseList[j]
              .blockData[k]
              .masterArea
              .toString(),
          masterblockid: GlobalLists
              .detailopeermainlisttab[0]
              .details[tabindexmain]
              .masterAreaWiseList[j]
              .blockData[k]
              .masterBlock
              .toString(),
        ));
        // });
      }
    }

    return isdataloaded == false
        ? Container()
        : Padding(
            padding: const EdgeInsets.only(left: 6, right: 6, bottom: 6),
            child: ListView(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              children: [
                //card was here in supervisor

                // SizedBox(height: 10,),
                Container(
                  child: Text(
                    "Master Area",
                    style: AppFonts.headerStyle(
                        fontSize: ResponsiveFlutter.of(context).fontSize(2.2),
                        color: customcolor.black,
                        fontWeight: FontWeight.w400),
                  ),
                ),

                //priority
                SizedBox(
                  height: 10,
                ),
                Container(
                  // height: SizeConfig.blockSizeVertical*45,
                  decoration: BoxDecoration(
                    //color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: customcolor.greyborder,
                      width: 0.4,
                    ),
                  ),

                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //                     StatefulBuilder(
                      //         builder: (BuildContext context, StateSetter setStateDialgoue) {
                      // return
                      Container(
                        alignment: Alignment.centerLeft,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Wrap(
                            spacing: 5.0,
                            runSpacing: 3.0,
                            children: _buildnewoperationChoiceList(),
                          ),
                        ),
                      ),
                      //}),
                      //7dec
                      //wait5
                      newoperationexpandedheader(tabindexmain, tag)
//
                    ],
                  ),
                ),
              ],
            ),
          );
  }

//operation masteraree
  operationmasterarea(int tabindexmain) {
    //selectedindexmain=1;
    print("operationMASTERARE");
    // print(tabindexmain);
    tabs = [];
    operationlisttab = [];
    String status = "";

//  print("length tab ${GlobalLists.mainlisttabs[GlobalLists.maintag].details[tabindexmain].masterAreaWiseList.length.toString()}");
    _tabController = new TabController(
      vsync: this,
      length:
          //      5
          GlobalLists.mainlisttabs[GlobalLists.maintag].details[tabindexmain]
              .masterAreaWiseList.length,
    );

    print("TABCONTROLE ${_tabController.index.toString()}");
    print("selectedindexmain ${selectedindexmain.toString()}");
    for (int j = 0;
        j <
            GlobalLists.mainlisttabs[GlobalLists.maintag].details[tabindexmain]
                .masterAreaWiseList.length;
        j++) {
      // setState(() {
      operationlisttab.add(GlobalLists.mainlisttabs[GlobalLists.maintag]
          .details[tabindexmain].masterAreaWiseList[j]);
      status = GlobalLists.mainlisttabs[GlobalLists.maintag]
          .details[tabindexmain].masterAreaWiseList[j].pendingArea
          .toString();
      tabs.add(
        new Tab(
          ///    text: GlobalLists.workflowstatuslist[tabindexmain].masterAreaWiseList[j].masterAreaName,
          child: Container(
            // height: 35,
            width: SizeConfig.blockSizeHorizontal * 25,
            decoration: j == selectedindexmain
                ? BoxDecoration(
                    color: customcolor.blue,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  )
                : BoxDecoration(
                    color: GlobalLists
                                .mainlisttabs[GlobalLists.maintag]
                                .details[tabindexmain]
                                .masterAreaWiseList[j]
                                .status ==
                            "Pending"
                        ? customcolor.darkorange
                        : customcolor.blue.withOpacity(0.2),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
            child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "${GlobalLists.mainlisttabs[GlobalLists.maintag].details[tabindexmain].masterAreaWiseList[j].masterAreaName}",
                  style: AppFonts.headerStyle(
                      fontSize: 12,
                      color: customcolor.white,
                      fontWeight: FontWeight.normal),
                )),
          ),
        ),
      );
      // });
  
      //  print(GlobalLists.workflowstatuslist[i].masterAreaWiseList[j]);
      for (int k = 0;
          k <
              GlobalLists.mainlisttabs[GlobalLists.maintag]
                  .details[tabindexmain].masterAreaWiseList[j].blockData.length;
          k++) {
        //setState(() {
        mainlist.add(OperationalPendingTask(
          maintaskname: GlobalLists
              .mainlisttabs[GlobalLists.maintag]
              .details[tabindexmain]
              .masterAreaWiseList[j]
              .blockData[k]
              .masterAreaName,
          listvalue: GlobalLists
              .mainlisttabs[GlobalLists.maintag]
              .details[tabindexmain]
              .masterAreaWiseList[j]
              .blockData[k]
              .checklist,
          multipleSelected: [],
          isenabledclick: false,
          masterareaid: GlobalLists
              .mainlisttabs[GlobalLists.maintag]
              .details[tabindexmain]
              .masterAreaWiseList[j]
              .blockData[k]
              .masterArea
              .toString(),
          masterblockid: GlobalLists
              .mainlisttabs[GlobalLists.maintag]
              .details[tabindexmain]
              .masterAreaWiseList[j]
              .blockData[k]
              .masterBlock
              .toString(),
        ));
        // });
      }
    }

    return isdataloaded == false
        ? Container()
        : Padding(
            padding: const EdgeInsets.only(left: 6, right: 6, bottom: 6),
            child: ListView(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              children: [
                //card was here in supervisor

                // SizedBox(height: 10,),
                Container(
                  child: Text(
                    "Master Area",
                    style: AppFonts.headerStyle(
                        fontSize: ResponsiveFlutter.of(context).fontSize(2.2),
                        color: customcolor.black,
                        fontWeight: FontWeight.w400),
                  ),
                ),

                //priority
                SizedBox(
                  height: 10,
                ),
                Container(
                  // height: SizeConfig.blockSizeVertical*45,
                  decoration: BoxDecoration(
                    //color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: customcolor.greyborder,
                      width: 0.4,
                    ),
                  ),

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //                     StatefulBuilder(
                      //         builder: (BuildContext context, StateSetter setStateDialgoue) {
                      // return
                      Container(
                        alignment: Alignment.centerLeft,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Wrap(
                            direction: Axis.horizontal,
                            spacing: 5.0,
                            runSpacing: 3.0,
                            children: _buildoperationChoiceList(),
                          ),
                        ),
                      ),
                      //}),
                      //7dec
                      operationexpandedheader(tabindexmain, tag)
//
                    ],
                  ),
                ),
              ],
            ),
          );
  }

//commentedno
  expandedheader(int tabindexmain, int tabindex) {
    print("mainlistRU");
    // print(mainlist.length);
    // print(tabindexmain.toString());
    //   print("tag $tabindex.toString()");
    // print(mainlist[index].multipleSelected);
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 15,
          ),
          Container(
            child: Text(
              "Master Blocks",
              style: AppFonts.headerStyle(
                  fontSize: ResponsiveFlutter.of(context).fontSize(2.2),
                  color: customcolor.black,
                  fontWeight: FontWeight.w400),
            ),
          ),

          //priority
          SizedBox(
            height: 10,
          ),
          StatefulBuilder(
              builder: (BuildContext context, StateSetter setStateDialgoue) {
            return ListView.builder(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    setStateDialgoue(() {
                      expand =
                          ((tapped == null) || ((index == tapped) || !expand))
                              ? !expand
                              : expand;

                      /// This tracks which index was tapped
                      tapped = index;
                      debugPrint('current expand state: $expand');
                      print("drop");

                      // print(GlobalLists.workflowstatuslist[tabindex].blocksData[index].masterBlock);
                    });
                  },
                  child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                          side: BorderSide(
                              color: GlobalLists
                                          .workflowstatuslist[tabindex]
                                          .masterAreaWiseList[tabindexmain]
                                          .blockData[index]
                                          .blockPending ==
                                      0
                                  ? customcolor.red
                                  : customcolor.green //changes7feb
                              )),
                      child:
                          //  Container(child: Text(
                          //   // tabindex.toString())
                          //    GlobalLists.workflowstatuslist[tabindex].masterAreaWiseList[tabindexmain].blockData[index].masterBlockName),
                          //   )
                          GlobalLists
                                      .workflowstatuslist[tabindex]
                                      .masterAreaWiseList[tabindexmain]
                                      .blockData
                                      .length >
                                  0
                              ? expandableListView(
                                  GlobalLists
                                      .workflowstatuslist[tabindex].shift,
                                  index,
                                  tabindex,
                                  GlobalLists
                                      .workflowstatuslist[tabindex]
                                      .masterAreaWiseList[tabindexmain]
                                      .blockData[index]
                                      .masterBlockName,
                                  //  mainlist[index].maintaskname,
                                  GlobalLists
                                      .workflowstatuslist[tabindex]
                                      .masterAreaWiseList[tabindexmain]
                                      .blockData[index]
                                      .checklist,
                                  // mainlist[index].listvalue,
                                  [],
                                  //true
                                  index == tapped ? expand : false,
                                  GlobalLists
                                      .workflowstatuslist[tabindex]
                                      .masterAreaWiseList[tabindexmain]
                                      .blockData[index]
                                      .masterArea
                                      .toString(),
                                  GlobalLists
                                      .workflowstatuslist[tabindex]
                                      .masterAreaWiseList[tabindexmain]
                                      .blockData[index]
                                      .masterBlock
                                      .toString(),
                                  tabindexmain)
                              : Container()),
                );
              },
              itemCount: GlobalLists.workflowstatuslist[tabindex]
                  .masterAreaWiseList[tabindexmain].blockData.length,
            );
          }),
        ],
      ),
    );
  }

//opertatio
  operationexpandedheader(int tabindexmain, int tabindex) {
    log("RUCHITARANE $tabindex");
//  print("RANU");
//                _scrollToTab(4);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 15,
        ),
        Container(
          child: Text(
            "Master Blocks",
            style: AppFonts.headerStyle(
                fontSize: ResponsiveFlutter.of(context).fontSize(2.2),
                color: customcolor.black,
                fontWeight: FontWeight.w400),
          ),
        ),

        //priority
        SizedBox(
          height: 10,
        ),
        StatefulBuilder(
            builder: (BuildContext context, StateSetter setStateDialgoue) {
          return ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  setStateDialgoue(() {
                    expand =
                        ((tapped == null) || ((index == tapped) || !expand))
                            ? !expand
                            : expand;

                    /// This tracks which index was tapped
                    tapped = index;
                    debugPrint('current expand state: $expand');
                    print("drop");

                    // print(GlobalLists.workflowstatuslist[tabindex].blocksData[index].masterBlock);
                  });
                },
                child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                        side: BorderSide(
                            color: GlobalLists
                                        .mainlisttabs[GlobalLists.maintag]
                                        .details[tabindexmain]
                                        .masterAreaWiseList[tag]
                                        .blockData[index]
                                        .blockPending ==
                                    0
                                ? customcolor.red
                                : customcolor.green) //changes7feb

                        ),
                    child:
                        //Container(child: Text("data"),)
                        GlobalLists
                                    .mainlisttabs[GlobalLists.maintag]
                                    .details[tabindexmain]
                                    .masterAreaWiseList[tag]
                                    .blockData
                                    .length >
                                0
                            ? expandableoperationListView(
                                index,
                                tag,
                                GlobalLists
                                    .mainlisttabs[GlobalLists.maintag]
                                    .details[tabindexmain]
                                    .masterAreaWiseList[tag]
                                    .blockData[index]
                                    .masterBlockName,
                                //  mainlist[index].maintaskname,
                                GlobalLists
                                    .mainlisttabs[GlobalLists.maintag]
                                    .details[tabindexmain]
                                    .masterAreaWiseList[tag]
                                    .blockData[index]
                                    .checklist,
                                // mainlist[index].listvalue,
                                mainlist[index].multipleSelected,
                                //true
                                index == tapped ? expand : false,
                                GlobalLists
                                    .mainlisttabs[GlobalLists.maintag]
                                    .details[tabindexmain]
                                    .masterAreaWiseList[tag]
                                    .blockData[index]
                                    .masterArea
                                    .toString(),
                                GlobalLists
                                    .mainlisttabs[GlobalLists.maintag]
                                    .details[tabindexmain]
                                    .masterAreaWiseList[tag]
                                    .blockData[index]
                                    .masterBlock
                                    .toString(),
                                tabindexmain)
                            : Container()),
              );
            },
            itemCount: GlobalLists.mainlisttabs[GlobalLists.maintag]
                .details[tabindexmain].masterAreaWiseList[tag].blockData.length,
          );
        }),
      ],
    );
  }

//new manager expanded
  newoperationexpandedheader(int tabindexmain, int tabindex) {
    log("RUCHITARANE timeclip$tabindex");
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 15,
        ),
        Container(
          child: Text(
            "Master Blocks",
            style: AppFonts.headerStyle(
                fontSize: ResponsiveFlutter.of(context).fontSize(2.2),
                color: customcolor.black,
                fontWeight: FontWeight.w400),
          ),
        ),

        //priority
        SizedBox(
          height: 10,
        ),
        StatefulBuilder(
            builder: (BuildContext context, StateSetter setStateDialgoue) {
          return ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  setStateDialgoue(() {
                    expand =
                        ((tapped == null) || ((index == tapped) || !expand))
                            ? !expand
                            : expand;

                    /// This tracks which index was tapped
                    tapped = index;
                    debugPrint('current expand state: $expand');
                    print("drop");

                    // print(GlobalLists.workflowstatuslist[tabindex].blocksData[index].masterBlock);
                  });
                },
                child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                        side: BorderSide(
                            color: GlobalLists
                                        .detailopeermainlisttab[0]
                                        .details[tabindexmain]
                                        .masterAreaWiseList[tag]
                                        .blockData[index]
                                        .blockPending ==
                                    0
                                ? customcolor.red
                                : customcolor.green) //changes7feb

                        ),
                    child:
                        //Container(child: Text("data"),)
                        GlobalLists
                                    .detailopeermainlisttab[0]
                                    .details[tabindexmain]
                                    .masterAreaWiseList[tag]
                                    .blockData
                                    .length >
                                0
                            ? expandablenewoperationListView(
                                index,
                                tag,
                                GlobalLists
                                    .detailopeermainlisttab[0]
                                    .details[tabindexmain]
                                    .masterAreaWiseList[tag]
                                    .blockData[index]
                                    .masterBlockName,
                                //  mainlist[index].maintaskname,
                                GlobalLists
                                    .detailopeermainlisttab[0]
                                    .details[tabindexmain]
                                    .masterAreaWiseList[tag]
                                    .blockData[index]
                                    .checklist,
                                // mainlist[index].listvalue,
                                mainlist[index].multipleSelected,
                                //true
                                index == tapped ? expand : false,
                                GlobalLists
                                    .detailopeermainlisttab[0]
                                    .details[tabindexmain]
                                    .masterAreaWiseList[tag]
                                    .blockData[index]
                                    .masterArea
                                    .toString(),
                                GlobalLists
                                    .detailopeermainlisttab[0]
                                    .details[tabindexmain]
                                    .masterAreaWiseList[tag]
                                    .blockData[index]
                                    .masterBlock
                                    .toString(),
                                tabindexmain)
                            : Container()),
              );
            },
            itemCount: GlobalLists.detailopeermainlisttab[0]
                .details[tabindexmain].masterAreaWiseList[tag].blockData.length,
          );
        }),
      ],
    );
  }

  Widget expandableListView(
      int shiftid,
      int indexvalue,
      int tabindex,
      String title,
      List<Checklist> checkboxeslist,
      List multipleSelectedlist,
      bool isExpanded,
      String masterareaid,
      String bloackareaid,
      int tabindexmain) {
    selectedindexmain = tabindex;
    GlobalLists.card_startcurrentdatevalue =
        GlobalLists.workflowstatuslist[selectedindexmain].startTime;
    GlobalLists.card_endcurrentdatevalue =
        GlobalLists.workflowstatuslist[selectedindexmain].endTime;
    GlobalLists.card_superviorfirtvalue =
        "${GlobalLists.workflowstatuslist[selectedindexmain].clientName} - ${GlobalLists.workflowstatuslist[selectedindexmain].siteName}";
    GlobalLists.card_percentvalue = GlobalLists
        .total_supervisorercentage; //GlobalLists.workflowstatuslist[selectedindexmain].percentage.toString();

    print("R U CHITA");
    GlobalLists.tabControllermain.addListener(() {
      print("callinginit");
      setState(() {
        tag = 0;
        GlobalLists.selectedindex = 0;
      });
    });

    print(selectedindexmain);

    print("isexpanded1");

    print("isexpanded");
    print(isExpanded);
    print(title);
    debugPrint('List item build $indexvalue $isExpanded');
    debugPrint('List item build $checkboxeslist');
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setStateDialgoue) {
      return Container(
        color: customcolor.white,
        margin: EdgeInsets.symmetric(vertical: 2.0),
        child: Column(
          children: <Widget>[
//
            Container(
              color: Colors.white,
              padding: EdgeInsets.only(left: 20, right: 10, top: 2, bottom: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: [
                      // Image.network(img, width: 25, height: 25, errorBuilder:
                      //     (BuildContext context, Object exception,
                      //         StackTrace? stackTrace) {
                      //   return Container();
                      // }),
                      // SizedBox(
                      //   width: 15,
                      // ),
                      Container(
                        width: SizeConfig.blockSizeHorizontal * 70,
                        child: Text(
                          title,
                          style: AppFonts.headerStyle(
                              fontSize: 16,
                              color: GlobalLists
                                          .workflowstatuslist[tabindex]
                                          .masterAreaWiseList[tabindexmain]
                                          .blockData[indexvalue]
                                          .blockPending ==
                                      0
                                  ? customcolor.red
                                  : customcolor.green,
                              //changes7feb
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.black,
                    size: 30.0,
                  ),
                ],
              ),
            ),

            ExpandableContainer(
              expanded: isExpanded,
              expandedHeight: (role == GlobalLists.headrole ||
                      role == GlobalLists.reginalmanagerrole ||
                      role == GlobalLists.clientrole ||
                      role == GlobalLists.operationrole ||
                      role == GlobalLists.operationmanagerrole)
                  ? checkboxeslist.length <= 1
                      ? SizeConfig.blockSizeHorizontal * 10
                      : checkboxeslist.length <= 3
                          ? SizeConfig.blockSizeHorizontal * 30
                          : SizeConfig.blockSizeHorizontal * 40
                  :
//supervisorcheck
                  checkboxeslist.length <= 1
                      ? SizeConfig.blockSizeHorizontal * 30
                      : checkboxeslist.length <= 3
                          ? SizeConfig.blockSizeHorizontal * 40
                          : SizeConfig.blockSizeHorizontal * 70,
              //  expandedlistview
              child: Scrollbar(
                thumbVisibility: true,
                // thumbVisibility: true,
                child: Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: ListView(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    children: [
                      //      Padding(
                      //   padding: const EdgeInsets.only(left: 5,right:5),
                      //   child: Divider(color: customcolor.greytext,thickness: 0.5,),
                      // ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: (role == GlobalLists.headrole ||
                                role == GlobalLists.reginalmanagerrole ||
                                role == GlobalLists.clientrole ||
                                role == GlobalLists.operationrole ||
                                role == GlobalLists.operationmanagerrole)
                            ? List.generate(
                                checkboxeslist.length,
                                (indexcheck) => ListTileTheme(
                                  horizontalTitleGap: 0,
                                  minVerticalPadding: 0,
                                  child: Theme(
                                      data: ThemeData(
                                          unselectedWidgetColor:
                                              customcolor.greytext),
                                      child:
                                          //mainlist[indexvalue].isenabledclick?
                                          Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8, bottom: 8),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              width: SizeConfig
                                                      .blockSizeHorizontal *
                                                  65,
                                              child: Text(
                                                checkboxeslist[indexcheck]
                                                    .pointerName,
                                                maxLines: 1,
                                                style: AppFonts.headerStyle(
                                                    fontSize: 12,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            ),
                                            Text(
                                              checkboxeslist[indexcheck]
                                                          .checked ==
                                                      true
                                                  ? "Completed"
                                                  : "Pending",
                                              style: AppFonts.headerStyle(
                                                  fontSize: 12,
                                                  color:
                                                      checkboxeslist[indexcheck]
                                                                  .checked ==
                                                              true
                                                          ? customcolor.green
                                                          : customcolor.red,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                          ],
                                        ),
                                      )),
                                ),
                              )
                            : List.generate(
                                checkboxeslist.length,
                                (indexcheck) => ListTileTheme(
                                  contentPadding: EdgeInsets.all(0),
                                  horizontalTitleGap: 0,
                                  dense: true,
                                  minVerticalPadding: -4,
                                  child: Theme(
                                      data: ThemeData(
                                          unselectedWidgetColor:
                                              customcolor.greytext),
                                      child: //mainlist[indexvalue].isenabledclick?
                                          CheckboxListTile(
                                         //enabled:GlobalLists.shiftavaialble == "0" ? false : true,
                                        enabled: true,
                                        activeColor: customcolor.green,
                                        visualDensity: VisualDensity.compact,
                                        controlAffinity:
                                            ListTileControlAffinity.leading,
                                        contentPadding: EdgeInsets.all(0),
                                        dense: true,
                                        title: Text(
                                          checkboxeslist[indexcheck]
                                              .pointerName,
                                          style: AppFonts.headerStyle(
                                              fontSize: 14,
                                              color: checkboxeslist[indexcheck]
                                                          .checked ==
                                                      true
                                                  ? customcolor.green
                                                  : Colors.black,
                                              fontWeight: FontWeight.normal),
                                        ),
                                        value:
                                            checkboxeslist[indexcheck].checked,
                                        onChanged:isUpdateButtonVisible? (value) {
                                          // String startTime = "08:00 PM";
                                          // String endTime = "06:00 AM";
                                          // String current_time= "01:40 AM";
                                          //shift timing
                                          String startTime =
                                              GlobalLists.start_time;
                                          String endTime = GlobalLists.end_time;
                                          // Get the current time
                                          DateTime currentTime = DateTime.now();
                                          // ShowDialogs.showToast('Start Time: ${startTime}  End Time: ${endTime}  multidays: ${multidays}');
                                          // Format the current time
                                          String current_time =
                                              DateFormat('hh:mm a')
                                                  .format(currentTime);
                                          // print('Current Time: ${formattedTime}'); // Output: 01:40 AM
                                          // Clean up the time strings by removing invisible characters like non-breaking spaces
                                          startTime =
                                              cleanUpTimeString(startTime);
                                          endTime = cleanUpTimeString(endTime);
                                          current_time =
                                              cleanUpTimeString(current_time);

                                          // Extract AM or PM from the time strings
                                          String startPeriod =
                                              extractAMPM(startTime);
                                          String endPeriod =
                                              extractAMPM(endTime);
                                          String currentPeriod =
                                              extractAMPM(current_time);

                                          if (GlobalLists.multidays == true &&
                                              (startPeriod == 'PM' &&
                                                  endPeriod == 'AM')) {
                                            if (startPeriod == 'PM' &&
                                                currentPeriod == 'AM') {
                                              // after 00:00 AM
                                              if (checklistdate ==
                                                  GlobalLists
                                                      .datecontroller.text) {
                                                // checklistdate = datecontroller.text;
                                                ShowDialogs.showToast(
                                                    'Please select previous date');
                                              } else {
                                                // ShowDialogs.showToast('Proper Data');
                                                setStateDialgoue(() {
                                                  if (checkboxeslist[indexcheck]
                                                      .finalCheck) {
                                                  } else {
                                                    checkboxeslist[indexcheck]
                                                        .checked = value!;
                                                  }
                                                  print("multipleSelectedlist");
                                                  print(multipleSelectedlist);
                                                  print(checkboxeslist[
                                                      indexcheck]);

                                                  if (multipleSelectedlist
                                                      .contains(checkboxeslist[
                                                          indexcheck])) {
                                                    multipleSelectedlist.remove(
                                                        checkboxeslist[
                                                            indexcheck]);
                                                  } else {
                                                    multipleSelectedlist.add(
                                                        checkboxeslist[
                                                            indexcheck]);
                                                  }
                                                });
                                              }
                                            } else {
                                              // before 00:00 AM
                                              // ShowDialogs.showToast('before 00:00 AM');
                                              setStateDialgoue(() {
                                                if (checkboxeslist[indexcheck]
                                                    .finalCheck) {
                                                } else {
                                                  checkboxeslist[indexcheck]
                                                      .checked = value!;
                                                }
                                                print("multipleSelectedlist");
                                                print(multipleSelectedlist);
                                                print(
                                                    checkboxeslist[indexcheck]);

                                                if (multipleSelectedlist
                                                    .contains(checkboxeslist[
                                                        indexcheck])) {
                                                  multipleSelectedlist.remove(
                                                      checkboxeslist[
                                                          indexcheck]);
                                                } else {
                                                  multipleSelectedlist.add(
                                                      checkboxeslist[
                                                          indexcheck]);
                                                }
                                              });
                                            }
                                          } else {
                                            // ShowDialogs.showToast('No Apply Condition');
                                            setStateDialgoue(() {
                                              if (checkboxeslist[indexcheck]
                                                  .finalCheck) {
                                              } else {
                                                checkboxeslist[indexcheck]
                                                    .checked = value!;
                                              }
                                              print("multipleSelectedlist");
                                              print(multipleSelectedlist);
                                              print(checkboxeslist[indexcheck]);

                                              if (multipleSelectedlist.contains(
                                                  checkboxeslist[indexcheck])) {
                                                multipleSelectedlist.remove(
                                                    checkboxeslist[indexcheck]);
                                              } else {
                                                multipleSelectedlist.add(
                                                    checkboxeslist[indexcheck]);
                                              }
                                            });
                                          }
                                        }:null,
                                      )),
                                ),
                              ),
                      ),
                      (role == GlobalLists.headrole ||
                              role == GlobalLists.reginalmanagerrole ||
                              role == GlobalLists.clientrole ||
                              role == GlobalLists.operationrole ||
                              role == GlobalLists.operationmanagerrole)
                          ? Container()
                          :isUpdateButtonVisible? Column(
                              children: [
                                SizedBox(
                                  height: 15,
                                ),
                                //Updated Button Master Block
                                isworkflowUpdated
                                    ? CircularProgressIndicator(
                                        color: customcolor.blue,
                                      )
                                    :isUpdateButtonVisible?  MyElevatedButton(
                                        setStyleStr: 'home',
                                        width: 120,
                                        height:
                                            SizeConfig.blockSizeVertical * 6,
                                        onPressed: () {
                                          print("multipleSelectedlist");
                                          // print(multipleSelectedlist.checklistId.toString());
                                          List<String> checkedid = [];
                                          List<String> uncheckedid = [];
                                          //  for(int i=0;i<multipleSelectedlist.length;i++)
                                          //  {
                                          //   checkedid.add(multipleSelectedlist[i].id.toString());
                                          //  }
                                          for (int i = 0;
                                              i < checkboxeslist.length;
                                              i++) {
                                            if (!checkboxeslist[i].checked) {
                                              uncheckedid.add(checkboxeslist[i]
                                                  .id
                                                  .toString());
                                            } else {
                                              checkedid.add(checkboxeslist[i]
                                                  .id
                                                  .toString());
                                            }
                                          }
                                          log('click on update');
                                          print("checkedid");
                                          print("Calledupdate");
                                          print("check $checkedid");
                                          print("uncheck $uncheckedid");
                                          print(masterareaid);
                                          print(bloackareaid);
                                          print("shiftid $shiftid");
                                          print(
                                              "shiftid ${GlobalLists.workflowstatuslist[tabindex].masterAreaWiseList[tabindexmain].blockData[indexvalue].shift.toString()}");
                                          updatedworkflowstatusApi(
                                              GlobalLists
                                                  .workflowstatuslist[tabindex]
                                                  .masterAreaWiseList[
                                                      tabindexmain]
                                                  .blockData[indexvalue]
                                                  .shift
                                                  .toString(),
                                              checkedid,
                                              uncheckedid,
                                              masterareaid,
                                              bloackareaid);
                                        },
                                        borderRadius: BorderRadius.circular(5),
                                        colorvalue: customcolor.blue,
                                        child: Text('Update'),
                                      ):Container(),
                              ],
                            ):Container(),

                      //22april
                      isExpanded
                          ? SizedBox(
                              height: 10,
                            )
                          : SizedBox(
                              height: 10,
                            ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      );
    });
  }

  String cleanUpTimeString(String? timeString) {
    if (timeString == null) return '';
    return timeString
        .replaceAll(RegExp(r'[^\x00-\x7F]+'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  String extractAMPM(String time) {
    // Use regex to capture 'AM' or 'PM'
    RegExp amPmRegex = RegExp(r'(AM|PM)', caseSensitive: false);
    Match? match = amPmRegex.firstMatch(time);
    if (match != null) {
      return match.group(0) ?? ''; // Return the matched string (AM or PM)
    } else {
      return ''; // Return empty string if no match
    }
  }

  Widget expandableoperationListView(
      int indexvalue,
      int tabindex,
      String title,
      List<operwf.Checklist> checkboxeslist,
      List multipleSelectedlist,
      bool isExpanded,
      String masterareaid,
      String bloackareaid,
      int tabindexmain) {
    selectedindexmain = tabindex;
    GlobalLists.card_startcurrentdatevalue = GlobalLists
        .mainlisttabs[GlobalLists.maintag].details[tabindexmain].startTimeStr
        .toString();
    GlobalLists.card_endcurrentdatevalue = GlobalLists
        .mainlisttabs[GlobalLists.maintag].details[tabindexmain].endTimeStr
        .toString();
    GlobalLists.card_superviorfirtvalue = GlobalLists
        .mainlisttabs[GlobalLists.maintag].details[tabindexmain].supervisorName
        .toString();
    GlobalLists.card_percentvalue = GlobalLists
        .mainlisttabs[GlobalLists.maintag].totalPercentage
        .toString();
    print(selectedindexmain);
    GlobalLists.tabControllermain.addListener(() {
      print("callinginit");
      setState(() {
        tag = 0;
        GlobalLists.selectedindex = 0;
      });
    });

    debugPrint('List item build $indexvalue $isExpanded');
    debugPrint('List item build $checkboxeslist');

    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setStateDialgoue) {
      return Container(
        color: customcolor.white,
        margin: EdgeInsets.symmetric(vertical: 2.0),
        child: Column(
          children: <Widget>[
//
            Container(
              color: Colors.white,
              padding: EdgeInsets.only(left: 20, right: 10, top: 2, bottom: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: [
                      // Image.network(img, width: 25, height: 25, errorBuilder:
                      //     (BuildContext context, Object exception,
                      //         StackTrace? stackTrace) {
                      //   return Container();
                      // }),
                      // SizedBox(
                      //   width: 15,
                      // ),
                      Container(
                        width: SizeConfig.blockSizeHorizontal * 70,
                        child: Text(
                          title,
                          style: AppFonts.headerStyle(
                              fontSize: 16,
                              color: GlobalLists
                                          .mainlisttabs[GlobalLists.maintag]
                                          .details[tabindexmain]
                                          .masterAreaWiseList[tabindex]
                                          .blockData[indexvalue]
                                          .blockPending ==
                                      0
                                  ? customcolor.red
                                  : customcolor.green,
                              //changes7feb
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.black,
                    size: 30.0,
                  ),
                ],
              ),
            ),

            ExpandableContainer(
              expanded: isExpanded,
              expandedHeight: (role == GlobalLists.headrole ||
                      role == GlobalLists.reginalmanagerrole ||
                      role == GlobalLists.clientrole ||
                      role == GlobalLists.operationrole ||
                      role == GlobalLists.operationmanagerrole)
                  ?
                  //clientcheck
                  //      checkboxeslist.length <= 1 ? SizeConfig.blockSizeHorizontal * 9
                  //     : checkboxeslist.length <= 2  ? SizeConfig.blockSizeHorizontal * 14.5
                  //     : checkboxeslist.length <= 3  ? SizeConfig.blockSizeHorizontal * 22
                  //     : SizeConfig.blockSizeHorizontal * 40
                  //     : checkboxeslist.length <= 2 ? SizeConfig.blockSizeHorizontal * 40
                  //     : SizeConfig.blockSizeHorizontal * 70,
                  checkboxeslist.length <= 1
                      ? SizeConfig.blockSizeHorizontal * 9
                      : checkboxeslist.length <= 2
                          ? SizeConfig.blockSizeHorizontal * 14.4
                          : checkboxeslist.length <= 3
                              ? SizeConfig.blockSizeHorizontal * 22
                              : SizeConfig.blockSizeHorizontal * 30
                  : checkboxeslist.length <= 2
                      ? SizeConfig.blockSizeHorizontal * 40
                      : SizeConfig.blockSizeHorizontal * 70,
              // operation
              child: Scrollbar(
                thumbVisibility: true,
                // thumbVisibility: true,
                child: Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: ListView(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    children: [
                      //      Padding(
                      //   padding: const EdgeInsets.only(left: 5,right:5),
                      //   child: Divider(color: customcolor.greytext,thickness: 0.5,),
                      // ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: (role == GlobalLists.headrole ||
                                role == GlobalLists.reginalmanagerrole ||
                                role == GlobalLists.clientrole ||
                                role == GlobalLists.operationrole ||
                                role == GlobalLists.operationmanagerrole)
                            ? List.generate(
                                checkboxeslist.length,
                                (indexcheck) => ListTileTheme(
                                  horizontalTitleGap: 0,
                                  minVerticalPadding: 0,
                                  child: Theme(
                                      data: ThemeData(
                                          unselectedWidgetColor:
                                              customcolor.greytext),
                                      child:
                                          //mainlist[indexvalue].isenabledclick?
                                          Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8, bottom: 0, left: 8),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              width: SizeConfig
                                                      .blockSizeHorizontal *
                                                  60,
                                              child: Text(
                                                checkboxeslist[indexcheck]
                                                    .pointerName,
                                                style: AppFonts.headerStyle(
                                                    fontSize: 12,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            ),
                                            Text(
                                              checkboxeslist[indexcheck]
                                                          .checked ==
                                                      true
                                                  ? "Completed"
                                                  : "Pending",
                                              style: AppFonts.headerStyle(
                                                  fontSize: 12,
                                                  color:
                                                      checkboxeslist[indexcheck]
                                                                  .checked ==
                                                              true
                                                          ? customcolor.green
                                                          : customcolor.red,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                          ],
                                        ),
                                      )),
                                ),
                              )
                            : List.generate(
                                checkboxeslist.length,
                                (indexcheck) => ListTileTheme(
                                  horizontalTitleGap: 0,
                                  minVerticalPadding: 0,
                                  child: Theme(
                                      data: ThemeData(
                                          unselectedWidgetColor:
                                              customcolor.greytext),
                                      child:
                                          //mainlist[indexvalue].isenabledclick?
                                          CheckboxListTile(
                                        activeColor: customcolor.green,
                                        controlAffinity:
                                            ListTileControlAffinity.leading,
                                        contentPadding: EdgeInsets.zero,
                                        dense: true,
                                        title: Text(
                                          checkboxeslist[indexcheck]
                                              .pointerName,
                                          style: AppFonts.headerStyle(
                                              fontSize: 14,
                                              color: checkboxeslist[indexcheck]
                                                          .checked ==
                                                      true
                                                  ? customcolor.green
                                                  : Colors.black,
                                              fontWeight: FontWeight.normal),
                                        ),
                                        value:
                                            checkboxeslist[indexcheck].checked,
                                        onChanged:isUpdateButtonVisible? (value) {
                                          setStateDialgoue(() {
                                            checkboxeslist[indexcheck].checked =
                                                value!;
                                            print("multipleSelectedlist");
                                            print(multipleSelectedlist);
                                            print(checkboxeslist[indexcheck]);

                                            if (multipleSelectedlist.contains(
                                                checkboxeslist[indexcheck])) {
                                              multipleSelectedlist.remove(
                                                  checkboxeslist[indexcheck]);
                                            } else {
                                              multipleSelectedlist.add(
                                                  checkboxeslist[indexcheck]);
                                            }
                                          });
                                        }:null,
                                      )),
                                ),
                              ),
                      ),

                      (role == GlobalLists.headrole ||
                              role == GlobalLists.reginalmanagerrole ||
                              role == GlobalLists.clientrole ||
                              role == GlobalLists.operationrole ||
                              role == GlobalLists.operationmanagerrole)
                          ? Container()
                          : Column(
                              children: [
                                SizedBox(
                                  height: 15,
                                ),
                             isUpdateButtonVisible?    MyElevatedButton(
                                  setStyleStr: 'home',
                                  width: 120,
                                  height: SizeConfig.blockSizeVertical * 6,
                                  onPressed: () {
                                    print("multipleSelectedlist");
                                    // print(multipleSelectedlist.checklistId.toString());
                                    List<String> checkedid = [];
                                    List<String> uncheckedid = [];
                                    //  for(int i=0;i<multipleSelectedlist.length;i++)
                                    //  {
                                    //   checkedid.add(multipleSelectedlist[i].id.toString());
                                    //  }
                                    for (int i = 0;
                                        i < checkboxeslist.length;
                                        i++) {
                                      if (!checkboxeslist[i].checked) {
                                        uncheckedid.add(
                                            checkboxeslist[i].id.toString());
                                      } else {
                                        checkedid.add(
                                            checkboxeslist[i].id.toString());
                                      }
                                    }
                                    print("checkedid");
                                    print("Calledupdate");
                                    print("check $checkedid");
                                    print("uncheck $uncheckedid");
                                    print(masterareaid);
                                    print(bloackareaid);
                                    updatedworkflowstatusApi(
                                        widget.shiftid,
                                        checkedid,
                                        uncheckedid,
                                        masterareaid,
                                        bloackareaid);
                                  },
                                  borderRadius: BorderRadius.circular(5),
                                  colorvalue: customcolor.blue,
                                  child: Text('Update'),
                                ):Container(),
                              ],
                            ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      );
    });
  }

  Widget expandablenewoperationListView(
      int indexvalue,
      int tabindex,
      String title,
      List<newoperdetail.Checklist> checkboxeslist,
      List multipleSelectedlist,
      bool isExpanded,
      String masterareaid,
      String bloackareaid,
      int tabindexmain) {
    selectedindexmain = tabindex;
    // print("callinginit expandablenewoperationListView");
    //26mar
    GlobalLists.card_startcurrentdatevalue = GlobalLists
        .detailopeermainlisttab[0].details[tabindexmain].startTimeStr
        .toString();
    GlobalLists.card_endcurrentdatevalue = GlobalLists
        .detailopeermainlisttab[0].details[tabindexmain].endTimeStr
        .toString();
    GlobalLists.card_superviorfirtvalue = GlobalLists
        .detailopeermainlisttab[0].details[tabindexmain].supervisorName
        .toString();
    GlobalLists.card_percentvalue =
        GlobalLists.detailopeermainlisttab[0].totalPercentage.toString();
    print(selectedindexmain);
    GlobalLists.tabControllermain.addListener(() {
      print("callinginit expandablenewoperationListView");
      setState(() {
        tag = 0;
        GlobalLists.selectedindex = 0;
      });
    });

    debugPrint('List item build $indexvalue $isExpanded');
    debugPrint('List item build $checkboxeslist');

    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setStateDialgoue) {
      return Container(
        color: customcolor.white,
        margin: EdgeInsets.symmetric(vertical: 2.0),
        child: Column(
          children: <Widget>[
//
            Container(
              color: Colors.white,
              padding: EdgeInsets.only(left: 20, right: 10, top: 2, bottom: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: [
                      // Image.network(img, width: 25, height: 25, errorBuilder:
                      //     (BuildContext context, Object exception,
                      //         StackTrace? stackTrace) {
                      //   return Container();
                      // }),
                      // SizedBox(
                      //   width: 15,
                      // ),
                      Container(
                        width: SizeConfig.blockSizeHorizontal * 70,
                        child: Text(
                          title,
                          style: AppFonts.headerStyle(
                              fontSize: 16,
                              color: GlobalLists
                                          .detailopeermainlisttab[0]
                                          .details[tabindexmain]
                                          .masterAreaWiseList[tabindex]
                                          .blockData[indexvalue]
                                          .blockPending ==
                                      0
                                  ? customcolor.red
                                  : customcolor.green,
                              //changes7feb
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.black,
                    size: 30.0,
                  ),
                ],
              ),
            ),
            ExpandableContainer(
              expanded: isExpanded,
              expandedHeight: (role == GlobalLists.headrole ||
                      role == GlobalLists.reginalmanagerrole ||
                      role == GlobalLists.clientrole ||
                      role == GlobalLists.operationrole ||
                      role == GlobalLists.operationmanagerrole)
                  ?

                  //omcheck
                  checkboxeslist.length <= 1
                      ? SizeConfig.blockSizeHorizontal * 9
                      : checkboxeslist.length <= 2
                          ? SizeConfig.blockSizeHorizontal * 14.5
                          : checkboxeslist.length <= 3
                              ? SizeConfig.blockSizeHorizontal * 22
                              : checkboxeslist.length <= 4
                                  ? SizeConfig.blockSizeHorizontal * 27
                                  : checkboxeslist.length <= 5
                                      ? SizeConfig.blockSizeHorizontal * 34.8
                                      : SizeConfig.blockSizeHorizontal * 40
                  : checkboxeslist.length <= 2
                      ? SizeConfig.blockSizeHorizontal * 40
                      : SizeConfig.blockSizeHorizontal * 70,
              //new opertaion
              child: Scrollbar(
                thumbVisibility: true,
                // thumbVisibility: true,
                child: Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: ListView(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    children: [
                      //      Padding(
                      //   padding: const EdgeInsets.only(left: 5,right:5),
                      //   child: Divider(color: customcolor.greytext,thickness: 0.5,),
                      // ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: (role == GlobalLists.headrole ||
                                role == GlobalLists.reginalmanagerrole ||
                                role == GlobalLists.clientrole ||
                                role == GlobalLists.operationrole ||
                                role == GlobalLists.operationmanagerrole)
                            ? List.generate(
                                checkboxeslist.length,
                                (indexcheck) => ListTileTheme(
                                  horizontalTitleGap: 0,
                                  minVerticalPadding: 0,
                                  child: Theme(
                                      data: ThemeData(
                                          unselectedWidgetColor:
                                              customcolor.greytext),
                                      child:
                                          //mainlist[indexvalue].isenabledclick?
                                          Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8, bottom: 0, left: 8),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              width: SizeConfig
                                                      .blockSizeHorizontal *
                                                  60,
                                              child: Text(
                                                checkboxeslist[indexcheck]
                                                    .pointerName,
                                                style: AppFonts.headerStyle(
                                                    fontSize: 12,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            ),
                                            Text(
                                              checkboxeslist[indexcheck]
                                                          .checked ==
                                                      true
                                                  ? "Completed"
                                                  : "Pending",
                                              style: AppFonts.headerStyle(
                                                  fontSize: 12,
                                                  color:
                                                      checkboxeslist[indexcheck]
                                                                  .checked ==
                                                              true
                                                          ? customcolor.green
                                                          : customcolor.red,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                          ],
                                        ),
                                      )),
                                ),
                              )
                            : List.generate(
                                checkboxeslist.length,
                                (indexcheck) => ListTileTheme(
                                  horizontalTitleGap: 0,
                                  minVerticalPadding: 0,
                                  child: Theme(
                                      data: ThemeData(
                                          unselectedWidgetColor:
                                              customcolor.greytext),
                                      child:
                                          //mainlist[indexvalue].isenabledclick?
                                          CheckboxListTile(
                                        activeColor: customcolor.green,
                                        controlAffinity:
                                            ListTileControlAffinity.leading,
                                        contentPadding: EdgeInsets.zero,
                                        dense: true,
                                        title: Text(
                                          checkboxeslist[indexcheck]
                                              .pointerName,
                                          style: AppFonts.headerStyle(
                                              fontSize: 14,
                                              color: checkboxeslist[indexcheck]
                                                          .checked ==
                                                      true
                                                  ? customcolor.green
                                                  : Colors.black,
                                              fontWeight: FontWeight.normal),
                                        ),
                                        value:
                                            checkboxeslist[indexcheck].checked,
                                        onChanged:isUpdateButtonVisible? (value) {
                                          setStateDialgoue(() {
                                            checkboxeslist[indexcheck].checked =
                                                value!;
                                            print("multipleSelectedlist");
                                            print(multipleSelectedlist);
                                            print(checkboxeslist[indexcheck]);

                                            if (multipleSelectedlist.contains(
                                                checkboxeslist[indexcheck])) {
                                              multipleSelectedlist.remove(
                                                  checkboxeslist[indexcheck]);
                                            } else {
                                              multipleSelectedlist.add(
                                                  checkboxeslist[indexcheck]);
                                            }
                                          });
                                        }:null,
                                      )),
                                ),
                              ),
                      ),

                      (role == GlobalLists.headrole ||
                              role == GlobalLists.reginalmanagerrole ||
                              role == GlobalLists.clientrole ||
                              role == GlobalLists.operationrole ||
                              role == GlobalLists.operationmanagerrole)
                          ? Container()
                          : Column(
                              children: [
                                SizedBox(
                                  height: 15,
                                ),
                                MyElevatedButton(
                                  setStyleStr: 'home',
                                  width: 120,
                                  height: SizeConfig.blockSizeVertical * 6,
                                  onPressed: () {
                                    print("multipleSelectedlist");
                                    // print(multipleSelectedlist.checklistId.toString());
                                    List<String> checkedid = [];
                                    List<String> uncheckedid = [];
                                    //  for(int i=0;i<multipleSelectedlist.length;i++)
                                    //  {
                                    //   checkedid.add(multipleSelectedlist[i].id.toString());
                                    //  }
                                    for (int i = 0;
                                        i < checkboxeslist.length;
                                        i++) {
                                      if (!checkboxeslist[i].checked) {
                                        uncheckedid.add(
                                            checkboxeslist[i].id.toString());
                                      } else {
                                        checkedid.add(
                                            checkboxeslist[i].id.toString());
                                      }
                                    }
                                    print("checkedid");
                                    print("Calledupdate");
                                    print("check $checkedid");
                                    print("uncheck $uncheckedid");
                                    print(masterareaid);
                                    print(bloackareaid);
                                    updatedworkflowstatusApi(
                                        widget.shiftid,
                                        checkedid,
                                        uncheckedid,
                                        masterareaid,
                                        bloackareaid);
                                  },
                                  borderRadius: BorderRadius.circular(5),
                                  colorvalue: customcolor.blue,
                                  child: Text('Update'),
                                ),
                              ],
                            ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      );
    });
  }

  //new manager

  _buildChoiceList() {
    List<Widget> choices = [];
    listtab.forEachIndexed((item, value) {
      choices.add(Container(
        //  color: customcolor.darkorange,
        child: ChoiceChip(
          label: Text(
              // item.status
              item.masterAreaName),

          labelStyle: AppFonts.headerStyle(
              fontSize: ResponsiveFlutter.of(context).fontSize(1.6),
              color: tag == value
                  ? customcolor.white
                  : item.status == "Pending"
                      ? customcolor.white
                      : item.status == "Completed"
                          ? customcolor.green
                          : customcolor.white,
              fontWeight: FontWeight.w600),

          // selectedShadowColor: customcolor.blue,
          //shape: StadiumBorder(side: BorderSide(color:tag == value?customcolor.blue:customcolor.bg )),
          selectedColor:
              //  item.status=="Pending"?
              //   customcolor.red:
              //   item.status=="Completed"?customcolor.green.withOpacity(0.2):
              customcolor.blue,

          backgroundColor: tag == value
              ? customcolor.blue
              : item.status == "Pending"
                  ? customcolor.red
                  : item.status == "Completed"
                      ? customcolor.green.withOpacity(0.2)
                      : customcolor.blue,
          selected: tag == value,
          onSelected: (selected) {
            setState(() {
              _isSelected = item.masterAreaName;
              tag = value;
            });
          },
        ),
      ));
    });
    return choices;
  }

  //new manager detailoperationlisttab

  _buildnewoperationChoiceList() {
    List<Widget> choices = [];
    detailoperationlisttab.forEachIndexed((item, value) {
      choices.add(Container(
        //  color: customcolor.darkorange,
        child: ChoiceChip(
          label: Text(item.masterAreaName),
          labelStyle: AppFonts.headerStyle(
              fontSize: ResponsiveFlutter.of(context).fontSize(1.6),
              color: tag == value
                  ? customcolor.white
                  : item.status == "Pending"
                      ? customcolor.white
                      : item.status == "Completed"
                          ? customcolor.green
                          : customcolor.white,
              fontWeight: FontWeight.w600),

          // selectedColor:customcolor.blue,
          //shape: StadiumBorder(side: BorderSide(color:tag == value?customcolor.blue:customcolor.bg )),
          selectedColor:
              //  item.status=="Pending"?
              //   customcolor.red:
              //   item.status=="Completed"?customcolor.green.withOpacity(0.2):
              customcolor.blue,
          backgroundColor: item.status == "Pending"
              ? customcolor.red
              : item.status == "Completed"
                  ? customcolor.green.withOpacity(0.2)
                  : customcolor.blue,
          selected: tag == value,
          onSelected: (selected) {
            setState(() {
              //masterAreaName
              _isSelected = item.masterAreaName;
              tag = value;
              // print(tagvalue);
            });
          },
        ),
      ));
    });
    return choices;
  }

//operation ruchita chips

  //operation vishu chips
  _buildoperationChoiceList() {
    List<Widget> choices = [];
    operationlisttab.forEachIndexed((item, value) {
      choices.add(Container(
        //  color: customcolor.darkorange,
        child: ChoiceChip(
          label: Text(item.masterAreaName),
          labelStyle: AppFonts.headerStyle(
              fontSize: ResponsiveFlutter.of(context).fontSize(1.6),
              color: tag == value
                  ? customcolor.white
                  : item.status == "Pending"
                      ? customcolor.white
                      : item.status == "Completed"
                          ? customcolor.green
                          : customcolor.white,
              fontWeight: FontWeight.w600),

          // selectedColor:customcolor.blue,
          //shape: StadiumBorder(side: BorderSide(color:tag == value?customcolor.blue:customcolor.bg )),
          selectedColor:
              //  item.status=="Pending"?
              //   customcolor.red:
              //   item.status=="Completed"?customcolor.green.withOpacity(0.2):
              customcolor.blue,
          backgroundColor: item.status == "Pending"
              ? customcolor.red
              : item.status == "Completed"
                  ? customcolor.green.withOpacity(0.2)
                  : customcolor.blue,
          selected: tag == value,
          onSelected: (selected) {
            setState(() {
              _isSelected = item.masterAreaName;
              tag = value;
              // print('vishu workflow: masterAreaName ${_isSelected} : tag ${value}');
            });
          },
        ),
      ));
    });
    return choices;
  }

  // Map<String, List<worke.Datum>> GlobalLists.clientDetailsMap = {};

  workflowstatusApi(String shiftId) async {
    // Check Internet Connection
    if (!await ConnectionDetector.checkInternetConnection()) {
      // Try loading offline data
      final prefs = await SharedPreferences.getInstance();
      String? cachedData = prefs.getString('workflowstatusApi');

      if (cachedData != null) {
        final WorkfowstatusResponse resp =
            WorkfowstatusResponse.fromJson(jsonDecode(cachedData));

        setState(() {
          GlobalLists.workflowstatuslist = resp.data;
          GlobalLists.shiftavaialble = resp.shiftActive.toString();
          GlobalLists.multidays = resp.multidays;
          GlobalLists.start_time = resp.start_time;
          GlobalLists.end_time = resp.end_time;
          GlobalLists.total_supervisorercentage =
              resp.total_percentage.toString();

          GlobalLists.selectedindex = 0;
          for (int i = 0; i < GlobalLists.workflowstatuslist.length; i++) {
            final item = GlobalLists.workflowstatuslist[i];
            if (item.currentTime == true) {
              GlobalLists.selectedindex = i;
              if (item.priority_status == 1) break;
            }
          }

          final selectedItem =
              GlobalLists.workflowstatuslist[GlobalLists.selectedindex];
          GlobalLists.card_startcurrentdatevalue = selectedItem.startTime;
          GlobalLists.card_endcurrentdatevalue = selectedItem.endTime;
          GlobalLists.card_superviorfirtvalue =
              "${selectedItem.clientName} - ${selectedItem.siteName}";
          GlobalLists.card_percentvalue = GlobalLists.total_supervisorercentage;

          GlobalLists.tabsmain = List.generate(
            GlobalLists.workflowstatuslist.length,
            (i) => Tab(
              child: Text(
                "${GlobalLists.workflowstatuslist[i].startTime} - ${GlobalLists.workflowstatuslist[i].endTime}",
                style: TextStyle(
                  color:
                      _getStatusColor(GlobalLists.workflowstatuslist[i].status),
                ),
              ),
            ),
          );

          GlobalLists.tabControllermain = TabController(
            vsync: this,
            length: GlobalLists.workflowstatuslist.length,
            initialIndex: GlobalLists.selectedindex,
          );

          _tabController = TabController(vsync: this, length: 5);
          isdataloaded = true;
        });

        ShowDialogs.showToast("Offline data loaded");
      } else {
        ShowDialogs.showToast("Please check internet connection");
      }

      return;
    }

    // Online case
    // ShowDialogs.showLoadingDialog(context, _keyLoader);

    setState(() {
      GlobalLists.isWorflowLoading.value = true;
      // GlobalLists.workflowstatuslist = [];
    });

    final map = {
      'shift_id': shiftId,
      'client_id': GlobalLists.clientid,
      'site_id': GlobalLists.siteid,
      'today_date': GlobalLists.datecontroller.text,
    };

    APIManager().apiRequest(
      context,
      API.workflowstatus,
      (response) async {
        final WorkfowstatusResponse resp = response;

        if (resp.status != 1) {
          setState(() => isdataloaded = false);
          GlobalLists.isWorflowLoading.value = false;
          // Navigator.of(context).pop();
          return;
        }

        setState(() {
          GlobalLists.isShiftActive=resp.shiftActive;
          GlobalLists.workflowstatuslist = resp.data;
          GlobalLists.shiftavaialble = resp.shiftActive.toString();
          GlobalLists.multidays = resp.multidays;
          GlobalLists.start_time = resp.start_time;
          GlobalLists.end_time = resp.end_time;
          GlobalLists.total_supervisorercentage =
              resp.total_percentage.toString();

          GlobalLists.selectedindex = 0;

          for (int i = 0; i < GlobalLists.workflowstatuslist.length; i++) {
            final item = GlobalLists.workflowstatuslist[i];
            if (item.currentTime == true) {
              GlobalLists.selectedindex = i;
              if (item.priority_status == 1) break;
            }
          }

          final selectedItem =
              GlobalLists.workflowstatuslist[GlobalLists.selectedindex];
          GlobalLists.card_startcurrentdatevalue = selectedItem.startTime;
          GlobalLists.card_endcurrentdatevalue = selectedItem.endTime;
          GlobalLists.card_superviorfirtvalue =
              "${selectedItem.clientName} - ${selectedItem.siteName}";
          GlobalLists.card_percentvalue = GlobalLists.total_supervisorercentage;

          GlobalLists.tabsmain = List.generate(
            GlobalLists.workflowstatuslist.length,
            (i) => Tab(
              child: Text(
                "${GlobalLists.workflowstatuslist[i].startTime} - ${GlobalLists.workflowstatuslist[i].endTime}",
                style: TextStyle(
                  color:
                      _getStatusColor(GlobalLists.workflowstatuslist[i].status),
                ),
              ),
            ),
          );

          GlobalLists.tabControllermain = TabController(
            vsync: this,
            length: GlobalLists.workflowstatuslist.length,
            initialIndex: GlobalLists.selectedindex,
          );

          _tabController = TabController(vsync: this, length: 5);
          isdataloaded = true;
        });

        // Save response to offline
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
          'workflowstatusApi',
          jsonEncode(resp.toJson()),
        );
        setState(() {
          GlobalLists.isWorflowLoading.value = false;
        });
        // Navigator.of(context).pop();
      },
      (error) {
        setState(() {
          GlobalLists.isWorflowLoading.value = false;
        });
        // Navigator.of(context).pop();
        ShowDialogs.showToast("Server Not Responding");
      },
      false,
      "",
      jsonval: map,
    );
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case "Pending":
        return customcolor.red;
      case "Completed":
        return customcolor.green;
      default:
        return customcolor.blue;
    }
  }

  //operationalworkfloe
  operationlworkflowstatusApi() async {
    var status1 = await ConnectionDetector.checkInternetConnection();

    var clientid = await SPManager().getclientid();
    var map = {
      'today_date': GlobalLists.datecontroller.text,
    };
    if (role == GlobalLists.clientrole) {
      map['clientid'] = clientid.toString();
    }

    if (status1) {
      setState(() {
        GlobalLists.isWorflowLoading.value = true;
      });
      APIManager().apiRequest(context, API.operationalworkflow,
          (response) async {
        operwf.OperationalWorkflowResponse resp = response;

        if (resp.status == 1) {
          setState(() {
            GlobalLists.mainlisttabs = resp.data;
            GlobalLists.operationalworkflowstatuslist = resp.data;
            GlobalLists.selectedindex = 0;
            GlobalLists.tabsmain = <Tab>[];

            for (int i = 0; i < resp.data.length; i++) {
              if (resp.data[i].clientName == widget.clientname) {
                GlobalLists.maintag = i;
              }
            }

            _updateCardValues();
            _generateTabs();

            GlobalLists.tabControllermain = TabController(
              vsync: this,
              length:
                  GlobalLists.mainlisttabs[GlobalLists.maintag].details.length,
              initialIndex: GlobalLists.selectedindex,
            );

            isdataloaded = true;
            setState(() {
              GlobalLists.isWorflowLoading.value = false;
            });
            // Navigator.of(context).pop();
          });

          // ✅ Cache response locally
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(
            'cached_operationalworkflow',
            jsonEncode(resp.toJson()),
          );
        } else {
          setState(() {
            isdataloaded = false;
          });
          // Navigator.of(context).pop();
          setState(() {
            GlobalLists.isWorflowLoading.value = false;
          });
        }
      }, (error) {
        print('ERR msg is $error');
        Navigator.of(context).pop();
        ShowDialogs.showToast("Server Not Responding");
      }, false, "", jsonval: map);
    } else {
      // 🚫 No internet – Load from cache
      final prefs = await SharedPreferences.getInstance();
      String? cachedData = prefs.getString('cached_operationalworkflow');

      if (cachedData != null) {
        final decoded = jsonDecode(cachedData);
        operwf.OperationalWorkflowResponse cachedResponse =
            operwf.OperationalWorkflowResponse.fromJson(decoded);

        setState(() {
          GlobalLists.mainlisttabs = cachedResponse.data;
          GlobalLists.operationalworkflowstatuslist = cachedResponse.data;
          GlobalLists.selectedindex = 0;
          GlobalLists.tabsmain = <Tab>[];

          for (int i = 0; i < cachedResponse.data.length; i++) {
            if (cachedResponse.data[i].clientName == widget.clientname) {
              GlobalLists.maintag = i;
            }
          }

          _updateCardValues();
          _generateTabs();

          GlobalLists.tabControllermain = TabController(
            vsync: this,
            length:
                GlobalLists.mainlisttabs[GlobalLists.maintag].details.length,
            initialIndex: GlobalLists.selectedindex,
          );

          isdataloaded = true;
        });

        ShowDialogs.showToast("Loaded offline data");
      } else {
        ShowDialogs.showToast("No internet and no cached data available");
      }
    }
  }

  void _updateCardValues() {
    var details = GlobalLists.mainlisttabs[GlobalLists.maintag].details;
    for (int i = 0; i < details.length; i++) {
      if (details[i].currentTime == true && details[i].priority_status == 1) {
        GlobalLists.selectedindex = i;
        break;
      } else if (details[i].currentTime == true) {
        GlobalLists.selectedindex = i;
        break;
      }
    }

    GlobalLists.card_startcurrentdatevalue =
        details[GlobalLists.selectedindex].startTimeStr.toString();
    GlobalLists.card_endcurrentdatevalue =
        details[GlobalLists.selectedindex].endTimeStr.toString();
    GlobalLists.card_superviorfirtvalue =
        details[GlobalLists.selectedindex].supervisorName.toString();
    GlobalLists.card_percentvalue = GlobalLists
        .mainlisttabs[GlobalLists.maintag].totalPercentage
        .toString();
  }

  void _generateTabs() {
    var details = GlobalLists.mainlisttabs[GlobalLists.maintag].details;
    GlobalLists.tabsmain.clear();
    for (int i = 0; i < details.length; i++) {
      GlobalLists.tabsmain.add(
        Tab(
          child: Text(
            "${details[i].startTimeStr}-${details[i].endTimeStr}",
            style: TextStyle(
              color: details[i].status == "Pending"
                  ? customcolor.red
                  : details[i].status == "Completed"
                      ? customcolor.green
                      : customcolor.blue,
            ),
          ),
        ),
      );
    }
  }

  //new manager apis
  operationlManagerworkflowstatusApi() async {
    var status1 = await ConnectionDetector.checkInternetConnection();

    var supervisorid = await SPManager().getsupervisorid();
    var map = {
      'supervisor': supervisorid,
      'date_today': GlobalLists.datecontroller.text,
    };

    if (status1) {
      setState(() {
        GlobalLists.isWorflowLoading.value = true;
      });
      APIManager().apiRequest(
        context,
        API.workflowoperational,
        (response) async {
          newopera.Workflowoperationalmodel resp = response;
          print('Anand API ${resp.data}');

          if (resp.status == 1) {
            setState(() {
              GlobalLists.operationalmainlisttab = resp.data;
              GlobalLists.maintag = 0;
              GlobalLists.selectedindex = 0;

              operationlManagerdetailworkflowstatusApi(
                resp.data[0].clientId.toString(),
                resp.data[0].siteId.toString(),
              );
            });

            final prefs = await SharedPreferences.getInstance();
            await prefs.setString(
              'workflowOperationalCache',
              jsonEncode(resp.toJson()),
            );
            setState(() {
              GlobalLists.isWorflowLoading.value = false;
            });
            // Navigator.of(context).pop();
          } else {
            setState(() {
              isdataloaded = false;
            });
            setState(() {
              GlobalLists.isWorflowLoading.value = false;
            });
            // Navigator.of(context).pop();
          }
        },
        (error) {
          print('ERR msg is $error');
          Navigator.of(context).pop();
          ShowDialogs.showToast("Server Not Responding");
        },
        false,
        "",
        jsonval: map,
      );
    } else {
      final prefs = await SharedPreferences.getInstance();
      String? cachedData = prefs.getString('workflowOperationalCache');

      if (cachedData != null) {
        final decoded = jsonDecode(cachedData);
        newopera.Workflowoperationalmodel cachedResponse =
            newopera.Workflowoperationalmodel.fromJson(decoded);

        setState(() {
          GlobalLists.operationalmainlisttab = cachedResponse.data;
          GlobalLists.maintag = 0;
          GlobalLists.selectedindex = 0;

          if (cachedResponse.data != null && cachedResponse.data!.isNotEmpty) {
            operationlManagerdetailworkflowstatusApi(
              cachedResponse.data![0].clientId.toString(),
              cachedResponse.data![0].siteId.toString(),
            );
          }
        });

        ShowDialogs.showToast("Loaded offline data");
      } else {
        ShowDialogs.showToast("No internet and no cached data available");
      }
    }
  }

  //new manager detail apis
//changes off for client
  operationlManagerdetailworkflowstatusApi(
    String client_id,
    String site_id,
  ) async {
    try {
      var status1 = await ConnectionDetector.checkInternetConnection();
      var map = {
        'clientid': client_id,
        'siteid': site_id,
        'today_date': GlobalLists.datecontroller.text,
      };

      if (status1) {
        setState(() {
          GlobalLists.isWorflowLoading.value = true;
        });

        setState(() {
          GlobalLists.detailopeermainlisttab = [];
        });

        APIManager().apiRequest(
          context,
          API.workflowoperationaldetail,
          (response) async {
            try {
              newoperdetail.WorkflowoperationalDetailmodel resp = response;

              if (resp.status == 1) {
                setState(() {
                  GlobalLists.detailopeermainlisttab = resp.data;
                  GlobalLists.tabsmain = [];
                  GlobalLists.selectedindex = 0;

                  updateTabData(resp);
                  isdataloaded = true;
                  setState(() {
                    GlobalLists.isWorflowLoading.value = false;
                  });
                  // Navigator.of(this.context).pop();
                });

                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString("workflow_response", jsonEncode(resp.toJson()));

                /// ✅ FIX: Store the entire response, not just `data`
                String clientIdKey = client_id;
                if (!GlobalLists.clientDetailsMap.containsKey(clientIdKey)) {
                  GlobalLists.clientDetailsMap[clientIdKey] = [];
                }
                GlobalLists.clientDetailsMap[clientIdKey]!
                    .addAll(resp.data); // ✅ Correct
// 👈 FIXED LINE
              } else {
                setState(() {
                  isdataloaded = true;
                });
                setState(() {
                  GlobalLists.isWorflowLoading.value = false;
                });
                // Navigator.of(this.context).pop();
              }
            } catch (e) {
              print("Parsing Error: $e");
              setState(() {
                GlobalLists.isWorflowLoading.value = false;
              });
              // Navigator.of(this.context).pop();
              ShowDialogs.showToast("Something went wrong");
            }
          },
          (error) {
            print('ERR msg is $error');
            setState(() {
              GlobalLists.isWorflowLoading.value = false;
            });
            // Navigator.of(this.context).pop();
            ShowDialogs.showToast("Server Not Responding");
          },
          false,
          "",
          jsonval: map,
        );
      } else {
        /// 👉 Offline Mode
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? cached = prefs.getString("workflow_response");

        if (cached != null) {
          try {
            var decoded = jsonDecode(cached);
            newoperdetail.WorkflowoperationalDetailmodel resp =
                newoperdetail.WorkflowoperationalDetailmodel.fromJson(decoded);

            setState(() {
              GlobalLists.detailopeermainlisttab = resp.data;
              GlobalLists.tabsmain = [];
              GlobalLists.selectedindex = 0;
              updateTabData(resp);
              isdataloaded = true;
            });

            /// ✅ FIX: Add full response object, not just `data`
            String clientIdKey = client_id;
            if (!GlobalLists.clientDetailsMap.containsKey(clientIdKey)) {
              GlobalLists.clientDetailsMap[clientIdKey] = [];
            }
            GlobalLists.clientDetailsMap[clientIdKey]!
                .addAll(resp.data); // ✅ Correct
            // 👈 FIXED LINE
          } catch (e) {
            print("Error reading offline data: $e");
            ShowDialogs.showToast("Failed to load offline data");
          }
        } else {
          ShowDialogs.showToast("No offline data available");
        }
      }
    } catch (e) {
      print("API Exception: $e");
      ShowDialogs.showToast("Unexpected error occurred");
      setState(() {
        GlobalLists.isWorflowLoading.value = false;
      });
      // Navigator.of(this.context).pop();
    }
  }

  void updateTabData(newoperdetail.WorkflowoperationalDetailmodel resp) {
    GlobalLists.card_startcurrentdatevalue =
        resp.data[0].details[GlobalLists.selectedindex].startTimeStr.toString();
    GlobalLists.card_endcurrentdatevalue =
        resp.data[0].details[GlobalLists.selectedindex].endTimeStr.toString();
    GlobalLists.card_superviorfirtvalue =
        resp.data[0].superviourName.toString();
    GlobalLists.card_percentvalue = resp.data[0].totalPercentage.toString();

    for (int i = 0; i < resp.data[0].details.length; i++) {
      GlobalLists.tabsmain.add(
        Tab(
          child: Text(
            "${resp.data[0].details[i].startTimeStr} - ${resp.data[0].details[i].endTimeStr}",
            style: TextStyle(
              color: resp.data[0].details[i].status == "Pending"
                  ? customcolor.red
                  : resp.data[0].details[i].status == "Completed"
                      ? customcolor.green
                      : customcolor.blue,
            ),
          ),
        ),
      );
    }

    for (int i = 0; i < resp.data[0].details.length; i++) {
      if (resp.data[0].details[i].currentTime == true) {
        GlobalLists.selectedindex = i;
        GlobalLists.card_startcurrentdatevalue =
            resp.data[0].details[i].startTimeStr.toString();
        GlobalLists.card_endcurrentdatevalue =
            resp.data[0].details[i].endTimeStr.toString();
        GlobalLists.card_superviorfirtvalue =
            resp.data[0].details[i].supervisorName.toString();
        GlobalLists.card_percentvalue = resp.data[0].totalPercentage.toString();
        break;
      }
    }

    GlobalLists.tabControllermain = TabController(
        vsync: this,
        length: resp.data[0].details.length,
        initialIndex: GlobalLists.selectedindex);
  }

  void _scrollToTab(int index) {
    // Calculate the position to scroll to
    double scrollTo = index * 100.0; // Adjust based on tab width or padding

    // Scroll to the calculated position
    _scrollControllerbuttontab.animateTo(
      scrollTo,
      duration: Duration(milliseconds: 500), // Adjust duration as needed
      curve: Curves.easeInOut,
    );
  }

  bool isworkflowUpdated = false;
  updatedworkflowstatusApi(
    String shiftid,
    List<String> checklistid,
    List<String> unchecklistid,
    String masterid,
    String blockid,
  ) async {
    var isOnline = await ConnectionDetector.checkInternetConnection();

    Map<String, dynamic> jsonbody = {
      "shift_id": shiftid,
      "master_area_id": masterid,
      "master_block_id": blockid,
      "check_list_id": checklistid,
      "uncheck_list_id": unchecklistid,
      "date": finaldateselecter,
    };

    if (isOnline) {
      // ShowDialogs.showLoadingDialog(context, _keyLoader);
      setState(() {
        isworkflowUpdated = true;
      });
      APIManager().apiRequest(
        context,
        API.updatedworkflowstatus,
        (response) async {
          UpdatedworkflowResponse resp = response;

          if (resp.status == 1) {
            ShowDialogs.showToast(resp.msg);
            // Navigator.of(context).pop();
            setState(() {
              isworkflowUpdated = false;
            });
            // ✅ Updated local GlobalLists.workflowstatuslist
            for (var area in GlobalLists.workflowstatuslist) {
              if (area.shift.toString() == shiftid) {
                for (var masterArea in area.masterAreaWiseList) {
                  if (masterArea.masterArea == masterid) {
                    for (var block in masterArea.blockData) {
                      if (block.masterBlock == blockid) {
                        for (var checklistItem in block.checklist) {
                          if (checklistid
                              .contains(checklistItem.id.toString())) {
                            checklistItem.checked = true;
                          }
                          if (unchecklistid
                              .contains(checklistItem.id.toString())) {
                            checklistItem.checked = false;
                          }
                        }
                      }
                    }
                  }
                }
              }
            }

            // ✅ Save updated list to SharedPreferences
            await saveWorkflowStatusToPrefs();

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => WorkflowstatusOperation(
                  GlobalLists.shiftid,
                  false,
                  "",
                  "",
                  widget.clientname,
                  finaldateselecter,
                ),
              ),
            );
          } else {
            ShowDialogs.showToast(resp.msg);
            setState(() {
              isworkflowUpdated = false;
            });
            // Navigator.of(context).pop();
          }
        },
        (error) {
          print('ERR msg is $error');
          Navigator.of(context).pop();
        },
        false,
        "",
        parameter: jsonbody,
      );
    } else {
      // 🔁 Offline mode: update local checklist + queue for sync
      await DBHelper.insertOfflineRequest(
        '${Global.baseUrl}/api/siteconfigurator/update_work_status',
        jsonbody,
        isMultipart: false,
      );

      // ✅ Updated in-memory list
      for (var area in GlobalLists.workflowstatuslist) {
        if (area.shift.toString() == shiftid) {
          for (var masterArea in area.masterAreaWiseList) {
            if (masterArea.masterArea == masterid) {
              for (var block in masterArea.blockData) {
                if (block.masterBlock == blockid) {
                  for (var checklistItem in block.checklist) {
                    if (checklistid.contains(checklistItem.id.toString())) {
                      checklistItem.checked = true;
                    }
                    if (unchecklistid.contains(checklistItem.id.toString())) {
                      checklistItem.checked = false;
                    }
                  }
                }
              }
            }
          }
        }
      }

      // ✅ Save updated list to SharedPreferences
      await saveWorkflowStatusToPrefs();

      ShowDialogs.showToast("📴 Offline update saved. UI updated.");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => WorkflowstatusOperation(
            GlobalLists.shiftid,
            false,
            "",
            "",
            widget.clientname,
            finaldateselecter,
          ),
        ),
      );
    }
  }

  Future<void> saveWorkflowStatusToPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    final updatedResponse = WorkfowstatusResponse(
      status: 1,
      msg: "Cached",
      data: GlobalLists.workflowstatuslist,
      shiftActive: int.tryParse(GlobalLists.shiftavaialble.toString()) ?? 0,
      multidays: GlobalLists.multidays,
      start_time: GlobalLists.start_time,
      end_time: GlobalLists.end_time,
      total_percentage:
          double.tryParse(GlobalLists.total_supervisorercentage) ?? 0.0,
    );

    String newJson = jsonEncode(updatedResponse.toJson());
    String? existingJson = prefs.getString('workflowstatusApi');

    if (existingJson != newJson) {
      await prefs.setString('workflowstatusApi', newJson);
      print("✅ workflowstatusApi updated in SharedPreferences");
    } else {
      print("ℹ️ No change detected. Skipping SharedPreferences update.");
    }
  }
}

class ExpandableContainer extends StatelessWidget {
  final bool expanded;
  final double collapsedHeight;
  final double expandedHeight;
  final Widget child;

  ExpandableContainer({
    required this.child,
    this.collapsedHeight = 0.0,
    this.expandedHeight = 300.0,
    this.expanded = true,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      width: screenWidth,
      height: expanded ? expandedHeight : collapsedHeight,
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 20),
        // child: Divider(
        //   color: customcolor.greyborder,
        // ),
        child: Container(
          //  color: Colors.black,
          child: child,
          // decoration: BoxDecoration(
          //     border: Border.all(width: 0.2, color: customcolor.greyborder)),
        ),
      ),
    );
  }
}
