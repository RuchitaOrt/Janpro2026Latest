class RankingResponse {
  final dynamic status;
  final dynamic msg;
  final dynamic month;
  final MonthRange? monthRange;
  final Pagination? pagination;
  final List<RankingCard> rankingCard;

  RankingResponse({
    required this.status,
    required this.msg,
    required this.month,
    this.monthRange,
    this.pagination,
    required this.rankingCard,
  });

  factory RankingResponse.fromJson(Map<String, dynamic> json) {
    return RankingResponse(
      status: json['status'] ?? 0,
      msg: json['msg'] ?? "",
      month: json['month'] ?? "",
      monthRange: json['month_range'] != null
          ? MonthRange.fromJson(json['month_range'])
          : null,
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
      rankingCard: json['ranking_card'] != null
          ? List<RankingCard>.from(
              json['ranking_card'].map(
                (x) => RankingCard.fromJson(x),
              ),
            )
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "status": status,
      "msg": msg,
      "month": month,
      "month_range": monthRange?.toJson(),
      "pagination": pagination?.toJson(),
      "ranking_card": rankingCard.map((e) => e.toJson()).toList(),
    };
  }
}

class MonthRange {
  final dynamic from;
  final dynamic to;

  MonthRange({
    required this.from,
    required this.to,
  });

  factory MonthRange.fromJson(Map<String, dynamic> json) {
    return MonthRange(
      from: json['from'] ?? "",
      to: json['to'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "from": from,
      "to": to,
    };
  }
}

class Pagination {
  final int totalRecords;
  final int totalPages;
  final int currentPage;
  final int pageSize;
  final bool hasNext;
  final bool hasPrevious;

  Pagination({
    required this.totalRecords,
    required this.totalPages,
    required this.currentPage,
    required this.pageSize,
    required this.hasNext,
    required this.hasPrevious,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      totalRecords:
          int.tryParse(json['total_records'].toString()) ?? 0,

      totalPages:
          int.tryParse(json['total_pages'].toString()) ?? 0,

      currentPage:
          int.tryParse(json['current_page'].toString()) ?? 0,

      pageSize:
          int.tryParse(json['page_size'].toString()) ?? 0,

      hasNext: json['has_next'] ?? false,

      hasPrevious: json['has_previous'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "total_records": totalRecords,
      "total_pages": totalPages,
      "current_page": currentPage,
      "page_size": pageSize,
      "has_next": hasNext,
      "has_previous": hasPrevious,
    };
  }
}
class RankingCard {
  final String supervisorId;
  final String supervisorName;
  final int clientId;
  final String clientName;
  final String clientSiteName;
  final int siteId;
  final String siteName;
  final int totalSitesForClient;
  final double workflowAvg;
  final double attendanceAvg;
  final double score;
  final double scoreBarPct;
  final String month;
  final int rank;

  RankingCard({
    required this.supervisorId,
    required this.supervisorName,
    required this.clientId,
    required this.clientName,
    required this.clientSiteName,
    required this.siteId,
    required this.siteName,
    required this.totalSitesForClient,
    required this.workflowAvg,
    required this.attendanceAvg,
    required this.score,
    required this.scoreBarPct,
    required this.month,
    required this.rank,
  });

  factory RankingCard.fromJson(Map<String, dynamic> json) {
    return RankingCard(
      supervisorId: json['supervisor_id']?.toString() ?? "",
      supervisorName: json['supervisor_name']?.toString() ?? "",
      clientId: int.tryParse(json['client_id'].toString()) ?? 0,
      clientName: json['client_name']?.toString() ?? "",
      clientSiteName: json['client_site_name']?.toString() ?? "",
      siteId: int.tryParse(json['site_id'].toString()) ?? 0,
      siteName: json['site_name']?.toString() ?? "",
      totalSitesForClient:
          int.tryParse(json['total_sites_for_client'].toString()) ?? 0,

      workflowAvg:
          double.tryParse(json['workflow_avg'].toString()) ?? 0.0,

      attendanceAvg:
          double.tryParse(json['attendance_avg'].toString()) ?? 0.0,

      score:
          double.tryParse(json['score'].toString()) ?? 0.0,

      scoreBarPct:
          double.tryParse(json['score_bar_pct'].toString()) ?? 0.0,

      month: json['month']?.toString() ?? "",

      rank: int.tryParse(json['rank'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "supervisor_id": supervisorId,
      "supervisor_name": supervisorName,
      "client_id": clientId,
      "client_name": clientName,
      "client_site_name": clientSiteName,
      "site_id": siteId,
      "site_name": siteName,
      "total_sites_for_client": totalSitesForClient,
      "workflow_avg": workflowAvg,
      "attendance_avg": attendanceAvg,
      "score": score,
      "score_bar_pct": scoreBarPct,
      "month": month,
      "rank": rank,
    };
  }

}