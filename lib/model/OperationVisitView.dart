// To parse this JSON data, do
//
//     final operationVisitView = operationVisitViewFromJson(jsonString);

import 'dart:convert';

OperationVisitView operationVisitViewFromJson(String str) => OperationVisitView.fromJson(json.decode(str));

String operationVisitViewToJson(OperationVisitView data) => json.encode(data.toJson());

class OperationVisitView {
    int? status;
    String? msg;
    List<Datum>? data;

    OperationVisitView({
        this.status,
        this.msg,
        this.data,
    });

    factory OperationVisitView.fromJson(Map<String, dynamic> json) => OperationVisitView(
        status: json["status"],
        msg: json["msg"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Datum {
    int? id;
    DateTime? createdAt;
    dynamic updatedAt;
    dynamic createdBy;
    dynamic updatedBy;
    bool? isActive;
    String? clientId;
    String? siteId;
    DateTime? date;
    String? time;
    String? visitRemarks;
    String? supportingImage;
    String? propose_remark;


    Datum({
        this.id,
        this.createdAt,
        this.updatedAt,
        this.createdBy,
        this.updatedBy,
        this.isActive,
        this.clientId,
        this.siteId,
        this.date,
        this.time,
        this.visitRemarks,
        this.supportingImage,
        this.propose_remark,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
       id: json["id"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.tryParse(json["createdAt"]),
        updatedAt: json["updatedAt"],
        createdBy: json["createdBy"],
        updatedBy: json["updatedBy"],
        isActive: json["isActive"],
        clientId: json["client_id"]??'',
        siteId: json["site_id"]??'',
        date:
            json["date"] == null ? null : DateTime.tryParse(json["date"]),
        time: json["time"]??"",
        visitRemarks: json["visit_remarks"]??"",
        supportingImage: json["supporting_image"]??"",
        propose_remark: json['propose_remark']??"",

    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt,
        "createdBy": createdBy,
        "updatedBy": updatedBy,
        "isActive": isActive,
        "client_id": clientId,
        "site_id": siteId,
        "date": "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "time": time,
        "visit_remarks": visitRemarks,
        "supporting_image": supportingImage,
        'propose_remark':propose_remark
    };
}
