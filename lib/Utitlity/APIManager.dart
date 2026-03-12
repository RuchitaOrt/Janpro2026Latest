import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:janpro/Utitlity/AppEror.dart';
import 'package:http/http.dart' as http;
import 'package:janpro/Utitlity/GlobalLists.dart';
import 'package:janpro/Utitlity/ShowDialog.dart';
import 'package:janpro/model/ActivitylistResponse.dart';
import 'package:janpro/model/AddAttendanceResponse.dart';
import 'package:janpro/model/AddSpecialActivityResponse.dart';
import 'package:janpro/model/AddratingResponse.dart';
import 'package:janpro/model/AddtrainingResponse.dart';
import 'package:janpro/model/ApprovAttendanceRooster.dart';
import 'package:janpro/model/ApproveRejectSubmit.dart';
import 'package:janpro/model/AttendencelistResponse.dart';
import 'package:janpro/model/ClientDashboardResponse.dart';
import 'package:janpro/model/ClientsiteDashboardResponse.dart';
import 'package:janpro/model/ClientwisetrainingResponse.dart';
import 'package:janpro/model/CommonResponse.dart';
import 'package:janpro/model/DashboardlistResponse.dart';
import 'package:janpro/model/DeleteAttendance.dart';
import 'package:janpro/model/FridgeAttendanceRosterResponse.dart';
import 'package:janpro/model/FullDetailSpecialActivityResponse.dart';
import 'package:janpro/model/GetComplaintResponse.dart';
import 'package:janpro/model/GetDependentResponse.dart';
import 'package:janpro/model/JanitorActiveDeactive.dart';
import 'package:janpro/model/JanitorAdd.dart';
import 'package:janpro/model/JanitorContactFetchResponse.dart';
import 'package:janpro/model/JanitorDelete.dart';
import 'package:janpro/model/JanitorDetials.dart';
import 'package:janpro/model/JanitorUpdate.dart';
import 'package:janpro/model/JanitorslistResponse.dart';
import 'package:janpro/model/LoginResponse.dart';
import 'package:janpro/model/LogoutResponse.dart';
import 'package:janpro/model/MasterBlockResponse.dart';
import 'package:janpro/model/MasterareaResponse.dart';
import 'package:janpro/model/MobilelisttrainingResponse.dart';
import 'package:janpro/model/NotificationlistResponse.dart';
import 'package:janpro/model/OperationalPrioritylistResponse.dart';
import 'package:janpro/model/OperationalRatinggraphwiseResponse.dart';
import 'package:janpro/model/OperationalWorkflowResponse.dart';
import 'package:janpro/model/ProfileResponse.dart';
import 'package:janpro/model/RatinglistResponse.dart';
import 'package:janpro/model/RejectAttendanceRooster.dart';
import 'package:janpro/model/SubmitAttendanceRooster.dart';
import 'package:janpro/model/TicketllistResponse.dart' as ticket;
import 'package:janpro/model/TrendGraphResponse.dart';
import 'package:janpro/model/UnitComplaintResponse.dart';
import 'package:janpro/model/UnitDashboardResponse.dart';
import 'package:janpro/model/UnitclientMasterResponse.dart';
import 'package:janpro/model/UnitsiteMasterResponse.dart';
import 'package:janpro/model/UpdateTATResponse.dart';
import 'package:janpro/model/UpdatedworkflowResponse.dart';
import 'package:janpro/model/ViewAttendaceMonthly.dart';
import 'package:janpro/model/WorkflowlistResponse.dart';
import 'package:janpro/model/WorkflowoperationalDetailmodel.dart';
import 'package:janpro/model/Workflowoperationalmodel.dart';
import 'package:janpro/model/WorkfowstatusResponse.dart';
import 'package:janpro/model/unitAttendanceResponse.dart';

import '../model/AddDailyCountResponse.dart';
import '../model/CardVisitView.dart';
import '../model/ClientOperationResponse.dart';
import '../model/OperationVisitView.dart';
import '../model/SiteDropDown.dart';
import '../model/attendance_roster_response.dart';
import '../model/OperationVisitSubmit.dart';
import '../model/unitGraphAttendanceResponse.dart';

enum API {
  login,
  logout,
  ongoingshift,
  workflow,
  attendance,
  addattendance,
  workflowstatus,
  updatedworkflowstatus,
  getcomplaint,
  getdependantcomplaint,
  getresolvedcomplaint,
  gettatcomplaint,
  SingleView_Employee,

  //unit module
  unitdashboard,
  unitattendance,
  overallgraph,
  unitcomplaint,
  unitclientmaster,
  unitsitemaster,
  addrating,
  operationVisitSubmit,

  //operational
  operationalupdatetat,
  operationalfullDetail_SpecialActivity,
  operationaladdspecialactivity,
  operationalactivitylist,
  operationalworkflow,
  operationalratinggraphwise,
  operationalclientwiseratinglist,
  operationalclientwiseprioritylist,
  janitorslist,
  mobilelisttrainingmaster,
  clientwisetraininglist,
  visitwiseList,
  addtraining,

