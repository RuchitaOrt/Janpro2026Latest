// To parse this JSON data, do
//
//     final updateTatResponse = updateTatResponseFromJson(jsonString);

import 'dart:convert';

UpdateTatResponse updateTatResponseFromJson(String str) => UpdateTatResponse.fromJson(json.decode(str));

String updateTatResponseToJson(UpdateTatResponse data) => json.encode(data.toJson());

class UpdateTatResponse {
    int status;
    String message;
    Data data;

    UpdateTatResponse({
        required this.status,
        required this.message,
        required this.data,
    });

    factory UpdateTatResponse.fromJson(Map<String, dynamic> json) => UpdateTatResponse(
        status: json["status"],
        message: json["Message"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "Message": message,
        "data": data.toJson(),
    };
}

class Data {
    int id;
    DateTime createdAt;
    dynamic updatedAt;
    dynamic createdBy;
    dynamic updatedBy;
    bool isActive;
    String complainantName;
    int complaintType;
    String subject;
    int client;
    int site;
    String status;
    String image1;
    String image2;
    String image3;
    String comment;
    String tatDuration;
    int masterArea;
    int masterBlock;

    Data({
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
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"] ?? 0,
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"],
        createdBy: json["createdBy"],
        updatedBy: json["updatedBy"],
        isActive: json["isActive"] ?? false,
        complainantName: json["complainant_name"] ?? "",
        complaintType: json["complaint_type"] ?? 0,
        subject: json["subject"] ?? "",
        client: json["client"] ?? 0,
        site: json["site"] ?? 0,
        status: json["status"] ?? "",
        image1: json["image1"] ?? "",
        image2: json["image2"] ?? "",
        image3: json["image3"] ?? "",
        comment: json["comment"] ?? "",
        tatDuration: json["TAT_duration"] ?? "",
        masterArea: json["master_area"] ?? 0,
        masterBlock: json["master_block"] ?? 0,
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
        "subject": subject,
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
    };
}
