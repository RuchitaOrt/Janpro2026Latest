// ignore_for_file: unused_field

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:another_flushbar/flushbar.dart';
import 'package:geocoding/geocoding.dart';
import 'package:janpro/Screens/client_visit_view.dart';
import 'package:janpro/Utitlity/ResponsiveFlutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:janpro/Screens/Attendance.dart';
import 'package:janpro/Screens/Complaint.dart';
import 'package:janpro/Screens/PendingWorkflowstatus.dart';
import 'package:janpro/Screens/PrioritySupervisor.dart';
import 'package:janpro/Screens/Rating.dart' as rating;
import 'package:janpro/Screens/Training.dart';
import 'package:janpro/model/OperationalWorkflowResponse.dart' as operwf;
import 'package:janpro/model/WorkflowoperationalDetailmodel.dart'
    as newoperdetail;
import 'package:janpro/model/Workflowoperationalmodel.dart' as newopera;
// import 'package:janpro/Screens/Workflowstatus.dart';
import 'package:janpro/Screens/WorkflowstatusNew.dart';
import 'package:janpro/Screens/WorkflowstatusOperation.dart';
import 'package:janpro/Utitlity/APIManager.dart';
import 'package:janpro/Utitlity/AppDrawer.dart';
import 'package:janpro/Utitlity/FormTextField.dart';
import 'package:janpro/Utitlity/FormTextFieldButton.dart';
import 'package:janpro/Utitlity/GlobalLists.dart';
import 'package:janpro/Utitlity/LocationService.dart';
import 'package:janpro/Utitlity/SPManager.dart';
import 'package:janpro/Utitlity/ShowDialog.dart';
import 'package:janpro/Utitlity/appbar.dart';
import 'package:janpro/Utitlity/button.dart';
import 'package:janpro/Utitlity/customBottomNavigationBar.dart';
import 'package:janpro/Utitlity/custom_color.dart';
import 'package:janpro/Utitlity/internetConnection.dart';
import 'package:janpro/Utitlity/linechart.dart';
import 'package:janpro/Utitlity/sizeConfig.dart';
import 'package:janpro/model/ClientsiteDashboardResponse.dart' as clientdash;
import 'package:janpro/model/DashboardlistResponse.dart';
import 'package:janpro/model/GetDependentResponse.dart' as dependent;
import 'package:janpro/model/JanitorslistResponse.dart';
import 'package:janpro/model/UnitDashboardResponse.dart';
import 'package:janpro/model/UnitclientMasterResponse.dart';
import 'package:janpro/model/UnitsiteMasterResponse.dart';
import 'package:janpro/model/WorkfowstatusResponse.dart' as workflow;
import 'package:page_transition/page_transition.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:janpro/model/ClientwisetrainingResponse.dart' as training;
import 'package:permission_handler/permission_handler.dart' as permishan;
import 'package:janpro/model/AddtrainingResponse.dart' as addtraining;
import 'package:permission_handler/permission_handler.dart';

import 'package:syncfusion_flutter_core/theme.dart';

import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'dart:math' as math;

// import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:janpro/model/AddAttendanceResponse.dart' as addattten;
import 'package:janpro/model/UnitsiteMasterResponse.dart' as sitemaster;
import 'package:janpro/model/MobilelisttrainingResponse.dart' as agen;
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:janpro/model/unitAttendanceResponse.dart' as unitatt;

import '../controller/background_run_api.dart';
import '../model/AttendencelistResponse.dart' as att;
import '../model/WorkfowstatusResponse.dart';
import '../services/camera_capture_screen.dart';
import '../services/permission_helper.dart';
import 'OperationVisitCardPage.dart';
import 'operation_visit_page.dart';

class Dashboard {
  final String image;
  final String type;
  final String value;
  final String valuename;
  final String percentage;
  final String raitngcount;
  final String note;
  final percvalue;

  Dashboard(
    this.image,
    this.type,
    this.value,
    this.valuename,
    this.percentage,
    this.note,
    this.raitngcount,
    this.percvalue,
  );
}

class HomePage extends StatefulWidget {
  HomePage();

  @override
  _homePageState createState() => _homePageState();
}

class _homePageState extends State<HomePage> with TickerProviderStateMixin {
  bool expand = false;
  int? tapped;
  var statuscontroller = new TextEditingController();
  var namecontroller = new TextEditingController();

  var mobilecontroller = new TextEditingController();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  String selectedValue = "Pending";
  List<String> sitelist = ["IMax", "Cineplax", "PVR", "Cinipol"];
  List<String> result = [];
  bool isexpanded = false;
  late TabController _tabController;
  double _value = 40.0;
  late Data dashboardvlaue;
  bool isdashboradvisible = false;
  bool ishomedataadvisible = false;

  //     bool isExpanded = false;

  List<Dashboard> headlist = [];
  List mainlist = [];
  bool isoptionopen = false;
  final List<Tab> tabs = <Tab>[];
  bool isdataloaded = false;
  List<String> options = ["TAT", "Dependent", "Resolved"];
  GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  // String GlobalLists.clienname = "";

  // Future<void> refreshData() async {
  //   // Simulating an API request or data refresh
  //   setState(() {
  //     visitCount = false;
  //     print("APICall");
  //     var datefrom = DateFormat('dd-MM-yyyy').format(DateTime.now());
  //     datecontroller.text = datefrom;

  //     getrole();

  //     _tabController = new TabController(vsync: this, length: 3);
  //   });
  // }
  Future<void> refreshData() async {
    setState(() {
      visitCount = false;
      isFirstLoad = true; // show loader immediately
      print("APICall");

      // Update date
      var datefrom = DateFormat('dd-MM-yyyy').format(DateTime.now());
      datecontroller.text = datefrom;

      // Recreate tab controller if required
      _tabController = TabController(vsync: this, length: 3);
    });

    // 👇 Call getrole() outside setState (since it's async and contains API)
    await getrole();

    //  Once data loaded, isFirstLoad will automatically become false
    // inside your unitdashboardApi() or clientdashboardApi()
  }

  var sitenamecontroller = new TextEditingController();
  var clientnamecontroller = new TextEditingController();
  bool isexpandedjanitor = false;
  bool isexpandedclient = false;
  final GlobalKey<ScaffoldState> _scaffoldKey1 = new GlobalKey<ScaffoldState>();
  int selectedindex = 0;
  String? role = "1";
  late TabController _tabControllermain;
  final List<Tab> tabsmain = <Tab>[];
  int _counter = 0;
  int maintag = 0;
  File? _imageFile;
  dynamic _pickImageError;
  File? image;
  String? _fileName;
  List<PlatformFile>? _paths;
  String? _directoryPath;
  String? _extension;
  bool _loadingPath = false;
  FileType _pickingType = FileType.custom;

  String _isSelected = "";
  List<clientdash.Datum> mainlisttab = [];
  String attendanceclientid = "";
  String attendancesiteid = "";
  String? lat;
  String? long;

  List<Agendacheckbox> agendalist = [];
  var selectedDateTime;
  String janitorname = "";
  var datecontroller = new TextEditingController();
  List<String> janitorid = [];
  List<String> agendaid = [];
  List<Janitorcheckbox> dropdownList = [];
  var agendacontroller = new TextEditingController();

  var uploadcontroller = new TextEditingController();
  backGroundRun background = backGroundRun();
  bool visitCount = false;
  @override
  void initState() {
    super.initState();
    var datefrom = DateFormat('dd-MM-yyyy').format(DateTime.now());
    GlobalLists.datecontroller.text = datefrom;
    getrole();

    Future.delayed(Duration(seconds: 3), () {
      if (GlobalLists.isloadedWokeflow == false &&
          role != GlobalLists.unitrole) {
        getworkeflow();
      }
    });

    Future.delayed(Duration(seconds: 3), () {
      if (GlobalLists.isloadedAttendance == false) {
        getAttandance();
      }
    });
  }

  getrole() async {
    role = await SPManager().getroleid();
    if (role == GlobalLists.clientrole ||
        role == GlobalLists.headrole ||
        role == GlobalLists.reginalmanagerrole) {
      _tabControllermain = new TabController(vsync: this, length: 3);
      tabsmain.add(new Tab(text: "IMAX"));
      tabsmain.add(new Tab(text: "Cinepol"));
      tabsmain.add(new Tab(text: "Cineplax"));
    }

    if (role == GlobalLists.unitrole ||
        role == GlobalLists.operationrole ||
        role == GlobalLists.headrole ||
        role == GlobalLists.reginalmanagerrole ||
        role == GlobalLists.operationmanagerrole) {
      print("RUCHITA UNIT");
      await unitdashboardApi();
    } else if (role == GlobalLists.clientrole) {
      print("RUCHITA CLIENT");
      await clientdashboardApi();
    } else {
      print("RUCHITA ELSE");
      await dashboardApi();
    }
    if (role == GlobalLists.unitrole ||
        role == GlobalLists.operationrole ||
        role == GlobalLists.operationmanagerrole) {
      await unitclientmasterApi();
      await trainingagendaApi();
      await janotoragendaApi("", "");
    }
  }

  // getAttandance() async {
  //   role = await SPManager().getroleid();

  //   if (role == GlobalLists.supervisorrole) {
  //     background.janotoragendaApi(
  //         GlobalLists.clientid, GlobalLists.siteid, context);
  //   }
  //   if (role == GlobalLists.unitrole ||
  //       role == GlobalLists.operationrole ||
  //       role == GlobalLists.operationmanagerrole ||
  //       role == GlobalLists.headrole ||
  //       role == GlobalLists.reginalmanagerrole ||
  //       role == GlobalLists.clientrole) {
  //     background.unitattendanceApi(context, role);
  //   } else {
  //     await background.attendanceApi(context);
  //   }
  //   // GlobalLists.isloadedAttendance = true;
  // }

  getAttandance() async {
    role = await SPManager().getroleid();

    log('role : $role');
    if (role == GlobalLists.supervisorrole) {
      background.janotoragendaApi(
        GlobalLists.clientid,
        GlobalLists.siteid,
        context,
      );
    }
    if (role == GlobalLists.unitrole ||
        role == GlobalLists.operationrole ||
        role == GlobalLists.operationmanagerrole ||
        role == GlobalLists.headrole ||
        role == GlobalLists.reginalmanagerrole ||
        role == GlobalLists.clientrole) {
      background.unitattendanceApi(context, role);
    } else {
      log('attendance call');
      background.attendanceApi(context);
    }
    if (role == GlobalLists.unitrole ||
        role == GlobalLists.headrole ||
        role == GlobalLists.reginalmanagerrole ||
        role == GlobalLists.clientrole ||
        role == GlobalLists.operationrole ||
        role == GlobalLists.operationmanagerrole) {
      //  checkPermissionStatus();
      // _getLocation();
      // setState(() {});
    } else {
      // _getLocation();
      //   checkPermissionStatus();
    }
    GlobalLists.isloadedAttendance = true;
  }

  attendanceApi() async {
    log('attendanceApi');
    var status1 = await ConnectionDetector.checkInternetConnection();

    if (status1) {
      var supervisorid = await SPManager().getsupervisorid();
      var map = {
        'supervisor': supervisorid,
        'today_date': GlobalLists.datecontroller.text,
      };

      APIManager().apiRequest(
        context,
        API.attendance,
        (response) async {
          att.AttendencelistResponse resp = response;

          if (resp.status == 1) {
            setState(() {
              GlobalLists.attendancedata = resp.data;

              log('GlobalLists.attendancedata');
              log(
                'GlobalLists.attendancedata.count ${GlobalLists.attendancedata}',
              );
              GlobalLists.superviorgraphlist = resp.graphData;
              GlobalLists.mainlisttab = [
                unitatt.Datum(
                  clientName: "OverAll",
                  clientId: 0,
                  siteId: 0,
                  attendanceDetails: [],
                  lowattendance: false,
                  attendedCount: 0,
                  totalNoStaff: 0,
                  notapplicable: 0,
                ),
                unitatt.Datum(
                  clientName: resp.data.clientSiteName,
                  clientId: resp.data.clientId,
                  siteId: resp.data.siteId,
                  attendanceDetails: [],
                  lowattendance: resp.data.lowattendance,
                  attendedCount: 0,
                  totalNoStaff: 0,
                  notapplicable: 0,
                ),
              ];
              GlobalLists.attendanceemployeelist = resp.data.employeeList;
              // isdataloaded = true;

              // if (resp.data.clientSiteName == widget.clientname) {
              //   maintag = 1;
              // }
            });

            // ✅ Save JSON to SharedPreferences
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString(
              'cached_attendance_data',
              att.attendencelistResponseToJson(resp),
            );
            // Navigator.of(this.context).pop();
          } else {
            // Navigator.of(this.context).pop();
          }
        },
        (error) {
          log('ERR msg is $error');
        },
        false,
        "",
        jsonval: map,
      );
    }
  }

  getworkeflow() async {
    role = (await SPManager().getroleid())!;
    print("R O L E");
    print(role);
    print(GlobalLists.shiftid);
    if (role == GlobalLists.operationrole ||
        role == GlobalLists.headrole ||
        role == GlobalLists.reginalmanagerrole ||
        role == GlobalLists.operationmanagerrole) {
      print("Anand1");
      // await operationlManagerworkflowstatusApi();
    } else if (role == GlobalLists.clientrole) {
      // await background.operationlworkflowstatusApi(context, role);
      // await operationlworkflowstatusApi();
    } else {
      log('called');

      GlobalLists.isloadedWokeflow = true;
    }
  }

  workflowstatusApi() async {
    // Check Internet Connection
    if (!await ConnectionDetector.checkInternetConnection()) {
      // Try loading offline data
      final prefs = await SharedPreferences.getInstance();
      String? cachedData = prefs.getString('workflowstatusApi');

      if (cachedData != null) {
        final WorkfowstatusResponse resp = WorkfowstatusResponse.fromJson(
          jsonDecode(cachedData),
        );

        // setState(() {
        GlobalLists.workflowstatuslist = resp.data;

        log(' GlobalLists.workflowstatuslis${GlobalLists.workflowstatuslist}');
        GlobalLists.shiftavaialble = resp.shiftActive.toString();
        GlobalLists.multidays = resp.multidays;
        GlobalLists.start_time = resp.start_time;
        GlobalLists.end_time = resp.end_time;
        GlobalLists.total_supervisorercentage = resp.total_percentage
            .toString();

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
                color: _getStatusColor(
                  GlobalLists.workflowstatuslist[i].status,
                ),
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
        // });

        ShowDialogs.showToast("Offline data loaded");
      } else {
        ShowDialogs.showToast("Please check internet connection");
      }

      return;
    }

    final map = {
      'shift_id': GlobalLists.shiftid,
      'client_id': GlobalLists.clientid,
      'site_id': GlobalLists.siteid,
      'today_date': GlobalLists.datecontroller.text,
    };

    log(map.toString(), name: 'check');

    APIManager().apiRequest(
      context,
      API.workflowstatus,
      (response) async {
        final WorkfowstatusResponse resp = response;

        // if (resp.status != 1) {
        //   setState(() => isdataloaded = false);
        //   Navigator.of(context).pop();
        //   return;
        // }

        // setState(() {
        GlobalLists.workflowstatuslist = resp.data;
        GlobalLists.shiftavaialble = resp.shiftActive.toString();
        GlobalLists.multidays = resp.multidays;
        GlobalLists.start_time = resp.start_time;
        GlobalLists.end_time = resp.end_time;
        GlobalLists.total_supervisorercentage = resp.total_percentage
            .toString();

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
                color: _getStatusColor(
                  GlobalLists.workflowstatuslist[i].status,
                ),
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
        // });

        // Save response to offline
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('workflowstatusApi', jsonEncode(resp.toJson()));

        // Navigator.of(context).pop();
      },
      (error) {
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

  String _locationMessage = "Press the button to get your location";

  _getLocation() async {
    LocationService locationService = LocationService();
    try {
      Position position = await locationService.determinePosition();
      setState(() {
        _locationMessage =
            "Latitude: ${position.latitude}, Longitude: ${position.longitude}";

        print(_locationMessage);
      });
    } catch (e) {
      setState(() {
        _locationMessage = "Error: $e";
        print(_locationMessage);
      });
    }
    getLocation();
  }

  operationlworkflowstatusApi() async {
    // var status1 = await ConnectionDetector.checkInternetConnection();
    var clientid = await SPManager().getclientid();

    var map = {'today_date': GlobalLists.datecontroller.text};

    if (role == GlobalLists.clientrole) {
      map['clientid'] = clientid.toString();
    }

    // if (status1) {

    APIManager().apiRequest(
      context,
      API.operationalworkflow,
      (response) async {
        operwf.OperationalWorkflowResponse resp = response;

        if (resp.status == 1) {
          GlobalLists.mainlisttabs = resp.data;
          GlobalLists.operationalworkflowstatuslist = resp.data;
          GlobalLists.selectedindex = 0;
          GlobalLists.tabsmain = <Tab>[];

          // for (int i = 0; i < resp.data.length; i++) {
          //   // if (resp.data[i].clientName == widget.clientname) {
          //   //   GlobalLists.maintag = i;
          //   // }
          // }

          // _updateCardValues();
          // _generateTabs();

          // ✅ Cache response locally
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(
            'cached_operationalworkflow',
            jsonEncode(resp.toJson()),
          );
        } else {
          // ShowDialogs.showToast("Failed to load data");
        }
      },
      (error) {
        print('ERR msg is $error');
        // ShowDialogs.showToast("Server Not Responding");
      },
      false,
      "",
      jsonval: map,
    );
    // }
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

    GlobalLists.card_startcurrentdatevalue = details[GlobalLists.selectedindex]
        .startTimeStr
        .toString();
    GlobalLists.card_endcurrentdatevalue = details[GlobalLists.selectedindex]
        .endTimeStr
        .toString();
    GlobalLists.card_superviorfirtvalue = details[GlobalLists.selectedindex]
        .supervisorName
        .toString();
    GlobalLists.card_percentvalue = GlobalLists
        .mainlisttabs[GlobalLists.maintag]
        .totalPercentage
        .toString();
  }

  operationlManagerworkflowstatusApi() async {
    var status1 = await ConnectionDetector.checkInternetConnection();

    var supervisorid = await SPManager().getsupervisorid();
    var map = {
      'supervisor': supervisorid,
      'date_today': GlobalLists.datecontroller.text,
    };

    if (status1) {
      APIManager().apiRequest(
        context,
        API.workflowoperational,
        (response) async {
          newopera.Workflowoperationalmodel resp = response;
          print('Anand API ${resp.data}');

          if (resp.status == 1) {
            // setState(() {
            GlobalLists.operationalmainlisttab = resp.data;
            GlobalLists.maintag = 0;
            GlobalLists.selectedindex = 0;

            // operationlManagerdetailworkflowstatusApi(
            //   resp.data[0].clientId.toString(),
            //   resp.data[0].siteId.toString(),
            // );
            // });

            final prefs = await SharedPreferences.getInstance();
            await prefs.setString(
              'workflowOperationalCache',
              jsonEncode(resp.toJson()),
            );

            // Navigator.of(context).pop();
          } else {
            // setState(() {
            //   isdataloaded = false;
            // });
            // Navigator.of(context).pop();
          }
        },
        (error) {
          print('ERR msg is $error');
          // Navigator.of(context).pop();
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

        // setState(() {
        GlobalLists.operationalmainlisttab = cachedResponse.data;
        GlobalLists.maintag = 0;
        GlobalLists.selectedindex = 0;

        if (cachedResponse.data != null && cachedResponse.data.isNotEmpty) {
          operationlManagerdetailworkflowstatusApi(
            cachedResponse.data[0].clientId.toString(),
            cachedResponse.data[0].siteId.toString(),
          );
        }
        // });

        // ShowDialogs.showToast("Loaded offline data");
      } else {
        // ShowDialogs.showToast("No internet and no cached data available");
      }
    }
  }

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
        APIManager().apiRequest(
          context,
          API.workflowoperationaldetail,
          (response) async {
            try {
              newoperdetail.WorkflowoperationalDetailmodel resp = response;

              if (resp.status == 1) {
                // setState(() {
                GlobalLists.detailopeermainlisttab = resp.data;
                GlobalLists.tabsmain = [];
                GlobalLists.selectedindex = 0;

                updateTabData(resp);
                // isdataloaded = true;
                // Navigator.of(this.context).pop();
                // });

                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString("workflow_response", jsonEncode(resp.toJson()));

                /// ✅ FIX: Store the entire response, not just `data`
                String clientIdKey = client_id;
                if (!GlobalLists.clientDetailsMap.containsKey(clientIdKey)) {
                  GlobalLists.clientDetailsMap[clientIdKey] = [];
                }
                GlobalLists.clientDetailsMap[clientIdKey]!.addAll(
                  resp.data,
                ); // ✅ Correct
                // 👈 FIXED LINE
              } else {
                // setState(() {
                //   isdataloaded = true;
                // });
                // Navigator.of(this.context).pop();
              }
            } catch (e) {
              log("Parsing Error: $e");
              // Navigator.of(this.context).pop();
              // ShowDialogs.showToast("Something went wrong");
            }
          },
          (error) {
            log('ERR msg is $error');
            // Navigator.of(this.context).pop();
            // ShowDialogs.showToast("Server Not Responding");
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

            // setState(() {
            GlobalLists.detailopeermainlisttab = resp.data;
            GlobalLists.tabsmain = [];
            GlobalLists.selectedindex = 0;
            updateTabData(resp);
            // isdataloaded = true;
            // });

            /// ✅ FIX: Add full response object, not just `data`
            String clientIdKey = client_id;
            if (!GlobalLists.clientDetailsMap.containsKey(clientIdKey)) {
              GlobalLists.clientDetailsMap[clientIdKey] = [];
            }
            GlobalLists.clientDetailsMap[clientIdKey]!.addAll(
              resp.data,
            ); // ✅ Correct
            // 👈 FIXED LINE
          } catch (e) {
            print("Error reading offline data: $e");
            // ShowDialogs.showToast("Failed to load offline data");
          }
        } else {
          // ShowDialogs.showToast("No offline data available");
        }
      }
    } catch (e) {
      print("API Exception: $e");
      ShowDialogs.showToast("Unexpected error occurred");
      // Navigator.of(this.context).pop();
    }
  }

  void updateTabData(newoperdetail.WorkflowoperationalDetailmodel resp) {
    GlobalLists.card_startcurrentdatevalue = resp
        .data[0]
        .details[GlobalLists.selectedindex]
        .startTimeStr
        .toString();
    GlobalLists.card_endcurrentdatevalue = resp
        .data[0]
        .details[GlobalLists.selectedindex]
        .endTimeStr
        .toString();
    GlobalLists.card_superviorfirtvalue = resp.data[0].superviourName
        .toString();
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
        GlobalLists.card_startcurrentdatevalue = resp
            .data[0]
            .details[i]
            .startTimeStr
            .toString();
        GlobalLists.card_endcurrentdatevalue = resp
            .data[0]
            .details[i]
            .endTimeStr
            .toString();
        GlobalLists.card_superviorfirtvalue = resp
            .data[0]
            .details[i]
            .supervisorName
            .toString();
        GlobalLists.card_percentvalue = resp.data[0].totalPercentage.toString();
        break;
      }
    }

