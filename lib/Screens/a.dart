
// class ViewAttendanceRoster extends StatefulWidget {
//   final List<dynamic> attendanceRosterData;
//   final String month;
//   final String year;
//   final int attendancesiteid;
//   var attendanceclientid;
//   var attendanceshiftid;
//   final String role;
//   int maintag;

//   ViewAttendanceRoster({
//     required this.attendanceRosterData,
//     required this.month,
//     required this.year,
//     required this.attendancesiteid,
//     required this.attendanceclientid,
//     required this.role,
//     required this.maintag,
//     required this.attendanceshiftid,
//   });

//   @override
//   _ViewAttendanceRosterState createState() => _ViewAttendanceRosterState();
// }

// class _ViewAttendanceRosterState extends State<ViewAttendanceRoster> {
//   String month = '';
//   String year = '';
//   int? selectedYear;
//   int? selectedMonthIndex;
//   dynamic selectedShift;
//   int maintag = 0;
//   Set<String> selectedCells = {};
//   bool multiSelectMode = false;
//   bool isBulkMode = false;
//   Set<String> selectedEmployees = {};
//   var attendanceshiftid;
//   var is_month_end;
//   var is_final_submit;
//   // NEW: Multi-date selection
//   Set<String> selectedDates = {};
//   bool isDateSelectionMode = false;

//   // Bulk operation state
//   String? bulkSelectedDate;
//   String? bulkAttendanceStatus;
//   bool bulkHasOT = false;
//   bool _isreasonshow = false;
//   String bulkOTHours = '';
//   dynamic sup_final_submitted_v;
//   final GlobalKey<ScaffoldState> _scaffoldKey1 = new GlobalKey<ScaffoldState>();
// bool isDownloading = false;
// String? downloadedFilePath;
//   final List<String> monthNames = [
//     '',
//     'January',
//     'February',
//     'March',
//     'April',
//     'May',
//     'June',
//     'July',
//     'August',
//     'September',
//     'October',
//     'November',
//     'December',
//   ];

//   final List<String> monthNamesShort = [
//     '',
//     'JAN',
//     'FEB',
//     'MAR',
//     'APR',
//     'MAY',
//     'JUN',
//     'JUL',
//     'AUG',
//     'SEP',
//     'OCT',
//     'NOV',
//     'DEC',
//   ];

//   final List<int> availableYears = [2026, 2025];

//   Map<String, List<dynamic>> groupedByMonth = {};
//   var role;

//   getrole() async {
//     role = await SPManager().getroleid();
//     await _fetchAttendanceRoster();
//   }

//   var attendancesiteid;
//   var attendanceclientid;
//   List<dynamic> _attendanceRosterData = [];

//   @override
//   void initState() {
//     maintag = widget.maintag;
//     attendancesiteid = widget.attendancesiteid;
//     attendanceclientid = widget.attendanceclientid;
//     // attendanceshiftid=widget.attendanceshiftid;
//     print("RUCHITA  attendanceclientid ${attendanceclientid}");
//     getrole();
//     final now = DateTime.now();

//     if (now.month == 1) {
//       selectedMonthIndex = 12;
//       selectedYear = now.year - 1;
//     } else {
//       selectedMonthIndex = now.month - 1;
//       selectedYear = now.year;
//     }

//     super.initState();
//   }

//   @override
//   void dispose() {
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitUp,
//       DeviceOrientation.portraitDown,
//     ]);
//     super.dispose();
//   }

//   String _isSelected = "";

//   bool _isLoad = false;
//   bool isAttendanceLoaded = false;
//   bool _isLandscap = false;

//   _fetchAttendanceRoster() async {
//     log('is supervisor ${role == GlobalLists.supervisorrole}');
//     try {
//       var status1 = await ConnectionDetector.checkInternetConnection();
//       if (!status1) {
//         ShowDialogs.showToast("Please check internet connection");
//         return;
//       }

//       final now = DateTime.now();
//       if ((month == null || month.isEmpty) && (year == null || year.isEmpty)) {
//         DateTime previousMonth = DateTime(now.year, now.month - 1);

//         month = previousMonth.month.toString().padLeft(2, '0');
//         year = previousMonth.year.toString();
//       }

//       int selectedMonth = int.parse(month);
//       int selectedYear = int.parse(year);

//       final firstDayOfMonth = DateTime(selectedYear, selectedMonth, 1);
//       final lastDayOfMonth = DateTime(selectedYear, selectedMonth + 1, 0);

//       var map = {
//         'site_id': attendancesiteid.toString(),
//         'from_date': DateFormat('yyyy-MM-dd').format(firstDayOfMonth),
//         'to_date': DateFormat('yyyy-MM-dd').format(lastDayOfMonth),
//         "month": "$month",
//         "year": "$year",
//       };

//       // log('map view ${map}');

//       // showDialog(
//       //   context: context,
//       //   barrierDismissible: false,
//       //   builder: (context) => Center(child: CircularProgressIndicator()),
//       // );
// setState(() {
//   isAttendanceLoaded=true;
//   _isLoad = true;
// });
//       APIManager().apiRequest(
//         context,
//         role == GlobalLists.supervisorrole
//             ? API.sup_attendance_roster
//             : API.attendance_roster,
//         (response) async {
//           try {
//             if (response == null) {
//               ShowDialogs.showToast('Received null response from server');
//               return;
//             }

//             AttendanceRosterResponse rosterResponse;