  //clientapi
  clientsitedependentdashboard,
  tickettypelist,
  masterclientarea,
  masterclientblockarea,
  sitedropdown,
  visitview,
  cardvisitview,

  deleteattendance,
  submit_client_attendance_rooster,
  supervisor_submit_attendance_rooster,

  approved_rejected_om_oe_client_submit_attendance_rooster,


  approved_om_oe_attendance_rooster,
  rejected_om_oe_attendance_rooster,
  notificationlist,
  janitors_details,
  janitors_edit,
  janitors_delete,
  janitors_add,
  janitoractivedeactive,
  workflowoperational,
  workflowoperational_trends,
  workflowoperationaldetail,

  //fetch contact
  fetchcontact_janitors,

  //attendance trend

  trends_attendance_graph,
  attendance_roster,
  sup_attendance_roster,

  view_monthly_attendance_rooster_details,

  add_attendance_daily_count
}

enum HTTPMethod { GET, POST, PUT, DELETE }

typedef successCallback = void Function(dynamic response);
typedef progressCallback = void Function(int progress);
typedef failureCallback = void Function(AppError error);

class APIManager {
  static Duration? timeout;
  static String? token;
  static String? baseURL;
  static String? apiVersion;
  var taskId;

  APIManager._privateConstructor();

  static final APIManager _instance = APIManager._privateConstructor();

  factory APIManager() {
    return _instance;
  }

  var url;

  void loadConfiguration(String configString) {
    Map config = jsonDecode(configString);
    var env = config['environment'];
    baseURL = config[env]['hostUrl'];
    apiVersion = config['version'];
    timeout = Duration(seconds: config[env]['timeout']);
    print('load config' + configString);
  }

  void setToken(String value) {
    token = value;
  }

  String apiBaseURL() {
    return baseURL!;
  }

  static String api_key = "sss3!@#project%^&*buyer987!!sum@n@api";
  static String operationaladdspecialactivity =
      baseURL! + "/api/specialactivity/Add_SpecialActivity";
  static String operationaladdtraining =
      baseURL! + "/api/trainingmaster/mobile_add_training_master";
  static String clientaddcomplaint =
      baseURL! + "/api/ticketmanagement/Add_TicketManagement";
  static String getresolvedcomplaint2 =
      baseURL! + "/api/ticketmanagement/ResolvedComplaint";
  static String submitoperation =
      baseURL! + "/api/siteconfigurator/add_information";
  static String markstatus =
      baseURL! + "/api/trainingmaster/update_janitor_status";

