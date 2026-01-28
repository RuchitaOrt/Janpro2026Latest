// ignore_for_file: unnecessary_null_comparison, no_leading_underscores_for_local_identifiers, unused_local_variable

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:janpro/Screens/Attendance.dart';
import 'package:janpro/Screens/view_remark_attendance.dart';
import 'package:janpro/Utitlity/APIManager.dart';
import 'package:janpro/Utitlity/GlobalLists.dart';
import 'package:janpro/Utitlity/SPManager.dart';
import 'package:janpro/Utitlity/ShowDialog.dart';
import 'package:janpro/Utitlity/custom_color.dart';
import 'package:janpro/Utitlity/internetConnection.dart';
import 'package:janpro/model/ApprovAttendanceRooster.dart';
import 'package:janpro/model/RejectAttendanceRooster.dart';
import 'package:janpro/model/SubmitAttendanceRooster.dart';
import 'package:janpro/model/attendance_roster_response.dart';

class ViewAttendanceRoster extends StatefulWidget {
  final List<dynamic> attendanceRosterData;
  final String month;
  final String year;
  final int attendancesiteid;
  var attendanceclientid;
  final String role;
  var maintag;

  ViewAttendanceRoster({
    required this.attendanceRosterData,
    required this.month,
    required this.year,
    required this.attendancesiteid,
    required this.attendanceclientid,
    required this.role,
    required this.maintag,
  });

  @override
  _ViewAttendanceRosterState createState() => _ViewAttendanceRosterState();
}

class _ViewAttendanceRosterState extends State<ViewAttendanceRoster> {
  String month = '';
  String year = '';
  late int selectedYear;
  late int selectedMonthIndex;
  // late String selectedMonthDisplay;
  dynamic selectedShift;
  var maintag;
  Set<String> selectedCells = {};
  bool multiSelectMode = false;
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
  final List<int> availableYears = [2026, 2025];

  Map<String, List<dynamic>> groupedByMonth = {};
  var role;
  getrole() async {
    role = await SPManager().getroleid();
  }

  var attendancesiteid;
  var attendanceclientid;
  List<dynamic> _attendanceRosterData = [];

  @override
  void initState() {
    getrole();
    maintag = widget.maintag;
    attendancesiteid = widget.attendancesiteid;
    attendanceclientid = widget.attendanceclientid;

    super.initState();
    _fetchAttendanceRoster();
  }

