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
  OperationVisitPage(this.role);

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
      // ✅ Already granted
      print("Location permission granted");
      getLocation();
    } else if (status.isDenied) {
      // ⚠️ User has not granted permission yet — ask for it
      print("Requesting location permission...");
      var result = await permishan.Permission.location.request();

      if (result.isGranted) {
        print("User granted location permission");
        getLocation();
      } else if (result.isPermanentlyDenied) {
        print("Permission permanently denied");
        ShowDialogs.showToast(
            "Please allow location permission from settings to continue");
        await permishan.openAppSettings();
      } else {
        print("Permission denied by user");
        ShowDialogs.showToast("Location permission is required to add visits");
      }
    } else if (status.isPermanentlyDenied) {
      // 🚫 User selected “Don’t ask again”
      print("Permission permanently denied");
      ShowDialogs.showToast(
          "Please allow location permission from settings to continue");
      await permishan.openAppSettings();
    } else if (status.isRestricted || status.isLimited) {
      print("Permission restricted/limited");
      ShowDialogs.showToast(
          "Please allow location permission from settings to continue");
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
        'siteNameController.text ${siteNameController.text} GlobalLists.clientname ${GlobalLists.clientname}GlobalLists.visitSiteId${GlobalLists.visitSiteId}');

    getrole();
    DateTime now = DateTime.now();
    selectedDate = DateTime.now();
    selectedTime = TimeOfDay.now();
     getVisitDropdownApi();
  //    visitCategories = [
  //   VisitCategory(
  //     name: "Training",
  //     icon: Icons.school,
  //     items: [
  //       VisitItem(name: "Onboarding"),
  //       VisitItem(name: "Safety Training"),
  //       VisitItem(name: "Equipment Handling"),
  //     ],
  //   ),
  //   VisitCategory(
  //     name: "Process",
  //      icon: Icons.engineering,
  //     items: [
  //       VisitItem(name: "Dry Mopping"),
  //       VisitItem(name: "Wet Mopping"),
  //       VisitItem(name: "Glass Cleaning"),
  //     ],
  //   ),
  //   VisitCategory(
  //     name: "Chemical",
  //       icon: Icons.science,
  //     items: [
  //       VisitItem(name: "R2"),
  //       VisitItem(name: "Marble Check"),
  //     ],
  //   ),
  //   VisitCategory(
  //     name: "Consumables",
  //       icon: Icons.inventory_2,
  //     items: [
  //       VisitItem(name: "Microfiber Duster"),
  //       VisitItem(name: "Color Coding"),
  //       VisitItem(name: "Microfiber Mops"),
  //     ],
  //   ),
  //   // VisitCategory(
  //   //   name: "Workflow",
  //   //   items: [
  //   //     VisitItem(name: "Yes"),
  //   //     VisitItem(name: "No"),
    
  //   //   ],
  //   // ),
  // ];
    super.initState();
  }