  Future<String> apiEndPoint(API api) async {
    var apiPathString = "";

    switch (api) {
      case API.login:
        apiPathString = "/api/employeemaster/login";
        break;
      case API.logout:
        apiPathString = "/api/employeemaster/logout";
        break;
      case API.ongoingshift:
        apiPathString = "/api/siteconfigurator/ongoing_shift";
        break;
      case API.workflow:
        apiPathString = "/api/siteconfigurator/workflow_list";
        break;
      case API.visitview:
        apiPathString = "/api/siteconfigurator/List_information";
        break;
       case API.cardvisitview:
        apiPathString = "/api/siteconfigurator/single_mobiledata_list_information";
        break;
      case API.attendance:
        // apiPathString = "/api/attendancemaster/supervisor_attendance_list";
        apiPathString =
            "/api/attendancemaster/mobileapi_test_supervisor_attendance_list";
        break;
      case API.addattendance:
        apiPathString = "/api/attendancemaster/Mobile_Add_AttendanceMaster";
        break;

      case API.updatedworkflowstatus:
        apiPathString = "/api/siteconfigurator/update_work_status";
        break;
      case API.getcomplaint:
        apiPathString = "/api/ticketmanagement/mobile_complain_list";
        break;
      case API.getdependantcomplaint:
        apiPathString = "/api/ticketmanagement/DependentComplaint";
        break;
      case API.getresolvedcomplaint:
        apiPathString = "/api/ticketmanagement/ResolvedComplaint";
        break;
      case API.gettatcomplaint:
        apiPathString = "/api/ticketmanagement/TATComplaint";
        break;
      case API.SingleView_Employee:
        apiPathString = "/api/employeemaster/SingleView_Employee";
        break;
      case API.unitdashboard:
        apiPathString = "/api/siteconfigurator/dashboard_api";
        break;
      // attendance old
      // case API.unitattendance:
      //   apiPathString = "/api/siteconfigurator/clientwise_attendance_api";
      //   break;
      //for attendance overall graph
      case API.overallgraph:
        apiPathString =
        "/api/masterarea/overall_clientwise_attendance_api";
           // "/api/siteconfigurator/overall_clientwise_attendance_api";
        break;
      case API.unitattendance:
        apiPathString = "/api/siteconfigurator/new_clientwise_attendance_api";
        break;

      case API.unitcomplaint:
        apiPathString = "/api/siteconfigurator/client_complain_list";
        break;
      case API.unitclientmaster:
        apiPathString = "/api/siteconfigurator/client_site_attendance_api";
        break;
      case API.unitsitemaster:
        apiPathString = "/api/siteconfigurator/client_site_dependent";
        break;
      case API.addrating:
        apiPathString = "/api/clientmaster/add_rating";
        break;
      case API.operationalupdatetat:
        apiPathString = "/api/ticketmanagement/Update_TAT";
        break;
      case API.operationVisitSubmit:
        apiPathString = "/api/siteconfigurator/add_information";
        break;
      case API.operationalfullDetail_SpecialActivity:
        apiPathString = "/api/specialactivity/clientwise_SpecialActivity";
        break;
      case API.operationaladdspecialactivity:
        apiPathString = "/api/specialactivity/Add_SpecialActivity";
        break;
      case API.operationalactivitylist:
        apiPathString = "/api/specialactivity/fullDetail_Activity_Type";
        break;
      case API.operationalworkflow:
        apiPathString =
            // "/api/siteconfigurator/client_workflow_list_status";
            "/api/siteconfigurator/full_client_workflow_list_status";
        break;
      case API.workflowstatus:
        apiPathString = "/api/siteconfigurator/full_workflow_list_status";
        //  "/api/siteconfigurator/workflow_list_status";                  //workflow_status";
        break;
      case API.workflowoperationaldetail:
        apiPathString =
            //"/api/siteconfigurator/operation_manager_client_workflow_list_status";
            "/api/siteconfigurator/full_operation_manager_client_workflow_list_status";
        break;
      case API.operationalratinggraphwise:
        apiPathString = "/api/siteconfigurator/clientwise_rating_graph_api";
        break;
      case API.operationalclientwiseratinglist:
        apiPathString = "/api/siteconfigurator/clientwise_rating_list";
        break;
      case API.operationalclientwiseprioritylist:
        apiPathString =
            "/api/siteconfigurator/client_priority_workflow_list_status";
        break;
      case API.janitorslist:
        apiPathString = "/api/attendancemaster/janitors_list";
        break;

      case API.notificationlist:
        apiPathString = "/api/ticketmanagement/notification";
        break;
      case API.mobilelisttrainingmaster:
        apiPathString = "/api/trainingmaster/fullDetail_TrainingAgenda";
        break;
      case API.clientwisetraininglist:
        apiPathString =
            "/api/trainingmaster/mobileapi_clientwise_training_list";
        break;
      case API.visitwiseList:
        apiPathString =
            "/api/siteconfigurator/mobile_List_information";
        break;
      case API.addtraining:
        apiPathString = "/api/trainingmaster/mobile_add_training_master";
        break;
      case API.clientsitedependentdashboard:
        apiPathString = "/api/siteconfigurator/client_dashboard_site_list_api";
        break;
      case API.tickettypelist:
        apiPathString = "/api/ticketmanagement/Ticket_Type_List";
        break;
      case API.masterclientarea:
        apiPathString = "/api/siteconfigurator/master_client_area";
        break;
      case API.masterclientblockarea:
        apiPathString = "/api/siteconfigurator/master_client_area_block";
        break;
      case API.sitedropdown:
        apiPathString =
            "/api/siteconfigurator/sqlqueryclient_list_workflow_page";
        break;
      case API.deleteattendance:
        apiPathString = "/api/attendancemaster/Delete_AttendanceMaster";
        break;
      case API.submit_client_attendance_rooster:
        apiPathString = "/api/attendancemaster/submit_client_attendance_rooster";
        break;
      case API.supervisor_submit_attendance_rooster:
        apiPathString = "/api/attendancemaster/supervisor-submit-attendance-rooster";
        break;
      case API.approved_rejected_om_oe_client_submit_attendance_rooster:
        apiPathString = "/api/attendancemaster/approved_rejected_om_oe_client_submit_attendance_rooster";
        break;
      case API.approved_om_oe_attendance_rooster:
        apiPathString = "/api/attendancemaster/approved_om_oe_attendance_rooster";
        break;
      case API.rejected_om_oe_attendance_rooster:
        apiPathString = "/api/attendancemaster/rejected_om_oe_attendance_rooster";
        break;
      case API.janitors_add:
        apiPathString = "/api/attendancemaster/add_janitors";
        break;
      case API.janitors_delete:
        apiPathString = "/api/attendancemaster/delete_janitor";
        break;
      case API.janitors_details:
        apiPathString = "/api/attendancemaster/rolewise_janitors_details";
        // apiPathString = "/api/attendancemaster/janitors_details";
        break;
      case API.janitors_edit:
        apiPathString = "/api/attendancemaster/update_janitor";
        break;
      case API.janitoractivedeactive:
        apiPathString = "/api/attendancemaster/Active_deactive_janitor";
        break;
      case API.workflowoperational:
        apiPathString =
            "/api/siteconfigurator/sqlqueryclient_list_workflow_page";
        break;
      case API.workflowoperational_trends:
        apiPathString = "/api/siteconfigurator/attendance_trend_for_all";
        break;
      case API.fetchcontact_janitors:
        apiPathString = "/api/attendancemaster/list_janitors";
        break;
      case API.trends_attendance_graph:
        apiPathString = "/api/masterarea/new_trends_attendance_graph";
        //trends_attendance_graph";
        break;
      case API.attendance_roster:
        apiPathString = "/api/attendancemaster/attendance-rooster";
        break;
      case API.sup_attendance_roster:
        apiPathString = "/api/attendancemaster/supervisor-attendance-rooster";
        break;
      case API.view_monthly_attendance_rooster_details:
        apiPathString = "/api/attendancemaster/view_monthly_attendance_rooster_details";
        break;
      case API.add_attendance_daily_count:
        // apiPathString = "/api/siteconfigurator/add_attendance_daily_count";
        apiPathString = "/api/siteconfigurator/Update_staff_count_for_attendance";

        break;

        
      default:
        apiPathString = "/Login";
    }
    // print(apiBaseURL());

    return this.apiBaseURL() + apiPathString;
  }

