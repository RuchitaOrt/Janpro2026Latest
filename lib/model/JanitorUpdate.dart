// To parse this JSON data, do
//
//     final janitorUpdate = janitorUpdateFromJson(jsonString);

import 'dart:convert';

JanitorUpdate janitorUpdateFromJson(String str) => JanitorUpdate.fromJson(json.decode(str));

String janitorUpdateToJson(JanitorUpdate data) => json.encode(data.toJson());

class JanitorUpdate {
    int status;
    String msg;
    Data data;

    JanitorUpdate({
        required this.status,
        required this.msg,
        required this.data,
    });

    factory JanitorUpdate.fromJson(Map<String, dynamic> json) => JanitorUpdate(
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
    int id;
    DateTime createdAt;
    dynamic updatedAt;
    dynamic createdBy;
    dynamic updatedBy;
    String janName;
    String contact;
    bool isActive;
    dynamic clientId;
    dynamic siteId;
    bool actDeactJanitor;

    Data({
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
        required this.actDeactJanitor,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
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
        clientId: json["client_id"],
        siteId: json["site_id"],
        actDeactJanitor: json["act_deact_janitor"] ?? false,
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
        "act_deact_janitor": actDeactJanitor,
    };
}
