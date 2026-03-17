// To parse this JSON data, do
//
//     final activitylistResponse = activitylistResponseFromJson(jsonString);

import 'dart:convert';

ActivitylistResponse activitylistResponseFromJson(String str) => ActivitylistResponse.fromJson(json.decode(str));

String activitylistResponseToJson(ActivitylistResponse data) => json.encode(data.toJson());

class ActivitylistResponse {
    int status;
    String msg;
    List<Datum> data;

    ActivitylistResponse({
        required this.status,
        required this.msg,
        required this.data,
    });

    factory ActivitylistResponse.fromJson(Map<String, dynamic> json) => ActivitylistResponse(
        status: json["status"],
        msg: json["msg"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    int id;
    DateTime createdAt;
    dynamic updatedAt;
    dynamic createdBy;
    dynamic updatedBy;
    String name;
    bool isActive;

    Datum({
        required this.id,
        required this.createdAt,
        required this.updatedAt,
        required this.createdBy,
        required this.updatedBy,
        required this.name,
        required this.isActive,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"],
        createdBy: json["createdBy"],
        updatedBy: json["updatedBy"],
        name: json["name"]??"",
        isActive: json["isActive"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt,
        "createdBy": createdBy,
        "updatedBy": updatedBy,
        "name": name,
        "isActive": isActive,
    };
}
