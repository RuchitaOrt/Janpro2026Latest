// // To parse this JSON data, do
//
//     final addDailyCountResponse = addDailyCountResponseFromJson(jsonString);

import 'dart:convert';

AddDailyCountResponse addDailyCountResponseFromJson(String str) => AddDailyCountResponse.fromJson(json.decode(str));

String addDailyCountResponseToJson(AddDailyCountResponse data) => json.encode(data.toJson());

class AddDailyCountResponse {
    int status;
    String message;
    List<dynamic> data;

    AddDailyCountResponse({
        required this.status,
        required this.message,
        required this.data,
    });

    factory AddDailyCountResponse.fromJson(Map<String, dynamic> json) => AddDailyCountResponse(
        status: json["status"],
        message: json["Message"],
        data: List<dynamic>.from(json["data"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "Message": message,
        "data": List<dynamic>.from(data.map((x) => x)),
    };
}