Widget selectedItemsUI() {
  List<Map<String, dynamic>> selectedItemsWithCategory = [];

  for (var category in visitCategories) {
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
      Text("Selected Visit Details",
          style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 10),

      ...selectedItemsWithCategory.map((data) {
        VisitItem item = data["item"];
        String categoryName = data["category"];

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
              onTap: () async {
                final picked = await ImagePicker()
                    .pickImage(source: ImageSource.gallery);

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
                child: item.image != null
                    ? Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(item.image!,
                                width: double.infinity,
                                fit: BoxFit.cover),
                          ),
                          Positioned(
                            right: 5,
                            top: 5,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  item.image = null;
                                });
                              },
                              child: Icon(Icons.cancel, color: Colors.red),
                            ),
                          )
                        ],
                      )
                    : Center(
                        child: Icon(Icons.camera_alt,
                            color: customcolor.blue),
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
                onChanged: (val) {
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
                onChanged: (val) {
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

      /// ✅ SHOW IMAGE ONLY IF YES
      // if (workflowValue == "Yes")
      //   Column(
      //     children: [
      //       SizedBox(height: 10),

      //       GestureDetector(
      //         onTap: pickImage,
      //         child: Container(
      //           height: 120,
      //           width: double.infinity,
      //           decoration: BoxDecoration(
      //             borderRadius: BorderRadius.circular(10),
      //             border: Border.all(color: Colors.grey),
      //           ),
      //           child: selectedImage != null
      //               ? Stack(
      //                   children: [
      //                     ClipRRect(
      //                       borderRadius: BorderRadius.circular(10),
      //                       child: Image.file(
      //                         selectedImage!,
      //                         width: double.infinity,
      //                         fit: BoxFit.cover,
      //                       ),
      //                     ),

      //                     /// ✅ TICK ICON
      //                     Positioned(
      //                       right: 5,
      //                       top: 5,
      //                       child: Icon(Icons.check_circle,
      //                           color: Colors.green),
      //                     ),
      //                   ],
      //                 )
      //               : Center(
      //                   child: Row(
      //                     mainAxisAlignment: MainAxisAlignment.center,
      //                     children: [
      //                     Icon(Icons.camera_alt,
      //                       color: customcolor.blue),
      //                       SizedBox(width: 5,),
      //                       Text("Upload Workflow Image"),
      //                     ],
      //                   ),
      //                 ),
      //         ),
      //       ),
      //     ],
      //   ),
    ],
  );
}
void updateVisitTypeText() {
  List<VisitItem> selectedItems = visitCategories
      .expand((cat) => cat.items)
      .where((item) => item.isSelected)
      .toList();

  visitTypeController.text =
      selectedItems.map((e) => e.name).join(", ");
}
Widget visitTypeDropdownUI() {
  return ListView.builder(
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    itemCount: visitCategories.length,
    itemBuilder: (context, index) {
      final category = visitCategories[index];

      int selectedCount =
          category.items.where((e) => e.isSelected).length;

      return Container(
        margin: EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 2),
            )
          ],
        ),
        child: Column(
          children: [

            /// 🔷 HEADER
            InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () {
                setState(() {
                  category.isExpanded = !category.isExpanded;
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [

                    /// 🔷 LEFT ICON
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: customcolor.blue.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                       category.icon, // you can change per category
                        color: customcolor.blue,
                        size: 20,
                      ),
                    ),

                    SizedBox(width: 12),

                    /// 🔷 TITLE + COUNT
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            category.name,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                          if (selectedCount > 0)
                            Text(
                              "$selectedCount selected",
                              style: TextStyle(
                                  color: Colors.grey, fontSize: 12),
                            ),
                        ],
                      ),
                    ),

                    /// 🔽 ARROW
                    Icon(
                      category.isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),

            /// 🔷 ITEMS
            AnimatedCrossFade(
              firstChild: SizedBox(),
              secondChild: Column(
                children: category.items.map((item) {
                  return Column(
                    children: [

                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        child: Row(
                          children: [

                            /// ✅ ROUND CHECKBOX STYLE
                            GestureDetector(
                              onTap: () {
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
                                          : Colors.grey),
                                  color: item.isSelected
                                      ? customcolor.green
                                      : Colors.transparent,
                                ),
                                child: item.isSelected
                                    ? Icon(Icons.check,
                                        size: 16,
                                        color: Colors.white)
                                    : null,
                              ),
                            ),

                            SizedBox(width: 12),

                            /// 🔷 ITEM NAME
                            Expanded(
                              child: Text(item.name),
                            ),

                            /// 📷 CAMERA / ✅ TICK
                            GestureDetector(
                              onTap: () async {
                                if (!item.isSelected) {
                                  ShowDialogs.showToast(
                                      "Select item first");
                                  return;
                                }

                                final picked = await ImagePicker()
                                    .pickImage(
                                        source: ImageSource.gallery);

                                if (picked != null) {
                                  setState(() {
                                    item.image = File(picked.path);
                                  });
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  item.image != null
                                      ? Icons.check_circle
                                      : Icons.camera_alt,
                                  color: item.image != null
                                      ? Colors.green
                                      : Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// 🖼 IMAGE BELOW
                      // if (item.isSelected && item.image != null)
                      //   Padding(
                      //     padding: const EdgeInsets.symmetric(
                      //         horizontal: 12, vertical: 6),
                      //     child: Stack(
                      //       children: [
                      //         ClipRRect(
                      //           borderRadius: BorderRadius.circular(10),
                      //           child: Image.file(
                      //             item.image!,
                      //             height: 100,
                      //             width: double.infinity,
                      //             fit: BoxFit.cover,
                      //           ),
                      //         ),
                      //         Positioned(
                      //           right: 5,
                      //           top: 5,
                      //           child: GestureDetector(
                      //             onTap: () {
                      //               setState(() {
                      //                 item.image = null;
                      //               });
                      //             },
                      //             child: Icon(Icons.cancel,
                      //                 color: Colors.red),
                      //           ),
                      //         )
                      //       ],
                      //     ),
                      //   ),

                      // Divider(height: 1),
                    ],
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
      );
    },
  );
}
// Widget visitTypeDropdownUI() {
//   return Container(
//     height: 350,
//     child: Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12)),
//       child: Column(
//         children: [

//           /// ✅ SCROLLABLE LIST
//           Expanded(
//             child: ListView.builder(
//               itemCount: visitCategories.length,
//               itemBuilder: (context, index) {
//                 final category = visitCategories[index];

//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [

//                     /// 🔹 CATEGORY HEADER
//                     ListTile(
//                       title: Text(
//                         category.name,
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       trailing: Icon(
//                         category.isExpanded
//                             ? Icons.keyboard_arrow_up
//                             : Icons.keyboard_arrow_down,
//                       ),
//                       onTap: () {
//                         setState(() {
//                           category.isExpanded = !category.isExpanded;
//                         });
//                       },
//                     ),

//                     /// 🔹 ITEMS
//                     if (category.isExpanded)
//                       ...category.items.map((item) {
//                         return Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [

//                             /// ✅ ROW: CHECKBOX + TEXT + CAMERA/TICK ICON
//                             Row(
//                               children: [
//                               Padding(
//                                 padding: const EdgeInsets.only(left: 20),
//                                 child: SizedBox(
//                                   width: 24,
//                                   height: 24,
//                                   child: Transform.scale(
//                                     scale: 0.9, // 🔽 reduce size slightly
//                                     child: Checkbox(
//                                       value: item.isSelected,
//                                       activeColor: customcolor.green,
//                                       materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, // 🔥 removes default padding
//                                       visualDensity: VisualDensity.compact, // 🔥 reduces inner spacing
//                                       onChanged: (val) {
//                                         setState(() {
//                                           item.isSelected = val!;
                                
//                                           if (!item.isSelected) {
//                                             item.image = null;
//                                           }
                                
//                                           updateVisitTypeText();
//                                         });
//                                       },
//                                     ),
//                                   ),
//                                 ),
//                               ),

//                                 Expanded(
//                                   child: Text(item.name),
//                                 ),

//                                 /// ✅ CAMERA / TICK ICON
//                                 GestureDetector(
//                                   onTap: () async {
//                                     if (!item.isSelected) {
//                                       ShowDialogs.showToast(
//                                           "Please select item first");
//                                       return;
//                                     }

//                                     final picked = await ImagePicker()
//                                         .pickImage(
//                                             source: ImageSource.gallery);

//                                     if (picked != null) {
//                                       setState(() {
//                                         item.image = File(picked.path);
//                                       });
//                                     }
//                                   },
//                                   child: Padding(
//                                     padding: const EdgeInsets.only(right: 12),
//                                     child: Icon(
//                                       item.image != null
//                                           ? Icons.check_circle
//                                           : Icons.camera_alt,
//                                       color: item.image != null
//                                           ? Colors.green
//                                           : Colors.grey,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),

//                             /// ✅ IMAGE PREVIEW BELOW
//                             // if (item.isSelected && item.image != null)
//                             //   Padding(
//                             //     padding: const EdgeInsets.symmetric(
//                             //         horizontal: 12, vertical: 6),
//                             //     child: Stack(
//                             //       children: [
//                             //         ClipRRect(
//                             //           borderRadius:
//                             //               BorderRadius.circular(8),
//                             //           child: Image.file(
//                             //             item.image!,
//                             //             width: double.infinity,
//                             //             height: 100,
//                             //             fit: BoxFit.cover,
//                             //           ),
//                             //         ),

//                             //         /// ❌ REMOVE IMAGE BUTTON
//                             //         Positioned(
//                             //           right: 5,
//                             //           top: 5,
//                             //           child: GestureDetector(
//                             //             onTap: () {
//                             //               setState(() {
//                             //                 item.image = null;
//                             //               });
//                             //             },
//                             //             child: Icon(Icons.cancel,
//                             //                 color: Colors.red),
//                             //           ),
//                             //         )
//                             //       ],
//                             //     ),
//                             //   ),

//                             Divider(),
//                           ],
//                         );
//                       }).toList(),
//                   ],
//                 );
//               },
//             ),
//           ),

//           /// ✅ SUBMIT BUTTON
//           // Padding(
//           //   padding: const EdgeInsets.all(8.0),
//           //   child: GestureDetector(
//           //     onTap: () {
//           //       setState(() {
//           //         isExpandedVisitType = false;
//           //       });
//           //     },
//           //     child: Container(
//           //       width: double.infinity,
//           //       padding: EdgeInsets.symmetric(vertical: 12),
//           //       decoration: BoxDecoration(
//           //         color: customcolor.blue,
//           //         borderRadius: BorderRadius.circular(8),
//           //       ),
//           //       child: Center(
//           //         child: Text(
//           //           "Submit",
//           //           style: TextStyle(color: Colors.white),
//           //         ),
//           //       ),
//           //     ),
//           //   ),
//           // ),
//         ],
//       ),
//     ),
//   );
// }
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
      desiredAccuracy: LocationAccuracy.high);

  print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');

  // Get placemarks (address) from coordinates
  List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude, position.longitude);

  if (placemarks.isEmpty) {
    throw Exception("No address found for this location");
  }

  Placemark first = placemarks.first;

   lat = position.latitude.toString();
   long = position.longitude.toString();

  print("${first.name} : ${first.street}, ${first.locality}, ${first.country}");

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
            // ListTile(
            //   leading: Icon(Icons.camera_alt_outlined),
            //   title: Text('Take Photo'),
            //   onTap: () async {
            //     Navigator.pop(context);
            //     final pickedFile =
            //         await ImagePicker().pickImage(source: ImageSource.camera);
            //     if (pickedFile != null) {
            //       setState(() => selectedImage = File(pickedFile.path));
            //     }
            //   },
            // ),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Take Photo'),
              onTap: () async {
                Navigator.pop(context); // close dialog first

                // Ask for camera permission
                bool hasPermission =
                    await PermissionHelper.requestPermission(Permission.camera);

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
  onTap: () async {
    Navigator.pop(context);

    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

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
//   handleSubmit() async {
//     if (siteNameController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Please enter site'),
//           behavior: SnackBarBehavior.floating,
//           margin: EdgeInsets.only(bottom: 30, left: 16, right: 16),
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         ),
//       );
//       return;
//     } else if (visitTypeController.text.trim().isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Please select visit type '),
//           behavior: SnackBarBehavior.floating,
//           margin: EdgeInsets.only(bottom: 80, left: 16, right: 16),
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         ),
//       );
//       return;
//     }
//     //  else if (selectedImage == null || selectedImage == '') {
//     //   ScaffoldMessenger.of(context).showSnackBar(
//     //     SnackBar(
//     //       content: Text('Please upload supporting image'),
//     //       behavior: SnackBarBehavior.floating,
//     //       margin: EdgeInsets.only(bottom: 80, left: 16, right: 16),
//     //       shape:
//     //           RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//     //     ),
//     //   );
//     //   return;
//     // }
//      else if ((lat == null || lat == 0) || long == null || long == 0) {
//       grantPermission();
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Please allow location'),
//           behavior: SnackBarBehavior.floating,
//           margin: EdgeInsets.only(bottom: 80, left: 16, right: 16),
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         ),
//       );
//       return;
//     }
// // ✅ WORKFLOW VALIDATION
// if (workflowValue == null) {
//   ShowDialogs.showToast("Please select workflow option");
//   return;
// }

// // ✅ CHECK SELECTED ITEMS
// List selectedItems = visitCategories
//     .expand((cat) => cat.items)
//     .where((item) => item.isSelected)
//     .toList();

// if (selectedItems.isEmpty) {
//   ShowDialogs.showToast("Please select at least one visit type");
//   return;
// }

// // ✅ CHECK IMAGE FOR EACH SELECTED ITEM
// for (var item in selectedItems) {
//   if (item.image == null) {
//     ShowDialogs.showToast("Please upload image for ${item.name}");
//     return;
//   }
// }

// // ✅ WORKFLOW IMAGE IF YES
// // if (workflowValue == "Yes" && selectedImage == null) {
// //   ShowDialogs.showToast("Please upload workflow image");
// //   return;
// // }
//     var isConnected = await ConnectionDetector.checkInternetConnection();
//     var roles = await SPManager().getsupervisorid();
// List<Map<String, dynamic>> visitingImageList = [];

// for (var category in visitCategories) {
//   for (var item in category.items) {
//     if (item.isSelected && item.image != null) {

//       String base64Image = await convertToBase64(item.image!);

//       visitingImageList.add({
//         "training_visit_id": item.id,
//         "image": base64Image, // already base64
//       });

//       print("ID: ${item.id}");
//     }
//   }
// }
//     // Build payload with nullable values
//     final Map<String, dynamic> payload = {
//       "site_id": site_id.toString(),
//       "date": formattedDate,
//       "time": formattedTime,
//       "visit_remarks": purposeController.text.trim(),
//       "client_id": client_id.toString(),
//       "emp_id": roles,
//       "propose_remark": "",//visitTypeController.text.trim(),
//       'longitude': "${long ?? 0}",
//       "latitude": "${lat ?? 0}",
//         "workflow_management": workflowValue == "Yes" ? "yes" : "no",
//         "visiting_image": visitingImageList,
//     };

//     print('payload ${payload}');

//     // Log safe payload

//     if (isConnected) {
//       // ShowDialogs.showLoadingDialog(context, _submitkeyLoader);
//       setState(() {
//         isSubmitHandle = true;
//       });
//       try {
//         var request = http.MultipartRequest(
//           "POST",
//           Uri.parse(APIManager.submitoperation),
//         );

//         // Convert payload to Map<String, String>
//         request.fields.addAll(
//           payload.map((key, value) => MapEntry(key, value ?? '')),
//         );

//         // Add image if selected
//         // if (selectedImage != null) {
//         //   request.files.add(await http.MultipartFile.fromPath(
//         //     "supporting_image",
//         //     selectedImage!.path,
//         //   ));
//         // }
// // ✅ ADD SELECTED ITEMS WITH INDEX
// // int index = 0;

// // for (var category in visitCategories) {
// //   for (var item in category.items) {
// //     if (item.isSelected && item.image != null) {

// //       // Convert image to base64
// //       String base64Image = await convertToBase64(item.image!);

// //       // Send ID
// //       request.fields["visiting_image[$index][training_visit_id]"] =
// //           item.id.toString();

// //       // Send Base64 instead of file
// //       request.fields["visiting_image[$index][image]"] =
// //           base64Image;

// //       index++;

// //       print("ID: ${item.id}");
// //       print("BASE64 LENGTH: ${base64Image.length}");
// //     }
// //   }
// // }
// // print(request.files);
//         // Send request
//         var response = await request.send();
//         final respStr = await response.stream.bytesToString();
//         var res = json.decode(respStr);

//         print('res $res');

//         // Navigator.pop(context); // hide loader

//         if (res['status'] == 1) {
//           ShowDialogs.showToast(res['msg']);
//           Navigator.pushReplacement(
//             context,
//             // MaterialPageRoute(builder: (_) => ClientOperationVisitCard()),
//             MaterialPageRoute(
//                 builder: (_) => ClientOperationVisitCard(
//                       site_id: site_id,
//                       client_id: client_id,
//                     )),
//           );
//         } else {
//           print(res['msg']);
//           ShowDialogs.showToast(res['msg'] ?? "Submission failed.");
//           setState(() {
//             isSubmitHandle = false;
//           });
//           // Navigator.pop(context);
//         }
//       } catch (e) {
//         print('errro ${e}');
//         setState(() {
//           isSubmitHandle = false;
//         });
//         // Navigator.pop(context);
//         ShowDialogs.showToast("Error occurred: ${e.toString()}");
//       }
//     } else {
//       /// 🔁 Optional: Offline save if internet not available
//       await DBHelper.insertOfflineRequest(
//         '${Global.baseUrl}/api/siteconfigurator/add_information',
//         payload.map((k, v) => MapEntry(k, v ?? '')),
//         supporting_image: selectedImage != null ? [selectedImage!.path] : [],
//         isMultipart: true,
//       );
//       print(selectedImage.toString());
//       // Navigator.pop(context);
//       setState(() {
//         isSubmitHandle = false;
//       });
//       ShowDialogs.showToast("Saved offline. Will sync when internet is back.");
//     }
//   }
Future<void> handleSubmit() async {
  // ✅ VALIDATIONS
  if (siteNameController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Please enter site')),
    );
    return;
  }

  if (visitTypeController.text.trim().isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Please select visit type')),
    );
    return;
  }

  if ((lat == null || lat == 0) || (long == null || long == 0)) {
    grantPermission();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Please allow location')),
    );
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

  for (var item in selectedItems) {
    if (item.image == null) {
      ShowDialogs.showToast("Please upload image for ${item.name}");
      return;
    }
  }

  var isConnected = await ConnectionDetector.checkInternetConnection();
  var roles = await SPManager().getsupervisorid();

  // ✅ BUILD visiting_image ARRAY
  List<Map<String, dynamic>> visitingImageList = [];

  for (var category in visitCategories) {
    for (var item in category.items) {
      if (item.isSelected && item.image != null) {
        String base64Image = await convertToBase64(item.image!);
String finalImage = "data:image/jpeg;base64,$base64Image";
        visitingImageList.add({
          "training_visit_id":int.parse(item.id),
          "image": "data:image/jpeg;base64,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"
        });

        print("ID: ${item.id}");
      }
    }
  }

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
    "visiting_image":
    jsonEncode(visitingImageList ?? []),
    //  visitingImageList,
  };

  print("FINAL JSON: ${jsonEncode(payload)}");

  // ✅ API CALL
  if (isConnected) {
    setState(() => isSubmitHandle = true);

    try {
      var response = await http.post(
        Uri.parse(APIManager.submitoperation),
        headers: {
          "Content-Type": "application/json",
        },
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
"Consumables"
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
        borderSide: BorderSide(
          color: customcolor.greyborder,
          width: 1,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: customcolor.greyborder,
          width: 1,
        ),
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
              ));
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
            canvasColor: customcolor.blue, primaryColor: customcolor.blue),
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
            }),
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
                                            Navigator.push(
                                              context,
                                              PageRouteBuilder(
                                                pageBuilder: (context,
                                                        animation1,
                                                        animation2) =>
                                                    HomePage(),
                                              ),
                                            );
                                          },
                                          child: Icon(Icons.arrow_back)),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        child: Text(
                                          "SITE INFORMATION",
                                          style: AppFonts.headerStyle(
                                              fontSize: ResponsiveFlutter.of(
                                                      context)
                                                  .fontSize(2.3),
                                              color: customcolor.black,
                                              fontWeight: FontWeight.w300),
                                        ),
                                      ),
                                    ],
                                  ),
                Padding(
                  padding: const EdgeInsets.only(left: 10,right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // sectionTitle("Site Information", Icons.location_on),
                     
                      SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
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
                              onTap: pickDate,
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
                              onTap: pickTime,
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
                        // Card(
                        //   elevation: 5,
                        //   child: Container(
                        //     height: 120, // adjust as needed
                        //     decoration: BoxDecoration(
                        //       color: Colors.white,
                        //       borderRadius: BorderRadius.circular(10),
                        //       boxShadow: [
                        //         BoxShadow(color: Colors.black12, blurRadius: 4)
                        //       ],
                        //     ),
                        //     child: ListView(
                        //       padding:
                        //           EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        //       children: [
                        //         "Training Visit",
                        //         "Operational Visit",
                        //         "Regular Visit"
                        //       ]
                        //           .map((type) => Column(
                        //                 children: [
                        //                   GestureDetector(
                        //                     onTap: () {
                        //                       setState(() {
                        //                         visitTypeController.text = type;
                        //                         selectedVisitType = type;
                        //                         isExpandedVisitType =
                        //                             false; // collapse
                        //                       });
                        //                     },
                        //                     child: Container(
                        //                       width: double.infinity,
                        //                       padding:
                        //                           EdgeInsets.symmetric(vertical: 6),
                        //                       child: Text(
                        //                         type,
                        //                         style: AppFonts.headerStyle(
                        //                           fontSize: 14,
                        //                           color: customcolor.black,
                        //                           fontWeight: FontWeight.normal,
                        //                         ),
                        //                       ),
                        //                     ),
                        //                   ),
                        //                   Divider(color: customcolor.greybg),
                        //                 ],
                        //               ))
                        //           .toList(),
                        //     ),
                        //   ),
                        // ),
                        // selectedItemsUI(),
                          workflowUI(),
                     
                      selectedItemsUI(),
                      //  SizedBox(height: 16),
                     
                      // SizedBox(height: 24),
                      // sectionTitle("Visit Details", Icons.info_outline),
                      // SizedBox(height: 12),
                      // TextFormField(
                      //   controller: purposeController,
                      //   maxLines: 2,
                      //   decoration: customInputDecoration('Remarks'),
                      // ),
                      // SizedBox(height: 16),
                      // sectionTitle("Supporting Image", Icons.image),
                      // SizedBox(height: 12),
                      // GestureDetector(
                      //   onTap: pickImage,
                      //   child: Container(
                      //     height: 150,
                      //     width: double.infinity,
                      //     decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(12),
                      //       border: Border.all(color: Colors.grey),
                      //       color: Colors.grey.shade100,
                      //     ),
                      //     child: selectedImage != null
                      //         ? ClipRRect(
                      //             borderRadius: BorderRadius.circular(10),
                      //             child: Image.file(
                      //               selectedImage!,
                      //               fit: BoxFit
                      //                   .contain, // 👈 shows full image, no cropping
                      //               width: double.infinity,
                      //               height: 150,
                      //             ),
                      //           )
                      //         : const Center(
                      //             child: Icon(
                      //               Icons.add_photo_alternate,
                      //               color: Colors.grey,
                      //               size: 40,
                      //             ),
                      //           ),
                      //   ),
                      // ),
                      //                 GestureDetector(
                      //                   onTap: pickImage,
                      //                   child: Container(
                      //                     height: 150,
                      //                     width: double.infinity,
                      //                     decoration: BoxDecoration(
                      //                       borderRadius: BorderRadius.circular(12),
                      //                       border: Border.all(color: Colors.grey),
                      //                       color: Colors.grey.shade100,
                      //                     ),
                      //                     child: selectedImage != null
                      //                         ? ClipRRect(
                          
                      //                             borderRadius: BorderRadius.circular(10),
                      //                             child:
                      //                                 Image.file(selectedImage!,    fit: BoxFit.cover,
                      // width: double.infinity,
                      // height: 150,),
                      //                           )
                      //                         : Center(
                      //                             child: Icon(
                      //                               Icons.add_photo_alternate,
                      //                               color: Colors.grey,
                      //                               size: 40,
                      //                             ),
                      //                           ),
                      //                   ),
                      //                 ),
                      SizedBox(height: 30),
                      SizedBox(
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
          "${APIManager.baseURL}/api/siteconfigurator/training_visit_dropdown_api"),
    );

    if (response.statusCode == 200) {
      final res = json.decode(response.body);

      if (res['status'] == 1) {
        List data = res['data'];

        List<VisitCategory> tempList = [];

        for (var category in data) {
          List<VisitItem> items = [];

          for (var item in category['dropdown_value']) {
            items.add(VisitItem(name: item['name'],id: item['id'].toString()));
          }

          tempList.add(
            VisitCategory(
              name: category['name'],
              icon: getIcon(category['name']), // 👇 dynamic icon
              items: items,
              id: category['id'].toString()
            ),
          );
        }

        setState(() {
          visitCategories = tempList;
        });

        print("✅ API Binded Successfully");
      }
    } else {
      print("❌ API Failed");
    }
  } catch (e) {
    print("❌ ERROR: $e");
  }
}
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
      APIManager().apiRequest(context, API.sitedropdown, (response) async {
        SiteDropDown resp = response;

        print(' SiteDropDown resp ${resp}');
        if (resp.status == 1) {
          setState(() {
            GlobalLists.sitedropdown = resp.data ?? [];
          });

          // ✅ Save to local storage
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(
              'cached_site_dropdown', siteDropDownToJson(resp));
        } else {
          ShowDialogs.showToast(resp.msg.toString());
        }
      }, (error) {
        print('API Error: $error');
      }, false, "", jsonval: map);
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

