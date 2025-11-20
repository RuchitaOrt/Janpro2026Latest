// To parse this JSON data, do
//
//     final profileResponse = profileResponseFromJson(jsonString);

import 'dart:convert';

ProfileResponse profileResponseFromJson(String str) => ProfileResponse.fromJson(json.decode(str));

String profileResponseToJson(ProfileResponse data) => json.encode(data.toJson());

class ProfileResponse {
    dynamic status;
    String message;
    Data data;

    ProfileResponse({
        required this.status,
        required this.message,
        required this.data,
    });

    factory ProfileResponse.fromJson(Map<String, dynamic> json) => ProfileResponse(
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
    dynamic id;
    DateTime createdAt;
    dynamic updatedAt;
    dynamic createdBy;
    dynamic updatedBy;
    String empName;
    dynamic empType;
    String empEmailId;
    String password;
    String contact;
    String reportManager;
    bool isActive;
    String empTypeStr;

    Data({
        required this.id,
        required this.createdAt,
        required this.updatedAt,
        required this.createdBy,
        required this.updatedBy,
        required this.empName,
        required this.empType,
        required this.empEmailId,
        required this.password,
        required this.contact,
        required this.reportManager,
        required this.isActive,
        required this.empTypeStr,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
         id: json["id"],
       createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"],
        createdBy: json["createdBy"],
        updatedBy: json["updatedBy"],
        empName: json["emp_name"] ?? "",
        empType: json["emp_type"],
        empEmailId: json["emp_email_id"] ?? "",
        password: json["password"] ?? "",
        contact: json["contact"] ?? "",
        reportManager: json["report_manager"],
        isActive: json["isActive"] ?? false,
        empTypeStr: json["emp_type_str"] ?? "",
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt,
        "createdBy": createdBy,
        "updatedBy": updatedBy,
        "emp_name": empName,
        "emp_type": empType,
        "emp_email_id": empEmailId,
        "password": password,
        "contact": contact,
        "report_manager": reportManager,
        "isActive": isActive,
        "emp_type_str": empTypeStr,
    };
}
