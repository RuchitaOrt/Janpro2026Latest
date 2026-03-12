// To parse this JSON data, do
//
//     final janitorDetials = janitorDetialsFromJson(jsonString);

import 'dart:convert';

JanitorDetials janitorDetialsFromJson(String str) => JanitorDetials.fromJson(json.decode(str));

String janitorDetialsToJson(JanitorDetials data) => json.encode(data.toJson());

class JanitorDetials {
    int status;
    String msg;
    List<Datum> data;

    JanitorDetials({
        required this.status,
        required this.msg,
        required this.data,
    });

    factory JanitorDetials.fromJson(Map<String, dynamic> json) => JanitorDetials(
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
    int? clientId;
    int? siteId;
    bool actDeactJanitor;
    String clientName;
    String siteName;


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
        required this.actDeactJanitor,
         required this.clientName,
        required this.siteName,
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
        clientId: json["client_id"],
        siteId: json["site_id"],
        actDeactJanitor: json["act_deact_janitor"] ?? false,
        clientName: json["client_name"] ?? "",
        siteName: json["site_name"] ?? "",
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
        "client_name": clientName,
        "site_name": siteName,
    };
}
