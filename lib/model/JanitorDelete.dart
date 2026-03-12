// To parse this JSON data, do
//
//     final janitorDelete = janitorDeleteFromJson(jsonString);

import 'dart:convert';

JanitorDelete janitorDeleteFromJson(String str) => JanitorDelete.fromJson(json.decode(str));

String janitorDeleteToJson(JanitorDelete data) => json.encode(data.toJson());

class JanitorDelete {
    int status;
    String msg;
    Data data;

    JanitorDelete({
        required this.status,
        required this.msg,
        required this.data,
    });

    factory JanitorDelete.fromJson(Map<String, dynamic> json) => JanitorDelete(
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
