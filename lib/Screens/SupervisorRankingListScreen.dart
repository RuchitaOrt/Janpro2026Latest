import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:janpro/DBHelper/db_helper.dart';
import 'package:janpro/Utitlity/APIManager.dart';
import 'package:janpro/Utitlity/SPManager.dart';
import 'package:janpro/Utitlity/ShowDialog.dart';
import 'package:janpro/Utitlity/custom_color.dart';
import 'package:janpro/Utitlity/internetConnection.dart';
import 'package:janpro/const/global.dart';

import 'package:janpro/model/RankingResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SupervisorRankingListScreen extends StatefulWidget {
  final String selectedMonth;
  final int selectedYear;

  const SupervisorRankingListScreen({
    super.key,
    required this.selectedMonth,
    required this.selectedYear,
  });

  @override
  State<SupervisorRankingListScreen> createState() =>
      _SupervisorRankingListScreenState();
}

class _SupervisorRankingListScreenState
    extends State<SupervisorRankingListScreen> {
  final ScrollController _scrollController = ScrollController();
final TextEditingController searchController =
    TextEditingController();

List<RankingCard> filteredRankingList = [];
  List<RankingCard> rankingList = [];

  bool isLoading = false;
  bool hasMore = true;
  bool isApiCalling = false;

  int page = 1;

  String rmID = "";
@override
void initState() {
  super.initState();

  getRanking();

  _scrollController.addListener(_onScroll);

  searchController.addListener(() {
    filterRanking(searchController.text);
  });
}
void filterRanking(String query) {
  if (query.trim().isEmpty) {
    setState(() {
      filteredRankingList = rankingList;
    });
    return;
  }

  final search = query.toLowerCase();

  setState(() {
    filteredRankingList = rankingList.where((item) {
      final name =
          (item.supervisorName ?? "").toLowerCase();

      final location =
          (item.siteName ?? "").toLowerCase();

      return name.contains(search) ||
          location.contains(search);
    }).toList();
  });
}
  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    if (currentScroll >= (maxScroll - 200)) {
      if (!isLoading && hasMore && !isApiCalling) {
        getRanking();
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }

  String getMonthNumber(String month) {
    const months = {
      "Jan": "01",
      "Feb": "02",
      "Mar": "03",
      "Apr": "04",
      "May": "05",
      "Jun": "06",
      "Jul": "07",
      "Aug": "08",
      "Sep": "09",
      "Oct": "10",
      "Nov": "11",
      "Dec": "12",
    };

    return months[month] ?? "01";
  }
Future<void> getRanking() async {
  if (isApiCalling) return;

  isApiCalling = true;

  if (mounted) {
    setState(() {
      isLoading = true;
    });
  }

  rmID = (await SPManager().getRMID()) ?? "";

  String monthNumber = getMonthNumber(widget.selectedMonth);

  String datefrom = "${widget.selectedYear}-$monthNumber";

  final payload = {
    "date": datefrom,
    "rm_id": rmID,
    "page": page.toString(),
  };

  /// UNIQUE CACHE KEY
  final cacheKey =
      'rankingCache_${datefrom}_${rmID}_page_$page';

  var status = await ConnectionDetector.checkInternetConnection();

  /// ========================= ONLINE =========================
  if (status) {
    APIManager().apiRequest(
      context,
      API.get_ranking_card,
      (response) async {
        final resp = response as RankingResponse;

        if (!mounted) return;

        if (resp.status == 1) {
          final prefs = await SharedPreferences.getInstance();

          /// SAVE COMPLETE RESPONSE
          await prefs.setString(
            cacheKey,
            jsonEncode(resp.toJson()),
          );

          final newData = resp.rankingCard ?? [];

          setState(() {
            rankingList.addAll(newData);

            filteredRankingList = rankingList;

            hasMore = resp.pagination?.hasNext ?? false;

            if (hasMore) {
              page++;
            }

            isLoading = false;
          });
        } else {
          setState(() {
            hasMore = false;
            isLoading = false;
          });
        }

        isApiCalling = false;
      },
      (error) {
        if (!mounted) return;

        setState(() {
          isLoading = false;
        });

        isApiCalling = false;
      },
      false,
      "",
      jsonval: payload,
    );
  }

  /// ========================= OFFLINE =========================
  else {
    final prefs = await SharedPreferences.getInstance();

    List<RankingCard> offlineData = [];

    int tempPage = 1;

    /// LOAD ALL SAVED PAGES
    while (true) {
      final key =
          'rankingCache_${datefrom}_${rmID}_page_$tempPage';

      final cachedString = prefs.getString(key);

      if (cachedString == null) {
        break;
      }

      final decoded = jsonDecode(cachedString);

      RankingResponse cachedResponse =
          RankingResponse.fromJson(decoded);

      offlineData.addAll(
        cachedResponse.rankingCard ?? [],
      );

      tempPage++;
    }

    if (!mounted) return;

    setState(() {
      rankingList = offlineData;

      filteredRankingList = rankingList;

      isLoading = false;

      hasMore = false;
    });

    isApiCalling = false;

    if (offlineData.isNotEmpty) {
      ShowDialogs.showToast(
        "Offline cached data loaded",
      );
    } else {
      ShowDialogs.showToast(
        "No offline cached ranking data found",
      );
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Supervisor Rankings"),
        backgroundColor: customcolor.blue,
      ),
    body: Column(
  children: [
    /// SEARCH
    Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(14),
        ),
        child: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: "Search supervisor or location",
            hintStyle: TextStyle(
              color: Colors.grey.shade500,
            ),
            prefixIcon: Icon(
              Icons.search,
              color: customcolor.blue,
            ),
            suffixIcon: searchController.text.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      searchController.clear();

                      filterRanking("");
                    },
                    icon: const Icon(Icons.close),
                  )
                : null,
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(
              vertical: 15,
            ),
          ),
        ),
      ),
    ),

    /// LIST
    Expanded(
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: filteredRankingList.length + 1,
        itemBuilder: (context, index) {
          if (index < filteredRankingList.length) {
            final item = filteredRankingList[index];

            return RankingData(
              rank: item.rank ?? 0,
              name: item.supervisorName ?? "",
              location: item.siteName ?? "",
              workflow:
                  item.workflowAvg?.toInt() ?? 0,
              attendance:
                  item.attendanceAvg?.toInt() ?? 0,
              score: item.score?.toInt() ?? 0,
            );
          }

          if (isLoading) {
            return const Padding(
              padding: EdgeInsets.symmetric(
                vertical: 20,
              ),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (!hasMore) {
            return const SizedBox(height: 30);
          }

          return const SizedBox.shrink();
        },
      ),
    ),
  ],
),
    );
  }
}
class RankingData extends StatelessWidget {
  final int rank;
  final String name;
  final String location;
  final int workflow;
  final int attendance;
  final int score;