  _fetchAttendanceRoster() async {
    try {
      var status1 = await ConnectionDetector.checkInternetConnection();
      if (!status1) {
        ShowDialogs.showToast("Please check internet connection");
        return;
      }

      // Get current date
      final now = DateTime.now();

      log('now check this ');

      // Set default month and year if not provided

      if ((month == null || month.isEmpty) && (year == null || year.isEmpty)) {
        if (now.month == 1) {
          // January → previous year December
          month = "12";
          year = (now.year - 1).toString();
        } else {
          // Any other month → current month/year
          month = now.month.toString().padLeft(2, '0');
          year = now.year.toString();
        }
      }

      // Parse month and year
      int selectedMonth = int.parse(month);
      int selectedYear = int.parse(year);

      // Calculate first and last day of the selected month
      final firstDayOfMonth = DateTime(selectedYear, selectedMonth, 1);
      final lastDayOfMonth = DateTime(
        selectedYear,
        selectedMonth + 1,
        0,
      ); // Last day of month

      // Prepare the API request map
      var map = {
        'site_id': attendancesiteid.toString(),
        'from_date': DateFormat('yyyy-MM-dd').format(firstDayOfMonth),
        'to_date': DateFormat('yyyy-MM-dd').format(lastDayOfMonth),
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
          // Navigator.pop(context); // Dismiss loading dialog

          try {
     

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
                print(
                  "_attendanceRosterData length: ${_attendanceRosterData.length}",
                );

              });
              Navigator.pop(context); 

            } else {
              ShowDialogs.showToast(rosterResponse.msg);
            }
          } catch (e) {
            print('Error parsing response: $e');
            ShowDialogs.showToast('Error processing data: ${e.toString()}');
          }
        },
        (error) {
          // Navigator.pop(context); // Dismiss loading dialog
          ShowDialogs.showToast('Error: ${error.toString()}');
        },
        false,
        "",
        jsonval: map,
      );
    } catch (e) {
      // Navigator.pop(context); // Dismiss loading dialog if still showing
      ShowDialogs.showToast('An error occurred');
    }
  }

 

  var shiftId;
  var clientId;
  var userId;
  var siteId;

  @override
  Widget build(BuildContext context) {
    if (!mounted || context == null || _attendanceRosterData.isEmpty)
      return SizedBox.shrink();
    final _horizontalScrollKey = GlobalKey();
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

    int currentMonth = int.parse(month);
    int currentYear = int.parse(year);

    final Map<String, List<dynamic>> groupedByMonth = {};
    for (var shift in _attendanceRosterData) {
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

    List<int> availableYears = [2026, 2025];

    int selectedYear = int.parse(year);
    List<String> monthYears = [];
    for (int i = 1; i <= 12; i++) {
      monthYears.add('${monthNames[i]} $selectedYear');
    }

    String selectedMonth = '${monthNames[currentMonth]}';

    void _reloadDataForMonthYear(String newMonth, int newYear) {
      final monthName = newMonth.split(' ')[0];
      final monthIndex = monthNames.indexOf(monthName);
      month = monthIndex.toString().padLeft(2, '0');
      year = newYear.toString();

      // Close current dialog and fetch new data
      // Navigator.pop(context);
      _fetchAttendanceRoster();
    }

    // Sort months chronologically
    final availableMonths = groupedByMonth.keys.toList()
      ..sort((a, b) => getMonthYearDate(a).compareTo(getMonthYearDate(b)));

    // If selected month is not in available months, select the first available
    if (!availableMonths.contains(selectedMonth) &&
        availableMonths.isNotEmpty) {
      selectedMonth = availableMonths[0];
    }

    dynamic selectedShift = groupedByMonth[selectedMonth]?.isNotEmpty == true
        ? groupedByMonth[selectedMonth]![0]
        : null;

 
    // Change from String to int for month index tracking
    int selectedMonthIndex = currentMonth; // Track month by index (1-12)
    String selectedMonthDisplay = '${monthNames[currentMonth]} $selectedYear';

    // Helper function to get attendance status from key
    String _getAttendanceStatusFromKey(String key) {
      final parts = key.split(',');
      return parts.length >= 3 ? parts[2] : '';
    }

    bool _allSelectedHaveSameStatus() {
      if (selectedCells.isEmpty) return true;

      final firstStatus = _getAttendanceStatusFromKey(selectedCells.first);
      return selectedCells.every(
        (key) => _getAttendanceStatusFromKey(key) == firstStatus,
      );
    }

    String? _getCurrentSelectedStatus() {
      if (selectedCells.isEmpty) return null;

      final firstStatus = _getAttendanceStatusFromKey(selectedCells.first);
      return _allSelectedHaveSameStatus() ? firstStatus : null;
    }

    void _reloadDataForMonth(int monthIndex) {
      // Changed parameter type
      final monthIndexStr = monthIndex.toString().padLeft(2, '0');
      month = monthIndexStr;

      // Create the month-year string for grouping
      final monthYearKey = '${monthNames[monthIndex]} $selectedYear';

      // Update display
      selectedMonthDisplay = monthYearKey;

      // Update shift based on month-year key
      selectedShift = groupedByMonth[monthYearKey]?.isNotEmpty == true
          ? groupedByMonth[monthYearKey]![0]
          : null;

      // Clear selections
      selectedCells.clear();
      multiSelectMode = false;

      // Reload data
      // Navigator.pop(context);
      _fetchAttendanceRoster();
    }

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

    Map<String, dynamic> _prepareApiData(
      String reason,
      List<String> selectedKeys,
      String actionType, // 'submit', 'approve', or 'reject'
    ) {
      setState(() {
        siteId = '$attendancesiteid';
        userId = '$attendanceclientid';
        clientId = '$attendanceclientid';
        shiftId = selectedShift.id?.toString() ?? '';
      });

      log('check $siteId ,$userId,$clientId,$shiftId');

      // Get first selected date
      String toDate = '';
      if (selectedKeys.isNotEmpty) {
        final firstKeyParts = selectedKeys[0].split(',');
        if (firstKeyParts.length >= 2) {
          toDate = firstKeyParts[1];
        }
      }

      final List<Map<String, dynamic>> empDataList = [];
      final List<int> attendanceIdList = [];

      for (var key in selectedKeys) {
        final parts = key.split(',');
        if (parts.length < 3) continue;

        final empName = parts[0];
        final date = parts[1];

        EmployeeData? emp;
        try {
          emp = selectedShift.employeeList.firstWhere(
            (e) => e.empName == empName,
          );
        } catch (e) {
          continue;
        }

        if (emp == null) continue;

        AttendanceData? attendanceData;
        try {
          attendanceData = emp.attendData.firstWhere((att) => att.date == date);
        } catch (e) {
          log('No attendance data found for $empName on $date');
        }

        if (actionType == 'submit') {
          String toggledStatus = 'no';

          if (attendanceData?.attendanceStatus == 'yes') {
            toggledStatus = 'yes';
          } else if (attendanceData?.attendanceStatus == 'no') {
            toggledStatus = 'no';
          }

          Map<String, dynamic> data = {
            "date": date,
            "attendance_status": toggledStatus,
            "emp_id": emp.empId,
          };

          if (role == GlobalLists.clientrole) {
            data["reason"] = reason;
          } else {
            data["om_oe_resson"] = reason;
          }

          empDataList.add(data);
        } else if (actionType == 'approve' || actionType == 'reject') {
          if (attendanceData?.attendanceId != null) {
            attendanceIdList.add(attendanceData!.attendanceId!);
          } else {
            log('No attendance_id found for $empName on $date');
          }
        }
      }

      if (actionType == 'submit') {
        return {
          'site_id': siteId,
          'to_date': toDate,
          'shift': shiftId,
          'user_id': userId,
          'client_id': clientId,
          'emp_id': empDataList,
        };
      } else {
        return {
          'reason': reason,
          'user_id': userId,
          'is_client': role == GlobalLists.clientrole ? "true" : "false",
          'attendance_id_list': attendanceIdList,
        };
      }
    }

    // Function to show reason dialog
    void _showReasonDialog({bool isMultiSelect = false}) {
      // For multi-select, ensure all selected have the same status
      if (isMultiSelect && !_allSelectedHaveSameStatus()) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Cannot submit mixed attendance statuses. Please select only one type (All Present, All Absent, or All Unmarked).',
            ),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 3),
          ),
        );
        return;
      }

      bool hasReason = false;
      if (selectedCells.isNotEmpty) {
        for (var key in selectedCells) {
          final parts = key.split(',');
          if (parts.length >= 3) {
            final empName = parts[0];
            final date = parts[1];

            // Find the employee in the selected shift
            try {
              final emp = selectedShift.employeeList.firstWhere(
                (e) => e.empName == empName,
              );

              // Find the attendance data for this date
              final attendance = emp.attendData.firstWhere(
                (att) => att.date == date,
                // orElse: () => null,
              );
              log('Checking attendance ${attendance}');

              if (attendance != null && attendance.reason?.isNotEmpty == true) {
                hasReason = true;

                log('Found reason for $empName on $date: ${attendance.reason}');
                break;
              }
            } catch (e) {
              log('Error finding employee or attendance data: $e');
              continue;
            }
          }
        }
      }

      // Determine which buttons to show
      final bool showAcceptRemarkButtons = hasReason;
      final bool showSubmitButton = !showAcceptRemarkButtons;

      final reasonController = TextEditingController();
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.report_problem, color: Colors.redAccent),
                  SizedBox(width: 8),
                  Text(
                    "Mark as Absent",
                    style: TextStyle(
                      fontFamily: AppFonts.semibold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: Icon(Icons.close, color: customcolor.darkgrey),
                onPressed: () {
                  setState(() {
                    selectedCells.clear();
                    multiSelectMode = false;
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isMultiSelect
                    ? "Please enter a reason for marking ${selectedCells.length} employee(s) as absent."
                    : "Please enter a reason for marking this employee as absent.",
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: AppFonts.regular,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: reasonController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Enter reason here...",
                  hintStyle: TextStyle(
                    fontFamily: AppFonts.regular,
                    color: Colors.grey[500],
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: customcolor.blue),
                  ),
                ),
              ),
            ],
          ),
          actionsPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          actions: [
            if (showSubmitButton)
              ElevatedButton(
                onPressed: () async {
                  final reason = reasonController.text.trim();

                  final apiData = _prepareApiData(
                    reason,
                    selectedCells.toList(),
                    'submit', // Action type
                  );

                  try {
                    // Call the submit API
                    await _submitAttendaceRoster(apiData);

                    // Clear selections and close dialogs
                    setState(() {
                      selectedCells.clear();
                      multiSelectMode = false;
                    });

                    Navigator.pop(context); // Close reason dialog
                  } catch (e) {
                    log('Error submitting attendance: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to update attendance'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: customcolor.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                child: Text(
                  "Submit",
                  style: TextStyle(
                    fontFamily: AppFonts.semibold,
                    color: Colors.white,
                  ),
                ),
              ),

            if (showAcceptRemarkButtons) ...[
              // Accept Button
              ElevatedButton(
                onPressed: () async {
                  final reason = reasonController.text.trim();

                  final apiData = _prepareApiData(
                    reason,
                    selectedCells.toList(),
                    'approve', // Action type
                  );

                  try {
                    // Call the submit API
                    await _approveAttendaceRoster(apiData);

                    // Clear selections and close dialogs
                    setState(() {
                      selectedCells.clear();
                      multiSelectMode = false;
                    });

                    Navigator.pop(context); // Close reason dialog
                  } catch (e) {
                    log('Error submitting attendance: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to update attendance'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: customcolor.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                child: Text(
                  "Accept",
                  style: TextStyle(
                    fontFamily: AppFonts.semibold,
                    color: Colors.white,
                  ),
                ),
              ),

              // Remark Button
              ElevatedButton(
                onPressed: () async {
                  final reason = reasonController.text.trim();
                  if (reason.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please enter a reason'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  // Prepare API data
                  final apiData = _prepareApiData(
                    reason,
                    selectedCells.toList(),
                    'reject', // Action type
                  );

                  try {
                    // Call the submit API
                    await _rejectAttendaceRoster(apiData);

                    // Clear selections and close dialogs
                    setState(() {
                      selectedCells.clear();
                      multiSelectMode = false;
                    });

                    Navigator.pop(context); // Close reason dialog
                  } catch (e) {
                    log('Error submitting attendance: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to update attendance'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                child: Text(
                  role == GlobalLists.clientrole ? "Reject" : "Remark",
                  style: TextStyle(
                    fontFamily: AppFonts.semibold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ],
        ),
      );
    }

    // Function to handle single tap
    void _handleSingleTap(String key, AttendanceData? day) {
      log('Single tap on key: $key');
      setState(() {
        selectedCells.clear();
        selectedCells.add(key);
      });
      _showReasonDialog(isMultiSelect: false);
    }

    log('multiSelectMode:$multiSelectMode');

    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance Roster'),
        backgroundColor: customcolor.blue,
      ),
      // backgroundColor: Colors.black54,
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
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                        border: Border.all(color: customcolor.greyborder),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Select Year:',
                            style: TextStyle(
                              fontFamily: AppFonts.regular,
                              color: customcolor.subtitle,
                              fontSize: 10,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: DropdownButton<int>(
                              isExpanded: true,
                              underline: const SizedBox(),
                              value: selectedYear,
                              items: availableYears.map((year) {
                                return DropdownMenuItem<int>(
                                  value: year,
                                  child: Text(
                                    year.toString(),
                                    style: TextStyle(
                                      fontFamily: AppFonts.semibold,
                                      color: multiSelectMode
                                          ? Colors.grey
                                          : customcolor.title,
                                      fontSize: 10,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: multiSelectMode
                                  ? null
                                  : (val) {
                                      if (val == null) return;

                                      final int currentYear =
                                          DateTime.now().year;
                                      final int currentMonth =
                                          DateTime.now().month;

                                      setState(() {
                                        selectedYear = val;

                                        monthYears.clear();

                                        int endMonth =
                                            (selectedYear == currentYear)
                                            ? currentMonth
                                            : 12;

                                        for (int i = 1; i <= endMonth; i++) {
                                          monthYears.add(
                                            '${monthNames[i]} $selectedYear',
                                          );
                                        }

                                        selectedMonth =
                                            '${monthNames[1]} $selectedYear';

                                        /// Clear previous selections
                                        selectedCells.clear();
                                        multiSelectMode = false;

                                        _reloadDataForMonthYear(
                                          selectedMonth,
                                          selectedYear,
                                        );
                                      });
                                    },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
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
                              fontSize: 10,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              underline: const SizedBox(),
                              value: monthNames[selectedMonthIndex],
                              items: monthNames.sublist(1).map((monthName) {
                                // Show all months
                                return DropdownMenuItem<String>(
                                  value: monthName,
                                  child: Text(
                                    monthName,
                                    style: TextStyle(
                                      fontFamily: AppFonts.semibold,
                                      color: multiSelectMode
                                          ? Colors.grey
                                          : customcolor.title,
                                      fontSize: 10,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: multiSelectMode
                                  ? null
                                  : (val) {
                                      if (val == null) return;

                                      final monthIndex = monthNames.indexOf(
                                        val,
                                      );

                                      setState(() {
                                        selectedMonthIndex = monthIndex;
                                        _reloadDataForMonth(monthIndex);
                                      });
                                    },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              /// Shift Dropdown - Disabled when multiSelectMode is true
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
                                  color: multiSelectMode
                                      ? Colors.grey
                                      : customcolor.title,
                                  fontSize: 15,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: multiSelectMode
                              ? null
                              : (val) {
                                  setState(() {
                                    selectedShift = val;
                                    selectedCells.clear();
                                    multiSelectMode = false;
                                  });
                                },
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 16),

             multiSelectMode?
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: !_allSelectedHaveSameStatus()
                        ? Colors.orange.withOpacity(0.1)
                        : customcolor.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: !_allSelectedHaveSameStatus()
                          ? Colors.orange
                          : customcolor.blue,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Entries Selected: ${selectedCells.length}",
                            style: TextStyle(
                              fontFamily: AppFonts.semibold,
                              color: !_allSelectedHaveSameStatus()
                                  ? Colors.orange
                                  : customcolor.blue,
                            ),
                          ),
                          if (!_allSelectedHaveSameStatus())
                            Text(
                              "Mixed statuses selected - please select only one type",
                              style: TextStyle(
                                fontFamily: AppFonts.regular,
                                fontSize: 12,
                                color: Colors.orange,
                              ),
                            ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.close, size: 20),
                            color: !_allSelectedHaveSameStatus()
                                ? Colors.orange
                                : customcolor.blue,
                            onPressed: () {
                              setState(() {
                                selectedCells.clear();
                                multiSelectMode = false;
                              });
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.done, size: 20),
                            color: !_allSelectedHaveSameStatus()
                                ? Colors.orange
                                : customcolor.blue,
                            onPressed: () {
                              if (selectedCells.isNotEmpty &&
                                  _allSelectedHaveSameStatus()) {
                                _showReasonDialog(isMultiSelect: true);
                              } else if (selectedCells.isNotEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Cannot submit mixed attendance statuses',
                                    ),
                                    backgroundColor: Colors.orange,
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ):SizedBox(),

              selectedShift.employeeList.isEmpty
                  ? Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 200),
                          Text(
                            "No janitor assigned",
                            style: TextStyle(
                              fontFamily: AppFonts.regular,
                              fontSize: 14,
                              color: Colors.grey,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Expanded(
                      child: SingleChildScrollView(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 120,
                                  height: 45,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: 12,
                                  ),
                                  color: customcolor.skybluebg,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Janitor's Name",
                                        style: TextStyle(
                                          fontFamily: AppFonts.semibold,
                                          color: customcolor.blue,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                ...(selectedShift?.employeeList ?? []).map(
                                  (emp) => SizedBox(
                                    height: 45,
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
                                // Fixed: "No janitor assigned" centered properly
                                if (selectedShift.employeeList.isEmpty)
                                  Container(
                                    width: 120,
                                    height: 45,
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
                                    child: Center(
                                      child: Text(
                                        "No janitor assigned",
                                        style: TextStyle(
                                          fontFamily: AppFonts.regular,
                                          fontSize: 12,
                                          color: Colors.grey,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                key: _horizontalScrollKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (sortedDates.isNotEmpty)
                                      Row(
                                        children: sortedDates
                                            .map(
                                              (date) => Container(
                                                height: 45,
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
                                          AttendanceData? day;

                                          try {
                                            day = emp.attendData.firstWhere(
                                              (d) => d.date == date,
                                            );
                                          } catch (e) {
                                            day = null;
                                          }

                                          final key =
                                              '${emp.empName},$date,${day?.attendanceStatus ?? ''}';
                                          final selected = selectedCells
                                              .contains(key);
                                          final isFuture = DateTime.parse(
                                            date,
                                          ).isAfter(DateTime.now());

                                          // Determine if cell can be edited based on role
                                          bool canEdit = false;

                                          // Only for client role
                                          if (role == GlobalLists.clientrole) {
                                            // Check all conditions for client role
                                            canEdit =
                                                !isFuture &&
                                                selectedShift
                                                        ?.is_final_submitted ==
                                                    false &&
                                                day?.act_deact_janitor ==
                                                    true &&
                                                day?.attendanceStatus != '-' &&
                                                (day?.client_approval_status ==
                                                        null ||
                                                    day!.client_approval_status ==
                                                        '') &&
                                                (day?.reason == null ||
                                                    day?.reason == '');
                                          } else {
                                            // For non-client roles, canEdit remains false
                                            canEdit = false;
                                          }

                                          final currentStatus =
                                              day?.attendanceStatus ?? '';

                                          Color circleColor() {
                                            if (day?.act_deact_janitor ==
                                                false) {
                                              return Colors.grey[300]!;
                                            }
                                            // Client approval status takes precedence
                                            if (day?.client_approval_status !=
                                                    null &&
                                                day!
                                                    .client_approval_status!
                                                    .isNotEmpty) {
                                              return day.client_approval_status ==
                                                      'approved'
                                                  ? Colors.green
                                                  : Colors.green;
                                            }

                                            // OM/OE approval status (only if no client approval)
                                            if (day?.om_oe_approval_status !=
                                                    null &&
                                                day!
                                                    .om_oe_approval_status!
                                                    .isNotEmpty) {
                                              return day.om_oe_approval_status ==
                                                      'approved'
                                                  ? Colors.green
                                                  : customcolor.red;
                                            }

                                            if (day?.reason != null &&
                                                day!.reason!.isNotEmpty) {
                                              return customcolor.pink;
                                            }

                                            if (day == null)
                                              return customcolor.greybg;

                                            if (day.attendanceStatus == 'yes') {
                                              return customcolor.lightgreen;
                                            }

                                            if (day.attendanceStatus == 'no' &&
                                                !isFuture) {
                                              return customcolor.lightgreen;
                                            }

                                            return Colors.grey[300]!;
                                          }

                                          return GestureDetector(
                                            onLongPress: () {
                                              bool hasClientApproval = false;
                                              if (canEdit) {
                                                if (day!.client_approval_status !=
                                                        null &&
                                                    day
                                                        .client_approval_status!
                                                        .isNotEmpty) {
                                                  hasClientApproval = true;
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        'Cannot modify attendance that already has client approval',
                                                      ),
                                                      backgroundColor:
                                                          Colors.red,
                                                    ),
                                                  );
                                                  return;
                                                }
                                                // If multiSelectMode is off, start it with this cell
                                                if (!multiSelectMode) {
                                                  setState(() {
                                                    multiSelectMode = true;
                                                    selectedCells.clear();
                                                    selectedCells.add(key);
                                                  });

                                                  log('multiSelectMode started with key: $multiSelectMode');
                                                } else {
                                                  // If already in multiSelectMode, check if we can add this cell
                                                  final selectedStatus =
                                                      _getCurrentSelectedStatus();

                                                  if (selectedStatus == null ||
                                                      selectedStatus ==
                                                          currentStatus ||
                                                      selectedCells.isEmpty) {
                                                    setState(() {
                                                      selected
                                                          ? selectedCells
                                                                .remove(key)
                                                          : selectedCells.add(
                                                              key,
                                                            );
                                                    });
                                                  } else {
                                                    // Show warning that you can't mix different statuses
                                                    ScaffoldMessenger.of(
                                                      context,
                                                    ).showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                          'Cannot mix different attendance statuses in multi-select',
                                                        ),
                                                        backgroundColor:
                                                            Colors.orange,
                                                      ),
                                                    );
                                                  }
                                                }
                                              }
                                            },
                                            onTap: () {
                                              print(
                                                'day.attendanceStatus: ${day?.attendanceStatus}${canEdit}',
                                              );
                                              if (!canEdit) return;
                                             setState(() {
                                                multiSelectMode = true;
                                             });
                                            
                                           log('multiSelectMode started with key: $multiSelectMode');


                                              bool hasClientApproval = false;

                                              if (day!.client_approval_status !=
                                                      null &&
                                                  day
                                                      .client_approval_status!
                                                      .isNotEmpty) {
                                                hasClientApproval = true;
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      'Cannot modify attendance that already has client approval',
                                                    ),
                                                    backgroundColor: Colors.red,
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                    margin:
                                                        const EdgeInsets.only(
                                                          left: 16,
                                                          right: 16,
                                                          bottom: 30,
                                                        ),
                                                  ),
                                                );

                                                return;
                                              }

                                              if (multiSelectMode) {
                                                if (day.client_approval_status !=
                                                        null &&
                                                    day
                                                        .client_approval_status!
                                                        .isNotEmpty) {
                                                  hasClientApproval = true;
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        'Cannot modify attendance that already has client approval',
                                                      ),
                                                      backgroundColor:
                                                          Colors.red,
                                                    ),
                                                  );
                                                  return;
                                                }
                                                final selectedStatus =
                                                    _getCurrentSelectedStatus();

                                                // Check if we can select/deselect this cell
                                                if (selectedStatus == null ||
                                                    selectedStatus ==
                                                        currentStatus ||
                                                    selectedCells.isEmpty) {
                                                  setState(() {
                                                    selected
                                                        ? selectedCells.remove(
                                                            key,
                                                          )
                                                        : selectedCells.add(
                                                            key,
                                                          );
                                                  });
                                                } else {
                                                  // Show warning
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        'Cannot mix different attendance statuses in multi-select',
                                                      ),
                                                      backgroundColor:
                                                          Colors.orange,
                                                    ),
                                                  );
                                                }
                                              } else {
                                                _handleSingleTap(key, day);
                                              }
                                            },
                                            child: Container(
                                              width: 50,
                                              height: 45,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  bottom: BorderSide(
                                                    color:
                                                        customcolor.greyborder,
                                                  ),
                                                ),
                                              ),
                                              child: Container(
                                                width: 24,
                                                height: 24,
                                                decoration: BoxDecoration(
                                                  color: selected
                                                      ? customcolor.pink
                                                      : circleColor(),
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: selected
                                                        ? customcolor.blue
                                                        : Colors.transparent,
                                                    width: 2,
                                                  ),
                                                ),
                                                alignment: Alignment.center,
                                                child: Stack(
                                                  children: [
                                                    Text(
                                                      isFuture
                                                          ? '-'
                                                          : day == null
                                                          ? '-'
                                                          : (day.attendanceStatus ==
                                                                    '-'
                                                                ? '-'
                                                                : day.attendanceStatus ==
                                                                      'yes'
                                                                ? 'P'
                                                                : day.attendanceStatus ==
                                                                      'no'
                                                                ? 'A'
                                                                : ''),
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontFamily:
                                                            AppFonts.regular,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            selected ||
                                                                day
                                                                        ?.reason
                                                                        ?.isNotEmpty ==
                                                                    true
                                                            ? Colors.white
                                                            : isFuture ||
                                                                  day == null
                                                            ? customcolor
                                                                  .greytext
                                                            : ((day.attendanceStatus ==
                                                                      'yes') &&
                                                                  day.client_approval_status ==
                                                                      null &&
                                                                  day.om_oe_approval_status ==
                                                                      null)
                                                            ? customcolor.green
                                                            : customcolor.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),

                                    if (selectedShift.employeeList.isEmpty &&
                                        sortedDates.isNotEmpty)
                                      Row(
                                        children: sortedDates.map((date) {
                                          return Container(
                                            width: 50,
                                            height: 45,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                  color: customcolor.greyborder,
                                                ),
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "-",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: AppFonts.regular,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

              if (selectedCells.isNotEmpty &&
                  multiSelectMode &&
                  _allSelectedHaveSameStatus())
                SizedBox(height: 10),
              selectedShift?.employeeList.isEmpty ||
                      selectedShift?.employeeList.length == 0
                  ? SizedBox()
                  : Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: ElevatedButton(
                        onPressed: () {
                          log(
                            'check this ${selectedShift?.is_final_submitted},${selectedShift?.is_month_end}',
                          );

                          selectedShift?.is_month_end == 1 &&
                                  selectedShift?.is_final_submitted == false &&
                                  selectedCells.isEmpty &&
                                  !multiSelectMode &&
                                  role == GlobalLists.clientrole &&
                                  selectedShift.review_updated_by_oe_om ==
                                      false &&
                                  selectedShift.review_updated_by_client ==
                                      false
                              ? _submitAttendaceRosterfinal(
                                  selectedShift.id.toString(),
                                )
                              : selectedCells.isNotEmpty && multiSelectMode
                              ? _showReasonDialog(isMultiSelect: true)
                              : Navigator.push(
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
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              selectedShift?.is_month_end == 1 &&
                                  selectedShift?.is_final_submitted == true
                              ? Colors.grey
                              : customcolor.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          minimumSize: Size(double.infinity, 48),
                        ),
                        child: Text(
                          selectedShift?.is_month_end == 1 &&
                                  selectedShift?.is_final_submitted == true
                              ? "View Finalize Roster"
                              : selectedCells.isNotEmpty && multiSelectMode
                              ? "Report Discrepancy"
                              : role == GlobalLists.clientrole &&
                                    selectedShift?.review_updated_by_oe_om ==
                                        false &&
                                    selectedShift.review_updated_by_client ==
                                        false
                              ? "Approve Roster"
                              : role == GlobalLists.clientrole &&
                                    selectedShift?.review_updated_by_oe_om ==
                                        true
                              ? "Review Updates"
                              : "Review Discrepancy",
                          style: TextStyle(
                            fontFamily: AppFonts.semibold,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
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

  _rejectAttendaceRoster(Map<String, dynamic> apiData) async {
    try {
      var status1 = await ConnectionDetector.checkInternetConnection();
      if (!status1) {
        ShowDialogs.showToast("Please check internet connection");
        return;
      }
      var supervisorid = await SPManager().getsupervisorid();

      // Prepare the map according to API requirements
      var map = {
        'reason': apiData['reason'] ?? '',
        'user_id': GlobalLists.clientrole == role
            ? apiData['user_id'] ?? ''
            : supervisorid,
        // 'is_client':GlobalLists.clientrole == role?true:false,
        'is_client': apiData['is_client'] ?? '',
        'attendance_id_list': jsonEncode(apiData['attendance_id_list'] ?? []),
      };

      log('Rejecting attendance data: $map');

      await APIManager().apiRequest(
        context,
        API.rejected_om_oe_attendance_rooster,
        (response) async {
          RejectAttendanceRooster resp = response;
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
            });
          } else {}
        },
        (error) {
          print('Error rejecting attendance: $error');
          ShowDialogs.showToast('Error: $error');
        },
        false,
        "",
        jsonval: map,
      );
    } catch (e) {
      log('Error rejecting attendance roster: $e');
      ShowDialogs.showToast('Exception: $e');
    }
  }

  _approveAttendaceRoster(Map<String, dynamic> apiData) async {
    try {
      var status1 = await ConnectionDetector.checkInternetConnection();

      var supervisorid = await SPManager().getsupervisorid();

      // Prepare the map according to API requirements
      var map = {
        // 'reason': apiData['reason'] ?? '',
        'user_id': GlobalLists.clientrole == role
            ? apiData['user_id'] ?? ''
            : supervisorid,
        // 'is_client':GlobalLists.clientrole == role?"true":"false",
        'is_client': apiData['is_client'] ?? '',
        'attendance_id_list': jsonEncode(apiData['attendance_id_list'] ?? []),
      };

      log('Approving attendance data: $map');

      await APIManager().apiRequest(
        context,
        API.approved_om_oe_attendance_rooster,
        (response) async {
          ApprovAttendanceRooster resp = response;
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
            });
          } else {}
        },
        (error) {
          print('Error approving attendance: $error');
          ShowDialogs.showToast('Error: $error');
        },
        false,
        "",
        jsonval: map,
      );
    } catch (e) {
      log('Error approving attendance roster: $e');
      ShowDialogs.showToast('Exception: $e');
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
        'shift': apiData['shift'] ?? '',
        'client_id': GlobalLists.clientrole == role
            ? apiData['user_id'] ?? ''
            : supervisorid,
        'user_id': GlobalLists.clientrole == role
            ? apiData['user_id'] ?? ''
            : supervisorid,
        'emp_id': jsonEncode(apiData['emp_id'] ?? []),
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
          } else {}
        },
        (error) {
          log('Error submitting attendance: $error');
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
}