// import 'dart:async';
// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';
// import 'package:another_flushbar/flushbar.dart';
// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:geocoding/geocoding.dart';

// import 'package:geolocator/geolocator.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;
// import 'package:collection/collection.dart';
// import 'package:janpro/model/VisitTypeItem.dart';
// import 'package:page_transition/page_transition.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:permission_handler/permission_handler.dart' as permishan;

// import '../DBHelper/db_helper.dart';
// import '../Utitlity/AppDrawer.dart';
// import '../Utitlity/FormTextField.dart';
// import '../Utitlity/LocationService.dart';
// import '../Utitlity/appbar.dart';
// import '../Utitlity/customBottomNavigationBar.dart';
// import '../Utitlity/custom_color.dart';
// import '../Utitlity/APIManager.dart';
// import '../Utitlity/GlobalLists.dart';
// import '../Utitlity/SPManager.dart';
// import '../Utitlity/ShowDialog.dart';
// import '../Utitlity/internetConnection.dart';
// import '../const/global.dart';
// import '../model/SiteDropDown.dart';
// import '../services/camera_capture_screen.dart';
// import '../services/permission_helper.dart';
// import 'Homepage.dart';
// import 'OperationVisitCardPage.dart';
// import 'client_operation_visti_card.dart';
// import 'client_visit_view.dart';
// import 'package:intl/intl.dart';

