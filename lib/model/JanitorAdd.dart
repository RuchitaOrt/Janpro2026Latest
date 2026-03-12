// To parse this JSON data, do
//
//     final janitorAdd = janitorAddFromJson(jsonString);

import 'dart:convert';

JanitorAdd janitorAddFromJson(String str) => JanitorAdd.fromJson(json.decode(str));

String janitorAddToJson(JanitorAdd data) => json.encode(data.toJson());

class JanitorAdd {
    int status;
    String msg;
    Data data;

    JanitorAdd({
        required this.status,
        required this.msg,
        required this.data,
    });

    factory JanitorAdd.fromJson(Map<String, dynamic> json) => JanitorAdd(
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
    int clientId;
    int siteId;
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
        clientId: json["client_id"] ?? 0,
        siteId: json["site_id"] ?? 0,
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
