class RankingResponse {
  final int status;
  final String msg;
  final String date;
  final List<RankingCard> rankingCard;

  RankingResponse({
    required this.status,
    required this.msg,
    required this.date,
    required this.rankingCard,
  });

  factory RankingResponse.fromJson(Map<String, dynamic> json) {
    return RankingResponse(
      status: json['status'] ?? 0,
      msg: json['msg'] ?? '',
      date: json['date'] ?? '',
      rankingCard: (json['ranking_card'] as List? ?? [])
          .map((e) => RankingCard.fromJson(e))
          .toList(),
    );
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
      supervisorId: json['supervisor_id'] ?? '',
      supervisorName: json['supervisor_name'] ?? '',
      clientId: json['client_id'] ?? 0,
      clientName: json['client_name'] ?? '',
      clientSiteName: json['client_site_name'] ?? '',
      siteId: json['site_id'] ?? 0,
      siteName: json['site_name'] ?? '',
      totalSitesForClient: json['total_sites_for_client'] ?? 0,

      /// 🔥 SAFE DOUBLE PARSING
      workflowAvg: _toDouble(json['workflow_avg']),
      attendanceAvg: _toDouble(json['attendance_avg']),
      score: _toDouble(json['score']),
      scoreBarPct: _toDouble(json['score_bar_pct']),

      month: json['month'] ?? '',
      rank: json['rank'] ?? 0,
    );
  }

  /// ✅ Handles null / int / double / string
  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is int) return value.toDouble();
    if (value is double) return value;
    return double.tryParse(value.toString()) ?? 0.0;
  }
}