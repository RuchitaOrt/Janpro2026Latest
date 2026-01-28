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
    Data();

    factory Data.fromJson(Map<String, dynamic> json) => Data(
    );

    Map<String, dynamic> toJson() => {
    };
}
