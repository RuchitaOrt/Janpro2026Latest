// ignore_for_file: unnecessary_null_comparison, no_leading_underscores_for_local_identifiers, unused_local_variable, unnecessary_string_interpolations, must_be_immutable, prefer_typing_uninitialized_variables, use_key_in_widget_constructors, library_private_types_in_public_api, curly_braces_in_flow_control_structures, prefer_conditional_assignment, unused_element, strict_top_level_inference, deprecated_member_use, unused_field, unnecessary_brace_in_string_interps
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:janpro/Screens/Attendance.dart';
import 'package:janpro/Screens/view_remark_attendance.dart';
import 'package:janpro/Utitlity/APIManager.dart';
import 'package:janpro/Utitlity/AppDrawer.dart';
import 'package:janpro/Utitlity/GlobalLists.dart';
import 'package:janpro/Utitlity/ResponsiveFlutter.dart';
import 'package:janpro/Utitlity/SPManager.dart';
import 'package:janpro/Utitlity/ShowDialog.dart';
import 'package:janpro/Utitlity/appbar.dart';
import 'package:janpro/Utitlity/custom_color.dart';
import 'package:janpro/Utitlity/downloadRoster.dart';
import 'package:janpro/Utitlity/internetConnection.dart';
import 'package:janpro/model/FridgeAttendanceRosterResponse.dart';
import 'package:janpro/model/SubmitAttendanceRooster.dart';
import 'package:janpro/model/attendance_roster_response.dart';
import 'package:flutter/services.dart';
import 'package:janpro/widgets/dailogbox.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

// Global OT Hours Storage
class OTHoursManager {
  static final OTHoursManager _instance = OTHoursManager._internal();
  factory OTHoursManager() => _instance;
  OTHoursManager._internal();

  // Store OT hours: Map<empId, Map<date, hours>>
  Map<String, Map<String, double>> otHoursData = {};

  void setOTHours(String empId, String date, double hours) {
    if (!otHoursData.containsKey(empId)) {
      otHoursData[empId] = {};
    }
    otHoursData[empId]![date] = hours;
    log(' OT Saved: Employee $empId, Date $date, Hours $hours');
    log('Total stored OT entries: ${otHoursData.length} employees');
  }

  double? getOTHours(String empId, String date) {
    final hours = otHoursData[empId]?[date];
    if (hours != null) {
      print('📖 OT Retrieved: Employee $empId, Date $date, Hours $hours');
    }
    return hours;
  }

  void clearOTHours(String empId, String date) {
    otHoursData[empId]?.remove(date);
    print('🗑️ OT Cleared: Employee $empId, Date $date');
  }

  void clearAllForEmployee(String empId) {
    otHoursData.remove(empId);
  }

  void printAllOTData() {
    if (otHoursData.isEmpty) {
      print('   (No OT data stored)');
    } else {
      otHoursData.forEach((empId, dates) {
        print('   Employee $empId:');
        dates.forEach((date, hours) {
          print('      $date: ${hours.toStringAsFixed(1)} hours');
        });
      });
    }
  }
}

class ViewAttendanceRoster extends StatefulWidget {
  final List<dynamic> attendanceRosterData;
  final String month;
  final String year;
  final int attendancesiteid;
  var attendanceclientid;
  var attendanceshiftid;
  final String role;
  int maintag;

  ViewAttendanceRoster({
    required this.attendanceRosterData,
    required this.month,
    required this.year,
    required this.attendancesiteid,
    required this.attendanceclientid,
    required this.role,
    required this.maintag,
    required this.attendanceshiftid,
  });

  @override
  _ViewAttendanceRosterState createState() => _ViewAttendanceRosterState();
}

class _ViewAttendanceRosterState extends State<ViewAttendanceRoster> {
  String month = '';
  String year = '';
  int? selectedYear;
  int? selectedMonthIndex;
  dynamic selectedShift;
  int maintag = 0;
  Set<String> selectedCells = {};
  bool multiSelectMode = false;
  bool isBulkMode = false;
  Set<String> selectedEmployees = {};
  var attendanceshiftid;
  var is_month_end;
  var is_final_submit;
  // NEW: Multi-date selection
  Set<String> selectedDates = {};
  bool isDateSelectionMode = false;

