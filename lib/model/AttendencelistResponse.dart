
import 'dart:convert';

AttendencelistResponse attendencelistResponseFromJson(String str) =>
    AttendencelistResponse.fromJson(json.decode(str));

String attendencelistResponseToJson(AttendencelistResponse data) =>
    json.encode(data.toJson());

class AttendencelistResponse {
  int? status;
  String? msg;
  Data? data;
  List<GraphDatum>? graphData;

  AttendencelistResponse({
    this.status,
    this.msg,
    this.data,
    this.graphData,
  });

  factory AttendencelistResponse.fromJson(Map<String, dynamic> json) =>
      AttendencelistResponse(
        status: json["status"],
        msg: json["msg"],
        data: json["data"] == null
            ? null
            : Data.fromJson(json["data"]),
        graphData: json["graph_data"] == null
            ? []
            : List<GraphDatum>.from(
                json["graph_data"].map(
                  (x) => GraphDatum.fromJson(x),
                ),
              ),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
        "data": data?.toJson(),
        "graph_data":
            graphData?.map((x) => x.toJson()).toList() ?? [],
      };
}

class Data {
  int? clientId;
   String? clientName;
  String? clientSiteName;
  int? siteId;
  String? siteName;
  bool? lowattendance;
  int? attendedCount;
  int? totalNoStaff;
  List<AttendanceDetail>? attendanceDetails;

  Data({
    this.clientId,
     this.clientName,
    this.clientSiteName,
    this.siteId,
    this.siteName,
    this.lowattendance,
    this.attendedCount,
    this.totalNoStaff,
    this.attendanceDetails,
  });

  factory Data.fromJson(Map<String, dynamic> json) =>
      Data(
        clientId: json["client_id"],
        clientName: json["client_name"],
        clientSiteName:json['clientSiteName'],
        siteId: json["site_id"],
        siteName: json["site_name"],
        lowattendance: json["lowattendance"],
        attendedCount: json["attended_count"],
        totalNoStaff: json["total_no_staff"],
        attendanceDetails: json["attendance_details"] == null
            ? []
            : List<AttendanceDetail>.from(
                json["attendance_details"].map(
                  (x) => AttendanceDetail.fromJson(x),
                ),
              ),
      );

  Map<String, dynamic> toJson() => {
        "client_id": clientId,
        "client_name": clientName,
        "clientSiteName":clientSiteName,
        "site_id": siteId,
        "site_name": siteName,
        "lowattendance": lowattendance,
        "attended_count": attendedCount,
        "total_no_staff": totalNoStaff,
        "attendance_details":
            attendanceDetails?.map((x) => x.toJson()).toList() ?? [],
      };
}

class AttendanceDetail {
  int? id;
  String? createdAt;
  String? updatedAt;
  String? createdBy;
  String? updatedBy;
  bool? isActive;
  int? siteConfigId;
  String? shiftName;
  String? shiftStartTime;
  String? shiftEndTime;
  int? noOfStaff;
  int? lastNoOfStaff;
  String? supervisor;
  bool? multidays;
  String? sTime;
  String? startTime;
  String? endTime;
  int? count;
  bool? current_time;
  List<EmployeeList>? employeeList;
  String? date;
  num? percentage;

