// ignore_for_file: prefer_typing_uninitialized_variables, must_be_immutable, deprecated_member_use, unused_element, strict_top_level_inference, curly_braces_in_flow_control_structures

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:janpro/Screens/Attendance.dart';

import 'package:janpro/Utitlity/APIManager.dart';
import 'package:janpro/Utitlity/AppDrawer.dart';
import 'package:janpro/Utitlity/GlobalLists.dart';
import 'package:janpro/Utitlity/ResponsiveFlutter.dart';
import 'package:janpro/Utitlity/SPManager.dart';
import 'package:janpro/Utitlity/ShowDialog.dart';
import 'package:janpro/Utitlity/appbar.dart';
import 'package:janpro/Utitlity/custom_color.dart';
import 'package:janpro/Utitlity/internetConnection.dart';

import 'package:janpro/model/ApproveRejectSubmit.dart';
import 'package:janpro/model/ViewAttendaceMonthly.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import 'view_attenance_roster_new.dart';

class ViewRemarkAttendance extends StatefulWidget {
  var month;
  var year;
  var attendancesiteid;
  var clientid;
  var userid;
  var manTag;
  var shiftId;

  ViewRemarkAttendance({
    super.key,
    required this.month,
    required this.year,
    required this.attendancesiteid,
    this.clientid,
    this.userid,
    this.manTag,
    required this.shiftId,
  });

  @override
  State<ViewRemarkAttendance> createState() => _ViewRemarkAttendanceState();
}

class _ViewRemarkAttendanceState extends State<ViewRemarkAttendance> {
  ViewAttendaceMonthly? attendanceData;
  String? role = "1";

  /// recordId -> user's current selection (approve/reject)
  Map<int, String> approvalSelection = {};

  /// track records that are already rejected from API (client or OM/OE)
  Set<int> alreadyRejectedFromApi = {};

  /// universal reject reason (asked once on submit)
  String? universalRejectReason;

  /// Check if all records have client approval status
  bool get _allClientApproved {
    if (attendanceData == null || attendanceData!.data.isEmpty) return false;

    int totalRecords = 0;
    int clientApprovedRecords = 0;

    for (var d in attendanceData!.data) {
      for (var r in d.records) {
        totalRecords++;
        if (r.clientApprovalStatus != null &&
            r.clientApprovalStatus!.isNotEmpty) {
          clientApprovedRecords++;
        }
      }
    }

    return totalRecords > 0 && clientApprovedRecords == totalRecords;
  }

  /// Check if OM/OE approval is pending for any record
  bool get _hasPendingOmOeApproval {
    if (attendanceData == null) return false;

    for (var d in attendanceData!.data) {
      for (var r in d.records) {
        if (r.omOeApprovalStatus == null || r.omOeApprovalStatus!.isEmpty) {
          return true;
        }
      }
    }
    return false;
  }

  /// Check if a specific record has OM/OE approval pending
  bool _isOmOeApprovalPending(Record record) {
    return record.omOeApprovalStatus == null ||
        record.omOeApprovalStatus!.isEmpty;
  }

  /// Check if OM/OE approval is completed for all records
  bool get _isOmOeApprovalCompleted {
    if (attendanceData == null) return false;

    for (var d in attendanceData!.data) {
      for (var r in d.records) {
        //  print(r.id);
        //    print(r.omOeApprovalStatus);
        if (r.omOeApprovalStatus == null || r.omOeApprovalStatus!.isEmpty) {
          print("in if");
          print(r.id);
           print(r.omOeApprovalStatus);
          return false;
        }
      }
    }
    return true;
  }

  /// Check if client can take action on any record
  bool get _canClientTakeAction {
    if (GlobalLists.clientrole != role)
      return true; // Not a client, allow action

    return !_hasPendingOmOeApproval;
  }

  /// Check if client can take action on specific record
  bool _canClientTakeActionOnRecord(Record record) {
    if (GlobalLists.clientrole != role)
      return true; // Not a client, allow action

    return !_isOmOeApprovalPending(record);
  }

