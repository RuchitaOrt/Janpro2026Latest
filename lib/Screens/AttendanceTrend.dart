// ignore_for_file: unused_field, use_key_in_widget_constructors

import 'dart:async';
import 'dart:developer';

import 'dart:ui';


import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:intl/intl.dart';
import 'package:janpro/Screens/Homepage.dart';
import 'package:janpro/Utitlity/ResponsiveFlutter.dart';

import 'package:janpro/model/ClientsiteDashboardResponse.dart' as clientdash;
import 'package:janpro/Screens/Training.dart';
import 'package:janpro/Utitlity/APIManager.dart';
import 'package:janpro/Utitlity/AppDrawer.dart';

import 'package:janpro/Utitlity/GlobalLists.dart';
import 'package:janpro/Utitlity/SPManager.dart';
import 'package:janpro/Utitlity/ShowDialog.dart';
import 'package:janpro/Utitlity/appbar.dart';

import 'package:janpro/Utitlity/customBottomNavigationBar.dart';
import 'package:janpro/Utitlity/custom_color.dart';
import 'package:janpro/Utitlity/internetConnection.dart';
import 'package:janpro/Utitlity/linechart.dart';
import 'package:janpro/Utitlity/sizeConfig.dart';

import 'package:janpro/model/AttendencelistResponse.dart';

import 'package:janpro/model/TrendGraphResponse.dart' as trend;
import 'package:janpro/model/Workflowoperationalmodel.dart' as trendmain;

import 'package:page_transition/page_transition.dart';


class MainList {
  final String name;
  final String priority;

  MainList(this.name, this.priority);
}

class AttendanceTrend extends StatefulWidget {
  final String clientname;

  AttendanceTrend(this.clientname);

  @override
  _AttendanceTrendState createState() => _AttendanceTrendState();
}

