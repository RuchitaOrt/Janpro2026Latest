// To parse this JSON data, do
//
//     final unitsiteMasterResponse = unitsiteMasterResponseFromJson(jsonString);

import 'dart:convert';

UnitsiteMasterResponse unitsiteMasterResponseFromJson(String str) =>
    UnitsiteMasterResponse.fromJson(json.decode(str));

String unitsiteMasterResponseToJson(UnitsiteMasterResponse data) =>
    json.encode(data.toJson());

class UnitsiteMasterResponse {
  String status;
  String msg;
  List<Datum> data;

  UnitsiteMasterResponse({
    required this.status,
    required this.msg,
    required this.data,
  });

  factory UnitsiteMasterResponse.fromJson(Map<String, dynamic> json) =>
      UnitsiteMasterResponse(
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
  int id;
  DateTime createdAt;
  dynamic updatedAt;
  dynamic createdBy;
  dynamic updatedBy;
  bool isActive;
  int clientId;
  String siteName;
  String siteLocation;
  String qrcodefile;
  double lat;
  double lng;

  Datum({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.updatedBy,
    required this.isActive,
    required this.clientId,
    required this.siteName,
    required this.siteLocation,
    required this.qrcodefile,
    required this.lat,
    required this.lng,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"] ?? 0,
    createdAt: json["createdAt"] != null && json["createdAt"] != ""
        ? DateTime.parse(json["createdAt"])
        : DateTime.fromMillisecondsSinceEpoch(0),

    updatedAt: json["updatedAt"],
    createdBy: json["createdBy"],
    updatedBy: json["updatedBy"],

    isActive: json["isActive"] ?? false,

    clientId: json["client_id"] ?? 0,
    siteName: json["site_name"] ?? "",
    siteLocation: json["site_location"] ?? "",
    qrcodefile: json["qrcodefile"] ?? "",
    lat: json["lat"]?.toDouble(),
    lng: json["lng"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt,
    "createdBy": createdBy,
    "updatedBy": updatedBy,
    "isActive": isActive,
    "client_id": clientId,
    "site_name": siteName,
    "site_location": siteLocation,
    "qrcodefile": qrcodefile,
    "lat": lat,
    "lng": lng,
  };
}
