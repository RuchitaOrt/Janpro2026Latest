import 'package:flutter/material.dart';
import 'package:janpro/model/AttendencelistResponse.dart';
import 'package:janpro/model/ClientwisetrainingResponse.dart' as training;
import 'package:janpro/model/DashboardlistResponse.dart';
import 'package:janpro/model/GetComplaintResponse.dart' as complaint;
import 'package:janpro/model/OperationalRatinggraphwiseResponse.dart';
import 'package:janpro/model/UnitDashboardResponse.dart' as unitdash;
import 'package:janpro/model/UnitclientMasterResponse.dart' as clientmaster;
import 'package:janpro/model/WorkflowlistResponse.dart';
import 'package:janpro/model/WorkfowstatusResponse.dart';
import 'package:janpro/model/unitAttendanceResponse.dart' as unitatt;
import 'package:janpro/model/unitGraphAttendanceResponse.dart' as graph;
import 'package:janpro/model/UnitsiteMasterResponse.dart' as sitemaster;
import 'package:janpro/model/ActivitylistResponse.dart' as actilist;
import 'package:janpro/model/OperationalWorkflowResponse.dart' as operwf;
import 'package:janpro/model/OperationalPrioritylistResponse.dart'
    as operpriority;
import 'package:janpro/model/MobilelisttrainingResponse.dart' as agen;
import 'package:janpro/model/TicketllistResponse.dart' as ticket;
import 'package:janpro/model/OperationalWorkflowResponse.dart' as operwf;
import '../model/CardVisitView.dart' as viewcard;
import '../model/ClientOperationResponse.dart' as visit;

import 'package:janpro/model/MasterareaResponse.dart' as area;
import 'package:janpro/model/MasterBlockResponse.dart' as block;
import 'package:janpro/model/ClientsiteDashboardResponse.dart' as clientsite;
import 'package:janpro/model/NotificationlistResponse.dart' as notify;
import 'package:janpro/model/JanitorDetials.dart' as janodet;
import 'package:janpro/model/WorkflowoperationalDetailmodel.dart'
    as newoperdetail;
import 'package:janpro/model/TrendGraphResponse.dart' as trend;
import 'package:janpro/model/WorkfowstatusResponse.dart' as check;
import '../Screens/Training.dart';
import '../model/ClientOperationResponse.dart' as visitGraph;
import '../model/OperationVisitView.dart' as visitview;
import '../model/SiteDropDown.dart' as sitedrop;
import 'package:janpro/model/unitAttendanceResponse.dart' as unitatt;
import '../model/AttendencelistResponse.dart' as att;
import 'package:janpro/model/Workflowoperationalmodel.dart' as newopera;
import '../model/WorkflowoperationalDetailmodel.dart' as worke;

class GlobalLists {
//background check
static  ValueNotifier<bool> isAddcomplaintLoader = ValueNotifier(false);
static  ValueNotifier<bool> isaddAttendance = ValueNotifier(false);
static ValueNotifier<bool> isWorflowLoading = ValueNotifier<bool>(false);
static ValueNotifier<bool> iscomplaintLoadin = ValueNotifier<bool>(false);
static ValueNotifier<bool> isAddEditJanitor = ValueNotifier<bool>(false);
static ValueNotifier<bool> isActiveLoader = ValueNotifier<bool>(false);
static  int isShiftActive = 1;

static String downloadRosterLink="";
  static List<unitatt.Datum> mainlisttab = [];
  static List<Janitorcheckbox> dropdownList = [];
  static late att.Data attendancedata;
  static TextEditingController datecontroller = new TextEditingController();

  static bool isclientdata = false;
  static String clientname = "";
  static String sitename = "";
  static String shifttime = "";
  static String shiftendtime = "";
  static String nooftotalstaff = "";
  static String noofstaff = "";
  static String attendancedate = "";
  static String clientid = "";
  static String siteid = "";
  static String shiftid = "";
  static String empId = "";
  static List<newopera.Datum> operationalmainlisttab = [];
  static int maintag = 0;
  static int selectedindex = 0;
  static List<newoperdetail.Datum> detailopeermainlisttab = [];
  static late List<Tab> tabsmain = <Tab>[];
  static Map<String, List<worke.Datum>> clientDetailsMap = {};
  static String card_startcurrentdatevalue = "";
  static String card_endcurrentdatevalue = "";
  static String card_superviorfirtvalue = "";
  static String card_percentvalue = "";
  static List<operwf.Datum> mainlisttabs = [];
  static String total_supervisorercentage = "0";
  static dynamic shiftavaialble = "0";
  static dynamic multidays = true;
  static dynamic start_time = "";
  static dynamic end_time = "";
  static int notapplicable = 0;
  static int maintagvist = 0;
  static int maxVisitCount = 0;