class _AttendanceTrendState extends State<AttendanceTrend>
    with TickerProviderStateMixin {
  var searchcontroller = TextEditingController();
  var namecontroller = TextEditingController();
  var sitenamecontroller = TextEditingController();
  final GlobalKey<State> _keyLoader = GlobalKey<State>();
  final GlobalKey<ScaffoldState> _scaffoldKey1 = GlobalKey<ScaffoldState>();

  var mobilecontroller = TextEditingController();
  var datecontroller = TextEditingController();
  var clientnamecontroller = TextEditingController();
  List<EmployeeList> unitemployeelist = [];
  List<Janitorcheckbox> dropdownList = [];
  var selectedDateTime;
  String selectedValue = "Pending";
  String? lat;
  String? long;
  List<String> listtab = [];
  bool isexpandedjanitor = false;
  List<String>? formValue1;
  int tag = 0;
  int maintag = 0;

  String _isSelected = "";

  List<trendmain.Datum> mainlisttab = [];
  List<clientdash.Datum> mainlisttabclient = [];

  late Data attendancedata;
  bool isdataloaded = false;
  List<EmployeeList> searchUserList = [];
  String? role = "1";
  late TabController _tabControllermain;
  final List<Tab> tabsmain = <Tab>[];
  int selectedindex = 0;
  bool showAvg = false;
  bool isexpandedclient = false;
  bool isexpanded = false;
  String attendanceclientid = "";
  String attendancesiteid = "";

  @override
  void initState() {
    super.initState();
    var datefrom = DateFormat('dd-MM-yyyy').format(DateTime.now());
    datecontroller.text = datefrom;

    print("date ");
    getrole();
  }

  getrole() async {
    role = await SPManager().getroleid();
    if (role == GlobalLists.clientrole) {
      clientdashboardApi();
    } else {
      attendancemainstatusApi();
    }
  }

  Future<void> refreshData() async {
    // Simulating an API request or data refresh
    setState(() {
      print("APICall");

      getrole();
    });
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
        return  false;
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
              setStyleStr: 'Attendance Trends',
              onPressedBack: () {},
              onPressedNotify: () {},
              onPressedSearch: () {},
              onPressedSort: () {},
              onPressedmenu: () {
                _scaffoldKey1.currentState!.openEndDrawer();
              }),
        ),

        bottomNavigationBar: CustomBottomNavigationBar(index: 0),
        body:isAttendanceTrendLoading?Center(child: Column(
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
              physics: ScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 20, bottom: 20),
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

                      /// physics: ScrollPhysics(),
                      children: [
                        Container(
                          // color: customcolor.blue,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                child: Text(
                                  "ATTENDANCE TRENDS",
                                  style: AppFonts.headerStyle(
                                      fontSize: ResponsiveFlutter.of(context)
                                          .fontSize(2.3),
                                      color: customcolor.black,
                                      fontWeight: FontWeight.w300),
                                ),
                              ),
                             
                              mainlisttab.length > 0
                                  ? _buildChoicemainListDropdown()
                                  : SizedBox()
                            ],
                          ),
                        ),
                        unitmodule()
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget unitmodule() {
    return ListView(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      children: [
        Container(
          height: maintag == 0
              ? SizeConfig.blockSizeVertical * 66
              : SizeConfig.blockSizeVertical * 73, //74
          decoration: BoxDecoration(
            //color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: customcolor.greyborder,
              width: 0.4,
            ),
          ),

          child: (role == GlobalLists.clientrole)
              ? mainlisttabclient.length > 0
                  ? ListView(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      // mai
                      children: [
                        mainlisttabclient.length > 0
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(top: 14, bottom: 14),
                                child: Container(
                                  height: 25,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    physics: ScrollPhysics(),
                                    children: _buildChoicemainclientList(),
                                  ),
                                ))
                            : Container(),
                        maintab()
                      ],
                    )
                  : ShowDialogs.norecordwidget(
                      SizeConfig.blockSizeHorizontal * 30,
                      SizeConfig.blockSizeVertical * 30)
              : mainlisttab.length > 0
                  ? ListView(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      // mai
                      children: [
                        mainlisttab.length > 0
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(top: 14, bottom: 14),
                                child: Container(
                                  height: 25,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    physics: ScrollPhysics(),
                                    children: _buildChoicemainList(),
                                  ),
                                ))
                            : Container(),
                        maintab()
                      ],
                    )
                  : ShowDialogs.norecordwidget(
                      SizeConfig.blockSizeHorizontal * 30,
                      SizeConfig.blockSizeVertical * 30),
        ),
      ],
    );
  }

  Widget maintab() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
          elevation: 0,
          borderRadius: BorderRadius.circular(10),
          color: customcolor.white,
          child: ListView(
            // mainAxisAlignment: MainAxisAlignment.start,
            shrinkWrap: true,
            physics: ScrollPhysics(),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Overall Attendance",
                  maxLines: 2,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                  style: AppFonts.headerStyle(
                      fontSize: ResponsiveFlutter.of(context).fontSize(2),
                      color: customcolor.title,
                      fontWeight: FontWeight.normal),
                ),
              ),
       isoverAllGraphLoaded?
       Center(child: Container(
        height: SizeConfig.blockSizeVertical * 80,
         child: Column(
             mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: customcolor.blue,),
              SizedBox(height: 15),
                  Text("Loading, please wait...",
                      style: TextStyle(
                          color:   Colors.black))
            ],
          ),
       ))
       :       GlobalLists.trendgraphlist.length > 0
                  ? overallgraph(GlobalLists.trendgraphlist)
                  : Container(),
            ],
          )),
    );
  }

  Widget overallgraph(List<trend.GraphDatum> graph) {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 0.8,
          child: Padding(
            padding: const EdgeInsets.only(
              right: 18,
              left: 12,
              top: 15,
              bottom: 4,
            ),
            child: LineChart(
              LineChartSample2.trendmainData(graph),
            ),
          ),
        ),
      ],
    );
  }
