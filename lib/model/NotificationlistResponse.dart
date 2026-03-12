// To parse this JSON data, do
//
//     final notificationlistResponse = notificationlistResponseFromJson(jsonString);

import 'dart:convert';

NotificationlistResponse notificationlistResponseFromJson(String str) => NotificationlistResponse.fromJson(json.decode(str));

String notificationlistResponseToJson(NotificationlistResponse data) => json.encode(data.toJson());

class NotificationlistResponse {
    int status;
    String message;
    List<Datum> data;

    NotificationlistResponse({
        required this.status,
        required this.message,
        required this.data,
    });

    factory NotificationlistResponse.fromJson(Map<String, dynamic> json) => NotificationlistResponse(
        status: json["status"],
        message: json["Message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "Message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    int id;
    DateTime createdAt;
    dynamic updatedAt;
    dynamic createdBy;
    dynamic updatedBy;
    bool isActive;
    String complainantName;
    dynamic complaintType;
    String client;
    String site;
    String status;
    String image1;
    String image2;
    String image3;
    String comment;
    String tatDuration;
    dynamic masterArea;
    dynamic masterBlock;
    String complaintNo;
    dynamic date;
    String masterAreaName;
    String masterBlockName;
    String loggedAt;
    String turnAroundTime;
    dynamic statusId;
    dynamic complaintstatus;

    Datum({
        required this.id,
        required this.createdAt,
        required this.updatedAt,
        required this.createdBy,
        required this.updatedBy,
        required this.isActive,
        required this.complainantName,
        required this.complaintType,
        required this.client,
        required this.site,
        required this.status,
        required this.image1,
        required this.image2,
        required this.image3,
        required this.comment,
        required this.tatDuration,
        required this.masterArea,
        required this.masterBlock,
        required this.complaintNo,
        required this.date,
        required this.masterAreaName,
        required this.masterBlockName,
        required this.loggedAt,
        required this.turnAroundTime,
        required this.statusId,
        required this.complaintstatus,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
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
        client: json["client"] ?? "",
        site: json["site"] ?? "",
        status: json["status"] ?? "",
        image1: json["image1"] ?? "",
        image2: json["image2"] ?? "",
        image3: json["image3"],
        comment: json["comment"] ?? "",
        tatDuration: json["TAT_duration"] ?? "",
        masterArea: json["master_area"],
        masterBlock: json["master_block"],
        complaintNo: json["complaint_no"] ?? "",
        date: json["date"],
        masterAreaName: json["master_area_name"] ?? "",
        masterBlockName: json["master_block_name"] ?? "",
        loggedAt: json["logged_at"] ?? "",
        turnAroundTime: json["turn_around_time"] ?? "",
        statusId: json["status_id"],
        complaintstatus: json["Complaint_status"],
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
        "client": client,
        "site": site,
        "status": status,
        "image1": image1,
        "image2": image2,
        "image3": image3,
        "comment": comment,
        "TAT_duration": tatDuration,
        "master_area": masterArea,
        "master_block": masterBlock,
        "complaint_no": complaintNo,
        "date": date,
        "master_area_name": masterAreaName,
        "master_block_name": masterBlockName,
        "logged_at": loggedAt,
        "turn_around_time": turnAroundTime,
        "status_id": statusId,
        "Complaint_status":complaintstatus,
    };
}
