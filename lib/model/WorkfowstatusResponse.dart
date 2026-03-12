// // To parse this JSON data, do
// //
// //     final workfowstatusResponse = workfowstatusResponseFromJson(jsonString);

import 'dart:convert';

WorkfowstatusResponse workfowstatusResponseFromJson(String str) =>
    WorkfowstatusResponse.fromJson(json.decode(str));

String workfowstatusResponseToJson(WorkfowstatusResponse data) =>
    json.encode(data.toJson());

class WorkfowstatusResponse {
  int status;
  String msg;
  dynamic total_percentage;
  List<Datum> data;
  int shiftActive;
  bool multidays;
  String start_time;
  String end_time;

  WorkfowstatusResponse({
    required this.status,
    required this.msg,
    required this.data,
    required this.shiftActive,
    required this.multidays,
    required this.start_time,
    required this.end_time,
    required this.total_percentage,
  });

  factory WorkfowstatusResponse.fromJson(Map<String, dynamic> json) =>
      WorkfowstatusResponse(
        status: json["status"] ?? 0,
        shiftActive: json["shift_active"] ?? 0,
        multidays: json["multidays"] ?? false,
        start_time: json["start_time"] ?? '',
        end_time: json["end_time"] ?? '',
        msg: json["msg"],
        total_percentage: json["total_percentage"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "shift_active": shiftActive,
    "multidays": multidays,
    "start_time": start_time,
    "end_time": end_time,
    "msg": msg,
    "total_percentage": total_percentage,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  List<int> id;
  String startTime;
  String endTime;
  dynamic checkCount;
  dynamic uncheckCount;
  dynamic totalcount;
  dynamic percentage;
  bool currentTime;
  String status;
  List<MasterAreaWiseList> masterAreaWiseList;
  String sTime;
  String clientName;
  String siteName;
  int priority_status;
  dynamic shift;
  String endStatus;

  Datum({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.checkCount,
    required this.uncheckCount,
    required this.totalcount,
    required this.percentage,
    required this.status,
    required this.masterAreaWiseList,
    required this.sTime,
    required this.clientName,
    required this.siteName,
    required this.currentTime,
    required this.priority_status,
    required this.shift,
    required this.endStatus,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"] != null ? List<int>.from(json["id"].map((x) => x)) : [],
    startTime: json["start_time"] ?? "",
    endTime: json["end_time"] ?? "",
    checkCount: json["check_count"] ?? 0,
    uncheckCount: json["uncheck_count"] ?? 0,
    totalcount: json["totalcount"] ?? 0,
    percentage: json["percentage"] ?? 0,
    status: json["status"] ?? "",
    currentTime: json["current_time"] ?? false,
    endStatus: json["end_status"] ?? "",
    masterAreaWiseList: json["master_area_wise_list"] != null
        ? List<MasterAreaWiseList>.from(
            json["master_area_wise_list"].map(
              (x) => MasterAreaWiseList.fromJson(x),
            ),
          )
        : [],
    sTime: json["s_time"] ?? "",
    clientName: json["client_name"] ?? "",
    siteName: json["site_name"] ?? "",
    priority_status: json['priority_status'] ?? 0,
    shift: json["Shift"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": List<dynamic>.from(id.map((x) => x)),
    "start_time": startTime,
    "end_time": endTime,
    "check_count": checkCount,
    "uncheck_count": uncheckCount,
    "current_time": currentTime,
    "totalcount": totalcount,
    "percentage": percentage,
    "status": status,
    "master_area_wise_list": List<dynamic>.from(
      masterAreaWiseList.map((x) => x.toJson()),
    ),
    "s_time": sTime,
    "client_name": clientName,
    "site_name": siteName,
    "priority_status": priority_status,
    "end_status": endStatus,
    "Shift": shift,
  };
}

class MasterAreaWiseList {
  int masterArea;
  String masterAreaName;
  dynamic checkCount;
  dynamic uncheckCount;
  dynamic totalCount;
  String status;
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
        masterArea: json["master_area"] ?? 0,
        masterAreaName: json["master_area_name"] ?? "",
        checkCount: json["check_count"] ?? 0,
        uncheckCount: json["uncheck_count"] ?? 0,
        totalCount: json["total_count"] ?? 0,
        status: json["status"] ?? "",
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
  String masterAreaName;
  String masterBlockName;
  List<Checklist> checklist;
  int blockPending;

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
    required this.blockPending,
  });

  factory BlockDatum.fromJson(Map<String, dynamic> json) => BlockDatum(
    id: json["id"] ?? 0,
    createdAt: json["createdAt"] != null
        ? DateTime.parse(json["createdAt"])
        : DateTime.now(),
    updatedAt: json["updatedAt"] ?? "",
    createdBy: json["createdBy"] ?? "",
    updatedBy: json["updatedBy"] ?? "",
    isActive: json["isActive"] ?? false,
    clientWiseCheckListId: json["ClientWiseCheckList_id"] ?? 0,
    startTime: json["start_time"] ?? "",
    endTime: json["end_time"] ?? "",
    masterArea: json["master_area"] ?? 0,
    masterBlock: json["master_block"] ?? 0,
    shift: json["Shift"] ?? "",
    masterAreaName: json["master_area_name"] ?? "",
    masterBlockName: json["master_block_name"] ?? "",
    blockPending: json["block_pending"] ?? 0,
    checklist: json["checklist"] != null
        ? List<Checklist>.from(
            json["checklist"].map((x) => Checklist.fromJson(x)),
          )
        : [],
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
    "block_pending": blockPending,
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
  dynamic pointerId;
  dynamic checkListTimeTableId;
  String pointerName;
  bool checked;
  bool finalCheck;

  Checklist({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.updatedBy,
    required this.isActive,
    required this.pointerId,
    required this.checkListTimeTableId,
    required this.pointerName,
    required this.checked,
    required this.finalCheck,
  });

  factory Checklist.fromJson(Map<String, dynamic> json) => Checklist(
    id: json["id"] ?? 0,
        createdAt: json["createdAt"] != null
            ? DateTime.parse(json["createdAt"])
            : DateTime.now(),
        updatedAt: json["updatedAt"] ?? "",
        createdBy: json["createdBy"] ?? "",
        updatedBy: json["updatedBy"] ?? "",
        isActive: json["isActive"] ?? false,
        pointerId: json["pointer_id"] ?? 0,
        checkListTimeTableId: json["check_list_time_table_id"] ?? 0,
        pointerName: json["pointer_name"] ?? "",
        checked: json["checked"] ?? false,
        finalCheck: json["final_check"] ?? false,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt,
    "createdBy": createdBy,
    "updatedBy": updatedBy,
    "isActive": isActive,
    "pointer_id": pointerId,
    "check_list_time_table_id": checkListTimeTableId,
    "pointer_name": pointerName,
    "checked": checked,
    "final_check": finalCheck,
  };
}
