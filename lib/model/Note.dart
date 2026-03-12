// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';

// {date: 2024-03-11,
//site_id: 282, client: false, id: 191,
//type: complaint, emp_id: 90211683-37c2-4d72-a939-98ac46d25666, status: Pending}
class Note {
  final String status;
  final String id;
  final String type;
  final String date;
  final String emp_id;
  final bool isclient;
  final String siteid;
  final String client_site_name;

  final String shift_id;

  final String shift_start_time;

  final String shift_end_time;

  Note({
    required this.status,
    required this.id,
    required this.type,
    required this.date,
    required this.emp_id,
    required this.isclient,
    required this.siteid,
    required this.client_site_name,
    required this.shift_id,
    required this.shift_start_time,
    required this.shift_end_time,
  });

  //Add these methods below

  factory Note.fromJsonString(String str) => Note._fromJson(jsonDecode(str));

  String toJsonString() => jsonEncode(_toJson());

  factory Note._fromJson(Map<String, dynamic> json) => Note(
    status: json['status']??'',
    id: json['id']??'',
    type: json['type']??"",
    date: json['date']??'',
    siteid: json['siteid']??'',
    emp_id: json['emp_id']??'',
    isclient: json['isclient']??false,

    client_site_name: json['client_site_name']??'',
    shift_id: json['shift_id']??'',
    shift_start_time: json['shift_start_time']??"",
    shift_end_time: json['shift_end_time']??'',
  );

  Map<String, dynamic> _toJson() => {
    'status': status,
    'id': id,
    'type': type,
    'date': date,
    "siteid": siteid,
    'emp_id': emp_id,
    'isclient': isclient,
    "client_site_name": client_site_name,
    "shift_id": shift_id,
    "shift_start_time": shift_start_time,
    "shift_end_time": shift_end_time,
  };
}
