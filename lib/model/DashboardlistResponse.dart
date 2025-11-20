// To parse this JSON data, do
//
//     final dashboardlistResponse = dashboardlistResponseFromJson(jsonString);

import 'dart:convert';

DashboardlistResponse dashboardlistResponseFromJson(String str) =>
    DashboardlistResponse.fromJson(json.decode(str));

String dashboardlistResponseToJson(DashboardlistResponse data) =>
    json.encode(data.toJson());

class DashboardlistResponse {
  int status;
  String msg;
  Data data;
  dynamic workflowPercentage;
  List<Detail> pendingTaskDetail;
  dynamic pendingTaskCount;
  dynamic pendingtotalTaskCount;
  List<Penddingcomplaint> penddingcomplaint;
  dynamic penddingcomplaintcount;
  List<Detail> prioritydetails;
  dynamic priorityTaskCount;
  dynamic prioritytotalTaskCount;
  dynamic priorityPercentageCount;

  dynamic clientid;
  dynamic siteid;
  dynamic permission;
  dynamic notapplicable;
  // dynamic multiday;

  DashboardlistResponse({
    required this.status,
    required this.msg,
    required this.data,
    required this.workflowPercentage,
    required this.pendingTaskDetail,
    required this.pendingTaskCount,
    required this.pendingtotalTaskCount,
    required this.penddingcomplaint,
    required this.penddingcomplaintcount,
    required this.prioritydetails,
    required this.priorityTaskCount,
    required this.prioritytotalTaskCount,
    required this.priorityPercentageCount,
    required this.clientid,
    required this.siteid,
    required this.permission,
    required this.notapplicable,
    // required this.multiday,
  });

  factory DashboardlistResponse.fromJson(Map<String, dynamic> json) =>
      DashboardlistResponse(
          status: json["status"],
          msg: json["msg"],
          data: json["data"] == {} ? json["data"] : Data.fromJson(json["data"]),
          workflowPercentage: json["workflow_percentage"],
          pendingTaskDetail: json["pending_task_detail"] == []
              ? []
              : List<Detail>.from(
                  json["pending_task_detail"].map((x) => Detail.fromJson(x))),
          pendingTaskCount: json["pending_task_count"],
          pendingtotalTaskCount: json["pendingtotal_task_count"],
          penddingcomplaint: json["penddingcomplaint"] == []
              ? []
              : List<Penddingcomplaint>.from(json["penddingcomplaint"]
                  .map((x) => Penddingcomplaint.fromJson(x))),
          penddingcomplaintcount: json["penddingcomplaintcount"],
          prioritydetails: json["prioritydetails"] == []
              ? []
              : List<Detail>.from(
                  json["prioritydetails"].map((x) => Detail.fromJson(x))),
          priorityTaskCount: json["priority_task_count"],
          prioritytotalTaskCount: json["prioritytotal_task_count"],
          priorityPercentageCount: json["priority_percentage_count"],
          clientid: json["clientid"],
          siteid: json["siteid"],
          permission: json["permission"],
          notapplicable: json["notapplicable"],
          );

  Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
        "data": data.toJson(),
        "workflow_percentage": workflowPercentage,
        "pending_task_detail":
            List<dynamic>.from(pendingTaskDetail.map((x) => x.toJson())),
        "pending_task_count": pendingTaskCount,
        "pendingtotal_task_count": pendingtotalTaskCount,
        "penddingcomplaint":
            List<dynamic>.from(penddingcomplaint.map((x) => x.toJson())),
        "penddingcomplaintcount": penddingcomplaintcount,
        "prioritydetails":
            List<dynamic>.from(prioritydetails.map((x) => x.toJson())),
        "priority_task_count": priorityTaskCount,
        "prioritytotal_task_count": prioritytotalTaskCount,
        "priority_percentage_count": priorityPercentageCount,
        "clientid": clientid,
        "siteid": siteid,
        "permission": permission,
        "notapplicable": notapplicable,
        // 'multidays': multiday
      };
}

class Data {
  int id;
  dynamic createdAt;
  dynamic updatedAt;
  dynamic createdBy;
  dynamic updatedBy;
  dynamic isActive;
  dynamic siteConfigId;
  String shiftName;
  String shiftStartTime;
  String shiftEndTime;
  dynamic noOfStaff;
  String supervisor;
  String startTime;
  String endTime;
  dynamic clientId;
  String clientName;
  dynamic siteId;
  String siteName;
  dynamic count;
  double attendancePercentage;
  bool multidays;