  const RankingData({
    super.key,
    required this.rank,
    required this.name,
    required this.location,
    required this.workflow,
    required this.attendance,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    final isTop = rank == 1;

    final screenWidth = MediaQuery.of(context).size.width;

    final cardPadding = screenWidth * 0.04;

    final avatarSize = screenWidth * 0.12;

    final badgeSize = screenWidth * 0.11;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: screenWidth * 0.04),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: isTop
            ? const LinearGradient(
                colors: [
                  Color(0xff1E56B3),
                  Color(0xff2F6FE4),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: isTop ? null : const Color(0xffF7F7F7),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(cardPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// TOP SECTION
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// AVATAR
                    Container(
                      height: avatarSize,
                      width: avatarSize,
                      decoration: BoxDecoration(
                        color: isTop
                            ? Colors.white.withOpacity(0.18)
                            : customcolor.blue.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        name.isNotEmpty
                            ? name.substring(0, 2).toUpperCase()
                            : "NA",
                        style: TextStyle(
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.bold,
                          color:
                              isTop ? Colors.white : customcolor.blue,
                        ),
                      ),
                    ),

                    SizedBox(width: screenWidth * 0.03),

                    /// NAME + LOCATION
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: screenWidth * 0.042,
                                fontWeight: FontWeight.w700,
                                color: isTop
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),

                            SizedBox(height: 4),

                            Text(
                              location,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: screenWidth * 0.032,
                                color: isTop
                                    ? Colors.white70
                                    : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(width: badgeSize * 0.7),
                  ],
                ),

                SizedBox(height: screenWidth * 0.05),

                /// STATS
                _stat(
                  "Workflow",
                  workflow,
                  isTop,
                  Colors.green,
                  screenWidth,
                ),

                SizedBox(height: 10),

                _stat(
                  "Attendance",
                  attendance,
                  isTop,
                  Colors.orange,
                  screenWidth,
                ),

                SizedBox(height: screenWidth * 0.05),

                /// PROGRESS
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: (score / 100).clamp(0.0, 1.0),
                    minHeight: 8,
                    backgroundColor: isTop
                        ? Colors.white24
                        : Colors.grey.shade300,
                    valueColor: AlwaysStoppedAnimation(
                      isTop
                          ? Colors.greenAccent
                          : customcolor.blue,
                    ),
                  ),
                ),

                SizedBox(height: 12),

