// To parse this JSON data, do
//
//     final ticketllistResponse = ticketllistResponseFromJson(jsonString);

import 'dart:convert';

TicketllistResponse ticketllistResponseFromJson(String str) => TicketllistResponse.fromJson(json.decode(str));

String ticketllistResponseToJson(TicketllistResponse data) => json.encode(data.toJson());

class TicketllistResponse {
    int status;
    String message;
    List<Datum> data;

    TicketllistResponse({
        required this.status,
        required this.message,
        required this.data,
    });

    factory TicketllistResponse.fromJson(Map<String, dynamic> json) => TicketllistResponse(
        status: json["status"],
        message: json["Message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "Message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    int id;
    dynamic createdAt;
    dynamic updatedAt;
    dynamic createdBy;
    dynamic updatedBy;
    bool isActive;
    String name;

    Datum({
        required this.id,
        required this.createdAt,
        required this.updatedAt,
        required this.createdBy,
        required this.updatedBy,
        required this.isActive,
        required this.name,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"],
        createdBy: json["createdBy"],
        updatedBy: json["updatedBy"],
        isActive: json["isActive"]??false,
        name: json["name"]??'',
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt,
        "createdBy": createdBy,
        "updatedBy": updatedBy,
        "isActive": isActive,
        "name": name,
    };
}
