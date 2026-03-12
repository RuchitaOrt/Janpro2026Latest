// To parse this JSON data, do
//
//     final janitorslistResponse = janitorslistResponseFromJson(jsonString);

import 'dart:convert';

JanitorslistResponse janitorslistResponseFromJson(String str) => JanitorslistResponse.fromJson(json.decode(str));

String janitorslistResponseToJson(JanitorslistResponse data) => json.encode(data.toJson());

class JanitorslistResponse {
    int status;
    String msg;
    List<Datum> data;

    JanitorslistResponse({
        required this.status,
        required this.msg,
        required this.data,
    });

    factory JanitorslistResponse.fromJson(Map<String, dynamic> json) => JanitorslistResponse(
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
    String janName;
    String contact;
    bool isActive;
    int clientId;
    int siteId;

    Datum({
        required this.id,
        required this.createdAt,
        required this.updatedAt,
        required this.createdBy,
        required this.updatedBy,
        required this.janName,
        required this.contact,
        required this.isActive,
        required this.clientId,
        required this.siteId,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
           id: json["id"] ?? 0,
        createdAt: json["createdAt"] != null
            ? DateTime.tryParse(json["createdAt"]) ?? DateTime.now()
            : DateTime.now(),
        updatedAt: json["updatedAt"],
        createdBy: json["createdBy"],
        updatedBy: json["updatedBy"],
        janName: json["jan_name"] ?? "",
        contact: json["contact"] ?? "",
        isActive: json["isActive"] ?? false,
        clientId: json["client_id"] ?? 0,
        siteId: json["site_id"] ?? 0,
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt,
        "createdBy": createdBy,
        "updatedBy": updatedBy,
        "jan_name": janName,
        "contact": contact,
        "isActive": isActive,
        "client_id": clientId,
        "site_id": siteId,
    };
}

