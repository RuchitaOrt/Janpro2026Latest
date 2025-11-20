import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:janpro/Screens/Homepage.dart';
import 'package:janpro/Screens/Training.dart';
import 'package:janpro/Utitlity/APIManager.dart';
import 'package:janpro/Utitlity/AppDrawer.dart';
import 'package:janpro/Utitlity/FormTextField.dart';

import 'package:janpro/Utitlity/GlobalLists.dart';
import 'package:janpro/Utitlity/LocationService.dart';
import 'package:janpro/Utitlity/SPManager.dart';
import 'package:janpro/Utitlity/ShowDialog.dart';
import 'package:janpro/Utitlity/appbar.dart';

import 'package:janpro/Utitlity/customBottomNavigationBar.dart';
import 'package:janpro/Utitlity/custom_color.dart';
import 'package:janpro/Utitlity/internetConnection.dart';
import 'package:janpro/Utitlity/linechart.dart';
import 'package:janpro/Utitlity/sizeConfig.dart';
import 'package:janpro/model/AddAttendanceResponse.dart' as addattten;
import 'package:janpro/model/AttendencelistResponse.dart';
import 'package:janpro/model/DeleteAttendance.dart' as deleteatt;
import 'package:janpro/model/JanitorContactFetchResponse.dart';
import 'package:janpro/model/JanitorslistResponse.dart';
import 'package:janpro/model/unitAttendanceResponse.dart' as unitatt;
import 'package:janpro/model/unitGraphAttendanceResponse.dart' as graph;
import 'package:page_transition/page_transition.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart' as permishan;
import 'package:janpro/model/UnitsiteMasterResponse.dart' as sitemaster;
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:math' as math;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../DBHelper/db_helper.dart';
import '../const/global.dart';
import '../model/AddDailyCountResponse.dart';
import '../model/attendance_roster_response.dart';
import '../model/unitGraphAttendanceResponse.dart' as unitgraph;
import 'attendance_roster.dart';

class MainList {
  final String name;
  final String priority;

  MainList(this.name, this.priority);
}

class Attendance extends StatefulWidget {
  final String? clientname;

  Attendance(this.clientname);
  //overall im getting

