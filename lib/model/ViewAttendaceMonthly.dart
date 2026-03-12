import 'dart:convert';

ViewAttendaceMonthly viewAttendaceMonthlyFromJson(String str) =>
    ViewAttendaceMonthly.fromJson(json.decode(str));

String viewAttendaceMonthlyToJson(ViewAttendaceMonthly data) =>
    json.encode(data.toJson());

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

  factory ViewAttendaceMonthly.fromJson(Map<String, dynamic> json) =>
      ViewAttendaceMonthly(
        status: json["status"] ?? 0,
        msg: json["msg"] ?? "",
        data: (json["data"] ?? [])
            .map<Datum>((x) => Datum.fromJson(x))
            .toList(),
        totalApprovedByClient: json["total_approved_by_client"] ?? 0,
        totalApprovedByOeom: json["total_approved_by_oeom"] ?? 0,
        totalCount: json["total_count"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
        "data": data.map((x) => x.toJson()).toList(),
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
        date: DateTime.tryParse(json["date"] ?? "") ?? DateTime.now(),
        records: (json["records"] ?? [])
            .map<Record>((x) => Record.fromJson(x))
            .toList(),
        reasons: (json["reasons"] ?? [])
            .where((e) => e != null)
            .map<String>((e) => e.toString())
            .toList(),
        omOeResson: (json["om_oe_resson"] ?? [])
            .map<String?>((e) => e?.toString())
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "records": records.map((x) => x.toJson()).toList(),
        "reasons": reasons,
        "om_oe_resson": omOeResson,
      };
}

class Record {
  int id;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic createdBy;
  String? updatedBy;
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
  String? rejectedBy;
  String? omOeResson;
  String? clientApprovalStatus;
  bool isFinalSubmitted;
  String? attendance_type;
  String? previousStatus;

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
    required this.rejectedBy,
    required this.omOeResson,
    required this.clientApprovalStatus,
    required this.isFinalSubmitted,
    required this.previousStatus,
    required this.attendance_type,
  });

  factory Record.fromJson(Map<String, dynamic> json) => Record(
        id: json["id"] ?? 0,
        createdAt:
            DateTime.tryParse(json["createdAt"] ?? "") ?? DateTime.now(),
        updatedAt:
            DateTime.tryParse(json["updatedAt"] ?? "") ?? DateTime.now(),
        createdBy: json["createdBy"],
        updatedBy: json["updatedBy"],
        name: json["name"] ?? "",
        contact: json["contact"] ?? "",
        shift: json["shift"] ?? 0,
        clientId: json["client_id"] ?? 0,
        siteId: json["site_id"] ?? 0,
        date: DateTime.tryParse(json["date"] ?? "") ?? DateTime.now(),
        time: json["time"] ?? "",
        latitude: (json["latitude"] ?? 0).toDouble(),
        longitude: (json["longitude"] ?? 0).toDouble(),
        isActive: json["isActive"] ?? false,
        reason: json["reason"] ?? "",
        omOeApprovalStatus: json["om_oe_approval_status"],
        approvedBy: json["approved_by"],
        rejectedBy: json["rejected_by"],
        omOeResson: json["om_oe_resson"],
        clientApprovalStatus: json["client_approval_status"],
        isFinalSubmitted: json["is_final_submitted"] ?? false,
        previousStatus: json["previous_status"],
        attendance_type:json['attendance_type']??""
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
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "time": time,
        "latitude": latitude,
        "longitude": longitude,
        "isActive": isActive,
        "reason": reason,
        "om_oe_approval_status": omOeApprovalStatus,
        "approved_by": approvedBy,
        "rejected_by": rejectedBy,
        "om_oe_resson": omOeResson,
        "client_approval_status": clientApprovalStatus,
        "is_final_submitted": isFinalSubmitted,
        "previous_status": previousStatus,
        "attendance_type":attendance_type
      };
}
