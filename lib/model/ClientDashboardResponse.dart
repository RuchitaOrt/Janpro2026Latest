// To parse this JSON data, do
//
//     final clientDashboardResponse = clientDashboardResponseFromJson(jsonString);

import 'dart:convert';

ClientDashboardResponse clientDashboardResponseFromJson(String str) =>
    ClientDashboardResponse.fromJson(json.decode(str));

String clientDashboardResponseToJson(ClientDashboardResponse data) =>
    json.encode(data.toJson());

class ClientDashboardResponse {
  int status;
  String msg;
  List<Datum> data;

  ClientDashboardResponse({
    required this.status,
    required this.msg,
    required this.data,
  });

  factory ClientDashboardResponse.fromJson(Map<String, dynamic> json) =>
      ClientDashboardResponse(
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
  dynamic trainingData;
  int totalNumberOfTraning;
  int status;
  String trainingDone;
  List<GraphDatum> graphData;

  Datum({
    required this.clientId,
    required this.siteId,
    required this.clientName,
    required this.trainingData,
    required this.totalNumberOfTraning,
    required this.status,
    required this.trainingDone,
    required this.graphData,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    clientId: json["client_id"] ?? 0,
    siteId: json["site_id"] ?? 0,
    clientName: json["client_name "] ?? "",
    trainingData: json["training_data"],
    totalNumberOfTraning: json["total_number_of_traning"] ?? 0,
    status: json["status"] ?? 0,
    trainingDone: json["training_done"] ?? "",
    graphData: json["graph_data"] == null
        ? []
        : List<GraphDatum>.from(
            json["graph_data"].map((x) => GraphDatum.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "client_id": clientId,
    "site_id": siteId,
    "client_name ": clientName,
    "training_data": trainingData,
    "total_number_of_traning": totalNumberOfTraning,
    "status": status,
    "training_done": trainingDone,
    "graph_data": List<dynamic>.from(graphData.map((x) => x.toJson())),
  };
}

class GraphDatum {
  String month;
  String monthname;
  int percentage;

  GraphDatum({
    required this.month,
    required this.monthname,
    required this.percentage,
  });

  factory GraphDatum.fromJson(Map<String, dynamic> json) => GraphDatum(
    month: json["month"] ?? "",
    monthname: json["monthname"] ?? "",
    percentage: json["percentage"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "month": month,
    "monthname": monthname,
    "percentage": percentage,
  };
}

class TrainingDataClass {
  int id;
  DateTime createdAt;
  dynamic updatedAt;
  dynamic createdBy;
  dynamic updatedBy;
  bool isActive;
  DateTime dateOfTraining;
  int clientName;
  int site;
  String? image;
  String? image2;
  List<int> trainingAgenda;

  TrainingDataClass({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.updatedBy,
    required this.isActive,
    required this.dateOfTraining,
    required this.clientName,
    required this.site,
    required this.image,
    required this.image2,
    required this.trainingAgenda,
  });

  factory TrainingDataClass.fromJson(Map<String, dynamic> json) =>
      TrainingDataClass(
        id: json["id"] ?? 0,
        createdAt: json["createdAt"] != null
            ? DateTime.parse(json["createdAt"])
            : DateTime.now(),
        updatedAt: json["updatedAt"],
        createdBy: json["createdBy"],
        updatedBy: json["updatedBy"],
        isActive: json["isActive"] ?? false,
        dateOfTraining: json["Date_of_Training"] != null
            ? DateTime.parse(json["Date_of_Training"])
            : DateTime.now(),
        clientName: json["Client_Name"] ?? 0,
        site: json["Site"] ?? 0,
        image: json["image"],
        image2: json["image2"],
        trainingAgenda: json["Training_Agenda"] == null
            ? []
            : List<int>.from(json["Training_Agenda"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt,
    "createdBy": createdBy,
    "updatedBy": updatedBy,
    "isActive": isActive,
    "Date_of_Training":
        "${dateOfTraining.year.toString().padLeft(4, '0')}-${dateOfTraining.month.toString().padLeft(2, '0')}-${dateOfTraining.day.toString().padLeft(2, '0')}",
    "Client_Name": clientName,
    "Site": site,
    "image": image,
    "image2": image2,
    "Training_Agenda": List<dynamic>.from(trainingAgenda.map((x) => x)),
  };
}
