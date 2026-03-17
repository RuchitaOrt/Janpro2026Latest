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
    super.initState();
  }

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
  handleSubmit() async {
    if (siteNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter site'),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(bottom: 30, left: 16, right: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    } else if (visitTypeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select visit type '),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(bottom: 80, left: 16, right: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    } else if (selectedImage == null || selectedImage == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please upload supporting image'),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(bottom: 80, left: 16, right: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    } else if ((lat == null || lat == 0) || long == null || long == 0) {
      grantPermission();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please allow location'),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(bottom: 80, left: 16, right: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    var isConnected = await ConnectionDetector.checkInternetConnection();
    var roles = await SPManager().getsupervisorid();

    // Build payload with nullable values
    final Map<String, String?> payload = {
      "site_id": site_id.toString(),
      "date": formattedDate,
      "time": formattedTime,
      "visit_remarks": purposeController.text.trim(),
      "client_id": client_id.toString(),
      "emp_id ": roles,
      "propose_remark": visitTypeController.text.trim(),
      'longitude': "${long ?? 0}",
      "latitude": "${lat ?? 0}",
    };

    print('payload ${payload}');

    // Log safe payload

    if (isConnected) {
      // ShowDialogs.showLoadingDialog(context, _submitkeyLoader);
      setState(() {
        isSubmitHandle = true;
      });
      try {
        var request = http.MultipartRequest(
          "POST",
          Uri.parse(APIManager.submitoperation),
        );

        // Convert payload to Map<String, String>
        request.fields.addAll(
          payload.map((key, value) => MapEntry(key, value ?? '')),
        );

        // Add image if selected
        if (selectedImage != null) {
          request.files.add(await http.MultipartFile.fromPath(
            "supporting_image",
            selectedImage!.path,
          ));
        }

        // Send request
        var response = await request.send();
        final respStr = await response.stream.bytesToString();
        var res = json.decode(respStr);

        print('res $res');

        // Navigator.pop(context); // hide loader

        if (res['status'] == 1) {
          ShowDialogs.showToast(res['msg']);
          Navigator.pushReplacement(
            context,
            // MaterialPageRoute(builder: (_) => ClientOperationVisitCard()),
            MaterialPageRoute(
                builder: (_) => ClientOperationVisitCard(
                      site_id: site_id,
                      client_id: client_id,
                    )),
          );
        } else {
          print(res['msg']);
          ShowDialogs.showToast(res['msg'] ?? "Submission failed.");
          setState(() {
            isSubmitHandle = false;
          });
          // Navigator.pop(context);
        }
      } catch (e) {
        print('errro ${e}');
        setState(() {
          isSubmitHandle = false;
        });
        // Navigator.pop(context);
        ShowDialogs.showToast("Error occurred: ${e.toString()}");
      }
    } else {
      /// 🔁 Optional: Offline save if internet not available
      await DBHelper.insertOfflineRequest(
        '${Global.baseUrl}/api/siteconfigurator/add_information',
        payload.map((k, v) => MapEntry(k, v ?? '')),
        supporting_image: selectedImage != null ? [selectedImage!.path] : [],
        isMultipart: true,
      );
      print(selectedImage.toString());
      // Navigator.pop(context);
      setState(() {
        isSubmitHandle = false;
      });
      ShowDialogs.showToast("Saved offline. Will sync when internet is back.");
    }
  }

  Widget visitTypeDropdown(StateSetter setStateDialog) {
    // Static values for visit type
    final List<String> visitTypes = [
      "Training Visit",
      "Operational Visit",
      "Regular Visit",
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
        child: Card(
          elevation: 4,
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  sectionTitle("Site Information", Icons.location_on),
                  SizedBox(height: 12),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isExpandedSite = !isExpandedSite;
                      });
                    },
                    child: FormTextField(
                      isEnable: false,
                      textcontroller: siteNameController,
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
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isExpandedVisitType =
                            !isExpandedVisitType; // toggle dropdown
                      });
                    },
                    child: FormTextField(
                      isEnable: false,
                      textcontroller: visitTypeController,
                      placeholderStr: "Select Visit Type",
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
                  if (isExpandedVisitType)
                    Card(
                      elevation: 5,
                      child: Container(
                        height: 120, // adjust as needed
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 4)
                          ],
                        ),
                        child: ListView(
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          children: [
                            "Training Visit",
                            "Operational Visit",
                            "Regular Visit"
                          ]
                              .map((type) => Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            visitTypeController.text = type;
                                            selectedVisitType = type;
                                            isExpandedVisitType =
                                                false; // collapse
                                          });
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          padding:
                                              EdgeInsets.symmetric(vertical: 6),
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
                                      Divider(color: customcolor.greybg),
                                    ],
                                  ))
                              .toList(),
                        ),
                      ),
                    ),
                  SizedBox(height: 16),
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
                  // SizedBox(height: 24),
                  // sectionTitle("Visit Details", Icons.info_outline),
                  SizedBox(height: 12),
                  TextFormField(
                    controller: purposeController,
                    maxLines: 2,
                    decoration: customInputDecoration('Remarks'),
                  ),
                  SizedBox(height: 16),
                  sectionTitle("Supporting Image", Icons.image),
                  SizedBox(height: 12),
                  GestureDetector(
                    onTap: pickImage,
                    child: Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey),
                        color: Colors.grey.shade100,
                      ),
                      child: selectedImage != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                selectedImage!,
                                fit: BoxFit
                                    .contain, // 👈 shows full image, no cropping
                                width: double.infinity,
                                height: 150,
                              ),
                            )
                          : const Center(
                              child: Icon(
                                Icons.add_photo_alternate,
                                color: Colors.grey,
                                size: 40,
                              ),
                            ),
                    ),
                  ),
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
          ),
        ),
      ),
    );
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
