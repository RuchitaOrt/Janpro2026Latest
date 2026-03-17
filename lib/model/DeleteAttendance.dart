// To parse this JSON data, do
//
//     final deleteAttendance = deleteAttendanceFromJson(jsonString);

import 'dart:convert';

DeleteAttendance deleteAttendanceFromJson(String str) => DeleteAttendance.fromJson(json.decode(str));

String deleteAttendanceToJson(DeleteAttendance data) => json.encode(data.toJson());

class DeleteAttendance {
    int status;
    String message;
    Data data;

    DeleteAttendance({
        required this.status,
        required this.message,
        required this.data,
    });

    factory DeleteAttendance.fromJson(Map<String, dynamic> json) => DeleteAttendance(
        status: json["status"],
        message: json["Message"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "Message": message,
        "data": data.toJson(),
    };
}

class Data {
    Data();

    factory Data.fromJson(Map<String, dynamic> json) => Data(
    );

    Map<String, dynamic> toJson() => {
    };
}
