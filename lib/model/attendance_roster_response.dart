class AttendanceRosterResponse {
  final String status;
  final String msg;
  final List<ShiftData> data;

  AttendanceRosterResponse({
    required this.status,
    required this.msg,
    required this.data,
  });

  factory AttendanceRosterResponse.fromJson(Map<String, dynamic> json) {
    return AttendanceRosterResponse(
      status: json['status'] ?? '',
      msg: json['msg'] ?? '',
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => ShiftData.fromJson(e))
              ?.toList() ??
          [],
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

  ShiftData({
    required this.id,
    required this.shiftName,
    required this.shiftStartTime,
    required this.shiftEndTime,
    required this.supervisor,
    required this.employeeList,
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
              ?.toList() ??
          [],
    );
  }
}

class EmployeeData {
  final String empName;
  final int empId;

  final List<AttendanceData> attendData;

  EmployeeData(
      {required this.empName, required this.attendData, required this.empId});

  factory EmployeeData.fromJson(Map<String, dynamic> json) {
    return EmployeeData(
      empName: json['emp_name'] ?? '',
      empId: json['emp_id'],
      attendData: (json['attend_data'] as List<dynamic>?)
              ?.map((e) => AttendanceData.fromJson(e))
              ?.toList() ??
          [],
    );
  }
}

class AttendanceData {
  final String date;
  final String attendanceStatus;

  AttendanceData({
    required this.date,
    required this.attendanceStatus,
  });

  factory AttendanceData.fromJson(Map<String, dynamic> json) {
    return AttendanceData(
      date: json['date'] ?? '',
      attendanceStatus: json['attendance_status'] ?? '',
    );
  }
}
