// To parse this JSON data, do
//
//     final masterareaResponse = masterareaResponseFromJson(jsonString);

import 'dart:convert';

MasterareaResponse masterareaResponseFromJson(String str) => MasterareaResponse.fromJson(json.decode(str));

String masterareaResponseToJson(MasterareaResponse data) => json.encode(data.toJson());

class MasterareaResponse {
    int status;
    String msg;
    List<Datum> data;

    MasterareaResponse({
        required this.status,
        required this.msg,
        required this.data,
    });

    factory MasterareaResponse.fromJson(Map<String, dynamic> json) => MasterareaResponse(
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
    int areaId;
    String areaName;

    Datum({
        required this.id,
        required this.areaId,
        required this.areaName,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"]??0,
        areaId: json["area_id"]??0,
        areaName: json["area_name"]??"",
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "area_id": areaId,
        "area_name": areaName,
    };
}
