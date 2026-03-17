// To parse this JSON data, do
//
//     final ratinglistResponse = ratinglistResponseFromJson(jsonString);

import 'dart:convert';

RatinglistResponse ratinglistResponseFromJson(String str) => RatinglistResponse.fromJson(json.decode(str));

String ratinglistResponseToJson(RatinglistResponse data) => json.encode(data.toJson());

class RatinglistResponse {
    int status;
    String msg;
    List<Datum> data;

    RatinglistResponse({
        required this.status,
        required this.msg,
        required this.data,
    });

    factory RatinglistResponse.fromJson(Map<String, dynamic> json) => RatinglistResponse(
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
    int clientId;
    int siteId;
    String clientName;
    String review;
    List<MasterArea> masterArea;
    dynamic overallRating;
    dynamic status;
    dynamic pendingstatus;


    Datum({
        required this.clientId,
        required this.siteId,
        required this.clientName,
        required this.masterArea,
        required this.overallRating,
        required this.status,
        required this.pendingstatus,
        required this.review,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        clientId: json["client_id"]??0,
        siteId: json["site_id"]??0,
        clientName: json["client_name "]??"",
        masterArea: List<MasterArea>.from(json["master_area"].map((x) => MasterArea.fromJson(x))),
        overallRating: json["overall_rating"],
        status: json["status"],
         pendingstatus: json["pendingstatus"],
        review: json["review"]??"",
    );

    Map<String, dynamic> toJson() => {
        "client_id": clientId,
        "site_id": siteId,
        "client_name ": clientName,
        "master_area": List<dynamic>.from(masterArea.map((x) => x.toJson())),
        "overall_rating": overallRating,
        "status": status,
        "pendingstatus": pendingstatus,
        "review": review,
    };
}

class MasterArea {
    int id;
    DateTime createdAt;
    dynamic updatedAt;
    dynamic createdBy;
    dynamic updatedBy;
    bool isActive;
    dynamic clientWiseCheckListId;
    String startTime;
    String endTime;
    dynamic masterArea;
    dynamic masterBlock;
    dynamic shift;
    String? masterAreaName;
    List<MasterArea>? blockData;
    String? masterBlockName;
    dynamic? rating;

    MasterArea({
        required this.id,
        required this.createdAt,
        required this.updatedAt,
        required this.createdBy,
        required this.updatedBy,
        required this.isActive,
        required this.clientWiseCheckListId,
        required this.startTime,
        required this.endTime,
        required this.masterArea,
        required this.masterBlock,
        required this.shift,
        this.masterAreaName,
        this.blockData,
        this.masterBlockName,
        this.rating,
    });

    factory MasterArea.fromJson(Map<String, dynamic> json) => MasterArea(
        id: json["id"] ?? 0,
        createdAt: DateTime.parse(json["createdAt"]),
          
        updatedAt: json["updatedAt"],
        createdBy: json["createdBy"],
        updatedBy: json["updatedBy"],
        isActive: json["isActive"] ?? false,
        clientWiseCheckListId: json["ClientWiseCheckList_id"],
        startTime: json["start_time"] ?? "",
        endTime: json["end_time"] ?? "",
        masterArea: json["master_area"],
        masterBlock: json["master_block"],
        shift: json["Shift"],
        masterAreaName: json["master_area_name"],
        blockData: json["block_data"] != null
            ? List<MasterArea>.from(
                json["block_data"].map((x) => MasterArea.fromJson(x)))
            : [],
        masterBlockName: json["master_block_name"],
        rating: json["rating"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt,
        "createdBy": createdBy,
        "updatedBy": updatedBy,
        "isActive": isActive,
        "ClientWiseCheckList_id": clientWiseCheckListId,
        "start_time": startTime,
        "end_time": endTime,
        "master_area": masterArea,
        "master_block": masterBlock,
        "Shift": shift,
        "master_area_name": masterAreaName,
        "block_data": blockData == null ? [] : List<dynamic>.from(blockData!.map((x) => x.toJson())),
        "master_block_name": masterBlockName,
        "rating": rating,
    };
}