// class OperationVisitPage extends StatefulWidget {
//   String? role;
//   OperationVisitPage(this.role);

//   @override
//   State<OperationVisitPage> createState() => _OperationVisitPageState();
// }

// class _OperationVisitPageState extends State<OperationVisitPage> {
//   final TextEditingController siteNameController = TextEditingController();
//   final TextEditingController visitTypeController = TextEditingController();
//   final TextEditingController purposeController = TextEditingController();
//   final TextEditingController remarkController = TextEditingController();

//   DateTime? selectedDate;
//   TimeOfDay? selectedTime;
//   File? selectedImage;
//   Route? previousRoute;
//   final ImagePicker _imagePicker = ImagePicker();
//   var role;
//   String? selectedSite;
//   String? clientId;
//   var lat;
//   var long;
//   var client_id;
//   var site_id;

//   grantPermission() async {
//     var status = await permishan.Permission.location.status;
//     print("Current Permission Status: $status");

//     if (status.isGranted) {
//       // ✅ Already granted
//       print("Location permission granted");
//       getLocation();
//     } else if (status.isDenied) {
//       // ⚠️ User has not granted permission yet — ask for it
//       print("Requesting location permission...");
//       var result = await permishan.Permission.location.request();

//       if (result.isGranted) {
//         print("User granted location permission");
//         getLocation();
//       } else if (result.isPermanentlyDenied) {
//         print("Permission permanently denied");
//         ShowDialogs.showToast(
//             "Please allow location permission from settings to continue");
//         await permishan.openAppSettings();
//       } else {
//         print("Permission denied by user");
//         ShowDialogs.showToast("Location permission is required to add visits");
//       }
//     } else if (status.isPermanentlyDenied) {
//       // 🚫 User selected “Don’t ask again”
//       print("Permission permanently denied");
//       ShowDialogs.showToast(
//           "Please allow location permission from settings to continue");
//       await permishan.openAppSettings();
//     } else if (status.isRestricted || status.isLimited) {
//       print("Permission restricted/limited");
//       ShowDialogs.showToast(
//           "Please allow location permission from settings to continue");
//       await permishan.openAppSettings();
//     }
//   }