  @override
  _AttendanceState createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> with TickerProviderStateMixin {
  var searchcontroller = new TextEditingController();
  var namecontroller = new TextEditingController();
  var sitenamecontroller = new TextEditingController();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  final GlobalKey<ScaffoldState> _scaffoldKey1 = new GlobalKey<ScaffoldState>();

  var mobilecontroller = new TextEditingController();
  // var datecontroller = new TextEditingController();
  var clientnamecontroller = new TextEditingController();
  List<EmployeeList> unitemployeelist = [];
  // List<Janitorcheckbox> dropdownList = [];
  var selectedDateTime;
  String selectedValue = "Pending";
  String? lat;
  String? long;
  List<String> listtab = [];
  bool isexpandedjanitor = false;
  List<String>? formValue1;
  int tag = 0;
  int maintag = 0;
  int mainlaglastposition_overall = 0;
  String clientname = "";

  String _isSelected = "";
  // List<unitatt.Datum> mainlisttab = [];
  // late Data attendancedata;
  bool isdataloaded = false;
  List<EmployeeList> searchUserList = [];
  String? role = "1";
  late TabController _tabControllermain;
  final List<Tab> tabsmain = <Tab>[];
  int selectedindex = 0;
  bool showAvg = false;
  bool isexpandedclient = false;
  bool isexpanded = false;
  String attendanceclientid = "";
  String attendancesiteid = "";
  String attendanceshiftid = "";

  bool _showRoster = false;
  List<dynamic> _attendanceRosterData = [];
  bool _isLoadingRoster = false;
  DateTime _currentMonth = DateTime.now();

  final scrollController = ScrollController();
  bool isExpandedSite = false;
  @override
  void initState() {
    log('client_name${widget.clientname}');
    super.initState();
    var datefrom = DateFormat('dd-MM-yyyy').format(DateTime.now());
    GlobalLists.datecontroller.text = datefrom;
    log('GlobalLists.dropdownList${GlobalLists.dropdownList}');
    print('GlobalLists.siteid: ${GlobalLists.siteid}');
    print("date ");
    getrole();
  }

  String month = '';
  String year = '';

  Map<String, String> monthMap = {
    'January': '01',
    'February': '02',
    'March': '03',
    'April': '04',
    'May': '05',
    'June': '06',
    'July': '07',
    'August': '08',
    'September': '09',
    'October': '10',
    'November': '11',
    'December': '12',
  };

  _fetchAttendanceRoster() async {
    print('Site Id: $attendancesiteid');
    print('GlobalLists.siteid: ${GlobalLists.siteid}');
    try {
      var status1 = await ConnectionDetector.checkInternetConnection();
      if (!status1) {
        ShowDialogs.showToast("Please check internet connection");
        return;
      }

      final now = DateTime.now();
      final firstDay = DateTime(now.year, 1, 1); // January 1st
      final lastDay = DateTime(now.year, 12, 31); // December 31st
      if ((month == null || month.isEmpty) && (year == null || year.isEmpty)) {
        final now = DateTime.now();
        month = now.month.toString().padLeft(2, '0'); // "01" to "12"
        year = now.year.toString(); // "2025"
      }
      var map = {
        'site_id': attendancesiteid,
        'from_date': DateFormat('yyyy-MM-dd').format(firstDay),
        'to_date': DateFormat('yyyy-MM-dd').format(lastDay),
        "month": "$month",
        "year": "$year",
      };

      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator()),
      );

      APIManager().apiRequest(
        context,
        API.attendance_roster,
        (response) async {
          Navigator.pop(context); // Dismiss loading dialog

          try {
            print('Raw API response: $response');
            print('Response runtime type: ${response.runtimeType}');

            if (response == null) {
              ShowDialogs.showToast('Received null response from server');
              return;
            }

            AttendanceRosterResponse rosterResponse;

            if (response is AttendanceRosterResponse) {
              // Already parsed response
              rosterResponse = response;
            } else if (response is Map<String, dynamic>) {
              // Raw Map response
              rosterResponse = AttendanceRosterResponse.fromJson(response);
            } else if (response is String) {
              // JSON string response
              final responseMap = json.decode(response) as Map<String, dynamic>;
              rosterResponse = AttendanceRosterResponse.fromJson(responseMap);
            } else {
              throw Exception('Unexpected response type');
            }

            if (rosterResponse.status == "success") {
              setState(() {
                _attendanceRosterData = rosterResponse.data;
                // log(_attendanceRosterData.toString());
                print("_attendanceRosterData $_attendanceRosterData");
              });

              _showRosterDialog();
            } else {
              ShowDialogs.showToast(rosterResponse.msg);
            }
          } catch (e) {
            print('Error parsing response: $e');
            ShowDialogs.showToast('Error processing data: ${e.toString()}');
          }
        },
        (error) {
          Navigator.pop(context); // Dismiss loading dialog
          ShowDialogs.showToast('Error: ${error.toString()}');
        },
        false,
        "",
        jsonval: map,
      );
    } catch (e) {
      Navigator.pop(context); // Dismiss loading dialog if still showing
      print('Error in _fetchAttendanceRoster: $e');
      ShowDialogs.showToast('An error occurred');
    }
  }

  void _showRosterDialog() {
    if (!mounted || context == null || _attendanceRosterData.isEmpty) return;

    const monthNames = [
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

    final Map<String, List<dynamic>> groupedByMonth = {};
    for (var shift in _attendanceRosterData) {
      for (var emp in shift.employeeList) {
        for (var att in emp.attendData) {
          final monthYear = getMonthYear(att.date);
          groupedByMonth.putIfAbsent(monthYear, () => []);
          if (!groupedByMonth[monthYear]!.contains(shift)) {
            groupedByMonth[monthYear]!.add(shift);
          }
        }
      }
    }

    final now = DateTime.now();
    final List<String> monthYears = groupedByMonth.keys.toList()
      ..sort((a, b) => getMonthYearDate(a).compareTo(getMonthYearDate(b)));

    final currentMonthStr = '${monthNames[now.month]} ${now.year}';
    String selectedMonth = monthYears.contains(currentMonthStr)
        ? currentMonthStr
        : (monthYears.isNotEmpty ? monthYears[0] : '');
    dynamic selectedShift = groupedByMonth[selectedMonth]?.isNotEmpty == true
        ? groupedByMonth[selectedMonth]![0]
        : null;

    Set<String> selectedCells = {};
    bool multiSelectMode = false;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Roster',
      pageBuilder: (context, animation, secondaryAnimation) {
        return StatefulBuilder(
          builder: (context, setState) {
            final shifts = groupedByMonth[selectedMonth] ?? [];
            final allDates = <String>{};

            for (var shift in shifts) {
              for (var emp in shift.employeeList) {
                for (var att in emp.attendData) {
                  if (getMonthYear(att.date) == selectedMonth) {
                    allDates.add(att.date);
                  }
                }
              }
            }

            final sortedDates = allDates.toList()..sort();

            return Scaffold(
              backgroundColor: Colors.black54,
              body: SafeArea(
                child: Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Center(
                              child: Text(
                                "Attendance Roster",
                                style: AppFonts.headerStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: customcolor.blue,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.close,
                              color: customcolor.darkgrey,
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      /// Month Dropdown
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: customcolor.greyborder),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Text(
                              'Select Month:',
                              style: TextStyle(
                                fontFamily: AppFonts.regular,
                                color: customcolor.subtitle,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: DropdownButton<String>(
                                isExpanded: true,
                                underline: const SizedBox(),
                                value: selectedMonth,
                                items: monthYears
                                    .map(
                                      (m) => DropdownMenuItem(
                                        value: m,
                                        child: Text(
                                          m,
                                          style: TextStyle(
                                            fontFamily: AppFonts.semibold,
                                            color: customcolor.title,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (val) {
                                  if (val == null) return;
                                  setState(() {
                                    selectedMonth = val;
                                    print("selectedMonth $selectedMonth");
                                    final parts = val.split(' ');
                                    month =
                                        monthMap[parts[0]] ??
                                        '01'; // Default to '01'
                                    year = parts[1];

                                    print("month: $month, year: $year");
                                    final shiftsForMonth =
                                        groupedByMonth[selectedMonth] ?? [];
                                    selectedShift = shiftsForMonth.isNotEmpty
                                        ? shiftsForMonth[0]
                                        : null;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      /// Shift Dropdown
                      if (shifts.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: customcolor.greyborder),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Text(
                                'Select Shift:',
                                style: TextStyle(
                                  fontFamily: AppFonts.regular,
                                  color: customcolor.subtitle,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: DropdownButton<dynamic>(
                                  isExpanded: true,
                                  underline: const SizedBox(),
                                  value: selectedShift,
                                  items: shifts.map((shift) {
                                    final label =
                                        '${shift.shiftName} (${shift.shiftStartTime}-${shift.shiftEndTime})';
                                    return DropdownMenuItem(
                                      value: shift,
                                      child: Text(
                                        label,
                                        style: TextStyle(
                                          fontFamily: AppFonts.semibold,
                                          color: customcolor.title,
                                          fontSize: 15,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                    setState(() {
                                      selectedShift = val;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 16),
                      if (selectedShift != null)
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 120,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8,
                                        horizontal: 12,
                                      ),
                                      color: customcolor.skybluebg,
                                      child: Text(
                                        "Janitor's Name",
                                        style: TextStyle(
                                          fontFamily: AppFonts.semibold,
                                          color: customcolor.blue,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    ...selectedShift.employeeList.map(
                                      (emp) => SizedBox(
                                        height: 48,
                                        child: Container(
                                          width: 120,
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 8,
                                            horizontal: 12,
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                color: customcolor.greyborder,
                                              ),
                                            ),
                                          ),
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            emp.empName,
                                            style: TextStyle(
                                              fontFamily: AppFonts.regular,
                                              fontSize: 14,
                                              color: customcolor.title,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: sortedDates
                                              .map(
                                                (date) => Container(
                                                  width: 50,
                                                  alignment: Alignment.center,
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        vertical: 8,
                                                      ),
                                                  color: customcolor.skybluebg,
                                                  child: Text(
                                                    date.split('-')[2],
                                                    style: TextStyle(
                                                      fontFamily:
                                                          AppFonts.semibold,
                                                      color: customcolor.blue,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                        ),
                                        ...selectedShift.employeeList.map(
                                          (emp) => Row(
                                            children: sortedDates.map((date) {
                                              final day = emp.attendData
                                                  .firstWhere(
                                                    (d) => d.date == date,
                                                    orElse: () => null,
                                                  );
                                              final key =
                                                  '${emp.empName}|$date|${day.attendanceStatus}';
                                              final selected = selectedCells
                                                  .contains(key);
                                              final isFuture = DateTime.parse(
                                                date,
                                              ).isAfter(DateTime.now());

                                              return GestureDetector(
                                                onLongPress: () {
                                                  if (role ==
                                                          GlobalLists
                                                              .clientrole &&
                                                      isFuture == false) {
                                                    setState(() {
                                                      multiSelectMode = true;
                                                      selected
                                                          ? selectedCells
                                                                .remove(key)
                                                          : selectedCells.add(
                                                              key,
                                                            );
                                                    });
                                                  }
                                                  log(selectedCells.toString());
                                                },
                                                onTap: () {
                                                  print('on Tap');
                                                  if (role ==
                                                          GlobalLists
                                                              .clientrole &&
                                                      isFuture == false) {
                                                    print('condition');
                                                    if (multiSelectMode) {
                                                      setState(() {
                                                        selected
                                                            ? selectedCells
                                                                  .remove(key)
                                                            : selectedCells.add(
                                                                key,
                                                              );
                                                      });
                                                      final reasonController =
                                                          TextEditingController();
                                                      showDialog(
                                                        context: context,
                                                        builder: (_) => AlertDialog(
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  16,
                                                                ),
                                                          ),
                                                          title: Row(
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .report_problem,
                                                                color: Colors
                                                                    .redAccent,
                                                              ),
                                                              SizedBox(
                                                                width: 8,
                                                              ),
                                                              Text(
                                                                "Mark as Absent",
                                                              ),
                                                            ],
                                                          ),
                                                          content: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Text(
                                                                "Please enter a reason for marking this employee as absent.",
                                                                style: TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .grey[700],
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 16,
                                                              ),
                                                              TextField(
                                                                controller:
                                                                    reasonController,
                                                                maxLines: 3,
                                                                decoration: InputDecoration(
                                                                  hintText:
                                                                      "Enter reason here...",
                                                                  filled: true,
                                                                  fillColor: Colors
                                                                      .grey[100],
                                                                  contentPadding:
                                                                      EdgeInsets.symmetric(
                                                                        vertical:
                                                                            12,
                                                                        horizontal:
                                                                            12,
                                                                      ),
                                                                  border: OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                          12,
                                                                        ),
                                                                    borderSide: BorderSide(
                                                                      color: Colors
                                                                          .grey
                                                                          .shade300,
                                                                    ),
                                                                  ),
                                                                  focusedBorder: OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                          12,
                                                                        ),
                                                                    borderSide:
                                                                        BorderSide(
                                                                          color:
                                                                              Colors.blueAccent,
                                                                        ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          actionsPadding:
                                                              EdgeInsets.symmetric(
                                                                horizontal: 16,
                                                                vertical: 8,
                                                              ),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () =>
                                                                  Navigator.pop(
                                                                    context,
                                                                  ),
                                                              child: Text(
                                                                "Cancel",
                                                              ),
                                                            ),
                                                            ElevatedButton(
                                                              onPressed: () {
                                                                log(
                                                                  "Reason: ${reasonController.text}",
                                                                );
                                                                Navigator.pop(
                                                                  context,
                                                                );
                                                              },
                                                              style: ElevatedButton.styleFrom(
                                                                backgroundColor:
                                                                    customcolor
                                                                        .blue,
                                                                shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        8,
                                                                      ),
                                                                ),
                                                              ),
                                                              child: Text(
                                                                "Submit",
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    } else {
                                                      if (selected) {
                                                        setState(
                                                          () => selectedCells
                                                              .remove(key),
                                                        );
                                                      } else {
                                                        final reasonController =
                                                            TextEditingController();
                                                        showDialog(
                                                          context: context,
                                                          builder: (_) => AlertDialog(
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    16,
                                                                  ),
                                                            ),
                                                            title: Row(
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .report_problem,
                                                                  color: Colors
                                                                      .redAccent,
                                                                ),
                                                                SizedBox(
                                                                  width: 8,
                                                                ),
                                                                Text(
                                                                  "Mark as Absent",
                                                                ),
                                                              ],
                                                            ),
                                                            content: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                Text(
                                                                  "Please enter a reason for marking this employee as absent.",
                                                                  style: TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color: Colors
                                                                        .grey[700],
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 16,
                                                                ),
                                                                TextField(
                                                                  controller:
                                                                      reasonController,
                                                                  maxLines: 3,
                                                                  decoration: InputDecoration(
                                                                    hintText:
                                                                        "Enter reason here...",
                                                                    filled:
                                                                        true,
                                                                    fillColor:
                                                                        Colors
                                                                            .grey[100],
                                                                    contentPadding: EdgeInsets.symmetric(
                                                                      vertical:
                                                                          12,
                                                                      horizontal:
                                                                          12,
                                                                    ),
                                                                    border: OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                            12,
                                                                          ),
                                                                      borderSide: BorderSide(
                                                                        color: Colors
                                                                            .grey
                                                                            .shade300,
                                                                      ),
                                                                    ),
                                                                    focusedBorder: OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                            12,
                                                                          ),
                                                                      borderSide: BorderSide(
                                                                        color: Colors
                                                                            .blueAccent,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            actionsPadding:
                                                                EdgeInsets.symmetric(
                                                                  horizontal:
                                                                      16,
                                                                  vertical: 8,
                                                                ),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                      context,
                                                                    ),
                                                                child: Text(
                                                                  "Cancel",
                                                                ),
                                                              ),
                                                              ElevatedButton(
                                                                onPressed: () {
                                                                  log(
                                                                    "Reason: ${reasonController.text}",
                                                                  );
                                                                  Navigator.pop(
                                                                    context,
                                                                  );
                                                                },
                                                                style: ElevatedButton.styleFrom(
                                                                  backgroundColor:
                                                                      customcolor
                                                                          .blue,
                                                                  shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                          8,
                                                                        ),
                                                                  ),
                                                                ),
                                                                child: Text(
                                                                  "Submit",
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      }
                                                    }
                                                  }
                                                },
                                                child: Container(
                                                  width: 50,
                                                  height: 48,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    border: Border(
                                                      bottom: BorderSide(
                                                        color: customcolor
                                                            .greyborder,
                                                      ),
                                                    ),
                                                  ),
                                                  child: Container(
                                                    width: 24,
                                                    height: 24,
                                                    decoration: BoxDecoration(
                                                      color: selected
                                                          ? customcolor.pink
                                                          : day == null
                                                          ? customcolor.greybg
                                                          : day.attendanceStatus ==
                                                                'yes'
                                                          ? customcolor
                                                                .lightgreen
                                                          : day.attendanceStatus ==
                                                                    'no' &&
                                                                !isFuture
                                                          ? Colors.red
                                                          : Colors.grey[300],
                                                      shape: BoxShape.circle,
                                                    ),
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      isFuture
                                                          ? '-'
                                                          : day == null
                                                          ? '-'
                                                          : (day.attendanceStatus ==
                                                                    'yes'
                                                                ? 'P'
                                                                : 'A'),
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontFamily:
                                                            AppFonts.regular,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: selected
                                                            ? Colors.white
                                                            : isFuture ||
                                                                  day == null
                                                            ? customcolor
                                                                  .greytext
                                                            : day.attendanceStatus ==
                                                                  'yes'
                                                            ? customcolor.green
                                                            : customcolor.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      if (selectedCells.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: ElevatedButton(
                            onPressed: () {
                              final reasonController = TextEditingController();
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: Text("Submit Reason for Absent"),
                                  content: TextField(
                                    controller: reasonController,
                                    maxLines: 3,
                                    decoration: InputDecoration(
                                      hintText: "Enter reason",
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        log(
                                          "Submit reason for selected: \$selectedCells",
                                        );
                                        log(
                                          "Reason: \${reasonController.text}",
                                        );
                                        Navigator.pop(context);
                                      },
                                      child: Text("Submit"),
                                    ),
                                  ],
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: customcolor.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text("Submit"),
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
    );
  }

  List<List<T>> _splitIntoChunks<T>(List<T> list, int chunkSize) {
    List<List<T>> chunks = [];
    for (var i = 0; i < list.length; i += chunkSize) {
      chunks.add(
        list.sublist(
          i,
          i + chunkSize > list.length ? list.length : i + chunkSize,
        ),
      );
    }
    return chunks;
  }

  getrole() async {
    role = await SPManager().getroleid();

    log('role : $role');

    if (role == GlobalLists.supervisorrole) {
      janotoragendaApi(GlobalLists.clientid, GlobalLists.siteid);
    }
    if (role == GlobalLists.unitrole ||
        role == GlobalLists.operationrole ||
        role == GlobalLists.operationmanagerrole ||
        role == GlobalLists.headrole ||
        role == GlobalLists.reginalmanagerrole ||
        role == GlobalLists.clientrole) {
      print("RUCHI29OCT");
      unitattendanceApi();
    } else {
      print("RUCHI29OCT ATTEND");
      attendanceApi();
    }
    if (role == GlobalLists.unitrole ||
        role == GlobalLists.headrole ||
        role == GlobalLists.reginalmanagerrole ||
        role == GlobalLists.clientrole ||
        role == GlobalLists.operationrole ||
        role == GlobalLists.operationmanagerrole) {
      //  checkPermissionStatus();
      _getLocation();
      setState(() {});
    } else {
      _getLocation();
      //   checkPermissionStatus();
    }
    //unitgraphattendanceApi();
  }

  String _locationMessage = "Press the button to get your location";

  _getLocation() async {
    LocationService locationService = LocationService();
    try {
      Position position = await locationService.determinePosition();
      setState(() {
        _locationMessage =
            "Latitude: ${position.latitude}, Longitude: ${position.longitude}";

        print(_locationMessage);
      });
    } catch (e) {
      // setState(() {
      _locationMessage = "Error: $e";
      print(_locationMessage);
      //});
    }
    getLocation();
  }

  grantPermission() async {
    var status = await permishan.Permission.location.status;
    print("status");
    print(status);
    if (status.isGranted) {
      getLocation();
    } else if (status.isPermanentlyDenied) {
      print("isUndetermined");
      //  ShowDialogs.showToast(
      //                       "Please Allow Your Location Permission From Setting  To Add your Attendance");
      getLocation();
      //await Permission.location.request();
    } else {
      // getLocation();
      print("status1");
      permishan.openAppSettings();
      //locatedCountryCode = null;
      //await Permission.location.request();
    }
  }

  onItemChanged(String value) {
    print("in");

    setState(() {
      searchUserList.clear();

      GlobalLists.attendanceemployeelist.forEach((iElement) {
        if (iElement.name.toString().toLowerCase().contains(
          value.toLowerCase(),
        )) {
          searchUserList.add(iElement);
        }
      });
    });
  }

  void checkPermissionStatus() async {
    var status = await permishan.Permission.locationWhenInUse.status;
    if (status != permishan.PermissionStatus.granted) {
      //show Dialog or route to specific page (or route to Application Manager)
      print("notgranted");
      grantPermission();
      ShowDialogs.showToast(
        "Please Allow Your Location Permission From Setting  To Add your Attendance",
      );
      // openAppSettings();
    } else {
      print("granted");

      getLocation().then((value) {
        print("hii");
        if (value != null) {
          print("notnull");
          getLocation();
        } else {
          print("null");
          grantPermission();
          ShowDialogs.showToast(
            "Please Allow Your Location Permission From Setting  To Add your Attendance",
          );
        }

        // _getLocation();
        //    searching = !searching;
      });
      // Go to Second Screen
    }
  }

  Future<void> refreshData() async {
    // Simulating an API request or data refresh
    setState(() {
      print("APICall");
      getrole();
    });
  }

  @override
  Widget build(BuildContext context) {
    log('GlobalLists.graphlist ${GlobalLists.graphlist.length}');
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => HomePage(),
          ),
        );
        return await false;
      },
      child: Scaffold(
        key: _scaffoldKey1,

        endDrawer: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: customcolor.blue,
            primaryColor: customcolor.blue,
          ),
          child: AppDrawerfilter(role),
        ),
        backgroundColor: customcolor.greybg,
        resizeToAvoidBottomInset: false,

        floatingActionButton: FloatingActionButton(
          //Floating action button on Scaffold
          backgroundColor: customcolor.white,
          onPressed: () {
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.fade,
                child: HomePage(),
                duration: Duration(milliseconds: 300),
              ),
            );
          },
          child: Image.asset(
            "assets/images/greyhome.png",
            color: customcolor.greytext,
            width: 20,
            height: 20,
          ), //icon inside button
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        //floating action button position to center
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(148),
          child: AppbarComman(
            setStyleStr: 'Attendance',
            onPressedBack: () {},
            onPressedNotify: () {},
            onPressedSearch: () {},
            onPressedSort: () {},
            onPressedmenu: () {
              _scaffoldKey1.currentState!.openEndDrawer();
            },
          ),
        ),

        bottomNavigationBar: CustomBottomNavigationBar(index: 0),
        body: isattendanceLoadin
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: customcolor.blue),
                    SizedBox(height: 15),
                    Text(
                      "Loading, please wait...",
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              )
            : Stack(
                children: [
                  SingleChildScrollView(
                    physics: ScrollPhysics(),
                    child:
                        (role == GlobalLists.unitrole ||
                            role == GlobalLists.headrole ||
                            role == GlobalLists.reginalmanagerrole ||
                            role == GlobalLists.clientrole ||
                            role == GlobalLists.operationrole ||
                            role == GlobalLists.operationmanagerrole)
                        ? Padding(
                            padding: const EdgeInsets.only(
                              left: 10,
                              right: 10,
                              top: 20,
                              bottom: 20,
                            ),
                            child: Container(
                              child: CustomRefreshIndicator(
                                builder:
                                    (
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
                                                child:
                                                    CircularProgressIndicator(
                                                      value:
                                                          !controller.isLoading
                                                          ? controller.value
                                                                .clamp(0.0, 1.0)
                                                          : null,
                                                    ),
                                              ),
                                            ),
                                          Transform.translate(
                                            offset: Offset(
                                              0,
                                              100.0 * controller.value,
                                            ),
                                            child: child,
                                          ),
                                        ],
                                      );
                                    },
                                onRefresh: refreshData,
                                child: ListView(
                                  shrinkWrap: true,
                                  //  physics: ScrollPhysics(),
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          child: Text(
                                            "ATTENDANCE",
                                            style: AppFonts.headerStyle(
                                              fontSize: 17.sp,
                                              color: customcolor.black,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ),

                                        (role == GlobalLists.unitrole ||
                                                role == GlobalLists.headrole ||
                                                role ==
                                                    GlobalLists
                                                        .reginalmanagerrole ||
                                                role ==
                                                    GlobalLists.clientrole ||
                                                role ==
                                                    GlobalLists.operationrole ||
                                                role ==
                                                    GlobalLists
                                                        .supervisorrole ||
                                                role ==
                                                    GlobalLists
                                                        .operationmanagerrole)
                                            ?
                                              // ? maintag == mainlaglastposition_overall
                                              //     ? Container()
                                              //     :
                                              Row(
                                                children: [
                                                  //
                                                  new Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            20,
                                                          ),
                                                    ),
                                                    width:
                                                        SizeConfig
                                                            .blockSizeHorizontal *
                                                        32,
                                                    height: 30,

                                                    // padding: EdgeInsets.only(left: 6,bottom: 5,top:3,right: 5),
                                                    child: new Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        // new Expanded(child: new Text("Bemerkung",)),
                                                        new Expanded(
                                                          child: new TextField(
                                                            textAlignVertical:
                                                                TextAlignVertical
                                                                    .center,
                                                            textAlign: TextAlign
                                                                .center,
                                                            style:
                                                                AppFonts.headerStyle(
                                                                  fontSize:
                                                                      14.sp,
                                                                  color:
                                                                      customcolor
                                                                          .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300,
                                                                ),
                                                            readOnly: true,
                                                            onTap: () async {
                                                              DateTime?
                                                              pickedDate = await showDatePicker(
                                                                context:
                                                                    context,
                                                                initialDate:
                                                                    selectedDateTime ??
                                                                    DateTime.now(),
                                                                firstDate:
                                                                    DateTime(
                                                                      1950,
                                                                    ),
                                                                lastDate:
                                                                    DateTime(
                                                                      2050,
                                                                    ),
                                                              );

                                                              if (pickedDate !=
                                                                  null) {
                                                                var datefrom =
                                                                    DateFormat(
                                                                      'dd-MM-yyyy',
                                                                    ).format(
                                                                      pickedDate,
                                                                    );
                                                                GlobalLists
                                                                        .datecontroller
                                                                        .text =
                                                                    datefrom;
                                                            
                                                                setState(
                                                                  () => selectedDateTime =
                                                                      pickedDate,
                                                                );
                                                                if (role ==
                                                                        GlobalLists
                                                                            .unitrole ||
                                                                    role ==
                                                                        GlobalLists
                                                                            .operationrole ||
                                                                    role ==
                                                                        GlobalLists
                                                                            .headrole ||
                                                                    role ==
                                                                        GlobalLists
                                                                            .reginalmanagerrole ||
                                                                    role ==
                                                                        GlobalLists
                                                                            .clientrole ||
                                                                    role ==
                                                                        GlobalLists
                                                                            .operationmanagerrole) {
                                                                  print("unit");
                                                                  unitattendanceApi();
                                                                } else {
                                                                  attendanceApi();
                                                                }
                                                              }
                                                            },
                                                            controller: GlobalLists
                                                                .datecontroller,
                                                            decoration:
                                                                InputDecoration(
                                                                  border:
                                                                      InputBorder
                                                                          .none,
                                                                  contentPadding:
                                                                      EdgeInsets
                                                                          .zero,
                                                                  isDense: true,
                                                                ),
                                                          ),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () async {
                                                            DateTime?
                                                            pickedDate =
                                                                await showDatePicker(
                                                                  context:
                                                                      context,
                                                                  initialDate:
                                                                      selectedDateTime ??
                                                                      DateTime.now(),
                                                                  firstDate:
                                                                      DateTime(
                                                                        1950,
                                                                      ),
                                                                  lastDate:
                                                                      DateTime(
                                                                        2050,
                                                                      ),
                                                                );

                                                            if (pickedDate !=
                                                                null) {
                                                              var datefrom =
                                                                  DateFormat(
                                                                    'dd-MM-yyyy',
                                                                  ).format(
                                                                    pickedDate,
                                                                  );
                                                              GlobalLists
                                                                      .datecontroller
                                                                      .text =
                                                                  datefrom;
                                                              setState(
                                                                () => selectedDateTime =
                                                                    pickedDate,
                                                              );
                                                              print(
                                                                GlobalLists
                                                                    .datecontroller
                                                                    .text,
                                                              );
                                                              if (role ==
                                                                      GlobalLists
                                                                          .unitrole ||
                                                                  role ==
                                                                      GlobalLists
                                                                          .operationrole ||
                                                                  role ==
                                                                      GlobalLists
                                                                          .headrole ||
                                                                  role ==
                                                                      GlobalLists
                                                                          .reginalmanagerrole ||
                                                                  role ==
                                                                      GlobalLists
                                                                          .clientrole ||
                                                                  role ==
                                                                      GlobalLists
                                                                          .operationmanagerrole) {
                                                                print("unit");
                                                                unitattendanceApi();
                                                              } else {
                                                                attendanceApi();
                                                              }
                                                            }
                                                          },
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                  bottom: 1,
                                                                  right: 5,
                                                                ),
                                                            child: Image.asset(
                                                              'assets/images/calendar.png',
                                                              width: 22,
                                                              height: 22,
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                  SizedBox(width: 10),
                                                  GlobalLists
                                                          .mainlisttab
                                                          .isNotEmpty
                                                      ? _buildChoicemainListfortab()
                                                      : Container(),
                                                ],
                                              )
                                            : Container(),
                                      ],
                                    ),

                                    //workflow
                                    SizedBox(height: 20),
                                    unitmodule(),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(
                              left: 10,
                              right: 10,
                              top: 20,
                              bottom: 20,
                            ),
                            child: Container(
                              child: CustomRefreshIndicator(
                                builder:
                                    (
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
                                                child:
                                                    CircularProgressIndicator(
                                                      value:
                                                          !controller.isLoading
                                                          ? controller.value
                                                                .clamp(0.0, 1.0)
                                                          : null,
                                                    ),
                                              ),
                                            ),
                                          Transform.translate(
                                            offset: Offset(
                                              0,
                                              100.0 * controller.value,
                                            ),
                                            child: child,
                                          ),
                                        ],
                                      );
                                    },
                                onRefresh: refreshData,
                                child: ListView(
                                  shrinkWrap: true,

                                  /// physics: ScrollPhysics(),
                                  children: [
                                    Container(
                                      // color: customcolor.blue,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            child: Text(
                                              "ATTENDANCE",
                                              style: AppFonts.headerStyle(
                                                fontSize: 17.sp,
                                                color: customcolor.black,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                          ),
                                          (role == GlobalLists.unitrole ||
                                                  role ==
                                                      GlobalLists.headrole ||
                                                  role ==
                                                      GlobalLists
                                                          .reginalmanagerrole ||
                                                  role ==
                                                      GlobalLists.clientrole ||
                                                  role ==
                                                      GlobalLists
                                                          .operationrole ||
                                                  role ==
                                                      GlobalLists
                                                          .supervisorrole ||
                                                  role ==
                                                      GlobalLists
                                                          .operationmanagerrole)
                                              ? maintag == 0
                                                    ? Container()
                                                    : new Container(
                                                        decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                20,
                                                              ),
                                                        ),
                                                        width:
                                                            SizeConfig
                                                                .blockSizeHorizontal *
                                                            32,
                                                        height: 30,
                                                        //  padding: EdgeInsets.only(left: 6,bottom: 5,top:5,right: 5),
                                                        child: new Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: <Widget>[
                                                            // new Expanded(child: new Text("Bemerkung",)),
                                                            new Expanded(
                                                              child: new TextField(
                                                                textAlignVertical:
                                                                    TextAlignVertical
                                                                        .center,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: AppFonts.headerStyle(
                                                                  fontSize:
                                                                      17.sp,
                                                                  color:
                                                                      customcolor
                                                                          .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300,
                                                                ),
                                                                readOnly: true,
                                                                onTap: () async {
                                                                  DateTime?
                                                                  pickedDate = await showDatePicker(
                                                                    context:
                                                                        context,
                                                                    initialDate:
                                                                        selectedDateTime ??
                                                                        DateTime.now(),
                                                                    firstDate:
                                                                        DateTime(
                                                                          1950,
                                                                        ),
                                                                    lastDate:
                                                                        DateTime(
                                                                          2050,
                                                                        ),
                                                                  );

                                                                  if (pickedDate !=
                                                                      null) {
                                                                    var datefrom =
                                                                        DateFormat(
                                                                          'dd-MM-yyyy',
                                                                        ).format(
                                                                          pickedDate,
                                                                        );
                                                                    GlobalLists
                                                                            .datecontroller
                                                                            .text =
                                                                        datefrom;
                                                                    print(
                                                                      GlobalLists
                                                                          .datecontroller
                                                                          .text,
                                                                    );
                                                                    setState(
                                                                      () => selectedDateTime =
                                                                          pickedDate,
                                                                    );
                                                                    if (role ==
                                                                            GlobalLists.unitrole ||
                                                                        role ==
                                                                            GlobalLists.operationrole ||
                                                                        role ==
                                                                            GlobalLists.headrole ||
                                                                        role ==
                                                                            GlobalLists.reginalmanagerrole ||
                                                                        role ==
                                                                            GlobalLists.clientrole ||
                                                                        role ==
                                                                            GlobalLists.operationmanagerrole) {
                                                                      print(
                                                                        "unit",
                                                                      );
                                                                      unitattendanceApi();
                                                                    } else {
                                                                      attendanceApi();
                                                                    }
                                                                  }
                                                                },
                                                                controller:
                                                                    GlobalLists
                                                                        .datecontroller,
                                                                decoration: InputDecoration(
                                                                  border:
                                                                      InputBorder
                                                                          .none,
                                                                  contentPadding:
                                                                      EdgeInsets
                                                                          .zero,
                                                                  isDense: true,
                                                                ),
                                                              ),
                                                            ),
                                                            GestureDetector(
                                                              onTap: () async {
                                                                DateTime?
                                                                pickedDate = await showDatePicker(
                                                                  context:
                                                                      context,
                                                                  initialDate:
                                                                      selectedDateTime ??
                                                                      DateTime.now(),
                                                                  firstDate:
                                                                      DateTime(
                                                                        1950,
                                                                      ),
                                                                  lastDate:
                                                                      DateTime(
                                                                        2050,
                                                                      ),
                                                                );

                                                                if (pickedDate !=
                                                                    null) {
                                                                  var datefrom =
                                                                      DateFormat(
                                                                        'dd-MM-yyyy',
                                                                      ).format(
                                                                        pickedDate,
                                                                      );
                                                                  GlobalLists
                                                                          .datecontroller
                                                                          .text =
                                                                      datefrom;
                                                                  setState(
                                                                    () => selectedDateTime =
                                                                        pickedDate,
                                                                  );
                                                                  print(
                                                                    GlobalLists
                                                                        .datecontroller
                                                                        .text,
                                                                  );
                                                                  if (role ==
                                                                          GlobalLists
                                                                              .unitrole ||
                                                                      role ==
                                                                          GlobalLists
                                                                              .operationrole ||
                                                                      role ==
                                                                          GlobalLists
                                                                              .headrole ||
                                                                      role ==
                                                                          GlobalLists
                                                                              .reginalmanagerrole ||
                                                                      role ==
                                                                          GlobalLists
                                                                              .clientrole ||
                                                                      role ==
                                                                          GlobalLists
                                                                              .operationmanagerrole) {
                                                                    print(
                                                                      "unit",
                                                                    );
                                                                    unitattendanceApi();
                                                                  } else {
                                                                    attendanceApi();
                                                                  }
                                                                }
                                                              },
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsets.only(
                                                                      bottom: 1,
                                                                      right: 5,
                                                                    ),
                                                                child: Image.asset(
                                                                  'assets/images/calendar.png',
                                                                  width: 22,
                                                                  height: 22,
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                              : Container(),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    GlobalLists.mainlisttab.length > 0
                                        ? Wrap(
                                            children:
                                                _buildChoicemainList(), // ✅ correct usage
                                          )
                                        : Container(),
                                    //workflow
                                    SizedBox(height: 10),
                                    maintag == 0
                                        ? GlobalLists
                                                      .superviorgraphlist
                                                      .length >
                                                  0
                                              ? supervisoroverallgraph(
                                                  GlobalLists
                                                      .superviorgraphlist,
                                                )
                                              : ShowDialogs.norecordwidget(
                                                  SizeConfig
                                                          .blockSizeHorizontal *
                                                      30,
                                                  SizeConfig.blockSizeVertical *
                                                      30,
                                                )
                                        : isdataloaded == false
                                        ? ShowDialogs.norecordwidget(
                                            SizeConfig.blockSizeHorizontal * 30,
                                            SizeConfig.blockSizeVertical * 30,
                                          )
                                        : ListView(
                                            shrinkWrap: true,
                                            physics: ScrollPhysics(),
                                            children: [
                                              Material(
                                                elevation: 0,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Container(
                                                  width:
                                                      SizeConfig
                                                          .blockSizeHorizontal *
                                                      100,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                  ),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets.only(
                                                              left: 8,
                                                              right: 8,
                                                              top: 6,
                                                              bottom: 6,
                                                            ),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            SizedBox(
                                                              width:
                                                                  SizeConfig
                                                                      .blockSizeHorizontal *
                                                                  2,
                                                            ),
                                                            Container(
                                                              width:
                                                                  role ==
                                                                      GlobalLists
                                                                          .supervisorrole
                                                                  ? SizeConfig
                                                                            .blockSizeHorizontal *
                                                                        55
                                                                  : SizeConfig
                                                                            .blockSizeHorizontal *
                                                                        65,
                                                              child: Text(
                                                                "Attendance",
                                                                maxLines: 2,
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: AppFonts.headerStyle(
                                                                  fontSize:
                                                                      17.sp,
                                                                  color: customcolor
                                                                      .textblue,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ),
                                                            Container(
                                                              // color: customcolor.appbarcolor,
                                                              child: CircularPercentIndicator(
                                                                animationDuration:
                                                                    500,
                                                                //   radius: 35.0,
                                                                lineWidth: 6.0,
                                                                radius: 40.0,
                                                                //   lineWidth: 5.0,
                                                                animation: true,
                                                                percent:
                                                                    GlobalLists
                                                                            .attendancedata
                                                                            .percentage >
                                                                        100.0
                                                                    ? 0.0
                                                                    : GlobalLists
                                                                              .attendancedata
                                                                              .percentage /
                                                                          100,

                                                                center: new Text(
                                                                  "${GlobalLists.attendancedata.count}/${GlobalLists.attendancedata.noOfStaff}",
                                                                  style: AppFonts.headerStyle(
                                                                    fontSize:
                                                                        24,
                                                                    color: customcolor
                                                                        .textyellow,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),

                                                                circularStrokeCap:
                                                                    CircularStrokeCap
                                                                        .round,
                                                                progressColor:
                                                                    customcolor
                                                                        .textblue,
                                                              ),
                                                            ),
                                                            role ==
                                                                    GlobalLists
                                                                        .supervisorrole
                                                                ? GestureDetector(
                                                                    onTap: () {
                                                                      showStaffCountBottomSheet(
                                                                        context,
                                                                        GlobalLists
                                                                            .attendancedata
                                                                            .noOfStaff,
                                                                        GlobalLists
                                                                            .attendancedata
                                                                            .count,
                                                                      );
                                                                    },
                                                                    child: Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .topRight,
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.only(
                                                                          left:
                                                                              12,
                                                                        ),
                                                                        child: Icon(
                                                                          Icons
                                                                              .edit,
                                                                          color:
                                                                              customcolor.blue,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )
                                                                : Container(),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),

                                              SizedBox(height: 10),
                                              GlobalLists
                                                          .attendanceemployeelist
                                                          .length >
                                                      0
                                                  ? searchcontroller.text
                                                                .trim()
                                                                .length >
                                                            0
                                                        ? supervisorattendancelist(
                                                            searchUserList,
                                                          )
                                                        : supervisorattendancelist(
                                                            GlobalLists
                                                                .attendanceemployeelist,
                                                          )
                                                  : Container(),
                                            ],
                                          ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                  ),
                  (role == GlobalLists.unitrole ||
                          role == GlobalLists.operationrole ||
                          role == GlobalLists.supervisorrole ||
                          role == GlobalLists.operationmanagerrole)
                      ? maintag == mainlaglastposition_overall
                            ? Container()
                            : Align(
                                alignment: Alignment.bottomRight,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FloatingActionButton(
                                    backgroundColor: customcolor.blue,
                                    onPressed: () {
                                      clientnamecontroller.text = "";
                                      namecontroller.text = "";
                                      mobilecontroller.text = "";
                                      isexpandedclient = false;
                                      isexpandedjanitor = false;
                                      addaddtendance(context);
                                      // Add your action for the center button here
                                    },
                                    child: Icon(
                                      Icons.add,
                                      color: customcolor.white,
                                    ),
                                  ),
                                ),
                              )
                      : Container(),
                ],
              ),
      ),
    );
  }

  Widget unitmodule() {
    return ListView(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      children: [
        Container(
          height: maintag == mainlaglastposition_overall
              ? SizeConfig.blockSizeVertical * 66
              : SizeConfig.blockSizeVertical * 73, //74
          decoration: BoxDecoration(
            //color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: customcolor.greyborder, width: 0.4),
          ),

          child: GlobalLists.mainlisttab.length > 0
              ? ListView(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  children: [
                    GlobalLists.mainlisttab.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(top: 14, bottom: 14),
                            child: Container(
                              height: 25,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                children:
                                    _buildChoicemainList(), // ✅ now returns List<Widget>
                              ),
                            ),
                          )
                        : SizedBox(),
                    maintab(maintag),
                  ],
                )
              : ShowDialogs.norecordwidget(
                  SizeConfig.blockSizeHorizontal * 30,
                  SizeConfig.blockSizeVertical * 30,
                ),
        ),
      ],
    );
  }

  Widget maintab(int maintag) {
    return maintag == (GlobalLists.mainlisttab.length - 1)
        // return maintag == 5
        ? GlobalLists.graphlist.length == 0
              ? Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Material(
                    elevation: 0,
                    borderRadius: BorderRadius.circular(10),
                    color: customcolor.white,
                    child: ListView(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Overall Attendance",
                            maxLines: 2,
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            style: AppFonts.headerStyle(
                              fontSize: 17.sp,
                              color: customcolor.title,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        // GlobalLists.graphlist is zero maintag is zeror in start
                        // overallgraph(GlobalLists.graphlist),
                        overallgraph(GlobalLists.graphlist),
                      ],
                    ),
                  ),
                )
        : ListView(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            children: [
              SizedBox(height: 20),
              GlobalLists.mainlisttab[maintag].attendanceDetails.length == 0
                  ? Container()
                  : Material(
                      elevation: 0,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: SizeConfig.blockSizeHorizontal * 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 8,
                                right: 8,
                                top: 6,
                                bottom: 6,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: SizeConfig.blockSizeHorizontal * 2,
                                  ),
                                  Container(
                                    width: SizeConfig.blockSizeHorizontal * 65,
                                    child: Text(
                                      "Attendance",
                                      maxLines: 2,
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppFonts.headerStyle(
                                        fontSize: 20.sp,
                                        color: customcolor.textblue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    // color: customcolor.appbarcolor,
                                    child: CircularPercentIndicator(
                                      animationDuration: 500,
                                      //   radius: 35.0,
                                      lineWidth: 6.0,
                                      radius: 40.0,
                                      //   lineWidth: 5.0,
                                      animation: true,
                                      percent:
                                          ((GlobalLists
                                                      .mainlisttab[maintag]
                                                      .attendanceDetails[tag]
                                                      .count /
                                                  GlobalLists
                                                      .mainlisttab[maintag]
                                                      .attendanceDetails[tag]
                                                      .noOfStaff) *
                                              100) /
                                          100,
                                      center: new Text(
                                        // "${mainlisttab[maintag].attendanceDetails[tag].count.toString()}/${mainlisttab[maintag].attendanceDetails[tag].noOfStaff.toString()}",
                                        GlobalLists.notapplicable == 0
                                            ? "NA"
                                            : "${GlobalLists.mainlisttab[maintag].attendanceDetails[tag].count.toString()}/${GlobalLists.mainlisttab[maintag].attendanceDetails[tag].noOfStaff.toString()}",
                                        style: AppFonts.headerStyle(
                                          fontSize:
                                              GlobalLists.notapplicable == 0
                                              ? 18
                                              : 24,
                                          color: customcolor.textyellow,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),

                                      circularStrokeCap:
                                          CircularStrokeCap.round,
                                      progressColor: customcolor.textblue,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

              Padding(
                padding: const EdgeInsets.only(top: 14, bottom: 14),
                child: Container(
                  height: 25,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    children: _buildChoiceList(),
                  ),
                ),
              ),

              GlobalLists.mainlisttab[maintag].attendanceDetails.length == 0
                  ? ShowDialogs.norecordwidget(
                      SizeConfig.blockSizeHorizontal * 30,
                      SizeConfig.blockSizeVertical * 20,
                    )
                  : unitattendancelist(
                      GlobalLists
                          .mainlisttab[maintag]
                          .attendanceDetails[tag]
                          .employeeList,
                      GlobalLists
                          .mainlisttab[maintag]
                          .attendanceDetails[tag]
                          .permission,
                    ),
              SizedBox(height: 20),
            ],
          );
  }

  Widget overallgraph(List<graph.GraphDatum> graph) {
    log('overallgraph');
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 0.8,
          child: Padding(
            padding: const EdgeInsets.only(
              right: 18,
              left: 12,
              top: 15,
              bottom: 4,
            ),
            child: LineChart(LineChartSample2.mainData(graph)),
          ),
        ),
      ],
    );
  }

  Widget supervisoroverallgraph(List<GraphDatum> graph) {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 0.8,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 18,
                  left: 12,
                  top: 8,
                  bottom: 4,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        "Overall Attendance",
                        maxLines: 2,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        style: AppFonts.headerStyle(
                          fontSize: 17.sp,
                          color: customcolor.title,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    Expanded(
                      child: LineChart(
                        LineChartSample2.supervisormainData(graph),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  _buildChoiceList() {
    List<Widget> choices = [];
    listtab = [];
    // tag=0;
    for (
      int i = 0;
      i < GlobalLists.mainlisttab[maintag].attendanceDetails.length;
      i++
    ) {
      listtab.add(
        "${GlobalLists.mainlisttab[maintag].attendanceDetails[i].startTime}-${GlobalLists.mainlisttab[maintag].attendanceDetails[i].endTime}",
      );
    }
    listtab.forEachIndexed((item, value) {
      choices.add(
        Container(
          child: Padding(
            padding: const EdgeInsets.only(right: 5),
            child: ChoiceChip(
              label: Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Text(
                  item,
                  style: AppFonts.headerStyle(
                    fontSize: 12,
                    color: tag == value
                        ? customcolor.blue
                        : customcolor.greytext,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20))),
              labelStyle: AppFonts.headerStyle(
                fontSize: 12,
                color: tag == value ? customcolor.blue : customcolor.greytext,
                fontWeight: FontWeight.bold,
              ),

              selectedColor: customcolor.blue.withOpacity(0.2),
              backgroundColor: customcolor.white,
              selected: tag == value,
              onSelected: (selected) {
                setState(() {
                  _isSelected = item;
                  if (GlobalLists
                          .mainlisttab[maintag]
                          .attendanceDetails
                          .length >
                      0) {
                    attendanceshiftid = GlobalLists
                        .mainlisttab[maintag]
                        .attendanceDetails[value]
                        .id
                        .toString();
                  } else {
                    attendanceshiftid = "";
                  }

                  tag = value;
                  print(tag);
                });
              },
            ),
          ),
        ),
      );
    });
    return choices;
  }

  //tab
  _buildChoicemainList() {
    List<Widget> choices = [];
    GlobalLists.mainlisttab.forEachIndexed((item, value) {
      choices.add(
        Container(
          height: 25,
          child: Padding(
            padding: const EdgeInsets.only(right: 5),
            child: ChoiceChip(
              label: Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Text(
                  item.clientName,
                  style: AppFonts.headerStyle(
                    fontSize: 12,
                    color: maintag == value
                        ? customcolor.white
                        : item.lowattendance == true
                        ? customcolor.red
                        : (item.clientName.contains('OverAll')
                              ? customcolor.tabblue
                              : customcolor.green),
                    // :
                    // customcolor.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              side: BorderSide(
                width: 0.5,
                color: maintag == value
                    ? customcolor.white
                    : item.lowattendance == true
                    ? customcolor.red
                    : (item.clientName.contains('OverAll')
                          ? customcolor.tabblue
                          : customcolor.green),
              ),

              //:customcolor.green),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              labelStyle: AppFonts.headerStyle(
                fontSize: 12,
                color: maintag == value
                    ? customcolor.blue
                    : customcolor.greytext,
                fontWeight: FontWeight.bold,
              ),

              selectedColor: customcolor.tabblue,
              backgroundColor: customcolor.white,
              selected: maintag == value,
              onSelected: (selected) {
                setState(() {
                  _isSelected = item.clientName;
                  maintag = value;
                  log('maintag ${maintag}');
                  log('item.clientName ${item.clientName}');
                  log('GlobalLists.graphlist ${GlobalLists.graphlist.length}');
                  if (GlobalLists.graphlist.length == 0 &&
                      item.clientName == 'OverAll') {
                    print("unit 2");
                    if (role != GlobalLists.supervisorrole) {
                      unitgraphattendanceApi();
                    }
                  }

                  tag = 0;
                  if (maintag > 0) {
                    attendancesiteid = GlobalLists.mainlisttab[maintag].siteId
                        .toString();
                    attendanceclientid = GlobalLists
                        .mainlisttab[maintag]
                        .clientId
                        .toString();
                    if (role == GlobalLists.supervisorrole) {
                      attendanceshiftid = "";
                    } else {
                      if (GlobalLists
                          .mainlisttab[maintag]
                          .attendanceDetails
                          .isNotEmpty)
                        attendanceshiftid = GlobalLists
                            .mainlisttab[maintag]
                            .attendanceDetails[0]
                            .id
                            .toString();
                    }
                    clientname = GlobalLists.mainlisttab[maintag].clientName;
                  }
                  for (
                    int i = 0;
                    i <
                        GlobalLists
                            .mainlisttab[maintag]
                            .attendanceDetails
                            .length;
                    i++
                  ) {
                    // listtab.add("${mainlisttab[maintag].attendanceDetails[i].shiftStartTime}-${mainlisttab[maintag].attendanceDetails[i].shiftEndTime}");
                    if (GlobalLists
                            .mainlisttab[maintag]
                            .attendanceDetails[i]
                            .currentTime ==
                        true) {
                      log("selectedindextagselect");
                      tag = i;
                      log(selectedindex.toString());
                      attendancesiteid = GlobalLists.mainlisttab[maintag].siteId
                          .toString();
                      attendanceclientid = GlobalLists
                          .mainlisttab[maintag]
                          .clientId
                          .toString();
                      if (role == GlobalLists.supervisorrole) {
                        attendanceshiftid = "";
                      } else {
                        if (GlobalLists
                            .mainlisttab[maintag]
                            .attendanceDetails
                            .isNotEmpty)
                          attendanceshiftid = GlobalLists
                              .mainlisttab[maintag]
                              .attendanceDetails[i]
                              .id
                              .toString();
                      }
                    }
                  }
                  print("SITEID");
                  print(GlobalLists.mainlisttab[maintag].siteId.toString());
                  janotoragendaApi(attendanceclientid, attendancesiteid);
                });
              },
            ),
          ),
        ),
      );
    });
    return choices;
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
                                        title: Text(
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
                                            tag = 0;

                                            attendancesiteid = item.siteId
                                                .toString();
                                            attendanceclientid = item.clientId
                                                .toString();

                                            if (role ==
                                                GlobalLists.supervisorrole) {
                                              attendanceshiftid = "";
                                            } else if (item
                                                .attendanceDetails
                                                .isNotEmpty) {
                                              attendanceshiftid = item
                                                  .attendanceDetails[0]
                                                  .id
                                                  .toString();
                                            }

                                            for (
                                              int i = 0;
                                              i < item.attendanceDetails.length;
                                              i++
                                            ) {
                                              if (item
                                                      .attendanceDetails[i]
                                                      .currentTime ==
                                                  true) {
                                                tag = i;
                                                attendancesiteid = item.siteId
                                                    .toString();
                                                attendanceclientid = item
                                                    .clientId
                                                    .toString();
                                                attendanceshiftid =
                                                    role ==
                                                        GlobalLists
                                                            .supervisorrole
                                                    ? ""
                                                    : item
                                                          .attendanceDetails[i]
                                                          .id
                                                          .toString();
                                              }
                                            }

                                            janotoragendaApi(
                                              attendanceclientid,
                                              attendancesiteid,
                                            );
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

  ////
  void _onClientSelected(unitatt.Datum selectedItem) {
    final value = GlobalLists.mainlisttab.indexOf(selectedItem);
    setState(() {
      _isSelected = selectedItem.clientName;
      maintag = value;
      tag = 0;

      if (maintag > 0) {
        attendancesiteid = selectedItem.siteId.toString();
        attendanceclientid = selectedItem.clientId.toString();

        if (role == GlobalLists.supervisorrole) {
          attendanceshiftid = "";
        } else {
          if (selectedItem.attendanceDetails.isNotEmpty) {
            attendanceshiftid = selectedItem.attendanceDetails[0].id.toString();
          }
        }

        clientname = selectedItem.clientName;
      }

      for (int i = 0; i < selectedItem.attendanceDetails.length; i++) {
        if (selectedItem.attendanceDetails[i].currentTime == true) {
          tag = i;
          attendancesiteid = selectedItem.siteId.toString();
          attendanceclientid = selectedItem.clientId.toString();
          if (role == GlobalLists.supervisorrole) {
            attendanceshiftid = "";
          } else {
            attendanceshiftid = selectedItem.attendanceDetails[i].id.toString();
          }
        }
      }

      janotoragendaApi(attendanceclientid, attendancesiteid);
    });
  }

  addaddtendance(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      elevation: 5.0,
      barrierColor: Colors.black.withOpacity(0.7),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(20.0),
          topRight: const Radius.circular(20.0),
        ),
      ),
      context: context,
      builder: (builder) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStateDialgoue) {
            return new Container(
              height:
                  (role == GlobalLists.headrole ||
                      role == GlobalLists.reginalmanagerrole ||
                      role == GlobalLists.clientrole)
                  ? SizeConfig.blockSizeVertical * 48 +
                        MediaQuery.of(context).viewInsets.bottom
                  : SizeConfig.blockSizeVertical * 47 +
                        MediaQuery.of(context).viewInsets.bottom,
              color: Colors.white,
              margin: EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 2),
              padding: EdgeInsets.all(5),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 5),
                      Center(
                        child: Container(
                          width: 50,
                          child: Divider(
                            thickness: 4,
                            color: customcolor.greytext,
                            height: 2,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Mark Attendance",
                        textAlign: TextAlign.left,
                        style: AppFonts.headerStyle(
                          fontSize: 22,
                          color: customcolor.black,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 15),
                      Stack(
                        children: [
                          Column(
                            children: [
                              // clientnamecontroller.text==""?Container():
                              SizedBox(height: 20),

                              Stack(
                                children: [
                                  Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setStateDialgoue(() {
                                            isexpandedjanitor =
                                                !isexpandedjanitor;

                                            isexpandedclient = false;
                                          });
                                        },
                                        child: FormTextField(
                                          isEnable: false,
                                          textcontroller: namecontroller,
                                          placeholderStr:
                                              "Select Janitor's Name",
                                          textInputType: TextInputType.text,
                                          onchange: (val) {},
                                          suffixWidget: Padding(
                                            padding: EdgeInsets.only(right: 20),
                                            child: Image.asset(
                                              "assets/images/dropdown.png",
                                              width: 10,
                                              height: 10,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Stack(
                                        children: [
                                          Column(
                                            children: [
                                              SizedBox(height: 20),
                                              FormTextField(
                                                isEnable: false,
                                                textcontroller:
                                                    mobilecontroller,
                                                placeholderStr: "Mobile Number",
                                                lengthofmobile: 10,
                                                //   maxLength: 10,
                                                textInputType:
                                                    TextInputType.number,
                                                onchange: (val) {},
                                              ),
                                              SizedBox(height: 30),
                                            ],
                                          ),
                                          isexpandedjanitor
                                              ? janitorsDropdown(
                                                  setStateDialgoue,
                                                )
                                              : Container(),
                                        ],
                                      ),
                                    ],
                                  ),
                                  isexpanded
                                      ? siteDropdown(setStateDialgoue)
                                      : Container(),
                                ],
                              ),
                            ],
                          ),
                          isexpandedclient
                              ? clientDropdown(setStateDialgoue)
                              : Container(),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          if (role == GlobalLists.clientrole ||
                              role == GlobalLists.headrole ||
                              role == GlobalLists.reginalmanagerrole ||
                              role == GlobalLists.operationrole ||
                              role == GlobalLists.unitrole ||
                              role == GlobalLists.operationmanagerrole) {
                            // Navigator.pop(context);
                            if (lat == null || long == null) {
                              grantPermission();
                            }
                            // else if(clientnamecontroller.text.isEmpty)
                            // {
                            //      ShowDialogs.showToast(
                            //                 "Please Select Client Name");
                            //   }
                            else if (namecontroller.text.isEmpty) {
                              ShowDialogs.showToast("Please Enter Name");
                            } else if (mobilecontroller.text.isEmpty) {
                              ShowDialogs.showToast("Please Enter Mobile No");
                            } else if (mobilecontroller.text.length != 10) {
                              ShowDialogs.showToast(
                                "Please Enter Valid Mobile No",
                              );
                            } else {
                              addattendanceApi();
                            }
                          } else {
                            // Navigator.pop(context);
                            if (lat == null || long == null) {
                              grantPermission();
                            } else if (namecontroller.text.isEmpty) {
                              ShowDialogs.showToast("Please Enter Name");
                            } else if (mobilecontroller.text.isEmpty) {
                              ShowDialogs.showToast("Please Enter Mobile No");
                            } else if (mobilecontroller.text.length != 10) {
                              ShowDialogs.showToast(
                                "Please Enter Valid Mobile No",
                              );
                            } else {
                              print("RUCHIADD");
                              addattendanceApi();
                            }
                          }
                        },
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: ValueListenableBuilder<bool>(
                            valueListenable: GlobalLists.isaddAttendance,
                            builder: (context, isLoading, _) {
                              if (isLoading) {
                                return CircularProgressIndicator(
                                  color: customcolor.blue,
                                );
                              }
                              return Image.asset(
                                'assets/images/next.png',
                                width: 50,
                                height: 50,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  deleteattendanceApi(String id) async {
    var status1 = await ConnectionDetector.checkInternetConnection();
    final Map<String, dynamic> map = {'id': id};

    if (status1) {
      // Online mode
      // ShowDialogs.showLoadingDialog(context, _keyLoader);
      setState(() {
        isattendanceLoadin = true;
      });
      APIManager().apiRequest(
        context,
        API.deleteattendance,
        (response) async {
          deleteatt.DeleteAttendance resp = response;
          print('called API $resp');
          if (resp.status == 1) {
            setState(() {
              isattendanceLoadin = false;

              // Navigator.of(this.context).pop();
              Timer(Duration(seconds: 1), () => Navigator.pop(context));
              ShowDialogs().confirmationdone(
                context,
                "Attendance Deleted \nSuccessfully",
              );
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
            });
          } else {
            ShowDialogs.showToast(resp.message);
            setState(() {
              isattendanceLoadin = false;
            });
            // Navigator.of(this.context).pop();
          }
        },
        (error) {
          print('ERR msg is $error');
        },
        false,
        "",
        jsonval: map,
      );
    } else {
      // Offline mode
      await DBHelper.insertOfflineRequest(
        '${Global.baseUrl}/api/attendancemaster/Delete_AttendanceMaster',
        map,
      );

      final prefs = await SharedPreferences.getInstance();
      String? cachedData = prefs.getString('cached_attendance_data');

      if (cachedData != null) {
        try {
          // Parse response
          AttendencelistResponse resp = attendencelistResponseFromJson(
            cachedData,
          );

          // Remove from employeeList
          resp.data.employeeList.removeWhere(
            (item) => item.id.toString() == id.toString(),
          );

          // Save updated list back to SharedPreferences
          await prefs.setString(
            'cached_attendance_data',
            attendencelistResponseToJson(resp),
          );

          // Update global list & UI
          setState(() {
            GlobalLists.attendanceemployeelist = resp.data.employeeList;
            GlobalLists.attendancedata.employeeList = resp.data.employeeList;
          });

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
          ShowDialogs.showToast(
            "Offline: Deleted from local cache & saved delete request.",
          );
        } catch (e) {
          print("❌ Error updating offline cache: $e");
          ShowDialogs.showToast("Failed to delete offline data");
        }
      } else {
        ShowDialogs.showToast("No internet & no cached data to delete from");
      }
    }
  }

  Widget siteDropdown(StateSetter setStateDialgoue) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Card(
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: ListView.builder(
            itemCount: GlobalLists.sitemasterlist.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      setStateDialgoue(() {
                        sitenamecontroller.text =
                            GlobalLists.sitemasterlist[index].siteName;
                        attendancesiteid = GlobalLists.sitemasterlist[index].id
                            .toString();

                        isexpanded = false;
                      });
                    },
                    child: Container(
                      color: Colors.white,
                      width: SizeConfig.blockSizeHorizontal * 100,
                      child: Text(
                        GlobalLists.sitemasterlist[index].siteName,
                        style: AppFonts.headerStyle(
                          fontSize: 14,
                          color: customcolor.black,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Divider(color: customcolor.greybg),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget clientDropdown(StateSetter setStateDialgoue) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Card(
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.only(left: 10, right: 10, top: 10),
          child: ListView.builder(
            itemCount: GlobalLists.clientmasterlist.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      setStateDialgoue(() {
                        clientnamecontroller.text =
                            GlobalLists.clientmasterlist[index].clientName;

                        isexpandedclient = false;
                        sitenamecontroller.text = "";
                        attendanceclientid = GlobalLists
                            .clientmasterlist[index]
                            .clientId
                            .toString();
                        attendancesiteid = GlobalLists
                            .clientmasterlist[index]
                            .siteId
                            .toString();

                        janotoragendaApi(attendanceclientid, attendancesiteid);
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 3, bottom: 2),
                      child: Container(
                        color: Colors.white,
                        width: SizeConfig.blockSizeHorizontal * 100,
                        child: Text(
                          GlobalLists.clientmasterlist[index].clientName,
                          style: AppFonts.headerStyle(
                            fontSize: 14,
                            color: customcolor.black,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Divider(color: customcolor.greybg),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  //site master

  unitsitemasterApi(String clientid) async {
    var status1 = await ConnectionDetector.checkInternetConnection();

    if (status1) {
      var map = new Map<String, dynamic>();
      map['cid'] = clientid;

      APIManager().apiRequest(
        context,
        API.unitsitemaster,
        (response) async {
          sitemaster.UnitsiteMasterResponse resp = response;
          print('called API ${resp}');
          if (resp.status == "success") {
            setState(() {
              GlobalLists.sitemasterlist = resp.data;
            });
            // Navigator.of(this.context).pop();
            //  ShowDialogs.showToast(resp.msg);
          } else {
            ShowDialogs.showToast(resp.msg);
            // Navigator.of(this.context).pop();
          }
        },
        (error) {
          print('ERR msg is $error');
          //  Navigator.of(this.context).pop();
        },
        false,
        "",
        jsonval: map,
      );
    } else {
      ShowDialogs.showToast("Please check internet connection");
    }
  }

  supervisorattendancelist(List<EmployeeList> employeelist) {
    return Container(
      height: SizeConfig.blockSizeVertical * 50,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: employeelist.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 2.0, bottom: 6),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                side: BorderSide(width: 0.5, color: customcolor.greyborder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          employeelist[index].name == null
                              ? ""
                              : employeelist[index].name,
                          style: AppFonts.headerStyle(
                            fontSize: 17.sp,
                            color: customcolor.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (GlobalLists.attendance_delete_permission ==
                              false) {
                            ShowDialogs.showToast('No Active Shift');
                          } else {
                            ShowDialogs.showConfirmDialog(
                              context,
                              "Delete",
                              "Are you sure you want to\n delete these attendance?",
                              () {
                                deleteattendanceApi(
                                  employeelist[index].id.toString(),
                                );
                              },
                            );
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.delete,
                            color: customcolor.textblue,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                      top: 2,
                      bottom: 15,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: customcolor.skybluebg,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Mobile",
                                  style: AppFonts.headerStyle(
                                    fontSize: 15.sp,
                                    color: customcolor.greytext,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 3),
                                Text(
                                  employeelist[index].contact,
                                  style: AppFonts.headerStyle(
                                    fontSize: 17.sp,
                                    color: customcolor.black,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Login Timing",
                                  style: AppFonts.headerStyle(
                                    fontSize: 15.sp,
                                    color: customcolor.greytext,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 3),
                                Text(
                                  "${employeelist[index].loginTime}",
                                  style: AppFonts.headerStyle(
                                    fontSize: 17.sp,
                                    color: customcolor.black,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
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
        },
      ),
    );
  }

  Widget unitattendancelist(
    List<unitatt.EmployeeList> employeelist,
    bool delete_permission,
  ) {
    return Column(
      children: employeelist.map((employee) {
        return Padding(
          padding: const EdgeInsets.only(right: 2.0, bottom: 6),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              side: BorderSide(width: 0.5, color: customcolor.greyborder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        employee.name,
                        style: AppFonts.headerStyle(
                          fontSize: 17.sp,
                          color: customcolor.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    (role == GlobalLists.clientrole)
                        ? Container()
                        : GestureDetector(
                            onTap: () {
                              if (!delete_permission) {
                                ShowDialogs.showToast('No Active Shift');
                              } else {
                                ShowDialogs.showConfirmDialog(
                                  context,
                                  "Delete",
                                  "Are you sure you want to delete this attendance?",
                                  () {
                                    deleteattendanceApi(employee.id.toString());
                                  },
                                );
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.delete,
                                color: customcolor.textblue,
                                size: 18,
                              ),
                            ),
                          ),
                  ],
                ),

                // Details box
                Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                    top: 2,
                    bottom: 15,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: customcolor.skybluebg,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _infoColumn("Mobile", employee.contact),
                          _infoColumn("Login Timing", employee.loginTime),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _infoColumn(String title, String value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: AppFonts.headerStyle(
            fontSize: 12,
            color: customcolor.greytext,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: AppFonts.headerStyle(
            fontSize: 13,
            color: customcolor.black,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  // unitattendancelist(
  //     List<unitatt.EmployeeList> employeelist, bool delete_permission) {
  //   return Container(
  //     height: SizeConfig.blockSizeVertical * 90,
  //     child: ListView.builder(
  //       scrollDirection: Axis.vertical,
  //       shrinkWrap: true,
  //       physics: ScrollPhysics(),
  //       itemCount: employeelist.length,
  //       itemBuilder: (context, index) {
  //         return Padding(
  //           padding: const EdgeInsets.only(right: 2.0, bottom: 6),
  //           child: Card(
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.all(
  //                 Radius.circular(10),
  //               ),
  //               side: BorderSide(width: 0.5, color: customcolor.greyborder),
  //             ),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Padding(
  //                       padding: const EdgeInsets.all(8.0),
  //                       child: Text(
  //                         employeelist[index].name,
  //                         style: AppFonts.headerStyle(
  //                             fontSize:
  //                                 17.sp,
  //                             color: customcolor.black,
  //                             fontWeight: FontWeight.w500),
  //                       ),
  //                     ),
  //                     (role == GlobalLists.clientrole)
  //                         ? Container()
  //                         : GestureDetector(
  //                             onTap: () {
  //                               if (delete_permission == false) {
  //                                 ShowDialogs.showToast('No Active Shift');
  //                               } else {
  //                                 ShowDialogs.showConfirmDialog(
  //                                     context,
  //                                     "Delete",
  //                                     " Are you sure you want to\n delete these attendance?",
  //                                     () {
  //                                   deleteattendanceApi(
  //                                       employeelist[index].id.toString());
  //                                 });
  //                               }
  //                             },
  //                             child: Padding(
  //                               padding: const EdgeInsets.all(8.0),
  //                               child: Icon(
  //                                 Icons.delete,
  //                                 color: customcolor.textblue,
  //                                 size: 18,
  //                               ),
  //                             ),
  //                           )
  //                   ],
  //                 ),
  //                 Padding(
  //                   padding: const EdgeInsets.only(
  //                       left: 10, right: 10, top: 2, bottom: 15),
  //                   child: Container(
  //                     decoration: BoxDecoration(
  //                       color: customcolor.skybluebg,
  //                       borderRadius: BorderRadius.all(Radius.circular(10)),
  //                     ),
  //                     child: Padding(
  //                       padding: const EdgeInsets.all(8.0),
  //                       child: Row(
  //                         mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                         children: [
  //                           Column(
  //                             mainAxisAlignment: MainAxisAlignment.center,
  //                             crossAxisAlignment: CrossAxisAlignment.center,
  //                             children: [
  //                               Text(
  //                                 "Mobile",
  //                                 style: AppFonts.headerStyle(
  //                                     fontSize: ResponsiveFlutter.of(context)
  //                                         .fontSize(1.5),
  //                                     color: customcolor.greytext,
  //                                     fontWeight: FontWeight.w600),
  //                               ),
  //                               SizedBox(
  //                                 height: 3,
  //                               ),
  //                               Text(
  //                                 employeelist[index].contact,
  //                                 style: AppFonts.headerStyle(
  //                                     fontSize: ResponsiveFlutter.of(context)
  //                                         .fontSize(1.7),
  //                                     color: customcolor.black,
  //                                     fontWeight: FontWeight.w400),
  //                               ),
  //                             ],
  //                           ),
  //                           Column(
  //                             mainAxisAlignment: MainAxisAlignment.center,
  //                             crossAxisAlignment: CrossAxisAlignment.center,
  //                             children: [
  //                               Text(
  //                                 "Login Timing",
  //                                 style: AppFonts.headerStyle(
  //                                     fontSize: ResponsiveFlutter.of(context)
  //                                         .fontSize(1.5),
  //                                     color: customcolor.greytext,
  //                                     fontWeight: FontWeight.w600),
  //                               ),
  //                               SizedBox(
  //                                 height: 3,
  //                               ),
  //                               Text(
  //                                 "${employeelist[index].loginTime}",
  //                                 style: AppFonts.headerStyle(
  //                                     fontSize: ResponsiveFlutter.of(context)
  //                                         .fontSize(1.7),
  //                                     color: customcolor.black,
  //                                     fontWeight: FontWeight.w400),
  //                               ),
  //                             ],
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }
  bool isattendanceLoadin = false;
  //attendance api catch store
  attendanceApi() async {
    log('attendanceApi');
    var status1 = await ConnectionDetector.checkInternetConnection();

    if (status1) {
      // GlobalLists.attendanceemployeelist = [];
      //29OctRUCHI
      setState(() {
        isattendanceLoadin = true;
      });

      var supervisorid = await SPManager().getsupervisorid();
      var map = {
        'supervisor': supervisorid,
        'today_date': GlobalLists.datecontroller.text,
      };

      APIManager().apiRequest(
        context,
        API.attendance,
        (response) async {
          AttendencelistResponse resp = response;

          if (resp.status == 1) {
            setState(() {
              GlobalLists.attendancedata = resp.data;
              GlobalLists.superviorgraphlist = resp.graphData;

              log('GlobalLists.attendancedata');
              log(
                'GlobalLists.attendancedata.count ${GlobalLists.attendancedata}',
              );

              GlobalLists.mainlisttab = [
                unitatt.Datum(
                  clientName: "OverAll",
                  clientId: 0,
                  siteId: 0,
                  attendanceDetails: [],
                  lowattendance: false,
                  attendedCount: 0,
                  totalNoStaff: 0,
                  notapplicable: 0,
                ),
                unitatt.Datum(
                  clientName: resp.data.clientSiteName,
                  clientId: resp.data.clientId,
                  siteId: resp.data.siteId,
                  attendanceDetails: [],
                  lowattendance: resp.data.lowattendance,
                  attendedCount: 0,
                  totalNoStaff: 0,
                  notapplicable: 0,
                ),
              ];
              GlobalLists.attendanceemployeelist = resp.data.employeeList;
              isdataloaded = true;

              if (resp.data.clientSiteName == widget.clientname) {
                maintag = 1;
              }
            });

            final prefs = await SharedPreferences.getInstance();
            await prefs.setString(
              'cached_attendance_data',
              attendencelistResponseToJson(resp),
            );

            // ✅ Save JSON to SharedPreferences
            //29OctRUCHI
            setState(() {
              isattendanceLoadin = false;
            });
            // Navigator.of(this.context).pop();
          } else {
            //29OctRUCHI
            setState(() {
              isattendanceLoadin = false;
            });
            // Navigator.of(this.context).pop();
          }
        },
        (error) {
          //  Navigator.of(this.context).pop();
          setState(() {
            isattendanceLoadin = false;
          });
          log('ERR msg is $error');
        },
        false,
        "",
        jsonval: map,
      );
    } else {
      // 🚫 Offline Mode: Load from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      String? cachedData = prefs.getString('cached_attendance_data');

      if (cachedData != null) {
        try {
          AttendencelistResponse resp = attendencelistResponseFromJson(
            cachedData,
          );

          setState(() {
            GlobalLists.attendancedata = resp.data;
            GlobalLists.superviorgraphlist = resp.graphData;
            GlobalLists.mainlisttab = [
              unitatt.Datum(
                clientName: "OverAll",
                clientId: 0,
                siteId: 0,
                attendanceDetails: [],
                lowattendance: false,
                attendedCount: 0,
                totalNoStaff: 0,
                notapplicable: 0,
              ),
              unitatt.Datum(
                clientName: resp.data.clientSiteName,
                clientId: resp.data.clientId,
                siteId: resp.data.siteId,
                attendanceDetails: [],
                lowattendance: resp.data.lowattendance,
                attendedCount: 0,
                totalNoStaff: 0,
                notapplicable: 0,
              ),
            ];
            GlobalLists.attendanceemployeelist = resp.data.employeeList;
            isdataloaded = true;

            if (resp.data.clientSiteName == widget.clientname) {
              maintag = 1;
            }
          });

          ShowDialogs.showToast("Offline attendance data loaded");
        } catch (e) {
          print("❌ Error parsing cached attendance: $e");
          ShowDialogs.showToast("Failed to load offline data");
        }
      } else {
        ShowDialogs.showToast("No internet and no cached data available");
      }
    }
  }

  unitattendanceApi() async {
    print('unitattendanceApi called');
    var status1 = await ConnectionDetector.checkInternetConnection();
    final prefs = await SharedPreferences.getInstance();

    var clientid = await SPManager().getclientid();
    var supervisorid = await SPManager().getsupervisorid();

    final cacheKey =
        'cached_unitattendance_${GlobalLists.datecontroller.text}_${clientid ?? supervisorid}';

    Map<String, dynamic> map = {'date': GlobalLists.datecontroller.text};

    if (role == GlobalLists.clientrole) {
      map['clientid'] = clientid;
    } else {
      map['emp_id'] = supervisorid;
    }

    if (status1) {
      setState(() {
        GlobalLists.mainlisttab = [];
        GlobalLists.attendanceemployeelist = [];
      });
      // 29OctRUCHI

      setState(() {
        isattendanceLoadin = true;
      });

      APIManager().apiRequest(
        context,
        API.unitattendance,
        (response) async {
          try {
            final unitatt.UnitAttendanceResponse resp = response;
            // 29OctRUCHI
            setState(() {
              isattendanceLoadin = false;
            });

            // Navigator.of(context).pop(); // Close loading dialog

            if (resp.status == 1) {
              // Cache response
              await prefs.setString(cacheKey, json.encode(resp.toJson()));

              // Parse and update UI
              _handleAttendanceResponse(resp);
            } else {
              ShowDialogs.showToast(resp.msg);
            }
          } catch (e) {
            Navigator.of(context).pop();
            print('Error parsing API response: $e');
            ShowDialogs.showToast("Failed to parse API. Loading offline...");
            _loadCachedUnitAttendance(prefs, cacheKey);
          }
        },
        (error) {
          // Navigator.of(context).pop();
          log('API error checking : $error');
          ShowDialogs.showToast("API failed. Loading offline...");
          _loadCachedUnitAttendance(prefs, cacheKey);
        },
        false,
        "",
        jsonval: map,
      );
    } else {
      ShowDialogs.showToast("Offline: Loading cached attendance");
      _loadCachedUnitAttendance(prefs, cacheKey);
    }
  }

  void _loadCachedUnitAttendance(SharedPreferences prefs, String cacheKey) {
    final cachedData = prefs.getString(cacheKey);
    if (cachedData != null) {
      try {
        final unitatt.UnitAttendanceResponse resp =
            unitatt.UnitAttendanceResponse.fromJson(json.decode(cachedData));

        if (resp.status == 1) {
          _handleAttendanceResponse(resp);
        } else {
          ShowDialogs.showToast("Cached data invalid.");
        }
      } catch (e) {
        print('Error loading cached data: $e');
        ShowDialogs.showToast("Failed to load cached data.");
      }
    } else {
      ShowDialogs.showToast("No offline data found.");
    }
  }

  void _handleAttendanceResponse(unitatt.UnitAttendanceResponse resp) async {
    GlobalLists.mainlisttab = [];
    setState(() {
      isdataloaded = true;
      for (int i = 0; i < resp.data.length; i++) {
        GlobalLists.mainlisttab.add(resp.data[i]);
        GlobalLists.notapplicable = resp.data[i].notapplicable;
        clientname = widget.clientname.toString();
        if (resp.data[i].clientName == widget.clientname) {
          maintag = i;
        }
      }

      GlobalLists.mainlisttab.add(
        unitatt.Datum(
          clientName: "OverAll",
          clientId: 0,
          siteId: 0,
          attendanceDetails: [],
          lowattendance: false,
          attendedCount: 0,
          totalNoStaff: 0,
          notapplicable: 0,
        ),
      );

      mainlaglastposition_overall = GlobalLists.mainlisttab.length;

      if (GlobalLists.mainlisttab[maintag].attendanceDetails.isNotEmpty) {
        attendanceshiftid = GlobalLists
            .mainlisttab[maintag]
            .attendanceDetails[0]
            .id
            .toString();
      } else {
        attendanceshiftid = "";
      }

      for (
        int i = 0;
        i < GlobalLists.mainlisttab[maintag].attendanceDetails.length;
        i++
      ) {
        if (GlobalLists.mainlisttab[maintag].attendanceDetails[i].currentTime ==
            true) {
          tag = i;
          attendanceshiftid = GlobalLists
              .mainlisttab[maintag]
              .attendanceDetails[i]
              .id
              .toString();
          attendanceclientid = GlobalLists.mainlisttab[maintag].clientId
              .toString();
          attendancesiteid = GlobalLists.mainlisttab[maintag].siteId.toString();
          janotoragendaApi(attendanceclientid, attendancesiteid);
        }
      }
      print("unit 1");
      unitgraphattendanceApi();
    });
  }

  // only graph data offline db

  unitgraphattendanceApi() async {
    var status1 = await ConnectionDetector.checkInternetConnection();

    if (status1) {
      var map = new Map<String, dynamic>();

      var clientid = await SPManager().getclientid();
      var supervisorid = await SPManager().getsupervisorid();
      print(clientid);
      if (role == GlobalLists.clientrole) {
        map['clientid'] = clientid;
        map['date'] = GlobalLists.datecontroller.text;
      } else {
        map['date'] = GlobalLists.datecontroller.text;
        map['emp_id'] = supervisorid;
      }
      print("OVERALL");
      print(map);
      //OM attendance
      APIManager().apiRequest(
        context,
        API.overallgraph,
        (response) async {
          graph.UnitGraphAttendanceResponse resp = response;
          print('called API ${resp}');
          if (resp.status == 1) {
            setState(() {
              GlobalLists.graphlist = resp.graphData;

              // log('GlobalLists.graphlist ${GlobalLists.graphlist.length}');
            });

            final prefs = await SharedPreferences.getInstance();
            await prefs.setString(
              'unitgraphattendanceApi',
              unitgraph.unitGroupAttendanceResponseToJson(resp),
            );
          } else {
            ShowDialogs.showToast(resp.msg);
            // Navigator.of(this.context).pop();
          }
        },
        (error) {
          print('ERR msg is $error');
        },
        false,
        "",
        jsonval: map,
      );
    } else {
      final prefs = await SharedPreferences.getInstance();
      String? cachedData = prefs.getString('unitgraphattendanceApi');

      if (cachedData != null) {
        // 🔥 Fix here: use `fromJson`, not `toJson`
        graph.UnitGraphAttendanceResponse cachedResponse = unitgraph
            .unitGraphAttendanceResponseFromJson(cachedData);

        setState(() {
          GlobalLists.graphlist = cachedResponse.graphData ?? [];
        });
        ShowDialogs.showToast("Offline data loaded");
      } else {
        ShowDialogs.showToast("No internet and no offline data available");
      }
    }
  }

  Future<Placemark> getLocation() async {
    print("Getting location...");

    // Request permission if needed
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    print('Location: ${position.latitude}, ${position.longitude}');

    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    var first = placemarks.first;

    String lat = position.latitude.toString();
    String long = position.longitude.toString();

    print(
      "${first.name} : ${first.street}, ${first.locality}, ${first.country}",
    );

    return first;
  }

  void showStaffCountBottomSheet(
    BuildContext context,

    int initialCount,
    int numeratorCount,
  ) {
    int currentCount = initialCount;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Small handle at top
                  Container(
                    height: 4,
                    width: 50,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  Text(
                    "Update Staff Count",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Increment-Decrement Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          if (currentCount <= numeratorCount) {
                            ShowDialogs.showToast(
                              "The total staff count cannot exceed the number of attendances marked.",
                            );
                          } else {
                            if (currentCount > 1) {
                              setState(() => currentCount--);
                            }
                          }
                        },
                        icon: Icon(
                          Icons.remove_circle_outline,
                          size: 35,
                          color: customcolor.blue,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Text(
                          "$currentCount",
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          if (currentCount < numeratorCount) {
                            ShowDialogs.showToast(
                              "The total staff count cannot exceed the number of attendances marked.",
                            );
                          } else {
                            setState(() => currentCount++);
                          }
                        },
                        icon: Icon(
                          Icons.add_circle_outline,
                          size: 35,
                          color: customcolor.blue,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Submit button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: customcolor.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        // onSubmit(currentCount);

                        addNoOFStaffApi(
                          initialCount.toString(),
                          currentCount.toString(),
                          numeratorCount.toString(),
                        );
                      },
                      child: const Text(
                        "Submit",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            );
          },
        );
      },
    );
  }

  addNoOFStaffApi(String noofstaff, String newstaff, String staffcount) async {
    log(' In side addNoOFStaffApi');
    var status1 = await ConnectionDetector.checkInternetConnection();
    var map = <String, dynamic>{};
    var supervisorid = await SPManager().getsupervisorid();

    map['Client'] = GlobalLists.clientid;
    map['Site'] = GlobalLists.siteid;
    map['no_of_staff'] = noofstaff;
    map['new_no_of_staff'] = newstaff;
    map['attanded_staff_count'] = staffcount;
    map['shift_name'] = GlobalLists.shiftid;
    map["supervisor"] = supervisorid;
    map["multidays"] = "false";

    if (status1) {
      setState(() {
        isattendanceLoadin = true;
      });
      APIManager().apiRequest(
        context,
        API.add_attendance_daily_count,
        (response) async {
          AddDailyCountResponse resp = response;

          if (resp.status == 1) {
            setState(() {
              // Navigator.of(this.context).pop();
              isattendanceLoadin = false;
              print("RUCHIIF");

              Timer(
                Duration(seconds: 1),
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => Attendance(clientname),
                  ),
                ),
              );
            });
          } else {
            ShowDialogs.showToast(resp.msg!);
            print("RUCHIELSE");
            setState(() {
              isattendanceLoadin = false;
            });
            // Navigator.of(this.context).pop();
          }
        },
        (error) {
          log('ERR msg is $error');
        },
        false,
        "",
        jsonval: map,
      );
    } else {
      print("RUCHIELSE offline");
      // 🚫 Offline Mode
    }
  }

  //addattendance api
  addattendanceApi() async {
    log(' In side addattendanceApi');
    var status1 = await ConnectionDetector.checkInternetConnection();
    var map = <String, dynamic>{};

    if (role == GlobalLists.unitrole ||
        role == GlobalLists.operationrole ||
        role == GlobalLists.operationmanagerrole) {
      map['name'] = namecontroller.text.trim();
      map['contact'] = mobilecontroller.text.trim();
      map['client_id'] = attendanceclientid;
      map['site_id'] = attendancesiteid;
      map['latitude'] = lat;
      map['longitude'] = long;
      map['user_type'] = role == GlobalLists.supervisorrole ? "Supervisor" : "";
      map['shift'] = attendanceshiftid;
      map["date"] = DateTime.now().toIso8601String().split('T')[0];
      map["time"] = DateTime.now()
          .toIso8601String()
          .split('T')[1]
          .split('.')[0];
    } else {
      map['name'] = namecontroller.text.trim();
      map['contact'] = mobilecontroller.text.trim();
      map['client_id'] = GlobalLists.clientid;
      map['site_id'] = GlobalLists.siteid;
      map['latitude'] = lat;
      map['longitude'] = long;
      map['user_type'] = role == GlobalLists.supervisorrole ? "Supervisor" : "";
      map['shift'] = GlobalLists.shiftid;
      map["date"] = DateTime.now().toIso8601String().split('T')[0];
      map["time"] = DateTime.now()
          .toIso8601String()
          .split('T')[1]
          .split('.')[0];
    }

    if (status1) {
      log(' In side called');
      // ✅ Online mode
      // ShowDialogs.showLoadingDialog(context, _keyLoader);
      setState(() {
        GlobalLists.isaddAttendance.value = true;
      });
      APIManager().apiRequest(
        context,
        API.addattendance,
        (response) async {
          addattten.AddAttendanceResponse resp = response;
          if (resp.status == 1) {
            setState(() {
              // Navigator.of(this.context).pop();
              GlobalLists.isaddAttendance.value = false;
              print("RUCHIIF");
              // Timer(Duration(seconds: 1), () => Navigator.pop(context));
              ShowDialogs().confirmationdone(
                context,
                "Mark Attendance \nSuccessfully",
              );
              Timer(
                Duration(seconds: 1),
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => Attendance(clientname),
                  ),
                ),
              );
            });
          } else {
            ShowDialogs.showToast(resp.msg);
            print("RUCHIELSE");
            setState(() {
              GlobalLists.isaddAttendance.value = false;
            });
            // Navigator.of(this.context).pop();
          }
        },
        (error) {
          log('ERR msg is $error');
        },
        false,
        "",
        jsonval: map,
      );
    } else {
      print("RUCHIELSE offline");
      // 🚫 Offline Mode
      await DBHelper.insertOfflineRequest(
        '${Global.baseUrl}/api/attendancemaster/Add_AttendanceMaster',
        map,
      );

      final newId = DateTime.now().millisecondsSinceEpoch;
      log(map.toString());

      final newEmployee = EmployeeList(
        id: newId,
        name: map['name'],
        contact: map['contact'],
        loginTime: map['time'],
      );

      // ✅ Check duplicate in GlobalLists
      bool exists = GlobalLists.attendanceemployeelist.any(
        (e) => e.contact == newEmployee.contact,
      );

      if (!exists) {
        // setState(() {
        GlobalLists.attendanceemployeelist.add(newEmployee);
        GlobalLists.attendancedata.employeeList.add(newEmployee);
        // });

        // ✅ Update SharedPreferences cache
        final prefs = await SharedPreferences.getInstance();
        String? cachedData = prefs.getString('cached_attendance_data');

        if (cachedData != null) {
          try {
            AttendencelistResponse resp = attendencelistResponseFromJson(
              cachedData,
            );

            // Avoid duplicates in cache
            bool cacheExists = resp.data.employeeList.any(
              (e) => e.contact == newEmployee.contact,
            );

            if (!cacheExists) {
              resp.data.employeeList.add(newEmployee);
              await prefs.setString(
                'cached_attendance_data',
                attendencelistResponseToJson(resp),
              );
            }
          } catch (e) {
            print("❌ Error updating cache: $e");
          }
        }
      } else {
        ShowDialogs.showToast("Already marked attendance for this contact");
      }

      // Navigate
      Timer(
        Duration(seconds: 1),
        () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => Attendance(clientname),
          ),
        ),
      );

      ShowDialogs.showToast("Saved offline. Will sync when connected.");
    }
  }

  //janitorlist for attendance
  janotoragendaApi(String idclient, String idsite) async {
    var status1 = await ConnectionDetector.checkInternetConnection();

    // setState(() {
    //   print("JANITORSUPER");
    //   // GlobalLists.dropdownList = [];
    // });

    var map = {'client_id': idclient, 'site_id': idsite};

    final cacheKey = 'cached_janitor_${idclient}_$idsite';

    if (status1) {
      // ✅ ONLINE mode
      APIManager().apiRequest(
        context,
        API.janitorslist,
        (response) async {
          JanitorslistResponse resp = response;
          log('called Janitor Name : ${resp.data}');

          if (resp.status == 1) {
            setState(() {
              if (resp.data.isNotEmpty) {
                GlobalLists.dropdownList = resp.data.map((e) {
                  log(e.janName);
                  log(e.contact);
                  return Janitorcheckbox(
                    e.janName.toString(),
                    e.id.toString(),
                    false,
                    e.contact,
                  );
                }).toList();
              }

              // .map((e) => Janitorcheckbox(
              //       e.janName.toString(),
              //       e.id.toString(),
              //       false,
              //     ))
              // .toList();

              print('called JANITOR LENGTH ${GlobalLists.dropdownList.length}');
            });

            // ✅ Save response to local cache
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString(cacheKey, json.encode(resp.toJson()));
          } else {
            ShowDialogs.showToast(resp.msg);
          }
        },
        (error) {
          print('ERR msg is $error');
        },
        false,
        "",
        jsonval: map,
      );
    } else {
      // 🚫 OFFLINE mode
      final prefs = await SharedPreferences.getInstance();
      String? cachedData = prefs.getString(cacheKey);

      if (cachedData != null) {
        JanitorslistResponse cachedResp = JanitorslistResponse.fromJson(
          json.decode(cachedData),
        );

        setState(() {
          GlobalLists.dropdownList = cachedResp.data
              .map(
                (e) => Janitorcheckbox(
                  e.janName.toString(),
                  e.id.toString(),
                  false,
                  e.contact,
                ),
              )
              .toList();
        });

        ShowDialogs.showToast("Offline janitor list loaded");
      } else {
        ShowDialogs.showToast("No internet and no cached janitor data found");
      }
    }
  }

  //janitor dropdown
  Widget janitorsDropdown(StateSetter setStateDialgoue) {
    return Container(
      height: 105,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Card(
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.only(left: 10, right: 10, top: 10),
          child: ListView.builder(
            itemCount: GlobalLists.dropdownList.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      setStateDialgoue(() {
                        namecontroller.text =
                            GlobalLists.dropdownList[index].name;
                        mobilecontroller.text =
                            GlobalLists.dropdownList[index].contact;

                        isexpandedjanitor = false;

                        // fetchcontactApi(dropdownList[index].id.toString());
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 3, bottom: 2),
                      child: Container(
                        color: Colors.white,
                        width: SizeConfig.blockSizeHorizontal * 100,
                        child: Text(
                          GlobalLists.dropdownList[index].name,
                          style: AppFonts.headerStyle(
                            fontSize: 14,
                            color: customcolor.black,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Divider(color: customcolor.greybg),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  //fetch contact from janitor
  // fetchcontactApi(String janitorid) async {
  //   var status1 = await ConnectionDetector.checkInternetConnection();

  //   if (status1) {
  //     ShowDialogs.showLoadingDialog(context, _keyLoader);

  //     var map = new Map<String, dynamic>();

  //     map['id'] = janitorid;

  //     APIManager().apiRequest(context, API.fetchcontact_janitors,
  //         (response) async {
  //       JanitorContactFetchResponse resp = response;
  //       print('called API ${resp}');
  //       if (resp.status == 1) {
  //         Navigator.of(this.context).pop();
  //         //   ShowDialogs.showToast(resp.msg);
  //         setState(() {
  //           mobilecontroller.text = resp.data[0].contact;
  //         });
  //       } else {
  //         mobilecontroller.text = "";
  //         ShowDialogs.showToast(resp.msg);
  //         Navigator.of(this.context).pop();
  //       }
  //     }, (error) {
  //       print('ERR msg is $error');
  //     }, false, "", jsonval: map);
  //   } else {
  //     ShowDialogs.showToast("Please check internet connection");
  //   }
  // }
}

extension ExtendedIterable<E> on Iterable<E> {
  /// Like Iterable<T>.map but the callback has index as second argument
  Iterable<T> mapIndexed<T>(T Function(E e, int i) f) {
    var i = 0;
    return map((e) => f(e, i++));
  }

  void forEachIndexed(void Function(E e, int i) f) {
    var i = 0;
    forEach((e) => f(e, i++));
  }
}
