// To parse this JSON data, do
//
//     final submitAttendanceRooster = submitAttendanceRoosterFromJson(jsonString);

import 'dart:convert';

SubmitAttendanceRooster submitAttendanceRoosterFromJson(String str) => SubmitAttendanceRooster.fromJson(json.decode(str));

String submitAttendanceRoosterToJson(SubmitAttendanceRooster data) => json.encode(data.toJson());

class SubmitAttendanceRooster {
    int status;
    String msg;
    Data data;

    SubmitAttendanceRooster({
        required this.status,
        required this.msg,
        required this.data,
    });

    factory SubmitAttendanceRooster.fromJson(Map<String, dynamic> json) => SubmitAttendanceRooster(
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
    Data();

    factory Data.fromJson(Map<String, dynamic> json) => Data(
    );

    Map<String, dynamic> toJson() => {
    };
}
