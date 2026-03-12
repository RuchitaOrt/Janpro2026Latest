// To parse this JSON data, do
//
//     final fullDetailSpecialActivityResponse = fullDetailSpecialActivityResponseFromJson(jsonString);

import 'dart:convert';

FullDetailSpecialActivityResponse fullDetailSpecialActivityResponseFromJson(String str) => FullDetailSpecialActivityResponse.fromJson(json.decode(str));

String fullDetailSpecialActivityResponseToJson(FullDetailSpecialActivityResponse data) => json.encode(data.toJson());

class FullDetailSpecialActivityResponse {
    int status;
    String msg;
    List<Datum> data;

    FullDetailSpecialActivityResponse({
        required this.status,
        required this.msg,
        required this.data,
    });

    factory FullDetailSpecialActivityResponse.fromJson(Map<String, dynamic> json) => FullDetailSpecialActivityResponse(
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
    List<Detail> details;

    Datum({
        required this.clientName,
        required this.details,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        clientName: json["client_name"],
        details: List<Detail>.from(json["details"].map((x) => Detail.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "client_name": clientName,
        "details": List<dynamic>.from(details.map((x) => x.toJson())),
    };
}

class Detail {
    int id;
    DateTime createdAt;
    dynamic updatedAt;
    dynamic createdBy;
    dynamic updatedBy;
    String activityType;
    String date;
    String client;
    String site;
    bool isActive;
    String? beforeImage1;
    String? beforeImage2;
    String? beforeImage3;
    String? afterImage1;
    String? afterImage2;
    String? afterImage3;

    Detail({
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

    factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        id: json["id"]??0,
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"],
        createdBy: json["createdBy"],
        updatedBy: json["updatedBy"],
        activityType: json["activity_type"]??"",
        date: json["date"]??'',
        client: json["client"]??'',
        site: json["site"]??'',
        isActive: json["isActive"]??false,
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
        "date": date,
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
