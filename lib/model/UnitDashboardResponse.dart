// To parse this JSON data, do
//
//     final unitDashboardResponse = unitDashboardResponseFromJson(jsonString);

import 'dart:convert';

UnitDashboardResponse unitDashboardResponseFromJson(String str) =>
    UnitDashboardResponse.fromJson(json.decode(str));

String unitDashboardResponseToJson(UnitDashboardResponse data) =>
    json.encode(data.toJson());

class UnitDashboardResponse {
  int status;
  int notapplicable;
  String msg;
  dynamic workflowCheckCount;
  dynamic workflowTotalCount;
  dynamic pendingWorkflowSite;
  dynamic workflowPercentage;
  dynamic priorityWorkflowPercentage;
  dynamic pendingPriorityWorkflowSiteCount;
  dynamic totalPrioritySiteCount;
  dynamic attendancePercentage;
  dynamic pendingCompliantCount;
  dynamic ratingCount;
  dynamic lowRatingCount;
  List<Lowattendancedatum> lowattendancedata;
  dynamic lowatteandancecount;
  dynamic pendingTrainingSiteCount;
  dynamic pendingTrainingPercentage;
  dynamic totalSiteCount;
  List<Clientdatum> clientdata;
  dynamic visitCount;

  UnitDashboardResponse({
    required this.status,
    required this.notapplicable,
    required this.msg,
    required this.workflowCheckCount,
    required this.workflowTotalCount,
    required this.pendingWorkflowSite,
    required this.workflowPercentage,
    required this.priorityWorkflowPercentage,
    required this.pendingPriorityWorkflowSiteCount,
    required this.totalPrioritySiteCount,
    required this.attendancePercentage,
    required this.pendingCompliantCount,
    required this.ratingCount,
    required this.lowRatingCount,
    required this.lowattendancedata,
    required this.lowatteandancecount,
    required this.pendingTrainingSiteCount,
    required this.pendingTrainingPercentage,
    required this.totalSiteCount,
    required this.clientdata,
    required this.visitCount,
  });

  factory UnitDashboardResponse.fromJson(Map<String, dynamic> json) =>
      UnitDashboardResponse(
        status: json["status"] ?? 0,
        notapplicable: json["notapplicable"] ?? 0,
        msg: json["msg"]?.toString() ?? "",

        workflowCheckCount: json["workflow_check_count"],
        workflowTotalCount: json["workflow_total_count"],
        pendingWorkflowSite: json["pending_workflow_site"],
        workflowPercentage: json["workflow_percentage"],
        priorityWorkflowPercentage: json["priority_workflow_percentage"],
        pendingPriorityWorkflowSiteCount:
            json["pending_priority_workflow_site_count"],
        totalPrioritySiteCount: json["total_priority_site_count"],
        attendancePercentage: json["attendance_percentage"],
        pendingCompliantCount: json["pending_compliant_count"],
        ratingCount: json["rating_count"],
        lowRatingCount: json["low_rating_count"],

        lowattendancedata: json["lowattendancedata"] == null
            ? []
            : List<Lowattendancedatum>.from(
                (json["lowattendancedata"] as List).map(
                  (x) => Lowattendancedatum.fromJson(x),
                ),
              ),

        lowatteandancecount: json["lowatteandancecount"],

        pendingTrainingSiteCount: json["pending_training_site_count"],

        pendingTrainingPercentage: json["pending_training_percentage"] != null
            ? double.tryParse(json["pending_training_percentage"].toString())
            : null,

        totalSiteCount: json["total_site_count"],

        clientdata: json["clientdata"] == null
            ? []
            : List<Clientdatum>.from(
                (json["clientdata"] as List).map(
                  (x) => Clientdatum.fromJson(x),
                ),
              ),

        visitCount: json["visit_count"],
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "notapplicable": notapplicable,
    "msg": msg,
    "workflow_check_count": workflowCheckCount,
    "workflow_total_count": workflowTotalCount,
    "pending_workflow_site": pendingWorkflowSite,
    "workflow_percentage": workflowPercentage,
    "priority_workflow_percentage": priorityWorkflowPercentage,
    "pending_priority_workflow_site_count": pendingPriorityWorkflowSiteCount,
    "total_priority_site_count": totalPrioritySiteCount,
    "attendance_percentage": attendancePercentage,
    "pending_compliant_count": pendingCompliantCount,
    "rating_count": ratingCount,
    "low_rating_count": lowRatingCount,
    "lowattendancedata": List<dynamic>.from(
      lowattendancedata.map((x) => x.toJson()),
    ),
    "lowatteandancecount": lowatteandancecount,
    "pending_training_site_count": pendingTrainingSiteCount,
    "pending_training_percentage": pendingTrainingPercentage,
    "total_site_count": totalSiteCount,
    "clientdata": List<dynamic>.from(clientdata.map((x) => x.toJson())),
    'visit_count': visitCount,
  };
}