  // Bulk operation state
  String? bulkSelectedDate;
  String? bulkAttendanceStatus;
  bool bulkHasOT = false;
  bool _isreasonshow = false;
  String bulkOTHours = '';
  dynamic sup_final_submitted_v;
  final GlobalKey<ScaffoldState> _scaffoldKey1 = new GlobalKey<ScaffoldState>();
bool isDownloading = false;
String? downloadedFilePath;
  final List<String> monthNames = [
    '',
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  final List<String> monthNamesShort = [
    '',
    'JAN',
    'FEB',
    'MAR',
    'APR',
    'MAY',
    'JUN',
    'JUL',
    'AUG',
    'SEP',
    'OCT',
    'NOV',
    'DEC',
  ];

  final List<int> availableYears = [2026, 2025];

  Map<String, List<dynamic>> groupedByMonth = {};
  var role;

  getrole() async {
    role = await SPManager().getroleid();
    await _fetchAttendanceRoster();
  }

  var attendancesiteid;
  var attendanceclientid;
  List<dynamic> _attendanceRosterData = [];

  @override
  void initState() {
    maintag = widget.maintag;
    attendancesiteid = widget.attendancesiteid;
    attendanceclientid = widget.attendanceclientid;
    // attendanceshiftid=widget.attendanceshiftid;
    print("RUCHITA  attendanceclientid ${attendanceclientid}");
    getrole();
    final now = DateTime.now();

    if (now.month == 1) {
      selectedMonthIndex = 12;
      selectedYear = now.year - 1;
    } else {
      selectedMonthIndex = now.month - 1;
      selectedYear = now.year;
    }

    // _reloadDataForMonth(selectedMonthIndex!);

    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  String _isSelected = "";

  bool _isLoad = false;
  bool isAttendanceLoaded = false;
  bool _isLandscap = false;

  _fetchAttendanceRoster() async {
    log('is supervisor ${role == GlobalLists.supervisorrole}');
    try {
      var status1 = await ConnectionDetector.checkInternetConnection();
      if (!status1) {
        ShowDialogs.showToast("Please check internet connection");
        return;
      }

      final now = DateTime.now();
      if ((month == null || month.isEmpty) && (year == null || year.isEmpty)) {
        DateTime previousMonth = DateTime(now.year, now.month - 1);

        month = previousMonth.month.toString().padLeft(2, '0');
        year = previousMonth.year.toString();
      }

      int selectedMonth = int.parse(month);
      int selectedYear = int.parse(year);

      final firstDayOfMonth = DateTime(selectedYear, selectedMonth, 1);
      final lastDayOfMonth = DateTime(selectedYear, selectedMonth + 1, 0);

      var map = {
        'site_id': attendancesiteid.toString(),
        'from_date': DateFormat('yyyy-MM-dd').format(firstDayOfMonth),
        'to_date': DateFormat('yyyy-MM-dd').format(lastDayOfMonth),
        "month": "$month",
        "year": "$year",
      };

      // log('map view ${map}');

      // showDialog(
      //   context: context,
      //   barrierDismissible: false,
      //   builder: (context) => Center(child: CircularProgressIndicator()),
      // );
setState(() {
  isAttendanceLoaded=true;
  _isLoad = true;
});
      APIManager().apiRequest(
        context,
        role == GlobalLists.supervisorrole
            ? API.sup_attendance_roster
            : API.attendance_roster,
        (response) async {
          try {
            if (response == null) {
              ShowDialogs.showToast('Received null response from server');
              return;
            }

            AttendanceRosterResponse rosterResponse;

            if (response is AttendanceRosterResponse) {
              rosterResponse = response;
            } else if (response is Map<String, dynamic>) {
              rosterResponse = AttendanceRosterResponse.fromJson(response);
            } else if (response is String) {
              final responseMap = json.decode(response) as Map<String, dynamic>;
              rosterResponse = AttendanceRosterResponse.fromJson(responseMap);
            } else {
              throw Exception('Unexpected response type');
            }

            if (rosterResponse.status == "success") {
                GlobalLists.downloadRosterLink=rosterResponse.monthly_roster_report;
              setState(() {
                _isLoad = true;
                _attendanceRosterData = rosterResponse.data;
                isAttendanceLoaded=false;
              });
              // Navigator.pop(context);
            } else {
              ShowDialogs.showToast(rosterResponse.msg);
            }
          } catch (e) {
            setState(() {
  _isLoad = false;
  isAttendanceLoaded=false;
});
            log('Error parsing response: $e');
            ShowDialogs.showToast('Error processing data: ${e.toString()}');
          }
        },
        (error) {
          log('Error: ${error.toString()}');
          ShowDialogs.showToast('Error: ${error.toString()}');
      setState(() {
  _isLoad = false;
  isAttendanceLoaded=false;
});
        },
        false,
        "",
        jsonval: map,
      );
    } catch (e) {
      setState(() {
  _isLoad = false;
  isAttendanceLoaded=false;
});
      ShowDialogs.showToast('An error occurred');
    }
  }
TextEditingController hoursController = TextEditingController();
  var shiftId;
  var clientId;
  var userId;
  var siteId;

  void _reloadDataForMonth(int monthIndex) {
    final monthIndexStr = monthIndex.toString().padLeft(2, '0');
    month = monthIndexStr;
    selectedCells.clear();
    multiSelectMode = false;
    isBulkMode = false;
    selectedEmployees.clear();
    selectedDates.clear();
    isDateSelectionMode = false;

    _fetchAttendanceRoster();
  }
  Future<void> refreshData() async {
    // Simulating an API request or data refresh
    setState(() {
      print("APICall");
      getrole();
    });
  }

  bool isCurrentMonthYear(int selectedMonthIndex, int selectedYear) {
    final now = DateTime.now();

    int currentMonth = now.month; // 1 - 12
    int currentYear = now.year;

    // If your selectedMonthIndex is 0-based (Jan = 0)
    int selectedMonth = selectedMonthIndex;

    return selectedMonth == currentMonth && selectedYear == currentYear;
  }
Future<void> _downloadRoster(String shiftId) async {
  setState(() {
    isDownloading = true;
  });

  try {
    Directory baseDir = await getApplicationDocumentsDirectory();
    String filePath = "${baseDir.path}/roster_$shiftId.pdf";

    Dio dio = Dio();

    print("🚀 Download Start");
    print("👉 URL: ${GlobalLists.downloadRosterLink}");
    print("👉 PATH: $filePath");

    await dio.download(
      GlobalLists.downloadRosterLink,
      filePath,
      onReceiveProgress: (received, total) {
        if (total != -1) {
          print("📥 Progress: ${(received / total * 100).toStringAsFixed(0)}%");
        } else {
          print("📥 Downloading... $received bytes");
        }
      },
    );

    setState(() {
      isDownloading = false;
      downloadedFilePath = filePath;
    });

    print("✅ Download Complete: $filePath");

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Download completed")),
    );

    /// 🔥 Open file
    // await OpenFilex.open(filePath);

  } catch (e) {
    setState(() {
      isDownloading = false;
      downloadedFilePath = null;
    });

    print("💥 Download Error: $e");

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Download failed: $e")),
    );
  }
}
GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  @override
  Widget build(BuildContext context) {
    // if (!mounted || context == null || _attendanceRosterData.isEmpty)
    //   return Scaffold(backgroundColor: Color(0xFFFAFBFC));
// if (!_isLoad) {
//   return Scaffold(
//     backgroundColor: Color(0xFFFAFBFC),
//     body: Center(
//       child: CircularProgressIndicator(
//         color: customcolor.blue,
//       ),
//     ),
//   );
// }


    String getMonthYear(String date) {
      final parts = date.split('-');
      final month = int.parse(parts[1]);
      final year = parts[0];
      return '${monthNames[month]} $year';
    }

    DateTime getMonthYearDate(String monthYear) {
      final parts = monthYear.split(' ');
      final monthIndex = monthNames.indexOf(parts[0]);
      final year = int.parse(parts[1]);
      return DateTime(year, monthIndex);
    }

    //  final firstDayOfMonth = DateTime(selectedYear, selectedMonth, 1);
    //   final lastDayOfMonth = DateTime(selectedYear, selectedMonth + 1, 0);
int currentMonth = int.tryParse(month) ?? DateTime.now().month -1;
int currentYear = int.tryParse(year) ?? DateTime.now().year;
    // int currentMonth = int.parse(month);
    // int currentYear = int.parse(year);

    final Map<String, List<dynamic>> groupedByMonth = {};
    for (var shift in _attendanceRosterData) {
      log('shift id ${shift.id}');
      final monthsInShift = <String>{};

      for (var emp in shift.employeeList) {
        for (var att in emp.attendData) {
          final monthYear = getMonthYear(att.date);
          monthsInShift.add(monthYear);
        }
      }

      if (monthsInShift.isEmpty) {
        monthsInShift.add('${monthNames[currentMonth]} $currentYear');
      }

      for (var monthYear in monthsInShift) {
        groupedByMonth.putIfAbsent(monthYear, () => []);
        if (!groupedByMonth[monthYear]!.contains(shift)) {
          groupedByMonth[monthYear]!.add(shift);
        }
      }
    }

    if (selectedYear == null) {
      selectedYear = int.parse(year);
    }
    String selectedMonth = '${monthNames[currentMonth]}';

    void _reloadDataForMonthYear(String newMonth, int newYear) {
      final monthName = newMonth.split(' ')[0];
      final monthIndex = monthNames.indexOf(monthName);
      month = monthIndex.toString().padLeft(2, '0');
      year = newYear.toString();
      _fetchAttendanceRoster();
    }

    final availableMonths = groupedByMonth.keys.toList()
      ..sort((a, b) => getMonthYearDate(a).compareTo(getMonthYearDate(b)));

    if (!availableMonths.contains(selectedMonth) &&
        availableMonths.isNotEmpty) {
      selectedMonth = availableMonths[0];
    }

    dynamic selectedShift = groupedByMonth[selectedMonth]?.isNotEmpty == true
        ? groupedByMonth[selectedMonth]![0]
        : null;

    if (selectedMonthIndex == null) {
      selectedMonthIndex = currentMonth;
    }

    final shifts = groupedByMonth[selectedMonth] ?? [];

    // Calculate statistics with OT from global storage
    int presentCount = 0;
    int absentCount = 0;
    int hoildayCount = 0;
    int hlfdayCount = 0;
    int whoildayCount = 0;

    double otHours = 0;
    int pendingCount = 0;
  bool _isDownloading = false;
  bool _downloaded = false;
  String? _filePath;


    if (selectedShift != null) {
      for (var emp in selectedShift.employeeList ?? []) {
        for (var att in emp.attendData ?? []) {
          if (att.attendance_type == 'P') presentCount++;
          if (att.attendance_type == 'A') absentCount++;
          if (att.attendance_type == 'W') whoildayCount++;
          if (att.attendance_type == 'F') hlfdayCount++;
          if (att.attendance_type == 'H') hoildayCount++;

          // Check global OT storage first, then fall back to server data
          final globalOT = OTHoursManager().getOTHours(
            emp.empId.toString(),
            att.date,
          );
          if (globalOT != null) {
            otHours += globalOT;
          } else if (att.ot_hours != null) {
            otHours += att.ot_hours ?? 0;
          }
        }
      }
    }

    
        return Scaffold(
          backgroundColor: Color(0xFFFAFBFC),
          key: _scaffoldKey1,
          endDrawer: Theme(
            data: Theme.of(context).copyWith(
              canvasColor: customcolor.blue,
              primaryColor: customcolor.blue,
            ),
            child: AppDrawerfilter(role),
          ),
          resizeToAvoidBottomInset: false,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(148),
            child: AppbarComman(
              setStyleStr: 'View Attendance Roster',
              onPressedBack: () {},
              onPressedNotify: () {},
              onPressedSearch: () {},
              onPressedSort: () {},
              onPressedmenu: () {
                _scaffoldKey1.currentState!.openEndDrawer();
              },
            ),
          ),
          body: CustomRefreshIndicator(
               key: refreshIndicatorKey,
      builder: (
        BuildContext context,
        Widget child,
        IndicatorController controller,
      ) {
        return Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            if (!controller.isIdle)
              Positioned(
                top: 35.0 * controller.value,
                child: SizedBox(
                  height: 30,
                  width: 30,
                  child: CircularProgressIndicator(
                    value: !controller.isLoading
                        ? controller.value.clamp(0.0, 1.0)
                        : null,
                  ),
                ),
              ),
            Transform.translate(
              offset: Offset(0, 100.0 * controller.value),
              child: child,
            ),
          ],
        );
      },
      onRefresh: refreshData,
            child: SafeArea(
              child:  (isAttendanceLoaded)?Center(child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: customcolor.blue,),
                  SizedBox(height: 15),
                      Text("Loading, please wait...",
                          style: TextStyle(
                              color:   Colors.black))
                ],
              )): _attendanceRosterData.isEmpty
                ? Center(
                    child: Text(
                      "No data available",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                :  Stack(
                children: [
                Column(
                    children: [
                      // Header with dark background
                      Container(
                        decoration: BoxDecoration(
                          // color: customcolor.blue,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Top header with title and month navigation
                            Padding(
                              padding: EdgeInsets.all(12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.arrow_back,
                                          color: Colors.black,
                                        ),
                                        onPressed: () => Navigator.pop(context),
                                        padding: EdgeInsets.zero,
                                        constraints: BoxConstraints(),
                                      ),
                                      SizedBox(width: 12),
                                      Text(
                                        'Team Roster',
                                        style: AppFonts.headerStyle(
                                          fontSize: ResponsiveFlutter.of(
                                            context,
                                          ).fontSize(2.3),
                                          // color: customcolor.white,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ],
                                  ),
                    
                                  Row(
                                    children: [
                                      // Month Dropdown
                                      GestureDetector(
                                        onTap: () => _showMonthPicker(
                                          context,
                                          selectedMonthIndex ?? int.parse(month),
                                        ),
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                    
                                          elevation: 1,
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 6,
                                            ),
                    
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  monthNamesShort[selectedMonthIndex ??
                                                      int.parse(month)],
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                SizedBox(width: 4),
                                                Icon(
                                                  Icons.arrow_drop_down,
                                                  color: customcolor.blue,
                                                  size: 18,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      // Year Dropdown
                                      GestureDetector(
                                        onTap: () => _showYearPicker(
                                          context,
                                          selectedYear ?? int.parse(year),
                                        ),
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 6,
                                            ),
                    
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  '${selectedYear ?? int.parse(year)}',
                                                  style: TextStyle(
                                                    // color: Colors.white,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                SizedBox(width: 4),
                                                Icon(
                                                  Icons.arrow_drop_down,
                                                  color: customcolor.blue,
                                                  size: 18,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                    
                                      SizedBox(width: 10),
                                      GlobalLists.mainlisttab.isNotEmpty
                                          ? _buildChoicemainListfortab()
                                          : Container(),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                    
                            selectedShift?.employeeList?.isEmpty ||
                                    GlobalLists.supervisorrole != role &&
                                        !selectedShift.sup_final_submitted
                                ? SizedBox()
                                : Padding(
                                    padding: const EdgeInsets.only(
                                      left: 10,
                                      right: 10,
                                      bottom: 8,
                                    ),
                                    child: Row(
                                      children: [
                                        // Landscape / Portrait toggle
                                        !_isLandscap
                                            ? ElevatedButton.icon(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: customcolor.blue,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(12),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  setState(() => _isLandscap = true);
                                                  SystemChrome.setPreferredOrientations(
                                                    [
                                                      DeviceOrientation.landscapeLeft,
                                                      DeviceOrientation
                                                          .landscapeRight,
                                                    ],
                                                  );
                                                },
                                                icon: Icon(
                                                  Icons.screen_rotation,
                                                  color: Colors.white,
                                                  size: 16,
                                                ),
                                                label: Text(
                                                  'Landscape',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              )
                                            : ElevatedButton.icon(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: customcolor.blue,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(12),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  setState(() => _isLandscap = false);
                                                  SystemChrome.setPreferredOrientations(
                                                    [DeviceOrientation.portraitUp],
                                                  );
                                                },
                                                icon: Icon(
                                                  Icons.stay_current_portrait,
                                                  color: Colors.white,
                                                  size: 16,
                                                ),
                                                label: Text(
                                                  'Portrait',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                    
                                        SizedBox(width: 10),
                    
                                        // Bulk mode toggle — moved here from FAB
                                        GlobalLists.supervisorrole == role &&
                                                    selectedShift
                                                        .sup_final_submitted ||
                                                selectedShift?.is_month_end == 1 &&
                                                    selectedShift
                                                            ?.is_final_submitted ==
                                                        true
                                            ? SizedBox()
                                            : ElevatedButton.icon(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: isBulkMode
                                                      ? Colors.red
                                                      : customcolor.blue,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(12),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  if (GlobalLists.supervisorrole ==
                                                          role &&
                                                      selectedShift
                                                          .sup_final_submitted) {
                                                    log(
                                                      'disable ${selectedShift.employeeList.length}',
                                                    );
                    
                                                    log(
                                                      'disable ${selectedShift.sup_final_submitted}',
                                                    );
                    
                                                    return;
                                                  }
                    
                                                  setState(() {
                                                    isBulkMode = !isBulkMode;
                                                    if (!isBulkMode)
                                                      selectedEmployees.clear();
                                                  });
                                                },
                                                icon: Icon(
                                                  isBulkMode
                                                      ? Icons.close
                                                      : Icons.people,
                                                  color: Colors.white,
                                                  size: 16,
                                                ),
                                                label: Text(
                                                  isBulkMode
                                                      ? 'Cancel Bulk'
                                                      : 'Bulk Mark',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                    
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              icon: Icon(
                                                Icons.info_outline,
                                                color: customcolor.blue,
                                              ),
                                              tooltip: "View reasons",
                                              onPressed: () {
                                                Dailogbox().showLegendDialog(context);
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                    
                            // Stats bar
                            _isLandscap ||
                                    selectedShift?.employeeList?.isEmpty ||
                                    GlobalLists.supervisorrole != role &&
                                        !selectedShift.sup_final_submitted
                                ? SizedBox()
                                : Container(
                                    padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: [
                                          _buildStatChip(
                                            '$presentCount',
                                            'Present',
                                            customcolor.blue,
                                          ),
                                          SizedBox(width: 10),
                                          _buildStatChip(
                                            '$absentCount',
                                            'Absent',
                                            customcolor.blue,
                                          ),
                    
                                          SizedBox(width: 10),
                                          _buildStatChip(
                                            '$hoildayCount',
                                            'Holiday',
                                            customcolor.blue,
                                          ),
                                          SizedBox(width: 10),
                                          _buildStatChip(
                                            '$whoildayCount',
                                            'Working Holiday',
                                            customcolor.blue,
                                          ),
                                          SizedBox(width: 10),
                                          _buildStatChip(
                                            '$hlfdayCount',
                                            'Halfday',
                                            customcolor.blue,
                                          ),
                                          SizedBox(width: 10),
                    
                                          _buildStatChip(
                                            '${otHours.toStringAsFixed(1)}',
                                            'OT Hrs',
                                            customcolor.blue,
                                          ),
                                          SizedBox(width: 10),
                                        ],
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    
                      // Bulk Mode Banner
                      if (isBulkMode)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [customcolor.blue, Color(0xFFA855F7)],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: customcolor.blue.withOpacity(0.3),
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '✓',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      '${selectedEmployees.length} employee${selectedEmployees.length != 1 ? 's' : ''}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  _buildBulkButton('Cancel', false),
                                  SizedBox(width: 8),
                                  _buildBulkButton('Mark', true),
                                ],
                              ),
                            ],
                          ),
                        ),
                    
                      // Employee Cards
                      Expanded(
                        child: selectedShift?.employeeList?.isEmpty ?? true
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.people_outline,
                                      size: 64,
                                      color: Colors.grey[400],
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      "No janitor assigned",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : role != GlobalLists.supervisorrole &&
                                  (selectedShift.sup_final_submitted == false ||
                                      selectedShift.sup_final_submitted == null)
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.people_outline,
                                      size: 64,
                                      color: Colors.grey[400],
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      "Attendance roster is not finalized yet.",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                padding: EdgeInsets.only(top: 12, bottom: 80),
                                itemCount: selectedShift?.employeeList?.length ?? 0,
                                itemBuilder: (context, index) {
                                  is_final_submit = selectedShift.is_final_submitted;
                                  is_month_end = selectedShift.is_month_end;
                                  sup_final_submitted_v =
                                      selectedShift.sup_final_submitted;
                                  final emp = selectedShift.employeeList[index];
                    
                                  final isSelected = selectedEmployees.contains(
                                    emp.empId.toString(),
                                  );
                    
                                  return _buildEmployeeCard(emp, isSelected);
                                },
                              ),
                      ),
                    ],
                  ),
                    
                  ((role == GlobalLists.unitrole ||role == GlobalLists.operationmanagerrole ||
                              role == GlobalLists.operationrole) &&
                          selectedShift?.is_final_submitted == false &&
                          selectedShift.review_updated_by_client == false)
                      ? SizedBox()
                      : isCurrentMonthYear(selectedMonthIndex!, selectedYear!)
                      ? SizedBox()
                      : selectedShift?.employeeList.isEmpty ||
                            selectedShift?.employeeList.length == 0 ||
                            GlobalLists.supervisorrole != role &&
                                selectedShift.sup_final_submitted == false ||
                            selectedEmployees.isNotEmpty
                      ? SizedBox()
                      : GlobalLists.supervisorrole == role &&
                            !selectedShift.sup_final_submitted
                      ? Padding(
                          padding: const EdgeInsets.only(
                            top: 8,
                            bottom: 12,
                            right: 12,
                            left: 12,
                          ),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: ElevatedButton(
                              onPressed: () {
                                if (GlobalLists.supervisorrole == role &&
                                    selectedShift.sup_final_submitted) {
                                  ShowDialogs.showToast(
                                    "Roster is already finalized.",
                                  );
                    
                                  return;
                                }
                    
                                _showRosterLockDialog(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: customcolor.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                minimumSize: Size(double.infinity, 48),
                              ),
                              child: Text(
                                GlobalLists.supervisorrole == role &&
                                        selectedShift.sup_final_submitted
                                    ? "Roster finalize"
                                    : "Submit",
                                style: TextStyle(
                                  fontFamily: AppFonts.semibold,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        )
                      : 
                      Padding(
            padding: const EdgeInsets.only(
                    top: 8,
                    bottom: 12,
                    right: 12,
                    left: 12,
            ),
            child: Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
            onPressed: () async {
              // --- If file already downloaded, open it ---
              if (downloadedFilePath != null) {
                if(Platform.isAndroid)
                {await OpenFilex.open(downloadedFilePath!);
                    
                }else{
                  _openFileOptions(downloadedFilePath!);
                }
                
                return;
              }
                    
              // --- Supervisor / Operation roles ---
              if ((role == GlobalLists.unitrole || GlobalLists.supervisorrole == role ||
                      GlobalLists.operationmanagerrole == role ||
                      GlobalLists.operationrole == role) &&
                  selectedShift.sup_final_submitted &&
                  selectedShift.is_final_submitted == false &&
                  selectedShift.review_updated_by_client) {
                if (selectedShift?.is_month_end == 1 &&
                    selectedShift?.is_final_submitted == false &&
                    selectedCells.isEmpty &&
                    !multiSelectMode &&
                    role == GlobalLists.clientrole &&
                    selectedShift.review_updated_by_oe_om == false &&
                    selectedShift.review_updated_by_client == false) {
                  _submitAttendaceRosterfinal(selectedShift.id.toString());
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewRemarkAttendance(
                        month: month,
                        year: year,
                        attendancesiteid: attendancesiteid,
                        clientid: attendanceclientid,
                        manTag: maintag,
                        shiftId: selectedShift?.id,
                      ),
                    ),
                  );
                }
                return;
              }
                    
              // --- Supervisor downloading finalized roster ---
              if (GlobalLists.supervisorrole == role &&
                  selectedShift.sup_final_submitted &&
                  selectedShift.is_final_submitted) {
                await _downloadRoster(selectedShift.id.toString());
                return;
              }
                    
              // --- Month-end download for finalized roster ---
              if (selectedShift?.is_month_end == 1 &&
                  selectedShift?.is_final_submitted == true) {
                await _downloadRoster(selectedShift.id.toString());
                return;
              }
                    
              // --- Client approval conditions ---
              if (role == GlobalLists.clientrole &&
                  selectedShift?.review_updated_by_oe_om == false &&
                  selectedShift.review_updated_by_client == false) {
                if (selectedShift?.is_month_end == 1 &&
                    selectedShift?.is_final_submitted == false &&
                    selectedCells.isEmpty &&
                    !multiSelectMode &&
                    role == GlobalLists.clientrole &&
                    selectedShift.review_updated_by_oe_om == false &&
                    selectedShift.review_updated_by_client == false) {
                  _submitAttendaceRosterfinal(selectedShift.id.toString());
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewRemarkAttendance(
                        month: month,
                        year: year,
                        attendancesiteid: attendancesiteid,
                        clientid: attendanceclientid,
                        manTag: maintag,
                        shiftId: selectedShift?.id,
                      ),
                    ),
                  );
                }
                return;
              }
                    
              // --- Client reviewing discrepancies ---
              if (role == GlobalLists.clientrole &&
                  selectedShift.review_updated_by_client) {
                if (selectedShift?.is_month_end == 1 &&
                    selectedShift?.is_final_submitted == false &&
                    selectedCells.isEmpty &&
                    !multiSelectMode &&
                    role == GlobalLists.clientrole &&
                    selectedShift.review_updated_by_oe_om == false &&
                    selectedShift.review_updated_by_client == false) {
                  _submitAttendaceRosterfinal(selectedShift.id.toString());
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewRemarkAttendance(
                        month: month,
                        year: year,
                        attendancesiteid: attendancesiteid,
                        clientid: attendanceclientid,
                        manTag: maintag,
                        shiftId: selectedShift?.id,
                      ),
                    ),
                  );
                }
                return;
              }
                    
              // --- Supervisor submitted but no action ---
              if (GlobalLists.supervisorrole == role &&
                  selectedShift.sup_final_submitted) {
                return;
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: (downloadedFilePath != null)
                  ? customcolor.blue
                  : (GlobalLists.supervisorrole == role &&
                          selectedShift.sup_final_submitted &&
                          selectedShift.is_final_submitted)
                      ? customcolor.blue
                      : (selectedShift?.is_month_end == 1 &&
                              selectedShift?.is_final_submitted == true)
                          ? customcolor.blue
                          : (GlobalLists.supervisorrole == role &&
                                  selectedShift.sup_final_submitted)
                              ? Colors.grey
                              : customcolor.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              minimumSize: Size(double.infinity, 40),
            ),
            child: isDownloading
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      ),
                      SizedBox(width: 12),
                      Text("Downloading...",
                          style: TextStyle(
                              fontFamily: AppFonts.semibold,
                              fontSize: 16,
                              color: Colors.white)),
                    ],
                  )
                : Text(
                    (downloadedFilePath != null)
                        ? "View Download"
                        : (GlobalLists.supervisorrole == role &&
                                selectedShift.sup_final_submitted &&
                                selectedShift.is_final_submitted)
                            ? "Download Roster ${selectedShift.sup_final_submitted} ${selectedShift.is_final_submitted}"
                            : (GlobalLists.supervisorrole == role &&
                                    selectedShift.sup_final_submitted &&
                                    selectedShift.is_final_submitted == false &&
                                    selectedShift.review_updated_by_client)
                                ? "Review Discrepancy"
                                : (GlobalLists.supervisorrole == role &&
                                        selectedShift.sup_final_submitted)
                                    ? "Submitted to Client"
                                    : (role == GlobalLists.clientrole &&
                                            selectedShift.review_updated_by_client &&
                                            selectedShift.is_final_submitted)
                                        ?"Finalized Roster"
                                        : (role == GlobalLists.clientrole &&
                                                selectedShift?.review_updated_by_oe_om ==
                                                    true &&
                                                selectedShift.is_final_submitted ==
                                                    false)
                                            ? "Review Updates"
                                            : (role == GlobalLists.clientrole &&
                                                    selectedShift.review_updated_by_client)
                                                ? "Review Discrepancy"
                                                : selectedShift?.is_month_end == 1 &&
                                                        selectedShift?.is_final_submitted ==
                                                            true
                                                    ? "Download Roster"
                                                    : selectedCells.isNotEmpty &&
                                                            multiSelectMode
                                                        ? "Review Discrepancy"
                                                        : role ==
                                                                    GlobalLists
                                                                        .clientrole &&
                                                                selectedShift
                                                                        ?.review_updated_by_oe_om ==
                                                                    false &&
                                                                selectedShift.review_updated_by_client ==
                                                                    false
                                                            ? "Approve Roster"
                                                            : "Review Discrepancy",
                    style: TextStyle(
                      fontFamily: AppFonts.semibold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                    ),
            ),
                    ),
                    
                    // --- Add this helper function in your StatefulWidget ---
                    
                    //                 Padding(
                    //   padding: const EdgeInsets.only(
                    //     top: 8,
                    //     bottom: 12,
                    //     right: 12,
                    //     left: 12,
                    //   ),
                    //   child: Align(
                    //     alignment: Alignment.bottomCenter,
                    //     child: ElevatedButton(
                    //       onPressed:
                    //           ((GlobalLists.supervisorrole == role ||
                    //                   GlobalLists.operationmanagerrole == role ||
                    //                   GlobalLists.operationrole == role) &&
                    //               selectedShift.sup_final_submitted &&
                    //               selectedShift.is_final_submitted == false &&
                    //               selectedShift.review_updated_by_client)
                    //               ? () {
                    //                   selectedShift?.is_month_end == 1 &&
                    //                           selectedShift?.is_final_submitted == false &&
                    //                           selectedCells.isEmpty &&
                    //                           !multiSelectMode &&
                    //                           role == GlobalLists.clientrole &&
                    //                           selectedShift.review_updated_by_oe_om == false &&
                    //                           selectedShift.review_updated_by_client == false
                    //                       ? _submitAttendaceRosterfinal(
                    //                           selectedShift.id.toString(),
                    //                         )
                    //                       : Navigator.push(
                    //                           context,
                    //                           MaterialPageRoute(
                    //                             builder: (context) => ViewRemarkAttendance(
                    //                               month: month,
                    //                               year: year,
                    //                               attendancesiteid: attendancesiteid,
                    //                               clientid: attendanceclientid,
                    //                               manTag: maintag,
                    //                               shiftId: selectedShift?.id,
                    //                             ),
                    //                           ),
                    //                         );
                    //                 }
                    //               : (GlobalLists.supervisorrole == role &&
                    //                       selectedShift.sup_final_submitted &&
                    //                       selectedShift?.is_final_submitted)
                    //                   ? () async {
                    //                       // --- Download with loader ---
                    //                       setState(() {
                    //                         isDownloading = true;
                    //                       });
                    //                       try {
                    //                         Directory baseDir =
                    //                             await getApplicationDocumentsDirectory();
                    //                         String filePath =
                    //                             "${baseDir.path}/roster_${selectedShift.id}.pdf";
                    
                    //                         Dio dio = Dio();
                    //                         await dio.download(
                    //                             GlobalLists.downloadRosterLink, filePath,
                    //                             onReceiveProgress: (received, total) {
                    //                           print("Downloading $received / $total");
                    //                         });
                    
                    //                         setState(() {
                    //                           isDownloading = false;
                    //                           downloadedFilePath = filePath;
                    //                         });
                    
                    //                         ScaffoldMessenger.of(context).showSnackBar(
                    //                           SnackBar(content: Text("Download completed")),
                    //                         );
                    //                       } catch (e) {
                    //                         setState(() {
                    //                           isDownloading = false;
                    //                         });
                    //                         ScaffoldMessenger.of(context).showSnackBar(
                    //                           SnackBar(content: Text("Download failed: $e")),
                    //                         );
                    //                       }
                    //                     }
                    //                   : (selectedShift?.is_month_end == 1 &&
                    //                           selectedShift?.is_final_submitted == true)
                    //                       ? () async {
                    //                           // --- Download with loader ---
                    //                           setState(() {
                    //                             isDownloading = true;
                    //                           });
                    //                           try {
                    //                             Directory baseDir =
                    //                                 await getApplicationDocumentsDirectory();
                    //                             String filePath =
                    //                                 "${baseDir.path}/roster_${selectedShift.id}.pdf";
                    
                    //                             Dio dio = Dio();
                    //                             await dio.download(
                    //                                 GlobalLists.downloadRosterLink, filePath,
                    //                                 onReceiveProgress: (received, total) {
                    //                               print("Downloading $received / $total");
                    //                             });
                    
                    //                             setState(() {
                    //                               isDownloading = false;
                    //                               downloadedFilePath = filePath;
                    //                             });
                    
                    //                             ScaffoldMessenger.of(context).showSnackBar(
                    //                               SnackBar(content: Text("Download completed")),
                    //                             );
                    //                           } catch (e) {
                    //                             setState(() {
                    //                               isDownloading = false;
                    //                             });
                    //                             ScaffoldMessenger.of(context).showSnackBar(
                    //                               SnackBar(content: Text("Download failed: $e")),
                    //                             );
                    //                           }
                    //                         }
                    //                       // --- Keep all other conditions intact ---
                    //                       : (role == GlobalLists.clientrole &&
                    //                               selectedShift?.review_updated_by_oe_om == false &&
                    //                               selectedShift.review_updated_by_client == false)
                    //                           ? () {
                    //                               selectedShift?.is_month_end == 1 &&
                    //                                       selectedShift?.is_final_submitted ==
                    //                                           false &&
                    //                                       selectedCells.isEmpty &&
                    //                                       !multiSelectMode &&
                    //                                       role == GlobalLists.clientrole &&
                    //                                       selectedShift.review_updated_by_oe_om ==
                    //                                           false &&
                    //                                       selectedShift
                    //                                               .review_updated_by_client ==
                    //                                           false
                    //                                   ? _submitAttendaceRosterfinal(
                    //                                       selectedShift.id.toString(),
                    //                                     )
                    //                                   : Navigator.push(
                    //                                       context,
                    //                                       MaterialPageRoute(
                    //                                         builder: (context) =>
                    //                                             ViewRemarkAttendance(
                    //                                           month: month,
                    //                                           year: year,
                    //                                           attendancesiteid: attendancesiteid,
                    //                                           clientid: attendanceclientid,
                    //                                           manTag: maintag,
                    //                                           shiftId: selectedShift?.id,
                    //                                         ),
                    //                                       ),
                    //                                     );
                    //                             }
                    //                           : (GlobalLists.supervisorrole == role &&
                    //                                   selectedShift.sup_final_submitted)
                    //                               ? () {}
                    //                               : (role == GlobalLists.clientrole &&
                    //                                       selectedShift.review_updated_by_client)
                    //                                   ? () {
                    //                                       selectedShift?.is_month_end == 1 &&
                    //                                               selectedShift?.is_final_submitted ==
                    //                                                   false &&
                    //                                               selectedCells.isEmpty &&
                    //                                               !multiSelectMode &&
                    //                                               role == GlobalLists.clientrole &&
                    //                                               selectedShift
                    //                                                       .review_updated_by_oe_om ==
                    //                                                   false &&
                    //                                               selectedShift
                    //                                                       .review_updated_by_client ==
                    //                                                   false
                    //                                           ? _submitAttendaceRosterfinal(
                    //                                               selectedShift.id.toString(),
                    //                                             )
                    //                                           : Navigator.push(
                    //                                               context,
                    //                                               MaterialPageRoute(
                    //                                                 builder: (context) =>
                    //                                                     ViewRemarkAttendance(
                    //                                                   month: month,
                    //                                                   year: year,
                    //                                                   attendancesiteid:
                    //                                                       attendancesiteid,
                    //                                                   clientid:
                    //                                                       attendanceclientid,
                    //                                                   manTag: maintag,
                    //                                                   shiftId: selectedShift?.id,
                    //                                                 ),
                    //                                               ),
                    //                                             );
                    //                                     }
                    //                                   : (downloadedFilePath != null)
                    //                                       ? () async {
                    //                                           await OpenFilex.open(downloadedFilePath!);
                    //                                         }
                    //                                       : null,
                    //       style: ElevatedButton.styleFrom(
                    //         backgroundColor:
                    //             (GlobalLists.supervisorrole == role &&
                    //                     selectedShift.sup_final_submitted &&
                    //                     selectedShift?.is_final_submitted)
                    //                 ? customcolor.blue
                    //                 : (selectedShift?.is_month_end == 1 &&
                    //                         selectedShift?.is_final_submitted == true)
                    //                     ? customcolor.blue
                    //                     : (GlobalLists.supervisorrole == role &&
                    //                             selectedShift.sup_final_submitted)
                    //                         ? Colors.grey
                    //                         : role == GlobalLists.supervisorrole
                    //                             ? customcolor.blue
                    //                             : customcolor.blue,
                    //         shape: RoundedRectangleBorder(
                    //           borderRadius: BorderRadius.circular(8),
                    //         ),
                    //         minimumSize: Size(double.infinity, 40),
                    //       ),
                    //       child: isDownloading
                    //           ? Row(
                    //               mainAxisAlignment: MainAxisAlignment.center,
                    //               children: [
                    //                 SizedBox(
                    //                     height: 20,
                    //                     width: 20,
                    //                     child: CircularProgressIndicator(
                    //                       color: Colors.white,
                    //                       strokeWidth: 2,
                    //                     )),
                    //                 SizedBox(width: 12),
                    //                 Text("Downloading...",
                    //                     style: TextStyle(
                    //                         fontFamily: AppFonts.semibold,
                    //                         fontSize: 16,
                    //                         color: Colors.white)),
                    //               ],
                    //             )
                    //           : Text(
                    //               (downloadedFilePath != null)
                    //                   ? "View Download"
                    //                   : (GlobalLists.supervisorrole == role &&
                    //                           selectedShift.sup_final_submitted &&
                    //                           selectedShift?.is_final_submitted)
                    //                       ? "Download Roster"
                    //                       : (GlobalLists.supervisorrole == role &&
                    //                               selectedShift.sup_final_submitted &&
                    //                               selectedShift.is_final_submitted == false &&
                    //                               selectedShift.review_updated_by_client)
                    //                           ? "Review Discrepancy"
                    //                           : (GlobalLists.supervisorrole == role &&
                    //                                   selectedShift.sup_final_submitted)
                    //                               ? "Submitted to Client"
                    //                               : (role == GlobalLists.clientrole &&
                    //                                       selectedShift.review_updated_by_client &&
                    //                                       selectedShift.is_final_submitted)
                    //                                   ? "Finalized Roster"
                    //                                   : (role == GlobalLists.clientrole &&
                    //                                           selectedShift?.review_updated_by_oe_om ==
                    //                                               true &&
                    //                                           selectedShift.is_final_submitted ==
                    //                                               false)
                    //                                       ? "Review Updates"
                    //                                       : (role == GlobalLists.clientrole &&
                    //                                               selectedShift.review_updated_by_client)
                    //                                           ? "Review Discrepancy"
                    //                                           : selectedShift?.is_month_end == 1 &&
                    //                                                   selectedShift?.is_final_submitted ==
                    //                                                       true
                    //                                               ? "Download Roster"
                    //                                               : selectedCells.isNotEmpty &&
                    //                                                       multiSelectMode
                    //                                                   ? "Review Discrepancy"
                    //                                                   : role ==
                    //                                                               GlobalLists
                    //                                                                   .clientrole &&
                    //                                                           selectedShift
                    //                                                                   ?.review_updated_by_oe_om ==
                    //                                                               false &&
                    //                                                           selectedShift.review_updated_by_client ==
                    //                                                               false
                    //                                                       ? "Approve Roster"
                    //                                                       : "Review Discrepancy",
                    //               style: TextStyle(
                    //                 fontFamily: AppFonts.semibold,
                    //                 fontSize: 16,
                    //                 color: Colors.white,
                    //               ),
                    //             ),
                    //     ),
                    //   ),
                    // ),
                    //                 Padding(
                    //                     padding: const EdgeInsets.only(
                    //                       top: 8,
                    //                       bottom: 12,
                    //                       right: 12,
                    //                       left: 12,
                    //                     ),
                    //                     child: Align(
                    //                       alignment: Alignment.bottomCenter,
                    //                       child: ElevatedButton(
                    //                         onPressed:
                    //                             ((GlobalLists.supervisorrole == role ||
                    //                                     GlobalLists.operationmanagerrole == role ||
                    //                                     GlobalLists.operationrole == role) &&
                    //                                 selectedShift.sup_final_submitted &&
                    //                                 selectedShift.is_final_submitted == false &&
                    //                                 selectedShift.review_updated_by_client)
                    //                             ? () {
                    //                                 selectedShift?.is_month_end == 1 &&
                    //                                         selectedShift?.is_final_submitted ==
                    //                                             false &&
                    //                                         selectedCells.isEmpty &&
                    //                                         !multiSelectMode &&
                    //                                         role == GlobalLists.clientrole &&
                    //                                         selectedShift.review_updated_by_oe_om ==
                    //                                             false &&
                    //                                         selectedShift
                    //                                                 .review_updated_by_client ==
                    //                                             false
                    //                                     ? _submitAttendaceRosterfinal(
                    //                                         selectedShift.id.toString(),
                    //                                       )
                    //                                     : Navigator.push(
                    //                                         context,
                    //                                         MaterialPageRoute(
                    //                                           builder: (context) =>
                    //                                               ViewRemarkAttendance(
                    //                                                 month: month,
                    //                                                 year: year,
                    //                                                 attendancesiteid:
                    //                                                     attendancesiteid,
                    //                                                 clientid:
                    //                                                     attendanceclientid, //GlobalLists.clientid,
                    //                                                 manTag: maintag,
                    //                                                 shiftId: selectedShift?.id,
                    //                                               ),
                    //                                         ),
                    //                                       );
                    //                               }
                    //                             : (GlobalLists.supervisorrole == role &&
                    //                                   selectedShift.sup_final_submitted &&
                    //                                   selectedShift?.is_final_submitted)
                    //                             ? () {
                    
                    //                                 print("Downloading Supervisor ${GlobalLists.downloadRosterLink}");
                    //                                 downloadRoster(
                    //   GlobalLists.downloadRosterLink,
                    //   selectedShift.id.toString(),
                    // );
                    //                               }
                    //                             : (selectedShift?.is_month_end == 1 &&
                    //                                   selectedShift?.is_final_submitted == true)
                    //                             ? () {
                    //                                print("Downloading ${GlobalLists.downloadRosterLink}");
                    //                                downloadRoster(
                    //   GlobalLists.downloadRosterLink,
                    //   selectedShift.id.toString(),
                    // );
                    //                               }
                    //                             :(role == GlobalLists.clientrole &&
                    //                                     selectedShift?.review_updated_by_oe_om ==
                    //                                         false &&
                    //                                     selectedShift.review_updated_by_client ==
                    //                                         false)?() {
                    //                                 selectedShift?.is_month_end == 1 &&
                    //                                         selectedShift?.is_final_submitted ==
                    //                                             false &&
                    //                                         selectedCells.isEmpty &&
                    //                                         !multiSelectMode &&
                    //                                         role == GlobalLists.clientrole &&
                    //                                         selectedShift.review_updated_by_oe_om ==
                    //                                             false &&
                    //                                         selectedShift
                    //                                                 .review_updated_by_client ==
                    //                                             false
                    //                                     ? _submitAttendaceRosterfinal(
                    //                                         selectedShift.id.toString(),
                    //                                       )
                    //                                     : Navigator.push(
                    //                                         context,
                    //                                         MaterialPageRoute(
                    //                                           builder: (context) =>
                    //                                               ViewRemarkAttendance(
                    //                                                 month: month,
                    //                                                 year: year,
                    //                                                 attendancesiteid:
                    //                                                     attendancesiteid,
                    //                                                 clientid:
                    //                                                     attendanceclientid, //GlobalLists.clientid,
                    //                                                 manTag: maintag,
                    //                                                 shiftId: selectedShift?.id,
                    //                                               ),
                    //                                         ),
                    //                                       );
                    //                               }: (GlobalLists.supervisorrole == role &&
                    //                                   selectedShift.sup_final_submitted)
                    //                             ? ()
                    //                             {
                    
                    //                             }
                    //                             : (role == GlobalLists.clientrole &&
                    //                                   selectedShift.review_updated_by_client)
                    //                             ? () {
                    //                                 selectedShift?.is_month_end == 1 &&
                    //                                         selectedShift?.is_final_submitted ==
                    //                                             false &&
                    //                                         selectedCells.isEmpty &&
                    //                                         !multiSelectMode &&
                    //                                         role == GlobalLists.clientrole &&
                    //                                         selectedShift.review_updated_by_oe_om ==
                    //                                             false &&
                    //                                         selectedShift
                    //                                                 .review_updated_by_client ==
                    //                                             false
                    //                                     ? _submitAttendaceRosterfinal(
                    //                                         selectedShift.id.toString(),
                    //                                       )
                    //                                     : Navigator.push(
                    //                                         context,
                    //                                         MaterialPageRoute(
                    //                                           builder: (context) =>
                    //                                               ViewRemarkAttendance(
                    //                                                 month: month,
                    //                                                 year: year,
                    //                                                 attendancesiteid:
                    //                                                     attendancesiteid,
                    //                                                 clientid:
                    //                                                     attendanceclientid, //GlobalLists.clientid,
                    //                                                 manTag: maintag,
                    //                                                 shiftId: selectedShift?.id,
                    //                                               ),
                    //                                         ),
                    //                                       );
                    //                               }
                    //                             : null,
                    //                         style: ElevatedButton.styleFrom(
                    //                           backgroundColor:
                    //                            (GlobalLists.supervisorrole == role &&
                    //                                   selectedShift.sup_final_submitted &&
                    //                                   selectedShift?.is_final_submitted)?customcolor.blue:
                    //                                   ( selectedShift?.is_month_end == 1 &&
                                         
                    //                                     selectedShift?.is_final_submitted == true)?customcolor.blue:
                    //                           (GlobalLists.supervisorrole == role &&
                    //                                     selectedShift.sup_final_submitted)?Colors.grey: role == GlobalLists.supervisorrole
                    //                               ? customcolor.blue
                    //                               // :
                    //                               //  selectedShift?.is_month_end == 1 &&
                    //                               //       selectedShift?.is_final_submitted == true
                    //                               // ? Colors.grey
                    //                               : customcolor.blue,
                    //                           shape: RoundedRectangleBorder(
                    //                             borderRadius: BorderRadius.circular(8),
                    //                           ),
                    //                           minimumSize: Size(double.infinity, 40),
                    //                         ),
                    //                         child: Text(
                    //                           (GlobalLists.supervisorrole == role &&
                    //                                   selectedShift.sup_final_submitted &&
                    //                                   selectedShift?.is_final_submitted)
                    //                               ?"Download Roster"
                    //                               : (GlobalLists.supervisorrole == role &&
                    //                                     selectedShift.sup_final_submitted &&
                    //                                     selectedShift.is_final_submitted == false &&
                    //                                     selectedShift.review_updated_by_client)
                    //                               ? "Review Discrepancy"
                    //                               : (GlobalLists.supervisorrole == role &&
                    //                                     selectedShift.sup_final_submitted)
                    //                               ? "Submitted to Client"
                    //                               : (role == GlobalLists.clientrole &&
                    //                                     selectedShift.review_updated_by_client &&
                    //                                     selectedShift.is_final_submitted)
                    //                               ? "Finalized Roster"
                    //                               : (role == GlobalLists.clientrole &&
                    //                                     selectedShift?.review_updated_by_oe_om ==
                    //                                         true &&  selectedShift.is_final_submitted==false)
                    //                               ? "Review Updates"
                    //                               :  (role == GlobalLists.clientrole &&
                    //                                     selectedShift.review_updated_by_client)
                    //                               ? "Review Discrepancy"//Report
                    //                               :
                    //                                 //is_month_end -1 check to
                    //                                 selectedShift?.is_month_end == 1 &&
                    //                                     //is_final_submitted client submited or not
                    //                                     selectedShift?.is_final_submitted == true
                    //                               ?  "Download Roster" //"View Finalize Roster"
                    //                               : selectedCells.isNotEmpty && multiSelectMode
                    //                               ? "Review Discrepancy"//Report
                    //                               : role == GlobalLists.clientrole &&
                    //                                     selectedShift?.review_updated_by_oe_om ==
                    //                                         false &&
                    //                                     selectedShift.review_updated_by_client ==
                    //                                         false
                    //                               ? "Approve Roster"
                    //                               :"Review Discrepancy",
                    //                           style: TextStyle(
                    //                             fontFamily: AppFonts.semibold,
                    //                             fontSize: 16,
                    //                             color: Colors.white,
                    //                           ),
                    //                         ),
                    //                       ),
                    //                     ),
                    //                   ),
                ],
              ),
            ),
          ),
        );
      
  }
void _openFileOptions(String filePath) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.open_in_new),
              title: Text("Open File"),
              onTap: () async {
                Navigator.pop(context);
                await OpenFilex.open(filePath);
              },
            ),
            
          ],
        ),
      );
    },
  );
}
  Widget _buildStatChip(String value, String label, Color color) {
    return Card(
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),

        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(width: 4),
            Text(label, style: TextStyle(fontSize: 12, color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Widget _buildBulkButton(String text, bool isPrimary) {
    return ElevatedButton(
      onPressed: () {
        if (!isPrimary) {
          setState(() {
            isBulkMode = false;
            selectedEmployees.clear();
          });
        } else {
          _showBulkMarkingDialog();
          // showTopSnackBar('Please select at least one date', Color(0xFFEF4444));
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary ? Colors.white : Colors.transparent,
        foregroundColor: isPrimary ? customcolor.blue : Colors.white,
        side: BorderSide(color: Colors.white, width: 2),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 0,
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      ),
    );
  }


  Widget _buildEmployeeCard(dynamic emp, bool isSelected) {
    final allDates = <String>[];
    for (var att in emp.attendData ?? []) {
      allDates.add(att.date);
    }
    allDates.sort();

    // Calculate summary with global OT storage
    int presentCount = 0;
    int absentCount = 0;
    int hoildayCount = 0;
    int hlfdayCount = 0;
    int whoildayCount = 0;
    double otHours = 0;

    for (var att in emp.attendData ?? []) {
      if (att.attendance_type == 'P') presentCount++;
      if (att.attendance_type == 'A') absentCount++;
      if (att.attendance_type == 'W') whoildayCount++;
      if (att.attendance_type == 'F') hlfdayCount++;
      if (att.attendance_type == 'H') hoildayCount++;

      // Check global storage first
      final globalOT = OTHoursManager().getOTHours(
        emp.empId.toString(),
        att.date,
      );
      if (globalOT != null) {
        otHours += globalOT;
      } else if (att.ot_hours != null) {
        otHours += att.ot_hours ?? 0;
      }
    }

    return GestureDetector(
      onTap: () {
        if (isBulkMode) {
          setState(() {
            if (isSelected) {
              selectedEmployees.remove(emp.empId.toString());
            } else {
              selectedEmployees.add(emp.empId.toString());
            }

            log('selectedEmployees${selectedEmployees}');
          });
        }
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(12, 0, 12, 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: customcolor.blue, width: 3)
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 3,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Employee Header
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFF8FAFC), Color(0xFFF1F5F9)],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
              ),
              child: Stack(
                children: [
                  Row(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    /// LEFT (Employee Info)
    Expanded(
      flex: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            emp.empName,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0F172A),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 2),
          Text(
            emp.empId.toString(),
            style: TextStyle(
              fontSize: 11,
              color: Color(0xFF64748B),
            ),
          ),
        ],
      ),
    ),

    SizedBox(width: 8),

    /// CENTER (Stats)
    Expanded(
      flex: 3,
      child: SingleChildScrollView( // ✅ prevents overflow
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildSummaryItem(presentCount.toString(), 'P', Color(0xFF22C55E)),
            SizedBox(width: 10),
            _buildSummaryItem(absentCount.toString(), 'A', Color(0xFFEF4444)),
            SizedBox(width: 10),
            _buildSummaryItem(hoildayCount.toString(), 'H', Color(0xFF7DD3FC)),
            SizedBox(width: 10),
            _buildSummaryItem(whoildayCount.toString(), 'W', Color(0xFF2563EB)),
            SizedBox(width: 10),
            _buildSummaryItem(hlfdayCount.toString(), 'F', Color(0xFF4ADE80)),
            SizedBox(width: 10),
            _buildSummaryItem(otHours.toStringAsFixed(1), 'OT', customcolor.blue),
          ],
        ),
      ),
    ),

    SizedBox(width: 2),

    /// RIGHT (Eye Icon)
  
   GestureDetector(
 onTap: () {
  //  final List<AttendanceData> list =
  //       (emp.attendData ?? []).cast<AttendanceData>();

    // if (list.isEmpty) return;

    // final att = list.first; // 👈 latest item

    // final reason = (att.sup_reason?.isNotEmpty == true)
    //     ? att.sup_reason!
    //     : (att.reason?.isNotEmpty == true)
    //         ? att.reason!
    //         : (att.om_oe_resson ?? "No reason");
_showReasonDialog(
  context,
  attendData: emp.attendData,
  clientReasonList: emp.clientReasonList,
);
    // _showReasonDialog(
    //   context,
    //   date: att.date,
    //   reason: reason,
    // );
},
  child: Icon(
                                          Icons.info_outline,
                                          color: customcolor.blue,
                                        ),
)
  ],
)
                 
                ],
              ),
            ),

            // Timeline Container - Horizontal Scroll
            Container(
              height: 135,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: allDates.map((date) {
                    return _buildDateColumn(emp, date);
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  void _showReasonDialog(
  BuildContext context, {
  required List<AttendanceData> attendData,
  List<ClientReason>? clientReasonList, // nullable
}) {
  final clientList = clientReasonList ?? [];

  // Filter attendData to only include entries with a reason
  final filteredAttendData = attendData.where((att) {
    final clientReason = clientList.firstWhere(
      (cr) => cr.date == att.date,
      orElse: () => ClientReason(date: att.date, supReason: '', clientReason: ''),
    );
    // Only include if supervisor or client reason is not empty
    return (att.sup_reason?.isNotEmpty == true) || (clientReason.clientReason.isNotEmpty);
  }).toList();

  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (_) => Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Details",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // Show message if no filtered reasons
              if (filteredAttendData.isEmpty)
                const Text("No reasons available")
              else
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: filteredAttendData.length,
                    itemBuilder: (context, index) {
                      final att = filteredAttendData[index];

                      // Find client reason for same date
                      final clientReason = clientList.firstWhere(
                        (cr) => cr.date == att.date,
                        orElse: () => ClientReason(date: att.date, supReason: '', clientReason: ''),
                      );

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Date: ${att.date}", style: const TextStyle(fontWeight: FontWeight.w600)),
                            const SizedBox(height: 4),
                            if (att.sup_reason?.isNotEmpty == true)
                              Text("Supervisor Reason: ${att.sup_reason}"),
                            if (clientReason.clientReason.isNotEmpty)
                              Text("Client Reason: ${clientReason.clientReason}"),
                            const Divider(),
                          ],
                        ),
                      );
                    },
                  ),
                ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: customcolor.blue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("OK", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
// void _showReasonDialog(
//   BuildContext context, {
//   required List<AttendanceData> attendData,
//   List<ClientReason>? clientReasonList, // nullable
// }) {
//   final clientList = clientReasonList ?? []; // default to empty list

//   showDialog(
//     context: context,
//     barrierDismissible: true,
//     builder: (_) => Dialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: ConstrainedBox(
//           // Limit max height of dialog to 80% of screen
//           constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 "Details",
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 12),