  Data({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.updatedBy,
    required this.isActive,
    required this.siteConfigId,
    required this.shiftName,
    required this.shiftStartTime,
    required this.shiftEndTime,
    required this.noOfStaff,
    required this.supervisor,
    required this.startTime,
    required this.endTime,
    required this.clientId,
    required this.clientName,
    required this.siteId,
    required this.siteName,
    required this.count,
    required this.attendancePercentage,
    required this.multidays,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
      id: json["id"] ?? 0,
      createdAt: json["createdAt"],
      updatedAt: json["updatedAt"],
      createdBy: json["createdBy"],
      updatedBy: json["updatedBy"],
      isActive: json["isActive"] ?? false,
      siteConfigId: json["site_config_id"],
      shiftName: json["shift_name"] ?? "",
      shiftStartTime: json["shift_start_time"] ?? "",
      shiftEndTime: json["shift_end_time"] ?? "",
      noOfStaff: json["no_of_staff"] ?? 0,
      supervisor: json["supervisor"] ?? "",
      startTime: json["start_time"] ?? "",
      endTime: json["end_time"] ?? "",
      clientId: json["client_id"],
      clientName: json["client_name"] ?? "",
      siteId: json["Site_id"],
      siteName: json["site_name"] ?? "",
      count: json["count"] ?? 0,
      attendancePercentage:
          json["attendance_percentage"] != null ? json["attendance_percentage"].toDouble() : 0.0,
      multidays: json["multidays"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "createdBy": createdBy,
        "updatedBy": updatedBy,
        "isActive": isActive,
        "site_config_id": siteConfigId,
        "shift_name": shiftName,
        "shift_start_time": shiftStartTime,
        "shift_end_time": shiftEndTime,
        "no_of_staff": noOfStaff,
        "supervisor": supervisor,
        "start_time": startTime,
        "end_time": endTime,
        "client_id": clientId,
        "client_name": clientName,
        "Site_id": siteId,
        "site_name": siteName,
        "count": count,
        "attendance_percentage": attendancePercentage,
        "multidays": multidays,
      };
}

class Penddingcomplaint {
  int id;
  DateTime createdAt;
  dynamic updatedAt;
  dynamic createdBy;
  String? updatedBy;
  bool isActive;
  String complainantName;
  dynamic complaintType;
  String subject;
  String client;
  String site;
  String status;
  String? image1;
  String? image2;
  String? image3;
  String comment;
  String? tatDuration;
  DateTime date;

  Penddingcomplaint({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.updatedBy,
    required this.isActive,
    required this.complainantName,
    required this.complaintType,
    required this.subject,
    required this.client,
    required this.site,
    required this.status,
    required this.image1,
    required this.image2,
    required this.image3,
    required this.comment,
    required this.tatDuration,
    required this.date,
  });

  factory Penddingcomplaint.fromJson(Map<String, dynamic> json) =>
      Penddingcomplaint(
         id: json["id"] ?? 0,
      createdAt: json["createdAt"] != null
          ? DateTime.tryParse(json["createdAt"]) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json["updatedAt"],
      createdBy: json["createdBy"],
      updatedBy: json["updatedBy"],
      isActive: json["isActive"] ?? false,
      complainantName: json["complainant_name"] ?? "",
      complaintType: json["complaint_type"],
      subject: json["subject"] ?? "",
      client: json["client"] ?? "",
      site: json["site"] ?? "",
      status: json["status"] ?? "",
      image1: json["image1"],
      image2: json["image2"],
      image3: json["image3"],
      comment: json["comment"] ?? "",
      tatDuration: json["TAT_duration"],
      date: json["date"] != null
          ? DateTime.tryParse(json["date"]) ?? DateTime.now()
          : DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt,
        "createdBy": createdBy,
        "updatedBy": updatedBy,
        "isActive": isActive,
        "complainant_name": complainantName,
        "complaint_type": complaintType,
        "subject": subject,
        "client": client,
        "site": site,
        "status": status,
        "image1": image1,
        "image2": image2,
        "image3": image3,
        "comment": comment,
        "TAT_duration": tatDuration,
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
      };
}

class Detail {
  String startTime;
  String endTime;
  dynamic checkCount;
  dynamic uncheckCount;
  dynamic totalcount;
  dynamic percentage;
  String status;
  List<MasterAreaWiseList> masterAreaWiseList;

  Detail({
    required this.startTime,
    required this.endTime,
    required this.checkCount,
    required this.uncheckCount,
    required this.totalcount,
    required this.percentage,
    required this.status,
    required this.masterAreaWiseList,
  });

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        startTime: json["start_time"]??'',
        endTime: json["end_time"]??'',
        checkCount: json["check_count"],
        uncheckCount: json["uncheck_count"],
        totalcount: json["totalcount"],
        percentage: json["percentage"],
        status: json["status"]??'',
        masterAreaWiseList: List<MasterAreaWiseList>.from(
            json["master_area_wise_list"]
                .map((x) => MasterAreaWiseList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "start_time": startTime,
        "end_time": endTime,
        "check_count": checkCount,
        "uncheck_count": uncheckCount,
        "totalcount": totalcount,
        "percentage": percentage,
        "status": status,
        "master_area_wise_list":
            List<dynamic>.from(masterAreaWiseList.map((x) => x.toJson())),
      };
}

class MasterAreaWiseList {
  dynamic masterArea;
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
        masterArea: json["master_area"],
        masterAreaName: json["master_area_name"]??"",
        checkCount: json["check_count"],
        uncheckCount: json["uncheck_count"],
        totalCount: json["total_count"],
        status: json["status"]??'',
        blockData: List<BlockDatum>.from(
            json["block_data"].map((x) => BlockDatum.fromJson(x))),
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
        id: json["id"]??0,
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"],
        createdBy: json["createdBy"],
        updatedBy: json["updatedBy"],
        isActive: json["isActive"]??false,
        clientWiseCheckListId: json["ClientWiseCheckList_id"],
        startTime: json["start_time"]??'',
        endTime: json["end_time"]??'',
        masterArea: json["master_area"],
        masterBlock: json["master_block"],
        shift: json["Shift"],
        masterAreaName: json["master_area_name"]??'',
        masterBlockName: json["master_block_name"]??'',
        checklist: json["checklist"] == null
            ? []
            : List<Checklist>.from(
                json["checklist"].map((x) => Checklist.fromJson(x))),
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
        "checklist": checklist == null
            ? []
            : List<dynamic>.from(checklist.map((x) => x.toJson())),
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
    required this.checked,
  });

  factory Checklist.fromJson(Map<String, dynamic> json) => Checklist(
        id: json["id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"],
        createdBy: json["createdBy"],
        updatedBy: json["updatedBy"],
        isActive: json["isActive"]??false,
        pointerName: json["pointer_name"]??"",
        checkStatus: json["check_status"]??false,
        masterBlockId: json["master_block_id"],
        checkListTimeTableId: json["check_list_time_table_id"],
        checked: json["checked"]??false,
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
        "checked": checked,
      };
}
