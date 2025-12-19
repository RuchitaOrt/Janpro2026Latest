import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:janpro/Screens/Attendance.dart';
import 'package:janpro/Screens/Homepage.dart';
import 'package:janpro/Utitlity/APIManager.dart';
import 'package:janpro/Utitlity/AppDrawer.dart';
import 'package:janpro/Utitlity/Dropbutton.dart';
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
import 'package:janpro/Utitlity/sizeConfig.dart';
import 'package:janpro/model/DashboardlistResponse.dart';
import 'package:janpro/model/OperationalPrioritylistResponse.dart'
    as operpriority;
import 'package:janpro/model/UpdatedworkflowResponse.dart';

import 'package:percent_indicator/circular_percent_indicator.dart';


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

class PendingWorkflowstatus extends StatefulWidget {
  final String title;
  final String shiftid;
  List<Detail> pendingTaskDetail;

  PendingWorkflowstatus(this.title, this.shiftid, this.pendingTaskDetail);

  @override
  _PendingWorkflowstatusState createState() => _PendingWorkflowstatusState();
}

class _PendingWorkflowstatusState extends State<PendingWorkflowstatus>
    with TickerProviderStateMixin {
  bool expand = true;
  List<operpriority.Datum> mainlisttab = [];
  final GlobalKey<ScaffoldState> _scaffoldKey1 = new GlobalKey<ScaffoldState>();
  int selectedindex = 0;
  int selectedindexmain = 0;

  // bool enabled = false;
  int? tapped;
  var statuscontroller = new TextEditingController();
  var namecontroller = new TextEditingController();
  List<Tab> tabs = <Tab>[];
  List<MasterAreaWiseList> listtab = [];
  List<Tab> tabsmain = <Tab>[];
  bool isdataloaded = false;
  String _isSelected = "";
  var datecontroller = new TextEditingController();

  var mobilecontroller = new TextEditingController();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  var selectedDateTime;
  double yOffset = 0;
  double xOffset = 0;
  double pageScale = 1;
  String selectedValue = "Pending";
  late TabController _tabController;
  late TabController _tabControllermain;
  double _value = 40.0;
  List<Widget> listoftabwiget = [];
  List<Widget> listoftabwigetmain = [];
  int maintag = 0;

  // ];
  List mainlist = [];
  bool isoptionopen = false;
  List<String> options = [
    "TAT",
    "Dependent",
    "Resolved",
  ];
  List<String>? formValue1;
  int tag = 0;

  @override
  void initState() {
    super.initState();

    isdataloaded = true;
    var datefrom = DateFormat('dd-MM-yyyy').format(DateTime.now());
    datecontroller.text = datefrom;
    getrole();
  }

  String role = "";

  getrole() async {
    role = (await SPManager().getroleid())!;
    operationlworkflowstatusApi();
    if (role == GlobalLists.unitrole ||
        role == GlobalLists.headrole ||
        role == GlobalLists.reginalmanagerrole ||
        role == GlobalLists.clientrole ||
        role == GlobalLists.operationrole ||
        role == GlobalLists.operationmanagerrole) {
      setState(() {
        // mainlisttab.add(MainList("IMAX","1"));
        //  mainlisttab.add(MainList("Cinipol","1"));
        //   mainlisttab.add(MainList("Cinimax","0"));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: customcolor.greybg,
      resizeToAvoidBottomInset: false,
      endDrawer: Theme(
        data: Theme.of(context).copyWith(
            canvasColor: customcolor.blue, primaryColor: customcolor.blue),
        child: AppDrawerfilter(role),
      ),

      key: _scaffoldKey1,
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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

      /// bottomNavigationBar: CustomBottomNavigationBar(index: 1),
      body:isOperWorkFlowLoaded?Center(child: Column(
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
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 10, right: 10, top: 10, bottom: 10),
              child: (role == GlobalLists.operationrole ||
                      role == GlobalLists.headrole ||
                      role == GlobalLists.reginalmanagerrole ||
                      role == GlobalLists.operationmanagerrole)
                  ? ListView(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      children: [
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Icon(Icons.arrow_back)),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  child: Text(
                                    "${widget.title}",
                                    style: AppFonts.headerStyle(
                                        fontSize: ResponsiveFlutter.of(context)
                                            .fontSize(2.3),
                                        color: customcolor.title,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                              ],
                            ),
                            (role == GlobalLists.unitrole ||
                                    role == GlobalLists.headrole ||
                                    role == GlobalLists.reginalmanagerrole ||
                                    role == GlobalLists.clientrole ||
                                    role == GlobalLists.operationrole ||
                                    role == GlobalLists.operationmanagerrole)
                                ? new Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    width: SizeConfig.blockSizeHorizontal * 32,
                                    height: 30,
                                    // padding: EdgeInsets.only(left: 6,bottom: 5,top:3,right: 5),
                                    child: new Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        // new Expanded(child: new Text("Bemerkung",)),
                                        new Expanded(
                                          child: new TextField(
                                            textAlignVertical:
                                                TextAlignVertical.center,
                                            textAlign: TextAlign.center,
                                            style: AppFonts.headerStyle(
                                                fontSize: ResponsiveFlutter.of(
                                                        context)
                                                    .fontSize(1.6),
                                                color: customcolor.black,
                                                fontWeight: FontWeight.w300),
                                            readOnly: true,
                                            onTap: () async {
                                              DateTime? pickedDate =
                                                  await showDatePicker(
                                                      context: context,
                                                      initialDate:
                                                          selectedDateTime ??
                                                              DateTime.now(),
                                                      firstDate: DateTime(1950),
                                                      lastDate: DateTime(2050));

                                              if (pickedDate != null) {
                                                var datefrom =  DateFormat('dd-MM-yyyy')  .format(pickedDate);
                                                datecontroller.text = datefrom;
                                                print(datecontroller.text);
                                                setState(() =>
                                                    selectedDateTime =
                                                        pickedDate);
                                                if (role ==
                                                        GlobalLists.unitrole ||
                                                    role ==
                                                        GlobalLists
                                                            .operationrole ||
                                                    role ==
                                                        GlobalLists.headrole ||
                                                    role ==
                                                        GlobalLists
                                                            .reginalmanagerrole ||
                                                    role ==
                                                        GlobalLists
                                                            .clientrole ||
                                                    role ==
                                                        GlobalLists
                                                            .operationmanagerrole) {
                                                  print("unit");
                                                  operationlworkflowstatusApi();
                                                }
                                              }
                                            },
                                            controller: datecontroller,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              contentPadding: EdgeInsets.zero,
                                              isDense: true,
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            DateTime? pickedDate =
                                                await showDatePicker(
                                                    context: context,
                                                    initialDate:
                                                        selectedDateTime ??
                                                            DateTime.now(),
                                                    firstDate: DateTime(1950),
                                                    lastDate: DateTime(2050));

                                            if (pickedDate != null) {
                                              var datefrom =
                                                  DateFormat('dd-MM-yyyy')
                                                      .format(pickedDate);
                                              datecontroller.text = datefrom;
                                              setState(() => selectedDateTime =
                                                  pickedDate);
                                              print(datecontroller.text);
                                              if (role ==
                                                      GlobalLists.unitrole ||
                                                  role ==
                                                      GlobalLists
                                                          .operationrole ||
                                                  role ==
                                                      GlobalLists.headrole ||
                                                  role ==
                                                      GlobalLists
                                                          .reginalmanagerrole ||
                                                  role ==
                                                      GlobalLists.clientrole ||
                                                  role ==
                                                      GlobalLists
                                                          .operationmanagerrole) {
                                                print("unit");
                                                operationlworkflowstatusApi();
                                              }
                                            }
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                bottom: 1, right: 5),
                                            child: Image.asset(
                                              'assets/images/calendar.png',
                                              width: 22,
                                              height: 22,
                                              alignment: Alignment.center,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Container()
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        (role == GlobalLists.operationrole ||
                                role == GlobalLists.headrole ||
                                role == GlobalLists.reginalmanagerrole ||
                                role == GlobalLists.operationmanagerrole)
                            ? mainlisttab.length > 0
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, bottom: 5),
                                    child: Container(
                                      height: 25,
                                      child: ListView(
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,
                                        physics: ScrollPhysics(),
                                        children: _buildChoicemainList(),
                                      ),
                                    )
                                    //  Wrap(
                                    //      spacing: 5.0,
                                    //      runSpacing: 3.0,
                                    //      children: _buildChoicemainList(),
                                    //    ),
                                    )
                                : Container()
                            : Container(),
                        mainlisttab.length > 0
                            ? masteroperationalarea(0)
                            : Container()
                      ],
                    )
                  : widget.pendingTaskDetail.length == 0
                      ? Container(
                          child: Center(child: Text("No priority Task")),
                        )
                      : Container(
                          child: ListView(
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            children: [
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Icon(Icons.arrow_back)),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    child: Text(
                                      "${widget.title}",
                                      style: AppFonts.headerStyle(
                                          fontSize:
                                              ResponsiveFlutter.of(context)
                                                  .fontSize(2.3),
                                          color: customcolor.title,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              isdataloaded == false
                                  ? Container()
                                  : masterarea(0),
                            ],
                          ),
                        ),
            ),
          ),
        ],
      ),
    );
  }

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
                        : item.details[0].status == "Pending"
                            ? customcolor.red
                            : customcolor.greytext,
                    fontWeight: FontWeight.bold),
              ),
            ),
            side: BorderSide(
                width: 0.5,
                color: maintag == value
                    ? customcolor.white
                    : item.details[0].status == "Pending"
                        ? customcolor.red
                        : customcolor.white),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10))),
            labelStyle: AppFonts.headerStyle(
                fontSize: 12,
                color:
                    maintag == value ? customcolor.blue : customcolor.greytext,
                fontWeight: FontWeight.bold),
            selectedColor: customcolor.tabblue,
            backgroundColor: customcolor.white,
            selected: maintag == value,
            onSelected: (selected) {
              setState(() {
                _isSelected = item.clientName;
                maintag = value;
                tag = 0;
              });
            },
          ),
        ),
      ));
    });
    return choices;
  }

  masterarea(int tabindexmain) {
    //selectedindexmain=1;
    print("MASTERARE");
    // print(tabindexmain);
    tabs = [];
    listtab = [];
    String status = "";
    _tabController = new TabController(
      vsync: this,
      length:
          //      5
          widget.pendingTaskDetail[tabindexmain].masterAreaWiseList.length,
    );

    print("TABCONTROLE ${_tabController.index.toString()}");
    print("selectedindexmain ${selectedindexmain.toString()}");
    for (int j = 0;
        j < widget.pendingTaskDetail[tabindexmain].masterAreaWiseList.length;
        j++) {
      setState(() {
        listtab
            .add(widget.pendingTaskDetail[tabindexmain].masterAreaWiseList[j]);
        status =
            widget.pendingTaskDetail[tabindexmain].masterAreaWiseList[j].status;
        tabs.add(
          new Tab(
            child: Container(
              // height: 35,
              width: SizeConfig.blockSizeHorizontal * 25,
              decoration: j == selectedindexmain
                  ? BoxDecoration(
                      color: customcolor.blue,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    )
                  : BoxDecoration(
                      color: widget.pendingTaskDetail[tabindexmain]
                                  .masterAreaWiseList[j].status ==
                              "Pending"
                          ? customcolor.darkorange
                          : customcolor.blue.withOpacity(0.2),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
              child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "${widget.pendingTaskDetail[tabindexmain].masterAreaWiseList[j].masterAreaName}",
                    style: AppFonts.headerStyle(
                        fontSize: 12,
                        color: customcolor.white,
                        fontWeight: FontWeight.normal),
                  )),
            ),
          ),
        );
      });
      print("forloop");
      print("tab of masrter");
      print(tabs.length);

      for (int k = 0;
          k <
              widget.pendingTaskDetail[tabindexmain].masterAreaWiseList[j]
                  .blockData.length;
          k++) {
        setState(() {
          mainlist.add(PendingTask(
            maintaskname: widget.pendingTaskDetail[tabindexmain]
                .masterAreaWiseList[j].blockData[k].masterAreaName,
            listvalue: widget.pendingTaskDetail[tabindexmain]
                .masterAreaWiseList[j].blockData[k].checklist,
            multipleSelected: [],
            isenabledclick: false,
            masterareaid: widget.pendingTaskDetail[tabindexmain]
                .masterAreaWiseList[j].blockData[k].masterArea
                .toString(),
            masterblockid: widget.pendingTaskDetail[tabindexmain]
                .masterAreaWiseList[j].blockData[k].masterBlock
                .toString(),
          ));
        });
      }
    }

    return isdataloaded == false
        ? Container()
        : Padding(
            padding: const EdgeInsets.all(6.0),
            child: ListView(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              children: [
                SizedBox(
                  height: 10,
                ),
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
                  height: SizeConfig.blockSizeVertical * 100,
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
                        child: Wrap(
                          spacing: 5.0,
                          runSpacing: 3.0,
                          children: _buildChoiceList(),
                        ),
                      ),
                      //}),
                      expandedheader(tabindexmain, tag)
//
                    ],
                  ),
                ),
              ],
            ),
          );
  }

