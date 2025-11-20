// To parse this JSON data, do
//
//     final unitComplaintResponse = unitComplaintResponseFromJson(jsonString);

import 'dart:convert';

UnitComplaintResponse unitComplaintResponseFromJson(String str) => UnitComplaintResponse.fromJson(json.decode(str));

String unitComplaintResponseToJson(UnitComplaintResponse data) => json.encode(data.toJson());

class UnitComplaintResponse {
    int status;
    String message;
    List<DatumElement> data;

    UnitComplaintResponse({
        required this.status,
        required this.message,
        required this.data,
    });

    factory UnitComplaintResponse.fromJson(Map<String, dynamic> json) => UnitComplaintResponse(
        status: json["status"],
        message: json["Message"]??"",
        data: List<DatumElement>.from(json["data"].map((x) => DatumElement.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "Message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class DatumElement {
    int clientId;
    int siteId;
    String clientName;
    String siteName;
    List<DependentdatumElement> pendingdata;
    List<DependentdatumElement> dependentdata;
    List<DependentdatumElement> resolvedata;

    DatumElement({
        required this.clientId,
        required this.siteId,
        required this.clientName,
        required this.siteName,
        required this.pendingdata,
        required this.dependentdata,
        required this.resolvedata,
    });

    factory DatumElement.fromJson(Map<String, dynamic> json) => DatumElement(
        clientId: json["client_id"]??0,
        siteId: json["site_id"]??0,
        clientName: json["client_name "]??"",
        siteName: json["site_name "]??"",
        pendingdata: List<DependentdatumElement>.from(json["pendingdata"].map((x) => DependentdatumElement.fromJson(x))),
        dependentdata: List<DependentdatumElement>.from(json["dependentdata"].map((x) => DependentdatumElement.fromJson(x))),
        resolvedata: List<DependentdatumElement>.from(json["resolvedata"].map((x) => DependentdatumElement.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "client_id": clientId,
        "site_id": siteId,
        "client_name ": clientName,
        "site_name ": siteName,
        "pendingdata": List<dynamic>.from(pendingdata.map((x) => x.toJson())),
        "dependentdata": List<dynamic>.from(dependentdata.map((x) => x.toJson())),
        "resolvedata": List<dynamic>.from(resolvedata.map((x) => x.toJson())),
    };
}

class DependentdatumElement {
    int id;
    DateTime createdAt;
    dynamic updatedAt;
    dynamic createdBy;
    dynamic updatedBy;
    bool isActive;
    String complainantName;
    int complaintType;
    String subject;
    String client;
    String site;
    String status;
    String image1;
    String image2;
    String image3;
    String comment;
    String tatDuration;
    int masterArea;
    int masterBlock;
    String closeImg1;
    String closeImg2;
    String date;
    String masterAreaName;
    String masterBlockName;
    String loggedAt;
    String turnAroundTime;
    dynamic tatDate;
    dynamic TAT_remark;
    List<TatLoggedData> tatLoggedData;
     List<TatRemarkDatum>? tatRemarkData;

    DependentdatumElement({
        required this.id,
        required this.createdAt,
        required this.updatedAt,
        required this.createdBy,
        required this.updatedBy,
        required this.isActive,
        required this.complainantName,
        required this.complaintType,
        required this.subject,
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
        required this.closeImg1,
        required this.closeImg2,
        required this.date,
        required this.masterAreaName,
        required this.masterBlockName,
        required this.loggedAt,
        required this.turnAroundTime,
        required this.tatDate,
        required this.TAT_remark,
        required this.tatLoggedData,
        this.tatRemarkData,

    });

    factory DependentdatumElement.fromJson(Map<String, dynamic> json) => DependentdatumElement(
        id: json["id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"]?? "",
        createdBy: json["createdBy"]?? "",
        updatedBy: json["updatedBy"]?? "",
        isActive: json["isActive"]?? "",
        complainantName: json["complainant_name"]??"",
        complaintType: json["complaint_type"]?? 0,
        subject: json["subject"]??"",
        client: json["client"]??"",
        site: json["site"]??"",
        status: json["status"]??"",
        image1: json["image1"]??"",
        image2: json["image2"]??"",
        image3: json["image3"]??"",
        comment: json["comment"]??"",
        tatDuration: json["TAT_duration"]?? "",
        masterArea: json["master_area"]?? 0,
        masterBlock: json["master_block"]?? 0,
        closeImg1: json["close_img1"]??"",
        closeImg2: json["close_img2"]??"",
        date: json["date"]?? "",
        masterAreaName: json["master_area_name"]?? "",
        masterBlockName: json["master_block_name"]?? "",
        loggedAt: json["logged_at"]?? "",
        turnAroundTime: json["turn_around_time"]?? "",
        tatDate: json["TAT_date"]?? "",
        TAT_remark: json["TAT_remark"]?? "",

        tatLoggedData: json["tat_logged_data"] != null
            ? List<TatLoggedData>.from(json["tat_logged_data"].map((x) => TatLoggedData.fromJson(x)))
            : [],
        tatRemarkData: json["TAT_remark_data"] == null ? [] : List<TatRemarkDatum>.from(json["TAT_remark_data"]!.map((x) => TatRemarkDatum.fromJson(x))),
      

    );

    Map<String?, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt,
        "createdBy": createdBy,
        "updatedBy": updatedBy,
        "isActive": isActive,
        "complainant_name": complainantName,
        "complaint_type": complaintType,
        "subject": subject,
        "client": client,
        "site": site,
        "status": status,
        "image1": image1,
        "image2": image2,
        "image3": image3,
        "comment": comment,
        "TAT_duration": tatDuration,
        "TAT_remark": TAT_remark,
        "master_area": masterArea,
        "master_block": masterBlock,
        "close_img1": closeImg1,
        "close_img2": closeImg2,
        "date": date,
        "master_area_name": masterAreaName,
        "master_block_name": masterBlockName,
        "logged_at": loggedAt,
        "turn_around_time": turnAroundTime,
        "tat_logged_data": List<dynamic>.from(tatLoggedData.map((x) => x.toJson())),
        "TAT_remark_data": tatRemarkData == null ? [] : List<dynamic>.from(tatRemarkData!.map((x) => x.toJson())),

    };
}

class TatLoggedData {
    final String? tatText;

    TatLoggedData({ this.tatText});

    factory TatLoggedData.fromJson(Map<String?, dynamic> json) => TatLoggedData(
        tatText: json["tat_text"] ?? "",
    );

    Map<String?, dynamic> toJson() => {
        "tat_text": tatText,
    };
}class TatRemarkDatum {
    String? tatRemarkText;

    TatRemarkDatum({
        this.tatRemarkText,
    });

    factory TatRemarkDatum.fromJson(Map<String, dynamic> json) => TatRemarkDatum(
        tatRemarkText: json["tat_remark_text"] ?? "",
    );

    Map<String?, dynamic> toJson() => {
        "tat_remark_text": tatRemarkText,
    };
}

