// // To parse this JSON data, do
// //
// //     final cardVisitView = cardVisitViewFromJson(jsonString);

// import 'dart:convert';

// CardVisitView cardVisitViewFromJson(String str) => CardVisitView.fromJson(json.decode(str));

// String cardVisitViewToJson(CardVisitView data) => json.encode(data.toJson());

// class CardVisitView {
//     int? status;
//     String? msg;
//     List<Datum>? data;

//     CardVisitView({
//         this.status,
//         this.msg,
//         this.data,
//     });

//     factory CardVisitView.fromJson(Map<String, dynamic> json) => CardVisitView(
//         status: json["status"],
//         msg: json["msg"],
//         data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
//     );

//     Map<String, dynamic> toJson() => {
//         "status": status,
//         "msg": msg,
//         "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
//     };
// }

// class Datum {
//     int? id;
//     DateTime? createdAt;
//     dynamic updatedAt;
//     dynamic createdBy;
//     dynamic updatedBy;
//     bool? isActive;
//     String? clientId;
//     String? siteId;
//     DateTime? date;
//     String? time;
//     String? visitRemarks;
//     String? supportingImage;
//     String? empId;
//     String? proposeRemark;
//     double? latitude;
//     double? longitude;
//     dynamic emp_type_str;
//     String? empName;
    

//     Datum({
//         this.id,
//         this.createdAt,
//         this.updatedAt,
//         this.createdBy,
//         this.updatedBy,
//         this.isActive,
//         this.clientId,
//         this.siteId,
//         this.date,
//         this.time,
//         this.visitRemarks,
//         this.supportingImage,
//         this.empId,
//         this.proposeRemark,
//         this.latitude,
//         this.longitude,
//         this.emp_type_str,
//         this.empName,
//     });

//     factory Datum.fromJson(Map<String, dynamic> json) => Datum(
//         id: json["id"],
//         createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
//         updatedAt: json["updatedAt"],
//         createdBy: json["createdBy"],
//         updatedBy: json["updatedBy"],
//         isActive: json["isActive"],
//         clientId: json["client_id"],
//         siteId: json["site_id"],
//         date: json["date"] == null ? null : DateTime.parse(json["date"]),
//         time: json["time"],
//         visitRemarks: json["visit_remarks"],
//         supportingImage: json["supporting_image"],
//         empId: json["emp_id"],
//         proposeRemark: json["propose_remark"],
//         latitude: json["latitude"]?.toDouble(),
//         longitude: json["longitude"]?.toDouble(),
//         emp_type_str: json["emp_type_str"],
//         empName: json["emp_name"],
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id,
//         "createdAt": createdAt?.toIso8601String(),
//         "updatedAt": updatedAt,
//         "createdBy": createdBy,
//         "updatedBy": updatedBy,
//         "isActive": isActive,
//         "client_id": clientId,
//         "site_id": siteId,
//         "date": "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
//         "time": time,
//         "visit_remarks": visitRemarks,
//         "supporting_image": supportingImage,
//         "emp_id": empId,
//         "propose_remark": proposeRemark,
//         "latitude": latitude,
//         "longitude": longitude,
//         "emp_type_str": emp_type_str,
//         "emp_name": empName,
//     };
// }
import 'dart:convert';

CardVisitView cardVisitViewFromJson(String str) =>
    CardVisitView.fromJson(json.decode(str));

String cardVisitViewToJson(CardVisitView data) =>
    json.encode(data.toJson());

/// 🔹 CLEAN STRING FUNCTION (VERY IMPORTANT)
String cleanText(dynamic value) {
  if (value == null) return "";
  return value
      .toString()
      .replaceAll('%22', '') // remove encoded quotes
      .replaceAll('"', '')   // remove raw quotes
      .trim();
}

class CardVisitView {
  int? status;
  String? msg;
  List<Datum>? data;

  CardVisitView({
    this.status,
    this.msg,
    this.data,
  });