//             if (response is AttendanceRosterResponse) {
//               rosterResponse = response;
//             } else if (response is Map<String, dynamic>) {
//               rosterResponse = AttendanceRosterResponse.fromJson(response);
//             } else if (response is String) {
//               final responseMap = json.decode(response) as Map<String, dynamic>;
//               rosterResponse = AttendanceRosterResponse.fromJson(responseMap);
//             } else {
//               throw Exception('Unexpected response type');
//             }

//             if (rosterResponse.status == "success") {
//                 GlobalLists.downloadRosterLink=rosterResponse.monthly_roster_report;
//               setState(() {
//                 _isLoad = true;
//                 _attendanceRosterData = rosterResponse.data;
//                 print("RUCHI TAT ${_attendanceRosterData.length}");
//                 isAttendanceLoaded=false;
//               });
//               // Navigator.pop(context);
//             } else {
//               ShowDialogs.showToast(rosterResponse.msg);
//             }
//           } catch (e) {
//             setState(() {
//   _isLoad = false;
//   isAttendanceLoaded=false;
// });
//             log('Error parsing response: $e');
//             ShowDialogs.showToast('Error processing data: ${e.toString()}');
//           }
//         },
//         (error) {
//           log('Error: ${error.toString()}');
//           ShowDialogs.showToast('Error: ${error.toString()}');
//       setState(() {
//   _isLoad = false;
//   isAttendanceLoaded=false;
// });
//         },
//         false,
//         "",
//         jsonval: map,
//       );
//     } catch (e) {
//       setState(() {
//   _isLoad = false;
//   isAttendanceLoaded=false;
// });
//       ShowDialogs.showToast('An error occurred');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {

//     String getMonthYear(String date) {
//       final parts = date.split('-');
//       final month = int.parse(parts[1]);
//       final year = parts[0];
//       return '${monthNames[month]} $year';
//     }

//     DateTime getMonthYearDate(String monthYear) {
//       final parts = monthYear.split(' ');
//       final monthIndex = monthNames.indexOf(parts[0]);
//       final year = int.parse(parts[1]);
//       return DateTime(year, monthIndex);
//     }

// int currentMonth = int.tryParse(month) ?? DateTime.now().month -1;
// int currentYear = int.tryParse(year) ?? DateTime.now().year;
   
//     final Map<String, List<dynamic>> groupedByMonth = {};
//     for (var shift in _attendanceRosterData) {
//       log('shift id ${shift.id}');
//       final monthsInShift = <String>{};

//       for (var emp in shift.employeeList) {
//         for (var att in emp.attendData) {
//           final monthYear = getMonthYear(att.date);
//           monthsInShift.add(monthYear);
//         }
//       }

//       if (monthsInShift.isEmpty) {
//         monthsInShift.add('${monthNames[currentMonth]} $currentYear');
//       }

//       for (var monthYear in monthsInShift) {
//         groupedByMonth.putIfAbsent(monthYear, () => []);
//         if (!groupedByMonth[monthYear]!.contains(shift)) {
//           groupedByMonth[monthYear]!.add(shift);
//         }
//       }
//     }

//     if (selectedYear == null) {
//       selectedYear = int.parse(year);
//     }
//     String selectedMonth = '${monthNames[currentMonth]}';

//     void _reloadDataForMonthYear(String newMonth, int newYear) {
//       final monthName = newMonth.split(' ')[0];
//       final monthIndex = monthNames.indexOf(monthName);
//       month = monthIndex.toString().padLeft(2, '0');
//       year = newYear.toString();
//       _fetchAttendanceRoster();
//     }

//     final availableMonths = groupedByMonth.keys.toList()
//       ..sort((a, b) => getMonthYearDate(a).compareTo(getMonthYearDate(b)));

//     if (!availableMonths.contains(selectedMonth) &&
//         availableMonths.isNotEmpty) {
//       selectedMonth = availableMonths[0];
//     }

//     dynamic selectedShift = groupedByMonth[selectedMonth]?.isNotEmpty == true
//         ? groupedByMonth[selectedMonth]![0]
//         : null;

//     if (selectedMonthIndex == null) {
//       selectedMonthIndex = currentMonth;
//     }

//     final shifts = groupedByMonth[selectedMonth] ?? [];

//     // Calculate statistics with OT from global storage
//     int presentCount = 0;
//     int absentCount = 0;
//     int hoildayCount = 0;
//     int hlfdayCount = 0;
//     int whoildayCount = 0;

//     double otHours = 0;
//     int pendingCount = 0;
//   bool _isDownloading = false;
//   bool _downloaded = false;
//   String? _filePath;


//     if (selectedShift != null) {
//       for (var emp in selectedShift.employeeList ?? []) {
//         for (var att in emp.attendData ?? []) {
//           if (att.attendance_type == 'P') presentCount++;
//           if (att.attendance_type == 'A') absentCount++;
//           if (att.attendance_type == 'W') whoildayCount++;
//           if (att.attendance_type == 'F') hlfdayCount++;
//           if (att.attendance_type == 'H') hoildayCount++;

