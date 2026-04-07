import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:janpro/Utitlity/custom_color.dart';

class SupervisorRankingSection extends StatelessWidget {
  const SupervisorRankingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Header
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     Row(
        //       children: [
        //         // 4
        //         Padding(
        //           padding: const EdgeInsets.only(left: 4,top: 8),
        //           child: Text(
        //             "SUPERVISOR RANKINGS",
        //             style: TextStyle(
        //               fontSize: 16,
        //               fontWeight: FontWeight.bold,
        //               color: customcolor.black
        //             ),
        //           ),
        //         ),
        //       ],
        //     ),
            
        //     Container(
        //       padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        //       decoration: BoxDecoration(
        //         color: Color(0xffE8EEF9),
        //         borderRadius: BorderRadius.circular(20),
        //       ),
        //       child: Text(
        //         "March 2026",
        //         style: TextStyle(fontSize: 12),
        //       ),
        //     )
        //   ],
        // ),

        //  SizedBox(height: 21),

        // Padding(
        //   padding: const EdgeInsets.only(left: 10),
        //   child: Text(
        //     "Ranked by workflow completion + attendance · Resets monthly",
        //     style: TextStyle(fontSize: 13, color: Colors.black),
        //   ),
        // ),

         SizedBox(height: 15),

        /// Horizontal Cards
       SizedBox(
  height: 190, // 🔥 increased from 170
  child: ListView(
    scrollDirection: Axis.horizontal,
    children: const [
      RankingCard(
        rank: 1,
        name: "Rajesh Kumar",
        location: "Andheri site",
        workflow: 94,
        attendance: 98,
        score: 96,
      ),
      RankingCard(
        rank: 2,
        name: "Priya Mehta",
        location: "Bandra site",
        workflow: 88,
        attendance: 92,
        score: 90,
      ),
      RankingCard(
        rank: 3,
        name: "Amit Shah",
        location: "Powai site",
        workflow: 81,
        attendance: 89,
        score: 85,
      ),
    ],
  ),
)
      ],
    );
  }
}
class RankingCard extends StatelessWidget {
  final int rank;
  final String name;
  final String location;
  final int workflow;
  final int attendance;
  final int score;

  const RankingCard({
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

    return Container(
      width: 230, // 🔥 wider like design
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: isTop
            ? const LinearGradient(
                colors: [Color(0xff1E56B3), Color(0xff2F6FE4)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: isTop ? null : const Color(0xffF7F7F7),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Avatar
                // Container(
                //   height: 50,
                //   width: 56,
                //   decoration: BoxDecoration(
                //     color: isTop
                //         ? Colors.white.withOpacity(0.2)
                //         : const Color(0xffCFE8D1),
                //     borderRadius: BorderRadius.circular(16),
                //   ),
                //   alignment: Alignment.center,
                //   child: Padding(
                //     padding: const EdgeInsets.only(top: 8),
                //     child: Text(
                //       name.substring(0, 2).toUpperCase(),
                //       style: TextStyle(
                //         fontSize: 18,
                //         fontWeight: FontWeight.bold,
                //         color: isTop ? Colors.white : Colors.green[800],
                //       ),
                //     ),
                //   ),
                // ),

                const SizedBox(height: 5),

                /// Name
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 18, // 🔥 bigger like screenshot
                    fontWeight: FontWeight.w600,
                    color: isTop ? Colors.white : Colors.black,
                  ),
                ),

                const SizedBox(height: 4),

                /// Location
                Text(
                  location,
                  style: TextStyle(
                    fontSize: 12,
                    color: isTop ? Colors.white70 : Colors.grey,
                  ),
                ),

                const SizedBox(height: 16),

                /// Workflow
                _stat("Workflow", workflow, isTop, Colors.green),

                const SizedBox(height: 6),

                /// Attendance
                _stat("Attendance", attendance, isTop, Colors.orange),

                const Spacer(),

                /// Progress bar full width
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: score / 100,
                    minHeight: 8,
                    backgroundColor:
                        isTop ? Colors.white24 : Colors.grey.shade300,
                    valueColor: AlwaysStoppedAnimation(
                      isTop ? Colors.greenAccent : Colors.blue,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                /// Score aligned right
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Score",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isTop ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "$score",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isTop ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),

          /// 🔥 Floating Rank Badge (like screenshot)
        Positioned(
  top: 16,
  right: 16,
  child: Container(
    height: 38,
    width: 38,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: rank == 1
          ? Colors.amber
          : customcolor.blue.withOpacity(0.2),
      shape: BoxShape.circle, // 🔥 THIS makes it circle
    ),
    child: Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        "# $rank", // ❗ remove #
        style: TextStyle(
          color: rank == 1 ? Colors.black : customcolor.blue,
          fontSize: 20,
          fontFamily:  GoogleFonts.playfairDisplay().fontFamily,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ),
),
        ],
      ),
    );
  }

  Widget _stat(String title, int value, bool isTop, Color dotColor) {
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
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 13,
              color: isTop ? Colors.white70 : Colors.black54,
            ),
          ),
        ),
        Text(
          "$value%",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isTop ? Colors.white : Colors.black,
          ),
        )
      ],
    );
  }
}