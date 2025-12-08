// ignore_for_file: use_super_parameters

import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:janpro/Utitlity/AppDrawer.dart';
import 'package:janpro/Utitlity/custom_color.dart';
import 'package:janpro/Utitlity/customBottomNavigationBar.dart';
import 'package:janpro/Utitlity/SPManager.dart';
import 'package:janpro/Utitlity/appbar.dart';
import 'package:janpro/Screens/Homepage.dart';
import 'package:janpro/Utitlity/sizeConfig.dart';
import 'package:page_transition/page_transition.dart';
import '../Utitlity/APIManager.dart';
import '../Utitlity/GlobalLists.dart';
import '../Utitlity/ResponsiveFlutter.dart';
import '../Utitlity/ShowDialog.dart';
import '../Utitlity/internetConnection.dart';
import '../model/CardVisitView.dart';
import '../model/OperationVisitView.dart';
import 'operation_visit_page.dart';
import '../model/CardVisitView.dart' as viewcard;

class ClientOperationVisitCard extends StatefulWidget {
  var client_id;
  var site_id;
  ClientOperationVisitCard(
      {super.key, required this.client_id, required this.site_id});

  @override
  State<ClientOperationVisitCard> createState() =>
      _ClientOperationVisitCardState();
}

class _ClientOperationVisitCardState extends State<ClientOperationVisitCard> {
  String? roles = "0";
  String? role = "0";

  TextEditingController siteNameController = TextEditingController();
  TextEditingController visitTypeController = TextEditingController();

  bool isExpandedSite = false;
  bool isExpandedVisitType = false;

  String? selectedSite;
  String? selectedVisitType = "Current Month";