  AttendanceDetail({
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
    this.lastNoOfStaff,
    this.supervisor,
    this.multidays,
    this.sTime,
    this.startTime,
    this.endTime,
    this.count,
    this.employeeList,
    this.date,
    this.percentage,
    this.current_time
  });
factory AttendanceDetail.fromJson(Map<String, dynamic> json) {
  print("============== SHIFT ==============");
  print(json["shift_name"]);

  print("employee_list type => ${json["employee_list"].runtimeType}");
  print("employee_list value => ${json["employee_list"]}");

  List<EmployeeList> employees = [];

  if (json["employee_list"] != null) {
    employees = (json["employee_list"] as List)
        .map((e) {
          print("EMPLOYEE => $e");
          return EmployeeList.fromJson(
            Map<String, dynamic>.from(e),
          );
        })
        .toList();
  }

  print("PARSED EMPLOYEE COUNT => ${employees.length}");

  return AttendanceDetail(
    id: json["id"],
    createdAt: json["createdAt"],
    updatedAt: json["updatedAt"],
    createdBy: json["createdBy"],
    updatedBy: json["updatedBy"],
    isActive: json["isActive"],
    siteConfigId: json["site_config_id"],
    shiftName: json["shift_name"],
    shiftStartTime: json["shift_start_time"],
    shiftEndTime: json["shift_end_time"],
    noOfStaff: json["no_of_staff"],
    lastNoOfStaff: json["last_no_of_staff"],
    supervisor: json["supervisor"],
    multidays: json["multidays"],
    sTime: json["s_time"],
    startTime: json["start_time"],
    endTime: json["end_time"],
    count: json["count"],
    employeeList: employees,
    date: json["Date"],
    percentage: json["percentage"],
    current_time:json['current_time']
  );
}
  // factory AttendanceDetail.fromJson(Map<String, dynamic> json) =>
  //     AttendanceDetail(
  //       id: json["id"],
  //       createdAt: json["createdAt"],
  //       updatedAt: json["updatedAt"],
  //       createdBy: json["createdBy"],
  //       updatedBy: json["updatedBy"],
  //       isActive: json["isActive"],
  //       siteConfigId: json["site_config_id"],
  //       shiftName: json["shift_name"],
  //       shiftStartTime: json["shift_start_time"],
  //       shiftEndTime: json["shift_end_time"],
  //       noOfStaff: json["no_of_staff"],
  //       lastNoOfStaff: json["last_no_of_staff"],
  //       supervisor: json["supervisor"],
  //       multidays: json["multidays"],
  //       sTime: json["s_time"],
  //       startTime: json["start_time"],
  //       endTime: json["end_time"],
  //       count: json["count"],
  //       employeeList: json["employee_list"] == null
  //           ? []
  //           : List<EmployeeList>.from(
  //               json["employee_list"].map(
  //                 (x) => EmployeeList.fromJson(x),
  //               ),
  //             ),
  //       date: json["Date"],
  //       percentage: json["percentage"],
  //     );

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
        "last_no_of_staff": lastNoOfStaff,
        "supervisor": supervisor,
        "multidays": multidays,
        "s_time": sTime,
        "start_time": startTime,
        "end_time": endTime,
        "count": count,
        'current_time':current_time,
        "employee_list":
            employeeList?.map((x) => x.toJson()).toList() ?? [],
        "Date": date,
        "percentage": percentage,
      };
}

class EmployeeList {
  int? id;
  String? name;
  String? contact;
  String? loginTime;
  int? janMarkId;

  EmployeeList({
    this.id,
    this.name,
    this.contact,
    this.loginTime,
    this.janMarkId,
  });

