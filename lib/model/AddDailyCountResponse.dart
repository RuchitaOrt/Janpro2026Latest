class AddDailyCountResponse {
  final int? status;
  final String? msg;
  final AddDailyCountData? data;

  AddDailyCountResponse({
    this.status,
    this.msg,
    this.data,
  });

  factory AddDailyCountResponse.fromJson(Map<String, dynamic> json) {
    return AddDailyCountResponse(
      status: json['status'],
      msg: json['msg'],
      data: json['data'] != null
          ? AddDailyCountData.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'msg': msg,
      'data': data?.toJson(),
    };
  }
}

class AddDailyCountData {
  final int? id;
  final String? createdAt;
  final String? updatedAt;
  final String? createdBy;
  final String? updatedBy;
  final bool? isActive;
  final int? client;
  final int? site;
  final int? noOfStaff;
  final int? newNoOfStaff;
  final int? attandedStaffCount;
  final String? shiftName;
  final String? supervisor;
  final bool? multidays;

  AddDailyCountData({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
    this.isActive,
    this.client,
    this.site,
    this.noOfStaff,
    this.newNoOfStaff,
    this.attandedStaffCount,
    this.shiftName,
    this.supervisor,
    this.multidays,
  });

  factory AddDailyCountData.fromJson(Map<String, dynamic> json) {
    return AddDailyCountData(
      id: json['id'] ?? 0,
      createdAt: json['createdAt'] ?? "",
      updatedAt: json['updatedAt'] ?? "",
      createdBy: json['createdBy'] ?? "",
      updatedBy: json['updatedBy'] ?? "",
      isActive: json['isActive'] ?? false,
      client: json['Client'] is int ? json['Client'] : int.tryParse("${json['Client']}") ?? 0,
      site: json['Site'] is int ? json['Site'] : int.tryParse("${json['Site']}") ?? 0,
      noOfStaff: json['no_of_staff'] ?? 0,
      newNoOfStaff: json['new_no_of_staff'] ?? 0,
      attandedStaffCount: json['attanded_staff_count'] ?? 0,
      shiftName: json['shift_name'] ?? "",
      supervisor: json['supervisor'] ?? "",
      multidays: json['multidays'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'isActive': isActive,
      'Client': client,
      'Site': site,
      'no_of_staff': noOfStaff,
      'new_no_of_staff': newNoOfStaff,
      'attanded_staff_count': attandedStaffCount,
      'shift_name': shiftName,
      'supervisor': supervisor,
      'multidays': multidays,
    };
  }
}
