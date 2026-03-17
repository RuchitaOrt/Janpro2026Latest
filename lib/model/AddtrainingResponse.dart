// To parse this JSON data, do
//
//     final addtrainingResponse = addtrainingResponseFromJson(jsonString);

import 'dart:convert';

AddtrainingResponse addtrainingResponseFromJson(String str) => AddtrainingResponse.fromJson(json.decode(str));

String addtrainingResponseToJson(AddtrainingResponse data) => json.encode(data.toJson());

class AddtrainingResponse {
    int status;
    String message;
    Data data;

    AddtrainingResponse({
        required this.status,
        required this.message,
        required this.data,
    });

    factory AddtrainingResponse.fromJson(Map<String, dynamic> json) => AddtrainingResponse(
        status: json["status"],
        message: json["Message"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "Message": message,
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
    dynamic trainingAgenda;
    DateTime dateOfTraining;
    dynamic clientName;
    dynamic site;
    dynamic image;
    dynamic image2;

    Data({
        required this.id,
        required this.createdAt,
        required this.updatedAt,
        required this.createdBy,
        required this.updatedBy,
        required this.isActive,
        required this.trainingAgenda,
        required this.dateOfTraining,
        required this.clientName,
        required this.site,
        required this.image,
        required this.image2,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"],
        createdBy: json["createdBy"],
        updatedBy: json["updatedBy"],
        isActive: json["isActive"]??false,
        trainingAgenda: json["Training_Agenda"],
        dateOfTraining: DateTime.parse(json["Date_of_Training"]),
        clientName: json["Client_Name"],
        site: json["Site"],
        image: json["image"],
        image2: json["image2"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt,
        "createdBy": createdBy,
        "updatedBy": updatedBy,
        "isActive": isActive,
        "Training_Agenda": trainingAgenda,
        "Date_of_Training": "${dateOfTraining.year.toString().padLeft(4, '0')}-${dateOfTraining.month.toString().padLeft(2, '0')}-${dateOfTraining.day.toString().padLeft(2, '0')}",
        "Client_Name": clientName,
        "Site": site,
        "image": image,
        "image2": image2,
    };
}
