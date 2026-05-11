import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:geocoding/geocoding.dart';

import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:collection/collection.dart';
import 'package:janpro/Utitlity/ResponsiveFlutter.dart';
import 'package:janpro/model/VisitTypeItem.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart' as permishan;

import '../DBHelper/db_helper.dart';
import '../Utitlity/AppDrawer.dart';
import '../Utitlity/FormTextField.dart';
import '../Utitlity/LocationService.dart';
import '../Utitlity/appbar.dart';
import '../Utitlity/customBottomNavigationBar.dart';
import '../Utitlity/custom_color.dart';
import '../Utitlity/APIManager.dart';
import '../Utitlity/GlobalLists.dart';
import '../Utitlity/SPManager.dart';
import '../Utitlity/ShowDialog.dart';
import '../Utitlity/internetConnection.dart';
import '../const/global.dart';
import '../model/SiteDropDown.dart';
import '../services/camera_capture_screen.dart';
import '../services/permission_helper.dart';
import 'Homepage.dart';
import 'OperationVisitCardPage.dart';
import 'client_operation_visti_card.dart';
import 'client_visit_view.dart';
import 'package:intl/intl.dart';

class OperationVisitPage extends StatefulWidget {
  String? role;
  bool? isEdit;
  dynamic? visit;
  OperationVisitPage(this.role, this.isEdit, this.visit);

  @override
  State<OperationVisitPage> createState() => _OperationVisitPageState();
}

class _OperationVisitPageState extends State<OperationVisitPage> {
  final TextEditingController siteNameController = TextEditingController();
  final TextEditingController visitTypeController = TextEditingController();
  final TextEditingController purposeController = TextEditingController();
  final TextEditingController remarkController = TextEditingController();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  File? selectedImage;
  Route? previousRoute;
  final ImagePicker _imagePicker = ImagePicker();
  var role;
  String? selectedSite;
  String? clientId;
  var lat;
  var long;
  var client_id;
  var site_id;
  grantPermission() async {
    var status = await permishan.Permission.location.status;

    print("Current Permission Status: $status");

    if (status.isGranted) {
      print("Location permission granted");
      getLocation();
    } else if (status.isDenied) {
      print("Requesting location permission...");

      var result = await permishan.Permission.location.request();
      print(result);
      if (result.isGranted) {
        print("User granted location permission");
        getLocation();
      } else if (result.isPermanentlyDenied) {
        getLocation();
        // print("Permission permanently denied");
        // ShowDialogs.showToast(
        //     "Please enable location from settings");
        // await permishan.openAppSettings();
      } else {
        ShowDialogs.showToast("Location permission required");
      }
    } else if (status.isPermanentlyDenied) {
      print("Permission permanently denied");
      ShowDialogs.showToast("Please enable location from settings");
      await permishan.openAppSettings();
    }
  }

  getrole() async {
    role = await SPManager().getroleid();

    await grantPermission();
    await siteDropDown();
    await _getLocation();
    site_id = await GlobalLists.visitSiteId;
    client_id = await GlobalLists.visitClintId;
  }

  @override
  void initState() {
    siteNameController.text = GlobalLists.clienname;
    print(
      'siteNameController.text ${siteNameController.text} GlobalLists.clientname ${GlobalLists.clientname}GlobalLists.visitSiteId${GlobalLists.visitSiteId}',
    );

    getrole();
    if (widget.isEdit == true) {
      print("TRUE DYNAMIC VISIT");
      print(widget.visit.date);
      print(widget.visit.time);
      print(widget.visit.trainingImages.length);
      print(widget.visit.workflow);

      selectedDate = widget.visit.date;
      if (widget.visit.time != null) {
        final parts = widget.visit.time!.split(":");

        selectedTime = TimeOfDay(
          hour: int.parse(parts[0]),
          minute: int.parse(parts[1]),
        );
      }
      workflowValue = widget.visit.workflow == "yes"
          ? "Yes"
          : widget.visit.workflow == "no"
          ? "No"
          : "";
      // selectedTime = widget.visit.time;
    } else {
      DateTime now = DateTime.now();
      selectedDate = DateTime.now();
      selectedTime = TimeOfDay.now();
    }

    getVisitDropdownApi();

    super.initState();
  }

