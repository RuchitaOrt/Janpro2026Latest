// To parse this JSON data, do
//
//     final operationalRatinggraphwiseResponse = operationalRatinggraphwiseResponseFromJson(jsonString);

import 'dart:convert';

OperationalRatinggraphwiseResponse operationalRatinggraphwiseResponseFromJson(String str) => OperationalRatinggraphwiseResponse.fromJson(json.decode(str));

String operationalRatinggraphwiseResponseToJson(OperationalRatinggraphwiseResponse data) => json.encode(data.toJson());

class OperationalRatinggraphwiseResponse {
    int status;
    String msg;
    List<DatumElement> data;
    List<GraphDatumElement> graphData;

    OperationalRatinggraphwiseResponse({
        required this.status,
        required this.msg,
        required this.data,
        required this.graphData,
    });

    factory OperationalRatinggraphwiseResponse.fromJson(Map<String, dynamic> json) => OperationalRatinggraphwiseResponse(
        status: json["status"],
        msg: json["msg"],
        data: List<DatumElement>.from(json["data"].map((x) => DatumElement.fromJson(x))),
        graphData: List<GraphDatumElement>.from(json["graph_data"].map((x) => GraphDatumElement.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "graph_data": List<dynamic>.from(graphData.map((x) => x.toJson())),
    };
}

class DatumElement {
    int clientId;
    String clientName;
    dynamic siteId;
    List<GraphDatumElement> monthWisedata;
    dynamic overallRating;
    dynamic status;
    String review;

    DatumElement({
        required this.clientId,
        required this.clientName,
        required this.siteId,
        required this.monthWisedata,
        required this.overallRating,
        required this.status,
         required this.review,
        
    });

    factory DatumElement.fromJson(Map<String, dynamic> json) => DatumElement(
        clientId: json["client_id"]??0,
        clientName: json["client_name "]??'',
        siteId: json["site_id"],
        monthWisedata: List<GraphDatumElement>.from(json["month_wisedata"].map((x) => GraphDatumElement.fromJson(x))),
        overallRating: json["overall_rating"],
        status: json["status"],
         review: json["review"]??"",
    );

    Map<String, dynamic> toJson() => {
        "client_id": clientId,
        "client_name ": clientName,
        "site_id": siteId,
        "month_wisedata": List<dynamic>.from(monthWisedata.map((x) => x.toJson())),
        "overall_rating": overallRating,
        "status": status,
         "review": review,
    };
}

class GraphDatumElement {
    String month;
    String monthname;
    dynamic percentage;
    String? review;

    GraphDatumElement({
        required this.month,
        required this.monthname,
        required this.percentage,
        this.review,
    });

    factory GraphDatumElement.fromJson(Map<String, dynamic> json) => GraphDatumElement(
        month: json["month"]??'',
        monthname: json["monthname"]??"",
        percentage: json["percentage"],
        review: json["review"]??"",
    );

    Map<String, dynamic> toJson() => {
        "month": month,
        "monthname": monthname,
        "percentage": percentage,
        "review": review,
    };
}
