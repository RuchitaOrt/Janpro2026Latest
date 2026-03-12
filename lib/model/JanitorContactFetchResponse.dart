// To parse this JSON data, do
//
//     final janitorContactFetchResponse = janitorContactFetchResponseFromJson(jsonString);

import 'dart:convert';

JanitorContactFetchResponse janitorContactFetchResponseFromJson(String str) => JanitorContactFetchResponse.fromJson(json.decode(str));

String janitorContactFetchResponseToJson(JanitorContactFetchResponse data) => json.encode(data.toJson());

class JanitorContactFetchResponse {
    int status;
    String msg;
    List<Datum> data;

    JanitorContactFetchResponse({
        required this.status,
        required this.msg,
        required this.data,
    });

    factory JanitorContactFetchResponse.fromJson(Map<String, dynamic> json) => JanitorContactFetchResponse(
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
    int clientId;
    int siteId;
    bool actDeactJanitor;
    bool isActive;

    Datum({
        required this.id,
        required this.createdAt,
        required this.updatedAt,
        required this.createdBy,
        required this.updatedBy,
        required this.janName,
        required this.contact,
        required this.clientId,
        required this.siteId,
        required this.actDeactJanitor,
        required this.isActive,
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
        clientId: json["client_id"] ?? 0,
        siteId: json["site_id"] ?? 0,
        actDeactJanitor: json["act_deact_janitor"] ?? false,
        isActive: json["isActive"] ?? false,
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt,
        "createdBy": createdBy,
        "updatedBy": updatedBy,
        "jan_name": janName,
        "contact": contact,
        "client_id": clientId,
        "site_id": siteId,
        "act_deact_janitor": actDeactJanitor,
        "isActive": isActive,
    };
}