    GlobalLists.tabControllermain = TabController(
      vsync: this,
      length: resp.data[0].details.length,
      initialIndex: GlobalLists.selectedindex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        ShowDialogs.showConfirmDialog(
          context,
          "Exit",
          "Are you sure you want to\n quit the application?",
          () {
            SystemNavigator.pop();
          },
        );
        return true;
      },
      child: Scaffold(
        backgroundColor: customcolor.greybg,
        resizeToAvoidBottomInset: false,
        floatingActionButton: FloatingActionButton(
          //Floating action button on Scaffold
          backgroundColor: customcolor.skyblue,

          /// customcolor.tabblue.withOpacity(0.3),
          onPressed: () {
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.fade,
                child: HomePage(),
                duration: Duration(milliseconds: 300),
              ),
            );
          },
          child: Image.asset(
            "assets/images/homeblue.png",
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
            },
          ),
        ),
        key: _scaffoldKey1,

        // appBar: AppBar(
        //   title: Text('Go Back'),
        //   centerTitle: true,
        //   brightness: Brightness.dark,
        //   backgroundColor: Colors.deepPurpleAccent,
        // ),
        bottomNavigationBar: CustomBottomNavigationBar(index: 4),
        endDrawer: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: customcolor.blue,
            primaryColor: customcolor.blue,
          ),
          child: AppDrawerfilter(role),
        ),
        body:
            (role == GlobalLists.headrole ||
                role == GlobalLists.reginalmanagerrole ||
                role == GlobalLists.clientrole ||
                role == GlobalLists.operationrole ||
                role == GlobalLists.operationmanagerrole)
            ? CustomRefreshIndicator(
                key: refreshIndicatorKey,
                builder:
                    (
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

                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 20,
                        bottom: 20,
                      ),
                      child: Container(
                        child: ListView(
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          children: [
                            Container(
                              child: Text(
                                "DASHBOARD",
                                style: AppFonts.headerwithletterStyle(
                                  fontSize: ResponsiveFlutter.of(
                                    context,
                                  ).fontSize(2.5),
                                  color: customcolor.title,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.8,
                                ),
                                //
                              ),
                            ),
                            (role == GlobalLists.headrole ||
                                    role == GlobalLists.reginalmanagerrole ||
                                    role == GlobalLists.clientrole ||
                                    role == GlobalLists.operationrole ||
                                    role == GlobalLists.operationmanagerrole)
                                ? SizedBox(height: 0)
                                : SizedBox(height: 10),
                            role == GlobalLists.unitrole
                                ? unitcard()
                                : (role == GlobalLists.headrole ||
                                      role == GlobalLists.reginalmanagerrole ||
                                      role == GlobalLists.clientrole ||
                                      role == GlobalLists.operationrole ||
                                      role == GlobalLists.operationmanagerrole)
                                ? headcard()
                                : supervisormodule(),
                          ],
                        ),
                      ),
                    ),
                    (role == GlobalLists.unitrole)
                        ? Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                bottom: 10,
                                right: 15,
                              ),
                              child: FloatingActionButton(
                                backgroundColor: customcolor.blue,
                                onPressed: () {
                                  // Add your action for the center button here
                                  clientnamecontroller.text = "";
                                  namecontroller.text = "";
                                  mobilecontroller.text = "";
                                  isexpandedclient = false;
                                  addaddtendance(context);
                                },
                                child: Icon(
                                  Icons.add,
                                  color: customcolor.white,
                                ),
                              ),
                            ),
                          )
                        : (role == GlobalLists.clientrole)
                        ? Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                bottom: 10,
                                right: 15,
                              ),
                              child: _getFAB(),
                            ),
                          )
                        : (role == GlobalLists.operationrole ||
                              role == GlobalLists.operationmanagerrole)
                        ? Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                bottom: 10,
                                right: 15,
                              ),
                              child: _getoperationalFAB(),
                            ),
                          )
                        : (role ==
                              GlobalLists
                                  .headrole /*||  role == GlobalLists.reginalmanagerrole*/ )
                        ? Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                bottom: 10,
                                right: 15,
                              ),
                              child: _getheadroleFAB(),
                            ),
                          )
                        : Container(),
                  ],
                ),
              )
            : Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 20,
                      bottom: 20,
                    ),
                    child: Container(
                      child: ListView(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        children: [
                          Container(
                            child: Text(
                              "DASHBOARD",
                              style: AppFonts.headerwithletterStyle(
                                fontSize: ResponsiveFlutter.of(
                                  context,
                                ).fontSize(2.5),
                                color: customcolor.title,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8,
                              ),
                              //
                            ),
                          ),
                          (role == GlobalLists.headrole ||
                                  role == GlobalLists.reginalmanagerrole ||
                                  role == GlobalLists.clientrole ||
                                  role == GlobalLists.operationrole ||
                                  role == GlobalLists.operationmanagerrole)
                              ? SizedBox(height: 0)
                              : SizedBox(height: 10),
                          role == GlobalLists.unitrole
                              ? unitcard()
                              : (role == GlobalLists.headrole ||
                                    role == GlobalLists.reginalmanagerrole ||
                                    role == GlobalLists.clientrole ||
                                    role == GlobalLists.operationrole ||
                                    role == GlobalLists.operationmanagerrole)
                              ? headcard()
                              : supervisormodule(),
                        ],
                      ),
                    ),
                  ),
                  (role == GlobalLists.unitrole)
                      ? Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              bottom: 10,
                              right: 15,
                            ),
                            child: FloatingActionButton(
                              backgroundColor: customcolor.blue,
                              onPressed: () {
                                // Add your action for the center button here
                                clientnamecontroller.text = "";
                                namecontroller.text = "";
                                mobilecontroller.text = "";
                                isexpandedclient = false;
                                addaddtendance(context);
                              },
                              child: Icon(Icons.add, color: customcolor.white),
                            ),
                          ),
                        )
                      : (role == GlobalLists.clientrole)
                      ? Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              bottom: 10,
                              right: 15,
                            ),
                            child: _getFAB(),
                          ),
                        )
                      : (role == GlobalLists.operationrole ||
                            role == GlobalLists.operationmanagerrole ||
                            role == GlobalLists.reginalmanagerrole)
                      ? Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              bottom: 10,
                              right: 15,
                            ),
                            child: _getoperationalFAB(),
                          ),
                        )
                      : (role ==
                            GlobalLists
                                .headrole /*||  role == GlobalLists.reginalmanagerrole*/ )
                      ? Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              bottom: 10,
                              right: 15,
                            ),
                            child: _getheadroleFAB(),
                          ),
                        )
                      : Container(),
                ],
              ),
      ),
    );
  }

  Widget agendaDropdown(StateSetter setStateDialgoue) {
    return Container(
      height: agendalist.length <= 1
          ? 100
          : agendalist.length <= 2
          ? 150
          : 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Card(
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Scrollbar(
            thumbVisibility: agendalist.length <= 2 ? false : true,
            child: ListView(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: agendalist.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        //                       GestureDetector(
                        //                         onTap: () {
                        //                           setStateDialgoue(() {
                        //                             sitenamecontroller.text =
                        //                                 agendalist[index].name;

                        //                             isexpanded = false;
                        //                           });
                        //                         },
                        //                         child: Container(
                        //                           color: Colors.white,
                        //                           width: SizeConfig.blockSizeHorizontal * 100,
                        //                           child: Text(
                        //                             agendalist[index].name,
                        //                             style:
                        //                                                                      AppFonts.headerStyle(fontSize:14,
                        // color: customcolor.black,fontWeight: FontWeight.normal  ),

                        //                           ),
                        //                         ),
                        //                       ),
                        CheckboxListTile(
                          activeColor: customcolor.green,
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          title: Text(
                            agendalist[index].name,
                            style: AppFonts.headerStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          value: agendalist[index].isselected,
                          onChanged: (value) {
                            setStateDialgoue(() {
                              List<String> agelist = [];
                              List<String> agendais = [];
                              agendalist[index].isselected = value!;
                              for (int i = 0; i < agendalist.length; i++) {
                                if (agendalist[i].isselected) {
                                  agelist.add(agendalist[i].name.toString());
                                  agendais.add(agendalist[i].id.toString());
                                }
                              }
                              String s = agelist.join(', ');
                              agendacontroller.text = s;
                              agendaid = agendais;
                              // print("multipleSelectedlist");
                              // print(multipleSelectedlist);
                              // print(checkboxeslist[indexcheck]);

                              // if (multipleSelectedlist.contains(checkboxeslist[indexcheck])) {
                              //   multipleSelectedlist.remove(checkboxeslist[indexcheck]);
                              // } else {
                              //   multipleSelectedlist.add(checkboxeslist[indexcheck]);
                              // }
                            });
                          },
                        ),

                        // Divider(
                        //   color: customcolor.greybg
                        // )
                      ],
                    );
                  },
                ),
                Divider(),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      setStateDialgoue(() {
                        isexpanded = false;
                      });
                    },
                    child: Container(
                      color: customcolor.white,
                      width: SizeConfig.blockSizeHorizontal * 100,
                      child: Center(
                        child: Text(
                          "Submit",
                          style: AppFonts.headerStyle(
                            fontSize: 12,
                            color: customcolor.blue,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget siteDropdown(StateSetter setStateDialgoue) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Card(
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: ListView.builder(
            itemCount: GlobalLists.sitemasterlist.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      setStateDialgoue(() {
                        sitenamecontroller.text =
                            GlobalLists.sitemasterlist[index].siteName;
                        attendancesiteid = GlobalLists.sitemasterlist[index].id
                            .toString();
                        isexpanded = false;
                      });
                    },
                    child: Container(
                      color: Colors.white,
                      width: SizeConfig.blockSizeHorizontal * 100,
                      child: Text(
                        GlobalLists.sitemasterlist[index].siteName,
                        style: AppFonts.headerStyle(
                          fontSize: 14,
                          color: customcolor.black,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Divider(color: customcolor.greybg),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget clientDropdown(StateSetter setStateDialgoue) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Card(
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.only(left: 10, right: 10, top: 10),
          child: ListView.builder(
            itemCount: GlobalLists.clientmasterlist.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      setStateDialgoue(() {
                        clientnamecontroller.text =
                            GlobalLists.clientmasterlist[index].clientName;

                        isexpandedclient = false;
                        sitenamecontroller.text = "";

                        attendanceclientid = GlobalLists
                            .clientmasterlist[index]
                            .clientId
                            .toString();
                        attendancesiteid = GlobalLists
                            .clientmasterlist[index]
                            .siteId
                            .toString();
                        isexpandedjanitor = false;
                        namecontroller.text = "";
                        janotoragendaApi(attendanceclientid, attendancesiteid);
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 3, bottom: 2),
                      child: Container(
                        color: Colors.white,
                        width: SizeConfig.blockSizeHorizontal * 100,
                        child: Text(
                          //  GlobalLists.clientmasterlist[index].clientName==null?"":
                          GlobalLists.clientmasterlist[index].clientName,
                          style: AppFonts.headerStyle(
                            fontSize: 14,
                            color: customcolor.black,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Divider(color: customcolor.greybg),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget unitcard() {
    return CustomRefreshIndicator(
      key: refreshIndicatorKey,
      builder:
          (BuildContext context, Widget child, IndicatorController controller) {
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
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => Attendance("OverAll"),
                  // AllCategory()
                ),
              );
            },
            child: Material(
              elevation: 2,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: SizeConfig.blockSizeHorizontal * 100,
                height: SizeConfig.blockSizeVertical * 12,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: SizeConfig.blockSizeHorizontal * 25,
                      height: SizeConfig.blockSizeVertical * 12,
                      child: GestureDetector(
                        onTap: () {
                          //                                                                   Navigator.push(
                          // context,
                          // MaterialPageRoute(
                          //     builder: (BuildContext context) => LineChartSample2()

                          //     ));
                        },
                        child: Image.asset(
                          'assets/images/image4.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    SizedBox(width: SizeConfig.blockSizeHorizontal * 2),
                    Container(
                      width: SizeConfig.blockSizeHorizontal * 42,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ATTENDANCE',
                            maxLines: 2,
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            style: AppFonts.headerwithletterStyle(
                              fontSize: ResponsiveFlutter.of(
                                context,
                              ).fontSize(2),
                              color: customcolor.black,
                              fontWeight: FontWeight.w100,
                              letterSpacing: 1.5,
                            ),
                          ),
                          SizedBox(height: 5),
                          RichText(
                            textAlign: TextAlign.justify,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      "${GlobalLists.unitdashboard.lowatteandancecount.toString()}/${GlobalLists.unitdashboard.totalSiteCount.toString()} ",
                                  style: AppFonts.headerStyle(
                                    fontSize: ResponsiveFlutter.of(
                                      context,
                                    ).fontSize(1.5),
                                    color: customcolor.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: "Sites with",
                                  style: AppFonts.headerStyle(
                                    fontSize: ResponsiveFlutter.of(
                                      context,
                                    ).fontSize(1.5),
                                    color: customcolor.subtitle,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            "full attendance",
                            maxLines: 2,
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            style: AppFonts.headerStyle(
                              fontSize: ResponsiveFlutter.of(
                                context,
                              ).fontSize(1.5),
                              color: customcolor.subtitle,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: Container(
                        // color: customcolor.appbarcolor,
                        child: CircularPercentIndicator(
                          animationDuration: 500,
                          //   radius: 35.0,
                          lineWidth: 4.0,
                          radius: 34.0,
                          //   lineWidth: 5.0,
                          animation: true,
                          percent:
                              GlobalLists.unitdashboard.attendancePercentage >
                                  100.0
                              ? 0.0
                              : GlobalLists.unitdashboard.attendancePercentage /
                                    100,
                          //0.4,
                          center: new Text(
                            GlobalLists.unitdashboard.notapplicable == 0
                                ? "NA"
                                : "${GlobalLists.unitdashboard.attendancePercentage.toStringAsFixed(0)}%",
                            style: AppFonts.headerStyle(
                              fontSize: ResponsiveFlutter.of(
                                context,
                              ).fontSize(2),
                              color: customcolor.textorangecolor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          circularStrokeCap: CircularStrokeCap.round,
                          progressColor: customcolor.textblue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Image.asset(
                    'assets/images/lowattendance.png',
                    width: 30,
                    height: 30,
                  ),
                ),
                SizedBox(width: 5),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "LOW ATTENDANCE",
                    maxLines: 2,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    style: AppFonts.headerwithletterStyle(
                      fontSize: ResponsiveFlutter.of(context).fontSize(2),
                      color: customcolor.black,
                      fontWeight: FontWeight.w100,
                      letterSpacing: 1.5,
                    ),
                    //
                  ),
                ),
              ],
            ),
          ),
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: GlobalLists.unitlowattendacelist.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(top: 10),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => Attendance(
                          "${GlobalLists.unitlowattendacelist[index].clientName}",
                        ),
                        // AllCategory()
                      ),
                    );
                  },
                  child: Material(
                    elevation: 0,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: SizeConfig.blockSizeHorizontal * 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //19march
                            Container(
                              width: SizeConfig.blockSizeHorizontal * 72,
                              child: Text(
                                GlobalLists
                                    .unitlowattendacelist[index]
                                    .clientName,
                                maxLines: 2,
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                style: AppFonts.headerwithletterStyle(
                                  fontSize: ResponsiveFlutter.of(
                                    context,
                                  ).fontSize(1.8),
                                  color: customcolor.black,
                                  fontWeight: FontWeight.w100,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ),

                            Text(
                              "${GlobalLists.unitlowattendacelist[index].attendedCount.toString()}/${GlobalLists.unitlowattendacelist[index].totalStaff.toString()}",
                              maxLines: 2,
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                              style: AppFonts.headerStyle(
                                fontSize: ResponsiveFlutter.of(
                                  context,
                                ).fontSize(1.8),
                                color: customcolor.textorangecolor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  showfileimage(String title, String resultvalue) {
    return showDialog(
      context: context,
      builder: (_) {
        print("showimaf");
        print(resultvalue);
        return AlertDialog(
          scrollable: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${title}"),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(Icons.close),
              ),
            ],
          ),
          content: SingleChildScrollView(
            //MUST TO ADDED
            physics: NeverScrollableScrollPhysics(),
            child: Container(
              height: SizeConfig.blockSizeVertical * 30,
              width: double.maxFinite,
              child: ListView(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                // mainAxisSize: MainAxisSize.min,
                children: [
                  // (resultvalue=="null"||resultvalue==null ||resultvalue=="")?  Container():
                  (resultvalue == null ||
                          resultvalue == "" ||
                          resultvalue == "null")
                      ? Center(
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: SizeConfig.blockSizeVertical * 10,
                            ),
                            child: Text("No Image Uploaded"),
                          ),
                        )
                      : Image.file(
                          File(resultvalue),
                          //width: SizeConfig.blockSizeHorizontal*100,
                          height: SizeConfig.blockSizeVertical * 28,
                          fit: BoxFit.cover,

                          errorBuilder:
                              (
                                BuildContext context,
                                Object exception,
                                StackTrace? stackTrace,
                              ) {
                                return Icon(
                                  Icons.error_outline,
                                  size: SizeConfig.blockSizeHorizontal * 10,
                                );
                              },
                        ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void checkPermissionStatus() async {
    var status = await permishan.Permission.locationWhenInUse.status;
    if (status != permishan.PermissionStatus.granted) {
      //show Dialog or route to specific page (or route to Application Manager)
      print("notgranted");
      grantPermission();
      // ShowDialogs.showToast("Please Allow Your Location Permission From Setting  To Add your Attendance");
      // openAppSettings();
    } else {
      print("granted");

      getLocation().then((value) {
        print("hii");
        if (value != null) {
          print("notnull");
          getLocation();
        } else {
          print("null");
          grantPermission();
          ShowDialogs.showToast(
            "Please Allow Your Location Permission From Setting  To Add your Attendance",
          );
        }

        // _getLocation();
        //    searching = !searching;
      });
      // Go to Second Screen
    }
  }

  _buildChoicemainList() {
    List<Widget> choices = [];
    mainlisttab.forEachIndexedmain((item, value) {
      choices.add(
        Container(
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
                          // item.status == 0?customcolor.red:
                          customcolor.greytext,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              side: BorderSide(
                width: 0.5,
                color: maintag == value
                    ? customcolor.white
                    :
                      // item.status == 0?customcolor.red:
                      customcolor.white,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              labelStyle: AppFonts.headerStyle(
                fontSize: 12,
                color: maintag == value
                    ? customcolor.blue
                    : customcolor.greytext,
                fontWeight: FontWeight.bold,
              ),
              selectedColor: customcolor.tabblue,
              backgroundColor: customcolor.white,
              selected: maintag == value,
              onSelected: (selected) {
                setState(() {
                  _isSelected = item.clientName;
                  maintag = value;
                  // print(mainlisttab[maintag].id.toString());
                  // print(mainlisttab[maintag].clientName);
                  GlobalLists.clienname = item.clientName;
                  unitdashboardApi();
                });
              },
            ),
          ),
        ),
      );
    });
    return choices;
  }

  addtraing(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      isScrollControlled: true,
      elevation: 5.0,
      barrierColor: Colors.black.withOpacity(0.7),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(20.0),
          topRight: const Radius.circular(20.0),
        ),
      ),
      context: context,
      builder: (builder) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStateDialgoue) {
            return new Container(
              height: (isexpanded == true || isexpandedjanitor == true)
                  ? SizeConfig.blockSizeVertical * 85 +
                        MediaQuery.of(context).viewInsets.bottom
                  : (result.length >= 1)
                  ? SizeConfig.blockSizeVertical * 85 +
                        MediaQuery.of(context).viewInsets.bottom
                  : SizeConfig.blockSizeVertical * 65 +
                        MediaQuery.of(context).viewInsets.bottom,
              //  height:(isexpanded==true||isexpandedjanitor==true)?SizeConfig.blockSizeVertical * 68 +
              //     MediaQuery.of(context).viewInsets.bottom: SizeConfig.blockSizeVertical * 65 +
              //     MediaQuery.of(context).viewInsets.bottom,
              color: Colors.white,
              margin: EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 2),
              padding: EdgeInsets.all(5),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 5),
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
                      SizedBox(height: 20),
                      Text(
                        "Create Training",
                        textAlign: TextAlign.left,
                        style: AppFonts.headerStyle(
                          fontSize: 22,
                          color: customcolor.black,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 15),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: selectedDateTime ?? DateTime.now(),
                                firstDate: DateTime(1950),
                                lastDate: DateTime(2050),
                              );

                              if (pickedDate != null) {
                                var datefrom = DateFormat(
                                  'dd-MM-yyyy',
                                ).format(pickedDate);
                                datecontroller.text = datefrom;
                                print(datecontroller.text);
                                setState(() => selectedDateTime = pickedDate);
                              }
                            },
                            child: FormTextField(
                              isEnable: false,
                              textcontroller: datecontroller,
                              placeholderStr: "Date of Training",
                              suffixWidget: Padding(
                                padding: EdgeInsets.only(right: 20),
                                child: Image.asset(
                                  "assets/images/calendar.png",
                                  width: 20,
                                  height: 20,
                                ),
                              ),
                              textInputType: TextInputType.text,
                              onchange: (val) {},
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),

                      Stack(
                        children: [
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setStateDialgoue(() {
                                    isexpandedclient = !isexpandedclient;
                                    isexpandedjanitor = false;
                                    isexpanded = false;
                                  });
                                },
                                child: FormTextField(
                                  isEnable: false,
                                  textcontroller: clientnamecontroller,
                                  placeholderStr: "Client Name",
                                  suffixWidget: Padding(
                                    padding: EdgeInsets.only(right: 20),
                                    child: Image.asset(
                                      "assets/images/dropdown.png",
                                      width: 10,
                                      height: 10,
                                    ),
                                  ),
                                  textInputType: TextInputType.text,
                                  onchange: (val) {},
                                ),
                              ),
                              Stack(
                                children: [
                                  Column(
                                    children: [
                                      SizedBox(height: 20),
                                      GestureDetector(
                                        onTap: () {
                                          setStateDialgoue(() {
                                            isexpanded = !isexpanded;
                                            isexpandedjanitor = false;
                                            isexpandedclient = false;
                                          });
                                        },
                                        child: FormTextField(
                                          isEnable: false,
                                          textcontroller: agendacontroller,
                                          placeholderStr: "Training Agenda",
                                          suffixWidget: Padding(
                                            padding: EdgeInsets.only(right: 20),
                                            child: Image.asset(
                                              "assets/images/dropdown.png",
                                              width: 10,
                                              height: 10,
                                            ),
                                          ),
                                          textInputType: TextInputType.text,
                                          onchange: (val) {},
                                        ),
                                      ),
                                      Stack(
                                        children: [
                                          Column(
                                            children: [
                                              SizedBox(height: 20),
                                              GestureDetector(
                                                onTap: () {
                                                  setStateDialgoue(() {
                                                    isexpandedjanitor =
                                                        !isexpandedjanitor;
                                                    isexpanded = false;
                                                    isexpandedclient = false;
                                                  });
                                                },
                                                child: FormTextField(
                                                  isEnable: false,
                                                  textcontroller:
                                                      namecontroller,
                                                  placeholderStr:
                                                      "Name of Janitor Trained",
                                                  suffixWidget: Padding(
                                                    padding: EdgeInsets.only(
                                                      right: 20,
                                                    ),
                                                    child: Image.asset(
                                                      "assets/images/dropdown.png",
                                                      width: 10,
                                                      height: 10,
                                                    ),
                                                  ),
                                                  textInputType:
                                                      TextInputType.text,
                                                  onchange: (val) {},
                                                ),
                                              ),
                                              Stack(
                                                children: [
                                                  Column(
                                                    children: [
                                                      Stack(
                                                        children: [
                                                          Column(
                                                            children: [
                                                              SizedBox(
                                                                height: 20,
                                                              ),
                                                              GestureDetector(
                                                                onTap: () {
                                                                  _showSelectionDialog(
                                                                    context,
                                                                    1,
                                                                    setStateDialgoue,
                                                                  );
                                                                },
                                                                child: FormTextField(
                                                                  isEnable:
                                                                      false,
                                                                  textcontroller:
                                                                      uploadcontroller,
                                                                  placeholderStr:
                                                                      "Upload Image",

                                                                  //   maxLength: 10,
                                                                  textInputType:
                                                                      TextInputType
                                                                          .text,
                                                                  onchange:
                                                                      (val) {},
                                                                  suffixWidget: Padding(
                                                                    padding:
                                                                        EdgeInsets.only(
                                                                          right:
                                                                              20,
                                                                        ),
                                                                    child: Image.asset(
                                                                      "assets/images/addimage.png",
                                                                      width: 20,
                                                                      height:
                                                                          20,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              result.length == 0
                                                                  ? Container()
                                                                  : Padding(
                                                                      padding: const EdgeInsets.only(
                                                                        left: 5,
                                                                        top: 3,
                                                                        bottom:
                                                                            2,
                                                                      ),
                                                                      child: Wrap(
                                                                        alignment:
                                                                            WrapAlignment.start,
                                                                        runAlignment:
                                                                            WrapAlignment.start,
                                                                        crossAxisAlignment:
                                                                            WrapCrossAlignment.start,
                                                                        spacing:
                                                                            6.0,
                                                                        children:
                                                                            List<
                                                                              Widget
                                                                            >.generate(
                                                                              result.length,
                                                                              (
                                                                                int
                                                                                index,
                                                                              ) {
                                                                                return GestureDetector(
                                                                                  onTap: () async {
                                                                                    print(
                                                                                      "openfile",
                                                                                    );
                                                                                    showfileimage(
                                                                                      result[index]
                                                                                          .split(
                                                                                            '/',
                                                                                          )
                                                                                          .last,
                                                                                      result[index],
                                                                                    );
                                                                                    // Navigator.push(
                                                                                    //     context,
                                                                                    //     MaterialPageRoute(
                                                                                    //         builder: (BuildContext context) => OpenfilePage(
                                                                                    //               videoUrl: widget.taskupdatedlist.filelist[index].fileLink,
                                                                                    //             )));

                                                                                    // pdfAsset(uploadpath[index]).then((file) {
                                                                                    //   OpenFile.open(file.path);
                                                                                    // });
                                                                                    // await OpenFile.open(uploadpath[index]);
                                                                                  },
                                                                                  child: Chip(
                                                                                    side: BorderSide(
                                                                                      style: BorderStyle.solid,
                                                                                      color: customcolor.blue,
                                                                                    ),
                                                                                    shape: RoundedRectangleBorder(
                                                                                      borderRadius: BorderRadius.all(
                                                                                        Radius.circular(
                                                                                          4,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    labelPadding: EdgeInsets.all(
                                                                                      2.0,
                                                                                    ),
                                                                                    // avatar: CircleAvatar(
                                                                                    //     backgroundColor: Colors.transparent,
                                                                                    //     child: Icon(
                                                                                    //       Icons.contact_phone_rounded,
                                                                                    //       size: 20,
                                                                                    //       color: Colors.black,
                                                                                    //     )),
                                                                                    label: Text(
                                                                                      result[index]
                                                                                          .split(
                                                                                            '/',
                                                                                          )
                                                                                          .last,
                                                                                      style: TextStyle(
                                                                                        color: customcolor.blue,
                                                                                        fontSize: 12,
                                                                                      ),
                                                                                    ),
                                                                                    onDeleted: () {
                                                                                      setStateDialgoue(
                                                                                        () {
                                                                                          result.removeAt(
                                                                                            index,
                                                                                          );
                                                                                          List<
                                                                                            String
                                                                                          >
                                                                                          filename = [];
                                                                                          uploadcontroller.text = "";
                                                                                          for (
                                                                                            int i = 0;
                                                                                            i <
                                                                                                result.length;
                                                                                            i++
                                                                                          ) {
                                                                                            filename.add(
                                                                                              result[i]
                                                                                                  .split(
                                                                                                    '/',
                                                                                                  )
                                                                                                  .last,
                                                                                            );
                                                                                          }
                                                                                          print(
                                                                                            filename,
                                                                                          );
                                                                                          String s = filename.join(
                                                                                            ', ',
                                                                                          );
                                                                                          print(
                                                                                            s,
                                                                                          );

                                                                                          uploadcontroller.text = s;
                                                                                        },
                                                                                      );
                                                                                    },
                                                                                    deleteIcon: Icon(
                                                                                      Icons.close,
                                                                                      color: customcolor.blue,
                                                                                      size: 20,
                                                                                    ),

                                                                                    backgroundColor: customcolor.blue.withOpacity(
                                                                                      0.1,
                                                                                    ),
                                                                                    // elevation: 6.0,
                                                                                    // shadowColor: Colors.grey[60],
                                                                                    // padding: EdgeInsets.all(6.0),
                                                                                  ),
                                                                                );
                                                                              },
                                                                            ),
                                                                      ),
                                                                    ),
                                                              SizedBox(
                                                                height: 30,
                                                              ),
                                                              Center(
                                                                child: ElevatedButton(
                                                                  style: ElevatedButton.styleFrom(
                                                                    backgroundColor:
                                                                        customcolor
                                                                            .blue,
                                                                    minimumSize: Size(
                                                                      SizeConfig
                                                                              .blockSizeHorizontal *
                                                                          80,
                                                                      SizeConfig
                                                                              .blockSizeVertical *
                                                                          6,
                                                                    ),
                                                                    textStyle: AppFonts.headerStyle(
                                                                      fontSize:
                                                                          15,
                                                                      color: customcolor
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                  onPressed: () {
                                                                    if (datecontroller
                                                                        .text
                                                                        .isEmpty) {
                                                                      ShowDialogs.showToast(
                                                                        "Please Select Training Date",
                                                                      );
                                                                    } else if (agendacontroller
                                                                        .text
                                                                        .isEmpty) {
                                                                      ShowDialogs.showToast(
                                                                        "Please Select Training Agenda",
                                                                      );
                                                                    } else if (janitorname ==
                                                                        "") {
                                                                      ShowDialogs.showToast(
                                                                        "Please Select Trained Janitor",
                                                                      );
                                                                    } else if (result ==
                                                                        "") {
                                                                      ShowDialogs.showToast(
                                                                        "Please upload Image",
                                                                      );
                                                                    } else {
                                                                      operationaladdtrainingApi();
                                                                    }
                                                                  },
                                                                  child:
                                                                      addTrainingLoad
                                                                      ? CircularProgressIndicator(
                                                                          color:
                                                                              customcolor.white,
                                                                        )
                                                                      : Text(
                                                                          'Create',
                                                                          style: AppFonts.headerStyle(
                                                                            fontSize:
                                                                                14,
                                                                            color:
                                                                                customcolor.white,
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                          ),
                                                                        ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          isexpandedjanitor
                                                              ? janitorsDropdown(
                                                                  setStateDialgoue,
                                                                )
                                                              : Container(),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          isexpanded
                                              ? agendaDropdown(setStateDialgoue)
                                              : Container(),
                                        ],
                                      ),
                                    ],
                                  ),
                                  isexpandedclient
                                      ? clientDropdown(setStateDialgoue)
                                      : Container(),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),

                      //                         Stack(
                      //                           children: [
                      //                             Column(
                      //                               children: [
                      //                                  SizedBox(height: 20,),
                      //                         //          FormTextField(
                      //                         //   textcontroller: namecontroller,
                      //                         //   placeholderStr: "Name of Janitor Trained",

                      //                         //   textInputType: TextInputType.text,
                      //                         //   onchange: (val) {

                      //                         //   },
                      //                         // ),
                      //                                   Container(
                      //                                       height: 47,

                      // decoration: BoxDecoration(

                      //     borderRadius: BorderRadius.circular(10),
                      //     border: Border.all(width: 1, color: customcolor.greyborder)),
                      //                                     child: Padding(
                      //                                       padding: const EdgeInsets.only(left: 5),
                      //                                       child: RawAutocomplete<Janitorcheckbox>(
                      //                                                                         //  textEditingController: textEditingController1,
                      //                                                             optionsBuilder: (TextEditingValue textEditingValue) {

                      //                                                               if (textEditingValue.text == '') {

                      //                                                                  List<Janitorcheckbox> matches = <Janitorcheckbox>[];
                      //                                                                   matches.addAll(dropdownList);

                      //                                                                   // matches.retainWhere((s){
                      //                                                                   //   return s.toLowerCase().contains(textEditingValue.text.toLowerCase());
                      //                                                                   // });
                      //                                                                   return matches.toList();
                      //                                                               //  return const Iterable<String>.empty();
                      //                                                               }else{
                      //                                                                   List<Janitorcheckbox> matches = <Janitorcheckbox>[];
                      //                                                                   matches.addAll(dropdownList);
                      //                                                      return matches
                      //                                                                 .where((Janitorcheckbox category) => category.name.toLowerCase()
                      //                                                                   .startsWith(textEditingValue.text.toLowerCase())
                      //                                                                 )
                      //                                                                 .toList();

                      //                                                               }
                      //                                                             },
                      //                                                     displayStringForOption: (Janitorcheckbox option) => option.name,
                      //                                                             onSelected: (Janitorcheckbox selection) {
                      //                                                               FocusScope.of(context).unfocus();
                      //                                                                 print('You just selected category${selection}');
                      //                                                                 setState(() {

                      //                                                                 });
                      //                                                             },

                      //                                                             fieldViewBuilder: (BuildContext context, TextEditingController textEditingController,
                      //                                                                 FocusNode focusNode,
                      //                                                                 VoidCallback onFieldSubmitted) {
                      //                                                                   textEditingController.text=janitorname;
                      //                                                                   textEditingController.selection = TextSelection.collapsed(offset: textEditingController.text.length);
                      //                                                                //    textEditingController.selection = TextSelection.fromPosition(TextPosition(offset: textEditingController.text.length));
                      //                                                                   return
                      //                                                                   TextField(
                      //                                                           onChanged: (val)
                      //                                                           {
                      //                                                                                 //                         final val = TextSelection.collapsed(offset: textEditingController.text.length);
                      //                                                                                 //  textEditingController.selection = val;
                      //                                                           },
                      //                                                           decoration: InputDecoration(
                      //                                                             hintText: "Name of Janitor Trained",
                      //                                                                           border: InputBorder.none,
                      //                                                                           labelStyle:
                      //              AppFonts.headerStyle(fontSize:14,
                      //                     color: customcolor.hinttext,
                      //                     fontWeight: FontWeight.w400  ),

                      //           hintStyle:  AppFonts.headerStyle(fontSize:14,
                      //                     color: customcolor.hinttext,
                      //                     fontWeight: FontWeight.w400  ),
                      //                                                             // enabledBorder: UnderlineInputBorder(
                      //                                                             //   borderSide: BorderSide(color: customcolor.greybg),
                      //                                                             // ),
                      //                                                             // focusedBorder: UnderlineInputBorder(
                      //                                                             //   borderSide: BorderSide(color: customcolor.greybg),
                      //                                                             // ),
                      //                                                             suffixIcon:
                      //                                                               GestureDetector(
                      //                                                               onTap: ()
                      //                                                               {
                      //                                                     setState(() {

                      //                                                     textEditingController.text="";

                      //                                                     });
                      //                                                               },
                      //                                                               child:
                      //                                                        Image.asset(
                      //                           "assets/images/dropdown.png",
                      //                         scale:2.6,
                      //                           width: 2,
                      //                           height: 2,
                      //                                                         ),
                      //                                                     //           Icon(
                      //                                                     //   Icons.arrow_drop_down_sharp,
                      //                                                     //   color:customcolor.greyborder,
                      //                                                     // ),
                      //                                                             ),
                      //                                                           ),
                      //                                                           controller: textEditingController,

                      //                                                           focusNode: focusNode,

                      //                                                           onSubmitted: (String value) {

                      //                                                           },
                      //                                                                   );
                      //                                                             },

                      //                                                             optionsViewBuilder: (BuildContext context, void Function(Janitorcheckbox) onSelected,
                      //                                                                        Iterable<Janitorcheckbox> options) {
                      //                                                                 return Align(
                      //                                                               alignment: Alignment.topLeft,
                      //                                                               child: Material(
                      //                                                                 elevation: 1,
                      //                                                                 shape: const RoundedRectangleBorder(
                      //                                                                   borderRadius: BorderRadius.vertical(bottom: Radius.circular(4.0)),
                      //                                                                 ),
                      //                                                                 child: Column(
                      //                                                                   children: [
                      //                                                                     Container(
                      //                                                                       // color: customcolor.blue,
                      //                                                                       height:options.length<=2?SizeConfig.blockSizeVertical*10: 140,
                      //                                                                        width: SizeConfig.blockSizeHorizontal*85,
                      //                                                                      // width: constraints.biggest.width, // <-- Right here !
                      //                                                                       child: ListView.builder(
                      //                                                           padding: EdgeInsets.zero,
                      //                                                           itemCount: options.length,
                      //                                                           shrinkWrap: false,
                      //                                                                         // physics: ScrollPhysics(),
                      //                                                           itemBuilder: (BuildContext context, int index) {
                      //                                                             final Janitorcheckbox option = options.elementAt(index);
                      //                                                             return GestureDetector(
                      //                                                               onTap: () => onSelected(option),
                      //                                                               child: Column(
                      //                                                                         mainAxisAlignment: MainAxisAlignment.start,
                      //                                                                         crossAxisAlignment: CrossAxisAlignment.start,
                      //                                                                         children: [
                      //                                                                       // Text(option.name),
                      //                                                                       // Divider()
                      //                                                                            CheckboxListTile(
                      //                  activeColor: customcolor.green,

                      //                  controlAffinity: ListTileControlAffinity.leading,
                      //                   contentPadding: EdgeInsets.zero,
                      //                   dense: true,
                      //                   title: Text(
                      //                     option.name,
                      //                     style:
                      //                      AppFonts.headerStyle(fontSize:12,
                      //       color:Colors.black,fontWeight: FontWeight.normal  ),

                      //                   ),
                      //                   value: option.isselected,
                      //                   onChanged: (value) {
                      //                     setStateDialgoue(() {

                      //                        option.isselected = value!;

                      //                       // sitenamecontroller.text=agelist.toString();
                      //                       // print("multipleSelectedlist");
                      //                       // print(multipleSelectedlist);
                      //                       // print(checkboxeslist[indexcheck]);

                      //                       // if (multipleSelectedlist.contains(checkboxeslist[indexcheck])) {
                      //                       //   multipleSelectedlist.remove(checkboxeslist[indexcheck]);
                      //                       // } else {
                      //                       //   multipleSelectedlist.add(checkboxeslist[indexcheck]);
                      //                       // }
                      //                   });
                      //                   },
                      //                 ),

                      //                                                                         ],
                      //                                                               ),
                      //                                                             );
                      //                                                           },
                      //                                                                       ),
                      //                                                                     ),
                      //                                                                       Divider(),
                      //             Center(
                      //               child: GestureDetector(
                      //                 onTap: ()
                      //                 {
                      //                    setStateDialgoue(() {
                      //                   List<String> agelist=[];
                      //                    List<String> ageidlist=[];
                      //                         for(int i=0;i<dropdownList.length;i++)
                      //                      {
                      //                       if(dropdownList[i].isselected)
                      //                       {
                      //                       agelist.add(dropdownList[i].name.toString());
                      //                       ageidlist.add(dropdownList[i].id.toString());
                      //                       }
                      //                      }
                      //                      String s = agelist.join(', ');
                      //                      janitorname=s;
                      //                      janitorid=ageidlist;

                      //                   });
                      //                 },
                      //                 child: Text("Submit", style:
                      //                            AppFonts.headerStyle(fontSize:12,
                      //                           color:customcolor.blue,fontWeight: FontWeight.normal  ),),
                      //               ),
                      //             ),
                      //             SizedBox(height: 20,)
                      //                                                                   ],
                      //                                                                 ),
                      //                                                               ),
                      //                                                             );
                      //                                                             },
                      //                                                     ),
                      //                                     ),
                      //                                   ),
                      //                         SizedBox(height: 20,),
                      //       GestureDetector(
                      //         onTap: ()
                      //         {
                      //            _showSelectionDialog(context,1);
                      //         },
                      //         child: FormTextField(
                      //           isEnable: false,
                      //                             textcontroller: uploadcontroller,
                      //                             placeholderStr: "Upload Image",

                      //                             //   maxLength: 10,
                      //                             textInputType: TextInputType.text,
                      //                             onchange: (val) {

                      //                             },
                      //                             suffixWidget: Padding(
                      //                             padding:  EdgeInsets.only(right: 20),
                      //                             child: Image.asset(
                      //                             "assets/images/addimage.png",

                      //                             width: 20,
                      //                             height: 20,
                      //                                                           ),
                      //                           ),
                      //                           ),
                      //       ),
                      //                           SizedBox(height: 30,),
                      //                               ],
                      //                             ),
                      //                                   isexpanded?agendaDropdown(setStateDialgoue):Container(),
                      //                           ],
                      //                         ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  _displayPickImageDialog(
    BuildContext? context,
    OnPickImageCallback onPick,
  ) async {
    onPick(null, null, null);
  }

  Future<void> _showSelectionDialog(
    BuildContext context,
    int imageno,
    StateSetter setStateDialgoue,
  ) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "From where do you want to take the photo?",
                style: TextStyle(
                  color: customcolor.blue,
                  fontSize: 15,
                  fontFamily: AppFonts.didot,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Text("Gallery"),
                  onTap: () {
                    Navigator.pop(context);
                    if (result.length >= 2) {
                      ShowDialogs.showToast("You have upload 2 images");
                    } else {
                      _openFileExplorer(imageno, setStateDialgoue);
                    }
                  },
                ),
                Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  child: Text("Camera"),
                  onTap: () async {
                    Navigator.pop(context);

                    if (result.length >= 2) {
                      ShowDialogs.showToast("You have upload 2 images");
                    } else {
                      _onImageButtonPressed(
                        ImageSource.camera,
                        imageno,
                        setStateDialgoue,
                        context: context,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // void _onImageButtonPressed(
  //     ImageSource source, int imageno, StateSetter setStateDialgoue,
  //     {BuildContext? context}) async {
  //   try {
  //     final pickedFile = await ImagePicker().pickImage(
  //       source: source,
  //       maxWidth: null,
  //       maxHeight: null,
  //       imageQuality: null,
  //     );

  //     await _displayPickImageDialog(context,
  //         (double? maxWidth, double? maxHeight, int? quality) async {});
  //     setState(() {
  //       print(pickedFile);
  //       _imageFile = File(pickedFile!.path);
  //       print(_imageFile!.path);
  //       _fileName = _imageFile!.path.split('/').last;

  //       result.add(_imageFile!.path);
  //       // uploadcontroller.text=_fileName!;

  //       List<String> filename = [];
  //       uploadcontroller.text = "";
  //       for (int i = 0; i < result.length; i++) {
  //         filename.add(result[i].split('/').last);
  //       }
  //       print(filename);
  //       String s = filename.join(', ');
  //       print(s);
  //       uploadcontroller.text = s;
  //       setStateDialgoue(() {});
  //     });
  //   } catch (e) {
  //     setState(() {
  //       _pickImageError = e;
  //       print("Ruchita $e");
  //     });
  //   }
  // }

  void _onImageButtonPressed(
    ImageSource source,
    int imageno,
    StateSetter setStateDialgoue, {
    BuildContext? context,
  }) async {
    try {
      if (source == ImageSource.camera) {
        bool hasPermission = await PermissionHelper.requestPermission(
          Permission.camera,
        );

        if (!hasPermission) {
          Flushbar(
            margin: const EdgeInsets.all(8),
            borderRadius: BorderRadius.circular(8),
            backgroundColor: customcolor.blue,
            message: "Camera permission denied",
            duration: Duration(seconds: 2),
            flushbarPosition: FlushbarPosition.TOP,
          ).show(this.context);
          return;
        }

        // Open custom camera screen
        Navigator.push(
          context!,
          MaterialPageRoute(
            builder: (context) => CameraCaptureScreen(
              onImageCaptured: (String imagePath) {
                setStateDialgoue(() {
                  _imageFile = File(imagePath);
                  _fileName = _imageFile!.path.split('/').last;

                  result.add(_imageFile!.path);

                  List<String> filename = [];
                  uploadcontroller.text = "";
                  for (int i = 0; i < result.length; i++) {
                    filename.add(result[i].split('/').last);
                  }

                  uploadcontroller.text = filename.join(', ');
                });
              },
            ),
          ),
        );

        return; // stop further execution for CAMERA
      }
    } catch (e) {
      setState(() {
        _pickImageError = e;
        print("Ruchita $e");
      });
    }
  }

  void _openFileExplorer(int imageno, StateSetter setStateDialgoue) async {
    setState(() => _loadingPath = true);

    try {
      final ImagePicker picker = ImagePicker();

      final List<XFile> images = await picker.pickMultiImage();

      // User cancelled
      if (images.isEmpty) {
        setState(() => _loadingPath = false);
        return;
      }

      if (images.length > 2) {
        setState(() => _loadingPath = false);
        ShowDialogs.showToast("You can upload upto 2 images");
        return;
      }

      // Clear previous data
      result.clear();

      for (final img in images) {
        result.add(img.path);
      }

      // Build filename text
      final String filenames = images.map((e) => e.name).join(', ');

      if (!mounted) return;

      setState(() {
        _loadingPath = false;
        uploadcontroller.text = filenames;
      });

      setStateDialgoue(() {});
    } catch (e) {
      setState(() => _loadingPath = false);
      debugPrint("ImagePicker error: $e");
    }
  }

  //   void _openFileExplorer(int imageno, StateSetter setStateDialgoue) async {
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

  // //  uploadcontroller.text=_fileName!;

  //         List<String> filename = [];
  //         uploadcontroller.text = "";
  //         for (int i = 0; i < result.length; i++) {
  //           filename.add(result[i].split('/').last);
  //         }
  //         print(filename);
  //         String s = filename.join(', ');
  //         print(s);
  //         uploadcontroller.text = s;
  //         setStateDialgoue(() {});
  //       }
  //       // result = _paths![0].path!;
  //       // uploadcontroller.text=_fileName!;
  //     });
  //   }

  Widget headcard() {
    double circleRadius = MediaQuery.of(context).size.width * 0.075; // adaptive
    double circleLineWidth = 5.0;

    return
    // CustomRefreshIndicator(
    //   key: refreshIndicatorKey,
    //   builder: (
    //     BuildContext context,
    //     Widget child,
    //     IndicatorController controller,
    //   ) {
    //     return Stack(
    //       alignment: Alignment.topCenter,
    //       children: <Widget>[
    //         if (!controller.isIdle)
    //           Positioned(
    //             top: 35.0 * controller.value,
    //             child: SizedBox(
    //               height: 30,
    //               width: 30,
    //               child: CircularProgressIndicator(
    //                 value: !controller.isLoading
    //                     ? controller.value.clamp(0.0, 1.0)
    //                     : null,
    //               ),
    //             ),
    //           ),
    //         Transform.translate(
    //           offset: Offset(0, 100.0 * controller.value),
    //           child: child,
    //         ),
    //       ],
    //     );
    //   },
    //   onRefresh: refreshData,
    //   child:
    ListView(
      //changes 6nov2025
      // shrinkWrap: true,
      //  physics: ScrollPhysics(),
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      children: [
        (role == GlobalLists.clientrole)
            ? mainlisttab.length > 0
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
                      ),
                      //  Wrap(
                      //      spacing: 5.0,
                      //      runSpacing: 3.0,
                      //      children: _buildChoicemainList(),
                      //    ),
                    )
                  : Container()
            : Container(),
        ListView.builder(
          scrollDirection: Axis.vertical,
          // shrinkWrap: true,
          // physics: ScrollPhysics(),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: headlist.length,
          itemBuilder: (context, index) {
            return Column(
              // shrinkWrap: true,
              // physics: ScrollPhysics(),
              children: [
                GestureDetector(
                  onTap: () {
                    if (headlist[index].type.trim() == "RATING") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => rating.Rating(
                            role == GlobalLists.clientrole
                                ? GlobalLists.clienname
                                : "",
                          ),
                        ),
                      );
                    } else if (headlist[index].type.trim() == "TRAINING") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => Training(
                            role == GlobalLists.clientrole
                                ? GlobalLists.clienname
                                : "",
                          ),
                        ),
                      );
                    } else if (headlist[index].type.trim() == "WORKFLOW") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              WorkflowstatusOperation(
                                GlobalLists.shiftid,
                                false,
                                "",
                                "",
                                role == GlobalLists.clientrole
                                    ? GlobalLists.clienname
                                    : "",
                                "",
                              ),

                          //   Workflowstatus(GlobalLists.shiftid)
                        ),
                      );
                    } else if (headlist[index].type.trim() == "ATTENDANCE") {
                      // ATTENDANCE
                      // print("ATTENDANCE Test 2${headlist[index].type}");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => Attendance(
                            role == GlobalLists.clientrole
                                ? GlobalLists.clienname
                                : "OverAll",
                          ),
                          // AllCategory()
                        ),
                      );
                    } else if (headlist[index].type.trim() ==
                        "PRIORITY TASKS") {
                      print(
                        "GlobalLists.supervisorrole ${GlobalLists.supervisorrole}",
                      );
                      if (role == GlobalLists.supervisorrole) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                PrioritySupervisor(GlobalLists.shiftid),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                PendingWorkflowstatus(
                                  "Priority Tasks",
                                  GlobalLists.shiftid,
                                  GlobalLists.priorityworkflowstatuslist,
                                ),
                          ),
                        );
                      }
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Material(
                      elevation: 2,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: SizeConfig.blockSizeHorizontal * 100,
                        //  height: SizeConfig.blockSizeVertical*12,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: SizeConfig.blockSizeHorizontal * 25,
                              child: Image.asset(headlist[index].image),
                            ),
                            SizedBox(width: SizeConfig.blockSizeHorizontal * 2),
                            Container(
                              width: SizeConfig.blockSizeHorizontal * 42,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    headlist[index].type,
                                    maxLines: 2,
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppFonts.headerwithletterStyle(
                                      fontSize: ResponsiveFlutter.of(
                                        context,
                                      ).fontSize(2),
                                      color: customcolor.black,
                                      fontWeight: FontWeight.w100,
                                    ),
                                  ),
                                  RichText(
                                    textAlign: TextAlign.justify,
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: headlist[index].value,
                                          style: AppFonts.headerStyle(
                                            fontSize: 10,
                                            color: customcolor.red,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                        TextSpan(
                                          text: headlist[index].valuename,
                                          style: AppFonts.headerStyle(
                                            fontSize: 10,
                                            color: customcolor.subtitle,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  headlist[index].note != ""
                                      ? SizedBox(height: 10)
                                      : SizedBox(height: 1),
                                  headlist[index].note != ""
                                      ? RichText(
                                          textAlign: TextAlign.justify,
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text:
                                                    headlist[index].raitngcount,
                                                style: AppFonts.headerStyle(
                                                  fontWeight: FontWeight.w300,
                                                  color: customcolor.red,
                                                  fontSize:
                                                      ResponsiveFlutter.of(
                                                        context,
                                                      ).fontSize(1.6),
                                                ),
                                              ),
                                              TextSpan(
                                                text: headlist[index].note,
                                                style: AppFonts.headerStyle(
                                                  fontWeight: FontWeight.w300,
                                                  color: customcolor.black,
                                                  fontSize:
                                                      ResponsiveFlutter.of(
                                                        context,
                                                      ).fontSize(1.6),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Container(),
                                ],
                              ),
                            ),
                            Container(
                              //  color: customcolor.appbarcolor,
                              child: isFirstLoad
                                  ? Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        // Static grey background circle
                                        CircularPercentIndicator(
                                          lineWidth: 4.0,
                                          radius: 28.0,
                                          percent: 1.0,
                                          backgroundColor: Colors.transparent,
                                          progressColor: Colors.grey.shade300,
                                          circularStrokeCap:
                                              CircularStrokeCap.round,
                                          center: Text(
                                            headlist[index].percentage ?? "0%",
                                            style: AppFonts.headerStyle(
                                              fontSize: 14,
                                              color: customcolor.appbarcolor,
                                              fontWeight: FontWeight.w100,
                                            ),
                                          ),
                                        ),

                                        // Rotating loader (slightly smaller than final circle)
                                        SizedBox(
                                          height: 50, // reduced from 58
                                          width: 50,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 4.0,
                                            valueColor: AlwaysStoppedAnimation(
                                              customcolor.textblue,
                                            ),
                                            backgroundColor: Colors.transparent,
                                          ),
                                        ),
                                      ],
                                    )
                                  : CircularPercentIndicator(
                                      animationDuration: 600,
                                      radius:
                                          28.0, // matches loading circle for smooth transition
                                      lineWidth: 4.0,
                                      animation: true,
                                      percent:
                                          (headlist[index].percvalue ?? 0.0)
                                              .clamp(0.0, 1.0),
                                      circularStrokeCap:
                                          CircularStrokeCap.round,
                                      progressColor: customcolor.textblue,
                                      backgroundColor: Colors.grey.shade300,
                                      center: Text(
                                        headlist[index].percentage ?? "0%",
                                        style: AppFonts.headerStyle(
                                          fontSize: 14,
                                          color: customcolor.appbarcolor,
                                          fontWeight: FontWeight.w100,
                                        ),
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        (role == GlobalLists.operationmanagerrole ||
                role == GlobalLists.operationrole ||
                role == GlobalLists.headrole ||
                role == GlobalLists.clientrole ||
                role == GlobalLists.reginalmanagerrole)
            ? GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => ClientVisitView(),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Material(
                    elevation: 2,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: SizeConfig.blockSizeHorizontal * 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: SizeConfig.blockSizeHorizontal * 25,
                            child: Image.asset(
                              'assets/images/operation_vists.png',
                            ),
                          ),
                          SizedBox(width: SizeConfig.blockSizeHorizontal * 2),
                          Container(
                            width: SizeConfig.blockSizeHorizontal * 42,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "VISITS",
                                  maxLines: 2,
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppFonts.headerwithletterStyle(
                                    fontSize: ResponsiveFlutter.of(
                                      context,
                                    ).fontSize(2),
                                    color: customcolor.black,
                                    fontWeight: FontWeight.w100,
                                  ),
                                ),
                                RichText(
                                  textAlign: TextAlign.justify,
                                  text: TextSpan(
                                    children: [
                                      role ==
                                                  GlobalLists
                                                      .operationmanagerrole ||
                                              role == GlobalLists.operationrole
                                          ? TextSpan(
                                              text:
                                                  'Number of site visits\n done this month',
                                              style: AppFonts.headerStyle(
                                                fontSize: 10,
                                                color: customcolor.subtitle,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            )
                                          : TextSpan(
                                              text:
                                                  'Number of site visits\n this month',
                                              style: AppFonts.headerStyle(
                                                fontSize: 10,
                                                color: customcolor.subtitle,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          isFirstLoad
                              ? Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    // Static grey circle (background)
                                    CircularPercentIndicator(
                                      lineWidth: 4.0,
                                      radius:
                                          28.0, // slightly smaller for better alignment
                                      percent: 1.0,
                                      backgroundColor: Colors.transparent,
                                      progressColor: Colors.grey.shade300,
                                      circularStrokeCap:
                                          CircularStrokeCap.round,
                                      center: Text(
                                        "--", // stays static during loading
                                        style: AppFonts.headerStyle(
                                          fontSize: 14,
                                          color: customcolor.appbarcolor,
                                          fontWeight: FontWeight.w100,
                                        ),
                                      ),
                                    ),

                                    // Blue rotating loader (slightly smaller so it doesn’t overlap)
                                    SizedBox(
                                      height:
                                          52, // slightly smaller than before (was 60)
                                      width: 52,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 4.0,
                                        valueColor: AlwaysStoppedAnimation(
                                          customcolor.textblue,
                                        ),
                                        backgroundColor: Colors.transparent,
                                      ),
                                    ),
                                  ],
                                )
                              : CircularPercentIndicator(
                                  animationDuration: 500,
                                  radius:
                                      28.0, // match loading radius for seamless visual transition
                                  lineWidth: 4.0,
                                  animation: true,
                                  percent: role == GlobalLists.clientrole
                                      ? (GlobalLists.unitdashboard.visitCount ??
                                                    0) >
                                                0
                                            ? 1.0
                                            : 0.0
                                      : ((GlobalLists
                                                        .unitdashboard
                                                        .visitCount ??
                                                    0) /
                                                (GlobalLists
                                                            .unitdashboard
                                                            .totalSiteCount ==
                                                        0
                                                    ? 1 // avoid divide-by-zero
                                                    : GlobalLists
                                                          .unitdashboard
                                                          .totalSiteCount))
                                            .clamp(0.0, 1.0),
                                  center: Text(
                                    role == GlobalLists.clientrole
                                        ? '${GlobalLists.unitdashboard.visitCount}'
                                        : "${GlobalLists.unitdashboard.visitCount ?? 0}/${GlobalLists.unitdashboard.totalSiteCount}",
                                    style: AppFonts.headerStyle(
                                      fontSize: 14,
                                      color: customcolor.appbarcolor,
                                      fontWeight: FontWeight.w100,
                                    ),
                                  ),
                                  circularStrokeCap: CircularStrokeCap.round,
                                  progressColor: customcolor.textblue,
                                  backgroundColor: Colors.grey.shade300,
                                ),

                          //  ishomedataadvisible?
                          //                                                       isFirstLoad
                          // ?
                          // Stack(
                          //     alignment: Alignment.center,
                          //     children: [
                          //       // Grey background circle (same size as percent indicator)
                          //       CircularPercentIndicator(
                          //         lineWidth: 5.0,
                          //         radius: 30.0,
                          //         percent: 1.0, // full circle
                          //         backgroundColor: Colors.transparent,
                          //         progressColor: Colors.grey.shade300, // grey arc
                          //         center: Text(
                          //           "--",
                          //           //  role == GlobalLists.clientrole
                          //           //                       ? '${GlobalLists.unitdashboard.visitCount}'
                          //           //                       : "${GlobalLists.unitdashboard.visitCount ?? 0}/${GlobalLists.unitdashboard.totalSiteCount}",
                          //           style: AppFonts.headerStyle(
                          //             fontSize: 14,
                          //             color: customcolor.appbarcolor,
                          //             fontWeight: FontWeight.w100,
                          //           ),
                          //         ),
                          //         circularStrokeCap: CircularStrokeCap.round,
                          //       ),

                          //       // Blue rotating loader over grey circle
                          //       SizedBox(
                          //         height: 60,
                          //         width: 60,
                          //         child: CircularProgressIndicator(
                          //           strokeWidth: 5,
                          //           valueColor: AlwaysStoppedAnimation(customcolor.textblue),
                          //           backgroundColor: Colors.transparent, // keep transparent
                          //         ),
                          //       ),
                          //     ],
                          //   )
                          //   :

                          //                         CircularPercentIndicator(
                          //                           animationDuration: 500,
                          //                           radius: 30.0,
                          //                           lineWidth: 5.0,
                          //                           animation: true,
                          //                           percent: role == GlobalLists.clientrole
                          //                               ? (GlobalLists.unitdashboard.visitCount ??
                          //                                           0) >
                          //                                       0
                          //                                   ? 1.0
                          //                                   : 0.0
                          //                               : ((GlobalLists.unitdashboard.visitCount ??
                          //                                           0) /
                          //                                       GlobalLists
                          //                                           .unitdashboard.totalSiteCount)
                          //                                   .clamp(0.0, 1.0),
                          //                           center: Text(
                          //                             role == GlobalLists.clientrole
                          //                                 ? '${GlobalLists.unitdashboard.visitCount}'
                          //                                 : "${GlobalLists.unitdashboard.visitCount ?? 0}/${GlobalLists.unitdashboard.totalSiteCount}",
                          //                             style: AppFonts.headerStyle(
                          //                               fontSize: 14,
                          //                               color: customcolor.appbarcolor,
                          //                               fontWeight: FontWeight.w100,
                          //                             ),
                          //                           ),
                          //                           circularStrokeCap: CircularStrokeCap.round,
                          //                           progressColor: customcolor.textblue,
                          //                         )
                          // :
                          // Row(
                          //             children: [
                          //               SizedBox(width: 10,),
                          //               SizedBox(
                          //                   height: 40,
                          //                   width: 40,
                          //                   child: CircularProgressIndicator(
                          //                     strokeWidth: 3,
                          //                     color: customcolor.textblue,
                          //                   ),
                          //                 ),
                          //             ],
                          //           ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : SizedBox(),

        SizedBox(height: 15),

        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) =>
                    Complaint(false, "", "", "", "", "", "", "", false),
              ),
            );
          },
          child: Material(
            elevation: 0,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: SizeConfig.blockSizeHorizontal * 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Image.asset(
                                'assets/images/complaintblue.png',
                                width: 30,
                                height: 30,
                              ),
                            ),
                            SizedBox(width: 5),
                            Container(
                              child: Text(
                                "COMPLAINTS",
                                maxLines: 2,
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                style: AppFonts.headerwithletterStyle(
                                  fontSize: ResponsiveFlutter.of(
                                    context,
                                  ).fontSize(2.3),
                                  color: customcolor.title,
                                  fontWeight: FontWeight.normal,
                                  letterSpacing: 0.5,
                                ),
                                //                                                               AppFonts.headerStyle(fontSize:ResponsiveFlutter.of(context).fontSize(2.2),
                                // color: customcolor.black,fontWeight: FontWeight.normal  ),
                              ),
                            ),
                          ],
                        ),

                        ishomedataadvisible
                            ? Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                  children: [
                                    Text(
                                      "${GlobalLists.unitdashboard.pendingCompliantCount.toString()}",
                                      maxLines: 2,
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppFonts.headerStyle(
                                        fontSize: ResponsiveFlutter.of(
                                          context,
                                        ).fontSize(2.8),
                                        color: customcolor.appbarcolor,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                    Text(
                                      " Active",
                                      maxLines: 2,
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppFonts.headerStyle(
                                        fontSize: ResponsiveFlutter.of(
                                          context,
                                        ).fontSize(2),
                                        color: customcolor.black,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Row(
                                children: [
                                  SizedBox(
                                    height: 40,
                                    width: 40,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 3,
                                      color: customcolor.textblue,
                                    ),
                                  ),
                                  SizedBox(width: 25),
                                ],
                              ),
                        //  SizedBox(width: 2,)
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        SizedBox(height: 50),
      ],
    );
  }

  Widget clientmodule() {
    return ListView(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      children: [
        Container(
          height: SizeConfig.blockSizeVertical * 100,
          decoration: BoxDecoration(
            //color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: customcolor.greyborder, width: 0.4),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 30,
                child: ButtonsTabBar(
                  unselectedLabelStyle: AppFonts.headerStyle(
                    fontSize: 16,
                    color: customcolor.gradientgrey,
                    fontWeight: FontWeight.normal,
                  ),

                  height: 150,

                  onTap: (val) {
                    setState(() {
                      print("ontap");
                      print(val.toString());
                      selectedindex = val;
                    });
                  },

                  //   indicator:
                  // //  _tabControllermain.index==selectedindex?
                  decoration: BoxDecoration(
                    color: customcolor.blue,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  unselectedDecoration: BoxDecoration(
                    color: customcolor.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  // : BoxDecoration(
                  //   color: customcolor.darkorange,

                  //   borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight:Radius.circular(10) )
                  // ),
                  tabs: tabsmain,
                  // [
                  //   Tab(
                  //     text: "Basement",
                  //   ),
                  //   Tab(
                  //     text: "First Floor",
                  //   ),
                  //   Tab(
                  //     text: "Fourth Floor",
                  //   ),
                  // ],
                  controller: _tabControllermain,
                ),
              ),
              //  StatefulBuilder(builder: (thisLowerContext, innerSetState) {
              Expanded(
                flex: 3,
                child: TabBarView(
                  physics: ScrollPhysics(),
                  controller: _tabControllermain,
                  children: List.generate(tabsmain.length, (tabindexmain)
                  //expandedheader(tabindex),
                  {
                    return ListView(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      children: [
                        SizedBox(height: 20),
                        Container(child: Text("Comming")),
                      ],
                    );
                  }),
                ),
              ),
              //  }
              //   ),
            ],
          ),
        ),
      ],
    );
  }

  Widget supervisormodule() {
    return CustomRefreshIndicator(
      key: refreshIndicatorKey,
      builder:
          (BuildContext context, Widget child, IndicatorController controller) {
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
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: headlist.length,
            itemBuilder: (context, index) {
              return ListView(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                children: [
                  GestureDetector(
                    onTap: () {
                      if (headlist[index].type == "RATING") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => rating.Rating(
                              role == GlobalLists.clientrole
                                  ? GlobalLists.clienname
                                  : "",
                            ),
                          ),
                        );
                      } else if (headlist[index].type == "TRAINING") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => Training(
                              role == GlobalLists.clientrole
                                  ? GlobalLists.clienname
                                  : "",
                            ),
                          ),
                        );
                      } else if (headlist[index].type == "WORKFLOW") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                WorkflowstatusOperation(
                                  GlobalLists.shiftid,
                                  false,
                                  "",
                                  "",
                                  role == GlobalLists.clientrole
                                      ? GlobalLists.clienname
                                      : "",
                                  "",
                                ),

                            // Workflowstatus(GlobalLists.shiftid)
                          ),
                        );
                      } else if (headlist[index].type == "ATTENDANCE") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => Attendance(
                              role == GlobalLists.clientrole
                                  ? GlobalLists.clienname
                                  : "OverAll",
                            ),
                            // AllCategory()
                          ),
                        );
                      } else if (headlist[index].type == "PRIORITY TASKS") {
                        if (role == GlobalLists.supervisorrole) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  PrioritySupervisor(GlobalLists.shiftid),
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  PendingWorkflowstatus(
                                    "Priority Tasks",
                                    GlobalLists.shiftid,
                                    GlobalLists.priorityworkflowstatuslist,
                                  ),
                            ),
                          );
                        }
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Material(
                        elevation: 2,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          width: SizeConfig.blockSizeHorizontal * 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: SizeConfig.blockSizeHorizontal * 25,
                                //27.8
                                //  height: SizeConfig.blockSizeVertical*20,
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Image.asset(headlist[index].image),
                                ),
                              ),
                              SizedBox(
                                width: SizeConfig.blockSizeHorizontal * 1,
                              ),
                              Container(
                                width: SizeConfig.blockSizeHorizontal * 43,
                                //  height: SizeConfig.blockSizeVertical*12,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      headlist[index].type,
                                      maxLines: 2,
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppFonts.headerStyle(
                                        fontSize: ResponsiveFlutter.of(
                                          context,
                                        ).fontSize(2),
                                        color: customcolor.black,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    //  SizedBox(height: 1,),
                                    RichText(
                                      textAlign: TextAlign.justify,
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: headlist[index].value,
                                            style: AppFonts.headerStyle(
                                              fontSize: 12,
                                              color: customcolor.red,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          TextSpan(
                                            text: headlist[index].valuename,
                                            style: AppFonts.headerStyle(
                                              fontSize: 12,
                                              color: customcolor.subtitle,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                //  color: customcolor.appbarcolor,
                                child: isFirstLoad
                                    ? Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          // Static grey circle (background)
                                          CircularPercentIndicator(
                                            lineWidth: 4.0,
                                            radius:
                                                28.0, // slightly smaller for better alignment
                                            percent: 1.0,
                                            backgroundColor: Colors.transparent,
                                            progressColor: Colors.grey.shade300,
                                            circularStrokeCap:
                                                CircularStrokeCap.round,
                                            center: Text(
                                              "--", // stays static during loading
                                              style: AppFonts.headerStyle(
                                                fontSize: 14,
                                                color: customcolor.appbarcolor,
                                                fontWeight: FontWeight.w100,
                                              ),
                                            ),
                                          ),

                                          // Blue rotating loader (slightly smaller so it doesn’t overlap)
                                          SizedBox(
                                            height:
                                                52, // slightly smaller than before (was 60)
                                            width: 52,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 4.0,
                                              valueColor:
                                                  AlwaysStoppedAnimation(
                                                    customcolor.textblue,
                                                  ),
                                              backgroundColor:
                                                  Colors.transparent,
                                            ),
                                          ),
                                        ],
                                      )
                                    : CircularPercentIndicator(
                                        animationDuration: 500,
                                        //   radius: 35.0,
                                        lineWidth: 5.0,
                                        radius: 34.0,
                                        //   lineWidth: 5.0,
                                        animation: true,
                                        percent:
                                            headlist[index].percentage.contains(
                                              "NaN %",
                                            )||notapplicable==0
                                            ? 0
                                            : headlist[index].percvalue,
                                        center:
                                           notapplicable ==
                                                0
                                            ? Text(
                                                "NA",
                                                style: AppFonts.headerStyle(
                                                  fontSize: 18,
                                                  color: customcolor
                                                      .textorangecolor,
                                                  fontWeight: FontWeight.w100,
                                                ),
                                              )
                                            : Text(
                                                headlist[index].percentage
                                                        .contains("NaN %")
                                                    ? "0 %"
                                                    : headlist[index]
                                                          .percentage,
                                                style: AppFonts.headerStyle(
                                                  fontSize: 18,
                                                  color: customcolor
                                                      .textorangecolor,
                                                  fontWeight: FontWeight.w100,
                                                ),
                                              ),

                                        circularStrokeCap:
                                            CircularStrokeCap.round,
                                        progressColor: customcolor.textblue,
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          SizedBox(height: 15),
          GlobalLists.unresolvedcomplaint.toString() == ""
              ? Container()
              : GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            Complaint(false, "", "", "", "", "", "", "", false),
                      ),
                    );
                  },
                  child: Material(
                    elevation: 0,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: SizeConfig.blockSizeHorizontal * 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // SizedBox(height: 5,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Image.asset(
                                        'assets/images/complaintblue.png',
                                        width: 30,
                                        height: 30,
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Container(
                                      child: Text(
                                        "COMPLAINTS",
                                        maxLines: 2,
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.ellipsis,
                                        style:
                                            //                                                               AppFonts.headerStyle(fontSize:ResponsiveFlutter.of(context).fontSize(2.2),
                                            // color: customcolor.black,fontWeight: FontWeight.normal  ),
                                            //                                  GoogleFonts.gfsDidot(
                                            //  letterSpacing: 0.5,
                                            //    fontSize: ResponsiveFlutter.of(context).fontSize(2.3),
                                            //         color: customcolor.title ,
                                            //         fontWeight: FontWeight.bold,
                                            // ),
                                            AppFonts.headerwithletterStyle(
                                              fontSize: ResponsiveFlutter.of(
                                                context,
                                              ).fontSize(2.3),
                                              color: customcolor.title,
                                              fontWeight: FontWeight.normal,
                                              letterSpacing: 0.5,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        "${GlobalLists.unresolvedcomplaint.toString()}",
                                        maxLines: 2,
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppFonts.headerStyle(
                                          fontSize: ResponsiveFlutter.of(
                                            context,
                                          ).fontSize(2.8),
                                          color: customcolor.appbarcolor,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                      Text(
                                        " Active",
                                        maxLines: 2,
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppFonts.headerStyle(
                                          fontSize: ResponsiveFlutter.of(
                                            context,
                                          ).fontSize(2),
                                          color: customcolor.black,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
          //scence 1
          SizedBox(height: 30),
        ],
      ),
    );
  }

  //dashboard api

  Future<void> dashboardApi() async {
    log(  "dashboardApi called");
    final prefs = await SharedPreferences.getInstance();
    const cacheKey = 'dashboard_cache';

    var isConnected = await ConnectionDetector.checkInternetConnection();
    var map = <String, dynamic>{};
    var supervisorid = await SPManager().getsupervisorid();
    map['supervisor'] = supervisorid;

    // --- Step 1: Try cached data first ---
    final cachedData = prefs.getString(cacheKey);
    if (cachedData != null) {
      try {
        DashboardlistResponse cachedResp = dashboardlistResponseFromJson(
          cachedData,
        );

        setState(() {
          print("RUCHI @@@");
          updateDashboardState(cachedResp);
          isFirstLoad = false; // data already shown, no need for placeholders
        });
      } catch (e) {
        debugPrint("Error parsing cached dashboard: $e");
        // fallthrough to placeholder
      }
    }

    // --- Step 2: If no cached data, show placeholders immediately ---
    if (headlist.isEmpty) {
      setState(() {
        headlist = [
          Dashboard(
            "assets/images/image4.png",
            "ATTENDANCE",
            "",
            "Manpower present in the \ncurrent shift",
            "NA",
            "",
            "",
            0.0,
          ),
          Dashboard(
            "assets/images/image3.png",
            "WORKFLOW",
            "",
            "Percentage of workflow \ncompleted",
            "NA",
            "",
            "",
            0.0,
          ),
        ];
        // We'll show loaders for percentage values in UI
        isFirstLoad = true;
      });
    }

    // --- Step 3: Fetch API (don’t clear existing headlist) ---
    if (isConnected) {
      APIManager().apiRequest(
        context,
        API.ongoingshift,
        (response) async {
          try {
            DashboardlistResponse resp = response;

            if (resp.status == 1) {
              // Cache response for offline mode
              await prefs.setString(
                cacheKey,
                dashboardlistResponseToJson(resp),
              );
              print("RUCHI @@@ api 1");
              setState(() {
                updateDashboardState(resp);
              });

               log('notapplicable checking ${resp.notapplicable}');
              isFirstLoad = false; // stop showing loaders
              //17dec

              await SPManager().setShiftID(resp.data!.id.toString());
            } else {
              print("DASHBOARD ${resp.status}");
              //16dec2025
              // updateDashboardState(resp);

              print("RUCHITA GlobalLists.isActive");
              log('check isActive ${resp.data?.isActive}');


              log('notapplicable checking.. ${resp.notapplicable}');
              setState(() {
                notapplicable = resp.notapplicable;
              });

              GlobalLists.clientid = resp.clientid.toString();
              GlobalLists.siteid = resp.siteid.toString();
              var shiftID = await SPManager().getShiftID();
              GlobalLists.shiftid = shiftID!;
              setState(() {
                updateDashboardStatewhenNzero(resp);
              });

              isFirstLoad = false;

              ShowDialogs.showToast(resp.msg.toString());
              // keep placeholders or cached data
            }
          } catch (e) {
            setState(() {
              isFirstLoad = false;
            });
            debugPrint("Error processing dashboard response: $e");
          }
        },
        (error) {
          setState(() {
            isFirstLoad = false;
          });
          debugPrint('ERR msg is $error');
        },
        false,
        "",
        jsonval: map,
      );
    } else {
      // --- Step 4: Offline fallback ---
      if (cachedData != null) {
        ShowDialogs.showToast("Offline data loaded");
      } else {
        ShowDialogs.showToast("No internet and no cached data found");
      }
    }
  }

  //   dashboardApi() async {
  //     var status1 = await ConnectionDetector.checkInternetConnection();

  //     if (status1) {
  //       setState(() {
  //         GlobalLists.isclientdata = false;
  //         GlobalLists.attendance_delete_permission = false;
  //         GlobalLists.clientname = "";
  //         GlobalLists.shifttime = '';
  //         GlobalLists.sitename = "";
  //         GlobalLists.pendingcount = "";
  //         GlobalLists.pendingtotalcount = "";
  //         GlobalLists.prioritycount = "";
  //         GlobalLists.unresolvedcomplaint = "";
  //         GlobalLists.prioritytotalcount = "";
  //         GlobalLists.pendingworkflowstatuslist = [];
  //         GlobalLists.priorityworkflowstatuslist = [];
  //         GlobalLists.attendanceper = 0.0;
  //         GlobalLists.workflowper = 0.0;
  //         headlist = [];
  //       });

  //       // ShowDialogs.showLoadingDialog(context, _keyLoader);

  //       var map = <String, dynamic>{};
  //       var supervisorid = await SPManager().getsupervisorid();
  //       map['supervisor'] = supervisorid;

  //       APIManager().apiRequest(context, API.ongoingshift, (response) async {
  //         DashboardlistResponse resp = response;
  //         print('DashboardlistResponse${GlobalLists.multiday}');

  //         if (resp.status == 1) {
  //           log('resp.status ${resp.data.multidays}');
  //           GlobalLists.multiday = resp.data.multidays;
  //           // Cache JSON string for offline use
  //           final prefs = await SharedPreferences.getInstance();
  //           await prefs.setString(
  //               'dashboardApi', dashboardlistResponseToJson(resp));

  //           setState(() {
  //             updateDashboardState(resp);
  //           });

  //           log('GlobalLists.multidaysss ${GlobalLists.multiday}');
  //           // Navigator.of(this.context).pop();
  //         } else {
  //           setState(() {
  //             GlobalLists.clientid = resp.clientid.toString();
  //             GlobalLists.siteid = resp.siteid.toString();
  //             GlobalLists.unresolvedcomplaint =
  //                 resp.penddingcomplaintcount.toString();
  //           });

  //           headlist.add(
  //             Dashboard(
  //               "assets/images/image4.png", // Attendance icon
  //               "ATTENDANCE",
  //               "",
  //               "Manpower present in the \ncurrent shift",
  //               "NA",
  //               "",
  //               "",
  //               0.0,
  //             ),
  //           );

  //           headlist.add(
  //             Dashboard(
  //               "assets/images/image3.png", // Workflow icon
  //               "WORKFLOW",
  //               "",
  //               "Percentage of workflow \ncompleted",
  //               "NA",
  //               "",
  //               "",
  //               0.0,
  //             ),
  //           );

  //           ShowDialogs.showToast(resp.msg);
  //           // Navigator.of(this.context).pop();
  //         }
  //       }, (error) {
  //         print('ERR msg is $error');
  //         // Navigator.of(this.context).pop();
  //       }, false, "", jsonval: map);
  //     } else {
  //       // Handle offline mode using SharedPreferences
  //       final prefs = await SharedPreferences.getInstance();
  //       String? cachedData = prefs.getString('dashboardApi');
  //   print("cachedData");
  // print(cachedData);
  //       if (cachedData != null) {
  //         DashboardlistResponse cachedResp =
  //             dashboardlistResponseFromJson(cachedData);
  //             print("cachedResp");
  // print(cachedResp);
  //         setState(() {
  //           updateDashboardState(cachedResp);
  //         });

  //         ShowDialogs.showToast("Offline data loaded");
  //       } else {
  //         ShowDialogs.showToast("No internet and no offline data available");
  //       }
  //     }
  //   }
   int notapplicable = 0;

  void updateDashboardState(DashboardlistResponse resp) {
    print("RUCHI @2");
    GlobalLists.isclientdata = true;
    GlobalLists.clientname = resp.data?.clientName??"";
    GlobalLists.shifttime = '${resp.data?.startTime} -${resp.data?.endTime}';
    GlobalLists.sitename = resp.data?.siteName??'';
    GlobalLists.nooftotalstaff = resp.data?.noOfStaff?.toString() ?? "0";
    GlobalLists.noofstaff = resp.data?.count?.toString() ?? "0";
    GlobalLists.attendanceper = resp.data?.attendancePercentage ?? 0.0;
    GlobalLists.attendancedate = resp.data?.createdAt.toString()??'';
    GlobalLists.totalattendanceper =
        double.parse(GlobalLists.noofstaff) *
        (double.parse(GlobalLists.nooftotalstaff) / 100);
    GlobalLists.clientid = resp.data?.clientId.toString()??'';

    GlobalLists.shiftid = resp.data?.id.toString()??"";

    print(GlobalLists.clientid);
    print(resp.data?.clientId.toString());
    GlobalLists.siteid = resp.data?.siteId.toString()??"";
    // dashboardvlaue = resp.data;
    print("RUCHITA GlobalLists.shiftid");

    print("RUCHI @1");
    GlobalLists.workflowper = double.parse(resp.workflowPercentage.toString());
    GlobalLists.pendingcount = resp.pendingTaskCount.toString();
    GlobalLists.pendingtotalcount = resp.pendingtotalTaskCount.toString();
    GlobalLists.prioritycount = resp.priorityTaskCount.toString();
    GlobalLists.prioritytotalcount = resp.prioritytotalTaskCount.toString();
    GlobalLists.unresolvedcomplaint = resp.penddingcomplaintcount.toString();
    GlobalLists.pendingworkflowstatuslist = resp.pendingTaskDetail;
    GlobalLists.priorityworkflowstatuslist = resp.prioritydetails;
    GlobalLists.attendance_delete_permission = resp.permission;
    print("DELETE PERMISSION");
    print(GlobalLists.attendance_delete_permission);

     notapplicable = resp.notapplicable;
     setState(() {});

    log("RUCHI @ $notapplicable");
    headlist = [
      Dashboard(
        "assets/images/image4.png",
        "ATTENDANCE",
        "",
        "Manpower present in the \ncurrent shift",
        notapplicable == 0
            ? "NA"
            : "${GlobalLists.attendanceper.toStringAsFixed(0)}%",
        "",
        "",
        double.parse(GlobalLists.attendanceper.toString()) / 100,
      ),
      Dashboard(
        "assets/images/image3.png",
        "WORKFLOW",
        "",
        "Percentage of workflow \ncompleted",
        notapplicable == 0
            ? "NA"
            : "${GlobalLists.workflowper.toStringAsFixed(0)}%",
        "",
        "",
        double.parse(resp.workflowPercentage.toString()) / 100,
      ),
    ];

    if (GlobalLists.prioritycount != "0") {
      // Add priority dashboard if needed
    }

    isdashboradvisible = true;
  }

  void updateDashboardStatewhenNzero(DashboardlistResponse resp) {
    print("updateDashboardStatewhenNzero");
    GlobalLists.isclientdata = true;
    GlobalLists.clientname = resp.data?.clientName??"";
    GlobalLists.shifttime = '${resp.data?.startTime??''} -${resp.data?.endTime??""}';
    GlobalLists.sitename = resp.data?.siteName??"";
    GlobalLists.nooftotalstaff = resp.data?.noOfStaff?.toString() ?? "0";
    GlobalLists.noofstaff = resp.data?.count?.toString() ?? "0";
    GlobalLists.attendanceper = resp.data?.attendancePercentage ?? 0.0;
    GlobalLists.attendancedate = resp.data?.createdAt.toString()??'';
    GlobalLists.totalattendanceper =
        double.parse(GlobalLists.noofstaff) *
        (double.parse(GlobalLists.nooftotalstaff) / 100);

    GlobalLists.workflowper = double.parse(resp.workflowPercentage.toString());
    GlobalLists.pendingcount = resp.pendingTaskCount.toString();
    GlobalLists.pendingtotalcount = resp.pendingtotalTaskCount.toString();
    GlobalLists.prioritycount = resp.priorityTaskCount.toString();
    GlobalLists.prioritytotalcount = resp.prioritytotalTaskCount.toString();
    GlobalLists.unresolvedcomplaint = resp.penddingcomplaintcount.toString();
    GlobalLists.pendingworkflowstatuslist = resp.pendingTaskDetail;
    GlobalLists.priorityworkflowstatuslist = resp.prioritydetails;
    GlobalLists.attendance_delete_permission = resp.permission;
    print("DELETE PERMISSION");
    print(GlobalLists.attendance_delete_permission);

    int notapplicable = resp.notapplicable;

    print("RUCHI @ $notapplicable");
    headlist = [
      Dashboard(
        "assets/images/image4.png",
        "ATTENDANCE",
        "",
        "Manpower present in the \ncurrent shift",
        notapplicable == 0
            ? "NA"
            : "${GlobalLists.attendanceper.toStringAsFixed(0)}%",
        "",
        "",
        double.parse(GlobalLists.attendanceper.toString()) / 100,
      ),
      Dashboard(
        "assets/images/image3.png",
        "WORKFLOW",
        "",
        "Percentage of workflow \ncompleted",
        notapplicable == 0
            ? "NA"
            : "${GlobalLists.workflowper.toStringAsFixed(0)}%",
        "",
        "",
        double.parse(resp.workflowPercentage.toString()) / 100,
      ),
    ];

    if (GlobalLists.prioritycount != "0") {
      // Add priority dashboard if needed
    }

    isdashboradvisible = true;
  }

  //unit dashboard

  bool isFirstLoad = true; // class-level

  Future<void> unitdashboardApi() async {
    final prefs = await SharedPreferences.getInstance();
    const cacheKey = 'unit_dashboard_cache';

    var isConnected = await ConnectionDetector.checkInternetConnection();
    var map = <String, dynamic>{};
    var supervisorid = await SPManager().getsupervisorid();
    var clientid = await SPManager().getclientid();

    if (role == GlobalLists.clientrole) {
      map['clientid'] = clientid;
      map['siteid'] = mainlisttab[maintag].siteId.toString();
    } else {
      map['supervisor'] = supervisorid;
    }

    // --- First try cache (always try cache first) ---
    final cachedData = prefs.getString(cacheKey);
    if (cachedData != null) {
      try {
        UnitDashboardResponse cachedResp = UnitDashboardResponse.fromJson(
          jsonDecode(cachedData),
        );
        setState(() {
          GlobalLists.unitdashboard = cachedResp;
          GlobalLists.unitlowattendacelist = cachedResp.lowattendancedata;
          headlist = buildDashboardList(cachedResp);
          ishomedataadvisible = true;
          visitCount = true;
          isFirstLoad = false; // we already have real data from cache
        });
      } catch (e) {
        debugPrint("Error parsing cached dashboard: $e");
        // fallthrough to placeholder below
      }
    }

    // --- If no cached data available, show placeholders and keep isFirstLoad true ---
    if (headlist.isEmpty) {
      setState(() {
        headlist =
            buildDashboardListPlaceholder(); // ensures text/icons visible
        ishomedataadvisible = false; // show per-circle loaders
        // isFirstLoad remains true until API returns
      });
    }

    // --- Make API request (do not clear headlist) ---
    if (isConnected) {
      APIManager().apiRequest(
        context,
        API.unitdashboard,
        (response) async {
          try {
            UnitDashboardResponse resp = response;

            if (resp.status == 1) {
              // Save latest response to cache
              await prefs.setString(cacheKey, jsonEncode(resp.toJson()));

              setState(() {
                GlobalLists.unitdashboard = resp;
                GlobalLists.unitlowattendacelist = resp.lowattendancedata;
                headlist = buildDashboardList(resp);
                ishomedataadvisible = true;
                visitCount = true;
                isFirstLoad = false; // stop showing per-circle loaders
              });
            } else {
              ShowDialogs.showToast(resp.msg);
              // keep existing headlist (cache or placeholder) unchanged
            }
          } catch (e) {
            debugPrint("Error processing dashboard response: $e");
          }
        },
        (error) {
          debugPrint('ERR msg is $error');
          // keep existing headlist (cache or placeholder) unchanged
        },
        false,
        "",
        jsonval: map,
      );
    } else {
      // offline and we already loaded cache/placeholder above
      if (headlist.isEmpty && cachedData == null) {
        ShowDialogs.showToast("No internet and no cached data found");
      } else if (cachedData != null) {
        ShowDialogs.showToast("Offline data loaded");
      }
    }
  }

  List<Dashboard> buildDashboardListPlaceholder() {
    List<Dashboard> list = [];

    bool isClient = role == GlobalLists.clientrole;
    bool isOperation =
        role == GlobalLists.operationrole ||
        role == GlobalLists.operationmanagerrole;
    bool isHead =
        role == GlobalLists.headrole || role == GlobalLists.reginalmanagerrole;

    if (isOperation || isHead || isClient) {
      list.add(
        Dashboard(
          "assets/images/image4.png",
          "ATTENDANCE",
          "",
          "Sites with full attendance",
          "--",
          "",
          "",
          0.0,
        ),
      );
      list.add(
        Dashboard(
          "assets/images/image3.png",
          "WORKFLOW",
          "",
          "Percentage of workflow \ncompleted",
          "--",
          "",
          "",
          0.0,
        ),
      );
      list.add(
        Dashboard(
          "assets/images/image1.png",
          "TRAINING",
          "",
          "Sites with training \ncompleted",
          "--",
          "",
          "",
          0.0,
        ),
      );
      list.add(
        Dashboard(
          "assets/images/image2.png",
          "RATING",
          "",
          "Average Rating given by clients",
          "--",
          "",
          "",
          0.0,
        ),
      );
    }

    return list;
  }

  List<Dashboard> buildDashboardList(UnitDashboardResponse resp) {
    print("RUCHITA");
    List<Dashboard> list = [];

    bool isClient = role == GlobalLists.clientrole;
    bool isOperation =
        role == GlobalLists.operationrole ||
        role == GlobalLists.operationmanagerrole;
    bool isHead =
        role == GlobalLists.headrole || role == GlobalLists.reginalmanagerrole;

    if (isOperation) {
      print("RUCHITA oper");
      // Add operational role dashboards
      list.add(
        Dashboard(
          "assets/images/image4.png",
          "ATTENDANCE",
          "",
          "Sites with full attendance",
          resp.notapplicable == 0
              ? "NA"
              : '${resp.attendancePercentage.toStringAsFixed(0)}%',
          "",
          "",
          double.parse(resp.attendancePercentage.toStringAsFixed(0)) / 100,
        ),
      );

      list.add(
        Dashboard(
          "assets/images/image3.png",
          "WORKFLOW",
          "",
          "Percentage of workflow \ncompleted",
          resp.notapplicable == 0
              ? "NA"
              : '${resp.workflowPercentage.toStringAsFixed(0)}%',
          "",
          "",
          double.parse(resp.workflowPercentage.toString()) / 100,
        ),
      );

      list.add(
        Dashboard(
          "assets/images/image1.png",
          "TRAINING",
          "",
          "Sites with training \ncompleted",
          "${resp.pendingTrainingPercentage.toStringAsFixed(0)}%",
          "",
          "",
          double.parse(resp.pendingTrainingPercentage.toString()) / 100,
        ),
      );

      list.add(
        Dashboard(
          "assets/images/image2.png",
          "RATING",
          "",
          "Average Rating given by clients",
          "${resp.ratingCount.toStringAsFixed(0)}/10",
          "",
          resp.lowRatingCount.toStringAsFixed(0),
          (double.parse(resp.ratingCount.toStringAsFixed(0)) / 10 * 100) / 100,
        ),
      );
    } else if (isHead) {
      print("RUCHITA ishead");
      list.add(
        Dashboard(
          "assets/images/image4.png",
          "ATTENDANCE",
          // "${resp.lowatteandancecount.toStringAsFixed(0)}/${resp.totalSiteCount.toString()} ",
          "",
          "Sites with full attendance",
          // "${resp.attendancePercentage.toStringAsFixed(0)}%",
          "${resp.notapplicable == 0 ? "NA" : '${resp.attendancePercentage.toStringAsFixed(0)}%'}",
          "",
          "",
          double.parse(resp.attendancePercentage.toStringAsFixed(0)) / 100,
        ),
      );

      list.add(
        Dashboard(
          "assets/images/image3.png",
          "WORKFLOW",
          // "${resp.pendingWorkflowSite.toStringAsFixed(0)}/${resp.totalSiteCount.toString()} ",
          "",
          // "Sites with complete \nworkflow",
          "Percentage of workflow \ncompleted",
          // "${resp.workflowPercentage.toStringAsFixed(0)}%",
          "${resp.notapplicable == 0 ? "NA" : '${resp.workflowPercentage.toStringAsFixed(0)}%'}",
          "",
          "",
          double.parse(resp.workflowPercentage.toString()) / 100,
        ),
      );
      list.add(
        Dashboard(
          "assets/images/image1.png",
          "TRAINING",
          // "${resp.pendingTrainingSiteCount.toString()}/${resp.totalSiteCount.toString()} ",
          "",
          "Sites with training \ncompleted",
          "${resp.pendingTrainingPercentage.toStringAsFixed(0)}%",
          // "${resp.notapplicable == 0 ? "NA" : '${resp.pendingTrainingPercentage.toStringAsFixed(0)}%'}",
          "",
          "",
          double.parse(resp.pendingTrainingPercentage.toString()) / 100,
        ),
      );
      list.add(
        Dashboard(
          "assets/images/image2.png",
          "RATING",
          // "${resp.lowRatingCount.toStringAsFixed(0)}",
          "",
          // " Sites with low Rating (< 7)",
          "Average Rating given by clients",
          "${resp.ratingCount.toStringAsFixed(0)}/10",
          "",
          resp.lowRatingCount.toString(),
          (double.parse(resp.ratingCount.toStringAsFixed(0)) / 10 * 100) / 100,
        ),
      );
      //   if(resp.pendingPriorityWorkflowSiteCount.toString()!="0")
      //  {
      //    headlist.add(Dashboard("assets/images/image6.png", "PRIORITY TASKS", "${resp.pendingPriorityWorkflowSiteCount.toStringAsFixed(0)}/${resp.totalPrioritySiteCount.toString()} ", "Sites with pending \npriority task", "${resp.priorityWorkflowPercentage.toStringAsFixed(0)}%", "","",double.parse(resp.priorityWorkflowPercentage.toString())/100)
      //  );
      //  }
      // Copy the head role logic here if needed
      // Same as operation role in your original code
      // return buildDashboardList(resp); // optional: reuse same structure
    } else if (isClient) {
      print("RUCHITA is client");
      list.add(
        Dashboard(
          "assets/images/image4.png",
          "ATTENDANCE",
          "",
          "Manpower present in the \ncurrent shift",
          resp.notapplicable == 0
              ? "NA"
              : '${resp.attendancePercentage.toStringAsFixed(0)}%',
          "",
          "",
          double.parse(resp.attendancePercentage.toStringAsFixed(0)) / 100,
        ),
      );

      list.add(
        Dashboard(
          "assets/images/image3.png",
          "WORKFLOW",
          "",
          "Percentage of workflow \ncompleted",
          resp.notapplicable == 0
              ? "NA"
              : '${resp.workflowPercentage.toStringAsFixed(0)}%',
          "",
          "",
          double.parse(resp.workflowPercentage.toString()) / 100,
        ),
      );

      list.add(
        Dashboard(
          "assets/images/image1.png",
          "TRAINING",
          "",
          "Percentage of trained \njanitors on site",
          "${resp.pendingTrainingPercentage.toStringAsFixed(0)}%",
          "",
          "",
          double.parse(resp.pendingTrainingPercentage.toString()) / 100,
        ),
      );

      list.add(
        Dashboard(
          "assets/images/image2.png",
          "RATING",
          "",
          "Your last rating of \nour services",
          "${resp.ratingCount.toStringAsFixed(0)}/10",
          "",
          resp.lowRatingCount.toString(),
          (double.parse(resp.ratingCount.toStringAsFixed(0)) / 10 * 100) / 100,
        ),
      );
    }

    return list;
  }

  //unit client master
  //clientwisedashboad
  clientdashboardApi() async {
    var status1 = await ConnectionDetector.checkInternetConnection();

    if (status1) {
      // ShowDialogs.showLoadingDialog(context, _keyLoader);

      var map = <String, dynamic>{};

      var supervisorid = await SPManager().getsupervisorid();
      var clientid = await SPManager().getclientid();

      map['clientid'] = clientid;

      APIManager().apiRequest(
        context,
        API.clientsitedependentdashboard,
        (response) async {
          clientdash.ClientsiteDashboardResponse resp = response;

          if (resp.status == 1) {
            setState(() {
              mainlisttab = resp.data;
              GlobalLists.clienname = resp.data[0].clientName;
              unitdashboardApi();
            });

            // Save response offline
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString(
              'clientdashboardApi',
              clientdash.clientsiteDashboardResponseToJson(resp),
            );

            // Navigator.of(this.context).pop();
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
      // Load cached response
      final prefs = await SharedPreferences.getInstance();
      String? cachedData = prefs.getString('clientdashboardApi');

      if (cachedData != null) {
        clientdash.ClientsiteDashboardResponse cachedResp = clientdash
            .clientsiteDashboardResponseFromJson(cachedData);
        setState(() {
          mainlisttab = cachedResp.data;
          GlobalLists.clienname = cachedResp.data[0].clientName;
        });
        unitdashboardApi();
        ShowDialogs.showToast("Offline data loaded");
      } else {
        ShowDialogs.showToast("No internet and no offline data available");
      }
    }
  }

  unitclientmasterApi() async {
    var status1 = await ConnectionDetector.checkInternetConnection();

    setState(() {
      GlobalLists.clientmasterlist = [];
    });

    var prefs = await SharedPreferences.getInstance();
    var map = <String, dynamic>{};
    var supervisorid = await SPManager().getsupervisorid();
    map['emp_id'] = supervisorid;

    if (status1) {
      // Call API
      APIManager().apiRequest(
        context,
        API.unitclientmaster,
        (response) async {
          print("API Call: ${API.unitclientmaster}");
          UnitclientMasterResponse resp = response;
          if (resp.status == 1) {
            // ✅ Save offline
            await prefs.setString('unitclientmaster_offline', jsonEncode(resp));

            setState(() {
              GlobalLists.clientmasterlist = resp.data;
            });
            print(GlobalLists.clientmasterlist[0].clientName);
          } else {
            ShowDialogs.showToast(resp.msg);
          }
        },
        (error) {
          print('Error: $error');
        },
        false,
        "",
        jsonval: map,
      );
    } else {
      // ⛔ Offline: Load from cache
      String? savedData = prefs.getString('unitclientmaster_offline');
      if (savedData != null) {
        try {
          UnitclientMasterResponse resp = UnitclientMasterResponse.fromJson(
            jsonDecode(savedData),
          );
          if (resp.status == 1) {
            setState(() {
              GlobalLists.clientmasterlist = resp.data;
            });
            print("Loaded offline: ${GlobalLists.clientmasterlist.length}");
          }
        } catch (e) {
          print("Offline load error: $e");
        }
      } else {
        ShowDialogs.showToast("No offline data available");
      }
    }
  }

  //site master

  unitsitemasterApi(String clientid) async {
    var status1 = await ConnectionDetector.checkInternetConnection();

    if (status1) {
      var map = new Map<String, dynamic>();
      map['cid'] = clientid;

      APIManager().apiRequest(
        context,
        API.unitsitemaster,
        (response) async {
          sitemaster.UnitsiteMasterResponse resp = response;
          print('called API ${resp}');
          if (resp.status == "success") {
            setState(() {
              GlobalLists.sitemasterlist = resp.data;
            });
            // Navigator.of(this.context).pop();
            //  ShowDialogs.showToast(resp.msg);
          } else {
            ShowDialogs.showToast(resp.msg);
            // Navigator.of(this.context).pop();
          }
        },
        (error) {
          print('ERR msg is $error');
          //  Navigator.of(this.context).pop();
        },
        false,
        "",
        jsonval: map,
      );
    } else {
      ShowDialogs.showToast("Please check internet connection");
    }
  }

  bool addTrainingLoad = false;
  operationaladdtrainingApi() async {
    var status = await ConnectionDetector.checkInternetConnection();
    if (status) {
      // ShowDialogs.showLoadingDialog(context, _keyLoader);
      setState(() {
        addTrainingLoad = true;
      });
      var request = http.MultipartRequest(
        "POST",
        Uri.parse(APIManager.operationaladdtraining),
      );
      String train_agenda = agendaid.join(', ');
      String train_janitor = janitorid.join(', ');
      request.fields['Date_of_Training'] = datecontroller.text;

      request.fields['Training_Agenda'] = train_agenda;
      request.fields['janitors_list'] = train_janitor;
      //       for(int i=0;i<agendaid.length;i++)
      //       {
      //  request.fields['Training_Agenda $i'] =agendaid[i];
      //       }
      //       for(int i=0;i<janitorid.length;i++)
      //       {
      //  request.fields['janitors_list $i'] =janitorid[i];
      //       }

      request.fields['Client_Name'] = attendanceclientid;
      request.fields['Site'] = attendancesiteid;
      // if (result != "") {
      //   request.files.add(await http.MultipartFile.fromPath(
      //       'image', result,
      //       contentType: new MediaType('application', 'x-tar')));
      // }
      if (result != []) {
        for (int i = 0; i < result.length; i++) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'image$i',
              result[i],
              contentType: new MediaType('application', 'x-tar'),
            ),
          );
        }
      }
      var headers = {
        // "AppKey": APIManager.api_key,
        // "Authorization": "Bearer " + token!
      };
      //  ``   request.headers.addAll(headers);
      print(request.files);
      print(request.fields);
      var response = await request.send();

      final respStr = await response.stream.bytesToString();
      var res = json.decode(respStr);
      print("response.statusCode");
      print(response.statusCode);
      print(res);
      setState(() {
        addTrainingLoad = false;
      });
      // Navigator.of(_keyLoader.currentContext!).pop();
      if (response.statusCode == 200) {
        Timer(Duration(seconds: 1), () => Navigator.pop(context));
        ShowDialogs().confirmationdone(
          context,
          "Training Created \nSuccessfully",
        );

        Timer(
          Duration(seconds: 1),
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (BuildContext context) => HomePage()),
          ),
        );
      } else {
        ShowDialogs.showToast(res['msg']);
      }
    } else {
      SnackBar(content: Text('Please check your internet connection!'));
    }
  }

  addaddtendance(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      isScrollControlled: true,
      elevation: 5.0,
      barrierColor: Colors.black.withOpacity(0.7),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(20.0),
          topRight: const Radius.circular(20.0),
        ),
      ),
      context: context,
      builder: (builder) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStateDialgoue) {
            return new Container(
              height: role == GlobalLists.unitrole
                  ? SizeConfig.blockSizeVertical * 47 +
                        MediaQuery.of(context).viewInsets.bottom
                  : SizeConfig.blockSizeVertical * 40 +
                        MediaQuery.of(context).viewInsets.bottom,
              color: Colors.white,
              margin: EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 2),
              padding: EdgeInsets.all(5),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 5),
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
                      SizedBox(height: 20),
                      Text(
                        "Mark Attendance",
                        textAlign: TextAlign.left,
                        style: AppFonts.headerStyle(
                          fontSize: 22,
                          color: customcolor.black,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 15),
                      GestureDetector(
                        onTap: () {
                          setStateDialgoue(() {
                            isexpandedclient = !isexpandedclient;
                          });
                        },
                        child: FormTextField(
                          isEnable: false,
                          textcontroller: clientnamecontroller,
                          placeholderStr: "Client Name",
                          suffixWidget: Padding(
                            padding: EdgeInsets.only(right: 20),
                            child: Image.asset(
                              "assets/images/dropdown.png",
                              width: 10,
                              height: 10,
                            ),
                          ),
                          textInputType: TextInputType.text,
                          onchange: (val) {},
                        ),
                      ),
                      Stack(
                        children: [
                          Column(
                            children: [
                              // clientnamecontroller.text==""?Container():
                              SizedBox(height: 20),
                              role == GlobalLists.unitrole
                                  ? Column(
                                      children: [
                                        //  clientnamecontroller.text==""?Container():   GestureDetector(
                                        //       onTap: ()
                                        //       {
                                        //         setStateDialgoue(() {
                                        //           isexpanded=true;
                                        //         });
                                        //       },
                                        //       child: FormTextField(isEnable: false,
                                        //                                         textcontroller: sitenamecontroller,
                                        //                                         placeholderStr: "Site Name",
                                        //                                       suffixWidget: Padding(
                                        //                                         padding:  EdgeInsets.only(right: 20),
                                        //                                         child: Image.asset(
                                        //                                         "assets/images/dropdown.png",

                                        //                                         width: 10,
                                        //                                         height: 10,
                                        //                                                                       ),
                                        //                                       ),
                                        //                                         textInputType: TextInputType.text,
                                        //                                         onchange: (val) {

                                        //                                         },
                                        //                                       ),
                                        //     ),
                                        // SizedBox(height: 20,),
                                      ],
                                    )
                                  : Container(),
                              // SizedBox(height: 20,),
                              Stack(
                                children: [
                                  Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setStateDialgoue(() {
                                            isexpandedjanitor =
                                                !isexpandedjanitor;

                                            isexpandedclient = false;
                                          });
                                        },
                                        child: FormTextField(
                                          isEnable: false,
                                          textcontroller: namecontroller,
                                          placeholderStr:
                                              "Select Janitor's Name",
                                          textInputType: TextInputType.text,
                                          onchange: (val) {},
                                          suffixWidget: Padding(
                                            padding: EdgeInsets.only(right: 20),
                                            child: Image.asset(
                                              "assets/images/dropdown.png",
                                              width: 10,
                                              height: 10,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Stack(
                                        children: [
                                          Column(
                                            children: [
                                              SizedBox(height: 20),
                                              FormTextField(
                                                isEnable: true,
                                                textcontroller:
                                                    mobilecontroller,
                                                placeholderStr: "Mobile Number",
                                                lengthofmobile: 10,
                                                //   maxLength: 10,
                                                textInputType:
                                                    TextInputType.number,
                                                onchange: (val) {},
                                              ),
                                              SizedBox(height: 30),
                                            ],
                                          ),
                                          isexpandedjanitor
                                              ? janitorsclientDropdown(
                                                  setStateDialgoue,
                                                )
                                              : Container(),
                                        ],
                                      ),
                                    ],
                                  ),
                                  isexpanded
                                      ? siteDropdown(setStateDialgoue)
                                      : Container(),
                                ],
                              ),
                            ],
                          ),
                          isexpandedclient
                              ? clientDropdown(setStateDialgoue)
                              : Container(),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          print("next");
                          if (lat == null || long == null) {
                            print("coming here");
                            grantPermission();
                          } else if (clientnamecontroller.text.isEmpty) {
                            ShowDialogs.showToast("Please Select Client Name");
                          } else if (namecontroller.text.isEmpty) {
                            ShowDialogs.showToast("Please Enter Name");
                          } else if (mobilecontroller.text.isEmpty) {
                            ShowDialogs.showToast("Please Enter Mobile No");
                          } else if (mobilecontroller.text.length != 10) {
                            ShowDialogs.showToast(
                              "Please Enter Valid Mobile No",
                            );
                          } else {
                            print("next");
                            addattendanceApi();
                          }
                        },
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: addAttendance
                              ? CircularProgressIndicator(
                                  color: customcolor.blue,
                                )
                              : Image.asset(
                                  'assets/images/next.png',
                                  width: 50,
                                  height: 50,
                                ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  bool addAttendance = false;
  addattendanceApi() async {
    var status1 = await ConnectionDetector.checkInternetConnection();

    if (status1) {
      // ShowDialogs.showLoadingDialog(context, _keyLoader);
      setState(() {
        addAttendance = true;
      });
      var map = new Map<String, dynamic>();

      map['name'] = namecontroller.text.trim().toString();
      map['contact'] = mobilecontroller.text.trim().toString();
      map['client_id'] = attendanceclientid;
      map['site_id'] = attendancesiteid;
      map['latitude'] = lat;
      map['longitude'] = long;
      map['user_type'] = role == GlobalLists.supervisorrole ? "Supervisor" : "";
      map['shift'] = "";
      print(map);

      APIManager().apiRequest(
        context,
        API.addattendance,
        (response) async {
          addattten.AddAttendanceResponse resp = response;
          print('called API ${resp}');
          if (resp.status == 1) {
            setState(() {
              setState(() {
                addAttendance = false;
              });
              // Navigator.of(this.context).pop();
              Timer(Duration(seconds: 1), () => Navigator.pop(context));
              ShowDialogs().confirmationdone(
                context,
                "Mark Attendance \nSuccessfully",
              );
              Timer(
                Duration(seconds: 1),
                () => Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) =>
                        HomePage(),
                    transitionDuration: Duration(seconds: 0),
                  ),
                ),
              );
              // ShowDialogs.showToast(resp.msg);
            });
          } else {
            ShowDialogs.showToast(resp.msg);
            setState(() {
              addAttendance = false;
            });
            // Navigator.of(this.context).pop();
          }
        },
        (error) {
          print('ERR msg is $error');
        },
        false,
        "",
        jsonval: map,
      );
    } else {
      ShowDialogs.showToast("Please check internet connection");
    }
  }

  trainingagendaApi() async {
    final cacheKey = 'cached_training_agenda';
    var isConnected = await ConnectionDetector.checkInternetConnection();

    setState(() {
      agendalist = [];
    });

    if (isConnected) {
      var map = <String, dynamic>{};

      APIManager().apiRequest(
        context,
        API.mobilelisttrainingmaster,
        (response) async {
          agen.MobilelisttrainingResponse resp = response;

          if (resp.status == 1) {
            setState(() {
              agendalist = resp.data
                  .map((e) => Agendacheckbox(e.name, e.id.toString(), false))
                  .toList();
            });

            // ✅ Save to SharedPreferences
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString(cacheKey, json.encode(resp.toJson()));
          } else {
            ShowDialogs.showToast(resp.msg);
          }
        },
        (error) {
          print('ERR msg is $error');
        },
        false,
        "",
        jsonval: map,
      );
    } else {
      // 🚫 Offline: Load from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      String? cachedData = prefs.getString(cacheKey);

      if (cachedData != null) {
        agen.MobilelisttrainingResponse cachedResp =
            agen.MobilelisttrainingResponse.fromJson(json.decode(cachedData));

        setState(() {
          agendalist = cachedResp.data
              .map((e) => Agendacheckbox(e.name, e.id.toString(), false))
              .toList();
        });

        ShowDialogs.showToast("Offline training agenda loaded");
      } else {
        ShowDialogs.showToast("No internet and no offline data available");
      }
    }
  }

  janotoragendaApi(String idclient, String idsite) async {
    var isConnected = await ConnectionDetector.checkInternetConnection();
    final cacheKey = 'cached_janitor_agenda_${idclient}_$idsite';

    var map = {'client_id': idclient, 'site_id': idsite};

    if (isConnected) {
      APIManager().apiRequest(
        context,
        API.janitorslist,
        (response) async {
          JanitorslistResponse resp = response;

          if (resp.status == 1) {
            setState(() {
              dropdownList = resp.data
                  .map(
                    (e) => Janitorcheckbox(
                      e.janName.toString(),
                      e.id.toString(),
                      false,
                      e.contact,
                    ),
                  )
                  .toList();
            });

            final prefs = await SharedPreferences.getInstance();
            await prefs.setString(cacheKey, json.encode(resp.toJson()));
          } else {
            ShowDialogs.showToast(resp.msg);
          }
        },
        (error) {
          print('ERR msg is $error');
        },
        false,
        "",
        jsonval: map,
      );
    } else {
      final prefs = await SharedPreferences.getInstance();
      String? cachedData = prefs.getString(cacheKey);

      if (cachedData != null) {
        JanitorslistResponse cachedResp = JanitorslistResponse.fromJson(
          json.decode(cachedData),
        );

        setState(() {
          dropdownList = cachedResp.data
              .map(
                (e) => Janitorcheckbox(
                  e.janName.toString(),
                  e.id.toString(),
                  false,
                  e.contact,
                ),
              )
              .toList();
        });

        ShowDialogs.showToast("Offline janitor data loaded");
      } else {
        ShowDialogs.showToast("No internet and no offline data available");
      }
    }
  }

  //janitorclient dropdown
  Widget janitorsclientDropdown(StateSetter setStateDialgoue) {
    return Container(
      height: 105,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Card(
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.only(left: 10, right: 10, top: 10),
          child: ListView.builder(
            itemCount: dropdownList.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      setStateDialgoue(() {
                        namecontroller.text = dropdownList[index].name;

                        isexpandedjanitor = false;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 3, bottom: 2),
                      child: Container(
                        color: Colors.white,
                        width: SizeConfig.blockSizeHorizontal * 100,
                        child: Text(
                          dropdownList[index].name,
                          style: AppFonts.headerStyle(
                            fontSize: 14,
                            color: customcolor.black,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Divider(color: customcolor.greybg),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  grantPermission() async {
    var status = await permishan.Permission.location.status;
    print("status");
    print(status);
    if (status.isGranted) {
      getLocation();
    } else if (status.isPermanentlyDenied) {
      print("isUndetermined");
      //  ShowDialogs.showToast(
      //                       "Please Allow Your Location Permission From Setting  To Add your Attendance");
      getLocation();
      //await Permission.location.request();
    } else {
      // getLocation();
      print("status1");
      permishan.openAppSettings();
      //locatedCountryCode = null;
      //await Permission.location.request();
    }
  }

  Future<void> _getLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled
      return;
    }

    // Request permission to use location
    permission = await Geolocator.checkPermission();
    print("GELOCATOR00");
    print(permission);
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        // Permissions are denied, handle it accordingly.
        // _getLocationPermission();
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle it accordingly.
      //  _getLocationPermission();
      openAppSettings();
      return;
    }

    // Permissions are granted, get location
    getLocation();
  }

  Future<void> requestNotificationPermissions() async {
    // Request notification permissions
    final PermissionStatus status = await Permission.notification.request();

    // Handle permission status
    if (status == PermissionStatus.granted) {
      // Permission granted, initialize notification plugin
      // initializeNotifications();
    } else {
      openAppSettings();
      // Permission denied, handle accordingly
      // You can display a message to the user or take other actions
    }
  }

  Future<Placemark> getLocation() async {
    // Check and request location permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    }

    // Get current position
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    debugPrint(
      'Latitude: ${position.latitude}, Longitude: ${position.longitude}',
    );

    // Get address from coordinates
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    Placemark first = placemarks.first;

    // Store lat/lng as strings if needed
    lat = position.latitude.toString();
    long = position.longitude.toString();

    print(
      "${first.name} : ${first.street}, ${first.locality}, ${first.country}",
    );
    return first;
  }

  Widget janitorsDropdown(StateSetter setStateDialgoue) {
    return Container(
      height: dropdownList.length <= 1
          ? 100
          : dropdownList.length <= 2
          ? 150
          : 170,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Card(
        elevation: 5,
        child: dropdownList.length == 0
            ? Container(
                width: SizeConfig.blockSizeHorizontal * 90,
                child: Center(child: Text("No Record Found")),
              )
            : Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Scrollbar(
                  thumbVisibility: dropdownList.length <= 2 ? false : true,
                  child: ListView(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemCount: dropdownList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              //                       GestureDetector(
                              //                         onTap: () {
                              //                           setStateDialgoue(() {
                              //                             sitenamecontroller.text =
                              //                                 agendalist[index].name;

                              //                             isexpanded = false;
                              //                           });
                              //                         },
                              //                         child: Container(
                              //                           color: Colors.white,
                              //                           width: SizeConfig.blockSizeHorizontal * 100,
                              //                           child: Text(
                              //                             agendalist[index].name,
                              //                             style:
                              //                                                                      AppFonts.headerStyle(fontSize:14,
                              // color: customcolor.black,fontWeight: FontWeight.normal  ),

                              //                           ),
                              //                         ),
                              //                       ),
                              CheckboxListTile(
                                activeColor: customcolor.green,
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                                title: Text(
                                  dropdownList[index].name,
                                  style: AppFonts.headerStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                value: dropdownList[index].isselected,
                                onChanged: (value) {
                                  setStateDialgoue(() {
                                    List<String> agelist = [];
                                    List<String> agendais = [];
                                    dropdownList[index].isselected = value!;
                                    for (
                                      int i = 0;
                                      i < dropdownList.length;
                                      i++
                                    ) {
                                      if (dropdownList[i].isselected) {
                                        agelist.add(
                                          dropdownList[i].name.toString(),
                                        );
                                        agendais.add(
                                          dropdownList[i].id.toString(),
                                        );
                                      }
                                    }
                                    String s = agelist.join(', ');
                                    namecontroller.text = s;
                                    janitorname = agelist.toString();
                                    janitorid = agendais;
                                    // print("multipleSelectedlist");
                                    // print(multipleSelectedlist);
                                    // print(checkboxeslist[indexcheck]);

                                    // if (multipleSelectedlist.contains(checkboxeslist[indexcheck])) {
                                    //   multipleSelectedlist.remove(checkboxeslist[indexcheck]);
                                    // } else {
                                    //   multipleSelectedlist.add(checkboxeslist[indexcheck]);
                                    // }
                                  });
                                },
                              ),

                              // Divider(
                              //   color: customcolor.greybg
                              // )
                            ],
                          );
                        },
                      ),
                      Divider(),
                      dropdownList.length == 0
                          ? Container()
                          : Center(
                              child: GestureDetector(
                                onTap: () {
                                  setStateDialgoue(() {
                                    isexpandedjanitor = false;
                                  });
                                },
                                child: Container(
                                  color: customcolor.white,
                                  width: SizeConfig.blockSizeHorizontal * 100,
                                  child: Center(
                                    child: Text(
                                      "Submit",
                                      style: AppFonts.headerStyle(
                                        fontSize: 12,
                                        color: customcolor.blue,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _getFAB() {
    return SpeedDial(
      childrenButtonSize: Size(66, 66),
      spacing: 10,
      icon: Icons.add,
      activeIcon: Icons.close,
      // animatedIcon: AnimatedIcons.p,
      animatedIconTheme: IconThemeData(size: 22),
      backgroundColor: customcolor.blue,
      visible: true,
      curve: Curves.bounceIn,
      children: [
        // FAB 1
        SpeedDialChild(
          child: Image.asset(
            "assets/images/ratinggrey.png",
            width: 20,
            height: 20,
            color: customcolor.white,
          ),
          backgroundColor: customcolor.blue,
          onTap: () {
            /* do anything */

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => rating.Rating(""),
              ),
            );
          },
          labelWidget: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Container(
              decoration: new BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                color: customcolor.white,
                boxShadow: [
                  new BoxShadow(color: customcolor.greyborder, blurRadius: 1.0),
                ],
              ),
              width: 135,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text(
                    "Rating",
                    style: AppFonts.headerStyle(
                      fontSize: 14,
                      color: customcolor.blue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),

          //                 label: 'Rating',
          //                 labelStyle:
          //                                                          AppFonts.headerStyle(fontSize:14,
          // color: customcolor.blue,fontWeight: FontWeight.w500  ),
          labelBackgroundColor: customcolor.white,
        ),
        // FAB 2
        SpeedDialChild(
          child: Image.asset(
            "assets/images/greyticket.png",
            width: 20,
            height: 20,
            color: customcolor.white,
          ),
          backgroundColor: customcolor.blue,
          onTap: () {
            setState(() {
              _counter = 0;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) =>
                      Complaint(false, "", "", "", "", "", "", "", true),
                ),
              );
            });
          },
          labelWidget: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Container(
              decoration: new BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                color: customcolor.white,
                boxShadow: [
                  new BoxShadow(color: customcolor.greyborder, blurRadius: 1.0),
                ],
              ),
              width: 135,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text(
                    "Lodge Complaints",
                    style: AppFonts.headerStyle(
                      fontSize: 14,
                      color: customcolor.blue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),

          //                 label: 'Lode Complaints',
          //                 labelStyle:
          //                                                          AppFonts.headerStyle(fontSize:14,
          // color: customcolor.blue,fontWeight: FontWeight.w500  ),
          labelBackgroundColor: customcolor.white,
        ),
      ],
    );
  }

  Widget _getoperationalFAB() {
    return SpeedDial(
      childrenButtonSize: Size(66, 66),
      spacing: 10,
      icon: Icons.add,
      activeIcon: Icons.close,
      // animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 56),
      backgroundColor: customcolor.blue,
      visible: true,
      curve: Curves.bounceIn,
      children: [
        // FAB 1
        (role == GlobalLists.operationrole ||
                role == GlobalLists.operationmanagerrole)
            ? SpeedDialChild(
                child: Image.asset(
                  "assets/images/greyticket.png",
                  width: 20,
                  height: 20,
                  color: customcolor.white,
                ),
                backgroundColor: customcolor.blue,
                onTap: () {
                  setState(() {
                    _counter = 0;
                    datecontroller.text = "";
                    janitorname = "";
                    janitorid = [];
                    agendaid = [];
                    agendacontroller.text = "";
                    uploadcontroller.text = "";
                    result = [];
                    clientnamecontroller.text = "";
                    attendanceclientid = "";
                    attendancesiteid = "";
                    namecontroller.text = "";
                    isexpandedjanitor = false;
                    isexpanded = false;
                    isexpandedclient = false;
                    for (int i = 0; i < dropdownList.length; i++) {
                      dropdownList[i].isselected = false;
                    }
                    for (int i = 0; i < agendalist.length; i++) {
                      agendalist[i].isselected = false;
                    }
                    addtraing(context);
                  });
                },
                labelWidget: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Container(
                    decoration: new BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      color: customcolor.white,
                      boxShadow: [
                        new BoxShadow(
                          color: customcolor.greyborder,
                          blurRadius: 1.0,
                        ),
                      ],
                    ),
                    width: 100,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          "Add training",
                          style: AppFonts.headerStyle(
                            fontSize: 14,
                            color: customcolor.blue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                //                 label: 'Add Training',

                //                 labelStyle:

                //                                                          AppFonts.headerStyle(fontSize:14,
                // color: customcolor.blue,fontWeight: FontWeight.w500  ),
                labelBackgroundColor: customcolor.white,
              )
            : SpeedDialChild(),
        // FAB 2
        (role == GlobalLists.operationrole ||
                role == GlobalLists.operationmanagerrole ||
                role == GlobalLists.reginalmanagerrole)
            ? SpeedDialChild()
            : SpeedDialChild(
                child: Image.asset(
                  "assets/images/ratinggrey.png",
                  width: 20,
                  height: 20,
                  color: customcolor.white,
                ),
                backgroundColor: customcolor.blue,
                onTap: () {
                  /* do anything */

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => rating.Rating(""),
                    ),
                  );
                },
                labelWidget: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Container(
                    decoration: new BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      color: customcolor.white,
                      boxShadow: [
                        new BoxShadow(
                          color: customcolor.greyborder,
                          blurRadius: 1.0,
                        ),
                      ],
                    ),
                    width: 100,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          "Add rating",
                          style: AppFonts.headerStyle(
                            fontSize: 14,
                            color: customcolor.blue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                //                 label: 'Add Rating',
                //                 labelStyle:
                //                                                          AppFonts.headerStyle(fontSize:14,
                // color: customcolor.blue,fontWeight: FontWeight.w500  ),
                labelBackgroundColor: customcolor.white,
              ),

        (role == GlobalLists.operationrole ||
                role == GlobalLists.operationmanagerrole)
            ? SpeedDialChild(
                child: Image.asset(
                  "assets/images/calendar.png",
                  width: 20,
                  height: 20,
                  color: customcolor.white,
                ),
                backgroundColor: customcolor.blue,
                onTap: () {
                  /* do anything */

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          // OperationVisitCardPage()
                          OperationVisitPage(role),
                    ),
                  );
                },
                labelWidget: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Container(
                    decoration: new BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      color: customcolor.white,
                      boxShadow: [
                        new BoxShadow(
                          color: customcolor.greyborder,
                          blurRadius: 1.0,
                        ),
                      ],
                    ),
                    width: 100,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          "Operations Visit",
                          style: AppFonts.headerStyle(
                            fontSize: 14,
                            color: customcolor.blue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                //                 label: 'Add Rating',
                //                 labelStyle:
                //                                                          AppFonts.headerStyle(fontSize:14,
                // color: customcolor.blue,fontWeight: FontWeight.w500  ),
                labelBackgroundColor: customcolor.white,
              )
            : SpeedDialChild(),
      ],
    );
  }

  Widget _getheadroleFAB() {
    return SpeedDial(
      childrenButtonSize: Size(66, 66),
      spacing: 10,
      icon: Icons.add,
      activeIcon: Icons.close,
      // animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 56),
      backgroundColor: customcolor.blue,
      visible: true,
      curve: Curves.bounceIn,
      children: [
        // FAB 1
        SpeedDialChild(
          child: Image.asset(
            "assets/images/greyticket.png",
            width: 20,
            height: 20,
            color: customcolor.white,
          ),
          backgroundColor: customcolor.blue,
          onTap: () {
            setState(() {
              _counter = 0;
              datecontroller.text = "";
              janitorname = "";
              janitorid = [];
              agendaid = [];
              agendacontroller.text = "";
              uploadcontroller.text = "";
              result = [];
              clientnamecontroller.text = "";
              attendanceclientid = "";
              attendancesiteid = "";
              namecontroller.text = "";
              isexpandedjanitor = false;
              isexpanded = false;
              isexpandedclient = false;
              for (int i = 0; i < dropdownList.length; i++) {
                dropdownList[i].isselected = false;
              }
              for (int i = 0; i < agendalist.length; i++) {
                agendalist[i].isselected = false;
              }
              addtraing(context);
            });
          },
          labelWidget: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Container(
              decoration: new BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                color: customcolor.white,
                boxShadow: [
                  new BoxShadow(color: customcolor.greyborder, blurRadius: 1.0),
                ],
              ),
              width: 100,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text(
                    "Add training",
                    style: AppFonts.headerStyle(
                      fontSize: 14,
                      color: customcolor.blue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),

          //                 label: 'Add Training',

          //                 labelStyle:

          //                                                          AppFonts.headerStyle(fontSize:14,
          // color: customcolor.blue,fontWeight: FontWeight.w500  ),
          labelBackgroundColor: customcolor.white,
        ),
      ],
    );
  }
}

extension ExtendedIterable<E> on Iterable<E> {
  /// Like Iterable<T>.map but the callback has index as second argument
  Iterable<T> mapIndexed<T>(T Function(E e, int i) f) {
    var i = 0;
    return map((e) => f(e, i++));
  }

  void forEachIndexedmain(void Function(E e, int i) f) {
    var i = 0;
    forEach((e) => f(e, i++));
  }
}
