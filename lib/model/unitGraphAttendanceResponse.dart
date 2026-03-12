// To parse this JSON data, do
//
//     final unitAttendanceResponse = unitGraphAttendanceResponseFromJson(jsonString);

import 'dart:convert';

UnitGraphAttendanceResponse unitGraphAttendanceResponseFromJson(String str) => UnitGraphAttendanceResponse.fromJson(json.decode(str));

String unitGroupAttendanceResponseToJson(UnitGraphAttendanceResponse data) => json.encode(data.toJson());

class UnitGraphAttendanceResponse {
    int status;
    String msg;
    // List<Datum> data;
    List<GraphDatum> graphData;

    UnitGraphAttendanceResponse({
        required this.status,
        required this.msg,
        // required this.data,
        required this.graphData,
    });

    factory UnitGraphAttendanceResponse.fromJson(Map<String, dynamic> json) => UnitGraphAttendanceResponse(
        status: json["status"],
        msg: json["msg"],
        // data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        graphData: List<GraphDatum>.from(json["graph_data"].map((x) => GraphDatum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
        // "data": List<dynamic>.from(data.map((x) => x.toJson())),
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
        month: json["month"]??'',
        monthname: json["monthname"]??'',
        percentage: json["percentage"],
    );

    Map<String, dynamic> toJson() => {
        "month": month,
        "monthname": monthname,
        "percentage": percentage,
    };
}