//           // Check global OT storage first, then fall back to server data
//           final globalOT = OTHoursManager().getOTHours(
//             emp.empId.toString(),
//             att.date,
//           );
//           if (globalOT != null) {
//             otHours += globalOT;
//           } else if (att.ot_hours != null) {
//             otHours += att.ot_hours ?? 0;
//           }
//         }
//       }
//     }

    
//         return Scaffold(
//           backgroundColor: Color(0xFFFAFBFC),
//           key: _scaffoldKey1,
//           endDrawer: Theme(
//             data: Theme.of(context).copyWith(
//               canvasColor: customcolor.blue,
//               primaryColor: customcolor.blue,
//             ),
//             child: AppDrawerfilter(role),
//           ),
//           resizeToAvoidBottomInset: false,
//           appBar: PreferredSize(
//             preferredSize: Size.fromHeight(148),
//             child: AppbarComman(
//               setStyleStr: 'View Attendance Roster',
//               onPressedBack: () {},
//               onPressedNotify: () {},
//               onPressedSearch: () {},
//               onPressedSort: () {},
//               onPressedmenu: () {
//                 _scaffoldKey1.currentState!.openEndDrawer();
//               },
//             ),
//           ),
//           body: CustomRefreshIndicator(
//                key: refreshIndicatorKey,
//       builder: (
//         BuildContext context,
//         Widget child,
//         IndicatorController controller,
//       ) {
//         return Stack(
//           alignment: Alignment.topCenter,
//           children: <Widget>[
//             if (!controller.isIdle)
//               Positioned(
//                 top: 35.0 * controller.value,
//                 child: SizedBox(
//                   height: 30,
//                   width: 30,
//                   child: CircularProgressIndicator(
//                     value: !controller.isLoading
//                         ? controller.value.clamp(0.0, 1.0)
//                         : null,
//                   ),
//                 ),
//               ),
//             Transform.translate(
//               offset: Offset(0, 100.0 * controller.value),
//               child: child,
//             ),
//           ],
//         );
//       },
//       onRefresh: refreshData,
//             child: SafeArea(
//               child:  (isAttendanceLoaded)?Center(child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   CircularProgressIndicator(color: customcolor.blue,),
//                   SizedBox(height: 15),
//                       Text("Loading, please wait...",
//                           style: TextStyle(
//                               color:   Colors.black))
//                 ],
//               )): _attendanceRosterData.isEmpty
//                 ? Center(
//                     child: Text(
//                       "No data available",
//                       style: TextStyle(color: Colors.grey),
//                     ),
//                   )
//                 :  Stack(
//                 children: [
//                 Column(
//                     children: [
//                       // Header with dark background
//                       Container(
//                         decoration: BoxDecoration(
//                           // color: customcolor.blue,
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             // Top header with title and month navigation
//                             Padding(
//                               padding: EdgeInsets.all(12),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Row(
//                                     children: [
//                                       IconButton(
//                                         icon: Icon(
//                                           Icons.arrow_back,
//                                           color: Colors.black,
//                                         ),
//                                         onPressed: () => Navigator.pop(context),
//                                         padding: EdgeInsets.zero,
//                                         constraints: BoxConstraints(),
//                                       ),
//                                       SizedBox(width: 12),
//                                       Text(
//                                         'Team Roster',
//                                         style: AppFonts.headerStyle(
//                                           fontSize: ResponsiveFlutter.of(
//                                             context,
//                                           ).fontSize(2.3),
//                                           // color: customcolor.white,
//                                           fontWeight: FontWeight.w300,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
                    
//                                   Row(
//                                     children: [
//                                       // Month Dropdown
//                                       GestureDetector(
//                                         onTap: () => _showMonthPicker(
//                                           context,
//                                           selectedMonthIndex ?? int.parse(month),
//                                         ),
//                                         child: Card(
//                                           shape: RoundedRectangleBorder(
//                                             borderRadius: BorderRadius.circular(20),
//                                           ),
                    
//                                           elevation: 1,
//                                           child: Container(
//                                             padding: EdgeInsets.symmetric(
//                                               horizontal: 10,
//                                               vertical: 6,
//                                             ),
                    
//                                             child: Row(
//                                               mainAxisSize: MainAxisSize.min,
//                                               children: [
//                                                 Text(
//                                                   monthNamesShort[selectedMonthIndex ??
//                                                       int.parse(month)],
//                                                   style: TextStyle(
//                                                     color: Colors.black,
//                                                     fontSize: 13,
//                                                     fontWeight: FontWeight.w600,
//                                                   ),
//                                                 ),
//                                                 SizedBox(width: 4),
//                                                 Icon(
//                                                   Icons.arrow_drop_down,
//                                                   color: customcolor.blue,
//                                                   size: 18,
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                       SizedBox(width: 8),
//                                       // Year Dropdown
//                                       GestureDetector(
//                                         onTap: () => _showYearPicker(
//                                           context,
//                                           selectedYear ?? int.parse(year),
//                                         ),
//                                         child: Card(
//                                           shape: RoundedRectangleBorder(
//                                             borderRadius: BorderRadius.circular(20),
//                                           ),
//                                           child: Container(
//                                             padding: EdgeInsets.symmetric(
//                                               horizontal: 10,
//                                               vertical: 6,
//                                             ),
                    
//                                             child: Row(
//                                               mainAxisSize: MainAxisSize.min,
//                                               children: [
//                                                 Text(
//                                                   '${selectedYear ?? int.parse(year)}',
//                                                   style: TextStyle(
//                                                     // color: Colors.white,
//                                                     fontSize: 13,
//                                                     fontWeight: FontWeight.w600,
//                                                   ),
//                                                 ),
//                                                 SizedBox(width: 4),
//                                                 Icon(
//                                                   Icons.arrow_drop_down,
//                                                   color: customcolor.blue,
//                                                   size: 18,
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       ),
                    