bool isAttendanceTrendLoading=false;
  //clientwisedashboad
  clientdashboardApi() async {
    var status1 = await ConnectionDetector.checkInternetConnection();

    if (status1) {
      setState(() {
        mainlisttabclient = [];
      });

     
setState(() {
  isAttendanceTrendLoading=true;
});
      var map = Map<String, dynamic>();

      var supervisorid = await SPManager().getsupervisorid();
      print(supervisorid);
      var clientid = await SPManager().getclientid();
      // client
      // new vishu 13 aug 24
      map['clientid'] = clientid;
   

      APIManager().apiRequest(context, API.clientsitedependentdashboard,
          (response) async {
        clientdash.ClientsiteDashboardResponse resp = response;
        print("UNIT");
        print(resp.status.toString());
        print('called API ${resp}');
        if (resp.status == 1) {
          attendancegraphstatusApi(
              resp.data[0].clientId.toString(), resp.data[0].siteId.toString());
          setState(() {
            mainlisttabclient = resp.data;
          });
          setState(() {
  isAttendanceTrendLoading=false;
});
          // Navigator.of(this.context).pop();
          //  ShowDialogs.showToast(resp.msg);
        } else {
          ShowDialogs.showToast(resp.msg);
            setState(() {
  isAttendanceTrendLoading=false;
});
          // Navigator.of(this.context).pop();
        }
      }, (error) {
        print('ERR msg is $error');
          setState(() {
  isAttendanceTrendLoading=false;
});
        // Navigator.of(this.context).pop();
      }, false, "", jsonval: map);
    } else {
      ShowDialogs.showToast("Please check internet connection");
    }
  }

  Widget supervisoroverallgraph(List<GraphDatum> graph) {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 0.8,
          child: Padding(
            padding: const EdgeInsets.only(
              right: 18,
              left: 12,
              top: 15,
              bottom: 4,
            ),
            child: LineChart(
              LineChartSample2.supervisormainData(graph),
            ),
          ),
        ),
      ],
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
                        :
                        // item.lowattendance == true?customcolor.red:
                        customcolor.greytext,
                    fontWeight: FontWeight.bold),
              ),
            ),
            side: BorderSide(
                width: 0.5,
                color: maintag == value
                    ? customcolor.white
                    :
                    //    item.lowattendance == true?customcolor.red:
                    customcolor.white),
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
                attendancegraphstatusApi(
                    item.clientId.toString(), item.siteId.toString());
//                  for(int i=0;i<mainlisttab[maintag].attendanceDetails.length;i++)
//     {
// // listtab.add("${mainlisttab[maintag].attendanceDetails[i].shiftStartTime}-${mainlisttab[maintag].attendanceDetails[i].shiftEndTime}");
//    if(mainlisttab[maintag].attendanceDetails[i].currentTime==true)
//             {
//                print("selectedindextagselect");
//                 tag =  i;
//                print(selectedindex);
//             }