  /// Check if OM/OE user should be in read-only mode
  bool get _isOmOeReadOnly {
    print("_isOmOeReadOnly");
     print(_isOmOeApprovalCompleted);
    // If user is not a client and OM/OE approval is completed
    return GlobalLists.clientrole != role && _isOmOeApprovalCompleted;
  }
  //  bool get _isSupervisorReadOnly {
  //    print("_isSupervisorReadOnly");
  //   print(_isOmOeApprovalCompleted);
  //   // If user is not a client and OM/OE approval is completed
  //  return GlobalLists.supervisorrole == role  && _isOmOeApprovalCompleted;
  // }

  /// Initialize API rejection status
  void _initializeApiRejectionStatus() {
    alreadyRejectedFromApi.clear();

    if (attendanceData == null) return;

    for (var d in attendanceData!.data) {
      for (var r in d.records) {
        // Check if record is already rejected by client
        if (r.clientApprovalStatus == "rejected") {
          alreadyRejectedFromApi.add(r.id);
        }
        // Check if record is already rejected by OM/OE
        else if (r.omOeApprovalStatus == "rejected") {
          alreadyRejectedFromApi.add(r.id);
        }
      }
    }
  }
  final GlobalKey<ScaffoldState> _scaffoldKeyview = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    log('role == GlobalLists.clientrole ${role == GlobalLists.clientrole}');
    _fetchAttendanceRoster();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKeyview,

