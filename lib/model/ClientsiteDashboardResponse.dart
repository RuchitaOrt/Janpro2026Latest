// To parse this JSON data, do
//
//     final clientsiteDashboardResponse = clientsiteDashboardResponseFromJson(jsonString);

import 'dart:convert';

ClientsiteDashboardResponse clientsiteDashboardResponseFromJson(String str) => ClientsiteDashboardResponse.fromJson(json.decode(str));

String clientsiteDashboardResponseToJson(ClientsiteDashboardResponse data) => json.encode(data.toJson());

class ClientsiteDashboardResponse {
    int status;
    String msg;
    List<Datum> data;

    ClientsiteDashboardResponse({
        required this.status,
        required this.msg,
        required this.data,
    });

    factory ClientsiteDashboardResponse.fromJson(Map<String, dynamic> json) => ClientsiteDashboardResponse(
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
    int clientId;
    String clientName;
    int siteId;

    Datum({
        required this.id,
        required this.clientId,
        required this.clientName,
        required this.siteId,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"]??0,
        clientId: json["client_id"]??0,
        clientName: json["client_name "]??"",
        siteId: json["site_id"]??0,
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "client_id": clientId,
        "client_name ": clientName,
        "site_id": siteId,
    };
}


// // To parse this JSON data, do
// //
// //     final clientsiteDashboardResponse = clientsiteDashboardResponseFromJson(jsonString);

// import 'dart:convert';

// ClientsiteDashboardResponse clientsiteDashboardResponseFromJson(String str) => ClientsiteDashboardResponse.fromJson(json.decode(str));

// String clientsiteDashboardResponseToJson(ClientsiteDashboardResponse data) => json.encode(data.toJson());

// class ClientsiteDashboardResponse {
//     String status;
//     String msg;
//     List<Datum> data;

//     ClientsiteDashboardResponse({
//         required this.status,
//         required this.msg,
//         required this.data,
//     });

//     factory ClientsiteDashboardResponse.fromJson(Map<String, dynamic> json) => ClientsiteDashboardResponse(
//         status: json["status"],
//         msg: json["msg"],
//         data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
//     );

//     Map<String, dynamic> toJson() => {
//         "status": status,
//         "msg": msg,
//         "data": List<dynamic>.from(data.map((x) => x.toJson())),
//     };
// }

// class Datum {
//     int id;
//     DateTime createdAt;
//     dynamic updatedAt;
//     dynamic createdBy;
//     dynamic updatedBy;
//     bool isActive;
//     dynamic clientId;
//     String siteName;
//     String siteLocation;
//     String qrcodefile;
//     double lat;
//     double lng;

//     Datum({
//         required this.id,
//         required this.createdAt,
//         required this.updatedAt,
//         required this.createdBy,
//         required this.updatedBy,
//         required this.isActive,
//         required this.clientId,
//         required this.siteName,
//         required this.siteLocation,
//         required this.qrcodefile,
//         required this.lat,
//         required this.lng,
//     });

//     factory Datum.fromJson(Map<String, dynamic> json) => Datum(
//         id: json["id"],
//         createdAt: DateTime.parse(json["createdAt"]),
//         updatedAt: json["updatedAt"],
//         createdBy: json["createdBy"],
//         updatedBy: json["updatedBy"],
//         isActive: json["isActive"],
//         clientId: json["client_id"],
//         siteName: json["site_name"],
//         siteLocation: json["site_location"],
//         qrcodefile: json["qrcodefile"],
//         lat: json["lat"]?.toDouble(),
//         lng: json["lng"]?.toDouble(),
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id,
//         "createdAt": createdAt.toIso8601String(),
//         "updatedAt": updatedAt,
//         "createdBy": createdBy,
//         "updatedBy": updatedBy,
//         "isActive": isActive,
//         "client_id": clientId,
//         "site_name": siteName,
//         "site_location": siteLocation,
//         "qrcodefile": qrcodefile,
//         "lat": lat,
//         "lng": lng,
//     };
// }