//     }
              });
            },
          ),
        ),
      ));
    });
    return choices;
  }

  Widget _buildChoicemainListDropdown() {
    final selectedItem =
        maintag < mainlisttab.length ? mainlisttab[maintag] : null;

    return Row(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () async {
            TextEditingController searchController = TextEditingController();
            List filteredList = List.from(mainlisttab);

            await showDialog(
              context: context,
              builder: (_) {
                return StatefulBuilder(
                  builder: (context, setStateDialog) => Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                      constraints: BoxConstraints(maxHeight: 500),
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: TextField(
                              controller: searchController,
                              decoration: InputDecoration(
                                hintText: "Search Client...",
                                suffixIcon: searchController.text.isNotEmpty
                                    ? IconButton(
                                        icon: Icon(Icons.cancel_outlined),
                                        onPressed: () {
                                          searchController.clear();
                                          setStateDialog(() {
                                            filteredList =
                                                List.from(mainlisttab);
                                          });
                                        },
                                      )
                                    : null,
                                prefixIcon: Icon(Icons.search),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onChanged: (query) {
                                setStateDialog(() {
                                  filteredList = mainlisttab
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
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                  
                                    itemCount: filteredList.length,
                                    itemBuilder: (context, index) {
                                      final item = filteredList[index];
                                      final isSelected = item == selectedItem;

                                      final textColor = isSelected
                                          ? customcolor.tabblue
                                          : /* item.lowattendance == true
                                          ? customcolor.red
                                          : */
                                          customcolor.greytext;

                                      return ListTile(
                                        title: Text(
                                          item.clientName,
                                          style: AppFonts.headerStyle(
                                            fontSize: 14,
                                            color: textColor,
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
                                          final actualIndex =
                                              mainlisttab.indexOf(item);

                                          setState(() {
                                            _isSelected = item.clientName;
                                            maintag = actualIndex;
                                            tag = 0;
                                            attendancegraphstatusApi(
                                              item.clientId.toString(),
                                              item.siteId.toString(),
                                            );
                                            // Uncomment if needed
                                            // for (int i = 0; i < mainlisttab[maintag].attendanceDetails.length; i++) {
                                            //   if (mainlisttab[maintag].attendanceDetails[i].currentTime == true) {
                                            //     tag = i;
                                            //   }
                                            // }
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

  _buildChoicemainclientList() {
    List<Widget> choices = [];
    mainlisttabclient.forEachIndexed((item, value) {
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
                        :
                        // item.lowattendance == true?customcolor.red:
                        customcolor.greytext,
                    fontWeight: FontWeight.bold),
              ),
            ),
            side: BorderSide(
                width: 0.5,
                color: maintag == value
                    ? customcolor.white
                    :
                    //    item.lowattendance == true?customcolor.red:
                    customcolor.white),
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
                attendancegraphstatusApi(
                    item.clientId.toString(), item.siteId.toString());
//
              });
            },
          ),
        ),
      ));
    });
    return choices;
  }

  //attendance main list
  attendancemainstatusApi() async {
    var status1 = await ConnectionDetector.checkInternetConnection();

    if (status1) {
      setState(() {
        mainlisttab = [];
      });
   
  setState(() {
  isAttendanceTrendLoading=true;
});
      var map = Map<String, dynamic>();

      var supervisorid = await SPManager().getsupervisorid();
      print(supervisorid);

      map['supervisor'] = supervisorid;

      map['date_today'] = datecontroller.text;
      APIManager().apiRequest(context, API.workflowoperational_trends,
          (response) async {
        trendmain.Workflowoperationalmodel resp = response;

        if (resp.status == 1) {
            setState(() {
  isAttendanceTrendLoading=false;
});
          // Navigator.of(this.context).pop();
          //  ShowDialogs.showToast(resp.msg);
          setState(() {
            mainlisttab = resp.data;
            attendancegraphstatusApi(resp.data[0].clientId.toString(),
                resp.data[0].siteId.toString());
          });
        } else {
          setState(() {
            isdataloaded = false;
          });
          // ShowDialogs.showToast(resp.msg);
          // Navigator.of(this.context).pop();
            setState(() {
  isAttendanceTrendLoading=false;
});
        }
      }, (error) {
        print('ERR msg is $error');
          setState(() {
  isAttendanceTrendLoading=false;
});
        // Navigator.of(this.context).pop();
        ShowDialogs.showToast("Server Not Responding");
      }, false, "", jsonval: map);
    } else {
      ShowDialogs.showToast("Please check internet connection");
    }
  }
bool isoverAllGraphLoaded=false;
//graph list
  attendancegraphstatusApi(String clientid, String siteid) async {
    var status1 = await ConnectionDetector.checkInternetConnection();

    if (status1) {
      setState(() {
        GlobalLists.trendgraphlist = [];
        isoverAllGraphLoaded=true;
      });

    
      var map = Map<String, dynamic>();
      var emp_id = await SPManager().getclientid();
     
      // 3 OM
      if (role == GlobalLists.clientrole) {
        map['date'] = datecontroller.text;
        map['clientid'] = clientid;
        map['siteid'] = siteid;
      }
      else if (role == GlobalLists.operationmanagerrole||role == GlobalLists.operationrole ||role == GlobalLists.headrole ||role == GlobalLists.reginalmanagerrole) {
        map['date'] = datecontroller.text;
        map['clientid'] = clientid;
        map['siteid'] = siteid;
         map['emp_id'] = emp_id;
      }
       else {
        map['date'] = datecontroller.text;
        map['emp_id'] = emp_id;
      }

      log('Attendance Graph Params: $map');
      // map['date'] = datecontroller.text;
      // map['clientid'] = clientid;
      // map['siteid'] = siteid;
      // map['emp_id'] =
      APIManager().apiRequest(context, API.trends_attendance_graph,
          (response) async {
        trend.TrendGraphResponse resp = response;
        print("TREND GRAPH");
       setState(() {
          isoverAllGraphLoaded=false;
          });
 
        if (resp.status == 1) {
          // Navigator.of(this.context).pop();
          //  ShowDialogs.showToast(resp.msg);
          setState(() {
            GlobalLists.trendgraphlist = resp.graphData;
          });
        } else {
          setState(() {
            isdataloaded = false;
          });
          // ShowDialogs.showToast(resp.msg);
          // Navigator.of(this.context).pop();
        }
      }, (error) {
        print('ERR msg TrendGraphResponse is $error');
        // Navigator.of(this.context).pop();
         setState(() {
          isoverAllGraphLoaded=false;
          });
        ShowDialogs.showToast("Server Not Responding");
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