//opertational
  masteroperationalarea(int tabindexmain) {
    //selectedindexmain=1;
    print("MASTERARE");
    // print(tabindexmain);
    tabs = [];
    listtab = [];
    String status = "";
//  _tabController=new TabController(vsync: this, length:
//                             //      5
//                               mainlisttab[maintag].details.length,

//                                    );

//                                    print("TABCONTROLE ${_tabController.index.toString()}");
//                                    print("selectedindexmain ${selectedindexmain.toString()}");
//       for (int j = 0; j < mainlisttab[maintag].details.length; j++) {
//            setState(() {
//             // listtab.add(widget.pendingTaskDetail[tabindexmain].masterAreaWiseList[j]);
//             // status=widget.pendingTaskDetail[tabindexmain].masterAreaWiseList[j].status;
//                tabs.add(

//             new Tab(

//  child:Container(
//                               // height: 35,
//                                                              width: SizeConfig.blockSizeHorizontal*25,
//                       decoration:
//               j==selectedindexmain?       BoxDecoration(
//                             color: customcolor.blue,
//                           borderRadius: BorderRadius.all(Radius.circular(20)),
//                          ) :
//                          BoxDecoration(
//                             color:
//                             //  widget.pendingTaskDetail[tabindexmain].masterAreaWiseList[j].status=="Pending"?
//                             //  customcolor.darkorange:
//                              customcolor.blue.withOpacity(0.2),
//                           borderRadius: BorderRadius.all(Radius.circular(20)),
//                          ),
//                               child: Padding(
//                                 padding: const EdgeInsets.all(10.0),
//                                 child: Text("${mainlisttab[maintag].details[j].masterAreaWiseList}",
//                                 style:TextStyle(fontSize: 12,color: Colors.white,))

//                               ),
//                             ),
//             ),
//           );
//            });
//           print("forloop");
//           print("tab of masrter");
//            print(tabs.length);

//             for (int k = 0; k < widget.pendingTaskDetail[tabindexmain].masterAreaWiseList[j].blockData.length; k++) {

//           setState(() {
//               mainlist.add(PendingTask(
//                 maintaskname:widget.pendingTaskDetail[tabindexmain].masterAreaWiseList[j].blockData[k].masterAreaName,
//                 listvalue:widget.pendingTaskDetail[tabindexmain].masterAreaWiseList[j].blockData[k].checklist ,
//                 multipleSelected: [],
//                 isenabledclick:false,
//                masterareaid  : widget.pendingTaskDetail[tabindexmain].masterAreaWiseList[j].blockData[k].masterArea.toString(),
//                   masterblockid: widget.pendingTaskDetail[tabindexmain].masterAreaWiseList[j].blockData[k].masterBlock.toString(),

//                 ));
//           });
//            }
//          }

    return isdataloaded == false
        ? Container()
        : Padding(
            padding: const EdgeInsets.all(6.0),
            child: ListView(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              children: [
                SizedBox(
                  height: 10,
                ),
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
                  height: SizeConfig.blockSizeVertical * 70,
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
                        child: Wrap(
                          spacing: 5.0,
                          runSpacing: 3.0,
                          children: _buildoperationalChoiceList(0),
                        ),
                      ),
                      //}),
                      operationalexpandedheader(tabindexmain, tag)
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
    print("mainlist");
    print(mainlist.length);
    print(tabindexmain.toString());
    print(tabindex.toString());
    // print(mainlist[index].multipleSelected);
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
                  });
                },
                child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        side: BorderSide(color: customcolor.greybg)),
                    child:
                        //Container(child: Text("data"),)
                        expandableListView(
                            index,
                            tabindex,
                            widget
                                .pendingTaskDetail[tabindexmain]
                                .masterAreaWiseList[tabindex]
                                .blockData[index]
                                .masterBlockName,
                            //  mainlist[index].maintaskname,
                            widget
                                .pendingTaskDetail[tabindexmain]
                                .masterAreaWiseList[tabindex]
                                .blockData[index]
                                .checklist,
                            // mainlist[index].listvalue,
                            mainlist[index].multipleSelected,
                            //true
                            index == tapped ? expand : false,
                            widget
                                .pendingTaskDetail[tabindexmain]
                                .masterAreaWiseList[tabindex]
                                .blockData[index]
                                .masterArea
                                .toString(),
                            widget
                                .pendingTaskDetail[tabindexmain]
                                .masterAreaWiseList[tabindex]
                                .blockData[index]
                                .masterBlock
                                .toString())),
              );
            },
            itemCount: widget.pendingTaskDetail[tabindexmain]
                .masterAreaWiseList[tabindex].blockData.length,
          );
        }),
      ],
    );
  }

