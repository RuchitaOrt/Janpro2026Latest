/*
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

import '../Utitlity/APIManager.dart';
import '../Utitlity/ShowDialog.dart';
import '../Utitlity/internetConnection.dart';
import '../model/attendance_roster_response.dart';

class AttendanceRosterScreen extends StatefulWidget {
  @override
  _AttendanceRosterScreenState createState() => _AttendanceRosterScreenState();
}

class _AttendanceRosterScreenState extends State<AttendanceRosterScreen> {
  List<ShiftData> _attendanceRosterData = [];
  DateTime _currentMonth = DateTime.now();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchAttendanceRoster();
  }

  Future<void> _fetchAttendanceRoster() async {
    try {
      var status1 = await ConnectionDetector.checkInternetConnection();
      if (!status1) {
        ShowDialogs.showToast("Please check internet connection");
        return;
      }

      final firstDay = DateTime(_currentMonth.year, _currentMonth.month, 1);
      final lastDay = DateTime(_currentMonth.year, _currentMonth.month + 1, 0);

      var map = {
        'site_id': '67',
        'from_date': DateFormat('yyyy-MM-dd').format(firstDay),
        'to_date': DateFormat('yyyy-MM-dd').format(lastDay),
      };

      setState(() => _isLoading = true);

      APIManager().apiRequest(
        context,
        API.attendance_roster,
            (response) async {
          setState(() => _isLoading = false);

          try {
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
            } else {
              ShowDialogs.showToast(rosterResponse.msg);
            }
          } catch (e) {
            ShowDialogs.showToast('Error processing data: ${e.toString()}');
          }
        },
            (error) {
          setState(() => _isLoading = false);
          ShowDialogs.showToast('Error: ${error.toString()}');
        },
        false,
        "",
        jsonval: map,
      );
    } catch (e) {
      setState(() => _isLoading = false);
      ShowDialogs.showToast('An error occurred');
    }
  }

  String getMonthYear(String date) {
    final parts = date.split('-'); // yyyy-MM-dd
    final month = int.parse(parts[1]);
    final year = parts[0];
    const monthNames = [
      '',
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${monthNames[month]} $year';
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, List<ShiftData>> groupedByMonth = {};

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

    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance Roster'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _attendanceRosterData.isEmpty
          ? Center(child: Text('No data available'))
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: groupedByMonth.entries.map<Widget>((entry) {
            final month = entry.key;
            final shifts = entry.value;

            final allDates = <String>{};
            for (var shift in shifts) {
              for (var emp in shift.employeeList) {
                for (var att in emp.attendData) {
                  if (getMonthYear(att.date) == month) {
                    allDates.add(att.date);
                  }
                }
              }
            }

            final sortedDates = allDates.toList()..sort();

            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    month,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey),
                  ),
                  const SizedBox(height: 6),
                  ...shifts.map<Widget>((shift) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${shift.shiftName} (${shift.shiftStartTime}-${shift.shiftEndTime})',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                        Text(
                          'Supervisor: ${shift.supervisor}',
                          style: TextStyle(fontSize: 13),
                        ),
                        const SizedBox(height: 6),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const SizedBox(width: 100),
                                  ...sortedDates.map((date) {
                                    final formattedDate =
                                        '${date.split('-')[2]}/${date.split('-')[1]}';
                                    return Container(
                                      width: 50,
                                      alignment: Alignment.center,
                                      margin:
                                      const EdgeInsets.symmetric(
                                          horizontal: 4),
                                      child: Text(
                                        formattedDate,
                                        style: TextStyle(
                                            fontWeight:
                                            FontWeight.bold,
                                            fontSize: 13),
                                      ),
                                    );
                                  }).toList(),
                                ],
                              ),
                              const SizedBox(height: 6),
                              ...shift.employeeList.map((emp) {
                                return Row(
                                  children: [
                                    Container(
                                      width: 100,
                                      padding:
                                      const EdgeInsets.symmetric(
                                          vertical: 6),
                                      child: Text(
                                        emp.empName,
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight:
                                            FontWeight.w500),
                                      ),
                                    ),
                                    ...sortedDates.map((date) {
                                      final day = emp.attendData.firstWhere(
                                            (d) => d.date == date,
                                        orElse: () => AttendanceData(
                                          date: date,
                                          attendanceStatus: 'absent', // or some default you define
                                        ),
                                      );


                                      return Container(
                                        width: 50,
                                        alignment: Alignment.center,
                                        margin: const EdgeInsets
                                            .symmetric(horizontal: 4),
                                        child: Text(
                                          day != null
                                              ? (day.attendanceStatus ==
                                              'yes'
                                              ? '✓'
                                              : 'A')
                                              : '-',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight:
                                            FontWeight.bold,
                                            color: day == null
                                                ? Colors.grey
                                                : (day.attendanceStatus ==
                                                'yes'
                                                ? Colors.green
                                                : Colors.red),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ],
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    );
                  }).toList(),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/attendance_roster_response.dart';

class AttendanceRosterScreen extends StatefulWidget {
  final String selectedSite;
  final String selectedShift;

  const AttendanceRosterScreen({
    required this.selectedSite,
    required this.selectedShift,
    super.key,
  });

  @override
  State<AttendanceRosterScreen> createState() => _AttendanceRosterScreenState();
}

class _AttendanceRosterScreenState extends State<AttendanceRosterScreen> {
  late String selectedSite;
  late String selectedShift;
  String selectedMonth = DateFormat('MMMM').format(DateTime.now());
  int selectedYear = DateTime.now().year;

  final List<String> months = List.generate(12, (i) => DateFormat('MMMM').format(DateTime(0, i + 1)));
  final List<int> years = List.generate(5, (i) => DateTime.now().year - 2 + i);

  AttendanceRosterResponse? rosterResponse;

  @override
  void initState() {
    super.initState();
    selectedSite = widget.selectedSite;
    selectedShift = widget.selectedShift;
    fetchRosterData();
  }

  void fetchRosterData() async {
    // TODO: Call your API and parse to AttendanceRosterResponse
    setState(() {
      // rosterResponse = fetchedData;
    });
  }

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateUtils.getDaysInMonth(selectedYear, months.indexOf(selectedMonth) + 1);

    return Scaffold(
      appBar: AppBar(title: const Text('Attendance Roster')),
      body: Column(
        children: [
          buildHeaderFilters(),
          const Divider(),
          if (rosterResponse != null)
            Expanded(child: buildAttendanceTable(daysInMonth))
          else
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  Widget buildHeaderFilters() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(child: DropdownButtonFormField<String>(
            value: selectedSite,
            onChanged: (val) => setState(() => selectedSite = val!),
            items: ['Site A', 'Site B'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            decoration: const InputDecoration(labelText: 'Site'),
          )),
          const SizedBox(width: 10),
          Expanded(child: DropdownButtonFormField<String>(
            value: selectedShift,
            onChanged: (val) => setState(() => selectedShift = val!),
            items: ['Shift 1', 'Shift 2'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            decoration: const InputDecoration(labelText: 'Shift'),
          )),
          const SizedBox(width: 10),
          Expanded(child: DropdownButtonFormField<String>(
            value: selectedMonth,
            onChanged: (val) => setState(() => selectedMonth = val!),
            items: months.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            decoration: const InputDecoration(labelText: 'Month'),
          )),
          const SizedBox(width: 10),
          Expanded(child: DropdownButtonFormField<int>(
            value: selectedYear,
            onChanged: (val) => setState(() => selectedYear = val!),
            items: years.map((e) => DropdownMenuItem(value: e, child: Text(e.toString()))).toList(),
            decoration: const InputDecoration(labelText: 'Year'),
          )),
        ],
      ),
    );
  }

  Widget buildAttendanceTable(int totalDays) {
    final shift = rosterResponse!.data.firstWhere((s) => s.shiftName == selectedShift);
    final employees = shift.employeeList;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        children: [
          Row(
            children: [
              Container(width: 120, alignment: Alignment.center, child: const Text('Employee')),
              ...List.generate(totalDays, (i) {
                final day = i + 1;
                return Container(
                  width: 50,
                  alignment: Alignment.center,
                  child: Text(day.toString()),
                );
              }),
            ],
          ),
          const Divider(),
          ...employees.map((emp) {
            return Row(
              children: [
                Container(width: 120, alignment: Alignment.centerLeft, child: Text(emp.empName)),
                ...List.generate(totalDays, (i) {
                  final day = i + 1;
                  final dateStr = DateFormat('yyyy-MM-dd').format(DateTime(selectedYear, months.indexOf(selectedMonth) + 1, day));
                  final status = emp.attendData.firstWhere(
                        (d) => d.date == dateStr,
                    orElse: () => AttendanceData(date: dateStr, attendanceStatus: ''),
                  ).attendanceStatus;

                  return Container(
                    width: 50,
                    alignment: Alignment.center,
                    child: Text(status),
                  );
                }),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }
}