  static int tagvist = 0;
 static List<visit.Datum> mainlisttabvisit = [];


  
  // int maintag = 0;

  static bool isloadedAttendance = false;
  static bool isloadedWokeflow = false;

  static late TabController tabControllermain;
  static double attendanceper = 0.0;

  static double workflowper = 0.0;

  static String pendingcount = "";
  static String prioritycount = "";
  static String pendingtotalcount = "";
  static String prioritytotalcount = "";
  static String unresolvedcomplaint = "";

  static bool attendance_delete_permission = false;

  static double totalattendanceper = 0.0;

  static List<IngShift> todayworkflow = [];
  static List<IngShift> upcomingworkflow = [];
  static List<EmployeeList> attendanceemployeelist = [];
  static List<Datum> workflowstatuslist = [];
  static List<Detail> pendingworkflowstatuslist = [];
  static List<Detail> priorityworkflowstatuslist = [];
  static List<check.Checklist> checkboxeslist = [];
  static List<check.Checklist> multipleSelectedlist = [];

  static List<complaint.DependentdatumElement> resolvedlist = [];
  static List<complaint.DependentdatumElement> pendingcomlist = [];
  static List<complaint.DependentdatumElement> dependentcomlist = [];

  //pendingcomplaint
  static List<Penddingcomplaint> pendingcomplaintlist = [];

//Login
  //  static String unitrole = "2";
  //  static String headrole = "3";
  //  static String clientrole = "4";
  //     static String operationrole = "5";
  static String supervisorrole = "1";
  static String unitrole = "2";
  static String operationmanagerrole = "3"; //same //operational Executive
  static String operationrole = "4"; //same // operational manager
  static String headrole = "5";
  static String reginalmanagerrole = "6";
  static String clientrole = "7";
  static String role = "";

//       "emp_type": 1,  Supervisor
// "emp_type": 2,   Unit Executive
//  "emp_type": 3,  Operation Manager
//  "emp_type": 4,  Operation Executive
//  "emp_type": 5,  HOO Head Of Operations
//  "emp_type": 6,  Region Manager

  //unit module
  static List<unitdash.Lowattendancedatum> unitlowattendacelist = [];

  static unitdash.UnitDashboardResponse unitdashboard =
      unitdash.UnitDashboardResponse(
          pendingTrainingPercentage: 0,
          pendingTrainingSiteCount: 0,
          notapplicable: 0,
          clientdata: [],
          lowRatingCount: 0,
          pendingWorkflowSite: 0,
          totalPrioritySiteCount: 0,
          pendingPriorityWorkflowSiteCount: 0,
          status: 0,
          msg: "",
          workflowCheckCount: 0,
          workflowTotalCount: 0,
          workflowPercentage: 0,
          priorityWorkflowPercentage: [],
          attendancePercentage: 0,
          pendingCompliantCount: 0,
          ratingCount: 0,
          lowattendancedata: [],
          lowatteandancecount: 0,
          totalSiteCount: 0,
          visitCount: 0);
  static List<unitatt.Datum> employeeattendacelist = [];

  static List<clientmaster.Datum> clientmasterlist = [];

  static List<sitemaster.Datum> sitemasterlist = [];
  // static List<unitatt.GraphDatum> graphlist = [];
  static List<graph.GraphDatum> graphlist = [];

  static List<trend.GraphDatum> trendgraphlist = [];

  //operational
  static List<actilist.Datum> activitylist = [];
  static List<operwf.Datum> operationalworkflowstatuslist = [];

  static List<GraphDatumElement> ratinggraphlist = [];
  static List<DatumElement> ratinglistwisegraphlist = [];

  static int ratingclienttag = 0;
  static List<operpriority.Detail> operationalpriorityworkflowlist = [];

  //training
  static List<training.GraphDatum> traininggraphlist = [];
  static List<visitGraph.Datum> visitgraphlist = [];
  static List<visitGraph.GraphDatum> visitGraphlist = [];


