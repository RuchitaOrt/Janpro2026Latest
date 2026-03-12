// To parse this JSON data, do
//
//     final approvAttendanceRooster = approvAttendanceRoosterFromJson(jsonString);

import 'dart:convert';

ApprovAttendanceRooster approvAttendanceRoosterFromJson(String str) => ApprovAttendanceRooster.fromJson(json.decode(str));

String approvAttendanceRoosterToJson(ApprovAttendanceRooster data) => json.encode(data.toJson());

class ApprovAttendanceRooster {
    int status;
    String msg;
    Data data;

    ApprovAttendanceRooster({
        required this.status,
        required this.msg,
        required this.data,
    });

    factory ApprovAttendanceRooster.fromJson(Map<String, dynamic> json) => ApprovAttendanceRooster(
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
