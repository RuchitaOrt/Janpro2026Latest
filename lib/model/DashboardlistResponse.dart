import 'dart:convert';

DashboardlistResponse dashboardlistResponseFromJson(String str) =>
    DashboardlistResponse.fromJson(json.decode(str));

String dashboardlistResponseToJson(DashboardlistResponse data) =>
    json.encode(data.toJson());

class DashboardlistResponse {
  int? status;
  String? msg;
  Data? data;
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

  DashboardlistResponse({
    this.status,
    this.msg,
    this.data,
    this.workflowPercentage,
    required this.pendingTaskDetail,
    this.pendingTaskCount,
    this.pendingtotalTaskCount,
    required this.penddingcomplaint,
    this.penddingcomplaintcount,
    required this.prioritydetails,
    this.priorityTaskCount,
    this.prioritytotalTaskCount,
    this.priorityPercentageCount,
    this.clientid,
    this.siteid,
    this.permission,
    this.notapplicable,
  });

  factory DashboardlistResponse.fromJson(Map<String, dynamic> json) =>
      DashboardlistResponse(
        status: _parseInt(json["status"]),
        msg: json["msg"]?.toString(),
        data: json["data"] != null && json["data"] is Map && json["data"].isNotEmpty
            ? Data.fromJson(json["data"])
            : null,
        workflowPercentage: json["workflow_percentage"],
        pendingTaskDetail: json["pending_task_detail"] is List
            ? List<Detail>.from(
                (json["pending_task_detail"] as List).map((x) => Detail.fromJson(x)))
            : [],
        pendingTaskCount: json["pending_task_count"],
        pendingtotalTaskCount: json["pendingtotal_task_count"],
        penddingcomplaint: json["penddingcomplaint"] is List
            ? List<Penddingcomplaint>.from(
                (json["penddingcomplaint"] as List).map((x) => Penddingcomplaint.fromJson(x)))
            : [],
        penddingcomplaintcount: json["penddingcomplaintcount"],
        prioritydetails: json["prioritydetails"] is List
            ? List<Detail>.from(
                (json["prioritydetails"] as List).map((x) => Detail.fromJson(x)))
            : [],
        priorityTaskCount: json["priority_task_count"],
        prioritytotalTaskCount: json["prioritytotal_task_count"],
        priorityPercentageCount: json["priority_percentage_count"],
        clientid: _parseInt(json["clientid"]),
        siteid: _parseInt(json["siteid"]),
        permission: json["permission"],
        notapplicable: _parseInt(json["notapplicable"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
        "data": data?.toJson(),
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
      };

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) {
      return int.tryParse(value);
    }
    if (value is num) {
      return value.toInt();
    }
    return null;
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      return double.tryParse(value);
    }
    return null;
  }
}

class Data {
  int? id;
  dynamic createdAt;
  dynamic updatedAt;
  dynamic createdBy;
  dynamic updatedBy;
  bool? isActive;
  dynamic siteConfigId;
  String? shiftName;
  String? shiftStartTime;
  String? shiftEndTime;
  dynamic noOfStaff;
  String? supervisor;
  String? startTime;
  String? endTime;
  dynamic clientId;
  String? clientName;
  dynamic siteId;
  String? siteName;
  dynamic count;
  double? attendancePercentage;
  bool? multidays;

