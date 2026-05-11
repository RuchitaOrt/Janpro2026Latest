// To parse this JSON data, do
//
//     final unitAttendanceResponse = unitAttendanceResponseFromJson(jsonString);

import 'dart:convert';

UnitAttendanceResponse unitAttendanceResponseFromJson(String str) =>
    UnitAttendanceResponse.fromJson(json.decode(str));

String unitAttendanceResponseToJson(UnitAttendanceResponse data) =>
    json.encode(data.toJson());

class UnitAttendanceResponse {
  int status;
  String msg;
  List<Datum> data;

  // List<GraphDatum> graphData;

  UnitAttendanceResponse({
    required this.status,
    required this.msg,
    required this.data,
    // required this.graphData,
  });

  factory UnitAttendanceResponse.fromJson(
    Map<String, dynamic> json,
  ) => UnitAttendanceResponse(
    status: json["status"],
    msg: json["msg"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    // graphData: List<GraphDatum>.from(json["graph_data"].map((x) => GraphDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    // "graph_data": List<dynamic>.from(graphData.map((x) => x.toJson())),
  };
}

class Datum {
  int clientId;
  int siteId;
  String clientName;
  bool lowattendance;
  dynamic attendedCount;
  dynamic totalNoStaff;
  dynamic notapplicable;
  List<AttendanceDetail> attendanceDetails;

  Datum({
    required this.clientId,
    required this.siteId,
    required this.clientName,
    required this.lowattendance,
    required this.attendedCount,
    required this.totalNoStaff,
    required this.attendanceDetails,
    required this.notapplicable,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    siteId: json["site_id"] ?? 0,
    clientId: json["client_id"] ?? 0,
    clientName: json["client_name "]?.toString() ?? "",
    lowattendance: json["lowattendance"] ?? false,
    attendedCount: json["attended_count"],
    totalNoStaff: json["total_no_staff"],
    notapplicable: json["notapplicable"],
    attendanceDetails: json["attendance_details"] != null
        ? List<AttendanceDetail>.from(
            (json["attendance_details"] as List).map(
              (x) => AttendanceDetail.fromJson(x),
            ),
          )
        : [],
  );

  Map<String, dynamic> toJson() => {
    "site_id": siteId,
    "client_id": clientId,
    "client_name ": clientName,
    "lowattendance": lowattendance,
    "attended_count": attendedCount,
    "total_no_staff": totalNoStaff,
    "notapplicable": notapplicable,
    "attendance_details": List<dynamic>.from(
      attendanceDetails.map((x) => x.toJson()),
    ),
  };
}

class AttendanceDetail {
  int id;
  DateTime createdAt;
  dynamic updatedAt;
  dynamic createdBy;
  dynamic updatedBy;
  bool isActive;
  dynamic siteConfigId;
  String shiftName;
  String shiftStartTime;
  String shiftEndTime;
  dynamic noOfStaff;
  String supervisor;
  String startTime;
  String endTime;
  int clientId;
  String clientName;
  int siteId;
  String siteName;
  dynamic count;
  List<EmployeeList> employeeList;
  String date;
  dynamic percentage;
  bool currentTime;
  bool permission;

  AttendanceDetail({
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
    required this.currentTime,
    required this.permission,
    required this.employeeList,
    required this.date,
    required this.percentage,
  });

  factory AttendanceDetail.fromJson(Map<String, dynamic> json) =>
      AttendanceDetail(
        id: json["id"] ?? 0,

        createdAt: json["createdAt"] != null
            ? DateTime.tryParse(json["createdAt"].toString()) ?? DateTime.now()
            : DateTime.now(),

        updatedAt: json["updatedAt"],
        createdBy: json["createdBy"],
        updatedBy: json["updatedBy"],
        isActive: json["isActive"] ?? false,
        siteConfigId: json["site_config_id"],
        shiftName: json["shift_name"]?.toString() ?? "",
        shiftStartTime: json["shift_start_time"]?.toString() ?? "",
        shiftEndTime: json["shift_end_time"]?.toString() ?? "",
        noOfStaff: json["no_of_staff"],
        supervisor: json["supervisor"]?.toString() ?? "",
        startTime: json["start_time"]?.toString() ?? "",
        endTime: json["end_time"]?.toString() ?? "",
        clientId: json["client_id"] ?? 0,
        clientName: json["client_name"]?.toString() ?? "",
        siteId: json["Site_id"] ?? 0,
        siteName: json["site_name"]?.toString() ?? "",
        currentTime: json["current_time"] ?? false,
        permission: json["permission"] ?? false,
        count: json["count"],
        employeeList: json["employee_list"] != null
            ? List<EmployeeList>.from(
                (json["employee_list"] as List).map(
                  (e) => EmployeeList.fromJson(e),
                ),
              )
            : [],

        date: json["Date"]?.toString() ?? "",

        percentage: json["percentage"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "createdAt": createdAt.toIso8601String(),
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
    "current_time": currentTime,
    "permission": permission,
    "client_name": clientName,
    "Site_id": siteId,
    "site_name": siteName,
    "count": count,
    "employee_list": List<dynamic>.from(employeeList.map((x) => x.toJson())),
    "Date": date,
    "percentage": percentage,
  };
}

class EmployeeList {
  int id;
  String name;
  String contact;
  String loginTime;
  int? janmarkid;

  EmployeeList({
    required this.id,
    required this.name,
    required this.contact,
    required this.loginTime,
    this.janmarkid
  });

  factory EmployeeList.fromJson(Map<String, dynamic> json) => EmployeeList(
    id: json["id"]??0,
    name: json["name"]??'',
    contact: json["contact"]??'',
    loginTime: json["login_time"]??"",
    janmarkid: json['jan_mark_id'] ?? ""
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "contact": contact,
    "login_time": loginTime,
    "janmarkid":janmarkid
  };
}

class GraphDatum {
  String month;
  String monthname;
  dynamic percentage;

  GraphDatum({
    required this.month,
    required this.monthname,
    required this.percentage,
  });

  factory GraphDatum.fromJson(Map<String, dynamic> json) => GraphDatum(
    month: json["month"]??'',
    monthname: json["monthname"]??'',
    percentage: json["percentage"],
  );

  Map<String, dynamic> toJson() => {
    "month": month,
    "monthname": monthname,
    "percentage": percentage,
  };
}