  HTTPMethod apiHTTPMethod(API api) {
    HTTPMethod method;
    switch (api) {
      case API.login:
      case API.logout:
      case API.workflow:
      case API.attendance:
      case API.ongoingshift:
      case API.addattendance:
      case API.workflowstatus:
      case API.updatedworkflowstatus:
      case API.getcomplaint:
      case API.getdependantcomplaint:
      case API.getresolvedcomplaint:
      case API.gettatcomplaint:
      case API.unitdashboard:
      case API.unitattendance:
      case API.overallgraph:
      case API.unitcomplaint:
      case API.operationVisitSubmit:
      case API.visitview:
      case API.cardvisitview:


      case API.unitclientmaster:
      case API.addrating:
      case API.operationalupdatetat:
      case API.operationaladdspecialactivity:
      case API.operationalworkflow:
      case API.operationalratinggraphwise:
      case API.operationalclientwiseratinglist:
      case API.operationalclientwiseprioritylist:
      case API.clientwisetraininglist:
      case API.visitwiseList:

      case API.addtraining:

      case API.clientsitedependentdashboard:
      case API.masterclientarea:
      case API.masterclientblockarea:
      case API.sitedropdown:

      case API.deleteattendance:
      case API.submit_client_attendance_rooster:
      case API.supervisor_submit_attendance_rooster:
      case API.approved_rejected_om_oe_client_submit_attendance_rooster:
      case API.approved_om_oe_attendance_rooster:
      case API.rejected_om_oe_attendance_rooster:
      case API.janitorslist:
      case API.notificationlist:
      case API.janitors_add:
      case API.janitors_edit:
      case API.janitors_delete:
      case API.janitoractivedeactive:
      case API.operationalfullDetail_SpecialActivity:
      case API.janitors_details:
      case API.workflowoperational:
      case API.workflowoperational_trends:
      case API.workflowoperationaldetail:
      case API.fetchcontact_janitors:
      case API.trends_attendance_graph:
      case API.attendance_roster:
      case API.sup_attendance_roster:
      case API.view_monthly_attendance_rooster_details:
      case API.add_attendance_daily_count:
        method = HTTPMethod.POST;
        break;

      default:
        method = HTTPMethod.GET;
    }
    return method;
  }

