// To parse this JSON data, do
//
//     final addratingResponse = addratingResponseFromJson(jsonString);

import 'dart:convert';

AddratingResponse addratingResponseFromJson(String str) => AddratingResponse.fromJson(json.decode(str));

String addratingResponseToJson(AddratingResponse data) => json.encode(data.toJson());

class AddratingResponse {
    int status;
    String msg;
    Data data;

    AddratingResponse({
        required this.status,
        required this.msg,
        required this.data,
    });

    factory AddratingResponse.fromJson(Map<String, dynamic> json) => AddratingResponse(
        status: json["status"],
        msg: json["Message"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "Message": msg,
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
    int siteId;
    int clientId;
    int overallRating;

    Data({
        required this.id,
        required this.createdAt,
        required this.updatedAt,
        required this.createdBy,
        required this.updatedBy,
        required this.isActive,
        required this.siteId,
        required this.clientId,
        required this.overallRating,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"]??0,
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"],
        createdBy: json["createdBy"],
        updatedBy: json["updatedBy"],
        isActive: json["isActive"]??false,
        siteId: json["site_id"]??0,
        clientId: json["client_id"]??0,
        overallRating: json["overall_rating"]??0,
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt,
        "createdBy": createdBy,
        "updatedBy": updatedBy,
        "isActive": isActive,
        "site_id": siteId,
        "client_id": clientId,
        "overall_rating": overallRating,
    };
}
