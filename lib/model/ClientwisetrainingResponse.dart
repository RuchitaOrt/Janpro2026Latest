import 'dart:convert';

ClientwisetrainingResponse clientwisetrainingResponseFromJson(String str) =>
    ClientwisetrainingResponse.fromJson(json.decode(str));

String clientwisetrainingResponseToJson(ClientwisetrainingResponse data) =>
    json.encode(data.toJson());

class ClientwisetrainingResponse {
  int status;
  String msg;
  List<Datum> data;

  ClientwisetrainingResponse({
    required this.status,
    required this.msg,
    required this.data,
  });

  factory ClientwisetrainingResponse.fromJson(Map<String, dynamic> json) =>
      ClientwisetrainingResponse(
        status: json["status"],
        msg: json["msg"],
        data: json["data"] != null
            ? List<Datum>.from(json["data"].map((x) => Datum.fromJson(x)))
            : [],
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
  List<TrainingDatum> trainingData;
  dynamic totalNumberOfTraning;
  dynamic status;
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
        clientId: json["client_id"],
        siteId: json["site_id"],
        clientName: json["client_name "] ?? "",
        trainingData: json["training_data"] != null
            ? List<TrainingDatum>.from(
                json["training_data"].map((x) => TrainingDatum.fromJson(x)))
            : [],
        totalNumberOfTraning: json["total_number_of_traning"],
        status: json["status"],
        trainingDone: json["training_done"] ?? "",
        graphData: json["graph_data"] != null
            ? List<GraphDatum>.from(
                json["graph_data"].map((x) => GraphDatum.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "client_id": clientId,
        "site_id": siteId,
        "client_name ": clientName,
        "training_data":
            List<dynamic>.from(trainingData.map((x) => x.toJson())),
        "total_number_of_traning": totalNumberOfTraning,
        "status": status,
        "training_done": trainingDone,
        "graph_data": List<dynamic>.from(graphData.map((x) => x.toJson())),
      };
}

class GraphDatum {
  String month;
  String monthname;
  dynamic percentage;

  GraphDatum({
    required this.month,
    required this.monthname,
    required this.percentage,
  });

  factory GraphDatum.fromJson(Map<String, dynamic> json) => GraphDatum(
        month: json["month"] ?? "",
        monthname: json["monthname"] ?? "",
        percentage: json["percentage"],
      );

  Map<String, dynamic> toJson() => {
        "month": month,
        "monthname": monthname,
        "percentage": percentage,
      };
}

class TrainingDatum {
  int id;
  DateTime createdAt;
  dynamic updatedAt;
  dynamic createdBy;
  dynamic updatedBy;
  bool isActive;
  String trainingDatumDateOfTraining;
  dynamic clientName;
  dynamic site;
  String image;
  String image2;
  List<String> imageList;
  List<int> trainingAgenda;
  String traningName;
  List<String> traningAgendaName;
  String dateOfTraining;
  List<Janitor> janitorsNameList;

  TrainingDatum({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.updatedBy,
    required this.isActive,
    required this.trainingDatumDateOfTraining,
    required this.clientName,
    required this.site,
    required this.image,
    required this.image2,
    required this.imageList,
    required this.trainingAgenda,
    required this.traningName,
    required this.traningAgendaName,
    required this.dateOfTraining,
    required this.janitorsNameList,
  });

  factory TrainingDatum.fromJson(Map<String, dynamic> json) => TrainingDatum(
        id: json["id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"],
        createdBy: json["createdBy"],
        updatedBy: json["updatedBy"],
        isActive: json["isActive"],
        trainingDatumDateOfTraining: json["Date_of_Training"] ?? "",
        clientName: json["Client_Name"],
        site: json["Site"],
        image: json["image"] ?? "",
        image2: json["image2"] ?? "",
        imageList: json["image_list"] != null
            ? List<String>.from(json["image_list"].map((x) => x))
            : [],
        trainingAgenda: json["Training_Agenda"] != null
            ? List<int>.from(json["Training_Agenda"].map((x) => x))
            : [],
        traningName: json["traning_name"] ?? "",
        traningAgendaName: json["Traning_Agenda_name"] != null
            ? List<String>.from(json["Traning_Agenda_name"].map((x) => x))
            : [],
        dateOfTraining: json["Date_Of_Training"] ?? "",
        janitorsNameList: json["janitors_name_list"] != null
            ? List<Janitor>.from(
                json["janitors_name_list"].map((x) => Janitor.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt,
        "createdBy": createdBy,
        "updatedBy": updatedBy,
        "isActive": isActive,
        "Date_of_Training": trainingDatumDateOfTraining,
        "Client_Name": clientName,
        "Site": site,
        "image": image,
        "image2": image2,
        "image_list": List<dynamic>.from(imageList.map((x) => x)),
        "Training_Agenda": List<dynamic>.from(trainingAgenda.map((x) => x)),
        "traning_name": traningName,
        "Traning_Agenda_name":
            List<dynamic>.from(traningAgendaName.map((x) => x)),
        "Date_Of_Training": dateOfTraining,
        "janitors_name_list":
            List<dynamic>.from(janitorsNameList.map((x) => x.toJson())),
      };
}

class Janitor {
  int id;
  int janitorsId;
  String janitorsName;
  dynamic status;

  Janitor({
    required this.id,
    required this.janitorsId,
    required this.janitorsName,
    required this.status,
  });

  factory Janitor.fromJson(Map<String, dynamic> json) => Janitor(
        id: json["id"]??0,
        janitorsId: json["janitors_id"]??0,
        janitorsName: json["janitors_name"]??"",
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "janitors_id": janitorsId,
        "janitors_name": janitorsName,
        "status": status,
      };
}