class Clientdatum {
  String clientName;
  List<Detail> details;

  Clientdatum({required this.clientName, required this.details});

  factory Clientdatum.fromJson(Map<String, dynamic> json) => Clientdatum(
    clientName: json["client_name"] ?? "",
    details: List<Detail>.from(json["details"].map((x) => Detail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "client_name": clientName,
    "details": List<dynamic>.from(details.map((x) => x.toJson())),
  };
}

class Detail {
  String startTime;
  String endTime;
  dynamic id;
  String clientName;
  dynamic checkCount;
  dynamic uncheckCount;
  dynamic totalcount;
  dynamic percentage;
  dynamic status;
  List<MasterAreaWiseList> masterAreaWiseList;
  String sTime;
  String startTimeStr;
  String endTimeStr;

  Detail({
    required this.startTime,
    required this.endTime,
    required this.id,
    required this.clientName,
    required this.checkCount,
    required this.uncheckCount,
    required this.totalcount,
    required this.percentage,
    required this.status,
    required this.masterAreaWiseList,
    required this.sTime,
    required this.startTimeStr,
    required this.endTimeStr,
  });

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
    startTime: json["start_time"]?.toString() ?? "",
    endTime: json["end_time"]?.toString() ?? "",
    id: json["id"],
    clientName: json["client_name"]?.toString() ?? "",
    checkCount: json["check_count"],
    uncheckCount: json["uncheck_count"],
    totalcount: json["totalcount"],
    percentage: json["percentage"],
    status: json["status"],

    masterAreaWiseList: json["master_area_wise_list"] == null
        ? []
        : List<MasterAreaWiseList>.from(
            (json["master_area_wise_list"] as List).map(
              (x) => MasterAreaWiseList.fromJson(x),
            ),
          ),

    sTime: json["s_time"]?.toString() ?? "",
    startTimeStr: json["start_time_str"]?.toString() ?? "",
    endTimeStr: json["end_time_str"]?.toString() ?? "",
  );

  Map<String, dynamic> toJson() => {
    "start_time": startTime,
    "end_time": endTime,
    "id": id,
    "client_name": clientName,
    "check_count": checkCount,
    "uncheck_count": uncheckCount,
    "totalcount": totalcount,
    "percentage": percentage,
    "status": status,
    "master_area_wise_list": List<dynamic>.from(
      masterAreaWiseList.map((x) => x.toJson()),
    ),
    "s_time": sTime,
    "start_time_str": startTimeStr,
    "end_time_str": endTimeStr,
  };
}

class MasterAreaWiseList {
  dynamic masterArea;
  String masterAreaName;
  dynamic checkCount;
  dynamic uncheckCount;
  dynamic totalCount;
  dynamic status;
  List<BlockDatum> blockData;

  MasterAreaWiseList({
    required this.masterArea,
    required this.masterAreaName,
    required this.checkCount,
    required this.uncheckCount,
    required this.totalCount,
    required this.status,
    required this.blockData,
  });

