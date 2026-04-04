import 'dart:io';

import 'package:flutter/material.dart';
class VisitCategory {
  String name;
  bool isExpanded;
  List<VisitItem> items;

  VisitCategory({
    required this.name,
    this.isExpanded = false,
    required this.items,
  });
}

class VisitItem {
  String name;
  bool isSelected;
  File? image;
  TextEditingController remarkController;

  VisitItem({
    required this.name,
    this.isSelected = false,
    this.image,
  }) : remarkController = TextEditingController();
}
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