//                                       SizedBox(width: 10),
//                                       GlobalLists.mainlisttab.isNotEmpty
//                                           ? _buildChoicemainListfortab()
//                                           : Container(),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
                    
//                             selectedShift?.employeeList?.isEmpty ||
//                                     GlobalLists.supervisorrole != role &&
//                                         !selectedShift.sup_final_submitted
//                                 ? SizedBox()
//                                 : Padding(
//                                     padding: const EdgeInsets.only(
//                                       left: 10,
//                                       right: 10,
//                                       bottom: 8,
//                                     ),
//                                     child: Row(
//                                       children: [
//                                         // Landscape / Portrait toggle
//                                         !_isLandscap
//                                             ? ElevatedButton.icon(
//                                                 style: ElevatedButton.styleFrom(
//                                                   backgroundColor: customcolor.blue,
//                                                   shape: RoundedRectangleBorder(
//                                                     borderRadius:
//                                                         BorderRadius.circular(12),
//                                                   ),
//                                                 ),
//                                                 onPressed: () {
//                                                   setState(() => _isLandscap = true);
//                                                   SystemChrome.setPreferredOrientations(
//                                                     [
//                                                       DeviceOrientation.landscapeLeft,
//                                                       DeviceOrientation
//                                                           .landscapeRight,
//                                                     ],
//                                                   );
//                                                 },
//                                                 icon: Icon(
//                                                   Icons.screen_rotation,
//                                                   color: Colors.white,
//                                                   size: 16,
//                                                 ),
//                                                 label: Text(
//                                                   'Landscape',
//                                                   style: TextStyle(
//                                                     color: Colors.white,
//                                                   ),
//                                                 ),
//                                               )
//                                             : ElevatedButton.icon(
//                                                 style: ElevatedButton.styleFrom(
//                                                   backgroundColor: customcolor.blue,
//                                                   shape: RoundedRectangleBorder(
//                                                     borderRadius:
//                                                         BorderRadius.circular(12),
//                                                   ),
//                                                 ),
//                                                 onPressed: () {
//                                                   setState(() => _isLandscap = false);
//                                                   SystemChrome.setPreferredOrientations(
//                                                     [DeviceOrientation.portraitUp],
//                                                   );
//                                                 },
//                                                 icon: Icon(
//                                                   Icons.stay_current_portrait,
//                                                   color: Colors.white,
//                                                   size: 16,
//                                                 ),
//                                                 label: Text(
//                                                   'Portrait',
//                                                   style: TextStyle(
//                                                     color: Colors.white,
//                                                   ),
//                                                 ),
//                                               ),
                    
//                                         SizedBox(width: 10),
                    
//                                         // Bulk mode toggle — moved here from FAB
//                                         GlobalLists.supervisorrole == role &&
//                                                     selectedShift
//                                                         .sup_final_submitted ||
//                                                 selectedShift?.is_month_end == 1 &&
//                                                     selectedShift
//                                                             ?.is_final_submitted ==
//                                                         true
//                                             ? SizedBox()
//                                             : ElevatedButton.icon(
//                                                 style: ElevatedButton.styleFrom(
//                                                   backgroundColor: isBulkMode
//                                                       ? Colors.red
//                                                       : customcolor.blue,
//                                                   shape: RoundedRectangleBorder(
//                                                     borderRadius:
//                                                         BorderRadius.circular(12),
//                                                   ),
//                                                 ),
//                                                 onPressed: () {
//                                                   if (GlobalLists.supervisorrole ==
//                                                           role &&
//                                                       selectedShift
//                                                           .sup_final_submitted) {
//                                                     log(
//                                                       'disable ${selectedShift.employeeList.length}',
//                                                     );
                    
//                                                     log(
//                                                       'disable ${selectedShift.sup_final_submitted}',
//                                                     );
                    
//                                                     return;
//                                                   }
                    
//                                                   setState(() {
//                                                     isBulkMode = !isBulkMode;
//                                                     if (!isBulkMode)
//                                                       selectedEmployees.clear();
//                                                   });
//                                                 },
//                                                 icon: Icon(
//                                                   isBulkMode
//                                                       ? Icons.close
//                                                       : Icons.people,
//                                                   color: Colors.white,
//                                                   size: 16,
//                                                 ),
//                                                 label: Text(
//                                                   isBulkMode
//                                                       ? 'Cancel Bulk'
//                                                       : 'Bulk Mark',
//                                                   style: TextStyle(
//                                                     color: Colors.white,
//                                                   ),
//                                                 ),
//                                               ),
                    
//                                         Row(
//                                           mainAxisSize: MainAxisSize.min,
//                                           children: [
//                                             IconButton(
//                                               icon: Icon(
//                                                 Icons.info_outline,
//                                                 color: customcolor.blue,
//                                               ),
//                                               tooltip: "View reasons",
//                                               onPressed: () {
//                                                 Dailogbox().showLegendDialog(context);
//                                               },
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ),
                    