//operational
  operationalexpandedheader(int tabindexmain, int tabindex) {
    print("mainlist");
    print(mainlist.length);
    print(tabindexmain.toString());
    print(tabindex.toString());
    // print(mainlist[index].multipleSelected);
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
              print("ruchu");
              print(tabindex.toString());
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
                  });
                },
                child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        side: BorderSide(
                            color: mainlisttab[maintag]
                                        .details[tabindexmain]
                                        .masterAreaWiseList[tag]
                                        .blockData[index]
                                        .blockPending ==
                                    0
                                ? customcolor.red
                                : customcolor.greybg)),
                    child:
                        //Container(child: Text("data"),)
                        operationalexpandableListView(
                            index,
                            tabindex,
                            mainlisttab[maintag]
                                .details[tabindexmain]
                                .masterAreaWiseList[tag]
                                .blockData[index]
                                .masterBlockName,

                            //  mainlist[index].maintaskname,
                            mainlisttab[maintag]
                                .details[tabindexmain]
                                .masterAreaWiseList[tag]
                                .blockData[index]
                                .checklist,
                            // mainlist[index].listvalue,
                            [],
                            //true
                            index == tapped ? expand : false,
                            mainlisttab[maintag]
                                .details[tabindexmain]
                                .masterAreaWiseList[tag]
                                .blockData[index]
                                .masterArea
                                .toString(),
                            mainlisttab[maintag]
                                .details[tabindexmain]
                                .masterAreaWiseList[tag]
                                .blockData[index]
                                .masterBlock
                                .toString(),
                            tabindexmain)),
              );
            },
            itemCount: mainlisttab[maintag]
                .details[tabindexmain]
                .masterAreaWiseList[tag]
                .blockData
                .length,
          );
        }),
      ],
    );
  }

  Widget expandableListView(
      int indexvalue,
      int tabindex,
      String title,
      List<Checklist> checkboxeslist,
      List multipleSelectedlist,
      bool isExpanded,
      String masterareaid,
      String bloackareaid) {
    selectedindexmain = tabindex;

    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setStateDialgoue) {
      return Container(
        color: customcolor.white,
        margin: EdgeInsets.symmetric(vertical: 5.0),
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
                      Text(
                        title,
                        style: AppFonts.headerStyle(
                            fontSize: 16,
                            color: customcolor.black,
                            fontWeight: FontWeight.w400),
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
              expandedHeight: 180,
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
                    children: List.generate(
                      checkboxeslist.length,
                      (indexcheck) => ListTileTheme(
                        horizontalTitleGap: 0,
                        minVerticalPadding: 0,
                        child: Theme(
                            data: ThemeData(
                                unselectedWidgetColor: customcolor.greytext),
                            child:
                                //mainlist[indexvalue].isenabledclick?
                                CheckboxListTile(
                              activeColor: customcolor.green,
                              controlAffinity: ListTileControlAffinity.leading,
                              contentPadding: EdgeInsets.zero,
                              dense: true,
                              title: Text(
                                checkboxeslist[indexcheck].pointerName,
                                style: AppFonts.headerStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal),
                              ),
                              value: checkboxeslist[indexcheck].checked,
                              onChanged: (value) {
                                setStateDialgoue(() {
                                  checkboxeslist[indexcheck].checked = value!;
                                  print("multipleSelectedlist");
                                  print(multipleSelectedlist);
                                  print(checkboxeslist[indexcheck]);

                                  if (multipleSelectedlist
                                      .contains(checkboxeslist[indexcheck])) {
                                    multipleSelectedlist
                                        .remove(checkboxeslist[indexcheck]);
                                  } else {
                                    multipleSelectedlist
                                        .add(checkboxeslist[indexcheck]);
                                  }
                                });
                              },
                            )
                            //
                            ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  MyElevatedButton(
                    setStyleStr: 'home',
                    width: 120,
                    height: SizeConfig.blockSizeVertical * 6,
                    onPressed: () {
                      print("multipleSelectedlist");

                      List<String> checkedid = [];
                      List<String> uncheckedid = [];
                      //  for(int i=0;i<multipleSelectedlist.length;i++)
                      //  {
                      //   checkedid.add(multipleSelectedlist[i].id.toString());
                      //  }
                      for (int i = 0; i < checkboxeslist.length; i++) {
                        if (!checkboxeslist[i].checked) {
                          uncheckedid.add(checkboxeslist[i].id.toString());
                        } else {
                          checkedid.add(checkboxeslist[i].id.toString());
                        }
                      }
                      print("checkedid");
                      print("Calledupdate");
                      print(masterareaid);
                      print(bloackareaid);
                      updatedworkflowstatusApi(widget.shiftid, checkedid,
                          uncheckedid, masterareaid, bloackareaid);
                    },
                    borderRadius: BorderRadius.circular(5),
                    colorvalue: customcolor.blue,
                    child: Text('Update'),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            )
          ],
        ),
      );
    });
  }