  static int traningclienttag = 0;

  // static List<agen.Datum> agendalist = [];

  //complaint

  static List<ticket.Datum> clientticketlist = [];

  static List<area.Datum> masterarealist = [];

  static List<block.Datum> masterblocklist = [];
  static List<sitedrop.Datum> sitedropdown = [];
  // static List<visitview.Datum> opersationvisitview = [];
  static List <visitGraph.VisitDatum> opersationvisitview = [];
  static List <viewcard.Datum> visitview = [];




  static List<clientsite.Datum> complaintclientlist = [];
  static List<GraphDatum> superviorgraphlist = [];
  static List<notify.Datum> notifylist = [];
  static bool multiday = false;
  static String clienname = "";
  static var visitClintId;
  static var visitSiteId;

//janitor master

  static List<janodet.Datum> janitormasterlist = [];

  static void clearAll() {
    // Clear all static lists
    mainlisttab.clear();
    dropdownList.clear();
    operationalmainlisttab.clear();
    detailopeermainlisttab.clear();
    tabsmain = <Tab>[];
    mainlisttabs.clear();
    todayworkflow.clear();
    upcomingworkflow.clear();
    attendanceemployeelist.clear();
    workflowstatuslist.clear();
    pendingworkflowstatuslist.clear();
    priorityworkflowstatuslist.clear();
    checkboxeslist.clear();
    multipleSelectedlist.clear();
    resolvedlist.clear();
    pendingcomlist.clear();
    dependentcomlist.clear();
    pendingcomplaintlist.clear();
    unitlowattendacelist.clear();
    employeeattendacelist.clear();
    clientmasterlist.clear();
    sitemasterlist.clear();
    graphlist.clear();
    trendgraphlist.clear();
    activitylist.clear();
    operationalworkflowstatuslist.clear();
    ratinggraphlist.clear();
    ratinglistwisegraphlist.clear();
    operationalpriorityworkflowlist.clear();
    traininggraphlist.clear();
    clientticketlist.clear();
    masterarealist.clear();
    masterblocklist.clear();
    sitedropdown.clear();
    opersationvisitview.clear();
    complaintclientlist.clear();
    superviorgraphlist.clear();
    notifylist.clear();
    janitormasterlist.clear();

    // Reset strings & numbers
    clientname = "";
    sitename = "";
    shifttime = "";
    shiftendtime = "";
    nooftotalstaff = "";
    noofstaff = "";
    attendancedate = "";
    clientid = "";
    siteid = "";
    shiftid = "";
    empId = "";
    card_startcurrentdatevalue = "";
    card_endcurrentdatevalue = "";
    card_superviorfirtvalue = "";
    card_percentvalue = "";
    total_supervisorercentage = "0";
    shiftavaialble = "0";
    start_time = "";
    end_time = "";
    notapplicable = 0;
    pendingcount = "";
    prioritycount = "";
    pendingtotalcount = "";
    prioritytotalcount = "";
    unresolvedcomplaint = "";
    multiday = false;

    role = "";

    attendance_delete_permission = false;
    isloadedAttendance = false;
    isloadedWokeflow = false;

    // Reset double values
    attendanceper = 0.0;
    workflowper = 0.0;
    totalattendanceper = 0.0;

    // Reset tags
    maintag = 0;
    selectedindex = 0;
    ratingclienttag = 0;
    traningclienttag = 0;

    // Reset controllers
    datecontroller.text = "";

    // Reset Unit Dashboard object
    unitdashboard = unitdash.UnitDashboardResponse(
      pendingTrainingPercentage: 0,
      pendingTrainingSiteCount: 0,
      notapplicable: 0,
      clientdata: [],
      lowRatingCount: 0,
      pendingWorkflowSite: 0,
      totalPrioritySiteCount: 0,
      pendingPriorityWorkflowSiteCount: 0,
      status: 0,
      msg: "",
      workflowCheckCount: 0,
      workflowTotalCount: 0,
      workflowPercentage: 0,
      priorityWorkflowPercentage: [],
      attendancePercentage: 0,
      pendingCompliantCount: 0,
      ratingCount: 0,
      lowattendancedata: [],
      lowatteandancecount: 0,
      totalSiteCount: 0,
      visitCount: 0,
    );
  }
}