//                             // Stats bar
//                             _isLandscap ||
//                                     selectedShift?.employeeList?.isEmpty ||
//                                     GlobalLists.supervisorrole != role &&
//                                         !selectedShift.sup_final_submitted
//                                 ? SizedBox()
//                                 : Container(
//                                     padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
//                                     child: SingleChildScrollView(
//                                       scrollDirection: Axis.horizontal,
//                                       child: Row(
//                                         children: [
//                                           _buildStatChip(
//                                             '$presentCount',
//                                             'Present',
//                                             customcolor.blue,
//                                           ),
//                                           SizedBox(width: 10),
//                                           _buildStatChip(
//                                             '$absentCount',
//                                             'Absent',
//                                             customcolor.blue,
//                                           ),
                    
//                                           SizedBox(width: 10),
//                                           _buildStatChip(
//                                             '$hoildayCount',
//                                             'Holiday',
//                                             customcolor.blue,
//                                           ),
//                                           SizedBox(width: 10),
//                                           _buildStatChip(
//                                             '$whoildayCount',
//                                             'Working Holiday',
//                                             customcolor.blue,
//                                           ),
//                                           SizedBox(width: 10),
//                                           _buildStatChip(
//                                             '$hlfdayCount',
//                                             'Halfday',
//                                             customcolor.blue,
//                                           ),
//                                           SizedBox(width: 10),
                    
//                                           _buildStatChip(
//                                             '${otHours.toStringAsFixed(1)}',
//                                             'OT Hrs',
//                                             customcolor.blue,
//                                           ),
//                                           SizedBox(width: 10),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                           ],
//                         ),
//                       ),
                    