//opera
  Widget operationalexpandableListView(
      int indexvalue,
      int tabindex,
      String title,
      List<operpriority.Checklist> checkboxeslist,
      List multipleSelectedlist,
      bool isExpanded,
      String masterareaid,
      String bloackareaid,
      int tabindexmain) {
    selectedindexmain = tabindex;
    print("RANGA");
    print("maintag $maintag");
    print("tabindexmain $tabindexmain");
    print("index $tabindex");
    print(selectedindexmain);

    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setStateDialgoue) {
      return Container(
        color: customcolor.white,
        margin: EdgeInsets.symmetric(vertical: 5.0),
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
                      Text(
                        title,
                        style: AppFonts.headerStyle(
                            fontSize: 16,
                            color: mainlisttab[maintag]
                                        .details[tabindexmain]
                                        .masterAreaWiseList[tag]
                                        .blockData[indexvalue]
                                        .blockPending ==
                                    0
                                ? customcolor.red
                                : customcolor.black,
                            fontWeight: FontWeight.w400),
                        //  TextStyle(
                        //     color:mainlisttab[maintag].details[tabindexmain].masterAreaWiseList[tag].blockData[indexvalue].blockPending==0?customcolor.red: customcolor.black,
                        //     fontSize: 16,
                        //     fontFamily: AppFonts.medium,
                        //     fontWeight: FontWeight.w400),
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
                  ? checkboxeslist.length <= 2
                      ? SizeConfig.blockSizeHorizontal * 20
                      : SizeConfig.blockSizeHorizontal * 40
                  : checkboxeslist.length <= 2
                      ? SizeConfig.blockSizeHorizontal * 40
                      : SizeConfig.blockSizeHorizontal * 70,
              child: Scrollbar(
                thumbVisibility: true,
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
                                          Text(
                                            checkboxeslist[indexcheck]
                                                .pointerName,
                                            style: AppFonts.headerStyle(
                                                fontSize: 12,
                                                color: Colors.black,
                                                fontWeight: FontWeight.normal),
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
                                                fontWeight: FontWeight.normal),
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
                                        checkboxeslist[indexcheck].pointerName,
                                        style: AppFonts.headerStyle(
                                            fontSize: 14,
                                            color: checkboxeslist[indexcheck]
                                                        .checked ==
                                                    true
                                                ? customcolor.green
                                                : Colors.black,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      value: checkboxeslist[indexcheck].checked,
                                      onChanged: (value) {
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
                                      },
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
                       isworkflowUpdated?CircularProgressIndicator(color: customcolor.blue,):       MyElevatedButton(
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
                                      uncheckedid
                                          .add(checkboxeslist[i].id.toString());
                                    } else {
                                      checkedid
                                          .add(checkboxeslist[i].id.toString());
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
            )
          ],
        ),
      );
    });
  }