//   getrole() async {
//     role = await SPManager().getroleid();
//     await grantPermission();
//     await siteDropDown();
//     await _getLocation();
//     site_id = await GlobalLists.visitSiteId;
//     client_id = await GlobalLists.visitClintId;
//   }

//   @override
//   void initState() {
//     siteNameController.text = GlobalLists.clienname;
//     print(
//         'siteNameController.text ${siteNameController.text} GlobalLists.clientname ${GlobalLists.clientname}GlobalLists.visitSiteId${GlobalLists.visitSiteId}');

//     getrole();
//     DateTime now = DateTime.now();
//     selectedDate = DateTime.now();
//     selectedTime = TimeOfDay.now();
//     super.initState();
//   }

//   String _locationMessage = "Press the button to get your location";

//   _getLocation() async {
//     LocationService locationService = LocationService();
//     try {
//       Position position = await locationService.determinePosition();
//       setState(() {
//         _locationMessage =
//             "Latitude: ${position.latitude}, Longitude: ${position.longitude}";

//         print(_locationMessage);
//       });
//     } catch (e) {
//       setState(() {
//         _locationMessage = "Error: $e";
//         print(_locationMessage);
//       });
//     }
//     getLocation();
//   }

//  Future<Placemark> getLocation() async {
//   print("Fetching location...");

//   // Get current position
//   Position position = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high);

//   print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');

//   // Get placemarks (address) from coordinates
//   List<Placemark> placemarks = await placemarkFromCoordinates(
//       position.latitude, position.longitude);

//   if (placemarks.isEmpty) {
//     throw Exception("No address found for this location");
//   }

//   Placemark first = placemarks.first;

//    lat = position.latitude.toString();
//    long = position.longitude.toString();

//   print("${first.name} : ${first.street}, ${first.locality}, ${first.country}");

//   return first;
// }
 
//   final GlobalKey<ScaffoldState> _scaffoldKey2 = new GlobalKey<ScaffoldState>();

//   final GlobalKey<State> _submitkeyLoader = GlobalKey<State>();

//   Future<void> pickDate() async {
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: selectedDate ?? DateTime.now(),
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2100),
//     );
//     if (picked != null) setState(() => selectedDate = picked);
//   }

//   Future<void> pickTime() async {
//     final picked = await showTimePicker(
//       context: context,
//       initialTime: selectedTime ?? TimeOfDay.now(),
//     );
//     if (picked != null) setState(() => selectedTime = picked);
//   }

//   Future<void> pickImage() async {
//     showModalBottomSheet(
//       context: context,
//       isDismissible: true,
//       enableDrag: true,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//       ),
//       builder: (context) {
//         return Wrap(
//           children: [
//             // ListTile(
//             //   leading: Icon(Icons.camera_alt_outlined),
//             //   title: Text('Take Photo'),
//             //   onTap: () async {
//             //     Navigator.pop(context);
//             //     final pickedFile =
//             //         await ImagePicker().pickImage(source: ImageSource.camera);
//             //     if (pickedFile != null) {
//             //       setState(() => selectedImage = File(pickedFile.path));
//             //     }
//             //   },
//             // ),
//             ListTile(
//               leading: const Icon(Icons.camera_alt_outlined),
//               title: const Text('Take Photo'),
//               onTap: () async {
//                 Navigator.pop(context); // close dialog first

//                 // Ask for camera permission
//                 bool hasPermission =
//                     await PermissionHelper.requestPermission(Permission.camera);

//                 if (!hasPermission) {
//                   Flushbar(
//                     margin: const EdgeInsets.all(8),
//                     borderRadius: BorderRadius.circular(8),
//                     backgroundColor: customcolor.blue,
//                     message: "Camera permission denied",
//                     duration: const Duration(seconds: 2),
//                     flushbarPosition: FlushbarPosition.TOP, // <-- Top position
//                   ).show(context);

//                   return;
//                 }

