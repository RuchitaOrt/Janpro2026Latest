// To parse this JSON data, do
//
//     final masterBlockResponse = masterBlockResponseFromJson(jsonString);

import 'dart:convert';

MasterBlockResponse masterBlockResponseFromJson(String str) => MasterBlockResponse.fromJson(json.decode(str));

String masterBlockResponseToJson(MasterBlockResponse data) => json.encode(data.toJson());

class MasterBlockResponse {
    int status;
    String msg;
    List<Datum> data;

    MasterBlockResponse({
        required this.status,
        required this.msg,
        required this.data,
    });

    factory MasterBlockResponse.fromJson(Map<String, dynamic> json) => MasterBlockResponse(
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
    int blockObj;
    String blockName;

    Datum({
        required this.id,
        required this.areaId,
        required this.areaName,
        required this.blockObj,
        required this.blockName,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"]??0,
        areaId: json["area_id"]??0,
        areaName: json["area_name"]??'',
        blockObj: json["block_obj"]??0,
        blockName: json["block_name"]??'',
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "area_id": areaId,
        "area_name": areaName,
        "block_obj": blockObj,
        "block_name": blockName,
    };
}
