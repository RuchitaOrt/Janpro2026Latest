// To parse this JSON data, do
//
//     final workflowlistResponse = workflowlistResponseFromJson(jsonString);

import 'dart:convert';

WorkflowlistResponse workflowlistResponseFromJson(String str) => WorkflowlistResponse.fromJson(json.decode(str));

String workflowlistResponseToJson(WorkflowlistResponse data) => json.encode(data.toJson());

class WorkflowlistResponse {
    int status;
    String msg;
    Data data;

    WorkflowlistResponse({
        required this.status,
        required this.msg,
        required this.data,
    });

    factory WorkflowlistResponse.fromJson(Map<String, dynamic> json) => WorkflowlistResponse(
        status: json["status"],
        msg: json["msg"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
        "data": data.toJson(),
    };
}

class Data {
    List<IngShift> ongoingShift;
    List<IngShift> upcomingShift;

    Data({
        required this.ongoingShift,
        required this.upcomingShift,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        ongoingShift: List<IngShift>.from(json["ongoing_shift"]==[]?[]:json["ongoing_shift"].map((x) => IngShift.fromJson(x))),
        upcomingShift: List<IngShift>.from(json["upcoming_shift"]==[]?[]:json["upcoming_shift"].map((x) => IngShift.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "ongoing_shift": List<dynamic>.from(ongoingShift.map((x) => x.toJson())),
        "upcoming_shift": List<dynamic>.from(upcomingShift.map((x) => x.toJson())),
    };
}

class IngShift {
    int id;
    DateTime createdAt;
    dynamic updatedAt;
    dynamic createdBy;
    dynamic updatedBy;
    bool isActive;
    int siteConfigId;
    String shiftName;
    String shiftStartTime;
    String shiftEndTime;
    int noOfStaff;
    String supervisor;
    String clientName;
    int clientId;
    int siteId;
    String siteName;
    String time;

    IngShift({
        required this.id,
        required this.createdAt,
        this.updatedAt,
        this.createdBy,
        this.updatedBy,
        required this.isActive,
        required this.siteConfigId,
        required this.shiftName,
        required this.shiftStartTime,
        required this.shiftEndTime,
        required this.noOfStaff,
        required this.supervisor,
        required this.clientName,
        required this.clientId,
        required this.siteId,
        required this.siteName,
        required this.time,
    });

    factory IngShift.fromJson(Map<String, dynamic> json) => IngShift(
         id: json["id"] ?? 0,
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"],
        createdBy: json["createdBy"],
        updatedBy: json["updatedBy"],
        isActive: json["isActive"] ?? false,
        siteConfigId: json["site_config_id"] ?? 0,
        shiftName: json["shift_name"] ?? "",
        shiftStartTime: json["shift_start_time"] ?? "",
        shiftEndTime: json["shift_end_time"] ?? "",
        noOfStaff: json["no_of_staff"] ?? 0,
        supervisor: json["supervisor"] ?? "",
        clientName: json["client_name"] ?? "",
        clientId: json["client_id"] ?? 0,
        siteId: json["Site_id"] ?? 0,
        siteName: json["site_name"] ?? "",
        time: json["time"] ?? "",
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
        "client_name": clientName,
        "client_id": clientId,
        "Site_id": siteId,
        "site_name": siteName,
        "time": time,
    };
}