  List<dynamic> filteredVisits = [];
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    getRole();
  }

  getRole() async {
    roles = await SPManager().getroleid();
    await visitview();

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _filterVisitsByMonthRange("Current Month");
    // });
  }

  final GlobalKey<State> _viewoperation = GlobalKey<State>();
  final GlobalKey<ScaffoldState> _scaffoldKey2 = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => HomePage(),
          ),
        );
        return await false;
      },
      child: Scaffold(
        key: _scaffoldKey2,
        backgroundColor: Colors.grey.shade100,
        bottomNavigationBar: CustomBottomNavigationBar(index: -1),
        floatingActionButton: FloatingActionButton(
          backgroundColor: customcolor.white,
          onPressed: () {
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.fade,
                child: HomePage(),
                duration: const Duration(milliseconds: 300),
              ),
            );
          },
          child: Image.asset(
            "assets/images/greyhome.png",
            color: customcolor.greytext,
            width: 20,
            height: 20,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        endDrawer: Theme(
          data: Theme.of(context).copyWith(
              canvasColor: customcolor.blue, primaryColor: customcolor.blue),
          child: AppDrawerfilter(roles.toString()),
        ),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(148),
          child: AppbarComman(
            setStyleStr: 'Visit Records',
            onPressedBack: () {},
            onPressedNotify: () {},
            onPressedSearch: () {},
            onPressedSort: () {},
            onPressedmenu: () {
              _scaffoldKey2.currentState!.openEndDrawer();
            },
          ),
        ),
        body:isVisitViewLoad?Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: customcolor.blue,),
            SizedBox(height: 15),
                Text("Loading, please wait...",
                    style: TextStyle(
                        color:   Colors.black))
          ],
        )): Padding(
          padding: const EdgeInsets.all(10.0),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                              onTap: () {
                                Navigator.pop(
                                  context,
                                  // PageRouteBuilder(
                                  //   pageBuilder:
                                  //       (context, animation1, animation2) =>
                                  //           HomePage(),
                                  // ),
                                );
                              },
                              child: Icon(Icons.arrow_back)),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            child: Text(
                              "Operation Visits",
                              style: AppFonts.headerStyle(
                                  fontSize: ResponsiveFlutter.of(context)
                                      .fontSize(2.3),
                                  color: customcolor.black,
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(30),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (_) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Container(
                                    constraints: BoxConstraints(maxHeight: 300),
                                    padding: const EdgeInsets.all(10),
                                    child: ListView(
                                      shrinkWrap: true,
                                      children: [
                                        "Current Month",
                                        "Last 3 Months",
                                        "Last 6 Months",
                                        "Last 9 Months",
                                        "Last 12 Months",
                                      ].map((filter) {
                                        final isSelected =
                                            filter == selectedVisitType;
                                        final color = isSelected
                                            ? customcolor.tabblue
                                            : customcolor.blue;

                                        return ListTile(
                                          title: Text(
                                            filter,
                                            style: TextStyle(
                                              color: color,
                                              fontWeight: isSelected
                                                  ? FontWeight.bold
                                                  : FontWeight.w500,
                                              fontSize: 14,
                                            ),
                                          ),
                                          trailing: isSelected
                                              ? Icon(
                                                  Icons.check_circle,
                                                  color: customcolor.tabblue,
                                                  size: 18,
                                                )
                                              : null,
                                          onTap: () {
                                            setState(() {
                                              selectedVisitType = filter;

                                              _filterVisitsByMonthRange(filter);
                                            });
                                            Navigator.pop(context);
                                            // ScaffoldMessenger.of(context)
                                            //     .showSnackBar(
                                            //   SnackBar(
                                            //     content:
                                            //         Text("Filter applied: $filter"),
                                            //     duration:
                                            //         const Duration(seconds: 1),
                                            //   ),
                                            // );
                                          },
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: Align(
                            alignment: Alignment.center,
                            child: Container(
                              width: 50,
                              decoration: BoxDecoration(
                                color: customcolor.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: customcolor.white, width: 1.2),
                              ),
                              child: Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: customcolor.tabblue,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: filteredVisits.isEmpty
                        ? const Center(child: Text('No Visit Record'))
                        : ListView.builder(
                            itemCount: filteredVisits.length,
                            itemBuilder: (context, index) {
                              final visit = filteredVisits[index];

                              return Card(
                                elevation: 3,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                // shape: RoundedRectangleBorder(
                                //   borderRadius: BorderRadius.circular(12),
                                // ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          if (visit.supportingImage != null &&
                                              visit.supportingImage!
                                                  .isNotEmpty) {
                                                    showimage(context, "Operation Visits",visit.supportingImage);
        //                                     showDialog(
        //                                       context: context,
        //                                       builder: (ctx) =>
        //                                       AlertDialog(
        //                                      //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        //   scrollable: true,
        //   title: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       Text("Operation Visits"),
        //       GestureDetector(
        //           onTap: () {
        //             Navigator.pop(context);
        //           },
        //           child: Icon(Icons.close))
        //     ],
        //   ),
        //   content: SingleChildScrollView(
        //     //MUST TO ADDED

        //     physics: NeverScrollableScrollPhysics(),
        //     child: Container(
        //       height: SizeConfig.blockSizeVertical * 30,
        //       width: double.maxFinite,
        //       child: ListView(
        //         shrinkWrap: true,
        //         physics: ScrollPhysics(),
        //         // mainAxisSize: MainAxisSize.min,
        //         children: [
                
        //          Image.network(
               
        //            visit.supportingImage!,
        //             height: SizeConfig.blockSizeVertical * 30,
        //            fit: BoxFit.cover,
        //            errorBuilder: (ctx, error,
        //                    stackTrace) =>
        //                Container(
        //             height: SizeConfig.blockSizeVertical * 30,
        //              color:
        //                  Colors.grey.shade200,
        //              child: const Icon(
        //                  Icons.broken_image,
        //                  size: 40,
        //                  color: Colors.grey),
        //            ),
        //          )
        //         ],
        //       ),
        //     ),
        //   ),
        // ),
                                            
        //                                     );
                                          }
                                        },
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: (visit.supportingImage ==
                                                      null ||
                                                  visit
                                                      .supportingImage!.isEmpty)
                                              ? Container(
                                                  width: 70,
                                                  height: 70,
                                                  color: Colors.grey.shade200,
                                                  child: const Icon(
                                                      Icons.image_not_supported,
                                                      color: Colors.grey,
                                                      size: 32),
                                                )
                                              :
                                              Image.network(
  visit.supportingImage!,
  width: 70,
  height: 70,
  fit: BoxFit.cover,
  loadingBuilder: (context, child, loadingProgress) {
    if (loadingProgress == null) {
      //      Image loaded successfully
      return child;
    } else {
      // 🌀 While loading, show a loader
      return Container(
        width: 70,
        height: 70,
        alignment: Alignment.center,
        color: Colors.grey.shade100,
        child: const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2,color: customcolor.blue,),
        ),
      );
    }
  },
  errorBuilder: (context, error, stackTrace) => Container(
    width: 70,
    height: 70,
    color: Colors.grey.shade200,
    alignment: Alignment.center,
    child: const Icon(
      Icons.broken_image,
      color: Colors.grey,
      size: 32,
    ),
  ),
)

                                              //  Image.network(
                                              //     visit.supportingImage!,
                                              //     width: 70,
                                              //     height: 70,
                                              //     fit: BoxFit.cover,
                                              //     errorBuilder: (context, error,
                                              //             stackTrace) =>
                                              //         Container(
                                              //       width: 70,
                                              //       height: 70,
                                              //       color: Colors.grey.shade200,
                                              //       child: const Icon(
                                              //           Icons.broken_image,
                                              //           color: Colors.grey,
                                              //           size: 32),
                                              //     ),
                                              //   ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                visit.proposeRemark ?? "NA",
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: customcolor.blue,
                                                ),
                                              ),
                                              const SizedBox(height: 6),
                                              ((roles ==
                                                              GlobalLists
                                                                  .clientrole ||
                                                          roles ==
                                                              GlobalLists
                                                                  .reginalmanagerrole) &&
                                                      visit.empName != null)
                                                  ? Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                          Row(
                                                            children: [
                                                              Text(
                                                                visit.empName ??
                                                                    "NA",
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 13,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color:
                                                                      customcolor
                                                                          .blue,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    '(${visit.emp_type_str})',
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: customcolor
                                                                          .blue,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                              height: 6),
                                                        ])
                                                  : SizedBox(),
                                              Row(
                                                children: [
                                                  const Icon(
                                                      Icons
                                                          .calendar_today_outlined,
                                                      size: 14,
                                                      color: Colors.grey),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    visit.date != null
                                                        ? formatDate(visit.date)
                                                        : "N/A",
                                                    style: const TextStyle(
                                                        color: Colors.black87,
                                                        fontSize: 13),
                                                  ),
                                                  const SizedBox(width: 12),
                                                  const Icon(
                                                      Icons
                                                          .access_time_outlined,
                                                      size: 14,
                                                      color: Colors.grey),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    visit.time != null
                                                        ? formatTime(visit.time)
                                                        : "N/A",
                                                    style: const TextStyle(
                                                        color: Colors.black87,
                                                        fontSize: 13),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 6),
                                              const SizedBox(height: 6),
                                              visit.visitRemarks == null ||
                                                      visit
                                                          .visitRemarks!.isEmpty
                                                  ? SizedBox()
                                                  : _ExpandableRemark(
                                                      remark:
                                                          visit.visitRemarks!),
                                            ]),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
              if (roles == GlobalLists.operationmanagerrole ||
                  roles == GlobalLists.operationrole)
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OperationVisitPage(roles)),
                        );
                      },
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const Text("Add Visit",
                          style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: customcolor.blue,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        elevation: 6,
                      ),
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  void filterCurrentMonthVisits() {
    final now = DateTime.now();
    final currentMonth = now.month;
    final currentYear = now.year;

    print("📅 Filtering visits for: $currentMonth/$currentYear");
    print("🧾 Total visits before filter: ${GlobalLists.visitview.length}");

    setState(() {
      filteredVisits = GlobalLists.visitview.where((visit) {
        final date = visit.date;

        if (date == null) {
          print("⚠️ Skipping visit with null date: id=${visit.id}");
          return false;
        }

        final visitMonth = date.month;
        final visitYear = date.year;
        final isMatch =
            (visitMonth == currentMonth && visitYear == currentYear);

        print("🕓 Visit ID ${visit.id} → Date: $date → Match: $isMatch");

        return isMatch;
      }).toList();

      print(
          "📊 Filtered visits count (current month): ${filteredVisits.length}");
    });
  }

  void _filterVisitsByMonthRange(String range) {
    final now = DateTime.now();
    int monthsBack = 0;

    switch (range) {
      case "Last 3 Months":
        monthsBack = 3;
        break;
      case "Last 6 Months":
        monthsBack = 6;
        break;
      case "Last 9 Months":
        monthsBack = 9;
        break;
      case "Last 12 Months":
        monthsBack = 12;
        break;
      default:
        monthsBack = 0;
    }

    final startDate = DateTime(now.year, now.month - monthsBack, 1);
    final endDate = DateTime(now.year, now.month + 1, 0);

    print("🧮 Filtering visits from $startDate → $endDate ($range)");

    final List<viewcard.Datum> allVisits = GlobalLists.visitview;
    final List<viewcard.Datum> result = [];

    for (var visit in allVisits) {
      if (visit.date != null) {
        final visitDate = visit.date!;
        if (visitDate.isAfter(startDate.subtract(const Duration(days: 1))) &&
            visitDate.isBefore(endDate.add(const Duration(days: 1)))) {
          result.add(visit);
        }
      }
    }

    setState(() {
      filteredVisits = result;
      selectedVisitType = range;
    });

    print("📊 Filtered ${filteredVisits.length} visits for $range");
    if (filteredVisits.isEmpty) {
      ShowDialogs.showToast("No visits found for $range");
    }
  }
  
  void showimage(
  BuildContext context,
  String title,
  String? resultvalue,
 
) {
  showDialog(
    context: context,
    builder: (_) {
      return Dialog(
        insetPadding: const EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDialogHeader(context, title),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                   (resultvalue != null &&
                        resultvalue.isNotEmpty &&
                        resultvalue != "null")?
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: GestureDetector(
                          onTap: () =>
                              _showFullImageDialog(context, resultvalue, ""),
                          child: _buildThumbnail(resultvalue, ""),
                        ),
                      ): Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Center(child: Text("No Image Uploaded")),
                      ),
                  
                 
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
Widget _buildThumbnail(String url, String? label) {
  return Stack(
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          url,
          width: 250, // Consistent size across dialogs
          height: 180,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;
            return const Center(child: CircularProgressIndicator());
          },
          errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.broken_image, size: 100),
        ),
      ),
      if (label != null && label.isNotEmpty)
        Positioned(
          top: 8,
          left: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.8),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ),
    ],
  );
}