  Data({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
    this.isActive,
    this.siteConfigId,
    this.shiftName,
    this.shiftStartTime,
    this.shiftEndTime,
    this.noOfStaff,
    this.supervisor,
    this.startTime,
    this.endTime,
    this.clientId,
    this.clientName,
    this.siteId,
    this.siteName,
    this.count,
    this.attendancePercentage,
    this.multidays,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: DashboardlistResponse._parseInt(json["id"]),
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        createdBy: json["createdBy"],
        updatedBy: json["updatedBy"],
        isActive: json["isActive"] as bool?,
        siteConfigId: json["site_config_id"],
        shiftName: json["shift_name"]?.toString(),
        shiftStartTime: json["shift_start_time"]?.toString(),
        shiftEndTime: json["shift_end_time"]?.toString(),
        noOfStaff: json["no_of_staff"],
        supervisor: json["supervisor"]?.toString(),
        startTime: json["start_time"]?.toString(),
        endTime: json["end_time"]?.toString(),
        clientId: DashboardlistResponse._parseInt(json["client_id"]),
        clientName: json["client_name"]?.toString(),
        siteId: json["Site_id"],
        siteName: json["site_name"]?.toString(),
        count: json["count"],
        attendancePercentage: DashboardlistResponse._parseDouble(json["attendance_percentage"]),
        multidays: json["multidays"] as bool?,
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
  int? id;
  DateTime? createdAt;
  dynamic updatedAt;
  dynamic createdBy;
  String? updatedBy;
  bool? isActive;
  String? complainantName;
  dynamic complaintType;
  String? subject;
  String? client;
  String? site;
  String? status;
  String? image1;
  String? image2;
  String? image3;
  String? comment;
  String? tatDuration;
  DateTime? date;

  Penddingcomplaint({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
    this.isActive,
    this.complainantName,
    this.complaintType,
    this.subject,
    this.client,
    this.site,
    this.status,
    this.image1,
    this.image2,
    this.image3,
    this.comment,
    this.tatDuration,
    this.date,
  });

  factory Penddingcomplaint.fromJson(Map<String, dynamic> json) => Penddingcomplaint(
        id: DashboardlistResponse._parseInt(json["id"]),
        createdAt: json["createdAt"] != null && json["createdAt"].toString().isNotEmpty
            ? DateTime.tryParse(json["createdAt"].toString())
            : null,
        updatedAt: json["updatedAt"],
        createdBy: json["createdBy"],
        updatedBy: json["updatedBy"]?.toString(),
        isActive: json["isActive"] as bool?,
        complainantName: json["complainant_name"]?.toString(),
        complaintType: json["complaint_type"],
        subject: json["subject"]?.toString(),
        client: json["client"]?.toString(),
        site: json["site"]?.toString(),
        status: json["status"]?.toString(),
        image1: json["image1"]?.toString(),
        image2: json["image2"]?.toString(),
        image3: json["image3"]?.toString(),
        comment: json["comment"]?.toString(),
        tatDuration: json["TAT_duration"]?.toString(),
        date: json["date"] != null && json["date"].toString().isNotEmpty
            ? DateTime.tryParse(json["date"].toString())
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt?.toIso8601String(),
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
        "date": date?.toIso8601String(),
      };
}

class Detail {
  String? startTime;
  String? endTime;
  dynamic checkCount;
  dynamic uncheckCount;
  dynamic totalcount;
  dynamic percentage;
  String? status;
  List<MasterAreaWiseList> masterAreaWiseList;

  Detail({
    this.startTime,
    this.endTime,
    this.checkCount,
    this.uncheckCount,
    this.totalcount,
    this.percentage,
    this.status,
    required this.masterAreaWiseList,
  });

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        startTime: json["start_time"]?.toString(),
        endTime: json["end_time"]?.toString(),
        checkCount: json["check_count"],
        uncheckCount: json["uncheck_count"],
        totalcount: json["totalcount"],
        percentage: json["percentage"],
        status: json["status"]?.toString(),
        masterAreaWiseList: json["master_area_wise_list"] is List
            ? List<MasterAreaWiseList>.from(
                (json["master_area_wise_list"] as List)
                    .map((x) => MasterAreaWiseList.fromJson(x)))
            : [],
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
  String? masterAreaName;
  dynamic checkCount;
  dynamic uncheckCount;
  dynamic totalCount;
  String? status;
  List<BlockDatum> blockData;

  MasterAreaWiseList({
    this.masterArea,
    this.masterAreaName,
    this.checkCount,
    this.uncheckCount,
    this.totalCount,
    this.status,
    required this.blockData,
  });

  factory MasterAreaWiseList.fromJson(Map<String, dynamic> json) =>
      MasterAreaWiseList(
        masterArea: json["master_area"],
        masterAreaName: json["master_area_name"]?.toString(),
        checkCount: json["check_count"],
        uncheckCount: json["uncheck_count"],
        totalCount: json["total_count"],
        status: json["status"]?.toString(),
        blockData: json["block_data"] is List
            ? List<BlockDatum>.from(
                (json["block_data"] as List).map((x) => BlockDatum.fromJson(x)))
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
  int? id;
  DateTime? createdAt;
  dynamic updatedAt;
  dynamic createdBy;
  dynamic updatedBy;
  bool? isActive;
  dynamic clientWiseCheckListId;
  String? startTime;
  String? endTime;
  dynamic masterArea;
  dynamic masterBlock;
  dynamic shift;
  String? masterAreaName;
  String? masterBlockName;
  List<Checklist> checklist;

  BlockDatum({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
    this.isActive,
    this.clientWiseCheckListId,
    this.startTime,
    this.endTime,
    this.masterArea,
    this.masterBlock,
    this.shift,
    this.masterAreaName,
    this.masterBlockName,
    required this.checklist,
  });

  factory BlockDatum.fromJson(Map<String, dynamic> json) => BlockDatum(
        id: DashboardlistResponse._parseInt(json["id"]),
        createdAt: json["createdAt"] != null && json["createdAt"].toString().isNotEmpty
            ? DateTime.tryParse(json["createdAt"].toString())
            : null,
        updatedAt: json["updatedAt"],
        createdBy: json["createdBy"],
        updatedBy: json["updatedBy"],
        isActive: json["isActive"] as bool?,
        clientWiseCheckListId: json["ClientWiseCheckList_id"],
        startTime: json["start_time"]?.toString(),
        endTime: json["end_time"]?.toString(),
        masterArea: json["master_area"],
        masterBlock: json["master_block"],
        shift: json["Shift"],
        masterAreaName: json["master_area_name"]?.toString(),
        masterBlockName: json["master_block_name"]?.toString(),
        checklist: json["checklist"] is List
            ? List<Checklist>.from(
                (json["checklist"] as List).map((x) => Checklist.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt?.toIso8601String(),
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
  int? id;
  DateTime? createdAt;
  dynamic updatedAt;
  dynamic createdBy;
  dynamic updatedBy;
  bool? isActive;
  String? pointerName;
  bool? checkStatus;
  dynamic masterBlockId;
  dynamic checkListTimeTableId;
  bool? checked;

  Checklist({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
    this.isActive,
    this.pointerName,
    this.checkStatus,
    this.masterBlockId,
    this.checkListTimeTableId,
    this.checked,
  });

  factory Checklist.fromJson(Map<String, dynamic> json) => Checklist(
        id: DashboardlistResponse._parseInt(json["id"]),
        createdAt: json["createdAt"] != null && json["createdAt"].toString().isNotEmpty
            ? DateTime.tryParse(json["createdAt"].toString())
            : null,
        updatedAt: json["updatedAt"],
        createdBy: json["createdBy"],
        updatedBy: json["updatedBy"],
        isActive: json["isActive"] as bool?,
        pointerName: json["pointer_name"]?.toString(),
        checkStatus: json["check_status"] as bool?,
        masterBlockId: json["master_block_id"],
        checkListTimeTableId: json["check_list_time_table_id"],
        checked: json["checked"] as bool?,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt?.toIso8601String(),
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