  String classNameForAPI(API api) {
    String className;
    switch (api) {
      case API.login:
        className = "LoginResponse";
        break;
      case API.logout:
        className = "LogoutResponse";
        break;
      case API.workflow:
        className = "WorkflowlistResponse";
        break;
      case API.attendance:
        className = "AttendencelistResponse";
        break;
      case API.operationVisitSubmit:
        className = "OperationVisitSubmit";
        break;
      case API.ongoingshift:
        className = "DashboardlistResponse";
        break;
      case API.visitview:
        className = "OperationVisitView";

        break;
      case API.cardvisitview:
        className = "CardVisitView";

        break;
      //  case API.ongoingshift:
      // className = "DashboardlistResponsezero";
      // break;
      case API.addattendance:
        className = "AddAttendanceResponse";
        break;
      case API.workflowstatus:
        className = "WorkfowstatusResponse";
        break;
      case API.updatedworkflowstatus:
        className = "UpdatedworkflowResponse";
        break;
      case API.getcomplaint:
        className = "GetComplaintResponse";
        break;

      case API.getdependantcomplaint:
      case API.getresolvedcomplaint:
      case API.gettatcomplaint:
        className = "GetDependentResponse";
        break;
      case API.SingleView_Employee:
        className = "ProfileResponse";
        break;
      case API.unitdashboard:
        className = "UnitDashboardResponse";
        break;
      case API.unitattendance:
        className = "UnitAttendanceResponse";
        break;
      case API.overallgraph:
        className = "UnitGraphAttendanceResponse";
        break;
      case API.unitcomplaint:
        className = "UnitComplaintResponse";
        break;
      case API.unitclientmaster:
        className = "UnitclientMasterResponse";
        break;
      case API.unitsitemaster:
        className = "UnitsiteMasterResponse";
        break;
      case API.operationalupdatetat:
        className = "UpdateTatResponse";
        break;
      case API.operationalfullDetail_SpecialActivity:
        className = "FullDetailSpecialActivityResponse";
        break;
      case API.operationalactivitylist:
        className = "ActivitylistResponse";
        break;
      case API.operationalworkflow:
        className = "OperationalWorkflowResponse";
        break;
      case API.operationalratinggraphwise:
        className = "OperationalRatinggraphwiseResponse";
        break;
      case API.operationalclientwiseratinglist:
        className = "RatinglistResponse";
        break;
      case API.operationalclientwiseprioritylist:
        className = "OperationalPrioritylistResponse";
        break;
      case API.janitorslist:
        className = "JanitorslistResponse";
        break;
      case API.notificationlist:
        className = "NotificationlistResponse";
        break;
      case API.mobilelisttrainingmaster:
        className = "MobilelisttrainingResponse";
        break;
      case API.clientwisetraininglist:
        className = "ClientwisetrainingResponse";
        break;
      case API.visitwiseList:
        className = "ClientOperationResponse";
        break;
      case API.addtraining:
        className = "AddtrainingResponse";
        break;
      case API.addrating:
        className = "AddratingResponse";
        break;

      case API.clientsitedependentdashboard:
        className = "ClientsiteDashboardResponse";
        break;
      case API.tickettypelist:
        className = "TicketllistResponse";
        break;
      case API.masterclientarea:
        className = "MasterareaResponse";
        break;
      case API.masterclientblockarea:
        className = "MasterBlockResponse";
        break;
      case API.sitedropdown:
        className = "SiteDropDown";
        break;
      case API.deleteattendance:
        className = "DeleteAttendance";
        break;
      case API.submit_client_attendance_rooster:
        className = "SubmitAttendanceRooster";
        break;
      case API.supervisor_submit_attendance_rooster:
        className = "FridgeAttendanceRosterResponse";
        break;
      case API.approved_rejected_om_oe_client_submit_attendance_rooster:
        className = "ApproveRejectSubmit";
        break;
      case API.approved_om_oe_attendance_rooster:
        className = "ApprovAttendanceRooster";
        break;
      
      case API.rejected_om_oe_attendance_rooster:
        className = "RejectAttendanceRooster";
        break;

      case API.janitors_add:
        className = "JanitorAdd";
        break;
      case API.janitors_edit:
        className = "JanitorUpdate";
        break;
      case API.janitors_delete:
        className = "JanitorDelete";
        break;
      case API.janitors_details:
        className = "JanitorDetials";
        break;
      case API.janitoractivedeactive:
        className = "JanitorActiveDeactive";
        break;
      case API.workflowoperational:
        className = "Workflowoperationalmodel";
        break;
      case API.workflowoperational_trends:
        className = "Workflowoperationalmodel";
        break;
      case API.workflowoperationaldetail:
        className = "WorkflowoperationalDetailmodel";
        break;
      case API.fetchcontact_janitors:
        className = "JanitorContactFetchResponse";
        break;
      case API.trends_attendance_graph:
        className = "TrendGraphResponse";
        break;
      case API.attendance_roster:
        className = "AttendanceRosterResponse";
        break;
      case API.sup_attendance_roster:
        className = "AttendanceRosterResponse";
        break;
       case API.view_monthly_attendance_rooster_details:
        className = "ViewAttendaceMonthly";
        break;
        case API.add_attendance_daily_count:
         className = "AddDailyCountResponse";
        break;
      default:
        className = 'CommonResponse';
    }
    return className;
  }

  String classNameForAPIdefault(API api) {
    String className;
    switch (api) {
      default:
        className = 'CommonResponse';
    }
    return className;
  }

