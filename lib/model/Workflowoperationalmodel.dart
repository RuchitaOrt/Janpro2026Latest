// To parse this JSON data, do
//
//     final workflowoperationalmodel = workflowoperationalmodelFromJson(jsonString);

import 'dart:convert';

Workflowoperationalmodel workflowoperationalmodelFromJson(String str) => Workflowoperationalmodel.fromJson(json.decode(str));

String workflowoperationalmodelToJson(Workflowoperationalmodel data) => json.encode(data.toJson());

class Workflowoperationalmodel {
    int status;
    String msg;
    List<Datum> data;

    Workflowoperationalmodel({
        required this.status,
        required this.msg,
        required this.data,
    });

    factory Workflowoperationalmodel.fromJson(Map<String, dynamic> json) => Workflowoperationalmodel(
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
    String clientName;
    int clientId;
    int siteId;
    int pendingstatus;

    Datum({
        required this.clientName,
        required this.clientId,
        required this.siteId,
        required this.pendingstatus,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        clientName: json["client_name"]??"",
        clientId: json["client_id"]??0,
        siteId: json["site_id"]??0,
        pendingstatus: json["pendingstatus"]??0,
    );

    Map<String, dynamic> toJson() => {
        "client_name": clientName,
        "client_id": clientId,
        "site_id": siteId,
        "pendingstatus": pendingstatus,
    };
}