  factory EmployeeList.fromJson(Map<String, dynamic> json) => EmployeeList(
        id: json["id"],
        name: json["name"] ?? "",
        contact: json["contact"] ?? "",
        loginTime: json["login_time"] ?? "",
        janMarkId: json["jan_mark_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "contact": contact,
        "login_time": loginTime,
        "jan_mark_id": janMarkId,
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
// import 'dart:convert';

// AttendencelistResponse attendencelistResponseFromJson(String str) =>
//     AttendencelistResponse.fromJson(json.decode(str));

// String attendencelistResponseToJson(AttendencelistResponse data) =>
//     json.encode(data.toJson());

// class AttendencelistResponse {
//   int status;
//   String msg;
//   Data data;
//   List<GraphDatum> graphData;

//   AttendencelistResponse({
//     required this.status,
//     required this.msg,
//     required this.data,
//     required this.graphData,
//   });

//   factory AttendencelistResponse.fromJson(Map<String, dynamic> json) =>
//       AttendencelistResponse(
//         status: json["status"],
//         msg: json["msg"],
//         data: Data.fromJson(json["data"]),
//         graphData: List<GraphDatum>.from(
//           json["graph_data"].map((x) => GraphDatum.fromJson(x)),
//         ),
//       );

//   Map<String, dynamic> toJson() => {
//     "status": status,
//     "msg": msg,
//     "data": data.toJson(),
//     "graph_data": List<dynamic>.from(graphData.map((x) => x.toJson())),
//   };
// }

// class Data {
//   int id;
//   DateTime createdAt;
//   dynamic updatedAt;
//   dynamic createdBy;
//   dynamic updatedBy;
//   bool isActive;
//   dynamic siteConfigId;
//   String shiftName;
//   String shiftStartTime;
//   String shiftEndTime;
//   dynamic noOfStaff;
//   String supervisor;
//   String startTime;
//   String endTime;
//   dynamic clientId;
//   String clientName;
//   dynamic siteId;
//   String siteName;
//   dynamic count;
//   List<EmployeeList> employeeList;
//   String date;
//   dynamic percentage;
//   String clientSiteName;
//   bool lowattendance;

//   Data({
//     required this.id,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.createdBy,
//     required this.updatedBy,
//     required this.isActive,
//     required this.siteConfigId,
//     required this.shiftName,
//     required this.shiftStartTime,
//     required this.shiftEndTime,
//     required this.noOfStaff,
//     required this.supervisor,
//     required this.startTime,
//     required this.endTime,
//     required this.clientId,
//     required this.clientName,
//     required this.siteId,
//     required this.siteName,
//     required this.count,
//     required this.employeeList,
//     required this.date,
//     required this.percentage,
//     required this.clientSiteName,
//     required this.lowattendance,
//   });

//   factory Data.fromJson(Map<String, dynamic> json) => Data(
//     id: json["id"] ?? 0,

//     createdAt: json["createdAt"] != null
//         ? DateTime.tryParse(json["createdAt"].toString()) ?? DateTime.now()
//         : DateTime.now(),

//     updatedAt: json["updatedAt"],
//     createdBy: json["createdBy"],
//     updatedBy: json["updatedBy"],
//     isActive: json["isActive"] ?? false,
//     siteConfigId: json["site_config_id"],

//     shiftName: json["shift_name"] ?? "",
//     shiftStartTime: json["shift_start_time"] ?? "",
//     shiftEndTime: json["shift_end_time"] ?? "",
//     noOfStaff: json["no_of_staff"],

//     supervisor: json["supervisor"] ?? "",
//     startTime: json["start_time"] ?? "",
//     endTime: json["end_time"] ?? "",

//     clientId: json["client_id"],
//     clientName: json["client_name"] ?? "",
//     siteId: json["Site_id"],
//     siteName: json["site_name"] ?? "",
//     count: json["count"],

//     employeeList: json["employee_list"] == null
//         ? []
//         : List<EmployeeList>.from(
//             json["employee_list"].map((x) => EmployeeList.fromJson(x)),
//           ),

//     date: json["Date"]?.toString() ?? "",
//     percentage: json["percentage"],
//     clientSiteName: json["client_site_name"] ?? "",
//     lowattendance: json["lowattendance"] ?? false,
//   );

//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "createdAt": createdAt.toIso8601String(),
//     "updatedAt": updatedAt,
//     "createdBy": createdBy,
//     "updatedBy": updatedBy,
//     "isActive": isActive,
//     "site_config_id": siteConfigId,
//     "shift_name": shiftName,
//     "shift_start_time": shiftStartTime,
//     "shift_end_time": shiftEndTime,
//     "no_of_staff": noOfStaff,
//     "supervisor": supervisor,
//     "start_time": startTime,
//     "end_time": endTime,
//     "client_id": clientId,
//     "client_name": clientName,
//     "Site_id": siteId,
//     "site_name": siteName,
//     "count": count,
//     "employee_list": List<dynamic>.from(employeeList.map((x) => x.toJson())),
//     "Date": date,
//     "percentage": percentage,
//     "client_site_name": clientSiteName,
//     "lowattendance": lowattendance,
//   };
// }

// class EmployeeList {
//   int id;
//   String name;
//   String contact;
//   String loginTime;
//    int? janmarkid;

//   EmployeeList({
//     required this.id,
//     required this.name,
//     required this.contact,
//     required this.loginTime,
//      this.janmarkid
//   });

//   factory EmployeeList.fromJson(Map<String, dynamic> json) => EmployeeList(
//     id: json["id"]??0,
//     name: json["name"]??"",
//     contact: json["contact"]??"",
//     loginTime: json["login_time"]??"",
//      janmarkid: json['jan_mark_id'] ?? ""
//   );

//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "name": name,
//     "contact": contact,
//     "login_time": loginTime,
//     "janmarkid":janmarkid
//   };
// }

// class GraphDatum {
//   String month;
//   String monthname;
//   dynamic percentage;

//   GraphDatum({
//     required this.month,
//     required this.monthname,
//     required this.percentage,
//   });

//   factory GraphDatum.fromJson(Map<String, dynamic> json) => GraphDatum(
//     month: json["month"]??"",
//     monthname: json["monthname"]??"",
//     percentage: json["percentage"],
//   );

//   Map<String, dynamic> toJson() => {
//     "month": month,
//     "monthname": monthname,
//     "percentage": percentage,
//   };
// }