  dynamic parseResponse(String className, var json) {
    dynamic responseObj;
    if (className == 'LoginResponse') {
      responseObj = LoginResponse.fromJson(json);
    }
    if (className == 'LogoutResponse') {
      responseObj = LogoutResponse.fromJson(json);
    }
    if (className == 'WorkflowlistResponse') {
      responseObj = WorkflowlistResponse.fromJson(json);
    }
    if (className == 'DashboardlistResponse') {
      responseObj = DashboardlistResponse.fromJson(json);
    }
    if (className == 'AttendencelistResponse') {
      responseObj = AttendencelistResponse.fromJson(json);
    }
    if (className == 'OperationVisitSubmit') {
      responseObj = OperationVisitSubmit.fromJson(json);
    }
    if (className == 'AttendanceRosterResponse') {
      responseObj = AttendanceRosterResponse.fromJson(json);
    }


    if (className == 'ViewAttendaceMonthly') {
      responseObj = ViewAttendaceMonthly.fromJson(json);
    }
    if (className == 'CommonResponse') {
      responseObj = CommonResponse.fromJson(json);
    }
    if (className == 'AddAttendanceResponse') {
      responseObj = AddAttendanceResponse.fromJson(json);
    }
    if (className == 'WorkfowstatusResponse') {
      responseObj = WorkfowstatusResponse.fromJson(json);
    }
    if (className == 'UpdatedworkflowResponse') {
      responseObj = UpdatedworkflowResponse.fromJson(json);
    }
    if (className == 'GetComplaintResponse') {
      responseObj = GetComplaintResponse.fromJson(json);
    }
    if (className == 'GetDependentResponse') {
      responseObj = GetDependentResponse.fromJson(json);
    }
    if (className == 'ProfileResponse') {
      responseObj = ProfileResponse.fromJson(json);
    }
    if (className == 'UnitDashboardResponse') {
      responseObj = UnitDashboardResponse.fromJson(json);
    }
    if (className == 'OperationVisitView') {
      responseObj = OperationVisitView.fromJson(json);
    }
     if (className == 'CardVisitView') {
      responseObj = CardVisitView.fromJson(json);
    }
    if (className == 'SiteDropDown') {
      responseObj = SiteDropDown.fromJson(json);
    }
    if (className == 'UnitAttendanceResponse') {
      responseObj = UnitAttendanceResponse.fromJson(json);
    }
    if (className == 'UnitGraphAttendanceResponse') {
      responseObj = UnitGraphAttendanceResponse.fromJson(json);
    }
    if (className == 'UnitComplaintResponse') {
      responseObj = UnitComplaintResponse.fromJson(json);
    }
    if (className == 'UnitclientMasterResponse') {
      responseObj = UnitclientMasterResponse.fromJson(json);
    }
    if (className == 'UnitsiteMasterResponse') {
      responseObj = UnitsiteMasterResponse.fromJson(json);
    }
    if (className == 'UpdateTatResponse') {
      responseObj = UpdateTatResponse.fromJson(json);
    }
    if (className == 'FullDetailSpecialActivityResponse') {
      responseObj = FullDetailSpecialActivityResponse.fromJson(json);
    }
    if (className == 'AddSpecialActivityResponse') {
      responseObj = AddSpecialActivityResponse.fromJson(json);
    }
    if (className == 'ActivitylistResponse') {
      responseObj = ActivitylistResponse.fromJson(json);
    }
    if (className == 'OperationalWorkflowResponse') {
      responseObj = OperationalWorkflowResponse.fromJson(json);
    }
    if (className == 'OperationalRatinggraphwiseResponse') {
      responseObj = OperationalRatinggraphwiseResponse.fromJson(json);
    }
    if (className == 'RatinglistResponse') {
      responseObj = RatinglistResponse.fromJson(json);
    }
    if (className == 'OperationalPrioritylistResponse') {
      responseObj = OperationalPrioritylistResponse.fromJson(json);
    }
    if (className == 'JanitorslistResponse') {
      responseObj = JanitorslistResponse.fromJson(json);
    }
    if (className == 'MobilelisttrainingResponse') {
      responseObj = MobilelisttrainingResponse.fromJson(json);
    }
    if (className == 'ClientwisetrainingResponse') {
      responseObj = ClientwisetrainingResponse.fromJson(json);
    }
     if (className == 'ClientOperationResponse') {
      responseObj = ClientOperationResponse.fromJson(json);
    }
    if (className == 'AddtrainingResponse') {
      responseObj = AddtrainingResponse.fromJson(json);
    }
    if (className == 'AddratingResponse') {
      responseObj = AddratingResponse.fromJson(json);
    }
    if (className == 'ClientDashboardResponse') {
      responseObj = ClientDashboardResponse.fromJson(json);
    }
    if (className == 'ClientsiteDashboardResponse') {
      responseObj = ClientsiteDashboardResponse.fromJson(json);
    }
    if (className == 'TicketllistResponse') {
      responseObj = ticket.TicketllistResponse.fromJson(json);
    }
    if (className == 'MasterareaResponse') {
      responseObj = MasterareaResponse.fromJson(json);
    }
    if (className == 'TicketllistResponse') {
      responseObj = ticket.TicketllistResponse.fromJson(json);
    }
    if (className == 'MasterBlockResponse') {
      responseObj = MasterBlockResponse.fromJson(json);
    }

    if (className == 'DeleteAttendance') {
      responseObj = DeleteAttendance.fromJson(json);
    }
    if (className == 'SubmitAttendanceRooster') {
      responseObj = SubmitAttendanceRooster.fromJson(json);
    }
     if (className == 'FridgeAttendanceRosterResponse') {
      responseObj = FridgeAttendanceRosterResponse.fromJson(json);
    }
     if (className == 'ApproveRejectSubmit') {
      responseObj = ApproveRejectSubmit.fromJson(json);
    }
     if (className == 'RejectAttendanceRooster') {
      responseObj = RejectAttendanceRooster.fromJson(json);
    }
    if (className == 'ApprovAttendanceRooster') {
      responseObj = ApprovAttendanceRooster.fromJson(json);
    }
    if (className == 'NotificationlistResponse') {
      responseObj = NotificationlistResponse.fromJson(json);
    }
    if (className == 'JanitorAdd') {
      responseObj = JanitorAdd.fromJson(json);
    }

    if (className == 'JanitorUpdate') {
      responseObj = JanitorUpdate.fromJson(json);
    }
    if (className == 'JanitorDelete') {
      responseObj = JanitorDelete.fromJson(json);
    }
    if (className == 'JanitorDetials') {
      responseObj = JanitorDetials.fromJson(json);
    }
    if (className == 'JanitorActiveDeactive') {
      responseObj = JanitorActiveDeactive.fromJson(json);
    }
    if (className == 'Workflowoperationalmodel') {
      responseObj = Workflowoperationalmodel.fromJson(json);
    }
    if (className == 'WorkflowoperationalDetailmodel') {
      responseObj = WorkflowoperationalDetailmodel.fromJson(json);
    }
    if (className == 'JanitorContactFetchResponse') {
      responseObj = JanitorContactFetchResponse.fromJson(json);
    }
    if (className == 'TrendGraphResponse') {
      responseObj = TrendGraphResponse.fromJson(json);
    }

    if (className == 'AddDailyCountResponse') {
      responseObj = AddDailyCountResponse.fromJson(json);
    }

    return responseObj;
  }

