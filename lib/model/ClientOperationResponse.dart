// import 'dart:convert';

// ClientOperationResponse clientOperationResponseFromJson(String str) =>
//     ClientOperationResponse.fromJson(json.decode(str));

// String clientOperationResponseToJson(ClientOperationResponse data) =>
//     json.encode(data.toJson());

// class ClientOperationResponse {
//   int? status;
//   String? msg;
//   List<Datum> data;

//   ClientOperationResponse({
//     this.status,
//     this.msg,
//     required this.data,
//   });

//   factory ClientOperationResponse.fromJson(Map<String, dynamic> json) =>
//       ClientOperationResponse(
//         status: json["status"],
//         msg: json["msg"],
//         data: json["data"] == null
//             ? []
//             : List<Datum>.from(
//                 json["data"].map((x) => Datum.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "status": status,
//         "msg": msg,
//         "data": List<dynamic>.from(data.map((x) => x.toJson())),
//       };
// }

// class Datum {
//   int clientId;
//   int siteId;
//   String clientName;
//   String siteName;
//   List<VisitDatum> visitData;
//   int totalNumberOfVisit;
//   int? status;
//   String visitDone;
//   List<GraphDatum> graphData;

//   Datum({
//     required this.clientId,
//     required this.siteId,
//     required this.clientName,
//     required this.siteName,
//     required this.visitData,
//     required this.totalNumberOfVisit,
//     required this.status,
//     required this.visitDone,
//     required this.graphData,
//   });

//   factory Datum.fromJson(Map<String, dynamic> json) => Datum(
//         clientId: int.tryParse(json["client_id"].toString()) ?? 0,
//         siteId: int.tryParse(json["site_id"].toString()) ?? 0,
//         clientName: json["client_name"] ?? "",
//         siteName: json["site_name"] ?? "",
//         visitData: json["visit_data"] == null
//             ? []
//             : List<VisitDatum>.from(
//                 json["visit_data"]
//                     .map((x) => VisitDatum.fromJson(x))),
//         totalNumberOfVisit: json["total_number_of_visit"] ?? 0,
//         status: json["status"],
//         visitDone: json["visit_done"] ?? "",
//         graphData: json["graph_data"] == null
//             ? []
//             : List<GraphDatum>.from(
//                 json["graph_data"]
//                     .map((x) => GraphDatum.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "client_id": clientId,
//         "site_id": siteId,
//         "client_name": clientName,
//         "site_name": siteName,
//         "visit_data": List<dynamic>.from(visitData.map((x) => x.toJson())),
//         "total_number_of_visit": totalNumberOfVisit,
//         "status": status,
//         "visit_done": visitDone,
//         "graph_data": List<dynamic>.from(graphData.map((x) => x.toJson())),
//       };
// }

// class GraphDatum {
//   String year;
//   String month;
//   String monthname;
//   int percentage;

//   GraphDatum({
//     required this.year,
//     required this.month,
//     required this.monthname,
//     required this.percentage,
//   });

//   factory GraphDatum.fromJson(Map<String, dynamic> json) => GraphDatum(
//         year: json["year"] ?? "",
//         month: json["month"] ?? "",
//         monthname: json["monthname"] ?? "",
//         percentage: json["percentage"] ?? 0,
//       );

//   Map<String, dynamic> toJson() => {
//         "year": year,
//         "month": month,
//         "monthname": monthname,
//         "percentage": percentage,
//       };
// }

// class VisitDatum {
//   int id;
//   DateTime createdAt;
//   dynamic updatedAt;
//   dynamic createdBy;
//   dynamic updatedBy;
//   bool isActive;

//   String clientId;
//   String siteId;
//   String date;
//   String time;

//   String visitRemarks;
//   String supportingImage;

//   String empId;
//   String? empName;

//   String? proposeRemark;
//   double? latitude;
//   double? longitude;

//   String? workflowManagement;
//   int? empType;
//   String? empTypeStr;

//   List<TrainingImage> trainingImages;
//   String? trainingVisitCategories;
//   String? trainingVisitNames;

