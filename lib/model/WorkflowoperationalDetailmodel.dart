// // // To parse this JSON data, do
// // //
// // //     final workflowoperationalDetailmodel = workflowoperationalDetailmodelFromJson(jsonString);

// ignore_for_file: prefer_if_null_operators

import 'dart:convert';

WorkflowoperationalDetailmodel workflowoperationalDetailmodelFromJson(
  String str,
) => WorkflowoperationalDetailmodel.fromJson(json.decode(str));

String workflowoperationalDetailmodelToJson(
  WorkflowoperationalDetailmodel data,
) => json.encode(data.toJson());

class WorkflowoperationalDetailmodel {
  int status;
  String msg;
  List<Datum> data;

  WorkflowoperationalDetailmodel({
    required this.status,
    required this.msg,
    required this.data,
  });

  factory WorkflowoperationalDetailmodel.fromJson(Map<String, dynamic> json) =>
      WorkflowoperationalDetailmodel(
        status: json["status"],
        msg: json["msg"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String clientName;
  dynamic pendingstatus;
  List<Detail> details;
  String superviourName;
  String supTimes;
  dynamic totalPercentage;

  Datum({
    required this.clientName,
    required this.pendingstatus,
    required this.details,
    required this.superviourName,
    required this.supTimes,
    required this.totalPercentage,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    clientName: json["client_name"] ?? "",
    pendingstatus: json["pendingstatus"],
    superviourName: json["superviour_name"] ?? "",
    supTimes: json["sup_times"] ?? "",
    totalPercentage: json["total_percentage"],
    details: json["details"] != null
        ? List<Detail>.from(json["details"].map((x) => Detail.fromJson(x)))
        : [],
  );

  Map<String, dynamic> toJson() => {
    "client_name": clientName,
    "pendingstatus": pendingstatus,
    "superviour_name": superviourName,
    "sup_times": supTimes,
    "total_percentage": totalPercentage,
    "details": List<dynamic>.from(details.map((x) => x.toJson())),
  };
}

class Detail {
  String startTime;
  String endTime;
  List<int> id;
  // dynamic id;
  dynamic shift;
  dynamic priorityStatus;
  String clientName;
  dynamic checkCount;
  dynamic uncheckCount;
  dynamic totalcount;
  dynamic percentage;
  String status;
  List<MasterAreaWiseList> masterAreaWiseList;
  String sTime;
  bool currentTime;
  String supervisorName;
  String startTimeStr;
  String endTimeStr;

  Detail({
    required this.startTime,
    required this.endTime,
    required this.id,
    required this.shift,
    required this.priorityStatus,
    required this.clientName,
    required this.checkCount,
    required this.uncheckCount,
    required this.totalcount,
    required this.percentage,
    required this.status,
    required this.masterAreaWiseList,
    required this.sTime,
    required this.currentTime,
    required this.supervisorName,
    required this.startTimeStr,
    required this.endTimeStr,
  });

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
    startTime: json["start_time"] ?? "",
    endTime: json["end_time"] ?? "",
    id: json["id"] != null ? List<int>.from(json["id"].map((x) => x)) : [],
    shift: json["Shift"],
    priorityStatus: json["priority_status"],
    clientName: json["client_name"] ?? "",
    checkCount: json["check_count"] ?? 0,
    uncheckCount: json["uncheck_count"] ?? 0,
    totalcount: json["totalcount"] ?? 0,
    percentage: json["percentage"] ?? 0,
    status: json["status"] ?? "",
    masterAreaWiseList: json["master_area_wise_list"] != null
        ? List<MasterAreaWiseList>.from(
            json["master_area_wise_list"].map(
              (x) => MasterAreaWiseList.fromJson(x),
            ),
          )
        : [],
    sTime: json["s_time"] ?? "",
    currentTime: json["current_time"] ?? false,
    supervisorName: json["supervisor_name"] ?? "",
    startTimeStr: json["start_time_str"] ?? "",
    endTimeStr: json["end_time_str"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "start_time": startTime,
    "end_time": endTime,
    "id": List<dynamic>.from(id.map((x) => x)),
    // "id": id,
    "Shift": shift,
    "priority_status": priorityStatus,
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
    "current_time": currentTime,
    "supervisor_name": supervisorName,
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
  String status;
  dynamic pendingArea;
  List<BlockDatum> blockData;

  MasterAreaWiseList({
    required this.masterArea,
    required this.masterAreaName,
    required this.checkCount,
    required this.uncheckCount,
    required this.totalCount,
    required this.status,
    required this.pendingArea,
    required this.blockData,
  });

  factory MasterAreaWiseList.fromJson(Map<String, dynamic> json) =>
      MasterAreaWiseList(
        masterArea: json["master_area"],
        masterAreaName: json["master_area_name"] ?? "",
        checkCount: json["check_count"] ?? 0,
        uncheckCount: json["uncheck_count"] ?? 0,
        totalCount: json["total_count"] ?? 0,
        status: json["status"] ?? "",
        pendingArea: json["pending_area"],
        blockData: json["block_data"] != null
            ? List<BlockDatum>.from(
                json["block_data"].map((x) => BlockDatum.fromJson(x)),
              )
            : [],
      );

  Map<String, dynamic> toJson() => {
    "master_area": masterArea,
    "master_area_name": masterAreaName,
    "check_count": checkCount,
    "uncheck_count": uncheckCount,
    "total_count": totalCount,
    "status": status,
    "pending_area": pendingArea,
    "block_data": List<dynamic>.from(blockData.map((x) => x.toJson())),
  };
}

class BlockDatum {
  dynamic id;
  dynamic createdAt;
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
  String masterBlockName;
  dynamic blockPending;
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
    required this.blockPending,
    required this.checklist,
  });

  factory BlockDatum.fromJson(Map<String, dynamic> json) => BlockDatum(
    id: json["id"],
    createdAt: json["createdAt"] ?? "",
    updatedAt: json["updatedAt"] ?? "",
    createdBy: json["createdBy"] ?? "",
    updatedBy: json["updatedBy"] ?? "",
    isActive: json["isActive"] ?? false,
    clientWiseCheckListId: json["ClientWiseCheckList_id"],
    startTime: json["start_time"] ?? "",
    endTime: json["end_time"] ?? "",
    masterArea: json["master_area"],
    masterBlock: json["master_block"],
    shift: json["Shift"],
    masterAreaName: json["master_area_name"] ?? "",
    masterBlockName: json["master_block_name"] ?? "",
    blockPending: json["block_pending"],
    checklist: json["checklist"] != null
        ? List<Checklist>.from(
            json["checklist"].map((x) => Checklist.fromJson(x)),
          )
        : [],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "createdAt": createdAt,
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
    "block_pending": blockPending,
    "checklist": List<dynamic>.from(checklist.map((x) => x.toJson())),
  };
}

class Checklist {
  int id;
  dynamic createdAt;
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
    createdAt: json["createdAt"] ?? "",
    updatedAt: json["updatedAt"] ?? "",
    createdBy: json["createdBy"] ?? "",
    updatedBy: json["updatedBy"] ?? "",
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
    "createdAt": createdAt,
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