  Future<void> apiRequest(
      BuildContext context,
      API api,
      successCallback onSuccess,
      failureCallback onFailure,
      bool isheaders,
      String isapiname,
      {dynamic parameter,
      dynamic params,
      dynamic path,
      dynamic jsonval}) async {
    var jsonResponse;
    http.Response? response;
    Map<String, String> headers = {};
    //  String? token = await SPManager().getAuthToken();

    var body = (parameter != null ? json.encode(parameter) : jsonval);
    // print("bodu" + body);
    url = await this.apiEndPoint(api);
    if (path != null) {
      url = url + path;
      print(url);
    }
    print("print");
    print(jsonval);

    if (isheaders) {
      if (token != "") {
        headers = {
          //  "AppKey": api_key,
          HttpHeaders.contentTypeHeader: 'application/json',
          // "Authorization": "Bearer " + token!
        };
        print("header is $headers");
      } else {
        headers = {
          "Apikey": api_key,
          HttpHeaders.contentTypeHeader: 'application/json',
        };
      }
    } else {
      if (api == API.updatedworkflowstatus) {
        headers = {
          HttpHeaders.contentTypeHeader: 'application/json',
        };
      }
    }
    print('URL is $url');

    print("body is $body");

    print("header is $headers");

    try {
      if (this.apiHTTPMethod(api) == HTTPMethod.POST) {
        response = await http
            .post(Uri.parse(url), body: body, headers: headers)
            .timeout(timeout!);
        print(response.body);
        print('response of post');
      } else if (this.apiHTTPMethod(api) == HTTPMethod.GET) {
        //   print(url);
        response =
            await http.get(Uri.parse(url), headers: headers).timeout(timeout!);
        print('response of get');
        //print(response.body);
      } else if (this.apiHTTPMethod(api) == HTTPMethod.PUT) {
        print('body is -' + body);
        response = await http
            .put(
              Uri.parse(url),
              body: body,
              headers: headers,
            )
            .timeout(timeout!);
      } else if (this.apiHTTPMethod(api) == HTTPMethod.DELETE) {
        response = await http
            .delete(Uri.parse(url), headers: headers)
            .timeout(timeout!);
      }

      //TODO : Handle 201 status code as well
      print('Resp is ${response!.statusCode}');
      if (response.statusCode == 200) {
        //logout appi response is not json

        jsonResponse = json.decode(response.body);
        print('BODY is--> $jsonResponse');
        print(this.classNameForAPI(api));
        if (this.classNameForAPI(api) == "WorkfowstatusResponse" ||
            this.classNameForAPI(api) == "GetDependentResponse" ||
            this.classNameForAPI(api) == "AttendencelistResponse" ||
            this.classNameForAPI(api) == "AddAttendanceResponse" ||
            this.classNameForAPI(api) == "AddratingResponse" ||
            this.classNameForAPI(api) == "OperationalWorkflowResponse" ||
            this.classNameForAPI(api) == "JanitorAdd" ||
            this.classNameForAPI(api) == "JanitorUpdate" ||
            this.classNameForAPI(api) == "JanitorDelete" ||
            this.classNameForAPI(api) == "AttendencelistResponse" ||
            this.classNameForAPI(api) == "UnitAttendanceResponse" ||
            this.classNameForAPI(api) == "UnitGraphAttendanceResponse" ||
            this.classNameForAPI(api) == 'ClientsiteDashboardResponse' ||
            this.classNameForAPI(api) == "GetComplaintResponse" ||
            this.classNameForAPI(api) == "UnitComplaintResponse" ||
            this.classNameForAPI(api) == "ClientsiteDashboardResponse" ||
            this.classNameForAPI(api) == "AttendanceRosterResponse" ||
            this.classNameForAPI(api) == "UnitDashboardResponse") {
          if (jsonResponse['status'] == 0) {
            print("status is zero");
            if (this.classNameForAPI(api) == "AddAttendanceResponse" ||
                this.classNameForAPI(api) == "AddratingResponse" ||
                this.classNameForAPI(api) == "JanitorAdd" ||
                this.classNameForAPI(api) == "JanitorUpdate" ||
                this.classNameForAPI(api) == "JanitorDelete") {
              ShowDialogs.showToast(jsonResponse['msg']);
            //  Navigator.of(context).pop();
            } else {}
            GlobalLists.isAddcomplaintLoader.value=false;
             GlobalLists.isWorflowLoading.value=false;
             GlobalLists.isaddAttendance.value=false;
            GlobalLists.iscomplaintLoadin.value=false;
            GlobalLists.isAddEditJanitor.value=false;
            GlobalLists.isActiveLoader.value=false;
            // if (this.classNameForAPI(api) != 'AttendencelistResponse') {
           // Navigator.of(context).pop();
            // }

            //     if(this.classNameForAPI(api)=="DashboardlistResponse" )
            //       {
            //         //  setState(() {

            //         // });
            // GlobalLists.clientid=jsonResponse['clientid'].toString();
            //           GlobalLists.siteid=jsonResponse['siteid'].toString();
            //            GlobalLists.unresolvedcomplaint=jsonResponse['penddingcomplaintcount'].toString();
            //          //  onSuccess(this.parseResponse(this.classNameForAPIdefault(api), jsonResponse));
            //       }
//  onSuccess(this.parseResponse(this.classNameForAPIdefault(api), jsonResponse));
          } else {
            onSuccess(
                this.parseResponse(this.classNameForAPI(api), jsonResponse));
          }
        } else {
          onSuccess(
              this.parseResponse(this.classNameForAPI(api), jsonResponse));
        }

        // onSuccess(this.parseResponse(this.classNameForAPI(api), jsonResponse));
      } else if (response.statusCode == 201 || response.statusCode == 200) {
        jsonResponse = json.decode(response.body);
        print('Creted Resp dict ${jsonResponse.toString()}');

        onSuccess(this.parseResponse(this.classNameForAPI(api), jsonResponse));
      } else if (response.statusCode == 401) {
        ShowDialogs().unAthorizedTokenErrorDialog(context,
            message: "Session expired. Please login again.");
        // Fluttertoast.showToast(
        //     msg: "Server not responding",
        //     toastLength: Toast.LENGTH_SHORT,
        //     gravity: ToastGravity.BOTTOM,
        //     timeInSecForIosWeb: 1,
        //     backgroundColor: customcolor.darkorange,
        //     textColor: Colors.white,
        //     fontSize: 16.0);
        //clear all shared preferences
        // SPManager().clear().then((value) {
        //   // temporary redirect to login screen
        //   Navigator.pushReplacement(
        //       context, MaterialPageRoute(builder: (context) => MobileLogin()));
        // });
      } else {
        var appError = this.parseError(response);
        // FLog.error(
        //     text:
        //         'Caller : ${programInfo.callerFunctionName} Error : ${appError.toString()}');

        onFailure(appError);
      }
    } catch (error) {
      print('Exception ${error.toString()}');

      // executed for errors of all types other than Exception
      var appError = FetchDataError(error.toString());
      // FLog.error(
      //     text:
      //         'Time : ${Utility().calculateTime(startTime)} Caller : ${programInfo.callerFunctionName} Error : ${appError.toString()}');
      onFailure(appError);
    }
  }

  dynamic parseUploadError(String response, int statusCode) {
    var jsonResponse;
    var message;
    if (response != null && response.length > 0) {
      jsonResponse = json.decode(response);
      if (jsonResponse != null && jsonResponse["status_Message"] != null) {
        message = jsonResponse["status_Message"];
      } else {
        message = response;
      }
    }

    switch (statusCode) {
      case 400:
        return BadRequestError(message);
      case 401:
      case 403:
        return UnauthorisedError(message);
      case 500:
        return ShowDialogs.showToast("server Error");
      default:
        return FetchDataError(
            'Error occured while Communication with Server with StatusCode : ${statusCode}');
    }
  }

  dynamic parseError(http.Response response) {
    var jsonResponse;
    var message;

    if (response.body != null && response.body.toString().length > 0) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null && jsonResponse["desc"] != null) {
        message = jsonResponse["desc"];
      } else {
        message = response.body.toString();
      }
    }

    switch (response.statusCode) {
      case 400:
        return BadRequestError(message);
      case 200:
        return MessageError(message);
      case 401:
      case 403:
        return UnauthorisedError(message);
      case 500:
      default:
        return FetchDataError(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
