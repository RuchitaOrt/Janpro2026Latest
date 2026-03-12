// To parse this JSON data, do
//
//     final getComplaintResponse = getComplaintResponseFromJson(jsonString);

import 'dart:convert';

GetComplaintResponse getComplaintResponseFromJson(String str) =>
    GetComplaintResponse.fromJson(json.decode(str));

String getComplaintResponseToJson(GetComplaintResponse data) =>
    json.encode(data.toJson());

class GetComplaintResponse {
  int status;
  String message;
  List<DatumElement> data;

  GetComplaintResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory GetComplaintResponse.fromJson(Map<String, dynamic> json) =>
      GetComplaintResponse(
        status: json["status"] ?? 0,
        message: json["Message"] ?? "",
        data: json["data"] == null
            ? []
            : List<DatumElement>.from(
                json["data"].map((x) => DatumElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "Message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class DatumElement {
  List<DependentdatumElement> pendingdata;
  List<DependentdatumElement> dependentdata;
  List<DependentdatumElement> resolvedata;

  DatumElement({
    required this.pendingdata,
    required this.dependentdata,
    required this.resolvedata,
  });

  factory DatumElement.fromJson(Map<String, dynamic> json) => DatumElement(
        pendingdata: json["pendingdata"] == null
            ? []
            : List<DependentdatumElement>.from(json["pendingdata"]
                .map((x) => DependentdatumElement.fromJson(x))),
        dependentdata: json["dependentdata"] == null
            ? []
            : List<DependentdatumElement>.from(json["dependentdata"]
                .map((x) => DependentdatumElement.fromJson(x))),
        resolvedata: json["resolvedata"] == null
            ? []
            : List<DependentdatumElement>.from(json["resolvedata"]
                .map((x) => DependentdatumElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "pendingdata":
            List<dynamic>.from(pendingdata.map((x) => x.toJson())),
        "dependentdata":
            List<dynamic>.from(dependentdata.map((x) => x.toJson())),
        "resolvedata":
            List<dynamic>.from(resolvedata.map((x) => x.toJson())),
      };
}

class DependentdatumElement {
  int id;
  DateTime createdAt;
  dynamic updatedAt;
  dynamic createdBy;
  String? updatedBy;
  bool isActive;
  dynamic complainantName;
  int complaintType;
  dynamic client;
  dynamic site;
  String status;
  String image1;
  String image2;
  String close_img1;
  String close_img2;
  dynamic image3;
  dynamic comment;
  String tatDuration;
  int masterArea;
  int masterBlock;
  String date;
  dynamic masterAreaName;
  dynamic masterBlockName;
  int statusId;
  String loggedAt;
  dynamic turnAroundTime;
  dynamic tatDate;
  dynamic TAT_remark;

  DependentdatumElement({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.updatedBy,
    required this.isActive,
    required this.complainantName,
    required this.complaintType,
    required this.client,
    required this.site,
    required this.status,
    required this.image1,
    required this.image2,
    required this.image3,
    required this.comment,
    required this.tatDuration,
    required this.masterArea,
    required this.masterBlock,
    required this.date,
    required this.masterAreaName,
    required this.masterBlockName,
    required this.statusId,
    required this.loggedAt,
    required this.turnAroundTime,
    required this.tatDate,
    required this.TAT_remark,
    required this.close_img1,
    required this.close_img2,
  });

  factory DependentdatumElement.fromJson(Map<String, dynamic> json) =>
      DependentdatumElement(
        id: json["id"] ?? 0,

        createdAt: json["createdAt"] != null
            ? DateTime.tryParse(json["createdAt"]) ?? DateTime.now()
            : DateTime.now(),

        updatedAt: json["updatedAt"],
        createdBy: json["createdBy"],
        updatedBy: json["updatedBy"],
        isActive: json["isActive"] ?? false,

        complainantName: json["complainant_name"] ?? "",
        complaintType: json["complaint_type"] ?? 0,
        client: json["client"] ?? "",
        site: json["site"] ?? "",
        status: json["status"] ?? "",

        image1: json["image1"] ?? "",
        image2: json["image2"] ?? "",
        image3: json["image3"] ?? "",
        close_img1:json["close_img1"],
         close_img2: json["close_img2"],

        comment: json["comment"] ?? "",
        tatDuration: json["TAT_duration"] ?? "",

        masterArea: json["master_area"] ?? 0,
        masterBlock: json["master_block"] ?? 0,

        date: json["date"] ?? "",
        masterAreaName: json["master_area_name"] ?? "",
        masterBlockName: json["master_block_name"] ?? "",

        statusId: json["status_id"] ?? 0,
        loggedAt: json["logged_at"] ?? "",

        turnAroundTime: json["turn_around_time"],
        tatDate: json["TAT_date"],
        TAT_remark: json["TAT_remark"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt,
        "createdBy": createdBy,
        "updatedBy": updatedBy,
        "isActive": isActive,
        "complainant_name": complainantName,
        "complaint_type": complaintType,
        "client": client,
        "site": site,
        "status": status,
        "image1": image1,
        "image2": image2,
        "image3": image3,
        "comment": comment,
        "TAT_duration": tatDuration,
        "master_area": masterArea,
        "master_block": masterBlock,
        "date": date,
        "master_area_name": masterAreaName,
        "master_block_name": masterBlockName,
        "status_id": statusId,
        "logged_at": loggedAt,
        "turn_around_time": turnAroundTime,
        "TAT_date": tatDate,
        "TAT_remark": TAT_remark,
      };
}