        endDrawer: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: customcolor.blue,
            primaryColor: customcolor.blue,
          ),
          child: AppDrawerfilter(role),
        ),
        backgroundColor: customcolor.greybg,
         appBar: PreferredSize(
          preferredSize: Size.fromHeight(148),
          child: AppbarComman(
            setStyleStr: 'View Remark Attendance',
            onPressedBack: () {},
            onPressedNotify: () {},
            onPressedSearch: () {},
            onPressedSort: () {},
            onPressedmenu: () {
              _scaffoldKeyview.currentState!.openEndDrawer();
            },
          ),
        ),

   
      body: attendanceData?.data.length == 0 || attendanceData == null
          ? const Center(child: Text("No Record Found"))
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: CustomRefreshIndicator(
                onRefresh: () async {
                  _fetchAttendanceRoster();
                },

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
                child: Column(
                  children: [
                    _topBulkAction(),
                    Expanded(child: _attendanceList()),
                    _submitButton(),
                  ],
                ),
              ),
            ),
    );
  }

  /// ---------------- TOP APPROVE / REJECT ALL ----------------

  Widget _topBulkAction() {
    return attendanceData?.data.length == 0
        ? SizedBox()
        : Column(
            children: [
              // Header Card with Discrepancy Count
              Material(
                elevation: 2,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Discrepancy Text
                      Flexible(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Discrepancies",
                              style: AppFonts.headerStyle(
                                fontSize: ResponsiveFlutter.of(
                                  context,
                                ).fontSize(2.5),
                                color: customcolor.textblue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 55,
                                  child: Text(
                                    'Reason:',
                                    style: AppFonts.headerStyle(
                                      fontSize: 13,
                                      color: customcolor.black,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Builder(
                                    builder: (context) {
                                      final String reasonText = attendanceData!
                                          .data[0]
                                          .reasons
                                          .join(', ');
                                      final bool showReadMore =
                                          reasonText.length > 50;

                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            showReadMore
                                                ? reasonText.substring(0, 50)
                                                : reasonText,
                                            style: AppFonts.headerStyle(
                                              fontSize: 13,
                                              color: customcolor.black,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          if (showReadMore)
                                            InkWell(
                                              onTap: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (_) => AlertDialog(
                                                    title: Text(
                                                      "Full Reason",
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color:
                                                            customcolor.black,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                      ),
                                                    ),
                                                    content: SingleChildScrollView(
                                                      child: Text(
                                                        reasonText,
                                                        style:
                                                            AppFonts.headerStyle(
                                                              fontSize: 13,
                                                              color: customcolor
                                                                  .greypara,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                      ),
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                              context,
                                                            ),
                                                        child: const Text(
                                                          "Close",
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 4,
                                                ),
                                                child: Text(
                                                  "Read more",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: customcolor.blue,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Progress Circle
                      Container(
                        padding: const EdgeInsets.only(left: 8),
                        child: CircularPercentIndicator(
                          animationDuration: 500,
                          lineWidth: 6.0,
                          radius: 40.0,
                          animation: true,
                          percent: attendanceData!.data.isEmpty
                              ? 0
                              : _getApprovalProgress(),
                          center: Text(
                            attendanceData!.data.isEmpty
                                ? "NA"
                                : "${_getApprovalProgressCount()}/${attendanceData!.totalCount}",
                            style: AppFonts.headerStyle(
                              fontSize: attendanceData!.data.isEmpty ? 18 : 24,
                              color: customcolor.textyellow,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          circularStrokeCap: CircularStrokeCap.round,
                          progressColor: customcolor.textblue,
                          backgroundColor: Colors.grey.shade200,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Reasons Card
              attendanceData!.data[0].omOeResson.length == 0
                  ? SizedBox()
                  : Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          Text(
                            "Reasons Summary",
                            style: AppFonts.headerStyle(
                              fontSize: 13,
                              color: customcolor.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),

                          const SizedBox(height: 8),

                          // OM/OE Reasons (if exists)
                          attendanceData?.data[0].omOeResson.isEmpty ?? true
                              ? const SizedBox()
                              : Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 40,
                                          child: Text(
                                            'OPs:',
                                            style: AppFonts.headerStyle(
                                              fontSize: 13,
                                              color: customcolor.black,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Builder(
                                            builder: (context) {
                                              final String opsText =
                                                  attendanceData!
                                                      .data[0]
                                                      .omOeResson
                                                      .join(', ');
                                              final bool showReadMore =
                                                  opsText.length > 50;

                                              return Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    showReadMore
                                                        ? opsText.substring(
                                                            0,
                                                            50,
                                                          )
                                                        : opsText,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 14,
                                                      color:
                                                          Colors.grey.shade800,
                                                    ),
                                                  ),
                                                  if (showReadMore)
                                                    InkWell(
                                                      onTap: () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (_) => AlertDialog(
                                                            title: Text(
                                                              "Full OPs",
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                color:
                                                                    customcolor
                                                                        .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800,
                                                              ),
                                                            ),
                                                            content: SingleChildScrollView(
                                                              child: Text(
                                                                opsText,
                                                                style: AppFonts.headerStyle(
                                                                  fontSize: 13,
                                                                  color: customcolor
                                                                      .greypara,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                ),
                                                              ),
                                                            ),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                      context,
                                                                    ),
                                                                child:
                                                                    const Text(
                                                                      "Close",
                                                                    ),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.only(
                                                              top: 4,
                                                            ),
                                                        child: Text(
                                                          "Read more",
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color: customcolor
                                                                .blue,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 8),
                                  ],
                                ),
                        ],
                      ),
                    ),

              // Bulk Actions Container
              const SizedBox(height: 12),
            ],
          );
  }

  Widget _bulkButton({
    required String label,
    required Color color,
    required VoidCallback onTap,
    bool disabled = false,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: disabled ? Colors.grey.shade300 : color,
        foregroundColor: disabled ? Colors.grey.shade500 : Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 0,
      ),
      onPressed: disabled ? null : onTap,
      child: Text(
        label,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      ),
    );
  }

  bool _isRadioLocked(Record record) {
    bool isClient = GlobalLists.clientrole == role;
    bool isOmOeReadOnly = _isOmOeReadOnly;

    bool isClientFinal = record.clientApprovalStatus != null;
    bool isOmApproved = record.omOeApprovalStatus == "approved";
    bool isOmRejected = record.omOeApprovalStatus == "rejected";

    return isClientFinal ||
        isOmApproved ||
        (!isClient && isOmRejected) ||
        isOmOeReadOnly;
  }

  /// ---------------- LIST ----------------

  Widget _attendanceList() {
    return ListView.builder(
      itemCount: attendanceData!.data.length,
      itemBuilder: (context, index) {
        final datum = attendanceData!.data[index];

        /// FILTER: ONLY SHOW RECORDS WITH REASON
        final filteredRecords = datum.records.where((r) {
          return r.name.isNotEmpty;
        }).toList();

        /// IF NO RECORD HAS REASON → DO NOT SHOW DATE
        if (filteredRecords.isEmpty) return const SizedBox();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _dateHeader(datum.date),
            ...filteredRecords.map(_recordCard).toList(),
          ],
        );
      },
    );
  }

  Widget _dateHeader(DateTime date) {
    return Padding(
      padding: const EdgeInsets.only(right: 8, left: 8, top: 10),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: customcolor.blue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today, size: 16, color: customcolor.blue),
            const SizedBox(width: 8),
            Text(
              DateFormat('dd MMM yyyy').format(date),
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: customcolor.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ---------------- RECORD CARD ----------------

  Widget _recordCard(Record record) {
    bool isClient = GlobalLists.clientrole == role;
    bool isOmOeReadOnly = _isOmOeReadOnly;

    /// CLIENT FINAL DECISION
    bool isClientFinal = record.clientApprovalStatus != null;

    /// OM / OE STATUS
    bool isOmApproved = record.omOeApprovalStatus == "approved";
    bool isOmRejected = record.omOeApprovalStatus == "rejected";
    bool isOmPending = _isOmOeApprovalPending(record);

    bool lockRadio =
        isClientFinal ||
        isOmApproved ||
        (!isClient && isOmRejected) ||
        isOmOeReadOnly;

    /// Check if radio should be disabled for client
    bool radioDisabledForClient = isClient && isOmPending;

    log(
      "Record ${record.id} | isClient:$isClient | "
      "OM:${record.omOeApprovalStatus} | "
      "Client:${record.clientApprovalStatus} | "
      "lock:$lockRadio | radioDisabledForClient:$radioDisabledForClient | "
      "isOmOeReadOnly:$isOmOeReadOnly",
    );

    /// ---------------- PRESELECT VALUE ----------------
    String? selectedValue;

    if (record.clientApprovalStatus != null) {
      selectedValue = record.clientApprovalStatus == "approved"
          ? "approve"
          : "reject";
    } else if (record.omOeApprovalStatus != null) {
      // IMPORTANT: client should NOT be forced by OM/OE decision
      selectedValue = record.omOeApprovalStatus == "approved"
          ? "approve"
          : "reject";
    } else {
      selectedValue = approvalSelection[record.id];
    }

    /// SYNC ONCE (DO NOT OVERRIDE USER SELECTION)
    if (selectedValue != null && approvalSelection[record.id] == null) {
      approvalSelection[record.id] = selectedValue;
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        record.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                Row(
                  children: [
                    Text(
                      "Original Status : ",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      record.previousStatus.toString(),
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      role == GlobalLists.clientrole
                          ? "Your Status :"
                          : "Client Status: ",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      role == GlobalLists.clientrole
                          ? record.client_attendance_type.toString()
                          : record.client_attendance_type.toString(),
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    Text(
                      "OPs Status : ",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      record.omOeApprovalStatus == null
                          ? "Pending"
                          : record.om_oe_attendance_type.toString(),
                          // record.omOeApprovalStatus == 'approved'
                          // ? (record.previousStatus.toString())
                          // : record.omOeApprovalStatus == 'rejected'
                          // ? (record.previousStatus.toString())
                          // : "Pending",
                      style: TextStyle(
                        fontSize: 13,
                        color: _getOmOeStatusColor(record.omOeApprovalStatus),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),

            /// RADIO GROUP
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 100),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      _radio(
                        value: "approve",
                        id: record.id,
                        enabled:
                            !lockRadio &&
                            !_allClientApproved &&
                            !radioDisabledForClient &&
                            !isOmOeReadOnly,
                        isOmPending: isOmPending && isClient,
                      ),
                      Text(
                        "Approve",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _radio(
                        value: "reject",
                        id: record.id,
                        enabled:
                            !lockRadio &&
                            !_allClientApproved &&
                            !radioDisabledForClient &&
                            !isOmOeReadOnly,
                        isOmPending: isOmPending && isClient,
                      ),
                      Text(
                        "Reject",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getOmOeStatusColor(String? status) {
    if (status == null || status.isEmpty) return Colors.orange.shade700;
    if (status.toLowerCase() == "approved") return Colors.green;
    if (status.toLowerCase() == "rejected") return Colors.red;
    return Colors.grey.shade800;
  }

  /// ---------------- RADIO (NO DIALOG HERE) ----------------

  Widget _radio({
    required String value,
    required int id,
    required bool enabled,
    bool isOmPending = false,
  }) {
    return Stack(
      children: [
        Radio<String>(
          value: value,
          groupValue: approvalSelection[id],
          onChanged: enabled
              ? (val) {
                  setState(() {
                    approvalSelection[id] = val!;
                  });
                }
              : null,
          fillColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (!enabled) return Colors.grey.shade400;
            if (approvalSelection[id] == "approve") return Colors.green;
            if (approvalSelection[id] == "reject") return Colors.red;
            return customcolor.blue;
          }),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ],
    );
  }

  /// ---------------- SUBMIT ----------------

  Widget _submitButton() {
    bool isClient = GlobalLists.clientrole == role;
    bool hasPendingOmOe = _hasPendingOmOeApproval;
    bool isOmOeReadOnly = _isOmOeReadOnly;
    // bool isSupervisorRole=_isSupervisorReadOnly;

    // print("ISSPERVISOR ${isSupervisorRole}");
    // Determine if submit button should be enabled
    bool canSubmit;

    if (isOmOeReadOnly) {
      // OM/OE read-only mode: disable submit button
      canSubmit = false;
    }
   
     else {
      // OM/OE user who can still take action
      canSubmit = true;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Only show bulk buttons when NOT in OM/OE read-only mode
          // AND when client has permission (no pending OM/OE approval)
          (isOmOeReadOnly ||
                  (GlobalLists.clientrole == role && _hasPendingOmOeApproval))
              ? SizedBox()
              : Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _bulkButton(
                        label: "Approve All",
                        color: Colors.green,
                        onTap: () {
                          if (_allClientApproved) return;

                          // Check for client permission
                          if (GlobalLists.clientrole == role &&
                              _hasPendingOmOeApproval) {
                            ShowDialogs.showToast(
                              "Pending approval from OPs side",
                            );
                            return;
                          }

                          setState(() {
                            for (var d in attendanceData!.data) {
                              for (var r in d.records) {
                                if (!_isRadioLocked(r) &&
                                    _canClientTakeActionOnRecord(r)) {
                                  approvalSelection[r.id] = "approve";
                                }
                              }
                            }
                          });
                        },
                        disabled:
                            _allClientApproved ||
                            (GlobalLists.clientrole == role &&
                                _hasPendingOmOeApproval) ||
                            isOmOeReadOnly,
                      ),
                      const SizedBox(width: 8),
                      _bulkButton(
                        label: "Reject All",
                        color: Colors.red,
                        onTap: () {
                          if (_allClientApproved) return;

                          // Check for client permission
                          if (GlobalLists.clientrole == role &&
                              _hasPendingOmOeApproval) {
                            ShowDialogs.showToast(
                              "Pending approval from OPs side",
                            );
                            return;
                          }

                          setState(() {
                            for (var d in attendanceData!.data) {
                              for (var r in d.records) {
                                if (!_isRadioLocked(r) &&
                                    _canClientTakeActionOnRecord(r)) {
                                  approvalSelection[r.id] = "reject";
                                }
                              }
                            }
                          });
                        },
                        disabled:
                            _allClientApproved ||
                            (GlobalLists.clientrole == role &&
                                _hasPendingOmOeApproval) ||
                            isOmOeReadOnly ,
                      ),
                    ],
                  ),
                ),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  _allClientApproved || !canSubmit || isOmOeReadOnly
                      ? Colors.grey.shade300
                      : customcolor.blue,
                ),
                foregroundColor: MaterialStateProperty.all(
                  _allClientApproved || !canSubmit || isOmOeReadOnly
                      ? Colors.grey.shade500
                      : Colors.white,
                ),
                padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(vertical: 14),
                ),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              onPressed: _allClientApproved || !canSubmit || isOmOeReadOnly
                  ? null
                  : _submitAttendaceRoster,
              child: Text(
                _allClientApproved
                    ? "Already Approved"
                    : isOmOeReadOnly && role != GlobalLists.clientrole
                    ? "OPs Approval Completed"
                    : !canSubmit
                    ? "Pending OPs Approval"
                    : "Submit",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ---------------- REJECT DIALOG ----------------

  Future<String?> _rejectReasonDialog() async {
    TextEditingController controller = TextEditingController();

    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// TITLE
                const Text(
                  "Reject Reason",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),

                const SizedBox(height: 6),

                const Text(
                  "Please mention the reason for rejection",
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),

                const SizedBox(height: 14),

                /// TEXT FIELD
                TextField(
                  controller: controller,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: "Enter reject reason",
                    contentPadding: const EdgeInsets.all(12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: customcolor.blue,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// ACTION BUTTONS
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel"),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        if (controller.text.trim().isEmpty) {
                          ShowDialogs.showToast("Reject reason is required");
                          return;
                        }
                        Navigator.pop(context, controller.text.trim());
                      },
                      child: const Text("Submit"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// ---------------- API ----------------

  _fetchAttendanceRoster() async {
    role = await SPManager().getroleid();
    var supervisorid = await SPManager().getsupervisorid();

    if (!await ConnectionDetector.checkInternetConnection()) {
      ShowDialogs.showToast("Please check internet connection");
      return;
    }

    final now = DateTime.now();

    widget.month ??= now.month.toString().padLeft(2, '0');
    widget.year ??= now.year.toString();

    final firstDay = DateTime(
      int.parse(widget.year),
      int.parse(widget.month),
      1,
    );
    final lastDay = DateTime(
      int.parse(widget.year),
      int.parse(widget.month) + 1,
      0,
    );

    var map = {
      "from_date": DateFormat('yyyy-MM-dd').format(firstDay),
      "to_date": DateFormat('yyyy-MM-dd').format(lastDay),
      "shift": widget.shiftId.toString(),
    };

    if (role == GlobalLists.clientrole) {
      map["client_id"] = "${widget.clientid}";
    } else {
      map["user_id"] = "$supervisorid";
    }

    log('view remark attendance ${map}');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    APIManager().apiRequest(
      context,
      API.view_monthly_attendance_rooster_details,
      (response) {
        Navigator.pop(context);
        setState(() {
          attendanceData = response;
          _initializeApiRejectionStatus(); // Initialize rejection tracking
        });
      },
      (error) {
        Navigator.pop(context);
        ShowDialogs.showToast(error.toString());
      },
      false,
      "",
      jsonval: map,
    );
  }

  double _getApprovalProgress() {
    if (attendanceData == null || attendanceData!.totalCount == 0) return 0.0;

    // Get base approved count from API
    int baseApproved = role == GlobalLists.clientrole
        ? attendanceData!.totalApprovedByClient
        : attendanceData!.totalApprovedByOeom;

    // Count user selections that are "approve" for records not yet approved in API
    int pendingApprovals = 0;

    for (var d in attendanceData!.data) {
      for (var r in d.records) {
        // Check if this record is not already approved in API
        bool isAlreadyApproved = false;
        if (role == GlobalLists.clientrole) {
          isAlreadyApproved = r.clientApprovalStatus == "approved";
        } else {
          isAlreadyApproved = r.omOeApprovalStatus == "approved";
        }

        // If not already approved, check user selection
        if (!isAlreadyApproved && approvalSelection[r.id] == "approve") {
          pendingApprovals++;
          setState(() {});
        }
      }
    }

    return (baseApproved + pendingApprovals) / attendanceData!.totalCount;
  }

  int _getApprovalProgressCount() {
    if (attendanceData == null || attendanceData!.totalCount == 0) return 0;

    // Get base approved count from API
    int baseApproved = role == GlobalLists.clientrole
        ? attendanceData!.totalApprovedByClient
        : attendanceData!.totalApprovedByOeom;

    // Count user selections that are "approve" for records not yet approved in API
    int pendingApprovals = 0;

    for (var d in attendanceData!.data) {
      for (var r in d.records) {
        // Check if this record is not already approved in API
        bool isAlreadyApproved = false;
        if (role == GlobalLists.clientrole) {
          isAlreadyApproved = r.clientApprovalStatus == "approved";
        } else {
          isAlreadyApproved = r.omOeApprovalStatus == "approved";
        }

        // If not already approved, check user selection
        if (!isAlreadyApproved && approvalSelection[r.id] == "approve") {
          pendingApprovals++;
        }
      }
    }

    return (baseApproved + pendingApprovals);
  }

  _submitAttendaceRoster() async {
    // Check for OM/OE read-only mode
    if (_isOmOeReadOnly) {
      ShowDialogs.showToast("OPs approval already completed");
      return;
    }

    // Check for client permission to submit
    if (GlobalLists.clientrole == role && _hasPendingOmOeApproval) {
      ShowDialogs.showToast("Pending approval from OPs side");
      return;
    }

    List<Record> allRecords = [];
    for (var d in attendanceData!.data) {
      allRecords.addAll(d.records);
    }

    if (approvalSelection.length != allRecords.length) {
      ShowDialogs.showToast("Please approve or reject all records");
      return;
    }

    /// ======== FIXED: Check only for NEW rejections ========
    bool hasNewReject = false;

    for (var record in allRecords) {
      final userSelection = approvalSelection[record.id];

      // Only count it as a new rejection if:
      // 1. User selected "reject" AND
      // 2. It wasn't already rejected from API
      if (userSelection == "reject" &&
          !alreadyRejectedFromApi.contains(record.id)) {
        hasNewReject = true;
        break; // No need to check further
      }
    }

    if (hasNewReject) {
      universalRejectReason = await _rejectReasonDialog();
      if (universalRejectReason == null) return;
    }

    try {
      if (!await ConnectionDetector.checkInternetConnection()) {
        ShowDialogs.showToast("Please check internet connection");
        return;
      }

      var supervisorid = await SPManager().getsupervisorid();

      /// ---------------- BUILD attendance_id_list ----------------

      List<Map<String, dynamic>> attendanceIdList = [];

      for (var d in attendanceData!.data) {
        for (var r in d.records) {
          final status = approvalSelection[r.id];

          // Use the appropriate status based on whether it's a new rejection or existing
          String finalStatus;
          String approveStatus;

          if (alreadyRejectedFromApi.contains(r.id) && status == "reject") {
            // Keep existing API rejection status
            finalStatus = r.previousStatus == 'yes'
                ? "no"
                : "yes"; // Opposite of original
            approveStatus = "rejected";
          } else {
            // Use user's new selection
            finalStatus = status == "approve" ? "yes" : "no";
            approveStatus = status == "approve" ? "approved" : "rejected";
          }

          attendanceIdList.add({
            "date": DateFormat('yyyy-MM-dd').format(r.date),
            "attendance_status": finalStatus,
            "attendance_id": r.id,
            "approve_status": approveStatus,
            "attendance_type": r.attendance_type,
          });
        }
      }

      /// ---------------- CHECK IF USER IS APPROVING ALL RECORDS ----------------
      bool allRecordsApprovedByUser = true;

      for (var record in allRecords) {
        final userSelection = approvalSelection[record.id];
        if (userSelection != "approve") {
          setState(() {
            allRecordsApprovedByUser = false;
          });

          break;
        }
      }

      // Determine is_final_submitted value
      String isFinalSubmitted;

      if (GlobalLists.clientrole == role) {
        // For client users, always use "true" as per original logic
        isFinalSubmitted = "true";
      } else {
        // For non-client users (OM/OE):
        // - If user is approving ALL records, use "true"
        // - Otherwise, use "false"
        isFinalSubmitted = allRecordsApprovedByUser ? "true" : "false";
      }

      /// ---------------- FINAL MAP ----------------

      var map = {
        "reason": hasNewReject ? universalRejectReason : "",
        "attendance_id_list": jsonEncode(attendanceIdList),
        "is_client": GlobalLists.clientrole == role ? "true" : "false",
        "is_final_submitted": isFinalSubmitted,
      };

      if (GlobalLists.clientrole == role) {
        map["client_id"] = widget.clientid;
      } else {
        map["user_id"] = supervisorid;
      }

      log('check this $map');

      /// ---------------- API CALL ----------------

      await APIManager().apiRequest(
        context,
        API.approved_rejected_om_oe_client_submit_attendance_rooster,
        (response) {
          ApproveRejectSubmit resp = response;

          if (resp.status == 1) {
            // Timer(
            //   Duration(seconds: 1),
            //       () =>
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) =>
                    ViewAttendanceRoster(
                      month: widget.month,
                      year: widget.year,
                      attendancesiteid: widget.attendancesiteid,
                      attendanceclientid: widget.clientid,
                      role: role.toString(),
                      maintag: widget.manTag,
                      attendanceshiftid: widget.shiftId,
                      attendanceRosterData: [],
                    ),
                transitionDuration: Duration(seconds: 0),
              ),
            );
            // Navigator.pop(context);
            // );
            ShowDialogs.showToast(resp.msg);
          } else {
            ShowDialogs.showToast(resp.msg);
          }
        },
        (error) {
          ShowDialogs.showToast("Error: $error");
        },
        false,
        "",
        jsonval: map,
      );
    } catch (e) {
      log("Submit error => $e");
      ShowDialogs.showToast("Something went wrong");
    }
  }
}

// Extension for capitalizing first letter
extension StringExtension on String {
  String capitalizeFirst() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}