                /// SCORE
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Score",
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.bold,
                        color: isTop
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    Text(
                      "$score",
                      style: TextStyle(
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.bold,
                        color: isTop
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          /// RANK BADGE
          Positioned(
            top: 14,
            right: 14,
            child: Container(
              height: badgeSize,
              width: badgeSize,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: rank == 1
                    ? Colors.amber
                    : customcolor.blue.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Text(
                "#$rank",
                style: TextStyle(
                  color: rank == 1
                      ? Colors.black
                      : customcolor.blue,
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stat(
    String title,
    int value,
    bool isTop,
    Color dotColor,
    double screenWidth,
  ) {
    return Row(
      children: [
        Container(
          height: 8,
          width: 8,
          decoration: BoxDecoration(
            color: dotColor,
            shape: BoxShape.circle,
          ),
        ),

        SizedBox(width: 8),

        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: screenWidth * 0.034,
              color: isTop
                  ? Colors.white70
                  : Colors.black54,
            ),
          ),
        ),

        Flexible(
          child: Text(
            "$value%",
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: screenWidth * 0.035,
              fontWeight: FontWeight.w700,
              color:
                  isTop ? Colors.white : Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
// class RankingData extends StatelessWidget {
//   final int rank;
//   final String name;
//   final String location;
//   final int workflow;
//   final int attendance;
//   final int score;

//   const RankingData({
//     super.key,
//     required this.rank,
//     required this.name,
//     required this.location,
//     required this.workflow,
//     required this.attendance,
//     required this.score,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final isTop = rank == 1;

//     return Container(
//       width: double.infinity,
//       margin: const EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(26),
//         gradient: isTop
//             ? const LinearGradient(
//                 colors: [
//                   Color(0xff1E56B3),
//                   Color(0xff2F6FE4),
//                 ],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               )
//             : null,
//         color: isTop ? null : const Color(0xffF7F7F7),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.06),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Stack(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(18),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 /// TOP SECTION
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     /// AVATAR
//                     Container(
//                       height: 48,
//                       width: 48,
//                       decoration: BoxDecoration(
//                         color: isTop
//                             ? Colors.white.withOpacity(0.18)
//                             : customcolor.blue.withOpacity(0.10),
//                         borderRadius: BorderRadius.circular(18),
//                       ),
//                       alignment: Alignment.center,
//                       child: Text(
//                         name.isNotEmpty
//                             ? name.substring(0, 2).toUpperCase()
//                             : "NA",
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color:
//                               isTop ? Colors.white : customcolor.blue,
//                         ),
//                       ),
//                     ),

//                     const SizedBox(width: 14),

//                     /// NAME + LOCATION
//                     Expanded(
//                       child: Padding(
//                         padding: const EdgeInsets.only(top: 6),
//                         child: Column(
//                           crossAxisAlignment:
//                               CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               name,
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w700,
//                                 color: isTop
//                                     ? Colors.white
//                                     : Colors.black,
//                               ),
//                             ),
                        
//                             const SizedBox(height: 4),
                        
//                             Text(
//                               location,
//                               maxLines: 2,
//                               overflow: TextOverflow.ellipsis,
//                               style: TextStyle(
//                                 fontSize: 13,
//                                 color: isTop
//                                     ? Colors.white70
//                                     : Colors.grey,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),

//                 const SizedBox(height: 22),

//                 /// WORKFLOW
//                 _stat(
//                   "Workflow",
//                   workflow,
//                   isTop,
//                   Colors.green,
//                 ),

//                 const SizedBox(height: 10),

//                 /// ATTENDANCE
//                 _stat(
//                   "Attendance",
//                   attendance,
//                   isTop,
//                   Colors.orange,
//                 ),

//                 const SizedBox(height: 22),

//                 /// PROGRESS BAR
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(10),
//                   child: LinearProgressIndicator(
//                     value: score / 100,
//                     minHeight: 9,
//                     backgroundColor: isTop
//                         ? Colors.white24
//                         : Colors.grey.shade300,
//                     valueColor: AlwaysStoppedAnimation(
//                       isTop
//                           ? Colors.greenAccent
//                           : customcolor.blue,
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 10),

//                 /// SCORE
//                 Row(
//                   mainAxisAlignment:
//                       MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       "Score",
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: isTop
//                             ? Colors.white
//                             : Colors.black,
//                       ),
//                     ),

//                     Text(
//                       "$score",
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: isTop
//                             ? Colors.white
//                             : Colors.black,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),

//           /// RANK BADGE
//           Positioned(
//             top: 16,
//             right: 16,
//             child: Container(
//               height: 42,
//               width: 42,
//               alignment: Alignment.center,
//               decoration: BoxDecoration(
//                 color: rank == 1
//                     ? Colors.amber
//                     : customcolor.blue.withOpacity(0.15),
//                 shape: BoxShape.circle,
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.only(bottom: 3),
//                 child: Text(
//                   "$rank",
//                   style: TextStyle(
//                     color: rank == 1
//                         ? Colors.black
//                         : customcolor.blue,
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     fontFamily:
//                         GoogleFonts.playfairDisplay().fontFamily,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _stat(
//     String title,
//     int value,
//     bool isTop,
//     Color dotColor,
//   ) {
//     return Row(
//       children: [
//         Container(
//           height: 9,
//           width: 9,
//           decoration: BoxDecoration(
//             color: dotColor,
//             shape: BoxShape.circle,
//           ),
//         ),

//         const SizedBox(width: 8),

//         Expanded(
//           child: Text(
//             title,
//             style: TextStyle(
//               fontSize: 14,
//               color: isTop
//                   ? Colors.white70
//                   : Colors.black54,
//             ),
//           ),
//         ),

//         Text(
//           "$value%",
//           style: TextStyle(
//             fontSize: 15,
//             fontWeight: FontWeight.w700,
//             color:
//                 isTop ? Colors.white : Colors.black,
//           ),
//         ),
//       ],
//     );
//   }
// }