  Widget selectedItemsUI() {
    List<Map<String, dynamic>> selectedItemsWithCategory = [];

    // for (var category in visitCategories) {
    //   for (var item in category.items) {
    //     if (item.isSelected) {
    //       selectedItemsWithCategory.add({
    //         "category": category.name,
    //         "item": item,
    //       });
    //     }
    //   }
    // }
    for (var category in visitCategories) {
      /// ✅ CATEGORY WITHOUT ITEMS
      if (category.items.isEmpty && category.isSelected) {
        selectedItemsWithCategory.add({
          "category": category.name,
          "item": null,
          "categoryObj": category,
        });
      }

      /// ✅ ITEMS
      for (var item in category.items) {
        if (item.isSelected) {
          selectedItemsWithCategory.add({
            "category": category.name,
            "item": item,
          });
        }
      }
    }
    if (selectedItemsWithCategory.isEmpty) return SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Text(
          "Selected Visit Details",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),

        ...selectedItemsWithCategory.map((data) {
          String categoryName = data["category"];

          /// CATEGORY IMAGE CASE
          if (data["item"] == null) {
            VisitCategory category = data["categoryObj"];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Text(
                  "$categoryName Image",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 10),

                GestureDetector(
                  onTap: widget.isEdit == true
                      ? null
                      : () async {
                          final picked = await ImagePicker().pickImage(
                            source: ImageSource.gallery,
                          );

                          if (picked != null) {
                            setState(() {
                              category.image = File(picked.path);
                            });
                          }
                        },
                  child: Stack(
                    children: [
                      Container(
                        height: 110,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: (category.image != null)
                            ? Image.file(
                                category.image!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              )
                            : (category.networkImage != null &&
                                  category.networkImage!.isNotEmpty)
                            ? Image.network(
                                category.networkImage!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(child: CircularProgressIndicator());
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Center(
                                    child: Icon(
                                      Icons.broken_image,
                                      color: Colors.grey,
                                    ),
                                  );
                                },
                              )
                            : Center(
                                child: Icon(
                                  Icons.camera_alt,
                                  color: customcolor.blue,
                                ),
                              ),
                        // child: (category.image != null ||
                        //         (category.networkImage != null &&
                        //             category.networkImage!.isNotEmpty))
                        //     ? Image.file(
                        //         category.image!,
                        //         fit: BoxFit.cover,
                        //       )
                        //     : Center(
                        //         child: Icon(Icons.camera_alt,
                        //             color: customcolor.blue),
                        //       ),
                      ),

                   widget.isEdit == true?Container():    Positioned(
            right: 5,
            top: 5,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  /// 🔥 REMOVE IMAGE
                  category.image = null;
                  category.networkImage = null;

                  /// 🔥 UNCHECK CATEGORY
                 // category.isSelected = false;

                  /// 🔥 UPDATE TEXT
                  updateVisitTypeText();
                });
              },
              child: Icon(Icons.cancel, color: Colors.red),
            ),
          ),
                    ],
                  ),
                ),
              ],
            );
          }
          VisitItem item = data["item"];
          // String categoryName = data["category"];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),

              /// ✅ CATEGORY + ITEM NAME
              Text(
                "$categoryName - ${item.name} Image",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),

              SizedBox(height: 10),

              GestureDetector(
                onTap: widget.isEdit == true
                    ? null
                    : () async {
                        final picked = await ImagePicker().pickImage(
                          source: ImageSource.gallery,
                        );

                        if (picked != null) {
                          setState(() {
                            item.image = File(picked.path);
                          });
                        }
                      },
                child: Container(
                  height: 110,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child:
                      (item.image != null ||
                          (item.networkImage != null &&
                              item.networkImage!.isNotEmpty))
                      ? Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child:
                                  (item.networkImage != null &&
                                      item.networkImage!.isNotEmpty)
                                  ? Image.network(
                                      item.networkImage!,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                            if (loadingProgress == null)
                                              return child;
                                            return Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          },
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Center(
                                              child: Icon(
                                                Icons.broken_image,
                                                color: Colors.grey,
                                              ),
                                            );
                                          },
                                    )
                                  : (item.image != null
                                        ? Image.file(
                                            item.image!,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          )
                                        : SizedBox()),
                              // child:item.networkImage!.isNotEmpty ?
                              // Image.network(item.networkImage!,
                              //     width: double.infinity,
                              //     fit: BoxFit.cover): Image.file(item.image!,
                              //     width: double.infinity,
                              //     fit: BoxFit.cover),
                            ),
                            widget.isEdit == true
                                ? Container()
                                : Positioned(
                                    right: 5,
                                    top: 5,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          item.image = null;
                                        });
                                      },
                                      child: Icon(
                                        Icons.cancel,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                          ],
                        )
                      : Center(
                          child: Icon(
                            Icons.camera_alt,
                            color: customcolor.blue,
                          ),
                        ),
                ),
              ),
            ],
          );
        }).toList(),
      ],
    );
  }

  Widget workflowUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),

        Text(
          "Workflow Management at Site",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        SizedBox(height: 5),

        /// ✅ RADIO BUTTONS
        Row(
          children: [
            Row(
              children: [
                Radio<String>(
                  value: "Yes",
                  groupValue: workflowValue,
                  activeColor: customcolor.blue,
                  onChanged: widget.isEdit == true
                      ? null
                      : (val) {
                          setState(() {
                            workflowValue = val;
                          });
                        },
                ),
                Text("Yes"),
              ],
            ),

            SizedBox(width: 20),

            Row(
              children: [
                Radio<String>(
                  value: "No",
                  groupValue: workflowValue,
                  activeColor: customcolor.blue,
                  onChanged: widget.isEdit == true
                      ? null
                      : (val) {
                          setState(() {
                            workflowValue = val;

                            /// ❗ REMOVE IMAGE IF NO
                            if (val == "No") {
                              selectedImage = null;
                            }
                          });
                        },
                ),
                Text("No"),
              ],
            ),
          ],
        ),
      ],
    );
  }

  void updateVisitTypeText() {
    List<String> names = [];

    for (var cat in visitCategories) {
      if (cat.items.isEmpty) {
        if (cat.isSelected) {
          names.add(cat.name);
        }
      } else {
        for (var item in cat.items) {
          if (item.isSelected) {
            names.add(item.name);
          }
        }
      }
    }

    visitTypeController.text = names.join(", ");
  }
  // void updateVisitTypeText() {
  //   List<VisitItem> selectedItems = visitCategories
  //       .expand((cat) => cat.items)
  //       .where((item) => item.isSelected)
  //       .toList();

  //   visitTypeController.text = selectedItems.map((e) => e.name).join(", ");
  // }
  // Widget visitTypeDropdownUI() {
  //   return ListView.builder(
  //     shrinkWrap: true,
  //     physics: NeverScrollableScrollPhysics(),
  //     itemCount: visitCategories.length,
  //     itemBuilder: (context, index) {
  //       final category = visitCategories[index];
  //       bool hasItems = category.items.isNotEmpty;

  //       int selectedCount =
  //           category.items.where((e) => e.isSelected).length;

  //       return Container(
  //         margin: EdgeInsets.only(bottom: 12),
  //         padding: EdgeInsets.all(14),
  //         decoration: BoxDecoration(
  //           color: Colors.white,
  //           borderRadius: BorderRadius.circular(14),
  //           boxShadow: [
  //             BoxShadow(
  //               color: Colors.black12,
  //               blurRadius: 6,
  //               offset: Offset(0, 2),
  //             ),
  //           ],
  //         ),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [

  //             /// =========================
  //             /// 🔷 CATEGORY ROW
  //             /// =========================
  //             Row(
  //               children: [
  //                 /// ROUND CHECKBOX
  //                 GestureDetector(
  //                   onTap: widget.isEdit == true
  //                       ? null
  //                       : () {
  //                           setState(() {
  //                             if (!hasItems) {
  //                               category.isSelected =
  //                                   !(category.isSelected ?? false);

  //                               if (!(category.isSelected ?? false)) {
  //                                 category.image = null;
  //                               }
  //                             } else {
  //                               category.isExpanded =
  //                                   !category.isExpanded;
  //                             }

  //                             updateVisitTypeText();
  //                           });
  //                         },
  //                   child: Container(
  //                     width: 24,
  //                     height: 24,
  //                     decoration: BoxDecoration(
  //                       shape: BoxShape.circle,
  //                       border: Border.all(
  //                         color: (!hasItems
  //                                 ? (category.isSelected ?? false)
  //                                 : false)
  //                             ? customcolor.green
  //                             : Colors.grey,
  //                       ),
  //                       color: (!hasItems
  //                               ? (category.isSelected ?? false)
  //                               : false)
  //                           ? customcolor.green
  //                           : Colors.transparent,
  //                     ),
  //                     child: (!hasItems &&
  //                             (category.isSelected ?? false))
  //                         ? Icon(Icons.check,
  //                             size: 16, color: Colors.white)
  //                         : null,
  //                   ),
  //                 ),

  //                 SizedBox(width: 12),

  //                 /// CATEGORY NAME
  //                 Expanded(
  //                   child: Text(
  //                     category.name,
  //                     style: TextStyle(
  //                       fontWeight: FontWeight.bold,
  //                       fontSize: 15,
  //                     ),
  //                   ),
  //                 ),

  //                 /// 🔥 CAMERA / TICK ICON (RIGHT SIDE)
  //                 GestureDetector(
  //                   onTap: widget.isEdit == true
  //                       ? null
  //                       : () async {
  //                           /// CATEGORY WITHOUT ITEMS
  //                           if (!hasItems) {
  //                             if (!(category.isSelected ?? false)) {
  //                               ShowDialogs.showToast("Select first");
  //                               return;
  //                             }

  //                             final picked =
  //                                 await ImagePicker().pickImage(
  //                               source: ImageSource.gallery,
  //                             );

  //                             if (picked != null) {
  //                               setState(() {
  //                                 category.image =
  //                                     File(picked.path);
  //                               });
  //                             }
  //                           }
  //                         },
  //                   child: Icon(
  //                     (!hasItems &&
  //                             (category.image != null ||
  //                                 category.networkImage != null))
  //                         ? Icons.check_circle
  //                         : Icons.camera_alt,
  //                     color: (!hasItems &&
  //                             (category.image != null ||
  //                                 category.networkImage != null))
  //                         ? Colors.green
  //                         : Colors.grey,
  //                   ),
  //                 ),

  //                 /// DROPDOWN ICON (ONLY IF ITEMS)
  //                 if (hasItems)
  //                   Icon(
  //                     category.isExpanded
  //                         ? Icons.keyboard_arrow_up
  //                         : Icons.keyboard_arrow_down,
  //                     color: Colors.grey,
  //                   ),
  //               ],
  //             ),

  //             /// =========================
  //             /// 🔥 CATEGORY IMAGE PREVIEW BELOW
  //             /// =========================
  //             if (!hasItems &&
  //                 (category.image != null ||
  //                     (category.networkImage != null &&
  //                         category.networkImage!.isNotEmpty)))
  //               Padding(
  //                 padding: const EdgeInsets.only(top: 12),
  //                 child: Container(
  //                   height: 110,
  //                   width: double.infinity,
  //                   decoration: BoxDecoration(
  //                     borderRadius: BorderRadius.circular(10),
  //                     border: Border.all(color: Colors.grey),
  //                   ),
  //                   child: Stack(
  //                     children: [
  //                       ClipRRect(
  //                         borderRadius: BorderRadius.circular(10),
  //                         child: (category.networkImage != null &&
  //                                 category.networkImage!.isNotEmpty)
  //                             ? Image.network(
  //                                 category.networkImage!,
  //                                 width: double.infinity,
  //                                 fit: BoxFit.cover,
  //                               )
  //                             : Image.file(
  //                                 category.image!,
  //                                 width: double.infinity,
  //                                 fit: BoxFit.cover,
  //                               ),
  //                       ),
  //                       if (widget.isEdit != true)
  //                         Positioned(
  //                           right: 5,
  //                           top: 5,
  //                           child: GestureDetector(
  //                             onTap: () {
  //                               setState(() {
  //                                 category.image = null;
  //                               });
  //                             },
  //                             child: Icon(Icons.cancel,
  //                                 color: Colors.red),
  //                           ),
  //                         ),
  //                     ],
  //                   ),
  //                 ),
  //               ),

  //             /// =========================
  //             /// 🔷 ITEMS LIST
  //             /// =========================
  //             if (hasItems)
  //               AnimatedCrossFade(
  //                 firstChild: SizedBox(),
  //                 secondChild: Column(
  //                   children: category.items.map((item) {
  //                     return Padding(
  //                       padding: const EdgeInsets.symmetric(
  //                           vertical: 6),
  //                       child: Row(
  //                         children: [
  //                           GestureDetector(
  //                             onTap: widget.isEdit == true
  //                                 ? null
  //                                 : () {
  //                                     setState(() {
  //                                       item.isSelected =
  //                                           !item.isSelected;

  //                                       if (!item.isSelected) {
  //                                         item.image = null;
  //                                       }

  //                                       updateVisitTypeText();
  //                                     });
  //                                   },
  //                             child: Container(
  //                               width: 24,
  //                               height: 24,
  //                               decoration: BoxDecoration(
  //                                 shape: BoxShape.circle,
  //                                 border: Border.all(
  //                                   color: item.isSelected
  //                                       ? customcolor.green
  //                                       : Colors.grey,
  //                                 ),
  //                                 color: item.isSelected
  //                                     ? customcolor.green
  //                                     : Colors.transparent,
  //                               ),
  //                               child: item.isSelected
  //                                   ? Icon(Icons.check,
  //                                       size: 16,
  //                                       color: Colors.white)
  //                                   : null,
  //                             ),
  //                           ),

  //                           SizedBox(width: 12),
  //                           Expanded(child: Text(item.name)),

  //                           /// 🔥 CAMERA / TICK FOR ITEMS
  //                           GestureDetector(
  //                             onTap: widget.isEdit == true
  //                                 ? null
  //                                 : () async {
  //                                     if (!item.isSelected) {
  //                                       ShowDialogs.showToast(
  //                                           "Select item first");
  //                                       return;
  //                                     }

  //                                     final picked =
  //                                         await ImagePicker()
  //                                             .pickImage(
  //                                       source:
  //                                           ImageSource.gallery,
  //                                     );

  //                                     if (picked != null) {
  //                                       setState(() {
  //                                         item.image =
  //                                             File(picked.path);
  //                                       });
  //                                     }
  //                                   },
  //                             child: Icon(
  //                               (item.image != null ||
  //                                       item.networkImage != null)
  //                                   ? Icons.check_circle
  //                                   : Icons.camera_alt,
  //                               color: (item.image != null ||
  //                                       item.networkImage != null)
  //                                   ? Colors.green
  //                                   : Colors.grey,
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     );
  //                   }).toList(),
  //                 ),
  //                 crossFadeState: category.isExpanded
  //                     ? CrossFadeState.showSecond
  //                     : CrossFadeState.showFirst,
  //                 duration: Duration(milliseconds: 250),
  //               ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }
  Widget visitTypeDropdownUI() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: visitCategories.length,
      itemBuilder: (context, index) {
        final category = visitCategories[index];
        bool hasItems = category.items.isNotEmpty;

        return GestureDetector(
          onTap: widget.isEdit == true
              ? null
              : () {
                  setState(() {
                    if (hasItems) {
                      category.isExpanded = !(category.isExpanded ?? false);
                    } else {
                      category.isSelected = !(category.isSelected ?? false);

                      if (!(category.isSelected ?? false)) {
                        category.image = null;
                      }

                      updateVisitTypeText();
                    }
                  });
                },
          child: Container(
            margin: EdgeInsets.only(bottom: 12),
            padding: EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// =========================
                /// 🔷 CATEGORY ROW
                /// =========================
                Row(
                  children: [
                    /// LEFT ICON / CHECKBOX
                    hasItems
                        ? Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: customcolor.blue.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              category.icon,
                              color: customcolor.blue,
                              size: 20,
                            ),
                          )
                        : Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: customcolor.blue.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: (category.isSelected ?? false)
                                      ? customcolor.blue
                                      : Colors.white,
                                ),
                                color: (category.isSelected ?? false)
                                    ? customcolor.blue
                                    : Colors.white,
                              ),
                              child: (category.isSelected ?? false)
                                  ? Icon(
                                      Icons.check,
                                      size: 16,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                            // Icon(
                            //   category.icon,
                            //   color: customcolor.blue,
                            //   size: 20,
                            // ),
                          ),

                    SizedBox(width: 12),

                    /// CATEGORY NAME
                    Expanded(
                      child: Text(
                        category.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),

                    /// RIGHT SIDE ICON
                    hasItems
                        ? Icon(
                            category.isExpanded
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: Colors.grey,
                          )
                        : GestureDetector(
                            onTap: widget.isEdit == true
                                ? null
                                : () async {
                                    if (!(category.isSelected ?? false)) {
                                      ShowDialogs.showToast(
                                        "Select category first",
                                      );
                                      return;
                                    }

                                    final picked = await ImagePicker()
                                        .pickImage(source: ImageSource.gallery);

                                    if (picked != null) {
                                      setState(() {
                                        category.image = File(picked.path);
                                      });
                                    }
                                  },
                            child: Icon(
                              // (category.image != null ||
                              //         category.networkImage != null)
                              (category.image != null ||
                                      (category.networkImage != null &&
                                          category.networkImage!.isNotEmpty))
                                  ? Icons.check_circle
                                  : Icons.camera_alt,
                              color:
                                  //  (category.image != null ||
                                  //         category.networkImage != null)
                                  (category.image != null ||
                                      (category.networkImage != null &&
                                          category.networkImage!.isNotEmpty))
                                  ? Colors.green
                                  : Colors.grey,
                            ),
                          ),
                    // : Icon(
                    //     (category.image != null ||
                    //             category.networkImage != null)
                    //         ? Icons.check_circle
                    //         : Icons.radio_button_unchecked,
                    //     color: (category.image != null ||
                    //             category.networkImage != null)
                    //         ? Colors.green
                    //         : Colors.grey,
                    //   ),
                  ],
                ),

                /// =========================
                /// 🔷 ITEMS LIST
                /// =========================
                if (hasItems)
                  AnimatedCrossFade(
                    firstChild: SizedBox(),
                    secondChild: Column(
                      children: category.items.map((item) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            children: [
                              /// ITEM CHECKBOX
                              GestureDetector(
                                onTap: widget.isEdit == true
                                    ? null
                                    : () {
                                        setState(() {
                                          item.isSelected = !item.isSelected;

                                          if (!item.isSelected) {
                                            item.image = null;
                                          }

                                          updateVisitTypeText();
                                        });
                                      },
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: item.isSelected
                                          ? customcolor.green
                                          : Colors.grey,
                                    ),
                                    color: item.isSelected
                                        ? customcolor.green
                                        : Colors.transparent,
                                  ),
                                  child: item.isSelected
                                      ? Icon(
                                          Icons.check,
                                          size: 16,
                                          color: Colors.white,
                                        )
                                      : null,
                                ),
                              ),

                              SizedBox(width: 12),

                              Expanded(child: Text(item.name)),

                              /// CAMERA
                              GestureDetector(
                                onTap: widget.isEdit == true
                                    ? null
                                    : () async {
                                        if (!item.isSelected) {
                                          ShowDialogs.showToast(
                                            "Select item first",
                                          );
                                          return;
                                        }

                                        final picked = await ImagePicker()
                                            .pickImage(
                                              source: ImageSource.gallery,
                                            );

                                        if (picked != null) {
                                          setState(() {
                                            item.image = File(picked.path);
                                          });
                                        }
                                      },
                                child: Icon(
                                  (item.image != null ||
                                          (item.networkImage != null &&
                                              item.networkImage!.isNotEmpty))
                                      ? Icons.check_circle
                                      : Icons.camera_alt,
                                  color:
                                      (item.image != null ||
                                          (item.networkImage != null &&
                                              item.networkImage!.isNotEmpty))
                                      ? Colors.green
                                      : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    crossFadeState: category.isExpanded
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: Duration(milliseconds: 250),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<VisitCategory> visitCategories = [];

  String? workflowValue;
  String _locationMessage = "Press the button to get your location";

  _getLocation() async {
    LocationService locationService = LocationService();
    try {
      Position position = await locationService.determinePosition();
      setState(() {
        _locationMessage =
            "Latitude: ${position.latitude}, Longitude: ${position.longitude}";

        print(_locationMessage);
      });
    } catch (e) {
      setState(() {
        _locationMessage = "Error: $e";
        print(_locationMessage);
      });
    }
    getLocation();
  }

  Future<Placemark> getLocation() async {
    print("Fetching location...");

    // Get current position
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');

    // Get placemarks (address) from coordinates
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (placemarks.isEmpty) {
      throw Exception("No address found for this location");
    }

    Placemark first = placemarks.first;

    lat = position.latitude.toString();
    long = position.longitude.toString();

    print(
      "${first.name} : ${first.street}, ${first.locality}, ${first.country}",
    );

    return first;
  }

  final GlobalKey<ScaffoldState> _scaffoldKey2 = new GlobalKey<ScaffoldState>();

  final GlobalKey<State> _submitkeyLoader = GlobalKey<State>();

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => selectedDate = picked);
  }

  Future<void> pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) setState(() => selectedTime = picked);
  }

  Future<void> pickImage() async {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      enableDrag: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Take Photo'),
              onTap: () async {
                Navigator.pop(context); // close dialog first

                // Ask for camera permission
                bool hasPermission = await PermissionHelper.requestPermission(
                  Permission.camera,
                );

                if (!hasPermission) {
                  Flushbar(
                    margin: const EdgeInsets.all(8),
                    borderRadius: BorderRadius.circular(8),
                    backgroundColor: customcolor.blue,
                    message: "Camera permission denied",
                    duration: const Duration(seconds: 2),
                    flushbarPosition: FlushbarPosition.TOP, // <-- Top position
                  ).show(context);

                  return;
                }

                // Open custom camera capture screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CameraCaptureScreen(
                      onImageCaptured: (String imagePath) {
                        // Update UI after capture
                        setState(() {
                          selectedImage = File(imagePath);
                          String fileName = selectedImage!.path.split('/').last;
                          print("Captured: $fileName");
                        });

                        // Pop camera screen and return image path if needed
                        // Navigator.pop(context, imagePath);
                      },
                    ),
                  ),
                );

                // Return immediately after opening camera
                return;
              },
            ),

            // ListTile(
            //   leading: Icon(Icons.photo_library_outlined),
            //   title: Text('Choose from Gallery'),
            //   onTap: () async {
            //     Navigator.pop(context);
            //     final result =
            //         await FilePicker.platform.pickFiles(type: FileType.image);
            //     if (result != null && result.files.single.path != null) {
            //       setState(
            //           () => selectedImage = File(result.files.single.path!));
            //     }
            //   },
            // ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choose from Gallery'),
              onTap: widget.isEdit == true
                  ? null
                  : () async {
                      Navigator.pop(context);

                      final ImagePicker picker = ImagePicker();
                      final XFile? pickedFile = await picker.pickImage(
                        source: ImageSource.gallery,
                      );

                      if (pickedFile != null) {
                        setState(() {
                          selectedImage = File(pickedFile.path);
                        });
                      }
                    },
            ),
          ],
        );
      },
    );
  }

  String get formattedDate => selectedDate == null
      ? ''
      : '${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}';

  String get formattedTime => selectedTime == null
      ? ''
      : '${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}';
  bool isSubmitHandle = false;

  Future<String> convertToBase64(File file) async {
    List<int> imageBytes = await file.readAsBytes();
    return base64Encode(imageBytes);
  }

  Future<void> handleSubmit() async {
    // ✅ VALIDATIONS
    if (siteNameController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please enter site')));
      return;
    }

    if (visitTypeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please select visit type')));
      return;
    }

    if ((lat == null || lat == 0) || (long == null || long == 0)) {
      grantPermission();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please allow location')));
      return;
    }

    if (workflowValue == null) {
      ShowDialogs.showToast("Please select workflow option");
      return;
    }

    // ✅ SELECTED ITEMS
    List selectedItems = visitCategories
        .expand((cat) => cat.items)
        .where((item) => item.isSelected)
        .toList();

    if (selectedItems.isEmpty) {
      ShowDialogs.showToast("Please select at least one visit type");
      return;
    }

    // for (var item in selectedItems) {
    //   if (item.image == null) {
    //     ShowDialogs.showToast("Please upload image for ${item.name}");
    //     return;
    //   }
    // }
    for (var category in visitCategories) {
      if (category.items.isEmpty) {
        if (category.isSelected && category.image == null) {
          ShowDialogs.showToast("Please upload image for ${category.name}");
          return;
        }
      } else {
        for (var item in category.items) {
          if (item.isSelected && item.image == null) {
            ShowDialogs.showToast("Please upload image for ${item.name}");
            return;
          }
        }
      }
    }
    var isConnected = await ConnectionDetector.checkInternetConnection();
    var roles = await SPManager().getsupervisorid();

    // ✅ BUILD visiting_image ARRAY
    List<Map<String, dynamic>> visitingImageList = [];

    for (var category in visitCategories) {
      /// ✅ CATEGORY WITHOUT ITEMS
      if (category.items.isEmpty) {
        if (category.isSelected == true && category.image != null) {
          String base64Image = await convertToBase64(category.image!);
          visitingImageList.add({
            "training_visit_id": int.parse(category.id),
            "image": "data:image/jpeg;base64,$base64Image",
          });
        }
      }

      /// ✅ CATEGORY WITH ITEMS
      for (var item in category.items) {
        if (item.isSelected && item.image != null) {
          String base64Image = await convertToBase64(item.image!);
          visitingImageList.add({
            "training_visit_id": int.parse(item.id),
            "image": "data:image/jpeg;base64,$base64Image",
          });
        }
      }
    }
    // List<Map<String, dynamic>> visitingImageList = [];

    // for (var category in visitCategories) {
    //   for (var item in category.items) {
    //     if (item.isSelected &&
    //         (item.image != null || item.networkImage != null)) {
    //       String base64Image = await convertToBase64(item.image!);
    //       String finalImage = "data:image/jpeg;base64,$base64Image";
    //       visitingImageList.add({
    //         "training_visit_id": int.parse(item.id),
    //         "image": finalImage,
    //       });

    //       print("ID: ${item.id}");
    //     }
    //   }
    // }

    // ✅ FINAL PAYLOAD
    final Map<String, dynamic> payload = {
      "site_id": site_id.toString(),
      "date": formattedDate,
      "time": formattedTime,
      "visit_remarks": purposeController.text.trim(),
      "client_id": client_id.toString(),
      "emp_id": roles,
      "propose_remark": "",
      "longitude": "${long ?? 0}",
      "latitude": "${lat ?? 0}",
      "workflow_management": workflowValue == "Yes" ? "yes" : "no",
      "visiting_image": jsonEncode(visitingImageList ?? []),
      //  visitingImageList,
    };

    print("FINAL JSON: ${jsonEncode(payload)}");

    // ✅ API CALL
    if (isConnected) {
      setState(() => isSubmitHandle = true);

      try {
        var response = await http.post(
          Uri.parse(APIManager.submitoperation),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(payload),
        );

        print("STATUS CODE: ${response.statusCode}");
        print("RESPONSE: ${response.body}");

        var res = jsonDecode(response.body);

        if (res['status'] == 1) {
          ShowDialogs.showToast(res['msg']);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => ClientOperationVisitCard(
                site_id: site_id,
                client_id: client_id,
              ),
            ),
          );
        } else {
          ShowDialogs.showToast(res['msg'] ?? "Submission failed");
          setState(() => isSubmitHandle = false);
        }
      } catch (e) {
        print("ERROR: $e");
        setState(() => isSubmitHandle = false);
        ShowDialogs.showToast("Error: ${e.toString()}");
      }
    } else {
      // ✅ OFFLINE SAVE (OPTIONAL FIX)
      await DBHelper.insertOfflineRequest(
        '${Global.baseUrl}/api/siteconfigurator/add_information',
        payload.map((k, v) => MapEntry(k, v.toString())),
        supporting_image: [],
        isMultipart: false, // 🔥 IMPORTANT CHANGE
      );
      print("ERROR: ");
      setState(() => isSubmitHandle = false);
      ShowDialogs.showToast("Saved offline. Will sync later.");
    }
  }

  Widget visitTypeDropdown(StateSetter setStateDialog) {
    // Static values for visit type
    final List<String> visitTypes = [
      // "Training Visit",
      // "Operational Visit",
      // "Regular Visit",
      "Training",
      "Process",
      "Workflow",
      "Chemical",
      "Consumables",
    ];

    return Container(
      height: 150, // Adjust height if needed
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Card(
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: ListView.builder(
            itemCount: visitTypes.length,
            itemBuilder: (BuildContext context, int index) {
              final type = visitTypes[index];
              return Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      setStateDialog(() {
                        visitTypeController.text = type; //  no error now
                        selectedVisitType = type;
                        isExpandedVisitType = false;
                        //  collapse dropdown
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Container(
                        color: Colors.white,
                        width: double.infinity,
                        child: Text(
                          type,
                          style: AppFonts.headerStyle(
                            fontSize: 14,
                            color: customcolor.black,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Divider(color: customcolor.greybg),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  String? selectedVisitType;
  bool isExpandedVisitType = false;

  InputDecoration customInputDecoration(String label) {
    return InputDecoration(
      hintText: label,
      filled: true,
      fillColor: Colors.white, // Optional: set consistent fill color
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: customcolor.greyborder, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: customcolor.greyborder, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: customcolor.blue, // Highlight color on focus
          width: 2,
        ),
      ),
    );
  }

  Widget sectionTitle(String text, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: customcolor.blue),
        SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: customcolor.blue,
          ),
        ),
      ],
    );
  }

  bool isExpandedSite = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey2,
      backgroundColor: Colors.grey.shade100,
      bottomNavigationBar: CustomBottomNavigationBar(index: -1),
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        //Floating action button on Scaffold
        backgroundColor: customcolor.white,
        onPressed: () {
          Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.fade,
              child: HomePage(),
              duration: Duration(milliseconds: 300),
            ),
          );
        },
        child: Image.asset(
          "assets/images/greyhome.png",
          color: customcolor.greytext,
          width: 20,
          height: 20,
        ), //icon inside button
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      endDrawer: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: customcolor.blue,
          primaryColor: customcolor.blue,
        ),
        child: AppDrawerfilter(widget.role),
      ),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(148),
        child: AppbarComman(
          setStyleStr: 'Operations Visit',
          onPressedBack: () {},
          onPressedNotify: () {},
          onPressedSearch: () {},
          onPressedSort: () {},
          onPressedmenu: () {
            _scaffoldKey2.currentState!.openEndDrawer();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          // height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        // Navigator.push(
                        //   context,
                        //   PageRouteBuilder(
                        //     pageBuilder: (context,
                        //             animation1,
                        //             animation2) =>
                        //         HomePage(),
                        //   ),
                        // );
                      },
                      child: Icon(Icons.arrow_back),
                    ),
                    SizedBox(width: 10),
                    Container(
                      child: Text(
                        "SITE INFORMATION",
                        style: AppFonts.headerStyle(
                          fontSize: ResponsiveFlutter.of(context).fontSize(2.3),
                          color: customcolor.black,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // sectionTitle("Site Information", Icons.location_on),
                      SizedBox(height: 20),
                      GestureDetector(
                        onTap: widget.isEdit == true
                            ? null
                            : () {
                                setState(() {
                                  isExpandedSite = !isExpandedSite;
                                });
                              },
                        child: FormTextField(
                          isEnable: false,
                          textcontroller: siteNameController,
                          contaninerheigth: 48,
                          placeholderStr: "Select Site",
                          textInputType: TextInputType.text,
                          onchange: (val) {},
                          suffixWidget: Padding(
                            padding: EdgeInsets.only(right: 20),
                            child: Image.asset(
                              "assets/images/dropdown.png",
                              width: 10,
                              height: 10,
                            ),
                          ),
                        ),
                      ),
                      if (isExpandedSite)
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: siteDropdown(setState),
                        ),
                      SizedBox(height: 16),
                      // GestureDetector(
                      //   onTap: () {
                      //     setState(() {
                      //       isExpandedVisitType =
                      //           !isExpandedVisitType; // toggle dropdown
                      //     });
                      //   },
                      //   child: FormTextField(
                      //     isEnable: false,
                      //      contaninerheigth: 48,
                      //     textcontroller: visitTypeController,
                      //     placeholderStr: "Select Visit Type",
                      //     textInputType: TextInputType.text,
                      //     onchange: (val) {},
                      //     suffixWidget: Padding(
                      //       padding: EdgeInsets.only(right: 20),
                      //       child: Image.asset(
                      //         "assets/images/dropdown.png",
                      //         width: 10,
                      //         height: 10,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // if (isExpandedVisitType)
                      // SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: widget.isEdit == true ? null : pickDate,
                              child: AbsorbPointer(
                                child: TextFormField(
                                  decoration: customInputDecoration(
                                    formattedDate.isEmpty
                                        ? 'Select Date'
                                        : formattedDate,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: GestureDetector(
                              onTap: widget.isEdit == true ? null : pickTime,
                              child: AbsorbPointer(
                                child: TextFormField(
                                  decoration: customInputDecoration(
                                    formattedTime.isEmpty
                                        ? 'Select Time'
                                        : formattedTime,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Visit Type",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),

                      SizedBox(height: 10),
                      visitTypeDropdownUI(),

                      workflowUI(),

                      selectedItemsUI(),

                      SizedBox(height: 30),
                      widget.isEdit == true
                          ? Container()
                          : SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  handleSubmit();
                                },
                                icon: isSubmitHandle
                                    ? Container()
                                    : Icon(Icons.check_circle),
                                label: isSubmitHandle
                                    ? CircularProgressIndicator(
                                        color: customcolor.white,
                                      )
                                    : Text("Submit Visit Details"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: customcolor.blue,
                                  padding: EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  textStyle: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> getVisitDropdownApi() async {
    try {
      final response = await http.get(
        Uri.parse(
          "${APIManager.baseURL}/api/siteconfigurator/training_visit_dropdown_api",
        ),
      );

      if (response.statusCode == 200) {
        final res = json.decode(response.body);

        if (res['status'] == 1) {
          List data = res['data'];

          List<VisitCategory> tempList = [];

          for (var category in data) {
            List<VisitItem> items = [];

            for (var item in category['dropdown_value']) {
              items.add(
                VisitItem(name: item['name'], id: item['id'].toString()),
              );
            }

            tempList.add(
              VisitCategory(
                name: category['name'],
                icon: getIcon(category['name']), // 👇 dynamic icon
                items: items,
                id: category['id'].toString(),
              ),
            );
          }

          setState(() {
            visitCategories = tempList;
          });

          print("✅ API Binded Successfully");
          if (widget.isEdit == true) {
            bindExistingImages();
          }
        }
      } else {
        print("❌ API Failed");
      }
    } catch (e) {
      print("❌ ERROR: $e");
    }
  }
  // void bindExistingImages() {
  //   if (widget.visit == null || widget.visit.trainingImages == null) return;

  //   List images = widget.visit.trainingImages;

  //   for (var category in visitCategories) {

  //     /// =========================
  //     /// ✅ CATEGORY WITHOUT ITEMS
  //     /// =========================
  //     if (category.items.isEmpty) {
  //       for (var img in images) {
  //         if (category.id == img.trainingVisitId.toString()) {

  //           /// ✅ MARK CATEGORY SELECTED
  //           category.isSelected = true;

  //           /// ✅ SET NETWORK IMAGE
  //           category.networkImage = img.imageUrl;
  //         }
  //       }
  //     }

  //     /// =========================
  //     /// ✅ CATEGORY WITH ITEMS
  //     /// =========================
  //     for (var item in category.items) {
  //       for (var img in images) {
  //         if (item.id == img.trainingVisitId.toString()) {

  //           /// ✅ MARK ITEM SELECTED
  //           item.isSelected = true;

  //           /// ✅ SET NETWORK IMAGE
  //           item.networkImage = img.imageUrl;
  //         }
  //       }
  //     }
  //   }

  //   /// ✅ UPDATE TEXT FIELD
  //   updateVisitTypeText();

  //   setState(() {});
  // }
  void bindExistingImages() {
    if (widget.visit == null || widget.visit.trainingImages == null) return;

    List images = widget.visit.trainingImages;

    for (var category in visitCategories) {
      bool hasSelection = false; // 👈 track selection

      /// ✅ CATEGORY WITHOUT ITEMS
      if (category.items.isEmpty) {
        for (var img in images) {
          if (category.id == img.trainingVisitId.toString()) {
            category.isSelected = true;
            category.networkImage = img.imageUrl;
            hasSelection = true;
          }
        }
      }

      /// ✅ CATEGORY WITH ITEMS
      for (var item in category.items) {
        for (var img in images) {
          if (item.id == img.trainingVisitId.toString()) {
            item.isSelected = true;
            item.networkImage = img.imageUrl;
            hasSelection = true;
          }
        }
      }

      /// 🔥 AUTO EXPAND IN EDIT MODE
      if (widget.isEdit == true && hasSelection) {
        category.isExpanded = true;
      }
    }

    updateVisitTypeText();
    setState(() {});
  }
  // void bindExistingImages() {
  //   if (widget.visit == null || widget.visit.trainingImages == null) return;

  //   List images = widget.visit.trainingImages;

  //   for (var category in visitCategories) {
  //     for (var item in category.items) {
  //       for (var img in images) {
  //         if (item.id == img.trainingVisitId.toString()) {
  //           /// ✅ MARK SELECTED
  //           item.isSelected = true;

  //           /// ✅ STORE NETWORK IMAGE URL
  //           item.networkImage = img.imageUrl;
  //         }
  //       }
  //     }
  //   }

  //   /// ✅ UPDATE TEXT FIELD
  //   updateVisitTypeText();

  //   setState(() {});
  // }

  IconData getIcon(String name) {
    switch (name.toLowerCase()) {
      case "training":
        return Icons.school;
      case "process":
        return Icons.engineering;
      case "chemical":
        return Icons.science;
      case "consumables":
        return Icons.inventory_2;
      case "workflow management at site":
        return Icons.settings;
      default:
        return Icons.category;
    }
  }

  Widget siteDropdown(StateSetter setStateDialog) {
    return Container(
      height: 150, // Adjust height as needed
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Card(
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: ListView.builder(
            itemCount: GlobalLists.sitedropdown.length,
            itemBuilder: (BuildContext context, int index) {
              final site = GlobalLists.sitedropdown[index];
              return Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      setStateDialog(() {
                        siteNameController.text = site.clientName ?? '';
                        selectedSite = site.siteId.toString();
                        clientId = site.clientId.toString();
                        client_id = site.clientId;
                        site_id = site.siteId;
                        isExpandedSite = false;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Container(
                        color: Colors.white,
                        width: double.infinity,
                        child: Text(
                          site.clientName ?? '',
                          style: AppFonts.headerStyle(
                            fontSize: 14,
                            color: customcolor.black,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Divider(color: customcolor.greybg),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  siteDropDown() async {
    var status1 = await ConnectionDetector.checkInternetConnection();
    var roles = await SPManager().getsupervisorid();
    var clientid = await SPManager().getclientid();

    String today = DateTime.now()
        .toLocal()
        .toString()
        .split(' ')[0]
        .split('-')
        .reversed
        .join('-'); // dd-MM-yyyy

    var map = new Map<String, dynamic>();
    // map['date_today']=today;
    // map['client_id']=clientid;

    if (role == GlobalLists.clientrole) {
      map['date_today'] = today;
      map['client_id'] = clientid;
    } else {
      map['supervisor'] = roles;
      map['date_today'] = today;
    }

    print("Site Dropdown Request: $map");

    if (status1) {
      // ✅ Online: Fetch from API
      APIManager().apiRequest(
        context,
        API.sitedropdown,
        (response) async {
          SiteDropDown resp = response;

          print(' SiteDropDown resp ${resp}');
          if (resp.status == 1) {
            setState(() {
              GlobalLists.sitedropdown = resp.data ?? [];
            });

            // ✅ Save to local storage
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString(
              'cached_site_dropdown',
              siteDropDownToJson(resp),
            );
          } else {
            ShowDialogs.showToast(resp.msg.toString());
          }
        },
        (error) {
          print('API Error: $error');
        },
        false,
        "",
        jsonval: map,
      );
    } else {
      // 🚫 Offline: Load from local cache
      final prefs = await SharedPreferences.getInstance();
      String? cachedData = prefs.getString('cached_site_dropdown');

      if (cachedData != null) {
        SiteDropDown cachedResponse = siteDropDownFromJson(cachedData);
        setState(() {
          GlobalLists.sitedropdown = cachedResponse.data ?? [];
        });
        ShowDialogs.showToast("Offline data loaded");
      } else {
        ShowDialogs.showToast("No internet and no offline data available");
      }
    }
  }
}
