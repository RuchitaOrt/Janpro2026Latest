// To parse this JSON data, do
//
//     final rejectAttendanceRooster = rejectAttendanceRoosterFromJson(jsonString);

import 'dart:convert';

RejectAttendanceRooster rejectAttendanceRoosterFromJson(String str) => RejectAttendanceRooster.fromJson(json.decode(str));

String rejectAttendanceRoosterToJson(RejectAttendanceRooster data) => json.encode(data.toJson());

class RejectAttendanceRooster {
    int status;
    String msg;
    Data data;

    RejectAttendanceRooster({
        required this.status,
        required this.msg,
        required this.data,
    });

    factory RejectAttendanceRooster.fromJson(Map<String, dynamic> json) => RejectAttendanceRooster(
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