//                 // Open custom camera capture screen
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => CameraCaptureScreen(
//                       onImageCaptured: (String imagePath) {
//                         // Update UI after capture
//                         setState(() {
//                           selectedImage = File(imagePath);
//                           String fileName = selectedImage!.path.split('/').last;
//                           print("Captured: $fileName");
//                         });

//                         // Pop camera screen and return image path if needed
//                         // Navigator.pop(context, imagePath);
//                       },
//                     ),
//                   ),
//                 );

//                 // Return immediately after opening camera
//                 return;
//               },
//             ),

//             // ListTile(
//             //   leading: Icon(Icons.photo_library_outlined),
//             //   title: Text('Choose from Gallery'),
//             //   onTap: () async {
//             //     Navigator.pop(context);
//             //     final result =
//             //         await FilePicker.platform.pickFiles(type: FileType.image);
//             //     if (result != null && result.files.single.path != null) {
//             //       setState(
//             //           () => selectedImage = File(result.files.single.path!));
//             //     }
//             //   },
//             // ),
//             ListTile(
//   leading: const Icon(Icons.photo_library_outlined),
//   title: const Text('Choose from Gallery'),
//   onTap: () async {
//     Navigator.pop(context);

//     final ImagePicker picker = ImagePicker();
//     final XFile? pickedFile =
//         await picker.pickImage(source: ImageSource.gallery);

//     if (pickedFile != null) {
//       setState(() {
//         selectedImage = File(pickedFile.path);
//       });
//     }
//   },
// ),

//           ],
//         );
//       },
//     );
//   }

//   String get formattedDate => selectedDate == null
//       ? ''
//       : '${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}';

//   String get formattedTime => selectedTime == null
//       ? ''
//       : '${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}';
//   bool isSubmitHandle = false;
//   handleSubmit() async {
// //new
// // for (var item in visitTypesList.where((e) => e.isSelected)) {
// //   var payload = {
// //     "site_id": site_id.toString(),
// //     "date": formattedDate,
// //     "time": formattedTime,
// //     "visit_type": item.name,
// //     "visit_remarks": item.remarkController.text.trim(),
// //     "client_id": client_id.toString(),
// //     "longitude": "${long ?? 0}",
// //     "latitude": "${lat ?? 0}",
// //   };

// //   var request = http.MultipartRequest(
// //     "POST",
// //     Uri.parse(APIManager.submitoperation),
// //   );

// //   request.fields.addAll(payload.map((k, v) => MapEntry(k, v ?? '')));

// //   if (item.image != null) {
// //     request.files.add(
// //       await http.MultipartFile.fromPath("supporting_image", item.image!.path),
// //     );
// //   }

// //   var response = await request.send();
// //   var respStr = await response.stream.bytesToString();
// //   var res = json.decode(respStr);
// //   print("Submitted ${item.name}: $res");
// // }


// ////
//     if (siteNameController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Please enter site'),
//           behavior: SnackBarBehavior.floating,
//           margin: EdgeInsets.only(bottom: 30, left: 16, right: 16),
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         ),
//       );
//       return;
//     } else if (visitTypeController.text.trim().isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Please select visit type '),
//           behavior: SnackBarBehavior.floating,
//           margin: EdgeInsets.only(bottom: 80, left: 16, right: 16),
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         ),
//       );
//       return;
//     } else if (selectedImage == null || selectedImage == '') {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Please upload supporting image'),
//           behavior: SnackBarBehavior.floating,
//           margin: EdgeInsets.only(bottom: 80, left: 16, right: 16),
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         ),
//       );
//       return;
//     } else if ((lat == null || lat == 0) || long == null || long == 0) {
//       grantPermission();
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Please allow location'),
//           behavior: SnackBarBehavior.floating,
//           margin: EdgeInsets.only(bottom: 80, left: 16, right: 16),
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         ),
//       );
//       return;
//     }

//     var isConnected = await ConnectionDetector.checkInternetConnection();
//     var roles = await SPManager().getsupervisorid();

//     // Build payload with nullable values
//     final Map<String, String?> payload = {
//       "site_id": site_id.toString(),
//       "date": formattedDate,
//       "time": formattedTime,
//       "visit_remarks": purposeController.text.trim(),
//       "client_id": client_id.toString(),
//       "emp_id ": roles,
//       "propose_remark": visitTypeController.text.trim(),
//       'longitude': "${long ?? 0}",
//       "latitude": "${lat ?? 0}",
//     };

//     print('payload ${payload}');

//     // Log safe payload

//     if (isConnected) {
//       // ShowDialogs.showLoadingDialog(context, _submitkeyLoader);
//       setState(() {
//         isSubmitHandle = true;
//       });
//       try {
//         var request = http.MultipartRequest(
//           "POST",
//           Uri.parse(APIManager.submitoperation),
//         );

//         // Convert payload to Map<String, String>
//         request.fields.addAll(
//           payload.map((key, value) => MapEntry(key, value ?? '')),
//         );

//         // Add image if selected
//         if (selectedImage != null) {
//           request.files.add(await http.MultipartFile.fromPath(
//             "supporting_image",
//             selectedImage!.path,
//           ));
//         }

//         // Send request
//         var response = await request.send();
//         final respStr = await response.stream.bytesToString();
//         var res = json.decode(respStr);

//         print('res $res');

//         // Navigator.pop(context); // hide loader

//         if (res['status'] == 1) {
//           ShowDialogs.showToast(res['msg']);
//           Navigator.pushReplacement(
//             context,
//             // MaterialPageRoute(builder: (_) => ClientOperationVisitCard()),
//             MaterialPageRoute(
//                 builder: (_) => ClientOperationVisitCard(
//                       site_id: site_id,
//                       client_id: client_id,
//                     )),
//           );
//         } else {
//           print(res['msg']);
//           ShowDialogs.showToast(res['msg'] ?? "Submission failed.");
//           setState(() {
//             isSubmitHandle = false;
//           });
//           // Navigator.pop(context);
//         }
//       } catch (e) {
//         print('errro ${e}');
//         setState(() {
//           isSubmitHandle = false;
//         });
//         // Navigator.pop(context);
//         ShowDialogs.showToast("Error occurred: ${e.toString()}");
//       }
//     } else {
//       /// 🔁 Optional: Offline save if internet not available
//       await DBHelper.insertOfflineRequest(
//         '${Global.baseUrl}/api/siteconfigurator/add_information',
//         payload.map((k, v) => MapEntry(k, v ?? '')),
//         supporting_image: selectedImage != null ? [selectedImage!.path] : [],
//         isMultipart: true,
//       );
//       print(selectedImage.toString());
//       // Navigator.pop(context);
//       setState(() {
//         isSubmitHandle = false;
//       });
//       ShowDialogs.showToast("Saved offline. Will sync when internet is back.");
//     }
//   }
// List<VisitTypeItem> visitTypesList = [
//   VisitTypeItem(name: "Training"),
//   VisitTypeItem(name: "Process"),
//   VisitTypeItem(name: "Workflow"),
//   VisitTypeItem(name: "Chemical"),
//   VisitTypeItem(name: "Consumables"),
// ];
// Widget visitTypeMultiDropdown(StateSetter setStateDialog) {
//   return Container(
//     margin: EdgeInsets.only(top: 5),
//     child: Card(
//       elevation: 5,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Container(
//         height: 260,
//         padding: EdgeInsets.all(8),
//         child: Column(
//           children: [
//             /// ✅ List
//             Expanded(
//               child: ListView.builder(
//                 itemCount: visitTypesList.length,
//                 itemBuilder: (context, index) {
//                   final item = visitTypesList[index];
//                   return
//                   CheckboxListTile(
//   contentPadding: EdgeInsets.symmetric(horizontal: 4),
//   dense: true, // reduces height

//   title: Text(
//     item.name,
//     style: TextStyle(fontSize: 14),
//   ),

//   value: item.isSelected,

//   controlAffinity: ListTileControlAffinity.leading, // 👈 checkbox left aligned

//   visualDensity: VisualDensity.compact, // 👈 tighter spacing

//   activeColor: customcolor.green, // checkbox color

//   onChanged: (val) {
//     setStateDialog(() {
//       item.isSelected = val ?? false;
//     });
//   },
// );
//                   //  CheckboxListTile(
//                   //   contentPadding: EdgeInsets.zero,
//                   //   title: Text(item.name),
//                   //   value: item.isSelected,
//                   //   onChanged: (val) {
//                   //     setStateDialog(() {
//                   //       item.isSelected = val ?? false;
//                   //     });
//                   //   },
//                   // );
//                 },
//               ),
//             ),

//             Divider(),

//             /// ✅ Submit Button
//             ///  Center(
//                  GestureDetector(
//                   onTap: () {
//                   List selected = visitTypesList
//       .where((e) => e.isSelected)
//       .toList();

//   // update controller text
//   visitTypeController.text =
//       selected.map((e) => e.name).join(", ");

//   setStateDialog(() {
//     // 👇 mark only selected as submitted
//     for (var item in visitTypesList) {
//       item.isSubmitted = item.isSelected;
//     }