bool isOperWorkFlowLoaded=false;
  operationlworkflowstatusApi() async {
    var status1 = await ConnectionDetector.checkInternetConnection();

    if (status1) {
      // ShowDialogs.showLoadingDialog(context, _keyLoader);
setState(() {
  isOperWorkFlowLoaded=true;
});
      var map = new Map<String, dynamic>();
      map['today_date'] = datecontroller.text;

      APIManager().apiRequest(context, API.operationalclientwiseprioritylist,
          (response) async {
        operpriority.OperationalPrioritylistResponse resp = response;
        print('called API ${resp}');
        if (resp.status == 1) {
          //  ShowDialogs.showToast(resp.msg);
          setState(() {
            mainlisttab = resp.data;

            //            tabsmain= <Tab>[];
            //     _tabControllermain = new TabController(vsync: this, length: mainlisttab[maintag].details.length);
            //           print(_tabControllermain.length);
            //               // _tabController = new TabController(vsync: this, length: 1);
            // for (int i = 0; i < mainlisttab[maintag].details.length; i++) {
            //     tabsmain.add(
            //           new Tab(
            //            text: mainlisttab[maintag].details[i].startTime,

            //           ),
            //         );

            // }
// for(int m=0;m<mainlisttab.length;m++)
// {
//             _tabControllermain = new TabController(vsync: this, length: mainlisttab[m].details.length);
//             print(_tabControllermain.length);
//                 // _tabController = new TabController(vsync: this, length: 1);
//   for (int i = 0; i < mainlisttab[m].details.length; i++) {
//       tabsmain.add(
//             new Tab(
//              text: mainlisttab[m].details[i].startTime,

//             ),
//           );

//   }
// }

            isdataloaded = true;

            //tablist();
setState(() {
  isOperWorkFlowLoaded=false;
});
            // Navigator.of(this.context).pop();
          });
        } else {
          ShowDialogs.showToast(resp.msg);
          setState(() {
  isOperWorkFlowLoaded=false;
});
          // Navigator.of(this.context).pop();
        }
      }, (error) {
        print('ERR msg is $error');
        setState(() {
  isOperWorkFlowLoaded=false;
});
        // Navigator.of(this.context).pop();
        ShowDialogs.showToast("Server Not Responding");
      }, false, "", jsonval: map);
    } else {
      ShowDialogs.showToast("Please check internet connection");
    }
  }