//                       // Bulk Mode Banner
//                       if (isBulkMode)
//                         Container(
//                           padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                           decoration: BoxDecoration(
//                             gradient: LinearGradient(
//                               colors: [customcolor.blue, Color(0xFFA855F7)],
//                             ),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: customcolor.blue.withOpacity(0.3),
//                                 blurRadius: 8,
//                                 offset: Offset(0, 2),
//                               ),
//                             ],
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Row(
//                                 children: [
//                                   Text(
//                                     '✓',
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 18,
//                                     ),
//                                   ),
//                                   SizedBox(width: 12),
//                                   Container(
//                                     padding: EdgeInsets.symmetric(
//                                       horizontal: 12,
//                                       vertical: 4,
//                                     ),
//                                     decoration: BoxDecoration(
//                                       color: Colors.white.withOpacity(0.2),
//                                       borderRadius: BorderRadius.circular(20),
//                                     ),
//                                     child: Text(
//                                       '${selectedEmployees.length} employee${selectedEmployees.length != 1 ? 's' : ''}',
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontWeight: FontWeight.w700,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               Row(
//                                 children: [
//                                   _buildBulkButton('Cancel', false),
//                                   SizedBox(width: 8),
//                                   _buildBulkButton('Mark', true),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
                    
//                       // Employee Cards
//                       Expanded(
//                         child: selectedShift?.employeeList?.isEmpty ?? true
//                             ? Center(
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Icon(
//                                       Icons.people_outline,
//                                       size: 64,
//                                       color: Colors.grey[400],
//                                     ),
//                                     SizedBox(height: 16),
//                                     Text(
//                                       "No janitor assigned",
//                                       style: TextStyle(
//                                         fontSize: 16,
//                                         color: Colors.grey[600],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               )
//                             : role != GlobalLists.supervisorrole &&
//                                   (selectedShift.sup_final_submitted == false ||
//                                       selectedShift.sup_final_submitted == null)
//                             ? Center(
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Icon(
//                                       Icons.people_outline,
//                                       size: 64,
//                                       color: Colors.grey[400],
//                                     ),
//                                     SizedBox(height: 16),
//                                     Text(
//                                       "Attendance roster is not finalized yet.",
//                                       style: TextStyle(
//                                         fontSize: 16,
//                                         color: Colors.grey[600],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               )
//                             :
//                             ListView.builder(
//                                 padding: EdgeInsets.only(top: 12, bottom: 80),
//                                 itemCount: selectedShift?.employeeList?.length ?? 0,
//                                 itemBuilder: (context, index) {
//                                   is_final_submit = selectedShift.is_final_submitted;
//                                   is_month_end = selectedShift.is_month_end;
//                                   sup_final_submitted_v =
//                                       selectedShift.sup_final_submitted;
//                                   final emp = selectedShift.employeeList[index];
                    
//                                   final isSelected = selectedEmployees.contains(
//                                     emp.empId.toString(),
//                                   );
                    
//                                   return _buildEmployeeCard(emp, isSelected);
//                                 },
//                               ),
//                       ),
//                     ],
//                   ),
                    
//                   ((role == GlobalLists.unitrole ||role == GlobalLists.operationmanagerrole ||
//                               role == GlobalLists.operationrole) &&
//                           selectedShift?.is_final_submitted == false &&
//                           selectedShift.review_updated_by_client == false)
//                       ? SizedBox()
//                       : isCurrentMonthYear(selectedMonthIndex!, selectedYear!)
//                       ? SizedBox()
//                       : selectedShift?.employeeList.isEmpty ||
//                             selectedShift?.employeeList.length == 0 ||
//                             GlobalLists.supervisorrole != role &&
//                                 selectedShift.sup_final_submitted == false ||
//                             selectedEmployees.isNotEmpty
//                       ? SizedBox()
//                       : GlobalLists.supervisorrole == role &&
//                             !selectedShift.sup_final_submitted
//                       ? Padding(
//                           padding: const EdgeInsets.only(
//                             top: 8,
//                             bottom: 12,
//                             right: 12,
//                             left: 12,
//                           ),
//                           child: Align(
//                             alignment: Alignment.bottomCenter,
//                             child: ElevatedButton(
//                               onPressed: () {
//                                 if (GlobalLists.supervisorrole == role &&
//                                     selectedShift.sup_final_submitted) {
//                                   ShowDialogs.showToast(
//                                     "Roster is already finalized.",
//                                   );
                    
//                                   return;
//                                 }
                    
//                                 _showRosterLockDialog(context);
//                               },
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: customcolor.blue,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                                 minimumSize: Size(double.infinity, 48),
//                               ),
//                               child: Text(
//                                 GlobalLists.supervisorrole == role &&
//                                         selectedShift.sup_final_submitted
//                                     ? "Roster finalize"
//                                     : "Submit",
//                                 style: TextStyle(
//                                   fontFamily: AppFonts.semibold,
//                                   fontSize: 16,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         )
//                       : 
//                       Padding(
//             padding: const EdgeInsets.only(
//                     top: 8,
//                     bottom: 12,
//                     right: 12,
//                     left: 12,
//             ),
//             child: Align(
//                     alignment: Alignment.bottomCenter,
//                     child: ElevatedButton(
//             onPressed: () async {
//               // --- If file already downloaded, open it ---
//               if (downloadedFilePath != null) {
//                 if(Platform.isAndroid)
//                 {await OpenFilex.open(downloadedFilePath!);
                    
//                 }else{
//                   _openFileOptions(downloadedFilePath!);
//                 }
                
//                 return;
//               }
                    
//               // --- Supervisor / Operation roles ---
//               if ((role == GlobalLists.unitrole || GlobalLists.supervisorrole == role ||
//                       GlobalLists.operationmanagerrole == role ||
//                       GlobalLists.operationrole == role) &&
//                   selectedShift.sup_final_submitted &&
//                   selectedShift.is_final_submitted == false &&
//                   selectedShift.review_updated_by_client) {
//                 if (selectedShift?.is_month_end == 1 &&
//                     selectedShift?.is_final_submitted == false &&
//                     selectedCells.isEmpty &&
//                     !multiSelectMode &&
//                     role == GlobalLists.clientrole &&
//                     selectedShift.review_updated_by_oe_om == false &&
//                     selectedShift.review_updated_by_client == false) {
//                   _submitAttendaceRosterfinal(selectedShift.id.toString());
//                 } else {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => ViewRemarkAttendance(
//                         month: month,
//                         year: year,
//                         attendancesiteid: attendancesiteid,
//                         clientid: attendanceclientid,
//                         manTag: maintag,
//                         shiftId: selectedShift?.id,
//                       ),
//                     ),
//                   );
//                 }
//                 return;
//               }
                    
//               // --- Supervisor downloading finalized roster ---
//               if (GlobalLists.supervisorrole == role &&
//                   selectedShift.sup_final_submitted &&
//                   selectedShift.is_final_submitted) {
//                 await _downloadRoster(selectedShift.id.toString());
//                 return;
//               }
                    
//               // --- Month-end download for finalized roster ---
//               if (selectedShift?.is_month_end == 1 &&
//                   selectedShift?.is_final_submitted == true) {
//                 await _downloadRoster(selectedShift.id.toString());
//                 return;
//               }
                    
//               // --- Client approval conditions ---
//               if (role == GlobalLists.clientrole &&
//                   selectedShift?.review_updated_by_oe_om == false &&
//                   selectedShift.review_updated_by_client == false) {
//                 if (selectedShift?.is_month_end == 1 &&
//                     selectedShift?.is_final_submitted == false &&
//                     selectedCells.isEmpty &&
//                     !multiSelectMode &&
//                     role == GlobalLists.clientrole &&
//                     selectedShift.review_updated_by_oe_om == false &&
//                     selectedShift.review_updated_by_client == false) {
//                   _submitAttendaceRosterfinal(selectedShift.id.toString());
//                 } else {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => ViewRemarkAttendance(
//                         month: month,
//                         year: year,
//                         attendancesiteid: attendancesiteid,
//                         clientid: attendanceclientid,
//                         manTag: maintag,
//                         shiftId: selectedShift?.id,
//                       ),
//                     ),
//                   );
//                 }
//                 return;
//               }
                    
//               // --- Client reviewing discrepancies ---
//               if (role == GlobalLists.clientrole &&
//                   selectedShift.review_updated_by_client) {
//                 if (selectedShift?.is_month_end == 1 &&
//                     selectedShift?.is_final_submitted == false &&
//                     selectedCells.isEmpty &&
//                     !multiSelectMode &&
//                     role == GlobalLists.clientrole &&
//                     selectedShift.review_updated_by_oe_om == false &&
//                     selectedShift.review_updated_by_client == false) {
//                   _submitAttendaceRosterfinal(selectedShift.id.toString());
//                 } else {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => ViewRemarkAttendance(
//                         month: month,
//                         year: year,
//                         attendancesiteid: attendancesiteid,
//                         clientid: attendanceclientid,
//                         manTag: maintag,
//                         shiftId: selectedShift?.id,
//                       ),
//                     ),
//                   );
//                 }
//                 return;
//               }
                    
//               // --- Supervisor submitted but no action ---
//               if (GlobalLists.supervisorrole == role &&
//                   selectedShift.sup_final_submitted) {
//                 return;
//               }
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: (downloadedFilePath != null)
//                   ? customcolor.blue
//                   : (GlobalLists.supervisorrole == role &&
//                           selectedShift.sup_final_submitted &&
//                           selectedShift.is_final_submitted)
//                       ? customcolor.blue
//                       : (selectedShift?.is_month_end == 1 &&
//                               selectedShift?.is_final_submitted == true)
//                           ? customcolor.blue
//                           : (GlobalLists.supervisorrole == role &&
//                                   selectedShift.sup_final_submitted)
//                               ? Colors.grey
//                               : customcolor.blue,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               minimumSize: Size(double.infinity, 40),
//             ),
//             child: isDownloading
//                 ? Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       SizedBox(
//                         height: 20,
//                         width: 20,
//                         child: CircularProgressIndicator(
//                           color: Colors.white,
//                           strokeWidth: 2,
//                         ),
//                       ),
//                       SizedBox(width: 12),
//                       Text("Downloading...",
//                           style: TextStyle(
//                               fontFamily: AppFonts.semibold,
//                               fontSize: 16,
//                               color: Colors.white)),
//                     ],
//                   )
//                 : Text(
//                     (downloadedFilePath != null)
//                         ? "View Download"
//                         : (GlobalLists.supervisorrole == role &&
//                                 selectedShift.sup_final_submitted &&
//                                 selectedShift.is_final_submitted)
//                             ? "Download Roster"
//                             : (GlobalLists.supervisorrole == role &&
//                                     selectedShift.sup_final_submitted &&
//                                     selectedShift.is_final_submitted == false &&
//                                     selectedShift.review_updated_by_client)
//                                 ? "Review Discrepancy"
//                                 : (GlobalLists.supervisorrole == role &&
//                                         selectedShift.sup_final_submitted)
//                                     ? "Submitted to Client"
//                                     : (role == GlobalLists.clientrole &&
//                                             selectedShift.review_updated_by_client &&
//                                             selectedShift.is_final_submitted)
//                                         ?"Finalized Roster"
//                                         : (role == GlobalLists.clientrole &&
//                                                 selectedShift?.review_updated_by_oe_om ==
//                                                     true &&
//                                                 selectedShift.is_final_submitted ==
//                                                     false)
//                                             ? "Review Updates"
//                                             : (role == GlobalLists.clientrole &&
//                                                     selectedShift.review_updated_by_client)
//                                                 ? "Review Discrepancy"
//                                                 : selectedShift?.is_month_end == 1 &&
//                                                         selectedShift?.is_final_submitted ==
//                                                             true
//                                                     ? "Download Roster ${selectedShift?.is_final_submitted}"
//                                                     : selectedCells.isNotEmpty &&
//                                                             multiSelectMode
//                                                         ? "Review Discrepancy"
//                                                         : role ==
//                                                                     GlobalLists
//                                                                         .clientrole &&
//                                                                 selectedShift
//                                                                         ?.review_updated_by_oe_om ==
//                                                                     false &&
//                                                                 selectedShift.review_updated_by_client ==
//                                                                     false
//                                                             ? "Approve Roster"
//                                                             : "Review Discrepancy",
//                     style: TextStyle(
//                       fontFamily: AppFonts.semibold,
//                       fontSize: 16,
//                       color: Colors.white,
//                     ),
//                   ),
//                     ),
//             ),
//                     ),
                    
                    
//                 ],
//               ),
//             ),
//           ),
//         );
      
//   }
// void _openFileOptions(String filePath) {
//   showModalBottomSheet(
//     context: context,
//     builder: (context) {
//       return SafeArea(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ListTile(
//               leading: Icon(Icons.open_in_new),
//               title: Text("Open File"),
//               onTap: () async {
//                 Navigator.pop(context);
//                 await OpenFilex.open(filePath);
//               },
//             ),
            
//           ],
//         ),
//       );
//     },
//   );
// }

//   Widget _buildEmployeeCard(dynamic emp, bool isSelected) {
   
//     final allDates = <String>[];
//     for (var att in emp.attendData ?? []) {
      
//       allDates.add(att.date);
//     }
//     allDates.sort();

//     // Calculate summary with global OT storage
//     int presentCount = 0;
//     int absentCount = 0;
//     int hoildayCount = 0;
//     int hlfdayCount = 0;
//     int whoildayCount = 0;
//     double otHours = 0;

//     for (var att in emp.attendData ?? []) {
//       if (att.attendance_type == 'P') presentCount++;
//       if (att.attendance_type == 'A') absentCount++;
//       if (att.attendance_type == 'W') whoildayCount++;
//       if (att.attendance_type == 'F') hlfdayCount++;
//       if (att.attendance_type == 'H') hoildayCount++;

//       // Check global storage first
//       final globalOT = OTHoursManager().getOTHours(
//         emp.empId.toString(),
//         att.date,
//       );
//       if (globalOT != null) {
//         otHours += globalOT;
//       } else if (att.ot_hours != null) {
//         otHours += att.ot_hours ?? 0;
//       }
//     }

//     return GestureDetector(
//       onTap: () {
//         if (isBulkMode) {
//           setState(() {
//             if (isSelected) {
//               selectedEmployees.remove(emp.empId.toString());
//             } else {
//               selectedEmployees.add(emp.empId.toString());
//             }

//             log('selectedEmployees${selectedEmployees}');
//           });
//         }
//       },
//       child: Container(
//         margin: EdgeInsets.fromLTRB(12, 0, 12, 12),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           border: isSelected
//               ? Border.all(color: customcolor.blue, width: 3)
//               : null,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.08),
//               blurRadius: 3,
//               offset: Offset(0, 1),
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // Employee Header
//             Container(
//               padding: EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                   colors: [Color(0xFFF8FAFC), Color(0xFFF1F5F9)],
//                 ),
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(12),
//                   topRight: Radius.circular(12),
//                 ),
//                 border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
//               ),
//               child: Stack(
//                 children: [
//                   Row(
//   crossAxisAlignment: CrossAxisAlignment.start,
//   children: [
//     /// LEFT (Employee Info)
//     Expanded(
//       flex: 3,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text(
//             emp.empName,
//             style: TextStyle(
//               fontSize: 15,
//               fontWeight: FontWeight.w700,
//               color: Color(0xFF0F172A),
//             ),
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//           ),
//           SizedBox(height: 2),
//           Text(
//             emp.empId.toString(),
//             style: TextStyle(
//               fontSize: 11,
//               color: Color(0xFF64748B),
//             ),
//           ),
//         ],
//       ),
//     ),

//     SizedBox(width: 8),

//     /// CENTER (Stats)
//     Expanded(
//       flex: 3,
//       child: SingleChildScrollView( // ✅ prevents overflow
//         scrollDirection: Axis.horizontal,
//         child: Row(
//           children: [
//             _buildSummaryItem(presentCount.toString(), 'P', Color(0xFF22C55E)),
//             SizedBox(width: 10),
//             _buildSummaryItem(absentCount.toString(), 'A', Color(0xFFEF4444)),
//             SizedBox(width: 10),
//             _buildSummaryItem(hoildayCount.toString(), 'H', Color(0xFF7DD3FC)),
//             SizedBox(width: 10),
//             _buildSummaryItem(whoildayCount.toString(), 'W', Color(0xFF2563EB)),
//             SizedBox(width: 10),
//             _buildSummaryItem(hlfdayCount.toString(), 'F', Color(0xFF4ADE80)),
//             SizedBox(width: 10),
//             _buildSummaryItem(otHours.toStringAsFixed(1), 'OT', customcolor.blue),
//           ],
//         ),
//       ),
//     ),

//     SizedBox(width: 2),

//     /// RIGHT (Eye Icon)
  
//    GestureDetector(
//  onTap: () {
 
// _showReasonDialog(
//   context,
//   attendData: emp.attendData,
//   clientReasonList: emp.clientReasonList,
// );
  
// },
//   child: Icon(
//                                           Icons.info_outline,
//                                           color: customcolor.blue,
//                                         ),
// )
//   ],
// )
                 
//                 ],
//               ),
//             ),

//             // Timeline Container - Horizontal Scroll
//             Container(
//               height: 135,
//               padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//               child: SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Row(
//                   children: allDates.map((date) {
//                     return _buildDateColumn(emp, date);
//                   }).toList(),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
 
//   _fredgeAttendaceRoster() async {
//     try {
//       var status1 = await ConnectionDetector.checkInternetConnection();
//       if (!status1) {
//         ShowDialogs.showToast("Please check internet connection");
//         return;
//       }

//       String currentDate = DateTime.now().toIso8601String().split('T').first;

//       var supervisorid = await SPManager().getsupervisorid();
//       final now = DateTime.now();

//       if ((month == null || month.isEmpty) && (year == null || year.isEmpty)) {
//         if (now.month == 1) {
//           month = "12";
//           year = (now.year - 1).toString();
//         } else {
//           month = now.month.toString().padLeft(2, '0');
//           year = now.year.toString();
//         }
//       }

//       int selectedMonth = int.parse(month);
//       int selectedYear = int.parse(year);

//       final firstDayOfMonth = DateTime(selectedYear, selectedMonth, 1);
//       final lastDayOfMonth = DateTime(selectedYear, selectedMonth + 1, 0);

//       // Prepare the map according to API requirements
//       var map = {
//         'site_id': attendancesiteid.toString(),
//         'client_id': GlobalLists.clientid,
//         // 'from_date': DateFormat('yyyy-MM-dd').format(firstDayOfMonth),
//         // 'to_date': DateFormat('yyyy-MM-dd').format(lastDayOfMonth),
//         "month": "$month",
//         "year": "$year",
//       };

//       log(' API Request Data: ${jsonEncode(map)}');

//       await APIManager().apiRequest(
//         context,
//         API.supervisor_submit_attendance_rooster,
//         (response) async {
//           // Close loading dialog

//           FridgeAttendanceRosterResponse resp = response;
//           // log(' API Response: ${resp.status} - ${resp.msg}');

//           if (resp.status == 1) {
//             ShowDialogs.showToast('${resp.msg}');
//             //  Navigator.pop(context);
//             _fetchAttendanceRoster();
//           } else {
//             ShowDialogs.showToast('${resp.msg}');
//           }
//         },
//         (error) {
//           Navigator.pop(context); // Close loading dialog
//           log(' Error submitting attendance: $error');
//           ShowDialogs.showToast('Error: $error');
//         },
//         false,
//         "",
//         jsonval: map,
//       );
//     } catch (e) {
//       log(' Exception in _submitAttendaceRoster: $e');
//       ShowDialogs.showToast('Exception: $e');
//     }
//   }
// }

