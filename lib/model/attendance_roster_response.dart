class AttendanceRosterResponse {
  final String status;
  final String msg;
  final List<ShiftData> data;
  final String monthly_roster_report;

  AttendanceRosterResponse({
    required this.status,
    required this.msg,
    required this.data,
    required this.monthly_roster_report
  });

  factory AttendanceRosterResponse.fromJson(Map<String, dynamic> json) {
    return AttendanceRosterResponse(
      status: json['status'] ?? '',
      msg: json['msg'] ?? '',
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => ShiftData.fromJson(e))
              .toList() ??
          [],
          monthly_roster_report:json['monthly_roster_report']?? ""
    );
  }
}

class ShiftData {
  final int id;
  final String shiftName;
  final String shiftStartTime;
  final String shiftEndTime;
  final String supervisor;
  final List<EmployeeData> employeeList;
  final dynamic is_month_end;
  final dynamic is_final_submitted;
  final dynamic sup_final_submitted;

  final bool review_updated_by_oe_om;
  final bool review_updated_by_client;

  



  ShiftData({
    required this.id,
    required this.shiftName,
    required this.shiftStartTime,
    required this.shiftEndTime,
    required this.supervisor,
    required this.employeeList,
    required this.is_month_end,
    required this.is_final_submitted,
    required this.review_updated_by_oe_om,
    required this.review_updated_by_client,
    required this.sup_final_submitted

  });

  factory ShiftData.fromJson(Map<String, dynamic> json) {
    return ShiftData(
      id: json['id'] ?? 0,
      shiftName: json['shift_name'] ?? '',
      shiftStartTime: json['shift_start_time'] ?? '',
      shiftEndTime: json['shift_end_time'] ?? '',
      supervisor: json['supervisor'] ?? '',
    
      

      employeeList: (json['employee_list'] as List<dynamic>?)
              ?.map((e) => EmployeeData.fromJson(e))
              .toList() ??
          [],
          is_final_submitted:json['is_final_submitted'],
          is_month_end:json['is_month_end'],
        review_updated_by_oe_om:json['review_updated_by_oe_om']??false,
        review_updated_by_client:json["review_updated_by_client"]??false,
        sup_final_submitted:json['sup_final_submitted']

    );
  }
}

class EmployeeData {
  final String empName;
  final dynamic empId;
  final List<AttendanceData> attendData;
  final List<ClientReason> clientReasonList; 

  EmployeeData({
    required this.empName,
    required this.empId,
    required this.attendData,
    required this.clientReasonList,
  });

  factory EmployeeData.fromJson(Map<String, dynamic> json) {
    return EmployeeData(
      empName: json['emp_name'] ?? '',
      empId: json['emp_id'],
      attendData: (json['attend_data'] as List<dynamic>?)
              ?.map((e) => AttendanceData.fromJson(e))
              .toList() ??
          [],
          clientReasonList: (json['client_reason_list'] as List<dynamic>?)
              ?.map((e) => ClientReason.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class AttendanceData {
  final String date;
  final String attendanceStatus;
  final String? reason;
  final String? sup_reason;
  final String? om_oe_resson;
  final String? om_oe_approval_status;
  final String? client_approval_status;
  final bool? act_deact_janitor;
    final dynamic? ot_hours;
  final String?attendance_type;


  final String? statusPresentAbsent;
  final int? attendanceId;

  AttendanceData({
    required this.date,
    required this.attendanceStatus,
    this.reason,
    this.sup_reason,
    this.om_oe_resson,
    this.om_oe_approval_status,
    this.client_approval_status,
    this.statusPresentAbsent,
    this.attendanceId,
     this.act_deact_janitor,
     this.ot_hours,
     this.attendance_type,
  });

  factory AttendanceData.fromJson(Map<String, dynamic> json) {
    return AttendanceData(
      date: json['date'] ?? '',
      attendanceStatus: json['attendance_status'] ?? '',
      attendance_type: json['attendance_type'] ?? '',
      sup_reason:json['sup_reason']??"",

        ot_hours: json['ot_hours'] ?? 0.0,
      reason: json['reason'],
      om_oe_resson: json['om_oe_resson'],
      om_oe_approval_status: json['om_oe_approval_status'],
      client_approval_status: json['client_approval_status'],
      statusPresentAbsent: json['status_present_absent'],
      attendanceId: json['attendance_id'],
      act_deact_janitor: json['act_deact_janitor']??false,
    );
  }
}
class ClientReason {
  final String date;
  final String supReason;
  final String clientReason;

  ClientReason({
    required this.date,
    required this.supReason,
    required this.clientReason,
  });

  factory ClientReason.fromJson(Map<String, dynamic> json) {
    return ClientReason(
      date: json['date'] ?? '',
      supReason: json['sup_reason'] ?? '',
      clientReason: json['client_reason'] ?? '',
    );
  }
}