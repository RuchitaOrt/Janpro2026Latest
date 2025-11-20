// To parse this JSON data, do
//
//     final siteDropDown = siteDropDownFromJson(jsonString);

import 'dart:convert';

SiteDropDown siteDropDownFromJson(String str) =>
    SiteDropDown.fromJson(json.decode(str));

String siteDropDownToJson(SiteDropDown data) => json.encode(data.toJson());

class SiteDropDown {
  int? status;
  String? msg;
  List<Datum>? data;

  SiteDropDown({
    this.status,
    this.msg,
    this.data,
  });

  factory SiteDropDown.fromJson(Map<String, dynamic> json) => SiteDropDown(
        status: json["status"],
        msg: json["msg"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  String? clientName;
  int? clientId;
  int? siteId;
  int? pendingstatus;

  Datum({
    this.clientName,
    this.clientId,
    this.siteId,
    this.pendingstatus,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        clientName: json["client_name"]??'',
        clientId: json["client_id"]??0,
        siteId: json["site_id"]??0,
        pendingstatus: json["pendingstatus"]??0,
      );

  Map<String, dynamic> toJson() => {
        "client_name": clientName,
        "client_id": clientId,
        "site_id": siteId,
        "pendingstatus": pendingstatus,
      };
}
