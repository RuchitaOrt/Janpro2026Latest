import 'dart:io';

import 'package:flutter/material.dart';
// class VisitCategory {
//   String name;
//   IconData icon;
//   bool isExpanded;
//   List<VisitItem> items;

//   VisitCategory({
//     required this.name,
//     this.isExpanded = false,
//     required this.icon,
//     required this.items,
//   });
// }
class VisitCategory {
  String name;
  String id;
  IconData icon;
  bool isExpanded;
  List<VisitItem> items;

  VisitCategory({
    required this.name,
    required this.icon,
    required this.id,
    this.isExpanded = false,
    required this.items,
  });
}
class VisitItem {
  String name;
  String id;
  bool isSelected;
  File? image;

  /// 🔥 ADD THIS
  String? networkImage;

  VisitItem({
    required this.name,
    required this.id,
    this.isSelected = false,
    this.image,
    this.networkImage,
  });
}
// class VisitItem {
//   String name;
//   bool isSelected;
//   File? image;
//   TextEditingController remarkController;

//   VisitItem({
//     required this.name,
//     this.isSelected = false,
//     this.image,
//   }) : remarkController = TextEditingController();
// }
// class VisitTypeItem {
//   String name;
//   bool isSelected;
//   bool isSubmitted; // 👈 NEW
//   TextEditingController remarkController = TextEditingController();
//   File? image;

//   VisitTypeItem({
//     required this.name,
//     this.isSelected = false,
//     this.isSubmitted = false,
//   });
// }