// To parse this JSON data, do
//
//     final operationVisitSubmit = operationVisitSubmitFromJson(jsonString);

import 'dart:convert';

OperationVisitSubmit operationVisitSubmitFromJson(String str) =>
    OperationVisitSubmit.fromJson(json.decode(str));

String operationVisitSubmitToJson(OperationVisitSubmit data) =>
    json.encode(data.toJson());

class OperationVisitSubmit {
  int? status;
  String? msg;
  Data? data;

  OperationVisitSubmit({
    this.status,
    this.msg,
    this.data,
  });

  factory OperationVisitSubmit.fromJson(Map<String, dynamic> json) =>
      OperationVisitSubmit(
        status: json["status"],
        msg: json["msg"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
        "data": data?.toJson(),
      };
}

class Data {
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
  dynamic supportingImage;

  Data({
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
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
       id: json["id"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.tryParse(json["createdAt"]),
        updatedAt: json["updatedAt"],
        createdBy: json["createdBy"],
        updatedBy: json["updatedBy"],
        isActive: json["isActive"] ?? false,
        clientId: json["client_id"]?.toString(),
        siteId: json["site_id"]?.toString(),
        date:
            json["date"] == null ? null : DateTime.tryParse(json["date"]),
        time: json["time"],
        visitRemarks: json["visit_remarks"],
        supportingImage: json["supporting_image"],
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
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "time": time,
        "visit_remarks": visitRemarks,
        "supporting_image": supportingImage,
      };
}