//               // Use Flexible for scrollable content
//               if (attendData.isEmpty && clientList.isEmpty)
//                 const Text("No reasons available")
//               else
//                 Flexible(
//                   child: ListView.builder(
//                     shrinkWrap: true,
//                     itemCount: attendData.length,
//                     itemBuilder: (context, index) {
//                       final att = attendData[index];

//                       // Find client reason for same date
//                       final clientReason = clientList.firstWhere(
//                         (cr) => cr.date == att.date,
//                         orElse: () => ClientReason(date: att.date, supReason: '', clientReason: ''),
//                       );

//                       return Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 6),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text("Date: ${att.date}", style: const TextStyle(fontWeight: FontWeight.w600)),
//                             const SizedBox(height: 4),
//                             Text("Supervisor Reason: ${att.sup_reason?.isNotEmpty == true ? att.sup_reason : 'No reason'}"),
//                             const SizedBox(height: 2),
//                             Text("Client Reason: ${clientReason.clientReason.isNotEmpty ? clientReason.clientReason : 'No reason'}"),
//                             const Divider(),
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//                 ),

//               const SizedBox(height: 12),

//               SizedBox(
//                 width: double.infinity,
//                 height: 45,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: customcolor.blue,
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                   ),
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   child: const Text("OK", style: TextStyle(color: Colors.white)),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     ),
//   );
// }
// void _showReasonDialog(BuildContext context,
//     {required String date, required String reason}) {
//   showDialog(
//     context: context,
//     barrierDismissible: true,
//     builder: (_) => Dialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
            
