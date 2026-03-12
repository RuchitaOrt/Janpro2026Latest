// To parse this JSON data, do
//
//     final updatedworkflowResponse = updatedworkflowResponseFromJson(jsonString);

import 'dart:convert';

UpdatedworkflowResponse updatedworkflowResponseFromJson(String str) => UpdatedworkflowResponse.fromJson(json.decode(str));

String updatedworkflowResponseToJson(UpdatedworkflowResponse data) => json.encode(data.toJson());

class UpdatedworkflowResponse {
    int status;
    String msg;
    Data data;

    UpdatedworkflowResponse({
        required this.status,
        required this.msg,
        required this.data,
    });

    factory UpdatedworkflowResponse.fromJson(Map<String, dynamic> json) => UpdatedworkflowResponse(
        status: json["status"],
        msg: json["msg"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
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
    DateTime date;
    int shiftId;
    int masterAreaId;
    int masterBlockId;
    List<int> checkListId;

    Data({
        required this.id,
        required this.createdAt,
        this.updatedAt,
        this.createdBy,
        this.updatedBy,
        required this.isActive,
        required this.date,
        required this.shiftId,
        required this.masterAreaId,
        required this.masterBlockId,
        required this.checkListId,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
       id: json["id"] ?? 0,
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"],
        createdBy: json["createdBy"],
        updatedBy: json["updatedBy"],
        isActive: json["isActive"] ?? false,
        date: DateTime.parse(json["date"]),
        shiftId: json["shift_id"] ?? 0,
        masterAreaId: json["master_area_id"] ?? 0,
        masterBlockId: json["master_block_id"] ?? 0,
        checkListId: json["check_list_id"] != null
            ? List<int>.from(json["check_list_id"].map((x) => x ?? 0))
            : [],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt,
        "createdBy": createdBy,
        "updatedBy": updatedBy,
        "isActive": isActive,
        "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "shift_id": shiftId,
        "master_area_id": masterAreaId,
        "master_block_id": masterBlockId,
        "check_list_id": List<dynamic>.from(checkListId.map((x) => x)),
    };
}