//     isExpandedVisitType = false;
//   });
//                   },
//                   child: Text(
//                     "Submit",
//                     style: AppFonts.headerStyle(
//                       fontSize: 12,
//                       color: customcolor.blue,
//                       fontWeight: FontWeight.normal,
//                     ),
//                   ),
//                 ),
              
//             SizedBox(height: 10,)
//           ],
//         ),
//       ),
//     ),
//   );
// }

//   Widget visitTypeDropdown(StateSetter setStateDialog) {
//     // Static values for visit type
//     final List<String> visitTypes = [
//       // "Training Visit",
//       // "Operational Visit",
//       // "Regular Visit",
//       "Training"
// "Process",
// "Workflow",
// "Chemical",
// "Consumables"
//     ];

//     return Container(
//       height: 150, // Adjust height if needed
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Card(
//         elevation: 5,
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//           child: ListView.builder(
//             itemCount: visitTypes.length,
//             itemBuilder: (BuildContext context, int index) {
//               final type = visitTypes[index];
//               return Column(
//                 children: [
//                   GestureDetector(
//                     onTap: () {
//                       setStateDialog(() {
//                         visitTypeController.text = type; //  no error now
//                         selectedVisitType = type;
//                         isExpandedVisitType = false;
//                         //  collapse dropdown
//                       });
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 4),
//                       child: Container(
//                         color: Colors.white,
//                         width: double.infinity,
//                         child: Text(
//                           type,
//                           style: AppFonts.headerStyle(
//                             fontSize: 14,
//                             color: customcolor.black,
//                             fontWeight: FontWeight.normal,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   Divider(color: customcolor.greybg),
//                 ],
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   String? selectedVisitType;
//   bool isExpandedVisitType = false;

//   InputDecoration customInputDecoration(String label) {
//     return InputDecoration(
//       hintText: label,
//       filled: true,
//       fillColor: Colors.white, // Optional: set consistent fill color
//       contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(10),
//         borderSide: BorderSide(
//           color: customcolor.greyborder,
//           width: 1,
//         ),
//       ),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(10),
//         borderSide: BorderSide(
//           color: customcolor.greyborder,
//           width: 1,
//         ),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(10),
//         borderSide: BorderSide(
//           color: customcolor.blue, // Highlight color on focus
//           width: 2,
//         ),
//       ),
//     );
//   }

//   Widget sectionTitle(String text, IconData icon) {
//     return Row(
//       children: [
//         Icon(icon, color: customcolor.blue),
//         SizedBox(width: 8),
//         Text(
//           text,
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//             color: customcolor.blue,
//           ),
//         ),
//       ],
//     );
//   }

//   bool isExpandedSite = false;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey2,
//       backgroundColor: Colors.grey.shade100,
//       bottomNavigationBar: CustomBottomNavigationBar(index: -1),
//       resizeToAvoidBottomInset: false,
//       floatingActionButton: FloatingActionButton(
//         //Floating action button on Scaffold
//         backgroundColor: customcolor.white,
//         onPressed: () {
//           Navigator.push(
//               context,
//               PageTransition(
//                 type: PageTransitionType.fade,
//                 child: HomePage(),
//                 duration: Duration(milliseconds: 300),
//               ));
//         },
//         child: Image.asset(
//           "assets/images/greyhome.png",
//           color: customcolor.greytext,
//           width: 20,
//           height: 20,
//         ), //icon inside button
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       endDrawer: Theme(
//         data: Theme.of(context).copyWith(
//             canvasColor: customcolor.blue, primaryColor: customcolor.blue),
//         child: AppDrawerfilter(widget.role),
//       ),
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(148),
//         child: AppbarComman(
//             setStyleStr: 'Operations Visit',
//             onPressedBack: () {},
//             onPressedNotify: () {},
//             onPressedSearch: () {},
//             onPressedSort: () {},
//             onPressedmenu: () {
//               _scaffoldKey2.currentState!.openEndDrawer();
//             }),
//       ),
//       body: SingleChildScrollView(
//         child: Card(
//           elevation: 4,
//           child: Container(
//             width: double.infinity,
//             // height: MediaQuery.of(context).size.height,
//             child: Padding(
//               padding: const EdgeInsets.all(12),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   sectionTitle("Site Information", Icons.location_on),
//                   SizedBox(height: 12),
//                   GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         isExpandedSite = !isExpandedSite;
//                       });
//                     },
//                     child: FormTextField(
//                       isEnable: false,
//                       textcontroller: siteNameController,
//                       placeholderStr: "Select Site",
//                       textInputType: TextInputType.text,
//                       onchange: (val) {},
//                       suffixWidget: Padding(
//                         padding: EdgeInsets.only(right: 20),
//                         child: Image.asset(
//                           "assets/images/dropdown.png",
//                           width: 10,
//                           height: 10,
//                         ),
//                       ),
//                     ),
//                   ),
//                   if (isExpandedSite)
//                     Padding(
//                       padding: const EdgeInsets.only(top: 5),
//                       child: siteDropdown(setState),
//                     ),
//                   SizedBox(height: 16),
//                   GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         isExpandedVisitType =
//                             !isExpandedVisitType; // toggle dropdown
//                       });
//                     },
//                     child: FormTextField(
//                       isEnable: false,
//                       textcontroller: visitTypeController,
//                       placeholderStr: "Select Visit Type",
//                       textInputType: TextInputType.text,
//                       onchange: (val) {},
//                       suffixWidget: Padding(
//                         padding: EdgeInsets.only(right: 20),
//                         child: Image.asset(
//                           "assets/images/dropdown.png",
//                           width: 10,
//                           height: 10,
//                         ),
//                       ),
//                     ),
//                   ),
//                   if (isExpandedVisitType)
//                   visitTypeMultiDropdown(setState),
//                     // Card(
//                     //   elevation: 5,
//                     //   child: Container(
//                     //     height: 120, // adjust as needed
//                     //     decoration: BoxDecoration(
//                     //       color: Colors.white,
//                     //       borderRadius: BorderRadius.circular(10),
//                     //       boxShadow: [
//                     //         BoxShadow(color: Colors.black12, blurRadius: 4)
//                     //       ],
//                     //     ),
//                     //     child: ListView(
//                     //       padding:
//                     //           EdgeInsets.symmetric(horizontal: 5, vertical: 5),
//                     //       children: [
//                     //         "Training Visit",
//                     //         "Operational Visit",
//                     //         "Regular Visit"
//                     //       ]
//                     //           .map((type) => Column(
//                     //                 children: [
//                     //                   GestureDetector(
//                     //                     onTap: () {
//                     //                       setState(() {
//                     //                         visitTypeController.text = type;
//                     //                         selectedVisitType = type;
//                     //                         isExpandedVisitType =
//                     //                             false; // collapse
//                     //                       });
//                     //                     },
//                     //                     child: Container(
//                     //                       width: double.infinity,
//                     //                       padding:
//                     //                           EdgeInsets.symmetric(vertical: 6),
//                     //                       child: Text(
//                     //                         type,
//                     //                         style: AppFonts.headerStyle(
//                     //                           fontSize: 14,
//                     //                           color: customcolor.black,
//                     //                           fontWeight: FontWeight.normal,
//                     //                         ),
//                     //                       ),
//                     //                     ),
//                     //                   ),
//                     //                   Divider(color: customcolor.greybg),
//                     //                 ],
//                     //               ))
//                     //           .toList(),
//                     //     ),
//                     //   ),
//                     // ),
//                   SizedBox(height: 16),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: GestureDetector(
//                           onTap: pickDate,
//                           child: AbsorbPointer(
//                             child: TextFormField(
//                               decoration: customInputDecoration(
//                                 formattedDate.isEmpty
//                                     ? 'Select Date'
//                                     : formattedDate,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(width: 12),
//                       Expanded(
//                         child: GestureDetector(
//                           onTap: pickTime,
//                           child: AbsorbPointer(
//                             child: TextFormField(
//                               decoration: customInputDecoration(
//                                 formattedTime.isEmpty
//                                     ? 'Select Time'
//                                     : formattedTime,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   // SizedBox(height: 24),
//                   // sectionTitle("Visit Details", Icons.info_outline),
//                   SizedBox(height: 12),
//                   ListView(
//                     shrinkWrap: true,
//   //crossAxisAlignment: CrossAxisAlignment.start,
//   children: visitTypesList
//       .where((item) => item.isSubmitted)
//       .map((item) => Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(height: 16),
//               Text(
//                 "${item.name} Remark",
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 8),
//               TextFormField(
//                 controller: item.remarkController,
//                 maxLines: 2,
//                 decoration: InputDecoration(
//                   hintText: "Enter remark for ${item.name}",
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               SizedBox(height: 25),
//               Text(
//                 "${item.name} Image",
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 4),
//               GestureDetector(
//                 onTap: () async {
//                   final pickedFile = await ImagePicker()
//                       .pickImage(source: ImageSource.gallery);
//                   if (pickedFile != null) {
//                     setState(() {
//                       item.image = File(pickedFile.path);
//                     });
//                   }
//                 },
//                 child: Container(
//                   height: 120,
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.grey),
//                     borderRadius: BorderRadius.circular(8),
//                     color: Colors.grey.shade100,
//                   ),
//                   child: item.image != null
//                       ? Image.file(item.image!, fit: BoxFit.cover)
//                       : Center(
//                           child: Text(
//                             "Upload ${item.name} Image",
//                             style: TextStyle(color: Colors.grey),
//                           ),
//                         ),
//                 ),
//               ),
//             ],
//           ))
//       .toList(),
// ),
                 
