// To parse this JSON data, do
//
//     final unitclientMasterResponse = unitclientMasterResponseFromJson(jsonString);

import 'dart:convert';

UnitclientMasterResponse unitclientMasterResponseFromJson(String str) => UnitclientMasterResponse.fromJson(json.decode(str));

String unitclientMasterResponseToJson(UnitclientMasterResponse data) => json.encode(data.toJson());

class UnitclientMasterResponse {
    int status;
    String msg;
    List<Datum> data;

    UnitclientMasterResponse({
        required this.status,
        required this.msg,
        required this.data,
    });

    factory UnitclientMasterResponse.fromJson(Map<String, dynamic> json) => UnitclientMasterResponse(
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
    int clientId;
    String clientName;
    int siteId;

    Datum({
        required this.clientId,
        required this.clientName,
        required this.siteId,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        clientId: json["client_id"]??0,
        clientName: json["client_name "]??'',
        siteId: json["site_id"]??0,
    );

    Map<String, dynamic> toJson() => {
        "client_id": clientId,
        "client_name ": clientName,
        "site_id": siteId,
    };
}
