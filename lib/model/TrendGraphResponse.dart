// To parse this JSON data, do
//
//     final trendGraphResponse = trendGraphResponseFromJson(jsonString);

import 'dart:convert';

TrendGraphResponse trendGraphResponseFromJson(String str) => TrendGraphResponse.fromJson(json.decode(str));

String trendGraphResponseToJson(TrendGraphResponse data) => json.encode(data.toJson());

class TrendGraphResponse {
    int status;
    String msg;
    List<Datum> data;
    List<GraphDatum> graphData;

    TrendGraphResponse({
        required this.status,
        required this.msg,
        required this.data,
        required this.graphData,
    });

    factory TrendGraphResponse.fromJson(Map<String, dynamic> json) => TrendGraphResponse(
        status: json["status"],
        msg: json["msg"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        graphData: List<GraphDatum>.from(json["graph_data"].map((x) => GraphDatum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "graph_data": List<dynamic>.from(graphData.map((x) => x.toJson())),
    };
}

class Datum {
    int clientId;
    String clientName;
    dynamic siteId;
    bool lowattendance;
    dynamic todayAttendanceCount;
    dynamic todayTotalNoStaff;
    dynamic attendedCount;
    dynamic totalNoStaff;
    List<AttendanceDetail> attendanceDetails;

    Datum({
        required this.clientId,
        required this.clientName,
        required this.siteId,
        required this.lowattendance,
        required this.todayAttendanceCount,
        required this.todayTotalNoStaff,
        required this.attendedCount,
        required this.totalNoStaff,
        required this.attendanceDetails,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        clientId: json["client_id"],
        clientName: json["client_name "]??'',
        siteId: json["site_id"],
        lowattendance: json["lowattendance"]??false,
        todayAttendanceCount: json["today_attendance_count"],
        todayTotalNoStaff: json["today_total_no_staff"],
        attendedCount: json["attended_count"],
        totalNoStaff: json["total_no_staff"],
        attendanceDetails: List<AttendanceDetail>.from(json["attendance_details"].map((x) => AttendanceDetail.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "client_id": clientId,
        "client_name ": clientName,
        "site_id": siteId,
        "lowattendance": lowattendance,
        "today_attendance_count": todayAttendanceCount,
        "today_total_no_staff": todayTotalNoStaff,
        "attended_count": attendedCount,
        "total_no_staff": totalNoStaff,
        "attendance_details": List<dynamic>.from(attendanceDetails.map((x) => x.toJson())),
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
    String sTime;
    String startTime;
    String endTime;
    dynamic clientId;
    String clientName;
    dynamic siteId;
    String siteName;
    dynamic count;
    List<dynamic> employeeList;
    String date;
    dynamic percentage;

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
        required this.sTime,
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
    });

    factory AttendanceDetail.fromJson(Map<String, dynamic> json) => AttendanceDetail(
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
        sTime: json["s_time"]?.toString() ?? "",
        startTime: json["start_time"]?.toString() ?? "",
        endTime: json["end_time"]?.toString() ?? "",
        clientId: json["client_id"],
        clientName: json["client_name"]?.toString() ?? "",
        siteId: json["Site_id"],
        siteName: json["site_name"]?.toString() ?? "",
        count: json["count"],
        employeeList: json["employee_list"] != null
            ? List<dynamic>.from((json["employee_list"] as List).map((x) => x))
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
        "s_time": sTime,
        "start_time": startTime,
        "end_time": endTime,
        "client_id": clientId,
        "client_name": clientName,
        "Site_id": siteId,
        "site_name": siteName,
        "count": count,
        "employee_list": List<dynamic>.from(employeeList.map((x) => x)),
        "Date": date,
        "percentage": percentage,
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
