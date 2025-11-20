// To parse this JSON data, do
//
//     final addAttendanceResponse = addAttendanceResponseFromJson(jsonString);

import 'dart:convert';

AddAttendanceResponse addAttendanceResponseFromJson(String str) => AddAttendanceResponse.fromJson(json.decode(str));

String addAttendanceResponseToJson(AddAttendanceResponse data) => json.encode(data.toJson());

class AddAttendanceResponse {
    int status;
    String msg;
    Data data;

    AddAttendanceResponse({
        required this.status,
        required this.msg,
        required this.data,
    });

    factory AddAttendanceResponse.fromJson(Map<String, dynamic> json) => AddAttendanceResponse(
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
    int id;
    DateTime createdAt;
    dynamic updatedAt;
    dynamic createdBy;
    dynamic updatedBy;
    String name;
    String contact;
    int clientId;
    int siteId;
    DateTime date;
    String time;
    dynamic latitude;
    dynamic longitude;
    bool isActive;

    Data({
        required this.id,
        required this.createdAt,
        this.updatedAt,
        this.createdBy,
        this.updatedBy,
        required this.name,
        required this.contact,
        required this.clientId,
        required this.siteId,
        required this.date,
        required this.time,
        this.latitude,
        this.longitude,
        required this.isActive,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"],
        createdBy: json["createdBy"],
        updatedBy: json["updatedBy"],
        name: json["name"]??"",
        contact: json["contact"]??"",
        clientId: json["client_id"]??0,
        siteId: json["site_id"]??0,
        date: DateTime.parse(json["date"]),
        time: json["time"]??"",
        latitude: json["latitude"],
        longitude: json["longitude"],
        isActive: json["isActive"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt,
        "createdBy": createdBy,
        "updatedBy": updatedBy,
        "name": name,
        "contact": contact,
        "client_id": clientId,
        "site_id": siteId,
        "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "time": time,
        "latitude": latitude,
        "longitude": longitude,
        "isActive": isActive,
    };
}
