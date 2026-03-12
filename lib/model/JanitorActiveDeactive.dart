// To parse this JSON data, do
//
//     final janitorActiveDeactive = janitorActiveDeactiveFromJson(jsonString);

import 'dart:convert';

JanitorActiveDeactive janitorActiveDeactiveFromJson(String str) => JanitorActiveDeactive.fromJson(json.decode(str));

String janitorActiveDeactiveToJson(JanitorActiveDeactive data) => json.encode(data.toJson());

class JanitorActiveDeactive {
    int status;
    String msg;
    Data data;

    JanitorActiveDeactive({
        required this.status,
        required this.msg,
        required this.data,
    });

    factory JanitorActiveDeactive.fromJson(Map<String, dynamic> json) => JanitorActiveDeactive(
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