Widget _buildDialogHeader(BuildContext context, String title) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      GestureDetector(
        onTap: () => Navigator.pop(context),
        child: const Icon(Icons.close),
      ),
    ],
  );
}
Future<Size> _getImageSize(String url) async {
  final completer = Completer<Size>();
  final image = Image.network(url);
  image.image.resolve(const ImageConfiguration()).addListener(
    ImageStreamListener((info, _) {
      completer.complete(Size(
        info.image.width.toDouble(),
        info.image.height.toDouble(),
      ));
    }),
  );
  return completer.future;
}
void _showFullImageDialog(BuildContext context, String imageUrl, String label) {
  showDialog(
    context: context,
    builder: (_) => Dialog(
      insetPadding: const EdgeInsets.all(10),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDialogHeader(context, "Operation Visits"),
            const SizedBox(height: 12),
            FutureBuilder<Size>(
              future: _getImageSize(imageUrl),
              builder: (context, snapshot) {
                final screenWidth = MediaQuery.of(context).size.width;
                final screenHeight = MediaQuery.of(context).size.height;

                double displayHeight = screenHeight * 0.6;

                if (snapshot.hasData) {
                  final imgSize = snapshot.data!;
                  final aspectRatio = imgSize.width / imgSize.height;

                  // height = width / aspectRatio
                  displayHeight = screenWidth / aspectRatio;

                  // Limit height so dialog fits on screen
                  if (displayHeight > screenHeight * 0.85) {
                    displayHeight = screenHeight * 0.85;
                  }
                }

                return Container(
                  width: double.infinity, // FULL WIDTH
                  height: displayHeight,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Stack(
                      children: [
                        InteractiveViewer(
                          panEnabled: true,
                          minScale: 1,
                          maxScale: 4,
                          child: Image.network(
                            imageUrl,
                            width: double.infinity, // full width
                            height: displayHeight,
                            fit: BoxFit.cover, // fills width nicely
                            errorBuilder: (context, error, stackTrace) =>
                                const Center(
                              child: Icon(Icons.broken_image,
                                  size: 100, color: Colors.grey),
                            ),
                          ),
                        ),
                        if (label.isNotEmpty)
                          Positioned(
                            top: 12,
                            left: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                label,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    ),
  );
}
// void _showFullImageDialog(BuildContext context, String imageUrl, String label) {
//   showDialog(
//     context: context,
//     builder: (_) => Dialog(
//       insetPadding: const EdgeInsets.all(10),
//       child: LayoutBuilder(
//         builder: (context, constraints) {
//           final maxHeight = MediaQuery.of(context).size.height * 0.6;
//           final maxWidth = MediaQuery.of(context).size.width * 0.9;

//           return ConstrainedBox(
//             constraints: BoxConstraints(maxHeight: maxHeight, maxWidth: maxWidth),
//             child: Padding(
//               padding: const EdgeInsets.all(12),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   _buildDialogHeader(context, "Operation Visits"),
//                   const SizedBox(height: 16),
//                   Expanded(
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(8),
//                       child: Stack(
//                         children: [
//                           InteractiveViewer(
//                             panEnabled: true,
//                             minScale: 1,
//                             maxScale: 4,
//                             child: Image.network(
//                               imageUrl,
//                               fit: BoxFit.contain,
//                               width: maxWidth,
//                               errorBuilder: (context, error, stackTrace) =>
//                                   const Icon(Icons.broken_image, size: 100),
//                             ),
//                           ),
//                           if (label.isNotEmpty)
//                             Positioned(
//                               top: 12,
//                               left: 12,
//                               child: Container(
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 8, vertical: 4),
//                                 decoration: BoxDecoration(
//                                   color: Colors.green.withOpacity(0.8),
//                                   borderRadius: BorderRadius.circular(6),
//                                 ),
//                                 child: Text(
//                                   label,
//                                   style: const TextStyle(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     ),
//   );
// }


  String formatTime(String time24) {
    try {
      final parsedTime = DateFormat("HH:mm").parse(time24);
      return DateFormat("hh:mm a").format(parsedTime);
    } catch (e) {
      return time24;
    }
  }

  String formatDate(dynamic date) {
    try {
      final parsedDate =
          date is String ? DateTime.parse(date) : date as DateTime;
      return DateFormat('dd MMM yyyy').format(parsedDate);
    } catch (e) {
      return date.toString();
    }
  }
bool isVisitViewLoad=false;
  visitview() async {
    var status1 = await ConnectionDetector.checkInternetConnection();
    role = await SPManager().getsupervisorid();

    if (status1) {
      // ShowDialogs.showLoadingDialog(context, _viewoperation);
      setState(() {
        isVisitViewLoad=true;
      });
      String today = DateTime.now()
          .toLocal()
          .toString()
          .split(' ')[0]
          .split('-')
          .reversed
          .join('-'); // dd-MM-yyyy
      var map = new Map<String, dynamic>();
      map['client_id'] = widget.client_id.toString();
      map['site_id'] = widget.site_id.toString();
      APIManager().apiRequest(context, API.cardvisitview, (response) async {
        CardVisitView resp = response;
        if (resp.status == 1) {
          setState(() {
            GlobalLists.visitview = resp.data ?? [];
            // filteredVisits = GlobalLists.visitview;
          });
          filterCurrentMonthVisits();
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _filterVisitsByMonthRange("Current Month");
          });
          // Navigator.pop(context);
   setState(() {
        isVisitViewLoad=false;
      });
      
        } else {
          ShowDialogs.showToast(resp.msg.toString());
           setState(() {
        isVisitViewLoad=false;
      });
          // Navigator.pop(context);
        }
      }, (error) {
         setState(() {
        isVisitViewLoad=false;
      });
        // Navigator.pop(context);

      }, false, "", jsonval: map);
    } else {
      ShowDialogs.showToast("Please check internet connection");
    }
  }
}

class _ExpandableRemark extends StatefulWidget {
  final String remark;
  const _ExpandableRemark({Key? key, required this.remark}) : super(key: key);

  @override
  State<_ExpandableRemark> createState() => _ExpandableRemarkState();
}

class _ExpandableRemarkState extends State<_ExpandableRemark> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final bool isLong = widget.remark.length > 90; // adjust as needed

    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.note_alt_outlined,
              size: 14,
              color: Colors.grey,
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                widget.remark,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 13,
                ),
                maxLines: isExpanded ? null : 2,
                overflow:
                    isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        if (isLong)
          GestureDetector(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 18.0, top: 2),
              child: Text(
                isExpanded ? "Show less" : "Read more",
                style: TextStyle(
                  color: Colors.blue.shade700,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