//   VisitDatum({
//     required this.id,
//     required this.createdAt,
//     this.updatedAt,
//     this.createdBy,
//     this.updatedBy,
//     required this.isActive,
//     required this.clientId,
//     required this.siteId,
//     required this.date,
//     required this.time,
//     required this.visitRemarks,
//     required this.supportingImage,
//     required this.empId,
//     this.empName,
//     this.proposeRemark,
//     this.latitude,
//     this.longitude,
//     this.workflowManagement,
//     this.empType,
//     this.empTypeStr,
//     required this.trainingImages,
//     this.trainingVisitCategories,
//     this.trainingVisitNames,
//   });

//   factory VisitDatum.fromJson(Map<String, dynamic> json) => VisitDatum(
//         id: json["id"] ?? 0,
//         createdAt:
//             DateTime.tryParse(json["createdAt"] ?? "") ?? DateTime.now(),
//         updatedAt: json["updatedAt"],
//         createdBy: json["createdBy"],
//         updatedBy: json["updatedBy"],
//         isActive: json["isActive"] ?? false,
//         clientId: json["client_id"]?.toString() ?? "",
//         siteId: json["site_id"]?.toString() ?? "",
//         date: json["date"] ?? "",
//         time: json["time"] ?? "",
//         visitRemarks: json["visit_remarks"] ?? "",
//         supportingImage: json["supporting_image"] ?? "",
//         empId: json["emp_id"] ?? "",
//         empName: json["emp_name"] ?? "",
//         proposeRemark: json["propose_remark"] ?? "",
//         latitude: json["latitude"] != null
//             ? double.tryParse(json["latitude"].toString())
//             : null,
//         longitude: json["longitude"] != null
//             ? double.tryParse(json["longitude"].toString())
//             : null,

//         /// NEW FIELDS
//         workflowManagement: json["workflow_management"],
//         empType: json["emp_type"],
//         empTypeStr: json["emp_type_str"],

//         trainingImages: json["training_images"] == null
//             ? []
//             : List<TrainingImage>.from(
//                 json["training_images"]
//                     .map((x) => TrainingImage.fromJson(x))),
//         trainingVisitCategories: json["training_visit_categories"],
//         trainingVisitNames: json["training_visit_names"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "createdAt": createdAt.toIso8601String(),
//         "updatedAt": updatedAt,
//         "createdBy": createdBy,
//         "updatedBy": updatedBy,
//         "isActive": isActive,
//         "client_id": clientId,
//         "site_id": siteId,
//         "date": date,
//         "time": time,
//         "visit_remarks": visitRemarks,
//         "supporting_image": supportingImage,
//         "emp_id": empId,
//         "propose_remark": proposeRemark,
//         "latitude": latitude,
//         "longitude": longitude,
//         "workflow_management": workflowManagement,
//         "emp_type": empType,
//         "emp_type_str": empTypeStr,
//         "training_images":
//             List<dynamic>.from(trainingImages.map((x) => x.toJson())),
//         "training_visit_categories": trainingVisitCategories,
//         "training_visit_names": trainingVisitNames,
//       };
// }

// class TrainingImage {
//   String imageUrl;
//   int trainingVisitId;
//   String trainingVisitName;
//   String trainingVisitCategory;

//   TrainingImage({
//     required this.imageUrl,
//     required this.trainingVisitId,
//     required this.trainingVisitName,
//     required this.trainingVisitCategory,
//   });

//   factory TrainingImage.fromJson(Map<String, dynamic> json) =>
//       TrainingImage(
//         imageUrl:
//             (json["image_url"] ?? "").toString().replaceAll('%22', ''),
//         trainingVisitId: json["training_visit_id"] ?? 0,
//         trainingVisitName: json["training_visit_name"] ?? "",
//         trainingVisitCategory:
//             json["training_visit_category"] ?? "",
//       );

//   Map<String, dynamic> toJson() => {
//         "image_url": imageUrl,
//         "training_visit_id": trainingVisitId,
//         "training_visit_name": trainingVisitName,
//         "training_visit_category": trainingVisitCategory,
//       };
// }
import 'dart:convert';

ClientOperationResponse clientOperationResponseFromJson(String str) =>
    ClientOperationResponse.fromJson(json.decode(str));

