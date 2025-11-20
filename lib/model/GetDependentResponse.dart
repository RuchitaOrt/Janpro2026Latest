// To parse this JSON data, do
//
//     final getDependentResponse = getDependentResponseFromJson(jsonString);

import 'dart:convert';

GetDependentResponse getDependentResponseFromJson(String str) => GetDependentResponse.fromJson(json.decode(str));

String getDependentResponseToJson(GetDependentResponse data) => json.encode(data.toJson());

class GetDependentResponse {
    int status;
    String msg;
    Data data;

    GetDependentResponse({
        required this.status,
        required this.msg,
        required this.data,
    });

    factory GetDependentResponse.fromJson(Map<String, dynamic> json) => GetDependentResponse(
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
