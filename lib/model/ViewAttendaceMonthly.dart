// To parse this JSON data, do
//
//     final viewAttendaceMonthly = viewAttendaceMonthlyFromJson(jsonString);

import 'dart:convert';

ViewAttendaceMonthly viewAttendaceMonthlyFromJson(String str) => ViewAttendaceMonthly.fromJson(json.decode(str));

String viewAttendaceMonthlyToJson(ViewAttendaceMonthly data) => json.encode(data.toJson());

class ViewAttendaceMonthly {
    int status;
    String msg;
    List<Datum> data;
    int totalApprovedByClient;
    int totalApprovedByOeom;
    int totalCount;

    ViewAttendaceMonthly({
        required this.status,
        required this.msg,
        required this.data,
        required this.totalApprovedByClient,
        required this.totalApprovedByOeom,
        required this.totalCount,
    });

    factory ViewAttendaceMonthly.fromJson(Map<String, dynamic> json) => ViewAttendaceMonthly(
        status: json["status"],
        msg: json["msg"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        totalApprovedByClient: json["total_approved_by_client"],
        totalApprovedByOeom: json["total_approved_by_oeom"],
        totalCount: json["total_count"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "total_approved_by_client": totalApprovedByClient,
        "total_approved_by_oeom": totalApprovedByOeom,
        "total_count": totalCount,
    };
}

class Datum {
    DateTime date;
    List<Record> records;
    List<String> reasons;
    List<String?> omOeResson;

    Datum({
        required this.date,
        required this.records,
        required this.reasons,
        required this.omOeResson,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        date: DateTime.parse(json["date"]),
        records: List<Record>.from(json["records"].map((x) => Record.fromJson(x))),
        reasons: List<String>.from(json["reasons"].map((x) => x)),
        omOeResson: List<String?>.from(json["om_oe_resson"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "records": List<dynamic>.from(records.map((x) => x.toJson())),
        "reasons": List<dynamic>.from(reasons.map((x) => x)),
        "om_oe_resson": List<dynamic>.from(omOeResson.map((x) => x)),
    };
}

class Record {
    int id;
    DateTime createdAt;
    DateTime updatedAt;
    dynamic createdBy;
    String updatedBy;
    String name;
    String contact;
    int shift;
    int clientId;
    int siteId;
    DateTime date;
    String time;
    double latitude;
    double longitude;
    bool isActive;
    String reason;
    String? omOeApprovalStatus;
    dynamic approvedBy;
    DateTime? approvedAt;
    DateTime? rejectedAt;
    String? rejectedBy;
    String? omOeResson;
    String? clientApprovalStatus;
    DateTime? clientApprovedAt;
    DateTime? clientRejectedAt;
    bool isFinalSubmitted;
    String previousStatus;

    Record({
        required this.id,
        required this.createdAt,
        required this.updatedAt,
        required this.createdBy,
        required this.updatedBy,
        required this.name,
        required this.contact,
        required this.shift,
        required this.clientId,
        required this.siteId,
        required this.date,
        required this.time,
        required this.latitude,
        required this.longitude,
        required this.isActive,
        required this.reason,
        required this.omOeApprovalStatus,
        required this.approvedBy,
        required this.approvedAt,
        required this.rejectedAt,
        required this.rejectedBy,
        required this.omOeResson,
        required this.clientApprovalStatus,
        required this.clientApprovedAt,
        required this.clientRejectedAt,
        required this.isFinalSubmitted,
        required this.previousStatus,
    });

    factory Record.fromJson(Map<String, dynamic> json) => Record(
        id: json["id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        createdBy: json["createdBy"],
        updatedBy: json["updatedBy"],
        name: json["name"],
        contact: json["contact"],
        shift: json["shift"],
        clientId: json["client_id"],
        siteId: json["site_id"],
        date: DateTime.parse(json["date"]),
        time: json["time"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        isActive: json["isActive"],
        reason: json["reason"],
        omOeApprovalStatus: json["om_oe_approval_status"],
        approvedBy: json["approved_by"],
        approvedAt: json["approvedAt"] == null ? null : DateTime.parse(json["approvedAt"]),
        rejectedAt: json["rejectedAt"] == null ? null : DateTime.parse(json["rejectedAt"]),
        rejectedBy: json["rejected_by"],
        omOeResson: json["om_oe_resson"],
        clientApprovalStatus: json["client_approval_status"],
        clientApprovedAt: json["client_approvedAt"] == null ? null : DateTime.parse(json["client_approvedAt"]),
        clientRejectedAt: json["client_rejectedAt"] == null ? null : DateTime.parse(json["client_rejectedAt"]),
        isFinalSubmitted: json["is_final_submitted"],
        previousStatus: json["previous_status"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "createdBy": createdBy,
        "updatedBy": updatedBy,
        "name": name,
        "contact": contact,
        "shift": shift,
        "client_id": clientId,
        "site_id": siteId,
        "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "time": time,
        "latitude": latitude,
        "longitude": longitude,
        "isActive": isActive,
        "reason": reason,
        "om_oe_approval_status": omOeApprovalStatus,
        "approved_by": approvedBy,
        "approvedAt": approvedAt?.toIso8601String(),
        "rejectedAt": rejectedAt?.toIso8601String(),
        "rejected_by": rejectedBy,
        "om_oe_resson": omOeResson,
        "client_approval_status": clientApprovalStatus,
        "client_approvedAt": clientApprovedAt?.toIso8601String(),
        "client_rejectedAt": clientRejectedAt?.toIso8601String(),
        "is_final_submitted": isFinalSubmitted,
        "previous_status": previousStatus,
    };
}