String clientOperationResponseToJson(ClientOperationResponse data) =>
    json.encode(data.toJson());

class ClientOperationResponse {
  int? status;
  String? msg;
  List<Datum> data;

  ClientOperationResponse({
    required this.status,
    required this.msg,
    required this.data,
  });

  factory ClientOperationResponse.fromJson(Map<String, dynamic> json) =>
      ClientOperationResponse(
        status: json["status"],
        msg: json["msg"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
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
  String siteName;
  List<VisitDatum> visitData;
  int totalNumberOfVisit;
  int? status;
  String visitDone;
  List<GraphDatum> graphData;

  Datum({
    required this.clientId,
    required this.siteId,
    required this.clientName,
    required this.siteName,
    required this.visitData,
    required this.totalNumberOfVisit,
    required this.status,
    required this.visitDone,
    required this.graphData,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    clientId: int.tryParse(json["client_id"].toString()) ?? 0,
    siteId: int.tryParse(json["site_id"].toString()) ?? 0,
    clientName: json["client_name"] ?? "",
    siteName: json["site_name"] ?? "",
    visitData: json["visit_data"] == null
        ? []
        : List<VisitDatum>.from(
            json["visit_data"].map((x) => VisitDatum.fromJson(x)),
          ),
    totalNumberOfVisit: json["total_number_of_visit"] ?? 0,
    status: json["status"],
    visitDone: json["visit_done"] ?? "",
    graphData: json["graph_data"] == null
        ? []
        : List<GraphDatum>.from(
            json["graph_data"].map((x) => GraphDatum.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "client_id": clientId,
    "site_id": siteId,
    "client_name": clientName,
    "site_name": siteName,
    "visit_data": List<dynamic>.from(visitData.map((x) => x.toJson())),
    "total_number_of_visit": totalNumberOfVisit,
    "status": status,
    "visit_done": visitDone,
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

class VisitDatum {
  int id;
  DateTime createdAt;
  dynamic updatedAt;
  dynamic createdBy;
  dynamic updatedBy;
  bool isActive;
  String clientId;
  String siteId;
  String date;
  String time;
  String visitRemarks;
  String supportingImage;
  String empId;
  String? empName;

  String? proposeRemark;
  double? latitude;
  double? longitude;

  VisitDatum({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.updatedBy,
    required this.isActive,
    required this.clientId,
    required this.siteId,
    required this.date,
    required this.time,
    required this.visitRemarks,
    required this.supportingImage,
    required this.empId,
    required this.proposeRemark,
    required this.latitude,
    required this.longitude,
    required this.empName,
  });

  factory VisitDatum.fromJson(Map<String, dynamic> json) => VisitDatum(
    id: json["id"] ?? 0,
    createdAt: DateTime.tryParse(json["createdAt"] ?? "") ?? DateTime.now(),
    updatedAt: json["updatedAt"],
    createdBy: json["createdBy"],
    updatedBy: json["updatedBy"],
    isActive: json["isActive"] ?? false,
    clientId: json["client_id"]?.toString() ?? "",
    siteId: json["site_id"]?.toString() ?? "",
    date: json["date"] ?? "",
    time: json["time"] ?? "",
    visitRemarks: json["visit_remarks"] ?? "",
    supportingImage: json["supporting_image"] ?? "",
    empId: json["emp_id"] ?? "",
    empName: json["emp_name"] ?? "",

    proposeRemark: json["propose_remark"] ?? "",
    latitude: json["latitude"] != null
        ? double.tryParse(json["latitude"].toString())
        : null,
    longitude: json["longitude"] != null
        ? double.tryParse(json["longitude"].toString())
        : null,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt,
    "createdBy": createdBy,
    "updatedBy": updatedBy,
    "isActive": isActive,
    "client_id": clientId,
    "site_id": siteId,
    "date": date,
    "time": time,
    "visit_remarks": visitRemarks,
    "supporting_image": supportingImage,
    "emp_id": empId,
    "propose_remark": proposeRemark,
    "latitude": latitude,
    "longitude": longitude,
  };
}
