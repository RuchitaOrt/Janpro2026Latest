// To parse this JSON data, do
//
//     final attendencelistResponse = attendencelistResponseFromJson(jsonString);

import 'dart:convert';

AttendencelistResponse attendencelistResponseFromJson(String str) =>
    AttendencelistResponse.fromJson(json.decode(str));

String attendencelistResponseToJson(AttendencelistResponse data) =>
    json.encode(data.toJson());

class AttendencelistResponse {
  int status;
  String msg;
  Data data;
  List<GraphDatum> graphData;

  AttendencelistResponse({
    required this.status,
    required this.msg,
    required this.data,
    required this.graphData,
  });

  factory AttendencelistResponse.fromJson(Map<String, dynamic> json) =>
      AttendencelistResponse(
        status: json["status"],
        msg: json["msg"],
        data: Data.fromJson(json["data"]),
        graphData: List<GraphDatum>.from(
          json["graph_data"].map((x) => GraphDatum.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "data": data.toJson(),
    "graph_data": List<dynamic>.from(graphData.map((x) => x.toJson())),
  };
}

class Data {
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
  dynamic clientId;
  String clientName;
  dynamic siteId;
  String siteName;
  dynamic count;
  List<EmployeeList> employeeList;
  String date;
  dynamic percentage;
  String clientSiteName;
  bool lowattendance;

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
    required this.employeeList,
    required this.date,
    required this.percentage,
    required this.clientSiteName,
    required this.lowattendance,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"] ?? 0,

    createdAt: json["createdAt"] != null
        ? DateTime.tryParse(json["createdAt"].toString()) ?? DateTime.now()
        : DateTime.now(),

    updatedAt: json["updatedAt"],
    createdBy: json["createdBy"],
    updatedBy: json["updatedBy"],
    isActive: json["isActive"] ?? false,
    siteConfigId: json["site_config_id"],

    shiftName: json["shift_name"] ?? "",
    shiftStartTime: json["shift_start_time"] ?? "",
    shiftEndTime: json["shift_end_time"] ?? "",
    noOfStaff: json["no_of_staff"],

    supervisor: json["supervisor"] ?? "",
    startTime: json["start_time"] ?? "",
    endTime: json["end_time"] ?? "",

    clientId: json["client_id"],
    clientName: json["client_name"] ?? "",
    siteId: json["Site_id"],
    siteName: json["site_name"] ?? "",
    count: json["count"],

    employeeList: json["employee_list"] == null
        ? []
        : List<EmployeeList>.from(
            json["employee_list"].map((x) => EmployeeList.fromJson(x)),
          ),

    date: json["Date"]?.toString() ?? "",
    percentage: json["percentage"],
    clientSiteName: json["client_site_name"] ?? "",
    lowattendance: json["lowattendance"] ?? false,
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
    "client_name": clientName,
    "Site_id": siteId,
    "site_name": siteName,
    "count": count,
    "employee_list": List<dynamic>.from(employeeList.map((x) => x.toJson())),
    "Date": date,
    "percentage": percentage,
    "client_site_name": clientSiteName,
    "lowattendance": lowattendance,
  };
}

class EmployeeList {
  int id;
  String name;
  String contact;
  String loginTime;

  EmployeeList({
    required this.id,
    required this.name,
    required this.contact,
    required this.loginTime,
  });

  factory EmployeeList.fromJson(Map<String, dynamic> json) => EmployeeList(
    id: json["id"]??0,
    name: json["name"]??"",
    contact: json["contact"]??"",
    loginTime: json["login_time"]??"",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "contact": contact,
    "login_time": loginTime,
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
    month: json["month"]??"",
    monthname: json["monthname"]??"",
    percentage: json["percentage"],
  );

  Map<String, dynamic> toJson() => {
    "month": month,
    "monthname": monthname,
    "percentage": percentage,
  };
}