//             /// TITLE
//             const Text(
//               "Details",
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),

//             const SizedBox(height: 12),

//             /// DATE
//             Row(
//               children: [
//                 const Text(
//                   "Date: ",
//                   style: TextStyle(fontWeight: FontWeight.w600),
//                 ),
//                 Expanded(
//                   child: Text(
//                     date.isNotEmpty ? date : "-",
//                     style: TextStyle(color: Colors.grey[700]),
//                   ),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 12),

//             /// REASON FIELD (READ ONLY)
//             Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   "Supervisor Reason",
//                   style: TextStyle(fontWeight: FontWeight.w600),
//                 ),
//                 const SizedBox(height: 6),

//             TextField(
//               controller: TextEditingController(text: reason),
//               readOnly: true,
//               maxLines: 3,
//               decoration: InputDecoration(
//                 hintText: "No reason available",
//                 filled: true,
//                 fillColor: Colors.grey.shade100,
//                 contentPadding: const EdgeInsets.all(10),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//             ),

//             const SizedBox(height: 20),
//               ],
//             ),
            

            

//             /// BUTTON
//             SizedBox(
//               width: double.infinity,
//               height: 45,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: customcolor.blue,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//                 child: const Text(
//                   "OK",
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }
  Widget _buildSummaryItem(String value, String label, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        Text(label, style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
      ],
    );
  }

  Widget _buildDateColumn(dynamic emp, String date) {
    AttendanceData? day;
    bool canEdit = false;

    try {
      day = emp.attendData.firstWhere((d) => d.date == date);
    } catch (e) {
      day = null;
    }

    final dateObj = DateTime.parse(date);
    final dayNum = dateObj.day.toString();
    final dayName = DateFormat(
      'EEE',
    ).format(dateObj).substring(0, 3).toUpperCase();
    final isToday = DateFormat('yyyy-MM-dd').format(DateTime.now()) == date;
    final isWeekend = dateObj.weekday == 6 || dateObj.weekday == 7;
    final isFuture = dateObj.isAfter(DateTime.now());

    // Get OT hours from global storage
    final globalOT = OTHoursManager().getOTHours(emp.empId.toString(), date);
    final hasOT =
        globalOT != null || (day?.ot_hours != null && day!.ot_hours! > 0);
    final displayOT = globalOT ?? day?.ot_hours ?? 0.0;

    return GestureDetector(
      onTap: () {
      
        setState(() {});
       
        if (role == GlobalLists.clientrole) {
        
          canEdit =
              (is_final_submit == false ||
                  selectedShift?.is_final_submitted == null) &&
              day?.act_deact_janitor == true &&
             day?.attendance_type != '-' && //changes made ruchita 4April -
              (day?.client_approval_status == null ||
                  day!.client_approval_status == '') 
              //     &&
              // (day?.reason == null || day?.reason == '' || day?.reason == 'NA') //changes made ruchita 4April
              ;
        }
        
print("===== DEBUG START =====");
print("role: $role");

print("is_final_submit: $is_final_submit");
print("selectedShift.is_final_submitted: ${selectedShift?.is_final_submitted}");
print("day.act_deact_janitor: ${day?.act_deact_janitor}");
print("day.attendanceStatus: ${day?.attendanceStatus}");
print("day.client_approval_status: ${day?.client_approval_status}");
print("day.reason: ${day?.reason}");
print("sup_final_submitted_v: $sup_final_submitted_v");
print("isFuture: $isFuture");
print("isBulkMode: $isBulkMode");
print("day is null: ${day == null}");
print("canEdit: ${canEdit}");
print("=======================");
        if (GlobalLists.supervisorrole == role && sup_final_submitted_v) {
          print('Roster is already finalized.');
          ShowDialogs.showToast("Roster is already finalized.");
          return;
        }
       
        if (canEdit ||
            (GlobalLists.supervisorrole == role && !sup_final_submitted_v)) {
               print("-------------- AXXEPTED");
          if (!isFuture && day != null && !isBulkMode) {
            _showAttendanceDialog(emp, day, date);
          }
        }
      },
      child: Container(
        height: 120,
        width: 62,
        margin: EdgeInsets.only(right: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Date Header
            Container(
              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              decoration: BoxDecoration(
                color: Color(0xFFFAFBFC),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    dayName,
                    style: TextStyle(
                      fontSize: 9,
                      color: Color(0xFF64748B),
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    dayNum,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: isToday ? Color(0xFF3B82F6) : Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 6),

            // Attendance Marker
            Container(
              height: 28,
              decoration: BoxDecoration(
                color: _getAttendanceColor(day, isFuture).withOpacity(0.2),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: _getAttendanceColor(day, isFuture),
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Text(
                  _getAttendanceLabel(day, isFuture),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: _getAttendanceTextColor(day, isFuture),
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ),

            // OT Container with Input Box (always shown)
            SizedBox(height: 4),
            GestureDetector(
              onTap: () {
                  print("Clicked SAVE HERE");
                if (is_month_end == 1 && is_final_submit == true) {
                  return;
                }
                if (!isFuture && day != null && !isBulkMode) {
                  _showOTDialog(emp, day, date, displayOT.toDouble());
                }
              },
              child: Container(
                height: 28,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: hasOT ? Color(0xFFF3E8FF) : Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: hasOT ? customcolor.blue : Color(0xFFE2E8F0),
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 10,
                        color: hasOT ? Color(0xFF6B21A8) : Color(0xFF94A3B8),
                      ),
                      SizedBox(width: 4),
                      Text(
                        hasOT ? '${displayOT.toStringAsFixed(1)}h' : 'OT',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: hasOT ? Color(0xFF6B21A8) : Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  final reasonController = TextEditingController();

  void _showOTDialog(
    dynamic emp,
    AttendanceData day,
    String date,
    double currentOT,
  ) {
    TextEditingController otController = TextEditingController(
      text: currentOT > 0 ? currentOT.toStringAsFixed(1) : '',
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        padding: EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Modal Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Header
              Text(
                'Enter Overtime Hours',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 6),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      emp.empName,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF3B82F6),
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(' • ', style: TextStyle(color: Color(0xFF64748B))),
                  Text(
                    DateFormat('EEE, MMM d').format(DateTime.parse(date)),
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF0F172A),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),

              // OT Input
              Text(
                'OT HOURS',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF64748B),
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: 12),
                TextFormField(
  controller: hoursController,
  keyboardType: TextInputType.numberWithOptions(decimal: true),

  inputFormatters: [
    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,1}')),
  ],

  validator: (value) {
    if (value == null || value.isEmpty) {
      return "Enter hours";
    }

    final number = double.tryParse(value);
    if (number == null) {
      return "Invalid number";
    }

    if (number < 0 || number > 30) {
      return "Must be between 0 and 30";
    }

    return null;
  },

                    decoration: InputDecoration(
                      
                      hintText: 'Enter hours (e.g., 2.5)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Color(0xFFE2E8F0),
                          width: 2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Color(0xFFE2E8F0),
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Color(0xFF3B82F6),
                          width: 2,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),

                      prefixIcon: Icon(
                        Icons.access_time,
                        color: Color(0xFF64748B),
                      ),
                    ),  
  // decoration: InputDecoration(
  //   hintText: 'e.g., 2.5',
  //   border: OutlineInputBorder(
  //     borderRadius: BorderRadius.circular(12),
  //   ),
  //   prefixIcon: Icon(Icons.access_time),
  //   suffixText: 'hours',
  // ),

  onChanged: (value) {
    final number = double.tryParse(value);

    if (number != null && number > 30) {
      // Clear field
      hoursController.clear();

      // Show message
       ShowDialogs.showToast('OT should be maximum 30 hr');
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text("OT should be maximum 30 hr"),
      //     backgroundColor: Colors.red,
      //   ),
      // );
    } else {
      bulkOTHours = value;
    }
  },
),
  //             TextFormField(
  //                validator: (value) {
  //   if (value == null || value.isEmpty) {
  //     return "Enter hours";
  //   }

  //   final number = double.tryParse(value);
  //   if (number == null) {
  //     return "Invalid number";
  //   }

  //   if (number < 0 || number > 30) {
  //     return "Must be between 0 and 30";
  //   }

  //   return null;
  // },
  //               controller: otController,
  //               decoration: InputDecoration(
  //                 hintText: 'Enter hours (e.g., 2.5)',
  //                 border: OutlineInputBorder(
  //                   borderRadius: BorderRadius.circular(12),
  //                   borderSide: BorderSide(color: Color(0xFFE2E8F0), width: 2),
  //                 ),
  //                 enabledBorder: OutlineInputBorder(
  //                   borderRadius: BorderRadius.circular(12),
  //                   borderSide: BorderSide(color: Color(0xFFE2E8F0), width: 2),
  //                 ),
  //                 focusedBorder: OutlineInputBorder(
  //                   borderRadius: BorderRadius.circular(12),
  //                   borderSide: BorderSide(color: Color(0xFF3B82F6), width: 2),
  //                 ),
  //                 contentPadding: EdgeInsets.symmetric(
  //                   horizontal: 16,
  //                   vertical: 14,
  //                 ),
  //                 prefixIcon: Icon(Icons.access_time, color: Color(0xFF64748B)),
  //                 suffixText: 'hours',
  //               ),
  //               // keyboardType: TextInputType.numberWithOptions(decimal: true),
  //               keyboardType: TextInputType.numberWithOptions(decimal: true),
  // inputFormatters: [
  //   FilteringTextInputFormatter.allow(
  //     RegExp(r'^\d{0,2}(\.\d{0,1})?$'),
  //   ),
  // ],
  //               style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
  //             ),
              SizedBox(height: 8),
              Text(
                'Enter overtime hours worked on this date',
                style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
              ),

              SizedBox(height: 32),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFF1F5F9),
                        foregroundColor: Color(0xFF0F172A),
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                       
                        final otText = otController.text.trim();
                        double hours = 0.0;

                        if (otText.isNotEmpty) {
                          hours = double.tryParse(otText) ?? 0.0;
                          OTHoursManager().setOTHours(
                            emp.empId.toString(),
                            date,
                            hours,
                          );
                        } else {
                          OTHoursManager().clearOTHours(
                            emp.empId.toString(),
                            date,
                          );
                        }
                      
// Prepare attendance entry with current day's attendance status
                        final attendanceEntry = {
                          "date": date,
                          "attendance_status": day.attendance_type ?? '',
                          "emp_id": emp.empId,
                          "reason": role == GlobalLists.supervisorrole
                              ? ''
                              : reasonController.text,
                          "sup_reason": role != GlobalLists.supervisorrole
                              ? ''
                              : reasonController.text,
                          "attendance_type": day.attendance_type,
                          'attendance_id': day.attendanceId,
                          // ),
                          if (hours > 0) "ot_hours": hours,
                        };

                        final apiData = {
                          'site_id': attendancesiteid.toString(),
                          'to_date': date,
                          'shift': shiftId,
                          'emp_id': [attendanceEntry],
                          'roster_image': '',
                          'user_id': attendanceclientid,
                          'client_id': role == GlobalLists.supervisorrole
                              ? GlobalLists.clientid
                              : attendanceclientid,
                          'month': month,
                          'year': year,
                        };

                        Navigator.pop(context);

                        // Submit to API
                        await _submitAttendaceRoster(apiData).then((v) async {
                          await _fetchAttendanceRoster();
                        });
                       
                        
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: customcolor.blue,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Save',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
            ],
          ),
        ),
      ),
    );
  }

  Color _getAttendanceColor(AttendanceData? day, bool isFuture) {
    //  Future or null
    if (isFuture || day == null) {
      return const Color(0xFFCBD5E1); // Grey
    } 
    
    // ⭐ NEW: National Holiday (HIGHEST PRIORITY)
  if (day.national_holiday != null && day.national_holiday!.isNotEmpty) {
    return  Color(0xFFF54927); // Purple
  }

    // 2 Deactivated janitor
    if (day.act_deact_janitor == false) {
      return Colors.grey[300]!;
    }

    // 3 Prepare empty checks
    bool isClientEmpty =
        day.client_approval_status == null ||
        day.client_approval_status!.isEmpty;

    bool isOmEmpty =
        day.om_oe_approval_status == null || day.om_oe_approval_status!.isEmpty;

    bool isReasonEmpty =
        day.reason == null || day.reason!.isEmpty || day.reason == 'NA';

    // 4 If ALL are empty → use attendance_type switch
    if (isClientEmpty && isOmEmpty && isReasonEmpty) {
     
      switch (day.attendance_type) {
        case 'P': // Present
          return const Color(0xFF22C55E);

        case 'A': // Absent
          return const Color(0xFFEF4444);

        case 'H': // Holiday
          return const Color(0xFF7DD3FC);

        case 'W': // Working on Holiday
          return const Color(0xFF2563EB);

        case 'F': // Half Day
          return const Color(0xFF4ADE80);
          //  case 'O': // Half Day
          // return const Color(0xFFCBD5E1);

        default:
          return const Color(0xFFCBD5E1);
      }
    }

    //  Client approval (highest priority)
    if (!isClientEmpty) {
      return day.client_approval_status == 'approved'
          ? Colors.green
          : customcolor.red;
    }

    //  OM/OE approval
    if (!isOmEmpty) {
      return day.om_oe_approval_status == 'approved'
          ? Colors.green
          : customcolor.red;
    }

    //  Reason
    if (!isReasonEmpty) {
      return customcolor.pink;
    }

    //  Final fallback
    return const Color(0xFFCBD5E1);
  }

  Color _getAttendanceTextColor(AttendanceData? day, bool isFuture) {
    if (isFuture || day == null) {
      return const Color(0xFFCBD5E1); // Grey
    }

    switch (day.attendance_type) {
      case 'P': // Present
        return const Color(0xFF166534); // Dark Green

      case 'A': // Absent
        return const Color(0xFF991B1B); // Dark Red

      case 'H': // Holiday
        return const Color(0xFF075985); // Blue

      case 'W': // Working on Holiday
        return const Color(0xFF6B21A8); // Dark Purple

      case 'F': // Half Day
        return const Color(0xFF92400E); // Semi Brown

      default: // Week Off
        return const Color(0xFF64748B); // Neutral Grey
    }
  }

  String _getAttendanceLabel(AttendanceData? day, bool isFuture) {
    if (isFuture || day == null) return '';

    switch (day.attendance_type) {
      case 'P': // Present
        return 'P';
      case 'A': // Absent
        return 'A';
      case 'H': // Holiday
        return 'H';
      case 'W': // Working on Holiday
        return 'W';
      case 'F': // Half Day
        return 'F';
      case 'O': // Half Day
        return '';
      case '': // Half Day
        return '-';
      default: // Week Off
        return '';
    }
  }

  void _showAttendanceDialog(dynamic emp, AttendanceData day, String date) {
    reasonController.clear();
    String? selectedAttendance = day.attendance_type;
    _isreasonshow = false;

    // Get OT hours from global storage
    final globalOT = OTHoursManager().getOTHours(emp.empId.toString(), date);
    bool hasOT =
        globalOT != null || (day.ot_hours != null && day.ot_hours! > 0);
    String otHours =
        globalOT?.toStringAsFixed(1) ?? (hasOT ? day.ot_hours.toString() : '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          padding: EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Modal Handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Color(0xFFCBD5E1),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                // Header
                Text(
                  'Mark Attendance',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 6),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        emp.empName,
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF3B82F6),
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(' • ', style: TextStyle(color: Color(0xFF64748B))),
                    Text(
                      DateFormat('EEE, MMM d').format(DateTime.parse(date)),
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF0F172A),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),

                // Attendance Status Section
                Text(
                  'ATTENDANCE STATUS',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF64748B),
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildModalOptionButton(
                        '✓',
                        'Present',
                        selectedAttendance == 'yes',
                        () {
                          setDialogState(() {
                            _isreasonshow = true;
                            selectedAttendance = 'yes';
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: _buildModalOptionButton(
                        '✗',
                        'Absent',
                        selectedAttendance == 'no',
                        () {
                          setDialogState(() {
                            _isreasonshow = true;
                            selectedAttendance = 'no';
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _buildModalOptionButton(
                        '½',
                        'Half Day',
                        selectedAttendance == 'halfday',
                        () {
                          setDialogState(() {
                            _isreasonshow = true;
                            selectedAttendance = 'halfday';
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: _buildModalOptionButton(
                        '📅',
                        'Holiday',
                        selectedAttendance == 'leave',
                        () {
                          setDialogState(() {
                            _isreasonshow = true;
                            selectedAttendance = 'leave';
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _buildModalOptionButton(
                        '⚒',
                        'Working on Holiday',
                        selectedAttendance == 'working on holiday',
                        () {
                          setDialogState(() {
                            _isreasonshow = true;
                            selectedAttendance = 'working on holiday';
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: _buildModalOptionButton(
                        '⏹',
                        'Week off',
                        selectedAttendance == 'week off',
                        () {
                          setDialogState(() {
                            _isreasonshow = true;
                            selectedAttendance = 'week off';
                          });
                        },
                      ),
                    ),
                  ],
                ),

                !_isreasonshow
                    ? SizedBox()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 24),

                          Text(
                            'REASON',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF64748B),
                              letterSpacing: 0.5,
                            ),
                          ),
                          SizedBox(height: 8),
                          TextFormField(
                            maxLines: 3,
                            controller: reasonController,
                            decoration: InputDecoration(
                              hintText: 'Enter reason',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onChanged: (value) {
                              // attendanceReason = value;
                            },
                          ),
                        ],
                      ),

                SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFF1F5F9),
                          foregroundColor: Color(0xFF0F172A),
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {

                          print("Clicked HERE");
                          if (selectedAttendance == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Please select attendance status',
                                ),
                                backgroundColor: Color(0xFFEF4444),
                              ),
                            );
                            return;
                          }

                          // Get OT hours from global storage
                          final otHours = OTHoursManager().getOTHours(
                            emp.empId.toString(),
                            date,
                          );
 if(role==GlobalLists.clientrole && reasonController.text.trim()=="")
                       {
                         ShowDialogs.showToast("Please enter reason");
                       }else{
                          // Prepare API data for single attendance
                          final attendanceEntry = {
                            "date": date,
                            "attendance_status": selectedAttendance,
                            "emp_id": emp.empId,
                            "attendance_id": day.attendanceId,
                            "attendance_type": _convertAttendanceTypeToAPI(
                              selectedAttendance,
                            ),
                          };
                          if (role != GlobalLists.supervisorrole) {
                            attendanceEntry['reason'] = reasonController.text;
                          }
                          if (role == GlobalLists.supervisorrole) {
                            attendanceEntry['sup_reason'] =
                                reasonController.text;
                          }

                          // Add OT hours if present
                          if (otHours != null && otHours > 0) {
                            attendanceEntry["ot_hours"] = otHours
                                .toStringAsFixed(1);
                          }

                          final apiData = {
                            'site_id': attendancesiteid.toString(),
                            'to_date': date,
                            'shift': shiftId,
                            'emp_id': [attendanceEntry],
                            'roster_image': '',
                            'user_id': attendanceclientid,
                            'client_id': role == GlobalLists.supervisorrole
                                ? GlobalLists.clientid
                                : attendanceclientid,
                            'month': month,
                            'year': year,
                            'ot_hours': otHours != null
                                ? otHours.toStringAsFixed(1)
                                : '',
                          };
                          // In _showAttendanceDialog, just before Navigator.pop(context)
                          log(
                            'Submitting attendanceId: ${day.attendanceId} for empId: ${emp.empId} date: $date',
                          );

                          Navigator.pop(context);

                          // Submit to API
                          await _submitAttendaceRoster(apiData);
                       }
                        },

                        style: ElevatedButton.styleFrom(
                          backgroundColor: customcolor.blue,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Save',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModalOptionButton(
    String icon,
    String label,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFFEFF6FF) : Colors.white,
          border: Border.all(
            color: isSelected ? Color(0xFF3B82F6) : Color(0xFFE2E8F0),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(icon, style: TextStyle(fontSize: 22)),
            SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? Color(0xFF3B82F6) : Color(0xFF0F172A),
              ),
            ),
          ],
        ),
      ),
    );
  }

  dynamic _getAttendanceId(String empId, String date) {
    for (var shift in _attendanceRosterData) {
      for (var emp in shift.employeeList) {
        if (emp.empId.toString() == empId) {
          for (var attend in emp.attendData) {
            if (attend.date == date) {
              return attend.attendanceId ?? '';
            }
          }
        }
      }
    }
    return '';
  }

  void _showBulkMarkingDialog() {
    if (selectedEmployees.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select at least one employee'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );

      return;
    }

    // Reset bulk selection state
    selectedDates.clear();
    bulkAttendanceStatus = null;
    bulkHasOT = false;
    bulkOTHours = '';
    _isreasonshow = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          padding: EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Color(0xFFCBD5E1),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                // Header
                Text(
                  'Bulk Mark Attendance',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Color(0xFFF3E8FF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${selectedEmployees.length} employee${selectedEmployees.length != 1 ? 's' : ''} selected',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF6B21A8),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 24),

                // Multi-Date Selection
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'SELECT DATES',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF64748B),
                        letterSpacing: 0.5,
                      ),
                    ),
                    if (selectedDates.isNotEmpty)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFFDBEAFE),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${selectedDates.length} date${selectedDates.length != 1 ? 's' : ''}',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF3B82F6),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 12),

                // Date selection buttons
                Row(
                  children: [
                    Expanded(
                      child: _buildDateSelectionButton(
                        'Pick Dates',
                        Icons.calendar_today,
                        () => _showMultiDatePicker(context, setDialogState),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: _buildDateSelectionButton(
                        'Date Range',
                        Icons.date_range,
                        () => _showDateRangePicker(context, setDialogState),
                      ),
                    ),
                  ],
                ),

                // Show selected dates
                if (selectedDates.isNotEmpty) ...[
                  SizedBox(height: 12),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Color(0xFFE2E8F0)),
                    ),
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children:
                          (selectedDates.toList()
                                ..sort((a, b) => a.compareTo(b)))
                              .map<Widget>((date) {
                                return Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF3B82F6),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        DateFormat(
                                          'MMM d',
                                        ).format(DateTime.parse(date)),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(width: 6),
                                      GestureDetector(
                                        onTap: () {
                                          setDialogState(() {
                                            selectedDates.remove(date);
                                          });
                                        },
                                        child: Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              })
                              .toList(),
                    ),
                  ),
                ],

                SizedBox(height: 24),

                // Attendance Status
                Text(
                  'ATTENDANCE STATUS',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF64748B),
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildModalOptionButton(
                        '✓',
                        'Present',
                        bulkAttendanceStatus == 'yes',
                        () {
                          setDialogState(() {
                            _isreasonshow = true;
                            bulkAttendanceStatus = 'yes';
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: _buildModalOptionButton(
                        '✗',
                        'Absent',
                        bulkAttendanceStatus == 'no',
                        () {
                          setDialogState(() {
                            _isreasonshow = true;
                            bulkAttendanceStatus = 'no';
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _buildModalOptionButton(
                        '½',
                        'Half Day',
                        bulkAttendanceStatus == 'halfday',
                        () {
                          setDialogState(() {
                            _isreasonshow = true;
                            bulkAttendanceStatus = 'halfday';
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: _buildModalOptionButton(
                        '📅',
                        'Holiday',
                        bulkAttendanceStatus == 'leave',
                        () {
                          setDialogState(() {
                            _isreasonshow = true;
                            bulkAttendanceStatus = 'leave';
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _buildModalOptionButton(
                        '⚒',
                        'Working on Holiday',
                        bulkAttendanceStatus == 'working on holiday',
                        () {
                          setDialogState(() {
                            _isreasonshow = true;
                            bulkAttendanceStatus = 'working on holiday';
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: _buildModalOptionButton(
                        '⏹',
                        'Week off',
                        bulkAttendanceStatus == 'week off',
                        () {
                          setDialogState(() {
                            _isreasonshow = true;
                            bulkAttendanceStatus = 'week off';
                          });
                        },
                      ),
                    ),
                  ],
                ),

                !_isreasonshow
                    ? SizedBox()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 24),

                          Text(
                            'REASON',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF64748B),
                              letterSpacing: 0.5,
                            ),
                          ),
                          SizedBox(height: 8),
                          TextFormField(
                            maxLines: 3,
                            controller: reasonController,
                            decoration: InputDecoration(
                              hintText: 'Enter reason',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onChanged: (value) {
                              // attendanceReason = value;
                            },
                          ),
                        ],
                      ),

                SizedBox(height: 24),

                // Overtime Section
                Text(
                  'OVERTIME',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF64748B),
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildModalOptionButton('⏱', 'Yes', bulkHasOT, () {
                        setDialogState(() {
                          bulkHasOT = true;
                        });
                      }),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: _buildModalOptionButton('—', 'No', !bulkHasOT, () {
                        setDialogState(() {
                          bulkHasOT = false;
                          bulkOTHours = '';
                        });
                      }),
                    ),
                  ],
                ),

                if (bulkHasOT) ...[
                  SizedBox(height: 12),
                  Text(
                    'OT Hours (Same for all selected dates)',
                    style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
  controller: hoursController,
  keyboardType: TextInputType.numberWithOptions(decimal: true),

  inputFormatters: [
    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,1}')),
  ],

  validator: (value) {
    if (value == null || value.isEmpty) {
      return "Enter hours";
    }

    final number = double.tryParse(value);
    if (number == null) {
      return "Invalid number";
    }

    if (number < 0 || number > 30) {
      return "Must be between 0 and 30";
    }

    return null;
  },

                    decoration: InputDecoration(
                      
                      hintText: 'e.g., 2.5',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Color(0xFFE2E8F0),
                          width: 2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Color(0xFFE2E8F0),
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Color(0xFF3B82F6),
                          width: 2,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),

                      prefixIcon: Icon(
                        Icons.access_time,
                        color: Color(0xFF64748B),
                      ),
                    ),  
  // decoration: InputDecoration(
  //   hintText: 'e.g., 2.5',
  //   border: OutlineInputBorder(
  //     borderRadius: BorderRadius.circular(12),
  //   ),
  //   prefixIcon: Icon(Icons.access_time),
  //   suffixText: 'hours',
  // ),

  onChanged: (value) {
    final number = double.tryParse(value);

    if (number != null && number > 30) {
      // Clear field
      hoursController.clear();

      // Show message
       ShowDialogs.showToast('OT should be maximum 30 hr');
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text("OT should be maximum 30 hr"),
      //     backgroundColor: Colors.red,
      //   ),
      // );
    } else {
      bulkOTHours = value;
    }
  },
),
//                   TextFormField(
//                      validator: (value) {
//     if (value == null || value.isEmpty) {
//       return "Enter hours";
//     }

//     final number = double.tryParse(value);
//     if (number == null) {
//       return "Invalid number";
//     }

//     if (number < 0 || number > 30) {
//       return "Must be between 0 and 30";
//     }

//     return null;
//   },
//                     decoration: InputDecoration(
                      
//                       hintText: 'e.g., 2.5',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide(
//                           color: Color(0xFFE2E8F0),
//                           width: 2,
//                         ),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide(
//                           color: Color(0xFFE2E8F0),
//                           width: 2,
//                         ),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide(
//                           color: Color(0xFF3B82F6),
//                           width: 2,
//                         ),
//                       ),
//                       contentPadding: EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 14,
//                       ),

//                       prefixIcon: Icon(
//                         Icons.access_time,
//                         color: Color(0xFF64748B),
//                       ),
                      
//                       suffixText: 'hours',
//                     ),
                    
//  keyboardType: TextInputType.numberWithOptions(decimal: true),
//   inputFormatters: [
//     FilteringTextInputFormatter.allow(
//       RegExp(r'^\d{0,2}(\.\d{0,1})?$'),
//     ),
//   ],
//   // keyboardType: const TextInputType.numberWithOptions(
//   //   decimal: true,
//   //   signed: false,
//   // ),

//   // // ✅ THIS IS THE FIX
//   // inputFormatters: [
//   //   FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
//   // ],

//                     // keyboardType: TextInputType.numberWithOptions(
//                     //   decimal: true,signed: false
//                     // ),
//                     style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
//                     onChanged: (value) {
//                       bulkOTHours = value;
//                     },
//                   ),
                  SizedBox(height: 8),
                  Text(
                    'Note: This OT value will be applied to all selected dates',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF94A3B8),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],

                SizedBox(height: 24),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFF1F5F9),
                          foregroundColor: Color(0xFF0F172A),
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          // Validation
                          if (selectedDates.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Please select at least one date',
                                ),
                                backgroundColor: Color(0xFFEF4444),
                              ),
                            );
                            return;
                          }

                          if (bulkAttendanceStatus == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Please select attendance status',
                                ),
                                backgroundColor: Color(0xFFEF4444),
                              ),
                            );
                            return;
                          }

                          if (bulkHasOT && bulkOTHours.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Please enter OT hours'),
                                backgroundColor: Color(0xFFEF4444),
                              ),
                            );
                            return;
                          }

                          // Apply bulk marking and save to global storage
                          final hours = bulkHasOT && bulkOTHours.isNotEmpty
                              ? (double.tryParse(bulkOTHours) ?? 0.0)
                              : 0.0;

                          // Prepare bulk attendance entries
                          List<Map<String, dynamic>> attendanceEntries = [];

                          for (var empId in selectedEmployees) {
                            log(selectedEmployees.toString());
                            for (var date in selectedDates) {
                              final attendanceId = _getAttendanceId(
                                empId,
                                date,
                              );
                              // Save OT hours to global storage
                              if (bulkHasOT && hours > 0) {
                                OTHoursManager().setOTHours(empId, date, hours);
                              }

                              // Create entry for this employee and date
                              Map<String, dynamic> entry = {
                                "date": date,
                                "attendance_id": attendanceId,
                                "attendance_status": bulkAttendanceStatus,
                                "emp_id": int.parse(empId),

                                "attendance_type": _convertAttendanceTypeToAPI(
                                  bulkAttendanceStatus,
                                ),
                              };
                              if (role != GlobalLists.supervisorrole) {
                                entry['reason'] = reasonController.text;
                              }
                              if (role == GlobalLists.supervisorrole) {
                                entry['sup_reason'] = reasonController.text;
                              }

                              // Add OT hours if applicable
                              if (bulkHasOT && hours > 0) {
                                entry["ot_hours"] = hours;
                              }

                              attendanceEntries.add(entry);
                            }
                          }

                          log('attendanceEntries ${attendanceEntries}');

                          final apiData = {
                            'site_id': attendancesiteid.toString(),
                            'to_date': selectedDates.first,
                            'shift': shiftId,
                            'emp_id': attendanceEntries,
                            'roster_image': '',
                            'user_id': attendanceclientid,
                            'client_id': attendanceclientid,

                            'month': month,
                            'year': year,
                            'ot_hours': bulkHasOT
                                ? hours.toStringAsFixed(1)
                                : '',
                          };

                          Navigator.pop(context);

                          // Submit to API
                          await _submitAttendaceRoster(apiData);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: customcolor.blue,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Apply to All',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showTopSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: Colors.white)),
        backgroundColor: color,
        duration: Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(top: 20, left: 16, right: 16),
      ),
    );
  }

  Widget _buildDateSelectionButton(
    String label,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: Color(0xFFF8FAFC),
          border: Border.all(color: Color(0xFFE2E8F0), width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Color(0xFF3B82F6), size: 18),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0F172A),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMultiDatePicker(
    BuildContext context,
    StateSetter setDialogState,
  ) async {
    final currentYear = int.parse(year);
    final currentMonth = int.parse(month);

    // Get available dates from the current month
    final firstDay = DateTime(currentYear, currentMonth, 1);
    final lastDay = DateTime(currentYear, currentMonth + 1, 0);
    final today = DateTime.now();

    final availableDates = <DateTime>[];
    for (var i = 1; i <= lastDay.day; i++) {
      final date = DateTime(currentYear, currentMonth, i);
      if (!date.isAfter(today)) {
        availableDates.add(date);
      }
    }

    final tempSelectedDates = Set<String>.from(selectedDates);

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setPickerState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.75,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                // Handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: EdgeInsets.only(top: 12, bottom: 16),
                    decoration: BoxDecoration(
                      color: Color(0xFFCBD5E1),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                // Header
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Select Multiple Dates',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '${monthNames[currentMonth]} $currentYear - Tap to select/deselect',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                      if (tempSelectedDates.isNotEmpty)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFF3B82F6),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${tempSelectedDates.length}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                SizedBox(height: 20),

                // Weekday headers
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: ['S', 'M', 'T', 'W', 'T', 'F', 'S'].map((day) {
                      return Container(
                        width:
                            (MediaQuery.of(context).size.width - 48 - 42) / 7,
                        child: Center(
                          child: Text(
                            day,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                SizedBox(height: 12),

                // Date grid
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 7,
                          crossAxisSpacing: 6,
                          mainAxisSpacing: 6,
                          childAspectRatio: 1.0,
                        ),
                        itemCount: availableDates.length,
                        itemBuilder: (context, index) {
                          final date = availableDates[index];
                          final dateStr = DateFormat('yyyy-MM-dd').format(date);
                          final isSelected = tempSelectedDates.contains(
                            dateStr,
                          );
                          final isToday =
                              DateFormat('yyyy-MM-dd').format(DateTime.now()) ==
                              dateStr;
                          final isWeekend =
                              date.weekday == 6 || date.weekday == 7;

                          return InkWell(
                            onTap: () {
                              setPickerState(() {
                                if (isSelected) {
                                  tempSelectedDates.remove(dateStr);
                                } else {
                                  tempSelectedDates.add(dateStr);
                                }
                              });
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Color(0xFF3B82F6)
                                    : isToday
                                    ? Color(0xFFDBEAFE)
                                    : isWeekend
                                    ? Color(0xFFFEF2F2)
                                    : Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isSelected
                                      ? Color(0xFF3B82F6)
                                      : isToday
                                      ? Color(0xFF3B82F6).withOpacity(0.3)
                                      : Color(0xFFE2E8F0),
                                  width: isSelected ? 2 : 1,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  date.day.toString(),
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: isSelected || isToday
                                        ? FontWeight.w700
                                        : FontWeight.w600,
                                    color: isSelected
                                        ? Colors.white
                                        : isToday
                                        ? Color(0xFF3B82F6)
                                        : Color(0xFF0F172A),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),

                // Action buttons
                Padding(
                  padding: EdgeInsets.all(24),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFF1F5F9),
                            foregroundColor: Color(0xFF0F172A),
                            padding: EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setDialogState(() {
                              selectedDates = tempSelectedDates;
                            });
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: customcolor.blue,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Done (${tempSelectedDates.length})',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showDateRangePicker(
    BuildContext context,
    StateSetter setDialogState,
  ) async {
    final currentYear = int.parse(year);
    final currentMonth = int.parse(month);
    final today = DateTime.now();

    final result = await showDateRangePicker(
      context: context,
      firstDate: DateTime(currentYear, currentMonth, 1),
      lastDate: today,
      initialDateRange: null,
      helpText: 'Select Date Range',
      cancelText: 'Cancel',
      confirmText: 'Done',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: customcolor.blue,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF0F172A),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: customcolor.blue,
                textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (result != null) {
      setDialogState(() {
        selectedDates.clear();

        // Add all dates in the range
        DateTime current = result.start;
        while (current.isBefore(result.end) ||
            current.isAtSameMomentAs(result.end)) {
          selectedDates.add(DateFormat('yyyy-MM-dd').format(current));
          current = current.add(Duration(days: 1));
        }
      });

      // Show confirmation snackbar
      final daysCount = selectedDates.length;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Selected $daysCount date${daysCount != 1 ? 's' : ''} from ${DateFormat('MMM d').format(result.start)} to ${DateFormat('MMM d').format(result.end)}',
          ),
          backgroundColor: Color(0xFF3B82F6),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }

  // NEW: Month Picker
  void _showMonthPicker(BuildContext context, int currentMonth) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,

      builder: (context) => Container(
        height: _isLandscap ? 280 : 350,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: SafeArea(
          // top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: EdgeInsets.only(top: 12, bottom: 16),
                  decoration: BoxDecoration(
                    color: Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Select Month',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Color(0xFF64748B)),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 8),

              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: 12,
                  itemBuilder: (context, index) {
                    final monthIndex = index + 1;
                    final monthName = monthNames[monthIndex];
                    final monthNameShort = monthNamesShort[monthIndex];
                    final isSelected = monthIndex == currentMonth;
                    final isCurrentMonth =
                        monthIndex == DateTime.now().month &&
                        selectedYear == DateTime.now().year;

                    return InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          selectedMonthIndex = monthIndex;
                          _reloadDataForMonth(selectedMonthIndex!);
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Color(0xFFEFF6FF)
                              : Colors.transparent,
                          border: Border(
                            bottom: BorderSide(
                              color: Color(0xFFE2E8F0),
                              width: 1,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  monthName,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                    color: isSelected
                                        ? Color(0xFF3B82F6)
                                        : Color(0xFF0F172A),
                                  ),
                                ),
                                if (isCurrentMonth) ...[
                                  SizedBox(width: 8),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Color(0xFF22C55E),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      'Current',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            Text(
                              monthNameShort,
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF64748B),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (isSelected)
                              Icon(
                                Icons.check_circle,
                                color: Color(0xFF3B82F6),
                                size: 24,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _showYearPicker(BuildContext context, int currentYear) {
    final currentYearNow = DateTime.now().year;
    final years = List.generate(
      currentYearNow - 2023 + 2,
      (index) => 2023 + index,
    ).reversed.toList();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: _isLandscap ? 350 : 350,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: EdgeInsets.only(top: 12, bottom: 16),
                decoration: BoxDecoration(
                  color: Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Year',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Color(0xFF64748B)),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            SizedBox(height: 8),

            Expanded(
              // constraints: BoxConstraints(maxHeight: 400),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: years.length,
                itemBuilder: (context, index) {
                  final year = years[index];
                  final isSelected = year == currentYear;
                  final isCurrent = year == currentYearNow;

                  return InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        this.year = year.toString();
                        selectedYear = year;
                        _reloadDataForMonth(selectedMonthIndex!);
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Color(0xFFEFF6FF)
                            : Colors.transparent,
                        border: Border(
                          bottom: BorderSide(
                            color: Color(0xFFE2E8F0),
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                year.toString(),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  color: isSelected
                                      ? Color(0xFF3B82F6)
                                      : Color(0xFF0F172A),
                                ),
                              ),
                              if (isCurrent) ...[
                                SizedBox(width: 8),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF22C55E),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    'Current',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          if (isSelected)
                            Icon(
                              Icons.check_circle,
                              color: Color(0xFF3B82F6),
                              size: 24,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // Helper method to convert attendance status to API format
  String _convertAttendanceTypeToAPI(String? status) {
    switch (status) {
      case 'yes':
        return 'P'; // Present
      case 'no':
        return 'A'; // Absent
      case 'halfday':
        return 'F'; // Half day
      case 'leave':
        return 'H'; // Holiday/Leave
      case 'working on holiday':
        return 'W';
      case 'week off':
        return 'O';
      default:
        return '';
    }
  }

  _submitAttendaceRoster(Map<String, dynamic>? apiData) async {
    try {
      var status1 = await ConnectionDetector.checkInternetConnection();
      if (!status1) {
        ShowDialogs.showToast("Please check internet connection");
        return;
      }

      String currentDate = DateTime.now().toIso8601String().split('T').first;
      log('Current date for submission: $currentDate');

      var supervisorid = await SPManager().getsupervisorid();

      // Prepare the map according to API requirements
      var map = {
        'site_id': apiData!['site_id'] ?? '',
        'to_date': currentDate,
        // 'shift': apiData['shift'] ?? '',
        'shift': _attendanceRosterData[0].id.toString(),
        'emp_id': jsonEncode(apiData['emp_id'] ?? []),
        'month': month,
        'year': year,
        "client_id": apiData['user_id'],
        // "user_id":apiData['user_id'],
        // 'ot_hours': apiData['ot_hours'] ?? '',
        // 'roster_image': apiData['roster_image'] ?? '',
      };
      if (GlobalLists.clientrole == role) {
        map["user_id"] = apiData['user_id'];
      } else {
        map["user_id"] = supervisorid;
      }

      log(' API Request Data: ${jsonEncode(map)}');

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator()),
      );

      await APIManager().apiRequest(
        context,
        API.submit_client_attendance_rooster,
        (response) async {
          Navigator.pop(context); // Close loading dialog

          SubmitAttendanceRooster resp = response;
          log(' API Response: ${resp.status} - ${resp.msg}');
          log("client_attendance_type ${resp.data}");
          if (resp.status == 1) {
            // Clear OT data after successful submission
            if (apiData['emp_id'] is List) {
              for (var entry in apiData['emp_id']) {
                if (entry is Map) {
                  OTHoursManager().clearOTHours(
                    entry['emp_id'].toString(),
                    entry['date'].toString(),
                  );
                }
              }
            }

            setState(() {
              isBulkMode = false;
              selectedEmployees.clear();
              selectedDates.clear();
            });

            ShowDialogs.showToast('${resp.msg}');

            // Refresh the data
            await _fetchAttendanceRoster();
          } else {
            ShowDialogs.showToast('${resp.msg}');
          }
        },
        (error) {
          Navigator.pop(context); // Close loading dialog
          log(' Error submitting attendance: $error');
          ShowDialogs.showToast('Error: $error');
        },
        false,
        "",
        jsonval: map,
      );
    } catch (e) {
      log(' Exception in _submitAttendaceRoster: $e');
      ShowDialogs.showToast('Exception: $e');
    }
  }

  _submitAttendaceRosterfinal(dynamic selectedShift) async {
    try {
      var status1 = await ConnectionDetector.checkInternetConnection();
      if (!status1) {
        ShowDialogs.showToast("Please check internet connection");
        return;
      }
      String currentDate = DateTime.now().toIso8601String().split('T').first;

      log('Current date for submission final: $currentDate');
      var supervisorid = await SPManager().getsupervisorid();

      // Handle selectedShift - if it's already a string, use it directly
      // If it's an object with id property, get the id
      String shiftValue = "";
      if (selectedShift is String) {
        shiftValue = selectedShift;
      } else if (selectedShift != null && selectedShift.id != null) {
        shiftValue = selectedShift.id.toString();
      }

      // Prepare the map according to API requirements
      var map = {
        'site_id': '$attendancesiteid', // Use attendancesiteid directly
        'to_date': currentDate,
        'shift': shiftValue, // Use the properly extracted shift value
        'client_id': GlobalLists.clientrole == role
            ? '$attendanceclientid'
            : supervisorid,
        'user_id': GlobalLists.clientrole == role
            ? '$attendanceclientid'
            : supervisorid,
        'emp_id': jsonEncode([]),
        'month': month,
        'year': year,
      };

      log('Submitting attendance data: $map');

      await APIManager().apiRequest(
        context,
        API.submit_client_attendance_rooster,
        (response) async {
          SubmitAttendanceRooster resp = response;
          print('API Response: $resp');
          if (resp.status == 1) {
            setState(() {
              Timer(Duration(seconds: 1), () => Navigator.pop(context));

              Timer(
                Duration(seconds: 1),
                () => Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) =>
                        Attendance(GlobalLists.mainlisttab[maintag].clientName),
                    transitionDuration: Duration(seconds: 0),
                  ),
                ),
              );
              ShowDialogs.showToast('${resp.msg}');
            });
          } else {
            // Handle non-successful response if needed
          }
        },
        (error) {
          print('Error submitting attendance: $error');
          ShowDialogs.showToast('Error: $error');
        },
        false,
        "",
        jsonval: map,
      );
    } catch (e) {
      log('Error submitting attendance roster: $e');
      ShowDialogs.showToast('Exception: $e');
    }
  }

  Widget _buildChoicemainListfortab() {
    final selectedItem = maintag < GlobalLists.mainlisttab.length
        ? GlobalLists.mainlisttab[maintag]
        : null;

    return Row(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () async {
            TextEditingController searchController = TextEditingController();
            List filteredList = List.from(GlobalLists.mainlisttab);

            await showDialog(
              context: context,
              builder: (_) {
                return StatefulBuilder(
                  builder: (context, setStateDialog) => Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      constraints: BoxConstraints(maxHeight: 500),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: TextField(
                              controller: searchController,
                              decoration: InputDecoration(
                                hintText: "Search Client...",
                                prefixIcon: Icon(Icons.search),
                                suffixIcon: searchController.text.isNotEmpty
                                    ? IconButton(
                                        icon: Icon(Icons.cancel_outlined),
                                        onPressed: () {
                                          searchController.clear();
                                          setStateDialog(() {
                                            filteredList = List.from(
                                              GlobalLists.mainlisttab,
                                            );
                                          });
                                        },
                                      )
                                    : null,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 10,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onChanged: (query) {
                                setStateDialog(() {
                                  filteredList = GlobalLists.mainlisttab
                                      .where(
                                        (item) => item.clientName
                                            .toLowerCase()
                                            .contains(query.toLowerCase()),
                                      )
                                      .toList();
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: filteredList.isEmpty
                                ? Center(
                                    child: Text(
                                      "No client found.",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    itemCount: filteredList.length,
                                    itemBuilder: (context, index) {
                                      final item = filteredList[index];
                                      final isSelected = item == selectedItem;
                                      final color = isSelected
                                          ? customcolor.tabblue
                                          : item.lowattendance == true
                                          ? customcolor.red
                                          : item.clientName.contains('OverAll')
                                          ? customcolor.tabblue
                                          : customcolor.green;

                                      return ListTile(
                                        title: item.clientName == 'OverAll'
                                            ? SizedBox()
                                            : Text(
                                                item.clientName,
                                                style: AppFonts.headerStyle(
                                                  fontSize: 14,
                                                  color: color,
                                                  fontWeight: isSelected
                                                      ? FontWeight.bold
                                                      : FontWeight.w500,
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
                                          Navigator.pop(context);
                                          final value = GlobalLists.mainlisttab
                                              .indexOf(item);
                                          setState(() {
                                            _isSelected = item.clientName;
                                            maintag = value;
                                            maintag = 0;

                                            attendancesiteid = item.siteId
                                                .toString();
                                            attendanceclientid = item.clientId
                                                .toString();

                                            // if (role ==
                                            //     GlobalLists.supervisorrole) {
                                            //   // attendanceshiftid = "";
                                            // } else if (item
                                            //     .attendanceDetails
                                            //     .isNotEmpty) {
                                            //   attendanceshiftid = item
                                            //       .attendanceDetails[0]
                                            //       .id
                                            //       .toString();
                                            // }

                                            for (
                                              int i = 0;
                                              i < item.attendanceDetails.length;
                                              i++
                                            ) {
                                              if (item
                                                      .attendanceDetails[i]
                                                      .currentTime ==
                                                  true) {
                                                // tag = i;
                                                attendancesiteid = item.siteId
                                                    .toString();
                                                attendanceclientid = item
                                                    .clientId
                                                    .toString();
                                                // attendanceshiftid =
                                                //     role ==
                                                //         GlobalLists
                                                //             .supervisorrole
                                                //     ? ""
                                                //     : item
                                                //           .attendanceDetails[i]
                                                //           .id
                                                //           .toString();
                                              }
                                            }
                                            _fetchAttendanceRoster();

                                            // janotoragendaApi(
                                            //   attendanceclientid,
                                            //   attendancesiteid,
                                            // );
                                          });
                                        },
                                      );
                                    },
                                  ),
                          ),
                        ],
                      ),
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
                border: Border.all(color: customcolor.white, width: 1.2),
              ),
              child: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: customcolor.tabblue,
                size: 24,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showRosterLockDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.lock_outline, color: customcolor.blue),
              SizedBox(width: 8),
              Text(
                "Confirm Lock",
                style: TextStyle(fontFamily: AppFonts.semibold, fontSize: 18),
              ),
            ],
          ),
          content: Text(
            "Are you sure you want to lock the roster?\n\nOnce locked, changes cannot be modified.",
            style: TextStyle(fontFamily: AppFonts.regular, fontSize: 14),
          ),
          actionsPadding: EdgeInsets.only(right: 12, bottom: 10),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cancel
              },
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.grey,
                  fontFamily: AppFonts.semibold,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: customcolor.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                _fredgeAttendaceRoster();
                Navigator.pop(context);

                //  Your lock API / logic here
                log("Roster Locked");

                // ShowDialogs.showToast("Roster locked successfully");
              },
              child: Text(
                "Submit",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: AppFonts.semibold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  _fredgeAttendaceRoster() async {
    try {
      var status1 = await ConnectionDetector.checkInternetConnection();
      if (!status1) {
        ShowDialogs.showToast("Please check internet connection");
        return;
      }

      String currentDate = DateTime.now().toIso8601String().split('T').first;

      var supervisorid = await SPManager().getsupervisorid();
      final now = DateTime.now();

      if ((month == null || month.isEmpty) && (year == null || year.isEmpty)) {
        if (now.month == 1) {
          month = "12";
          year = (now.year - 1).toString();
        } else {
          month = now.month.toString().padLeft(2, '0');
          year = now.year.toString();
        }
      }

      int selectedMonth = int.parse(month);
      int selectedYear = int.parse(year);

      final firstDayOfMonth = DateTime(selectedYear, selectedMonth, 1);
      final lastDayOfMonth = DateTime(selectedYear, selectedMonth + 1, 0);

      // Prepare the map according to API requirements
      var map = {
        'site_id': attendancesiteid.toString(),
        'client_id': GlobalLists.clientid,
        // 'from_date': DateFormat('yyyy-MM-dd').format(firstDayOfMonth),
        // 'to_date': DateFormat('yyyy-MM-dd').format(lastDayOfMonth),
        "month": "$month",
        "year": "$year",
      };

      log(' API Request Data: ${jsonEncode(map)}');

      await APIManager().apiRequest(
        context,
        API.supervisor_submit_attendance_rooster,
        (response) async {
          // Close loading dialog

          FridgeAttendanceRosterResponse resp = response;
          // log(' API Response: ${resp.status} - ${resp.msg}');

          if (resp.status == 1) {
            ShowDialogs.showToast('${resp.msg}');
            //  Navigator.pop(context);
            _fetchAttendanceRoster();
          } else {
            ShowDialogs.showToast('${resp.msg}');
          }
        },
        (error) {
          Navigator.pop(context); // Close loading dialog
          log(' Error submitting attendance: $error');
          ShowDialogs.showToast('Error: $error');
        },
        false,
        "",
        jsonval: map,
      );
    } catch (e) {
      log(' Exception in _submitAttendaceRoster: $e');
      ShowDialogs.showToast('Exception: $e');
    }
  }
}