  factory CardVisitView.fromJson(Map<String, dynamic> json) =>
      CardVisitView(
        status: json["status"],
        msg: json["msg"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(
                json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

/// 🔹 MAIN MODEL
class Datum {
  int? id;
  DateTime? createdAt;
  dynamic updatedAt;
  dynamic createdBy;
  dynamic updatedBy;
  bool? isActive;
  String? clientId;
  String? siteId;
  DateTime? date;
  String? time;
  String? visitRemarks;
  String? supportingImage;
  String? empId;
  String? proposeRemark;
  double? latitude;
  double? longitude;
  dynamic empTypeStr;
  String? empName;

  /// ✅ NEW FIELDS
  List<TrainingImage>? trainingImages;
  String? trainingVisitCategories;
  String? trainingVisitNames;
  String? workflow;

  Datum({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
    this.isActive,
    this.clientId,
    this.siteId,
    this.date,
    this.time,
    this.visitRemarks,
    this.supportingImage,
    this.empId,
    this.proposeRemark,
    this.latitude,
    this.longitude,
    this.empTypeStr,
    this.empName,
    this.trainingImages,
    this.trainingVisitCategories,
    this.trainingVisitNames,
    this.workflow
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"],
        createdBy: json["createdBy"],
        updatedBy: json["updatedBy"],
        isActive: json["isActive"],
        clientId: json["client_id"],
        siteId: json["site_id"],
        date: json["date"] == null
            ? null
            : DateTime.parse(json["date"]),
        time: json["time"],
        visitRemarks: cleanText(json["visit_remarks"]),
        supportingImage: cleanText(json["supporting_image"]),
        empId: json["emp_id"],
        proposeRemark: cleanText(json["propose_remark"]),
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        empTypeStr: json["emp_type_str"],
        empName: json["emp_name"],
        workflow:json["workflow"],

        /// ✅ NEW PARSING
        trainingImages: json["training_images"] == null
            ? []
            : List<TrainingImage>.from(
                json["training_images"]
                    .map((x) => TrainingImage.fromJson(x))),
        trainingVisitCategories:
            cleanText(json["training_visit_categories"]),
        trainingVisitNames:
            cleanText(json["training_visit_names"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt,
        "createdBy": createdBy,
        "updatedBy": updatedBy,
        "isActive": isActive,
        "client_id": clientId,
        "site_id": siteId,
        "date": date == null
            ? null
            : "${date!.year.toString().padLeft(4, '0')}-"
                "${date!.month.toString().padLeft(2, '0')}-"
                "${date!.day.toString().padLeft(2, '0')}",
        "time": time,
        "visit_remarks": visitRemarks,
        "supporting_image": supportingImage,
        "emp_id": empId,
        "propose_remark": proposeRemark,
        "latitude": latitude,
        "longitude": longitude,
        "emp_type_str": empTypeStr,
        "emp_name": empName,

        /// ✅ NEW FIELDS
        "training_images": trainingImages == null
            ? []
            : List<dynamic>.from(
                trainingImages!.map((x) => x.toJson())),
        "training_visit_categories": trainingVisitCategories,
        "training_visit_names": trainingVisitNames,
        "workflow":workflow
      };
}

/// 🔹 TRAINING IMAGE MODEL
class TrainingImage {
  String? imageUrl;
  int? trainingVisitId;
  String? trainingVisitName;
  String? trainingVisitCategory;

  TrainingImage({
    this.imageUrl,
    this.trainingVisitId,
    this.trainingVisitName,
    this.trainingVisitCategory,
  });

  factory TrainingImage.fromJson(Map<String, dynamic> json) =>
      TrainingImage(
        imageUrl: cleanText(json["image_url"]),
        trainingVisitId: json["training_visit_id"],
        trainingVisitName:
            cleanText(json["training_visit_name"]),
        trainingVisitCategory:
            cleanText(json["training_visit_category"]),
      );

  Map<String, dynamic> toJson() => {
        "image_url": imageUrl,
        "training_visit_id": trainingVisitId,
        "training_visit_name": trainingVisitName,
        "training_visit_category": trainingVisitCategory,
      };
}