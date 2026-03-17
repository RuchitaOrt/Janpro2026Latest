// To parse this JSON data, do
//
//     final addSpecialActivityResponse = addSpecialActivityResponseFromJson(jsonString);

import 'dart:convert';

AddSpecialActivityResponse addSpecialActivityResponseFromJson(String str) => AddSpecialActivityResponse.fromJson(json.decode(str));

String addSpecialActivityResponseToJson(AddSpecialActivityResponse data) => json.encode(data.toJson());

class AddSpecialActivityResponse {
    int status;
    String message;
    Data data;

    AddSpecialActivityResponse({
        required this.status,
        required this.message,
        required this.data,
    });

    factory AddSpecialActivityResponse.fromJson(Map<String, dynamic> json) => AddSpecialActivityResponse(
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
    int activityType;
    DateTime date;
    int client;
    int site;
    bool isActive;
    dynamic beforeImage1;
    dynamic beforeImage2;
    dynamic beforeImage3;
    dynamic afterImage1;
    dynamic afterImage2;
    dynamic afterImage3;

    Data({
        required this.id,
        required this.createdAt,
        required this.updatedAt,
        required this.createdBy,
        required this.updatedBy,
        required this.activityType,
        required this.date,
        required this.client,
        required this.site,
        required this.isActive,
        required this.beforeImage1,
        required this.beforeImage2,
        required this.beforeImage3,
        required this.afterImage1,
        required this.afterImage2,
        required this.afterImage3,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
id: json["id"] ?? 0,

        createdAt: json["createdAt"] != null
            ? DateTime.tryParse(json["createdAt"].toString()) ?? DateTime.now()
            : DateTime.now(),

        updatedAt: json["updatedAt"],
        createdBy: json["createdBy"],
        updatedBy: json["updatedBy"],

        activityType: json["activity_type"] is String
            ? int.tryParse(json["activity_type"]) ?? 0
            : json["activity_type"] ?? 0,

        date: json["date"] != null
            ? DateTime.tryParse(json["date"].toString()) ?? DateTime.now()
            : DateTime.now(),

        client: json["client"] ?? 0,
        site: json["site"] ?? 0,
        isActive: json["isActive"] ?? false,

        beforeImage1: json["before_image1"],
        beforeImage2: json["before_image2"],
        beforeImage3: json["before_image3"],

        afterImage1: json["after_image1"],
        afterImage2: json["after_image2"],
        afterImage3: json["after_image3"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt,
        "createdBy": createdBy,
        "updatedBy": updatedBy,
        "activity_type": activityType,
        "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "client": client,
        "site": site,
        "isActive": isActive,
        "before_image1": beforeImage1,
        "before_image2": beforeImage2,
        "before_image3": beforeImage3,
        "after_image1": afterImage1,
        "after_image2": afterImage2,
        "after_image3": afterImage3,
    };
}
