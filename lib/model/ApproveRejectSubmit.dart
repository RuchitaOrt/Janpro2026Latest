// To parse this JSON data, do
//
//     final approveRejectSubmit = approveRejectSubmitFromJson(jsonString);

import 'dart:convert';

ApproveRejectSubmit approveRejectSubmitFromJson(String str) => ApproveRejectSubmit.fromJson(json.decode(str));

String approveRejectSubmitToJson(ApproveRejectSubmit data) => json.encode(data.toJson());

class ApproveRejectSubmit {
    int status;
    String msg;
    Data data;

    ApproveRejectSubmit({
        required this.status,
        required this.msg,
        required this.data,
    });

    factory ApproveRejectSubmit.fromJson(Map<String, dynamic> json) => ApproveRejectSubmit(
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