  factory MasterAreaWiseList.fromJson(Map<String, dynamic> json) =>
      MasterAreaWiseList(
        masterArea: json["master_area"],
        masterAreaName: json["master_area_name"] ?? "",
        checkCount: json["check_count"] ?? 0,
        uncheckCount: json["uncheck_count"] ?? 0,
        totalCount: json["total_count"] ?? 0,
        status: json["status"],
        blockData: json["block_data"] == null
            ? []
            : List<BlockDatum>.from(
                json["block_data"].map((x) => BlockDatum.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
    "master_area": masterArea,
    "master_area_name": masterAreaName,
    "check_count": checkCount,
    "uncheck_count": uncheckCount,
    "total_count": totalCount,
    "status": status,
    "block_data": List<dynamic>.from(blockData.map((x) => x.toJson())),
  };
}

class BlockDatum {
  int id;
  DateTime createdAt;
  dynamic updatedAt;
  dynamic createdBy;
  dynamic updatedBy;
  bool isActive;
  dynamic clientWiseCheckListId;
  String startTime;
  String endTime;
  dynamic masterArea;
  dynamic masterBlock;
  dynamic shift;
  dynamic masterAreaName;
  dynamic masterBlockName;
  List<Checklist> checklist;

  BlockDatum({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.updatedBy,
    required this.isActive,
    required this.clientWiseCheckListId,
    required this.startTime,
    required this.endTime,
    required this.masterArea,
    required this.masterBlock,
    required this.shift,
    required this.masterAreaName,
    required this.masterBlockName,
    required this.checklist,
  });

  factory BlockDatum.fromJson(Map<String, dynamic> json) => BlockDatum(
    id: json["id"] ?? 0,
    createdAt: json["createdAt"] != null
        ? DateTime.parse(json["createdAt"])
        : DateTime.now(),
    updatedAt: json["updatedAt"],
    createdBy: json["createdBy"],
    updatedBy: json["updatedBy"],
    isActive: json["isActive"] ?? false,
    clientWiseCheckListId: json["ClientWiseCheckList_id"],
    startTime: json["start_time"] ?? "",
    endTime: json["end_time"] ?? "",
    masterArea: json["master_area"],
    masterBlock: json["master_block"],
    shift: json["Shift"],
    masterAreaName: json["master_area_name"] ?? "",
    masterBlockName: json["master_block_name"] ?? "",
    checklist: (json["checklist"] == null)
        ? []
        : List<Checklist>.from(
            json["checklist"].map((x) => Checklist.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt,
    "createdBy": createdBy,
    "updatedBy": updatedBy,
    "isActive": isActive,
    "ClientWiseCheckList_id": clientWiseCheckListId,
    "start_time": startTime,
    "end_time": endTime,
    "master_area": masterArea,
    "master_block": masterBlock,
    "Shift": shift,
    "master_area_name": masterAreaName,
    "master_block_name": masterBlockName,
    "checklist": List<dynamic>.from(checklist.map((x) => x.toJson())),
  };
}

class Checklist {
  int id;
  DateTime createdAt;
  dynamic updatedAt;
  dynamic createdBy;
  dynamic updatedBy;
  bool isActive;
  String pointerName;
  bool checkStatus;
  dynamic masterBlockId;
  dynamic checkListTimeTableId;
  bool adminCheckStatus;
  bool checked;

  Checklist({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.updatedBy,
    required this.isActive,
    required this.pointerName,
    required this.checkStatus,
    required this.masterBlockId,
    required this.checkListTimeTableId,
    required this.adminCheckStatus,
    required this.checked,
  });

  factory Checklist.fromJson(Map<String, dynamic> json) => Checklist(
     id: json["id"] ?? 0,
        createdAt: json["createdAt"] != null
            ? DateTime.parse(json["createdAt"])
            : DateTime.now(),
        updatedAt: json["updatedAt"],
        createdBy: json["createdBy"],
        updatedBy: json["updatedBy"],
        isActive: json["isActive"] ?? false,
        pointerName: json["pointer_name"] ?? "",
        checkStatus: json["check_status"] ?? false,
        masterBlockId: json["master_block_id"],
        checkListTimeTableId: json["check_list_time_table_id"],
        adminCheckStatus: json["admin_check_status"] ?? false,
        checked: json["checked"] ?? false,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt,
    "createdBy": createdBy,
    "updatedBy": updatedBy,
    "isActive": isActive,
    "pointer_name": pointerName,
    "check_status": checkStatus,
    "master_block_id": masterBlockId,
    "check_list_time_table_id": checkListTimeTableId,
    "admin_check_status": adminCheckStatus,
    "checked": checked,
  };
}

class Lowattendancedatum {
  int clientId;
  String clientName;
  dynamic attendedCount;
  dynamic totalStaff;

  Lowattendancedatum({
    required this.clientId,
    required this.clientName,
    required this.attendedCount,
    required this.totalStaff,
  });

  factory Lowattendancedatum.fromJson(Map<String, dynamic> json) =>
      Lowattendancedatum(
        clientId: json["client_id"],
        clientName: json["client_name"] ?? "",
        attendedCount: json["attended_count"],
        totalStaff: json["total_staff"],
      );

  Map<String, dynamic> toJson() => {
    "client_id": clientId,
    "client_name": clientName,
    "attended_count": attendedCount,
    "total_staff": totalStaff,
  };
}
