// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

LoginResponse loginResponseFromJson(String str) => LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
    int status;
    String msg;
    Data data;
    String token;

    LoginResponse({
        required this.status,
        required this.msg,
        required this.data,
        required this.token,
    });

    factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        status: json["status"],
        msg: json["msg"],
        data: Data.fromJson(json["data"]),
        token: json["token"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
        "data": data.toJson(),
        "token": token,
    };
}

class Data {
    dynamic id;
    DateTime createdAt;
    dynamic updatedAt;
    dynamic createdBy;
    dynamic updatedBy;
    String empName;
    int empType;
    String empEmailId;
    String password;
    String contact;
    dynamic reportManager;
    bool isActive;

    Data({
        required this.id,
        required this.createdAt,
        this.updatedAt,
        this.createdBy,
        this.updatedBy,
        required this.empName,
        required this.empType,
        required this.empEmailId,
        required this.password,
        required this.contact,
        this.reportManager,
        required this.isActive,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        createdAt: json["createdAt"] != null
            ? DateTime.tryParse(json["createdAt"]) ?? DateTime.now()
            : DateTime.now(),
        updatedAt: json["updatedAt"],
        createdBy: json["createdBy"],
        updatedBy: json["updatedBy"],
        empName: json["emp_name"] ?? "",
        empType: json["emp_type"] ?? 0,
        empEmailId: json["emp_email_id"] ?? "",
        password: json["password"] ?? "",
        contact: json["contact"] ?? "",
        reportManager: json["report_manager"],
        isActive: json["isActive"] ?? false,
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
    };
}