//                   // SizedBox(height: 12),
//                   // GestureDetector(
//                   //   onTap: pickImage,
//                   //   child: Container(
//                   //     height: 150,
//                   //     width: double.infinity,
//                   //     decoration: BoxDecoration(
//                   //       borderRadius: BorderRadius.circular(12),
//                   //       border: Border.all(color: Colors.grey),
//                   //       color: Colors.grey.shade100,
//                   //     ),
//                   //     child: selectedImage != null
//                   //         ? ClipRRect(
//                   //             borderRadius: BorderRadius.circular(10),
//                   //             child: Image.file(
//                   //               selectedImage!,
//                   //               fit: BoxFit
//                   //                   .contain, // 👈 shows full image, no cropping
//                   //               width: double.infinity,
//                   //               height: 150,
//                   //             ),
//                   //           )
//                   //         : const Center(
//                   //             child: Icon(
//                   //               Icons.add_photo_alternate,
//                   //               color: Colors.grey,
//                   //               size: 40,
//                   //             ),
//                   //           ),
//                   //   ),
//                   // ),
//                   //                 GestureDetector(
//                   //                   onTap: pickImage,
//                   //                   child: Container(
//                   //                     height: 150,
//                   //                     width: double.infinity,
//                   //                     decoration: BoxDecoration(
//                   //                       borderRadius: BorderRadius.circular(12),
//                   //                       border: Border.all(color: Colors.grey),
//                   //                       color: Colors.grey.shade100,
//                   //                     ),
//                   //                     child: selectedImage != null
//                   //                         ? ClipRRect(

//                   //                             borderRadius: BorderRadius.circular(10),
//                   //                             child:
//                   //                                 Image.file(selectedImage!,    fit: BoxFit.cover,
//                   // width: double.infinity,
//                   // height: 150,),
//                   //                           )
//                   //                         : Center(
//                   //                             child: Icon(
//                   //                               Icons.add_photo_alternate,
//                   //                               color: Colors.grey,
//                   //                               size: 40,
//                   //                             ),
//                   //                           ),
//                   //                   ),
//                   //                 ),
//                   SizedBox(height: 30),
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton.icon(
//                       onPressed: () {
//                         handleSubmit();
//                       },
//                       icon: isSubmitHandle
//                           ? Container()
//                           : Icon(Icons.check_circle),
//                       label: isSubmitHandle
//                           ? CircularProgressIndicator(
//                               color: customcolor.white,
//                             )
//                           : Text("Submit Visit Details"),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: customcolor.blue,
//                         padding: EdgeInsets.symmetric(vertical: 14),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         textStyle: TextStyle(fontSize: 16),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 10),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget siteDropdown(StateSetter setStateDialog) {
//     return Container(
//       height: 150, // Adjust height as needed
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Card(
//         elevation: 5,
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//           child: ListView.builder(
//             itemCount: GlobalLists.sitedropdown.length,
//             itemBuilder: (BuildContext context, int index) {
//               final site = GlobalLists.sitedropdown[index];
//               return Column(
//                 children: [
//                   GestureDetector(
//                     onTap: () {
//                       setStateDialog(() {
//                         siteNameController.text = site.clientName ?? '';
//                         selectedSite = site.siteId.toString();
//                         clientId = site.clientId.toString();
//                         client_id = site.clientId;
//                         site_id = site.siteId;
//                         isExpandedSite = false;
//                       });
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 4),
//                       child: Container(
//                         color: Colors.white,
//                         width: double.infinity,
//                         child: Text(
//                           site.clientName ?? '',
//                           style: AppFonts.headerStyle(
//                             fontSize: 14,
//                             color: customcolor.black,
//                             fontWeight: FontWeight.normal,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   Divider(color: customcolor.greybg),
//                 ],
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   siteDropDown() async {
//     var status1 = await ConnectionDetector.checkInternetConnection();
//     var roles = await SPManager().getsupervisorid();
//     var clientid = await SPManager().getclientid();

//     String today = DateTime.now()
//         .toLocal()
//         .toString()
//         .split(' ')[0]
//         .split('-')
//         .reversed
//         .join('-'); // dd-MM-yyyy

//     var map = new Map<String, dynamic>();
//     // map['date_today']=today;
//     // map['client_id']=clientid;

//     if (role == GlobalLists.clientrole) {
//       map['date_today'] = today;
//       map['client_id'] = clientid;
//     } else {
//       map['supervisor'] = roles;
//       map['date_today'] = today;
//     }

//     print("Site Dropdown Request: $map");

//     if (status1) {
//       // ✅ Online: Fetch from API
//       APIManager().apiRequest(context, API.sitedropdown, (response) async {
//         SiteDropDown resp = response;

//         print(' SiteDropDown resp ${resp}');
//         if (resp.status == 1) {
//           setState(() {
//             GlobalLists.sitedropdown = resp.data ?? [];
//           });

//           // ✅ Save to local storage
//           final prefs = await SharedPreferences.getInstance();
//           await prefs.setString(
//               'cached_site_dropdown', siteDropDownToJson(resp));
//         } else {
//           ShowDialogs.showToast(resp.msg.toString());
//         }
//       }, (error) {
//         print('API Error: $error');
//       }, false, "", jsonval: map);
//     } else {
//       // 🚫 Offline: Load from local cache
//       final prefs = await SharedPreferences.getInstance();
//       String? cachedData = prefs.getString('cached_site_dropdown');

//       if (cachedData != null) {
//         SiteDropDown cachedResponse = siteDropDownFromJson(cachedData);
//         setState(() {
//           GlobalLists.sitedropdown = cachedResponse.data ?? [];
//         });
//         ShowDialogs.showToast("Offline data loaded");
//       } else {
//         ShowDialogs.showToast("No internet and no offline data available");
//       }
//     }
//   }
// }