bool isworkflowUpdated=false;
  updatedworkflowstatusApi(String shiftid, List<String> checklistid,
      List<String> unchecklistid, String masterid, String blockid) async {
    var status1 = await ConnectionDetector.checkInternetConnection();

    if (status1) {
      // ShowDialogs.showLoadingDialog(context, _keyLoader);
setState(() {
  isworkflowUpdated=true;
});
      var map = new Map<String, dynamic>();

      dynamic jsonbody = {
        "shift_id": shiftid,
        "master_area_id": masterid,
        "master_block_id": blockid,
        "check_list_id": checklistid,
        "uncheck_list_id": unchecklistid,
      };
      // }
      // map['check_list_id1']="2";
      //  map['check_list_id2']="1";
      // map['check_list_id'] =checklistid[i] ;

      APIManager().apiRequest(context, API.updatedworkflowstatus,
          (response) async {
        UpdatedworkflowResponse resp = response;
        print('called API ${resp}');
        if (resp.status == 1) {
          ShowDialogs.showToast(resp.msg);
          setState(() {
  isworkflowUpdated=false;
});
          // Navigator.of(this.context).pop();
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) => HomePage()));
        } else {
          ShowDialogs.showToast(resp.msg);
          setState(() {
  isworkflowUpdated=false;
});
          // Navigator.of(this.context).pop();
        }
      }, (error) {
        print('ERR msg is $error');
      }, false, "", parameter: jsonbody);
    } else {
      ShowDialogs.showToast("Please check internet connection");
    }
  }

  _buildChoiceList() {
    List<Widget> choices = [];
    listtab.forEachIndexed((item, value) {
      choices.add(Container(
        //  color: customcolor.darkorange,
        child: ChoiceChip(
          label: Text(item.masterAreaName),
          labelStyle: TextStyle(
              color: tag == value
                  ? customcolor.white
                  : item.status == "Pending"
                      ? customcolor.darkorange
                      : customcolor.blue),
          selectedColor: customcolor.blue,
          backgroundColor: item.status == "Pending"
              ? customcolor.darkorange.withOpacity(0.2)
              : customcolor.blue.withOpacity(0.2),
          selected: tag == value,
          onSelected: (selected) {
            setState(() {
              _isSelected = item.masterAreaName;
              tag = value;
              print("tag $tag");
            });
          },
        ),
      ));
    });
    return choices;
  }

  _buildoperationalChoiceList(int index) {
    List<Widget> choices = [];
    print("mainlisttab[maintag].details[0]");
    print(mainlisttab.length);
    // tag=0;
    mainlisttab[maintag]
        .details[index]
        .masterAreaWiseList
        .forEachIndexed((item, value) {
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
          selectedColor: customcolor.blue,
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
              print("tag $tag");
            });
          },
        ),
      ));
    });
    return choices;
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
        padding: const EdgeInsets.only(left: 20, right: 20),
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
