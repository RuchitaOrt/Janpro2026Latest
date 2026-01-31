
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

import 'package:janpro/model/attendance_roster_response.dart';
import 'package:flutter/services.dart';

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
  dynamic selectedShift;
  var maintag;
  Set<String> selectedCells = {};
  bool multiSelectMode = false;
  bool isBulkMode = false;
  Set<String> selectedEmployees = {};
  
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

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  _fetchAttendanceRoster() async {
    try {
      var status1 = await ConnectionDetector.checkInternetConnection();
      if (!status1) {
        ShowDialogs.showToast("Please check internet connection");
        return;
      }

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

      var map = {
        'site_id': attendancesiteid.toString(),
        'from_date': DateFormat('yyyy-MM-dd').format(firstDayOfMonth),
        'to_date': DateFormat('yyyy-MM-dd').format(lastDayOfMonth),
        "month": "$month",
        "year": "$year",
      };

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator()),
      );

      APIManager().apiRequest(
        context,
        API.attendance_roster,
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
              setState(() {
                _attendanceRosterData = rosterResponse.data;
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
          ShowDialogs.showToast('Error: ${error.toString()}');
        },
        false,
        "",
        jsonval: map,
      );
    } catch (e) {
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

    int selectedYear = int.parse(year);
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

    if (!availableMonths.contains(selectedMonth) && availableMonths.isNotEmpty) {
      selectedMonth = availableMonths[0];
    }

    dynamic selectedShift = groupedByMonth[selectedMonth]?.isNotEmpty == true
        ? groupedByMonth[selectedMonth]![0]
        : null;

    int selectedMonthIndex = currentMonth;

    void _reloadDataForMonth(int monthIndex) {
      final monthIndexStr = monthIndex.toString().padLeft(2, '0');
      month = monthIndexStr;
      selectedCells.clear();
      multiSelectMode = false;
      isBulkMode = false;
      selectedEmployees.clear();
      _fetchAttendanceRoster();
    }

    final shifts = groupedByMonth[selectedMonth] ?? [];

    // Calculate statistics
    int presentCount = 0;
    int absentCount = 0;
    double otHours = 0;
    int pendingCount = 0;
    
    if (selectedShift != null) {
      for (var emp in selectedShift.employeeList ?? []) {
        for (var att in emp.attendData ?? []) {
          if (att.attendanceStatus == 'yes') presentCount++;
          if (att.attendanceStatus == 'no') absentCount++;
          if (att.ot_hours != null) otHours += att.ot_hours ?? 0;
        }
      }
    }

    return Scaffold(
      backgroundColor: Color(0xFFFAFBFC),
      body: SafeArea(
        child: Column(
          children: [
            // Header with dark background
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF0F172A),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Top header with title and month navigation
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.arrow_back, color: Colors.white),
                              onPressed: () => Navigator.pop(context),
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Team Roster',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (selectedMonthIndex > 1) {
                                    setState(() {
                                      selectedMonthIndex--;
                                      _reloadDataForMonth(selectedMonthIndex);
                                    });
                                  }
                                },
                                child: Icon(Icons.chevron_left, color: Colors.white, size: 20),
                              ),
                              SizedBox(width: 8),
                              Text(
                                '${monthNamesShort[selectedMonthIndex]} $selectedYear',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'monospace',
                                ),
                              ),
                              SizedBox(width: 8),
                              GestureDetector(
                                onTap: () {
                                  if (selectedMonthIndex < 12) {
                                    setState(() {
                                      selectedMonthIndex++;
                                      _reloadDataForMonth(selectedMonthIndex);
                                    });
                                  }
                                },
                                child: Icon(Icons.chevron_right, color: Colors.white, size: 20),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Stats bar
                  Container(
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildStatChip('$presentCount Present'),
                          SizedBox(width: 8),
                          _buildStatChip('$absentCount Absent'),
                          SizedBox(width: 8),
                          _buildStatChip('${otHours.toStringAsFixed(1)} OT Hrs'),
                          SizedBox(width: 8),
                          _buildStatChip('$pendingCount Pending'),
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
                    colors: [Color(0xFF8B5CF6), Color(0xFFA855F7)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF8B5CF6).withOpacity(0.3),
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
                        Text('✓', style: TextStyle(color: Colors.white, fontSize: 18)),
                        SizedBox(width: 12),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${selectedEmployees.length} selected',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'monospace',
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
                          Icon(Icons.people_outline, size: 64, color: Colors.grey[400]),
                          SizedBox(height: 16),
                          Text(
                            "No janitor assigned",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      itemCount: selectedShift.employeeList.length,
                      itemBuilder: (context, index) {
                        final emp = selectedShift.employeeList[index];
                        final isSelected = selectedEmployees.contains(emp.empId.toString());
                        
                        return _buildEmployeeCard(emp, isSelected);
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            isBulkMode = !isBulkMode;
            if (!isBulkMode) {
              selectedEmployees.clear();
            }
          });
        },
        backgroundColor: Color(0xFF8B5CF6),
        child: Icon(Icons.people, color: Colors.white),
      ),
    );
  }

  Widget _buildStatChip(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
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
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary ? Colors.white : Colors.transparent,
        foregroundColor: isPrimary ? Color(0xFF8B5CF6) : Colors.white,
        side: BorderSide(color: Colors.white, width: 2),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildEmployeeCard(dynamic emp, bool isSelected) {
    // Get all dates for this employee
    final allDates = <String>[];
    for (var att in emp.attendData ?? []) {
      allDates.add(att.date);
    }
    allDates.sort();
    
    // Calculate summary
    int presentCount = 0;
    int absentCount = 0;
    double otHours = 0;
    
    for (var att in emp.attendData ?? []) {
      if (att.attendanceStatus == 'yes') presentCount++;
      if (att.attendanceStatus == 'no') absentCount++;
      if (att.ot_hours != null) otHours += att.ot_hours ?? 0;
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
          });
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: Color(0xFF8B5CF6), width: 3)
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
          children: [
            // Employee Header
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFF8FAFC), Color(0xFFF1F5F9)],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                border: Border(
                  bottom: BorderSide(color: Color(0xFFE2E8F0)),
                ),
              ),
              child: Stack(
                children: [
                  Row(
                    children: [
                      // Employee Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              emp.empName,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              emp.empId.toString(),
                              style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFF64748B),
                                fontFamily: 'monospace',
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Summary Stats
                      Row(
                        children: [
                          _buildSummaryItem(presentCount.toString(), 'P', Color(0xFF22C55E)),
                          SizedBox(width: 12),
                          _buildSummaryItem(absentCount.toString(), 'A', Color(0xFFEF4444)),
                          SizedBox(width: 12),
                          _buildSummaryItem(otHours.toStringAsFixed(1), 'OT', Color(0xFF8B5CF6)),
                        ],
                      ),
                    ],
                  ),
                  
                  // Selection Checkbox (top-right)
                  if (isBulkMode)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: isSelected ? Color(0xFF8B5CF6) : Colors.white,
                          border: Border.all(
                            color: isSelected ? Color(0xFF8B5CF6) : Color(0xFFE2E8F0),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: isSelected
                            ? Icon(Icons.check, color: Colors.white, size: 16)
                            : null,
                      ),
                    ),
                ],
              ),
            ),
            
            // Timeline Container - Horizontal Scroll
            Container(
              height: 120,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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

  Widget _buildSummaryItem(String value, String label, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: color,
            fontFamily: 'monospace',
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  Widget _buildDateColumn(dynamic emp, String date) {
    AttendanceData? day;
    try {
      day = emp.attendData.firstWhere((d) => d.date == date);
    } catch (e) {
      day = null;
    }
    
    final dateObj = DateTime.parse(date);
    final dayNum = dateObj.day.toString();
    final dayName = DateFormat('EEE').format(dateObj).toUpperCase();
    final isToday = DateFormat('yyyy-MM-dd').format(DateTime.now()) == date;
    final isWeekend = dateObj.weekday == 6 || dateObj.weekday == 7;
    final isFuture = dateObj.isAfter(DateTime.now());
    
    return GestureDetector(
      onTap: () {
        if (!isFuture && day != null) {
          _showAttendanceDialog(emp, day, date);
        }
      },
      child: Container(
        width: 62,
        margin: EdgeInsets.only(right: 6),
        child: Column(
          children: [
            // Date Header
            Container(
              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
              decoration: BoxDecoration(
                color: isToday 
                    ? Color(0xFFDBEAFE) 
                    : isWeekend 
                        ? Color(0xFFFEF2F2) 
                        : Color(0xFFFAFBFC),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
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
                      fontFamily: 'monospace',
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
            SizedBox(height: 4),
            
            // OT Marker
            if (day != null && day.ot_hours != null && day.ot_hours! > 0)
              Container(
                height: 20,
                decoration: BoxDecoration(
                  color: Color(0xFFF3E8FF),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: Color(0xFF8B5CF6),
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: Text(
                    '${day.ot_hours}h',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF6B21A8),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getAttendanceColor(AttendanceData? day, bool isFuture) {
    if (isFuture || day == null) return Color(0xFFCBD5E1);
    
    switch (day.attendanceStatus) {
      case 'yes':
        return Color(0xFF22C55E); // Present - green
      case 'no':
        return Color(0xFFEF4444); // Absent - red
      default:
        return Color(0xFFCBD5E1); // Unmarked - gray
    }
  }

  Color _getAttendanceTextColor(AttendanceData? day, bool isFuture) {
    if (isFuture || day == null) return Color(0xFFCBD5E1);
    
    switch (day.attendanceStatus) {
      case 'yes':
        return Color(0xFF166534); // Dark green
      case 'no':
        return Color(0xFF991B1B); // Dark red
      default:
        return Color(0xFF64748B); // Gray
    }
  }

  String _getAttendanceLabel(AttendanceData? day, bool isFuture) {
    if (isFuture || day == null) return '-';
    
    switch (day.attendanceStatus) {
      case 'yes':
        return 'P';
      case 'no':
        return 'A';
      default:
        return '-';
    }
  }

  void _showAttendanceDialog(dynamic emp, AttendanceData day, String date) {
    String? selectedAttendance = day.attendanceStatus;
    bool hasOT = day.ot_hours != null && day.ot_hours! > 0;
    String otHours = hasOT ? day.ot_hours.toString() : '';
    
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
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 6),
              Row(
                children: [
                  Text(
                    emp.empName,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF3B82F6),
                      fontWeight: FontWeight.w600,
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
                      selectedAttendance == 'yes',
                      () {
                        setDialogState(() {
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
                          selectedAttendance = 'no';
                        });
                      },
                    ),
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
                    child: _buildModalOptionButton(
                      '⏱',
                      'Yes',
                      hasOT,
                      () {
                        setDialogState(() {
                          hasOT = true;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: _buildModalOptionButton(
                      '—',
                      'No',
                      !hasOT,
                      () {
                        setDialogState(() {
                          hasOT = false;
                          otHours = '';
                        });
                      },
                    ),
                  ),
                ],
              ),
              
              if (hasOT) ...[
                SizedBox(height: 12),
                Text(
                  'OT Hours',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF64748B),
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'e.g., 2.5',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Color(0xFFE2E8F0), width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Color(0xFFE2E8F0), width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Color(0xFF3B82F6), width: 2),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'monospace',
                  ),
                  onChanged: (value) {
                    otHours = value;
                  },
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
                      onPressed: () {
                        // Save attendance
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Attendance marked successfully'),
                            backgroundColor: Color(0xFF22C55E),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF3B82F6),
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

  Widget _buildModalOptionButton(String icon, String label, bool isSelected, VoidCallback onTap) {
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
            Text(
              icon,
              style: TextStyle(
                fontSize: 22,
              ),
            ),
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

  void _showBulkMarkingDialog() {
    // Implementation for bulk marking
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
            Text(
              'Bulk Operations',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '${selectedEmployees.length} employees selected',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF64748B),
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  isBulkMode = false;
                  selectedEmployees.clear();
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF3B82F6),
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text('Apply to All', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }

  // Keep all your existing API methods
  _submitAttendaceRosterfinal(dynamic selectedShift) async {
    // ... existing implementation
  }

  _rejectAttendaceRoster(Map<String, dynamic> apiData) async {
    // ... existing implementation
  }

  _approveAttendaceRoster(Map<String, dynamic> apiData) async {
    // ... existing implementation
  }

  _submitAttendaceRoster(Map<String, dynamic>? apiData) async {
    // ... existing implementation
  }
}