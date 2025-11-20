import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:another_flushbar/flushbar.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';

import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:janpro/Screens/Homepage.dart';
import 'package:janpro/Screens/SpecialActivityImage.dart';
import 'package:janpro/Utitlity/APIManager.dart';
import 'package:janpro/Utitlity/AppDrawer.dart';
import 'package:janpro/Utitlity/FormTextField.dart';
import 'package:janpro/Utitlity/FormTextFieldButton.dart';
import 'package:janpro/Utitlity/GlobalLists.dart';
import 'package:janpro/Utitlity/SPManager.dart';
import 'package:janpro/Utitlity/ShowDialog.dart';
import 'package:janpro/Utitlity/appbar.dart';
import 'package:janpro/Utitlity/button.dart';
import 'package:janpro/Utitlity/customBottomNavigationBar.dart';
import 'package:janpro/Utitlity/custom_color.dart';
import 'package:janpro/Utitlity/internetConnection.dart';
import 'package:janpro/Utitlity/linechart.dart';
import 'package:janpro/Utitlity/sizeConfig.dart';
import 'package:janpro/model/AddAttendanceResponse.dart' as addattten;
import 'package:janpro/model/AddSpecialActivityResponse.dart' as addactivity;
import 'package:janpro/model/AttendencelistResponse.dart';
import 'package:janpro/model/FullDetailSpecialActivityResponse.dart'
    as mainactivity;
import 'package:janpro/model/UnitclientMasterResponse.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart' as permishan;
import 'package:permission_handler/permission_handler.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:file_picker/file_picker.dart';

import 'package:image_picker/image_picker.dart';
import 'package:janpro/model/ActivitylistResponse.dart' as actilist;
import 'package:http_parser/http_parser.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:flutter_image_compress/flutter_image_compress.dart';

import 'dart:math' as math;

import '../services/camera_capture_screen.dart';
import '../services/permission_helper.dart';

class MainList {
  final String name;
  final String priority;

  MainList(this.name, this.priority);
}

class ImageList {
  final String name;
  final String imagename;
  final String imagevalue;

  ImageList(this.name, this.imagename, this.imagevalue);
}

class SpecialActivity extends StatefulWidget {
  String clientname;
  SpecialActivity(this.clientname);

  @override
  _SpecialActivityState createState() => _SpecialActivityState();
}

class _SpecialActivityState extends State<SpecialActivity>
    with TickerProviderStateMixin {
  var searchcontroller = new TextEditingController();
  var activitycontroller = new TextEditingController();
  var sitenamecontroller = new TextEditingController();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  List<ImageList> imagelist = [];

  var beforeimage1controller = TextEditingController();

  var beforeimage2controller = new TextEditingController();

  var afterimage1controller = new TextEditingController();

  var afterimage2controller = new TextEditingController();

  var datecontroller = new TextEditingController();
  var clientcontroller = new TextEditingController();
  List<EmployeeList> unitemployeelist = [];
  String selectedValue = "Pending";
  String? lat;
  String? long;
  String attendanceclientid = "";
  String attendancesiteid = "";
  String activityid = "";
  List<String> listtab = [];
  List<String>? formValue1;
  var selectedDateTime;
  int tag = 0;
  int maintag = 0;

  String _isSelected = "";
  List<mainactivity.Datum> mainlisttab = [];
  late Data attendancedata;
  bool isdataloaded = false;
  List<EmployeeList> searchUserList = [];
  String? role = "1";
  late TabController _tabControllermain;
  final List<Tab> tabsmain = <Tab>[];
  int selectedindex = 0;
  List<String> sitelist = ["IMax", "Cineplax", "PVR", "Cinipol"];
  bool isexpanded = false;
  // List<String> clientlist=["Client 1","Client 2"];
  bool isexpandedclient = false;
  // List<String> activitylist=["Deep Cleaning","Carpet Shampoo"];
  bool isexpandedactivity = false;
  bool showAvg = false;
  File? _imageFile;
  dynamic _pickImageError;
  File? image;
  String? _fileName;
  List<PlatformFile>? _paths;
  String? _directoryPath;
  String? _extension;
  bool _loadingPath = false;
  FileType _pickingType = FileType.custom;
  String? beforeimage1 = "";
  String? beforeimage2 = "";
  String? afterimage1 = "";
  String? afterimage2 = "";
  @override
  void initState() {
    super.initState();
    var datefrom = DateFormat('dd-MM-yyyy').format(DateTime.now());
    datecontroller.text = datefrom;
    print("date ");
    getrole();
  }

  Future<void> refreshData() async {
    // Simulating an API request or data refresh
    setState(() {
      print("APICall");
      //     var  datefrom =
      //                                   DateFormat('dd-MM-yyyy').format(DateTime.now());
      // datecontroller.text=datefrom;
      getrole();
    });
  }

  getrole() async {
    role = await SPManager().getroleid();
    if (role == GlobalLists.unitrole ||
        role == GlobalLists.headrole ||
        role == GlobalLists.reginalmanagerrole ||
        role == GlobalLists.clientrole ||
        role == GlobalLists.operationrole ||
        role == GlobalLists.operationmanagerrole) {
      setState(() {
        listtab.add("3.30 - 4.00 pm");
        listtab.add("3.50 - 4.00 pm");
        listtab.add("4.30 - 5.00 pm");

        // mainlisttab.add(MainList("IMAX","0"));
        //  mainlisttab.add(MainList("Cinipol","0"));
        //   mainlisttab.add(MainList("Cinimax","0"));
      });
    }
    unitclientmasterApi();
    activitylistApi();
    getoperationalactivityApi();
  }

  grantPermission() async {
    var status = await permishan.Permission.location.status;
    print("status");
    print(status);
    if (status.isGranted) {
      getLocation();
    } else if (status.isPermanentlyDenied) {
      print("isUndetermined");
      //  ShowDialogs.showToast(
      //                       "Please Allow Your Location Permission From Setting  To Add your Attendance");
      getLocation();
      //await Permission.location.request();
    } else {
      // getLocation();
      print("status1");
      permishan.openAppSettings();
      //locatedCountryCode = null;
      //await Permission.location.request();
    }
  }

  onItemChanged(String value) {
    print("in");

    setState(() {
      searchUserList.clear();

      GlobalLists.attendanceemployeelist.forEach((iElement) {
        if (iElement.name
            .toString()
            .toLowerCase()
            .contains(value.toLowerCase())) {
          searchUserList.add(iElement);
        }
      });
    });
  }

  void checkPermissionStatus() async {
    var status = await permishan.Permission.locationWhenInUse.status;
    if (status != permishan.PermissionStatus.granted) {
      //show Dialog or route to specific page (or route to Application Manager)
      print("notgranted");
      grantPermission();
      ShowDialogs.showToast(
          "Please Allow Your Location Permission From Setting  To Add your Attendance");
      // openAppSettings();
    } else {
      print("granted");

      getLocation().then((value) {
        print("hii");
        if (value != null) {
          print("notnull");
          getLocation();
        } else {
          print("null");
          grantPermission();
          ShowDialogs.showToast(
              "Please Allow Your Location Permission From Setting  To Add your Attendance");
        }

        // _getLocation();
        //    searching = !searching;
      });
      // Go to Second Screen
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey1 = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => HomePage(),
          ),
        );
        return await false;
      },
      child: Scaffold(
        key: _scaffoldKey1,
        endDrawer: Theme(
          data: Theme.of(context).copyWith(
              canvasColor: customcolor.blue, primaryColor: customcolor.blue),
          child: AppDrawerfilter(role),
        ),
        backgroundColor: customcolor.greybg,
        resizeToAvoidBottomInset: false,

        //       floatingActionButton: FloatingActionButton(
        //         //Floating action button on Scaffold
        //         backgroundColor: customcolor.white,
        //         onPressed: () {
        //          Navigator.push(
        //                         context,
        //                         MaterialPageRoute(
        //                             builder: (BuildContext context) => HomePage()

        //                             ));
        //         },
        //         child:  Image.asset(
        //                                   "assets/images/greyhome.png",
        // color: customcolor.greytext,
        //                                   width: 20,
        //                                   height: 20,
        //                                 ), //icon inside button
        //       ),
        //       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        //floating action button position to center
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(148),
          child: AppbarComman(
              setStyleStr: 'Special Activity',
              onPressedBack: () {},
              onPressedNotify: () {},
              onPressedSearch: () {},
              onPressedSort: () {},
              onPressedmenu: () {
                _scaffoldKey1.currentState!.openEndDrawer();
              }),
        ),
        // bottomNavigationBar: CustomBottomNavigationBar(index: -1),
        body:isSpecialActivityLoaded?Center(child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: customcolor.blue,),
            SizedBox(height: 15),
                Text("Loading, please wait...",
                    style: TextStyle(
                        color:   Colors.black))
          ],
        )): Stack(
          children: [
            SingleChildScrollView(
                physics: ScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, top: 20, bottom: 20),
                  child: Container(
                    child: CustomRefreshIndicator(
                      builder: (
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
                      onRefresh: refreshData,
                      child: ListView(
                        shrinkWrap: true,
                        //  physics: ScrollPhysics(),
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder: (context, animation1,
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
                                      "SPECIALS",
                                      style: AppFonts.headerStyle(
                                          fontSize:
                                              17.sp,
                                          color: customcolor.black,
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ),
                                ],
                              ),
                              //                   (role==GlobalLists.unitrole||role==GlobalLists.headrole||role==GlobalLists.clientrole||role==GlobalLists.operationrole)?
                              //                       new Container(
                              //                                     decoration: BoxDecoration(
                              //                               color: Colors.white, borderRadius: BorderRadius.circular(20)),
                              //                         width:110,
                              //                         height: 30,
                              //                         padding: EdgeInsets.only(left: 6,bottom: 5,top:3,right: 5),
                              //                         child: new Row(
                              //                           mainAxisAlignment: MainAxisAlignment.center,
                              //                           children: <Widget>[
                              //                             // new Expanded(child: new Text("Bemerkung",)),
                              //                             new  Expanded(
                              //                                   child: new TextField(

                              //                                     textAlign: TextAlign.center,
                              //                                     style:

                              //                                      AppFonts.headerStyle(fontSize:12,
                              // color: customcolor.black,fontWeight: FontWeight.w300  ),
                              //                                  readOnly: true,
                              //                                  onTap: ()
                              //                                  async {
                              //                                    DateTime? pickedDate = await showDatePicker(
                              //                 context: context,
                              //                 initialDate: DateTime.now(),
                              //                 firstDate: DateTime(1950),
                              //                 lastDate: DateTime(2050));

                              //             if (pickedDate != null) {
                              //             var  datefrom =
                              //                                     DateFormat('dd-MM-yyyy').format(pickedDate);
                              //               datecontroller.text =datefrom;
                              //               print(datecontroller.text);
                              //             }
                              //                                  },
                              //                                     controller: datecontroller,
                              // decoration: InputDecoration( border: InputBorder.none,),
                              //                                   ),
                              //                                 ),
                              //                                GestureDetector(
                              //                                   onTap: ()
                              //                                   async {
                              //                                         DateTime? pickedDate = await showDatePicker(
                              //                 context: context,
                              //                 initialDate: DateTime.now(),
                              //                 firstDate: DateTime(1950),
                              //                 lastDate: DateTime(2050));

                              //             if (pickedDate != null) {
                              //             var  datefrom =
                              //                                     DateFormat('dd-MM-yyyy').format(pickedDate);
                              //               datecontroller.text =datefrom;
                              //               print(datecontroller.text);
                              //             }
                              //                                   },
                              //                                    child: Padding(
                              //                                    padding:  EdgeInsets.only(bottom: 1,right: 5),
                              //                                    child:   Image.asset('assets/images/calendar.png',width: 22,height: 22,alignment: Alignment.center,),
                              //                                  ),
                              //                                  ),
                              //                           ],
                              //                         ),
                              //                       ):Container()

                              mainlisttab.length > 0
                                  ? _buildChoicemainListDropdown()
                                  : SizedBox()
                            ],
                          ),

                          //workflow
                          SizedBox(
                            height: 10,
                          ),
                          unitmodule()
                        ],
                      ),
                    ),
                  ),
                )),
            (role == GlobalLists.operationrole ||
                    role == GlobalLists.operationmanagerrole)
                ? Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FloatingActionButton(
                        backgroundColor: customcolor.blue,
                        onPressed: () {
                          datecontroller.text = "";
                          clientcontroller.text = "";
                          activitycontroller.text = "";
                          beforeimage1controller.text = "";
                          beforeimage2controller.text = "";
                          afterimage1controller.text = "";
                          afterimage2controller.text = "";
                          addactivity(context);
                          // Add your action for the center button here
                        },
                        child: Icon(
                          Icons.add,
                          color: customcolor.white,
                        ),
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget unitmodule() {
    return ListView(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      children: [
        Container(
          height: SizeConfig.blockSizeVertical * 74,
          decoration: BoxDecoration(
            //color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: customcolor.greyborder,
              width: 0.4,
            ),
          ),
          child: mainlisttab.length > 0
              ? ListView(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  // mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: Container(
                          height: 25,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            children: _buildChoicemainList(),
                          ),
                        )
                        // Wrap(
                        //    spacing: 5.0,
                        //    runSpacing: 3.0,
                        //    children: _buildChoicemainList(),
                        //  ),
                        ),
                    attendancelist(mainlisttab[maintag].details)
                  ],
                )
              : ShowDialogs.norecordwidget(SizeConfig.blockSizeHorizontal * 30,
                  SizeConfig.blockSizeVertical * 30),
        ),
      ],
    );
  }

  //tab
  _buildChoicemainList() {
    List<Widget> choices = [];
    mainlisttab.forEachIndexed((item, value) {
      choices.add(Container(
        height: 25,
        child: Padding(
          padding: const EdgeInsets.only(right: 5),
          child: ChoiceChip(
            label: Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Text(
                item.clientName,
                style: AppFonts.headerStyle(
                    fontSize: 12,
                    color: maintag == value
                        ? customcolor.white
                        :
                        // item.priority == "1"?customcolor.red:
                        customcolor.greytext,
                    fontWeight: FontWeight.bold),
              ),
            ),
            side: BorderSide(
                width: 0.5,
                color: maintag == value
                    ? customcolor.white
                    :
                    // item.priority == "1"?customcolor.red:
                    customcolor.white),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10))),
            labelStyle: AppFonts.headerStyle(
                fontSize: 12,
                color:
                    maintag == value ? customcolor.blue : customcolor.greytext,
                fontWeight: FontWeight.bold),
            selectedColor: customcolor.tabblue,
            backgroundColor: customcolor.white,
            selected: maintag == value,
            onSelected: (selected) {
              setState(() {
                _isSelected = item.clientName;
                maintag = value;
                widget.clientname = item.clientName;
              });
            },
          ),
        ),
      ));
    });
    return choices;
  }

  Widget _buildChoicemainListDropdown() {
    final selectedItem =
        maintag < mainlisttab.length ? mainlisttab[maintag] : null;

    return Row(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () async {
            TextEditingController searchController = TextEditingController();
            List filteredList = List.from(mainlisttab);

            await showDialog(
              context: context,
              builder: (_) {
                return StatefulBuilder(
                  builder: (context, setStateDialog) => Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                      constraints: BoxConstraints(maxHeight: 500),
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: TextField(
                              controller: searchController,
                              decoration: InputDecoration(
                                hintText: "Search Client...",
                                suffixIcon: searchController.text.isNotEmpty
                                    ? IconButton(
                                        icon: Icon(Icons.cancel_outlined),
                                        onPressed: () {
                                          searchController.clear();
                                          setStateDialog(() {
                                            filteredList =
                                                List.from(mainlisttab);
                                          });
                                        },
                                      )
                                    : null,
                                prefixIcon: Icon(Icons.search),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onChanged: (query) {
                                setStateDialog(() {
                                  filteredList = mainlisttab
                                      .where((item) => item.clientName
                                          .toLowerCase()
                                          .contains(query.toLowerCase()))
                                      .toList();
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: filteredList.isEmpty
                                ? Center(
                                    child: Text(
                                      "No client found.",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    itemCount: filteredList.length,
                                    itemBuilder: (context, index) {
                                      final item = filteredList[index];
                                      final isSelected = item == selectedItem;

                                      final color = isSelected
                                          ? customcolor.tabblue
                                          : customcolor.greytext;

                                      return ListTile(
                                        title: Text(
                                          item.clientName,
                                          style: AppFonts.headerStyle(
                                            fontSize: 14,
                                            color: color,
                                            fontWeight: isSelected
                                                ? FontWeight.bold
                                                : FontWeight.w500,
                                          ),
                                        ),
                                        trailing: isSelected
                                            ? Icon(Icons.check_circle,
                                                color: customcolor.tabblue,
                                                size: 18)
                                            : null,
                                        onTap: () {
                                          Navigator.pop(context);
                                          final value =
                                              mainlisttab.indexOf(item);
                                          setState(() {
                                            _isSelected = item.clientName;
                                            maintag = value;
                                            widget.clientname = item.clientName;
                                          });
                                        },
                                      );
                                    },
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
          child: Align(
            alignment: Alignment.center,
            child: Container(
              width: 50,
              decoration: BoxDecoration(
                color: customcolor.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: customcolor.white, width: 1.2),
              ),
              child: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: customcolor.tabblue,
                size: 24,
              ),
            ),
          ),
        ),
      ],
    );
  }

  addactivity(
    BuildContext context,
  ) {
    showModalBottomSheet(
        backgroundColor: Colors.white,
        isScrollControlled: true,
        isDismissible: true,
        enableDrag: true,
        elevation: 5.0,
        barrierColor: Colors.black.withOpacity(0.7),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(20.0),
              topRight: const Radius.circular(20.0)),
        ),
        context: context,
        builder: (builder) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setStateDialgoue) {
            return new Container(
              height: SizeConfig.blockSizeVertical * 80 +
                  MediaQuery.of(context).viewInsets.bottom,
              color: Colors.white,
              margin: EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 2),
              padding: EdgeInsets.all(5),
              child: Stack(
                children: [
                  ListView(
                    shrinkWrap: true,
                    //  crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 5,
                      ),
                      Center(
                        child: Container(
                          width: 50,
                          child: Divider(
                            thickness: 4,
                            color: customcolor.greytext,
                            height: 2,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Create Activity",
                        textAlign: TextAlign.left,
                        style: AppFonts.headerStyle(
                            fontSize: 22,
                            color: customcolor.black,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      GestureDetector(
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: selectedDateTime ?? DateTime.now(),
                              firstDate: DateTime(1950),
                              lastDate: DateTime(2050));

                          if (pickedDate != null) {
                            var datefrom =
                                DateFormat('dd-MM-yyyy').format(pickedDate);
                            datecontroller.text = datefrom;
                            print(datecontroller.text);
                            setState(() => selectedDateTime = pickedDate);
                          }
                        },
                        child: FormTextField(
                          isEnable: false,
                          textcontroller: datecontroller,
                          placeholderStr: "Date of Activity",
                          suffixWidget: Padding(
                            padding: EdgeInsets.only(right: 20),
                            child: Image.asset(
                              "assets/images/calendar.png",
                              width: 20,
                              height: 20,
                            ),
                          ),
                          textInputType: TextInputType.text,
                          onchange: (val) {},
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          setStateDialgoue(() {
                            isexpandedclient = !isexpandedclient;
                            isexpandedactivity = false;
                          });
                        },
                        child: FormTextField(
                          isEnable: false,
                          textcontroller: clientcontroller,
                          placeholderStr: "Client",
                          suffixWidget: Padding(
                            padding: EdgeInsets.only(right: 20),
                            child: Image.asset(
                              "assets/images/dropdown.png",
                              width: 10,
                              height: 10,
                            ),
                          ),
                          textInputType: TextInputType.text,
                          onchange: (val) {},
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      (role == GlobalLists.operationrole ||
                              role == GlobalLists.operationmanagerrole)
                          ? Stack(
                              children: [
                                Column(
                                  children: [
                                    // GestureDetector(
                                    //   onTap: ()
                                    //   {
                                    //     setStateDialgoue(() {
                                    //       isexpanded=true;
                                    //     });
                                    //   },
                                    //   child: FormTextField(isEnable: false,
                                    //                                         textcontroller: sitenamecontroller,
                                    //                                         placeholderStr: "Site Name",
                                    //                                       suffixWidget: Padding(
                                    //                                         padding:  EdgeInsets.only(right: 20),
                                    //                                         child: Image.asset(
                                    //                                         "assets/images/dropdown.png",

                                    //                                         width: 10,
                                    //                                         height: 10,
                                    //                                                                       ),
                                    //                                       ),
                                    //                                         textInputType: TextInputType.text,
                                    //                                         onchange: (val) {

                                    //                                         },
                                    //                                       ),
                                    // ),
                                    //                                     SizedBox(height: 20,),
                                    Stack(
                                      children: [
                                        Column(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                setStateDialgoue(() {
                                                  isexpandedactivity =
                                                      !isexpandedactivity;
                                                  isexpandedclient = false;
                                                });
                                              },
                                              child: FormTextField(
                                                isEnable: false,
                                                textcontroller:
                                                    activitycontroller,
                                                placeholderStr: "Activity Type",
                                                suffixWidget: Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 20),
                                                    child: Image.asset(
                                                      "assets/images/dropdown.png",
                                                      width: 10,
                                                      height: 10,
                                                    )),
                                                textInputType:
                                                    TextInputType.text,
                                                onchange: (val) {},
                                              ),
                                            ),
                                            Stack(
                                              children: [
                                                Column(
                                                  children: [
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        _showSelectionDialog(
                                                            context, 1);
                                                      },
                                                      child: FormTextField(
                                                        isEnable: false,
                                                        textcontroller:
                                                            beforeimage1controller,
                                                        placeholderStr:
                                                            "Upload Before Image 1",
                                                        textInputType:
                                                            TextInputType.text,
                                                        onchange: (val) {},
                                                        suffixWidget: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right: 20),
                                                          child: Image.asset(
                                                            "assets/images/addimage.png",
                                                            width: 20,
                                                            height: 20,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        _showSelectionDialog(
                                                            context, 3);
                                                      },
                                                      child: FormTextField(
                                                        isEnable: false,
                                                        textcontroller:
                                                            afterimage1controller,
                                                        placeholderStr:
                                                            "Upload After Image 1",
                                                        textInputType:
                                                            TextInputType.text,
                                                        onchange: (val) {},
                                                        suffixWidget: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right: 20),
                                                          child: Image.asset(
                                                            "assets/images/addimage.png",
                                                            width: 20,
                                                            height: 20,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        _showSelectionDialog(
                                                            context, 2);
                                                      },
                                                      child: FormTextField(
                                                        isEnable: false,
                                                        textcontroller:
                                                            beforeimage2controller,
                                                        placeholderStr:
                                                            "Upload Before Image 2",
                                                        textInputType:
                                                            TextInputType.text,
                                                        onchange: (val) {},
                                                        suffixWidget: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right: 20),
                                                          child: Image.asset(
                                                            "assets/images/addimage.png",
                                                            width: 20,
                                                            height: 20,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        _showSelectionDialog(
                                                            context, 4);
                                                      },
                                                      child: FormTextField(
                                                        isEnable: false,
                                                        textcontroller:
                                                            afterimage2controller,
                                                        placeholderStr:
                                                            "Upload After Image 2",
                                                        textInputType:
                                                            TextInputType.text,
                                                        onchange: (val) {},
                                                        suffixWidget: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right: 20),
                                                          child: Image.asset(
                                                            "assets/images/addimage.png",
                                                            width: 20,
                                                            height: 20,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                  ],
                                                ),
                                                isexpandedactivity
                                                    ? activityDropdown(
                                                        setStateDialgoue)
                                                    : Container(),
                                              ],
                                            ),
                                          ],
                                        ),
                                        isexpanded
                                            ? siteDropdown(setStateDialgoue)
                                            : Container(),
                                      ],
                                    ),
                                  ],
                                ),
                                isexpandedclient
                                    ? clientDropdown(setStateDialgoue)
                                    : Container(),
                              ],
                            )
                          : Container(),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: customcolor.blue,
                            minimumSize: Size(
                                SizeConfig.blockSizeHorizontal * 80,
                                SizeConfig.blockSizeVertical * 6),
                            textStyle: AppFonts.headerStyle(
                                fontSize: 15,
                                color: customcolor.black,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            if (datecontroller.text.isEmpty) {
                              ShowDialogs.showToast(
                                  "Please Select Training Date");
                            } else if (clientcontroller.text.isEmpty) {
                              ShowDialogs.showToast("Please Select Client");
                            } else if (activitycontroller.text.isEmpty) {
                              ShowDialogs.showToast("Please Select Activity");
                            } else if (beforeimage1controller.text.isEmpty) {
                              ShowDialogs.showToast(
                                  "Please Upload Before image 1");
                            } else if (beforeimage2controller.text.isEmpty) {
                              ShowDialogs.showToast(
                                  "Please Upload Before image 2");
                            } else if (afterimage1controller.text.isEmpty) {
                              ShowDialogs.showToast("Please After image 1");
                            } else if (afterimage2controller.text.isEmpty) {
                              ShowDialogs.showToast("Please After image 2");
                            } else {
                              operationaladdactivityApi();
                            }
                          },
                          child:isAddActivtity?CircularProgressIndicator(color: customcolor.white,): Text(
                            'Create',
                            style: AppFonts.headerStyle(
                                fontSize: 14,
                                color: customcolor.white,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          });
        });
  }

  Widget siteDropdown(StateSetter setStateDialgoue) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Card(
        elevation: 5,
        child: Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: ListView.builder(
                itemCount: sitelist.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setStateDialgoue(() {
                            sitenamecontroller.text = sitelist[index];

                            isexpanded = false;
                          });
                        },
                        child: Container(
                          color: Colors.white,
                          width: SizeConfig.blockSizeHorizontal * 100,
                          child: Text(
                            sitelist[index],
                            style: AppFonts.headerStyle(
                                fontSize: 14,
                                color: customcolor.black,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Divider(color: customcolor.greybg)
                    ],
                  );
                })),
      ),
    );
  }

  //add by vishu
  Future<String> compressimagepath(String orginalfile) async {
    File file = File(orginalfile);
    if (file.existsSync()) {
      final dir = await path_provider.getTemporaryDirectory();
      final targetPath =
          '${dir.absolute.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final finalresult = await FlutterImageCompress.compressAndGetFile(
        file.path,
        targetPath,
        minHeight: 1080,
        minWidth: 1080,
        quality: 50,
      );
      File newImage = File(finalresult!.path);
      return newImage.path;
    } else {
      print('File does not exist: ${file.path}');
      // Handle file not found errors
    }
    return '';
  }
  //client

  Widget clientDropdown(StateSetter setStateDialgoue) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Card(
        elevation: 5,
        child: Padding(
            padding: EdgeInsets.only(left: 10, right: 10, top: 10),
            child: ListView.builder(
                itemCount: GlobalLists.clientmasterlist.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setStateDialgoue(() {
                            clientcontroller.text =
                                GlobalLists.clientmasterlist[index].clientName;

                            isexpandedclient = false;

                            attendanceclientid = GlobalLists
                                .clientmasterlist[index].clientId
                                .toString();
                            attendancesiteid = GlobalLists
                                .clientmasterlist[index].siteId
                                .toString();
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 3, bottom: 2),
                          child: Container(
                            color: Colors.white,
                            width: SizeConfig.blockSizeHorizontal * 100,
                            child: Text(
                              //  GlobalLists.clientmasterlist[index].clientName==null?"":
                              GlobalLists.clientmasterlist[index].clientName,
                              style: AppFonts.headerStyle(
                                  fontSize: 14,
                                  color: customcolor.black,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                        ),
                      ),
                      Divider(color: customcolor.greybg)
                    ],
                  );
                })),
      ),
    );
  }

  //activity
  Widget activityDropdown(StateSetter setStateDialgoue) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Card(
        elevation: 5,
        child: Padding(
            padding: EdgeInsets.only(left: 10, right: 10, top: 10),
            child: ListView.builder(
                itemCount: GlobalLists.activitylist.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setStateDialgoue(() {
                            activitycontroller.text =
                                GlobalLists.activitylist[index].name;
                            activityid =
                                GlobalLists.activitylist[index].id.toString();
                            isexpandedactivity = false;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 3, bottom: 2),
                          child: Container(
                            color: Colors.white,
                            width: SizeConfig.blockSizeHorizontal * 100,
                            child: Text(
                              GlobalLists.activitylist[index].name,
                              style: AppFonts.headerStyle(
                                  fontSize: 14,
                                  color: customcolor.black,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Divider(color: customcolor.greybg)
                    ],
                  );
                })),
      ),
    );
  }
  //unit client master

  unitclientmasterApi() async {
    var status1 = await ConnectionDetector.checkInternetConnection();
    setState(() {
      GlobalLists.clientmasterlist = [];
    });
    if (status1) {
    

      var map = new Map<String, dynamic>();
      var supervisorid = await SPManager().getsupervisorid();

      map['emp_id'] = supervisorid;

      APIManager().apiRequest(context, API.unitclientmaster, (response) async {
        print("Ruchita");
        print(API.unitclientmaster);
        UnitclientMasterResponse resp = response;
        print('called API ${resp}');
        if (resp.status == 1) {
          setState(() {
            GlobalLists.clientmasterlist = resp.data;
          });
          print(GlobalLists.clientmasterlist[0].clientName);
          // Navigator.of(this.context).pop();R
          //  ShowDialogs.showToast(resp.msg);
        } else {
          ShowDialogs.showToast(resp.msg);
          // Navigator.of(this.context).pop();
        }
      }, (error) {
        print('ERR msg is $error');
        //  Navigator.of(this.context).pop();
      }, false, "", jsonval: map);
    } else {
      ShowDialogs.showToast("Please check internet connection");
    }
  }

  activitylistApi() async {
    var status1 = await ConnectionDetector.checkInternetConnection();
    setState(() {
      GlobalLists.activitylist = [];
    });
    if (status1) {
     

      var map = new Map<String, dynamic>();

      APIManager().apiRequest(context, API.operationalactivitylist,
          (response) async {
        print("Ruchita");

        actilist.ActivitylistResponse resp = response;
        print('called API ${resp}');
        if (resp.status == 1) {
          setState(() {
            GlobalLists.activitylist = resp.data;
          });
          print(GlobalLists.activitylist[0].name);
        } else {
          // ShowDialogs.showToast(resp.msg);
          // Navigator.of(this.context).pop();
        }
      }, (error) {
        print('ERR msg is $error');
        //  Navigator.of(this.context).pop();
      }, false, "", jsonval: map);
    } else {
      ShowDialogs.showToast("Please check internet connection");
    }
  }

  Widget norecordwidget() {
    return Container(
        child: Padding(
      padding: EdgeInsets.only(
        left: SizeConfig.blockSizeHorizontal * 30,
        top: SizeConfig.blockSizeVertical * 30,
      ),
      child: Text("No records found"),
    ));
  }

  attendancelist(List<mainactivity.Detail> detaillist) {
    return detaillist.length == 0
        ? norecordwidget()
        : ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: detaillist.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 2.0, bottom: 6),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    side: BorderSide(width: 0.5, color: customcolor.greyborder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              detaillist[index].activityType,
                              style: AppFonts.headerStyle(
                                  fontSize:17.sp,
                                  color: customcolor.black,
                                  fontWeight: FontWeight.w500),
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    imagelist = [];
                                    imagelist.add(ImageList(
                                        detaillist[index].activityType,
                                        detaillist[index].beforeImage1 == null
                                            ? ""
                                            : detaillist[index].beforeImage1!,
                                        "Before"));
                                    imagelist.add(ImageList(
                                        detaillist[index].activityType,
                                        detaillist[index].afterImage1 == null
                                            ? ""
                                            : detaillist[index].afterImage1!,
                                        "After"));
                                    imagelist.add(ImageList(
                                        detaillist[index].activityType,
                                        detaillist[index].beforeImage2 == null
                                            ? ""
                                            : detaillist[index].beforeImage2!,
                                        "Before"));
                                    imagelist.add(ImageList(
                                        detaillist[index].activityType,
                                        detaillist[index].afterImage2 == null
                                            ? ""
                                            : detaillist[index].afterImage2!,
                                        "After"));
                                    if (imagelist.length > 0) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  SpecialActivityImage(
                                                      imagelist)));
                                    }
                                  },
                                  child: Text(
                                    "View Image",
                                    style: AppFonts.headerStyle(
                                        fontSize: 17.sp,
                                        color: customcolor.tabblue,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Icon(
                                  Icons.arrow_forward,
                                  color: customcolor.tabblue,
                                  size: 20,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, top: 2, bottom: 15),
                        child: Container(
                          decoration: BoxDecoration(
                            color: customcolor.skybluebg,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Site",
                                      style: AppFonts.headerStyle(
                                          fontSize:
                                              15.sp,
                                          color: customcolor.greytext,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Text(
                                      detaillist[index].site,
                                      style: AppFonts.headerStyle(
                                          fontSize:
                                              17.sp,
                                          color: customcolor.black,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Date",
                                      style: AppFonts.headerStyle(
                                          fontSize:
                                              15.sp,
                                          color: customcolor.greytext,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Text(
                                      "${detaillist[index].date}",
                                      style: AppFonts.headerStyle(
                                          fontSize:
                                              17.sp,
                                          color: customcolor.black,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }

//attendance api
  // attendanceApi() async {
  //   var status1 = await ConnectionDetector.checkInternetConnection();

  //   if (status1) {
  //     GlobalLists.attendanceemployeelist = [];

  //     ShowDialogs.showLoadingDialog(context, _keyLoader);

  //     var map = new Map<String, dynamic>();

  //     var supervisorid = await SPManager().getsupervisorid();
  //     print(supervisorid);
  //     map['supervisor'] = supervisorid;

  //     APIManager().apiRequest(context, API.attendance, (response) async {
  //       AttendencelistResponse resp = response;
  //       print('called API ${resp}');
  //       if (resp.status == 1) {
  //         Navigator.of(this.context).pop();
  //         //   ShowDialogs.showToast(resp.msg);
  //         setState(() {
  //           attendancedata = resp.data;
  //           GlobalLists.attendanceemployeelist = resp.data.employeeList;
  //           isdataloaded = true;
  //         });
  //       } else {
  //         ShowDialogs.showToast(resp.msg);
  //         Navigator.of(this.context).pop();
  //       }
  //     }, (error) {
  //       print('ERR msg is $error');
  //     }, false, "", jsonval: map);
  //   } else {
  //     ShowDialogs.showToast("Please check internet connection");
  //   }
  // }

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

  String lat = position.latitude.toString();
  String long = position.longitude.toString();

  print("${first.name} : ${first.street}, ${first.locality}, ${first.country}");

  return first;
}
  //operationalspecialactivity
bool isSpecialActivityLoaded=false;
  getoperationalactivityApi() async {
    var status1 = await ConnectionDetector.checkInternetConnection();

    if (status1) {
      setState(() {
        mainlisttab = [];
      });

      
setState(() {
  isSpecialActivityLoaded=true;
});
      var map = new Map<String, dynamic>();
      var clientid = await SPManager().getclientid();
      var supervisorid = await SPManager().getsupervisorid();

      if (role == GlobalLists.clientrole) {
        print("CLIENT");
        map['clientid'] = clientid.toString();
        print("client id ${clientid}");
      } else {
        map['emp_id'] = supervisorid;
      }
      print(role);
      print(GlobalLists.clientrole);
      print("sushma fulldetail");
      APIManager().apiRequest(
          context, API.operationalfullDetail_SpecialActivity, (response) async {
        mainactivity.FullDetailSpecialActivityResponse resp = response;
        print('called API ${resp}');
        if (resp.status == 1) {
          setState(() {
  isSpecialActivityLoaded=false;
});
          // Navigator.of(this.context).pop();
          setState(() {
            print("sushma resp ${resp.data.length}");
            for (int i = 0; i < resp.data.length; i++) {
              mainlisttab.add(resp.data[i]);
              print("CLIENTNAME");
              print(resp.data[i].clientName);
              if (resp.data[i].clientName == widget.clientname) {
                //  int selectindex = resp.data.indexWhere((item) => item.clientName == "RMALL - Mulund");
                setState(() {
                  maintag = i;
                  print(maintag.toString());
                });
              }
            }
            print("sushma ${mainlisttab.length}");
          });
        } else {
          // ShowDialogs.showToast(resp.msg);
          // Navigator.of(this.context).pop();
          setState(() {
  isSpecialActivityLoaded=false;
});
        }
      }, (error) {
        print('ERR msg is $error');
        setState(() {
  isSpecialActivityLoaded=false;
});
        // Navigator.of(this.context).pop();
      }, false, "", jsonval: map);
    } else {
      ShowDialogs.showToast("Please check internet connection");
    }
  }
  //add activity
bool isAddActivtity=false;
  operationaladdactivityApi() async {
    print("|||||||||||||||||||||||");
    print("result");
    print("|||||||||||||||||||||||");
    var status = await ConnectionDetector.checkInternetConnection();
    if (status) {
      // ShowDialogs.showLoadingDialog(context, _keyLoader);
setState(() {
  isAddActivtity=true;
});
      var request = http.MultipartRequest(
          "POST", Uri.parse(APIManager.operationaladdspecialactivity));

      request.fields['activity_type'] = activityid;
      request.fields['date'] = datecontroller.text;
      request.fields['client'] = attendanceclientid;
      request.fields['site'] = attendancesiteid;
      if (beforeimage1 != "") {
        request.files.add(await http.MultipartFile.fromPath(
            'before_image1', beforeimage1!,
            contentType: new MediaType('application', 'x-tar')));
      }
      if (beforeimage1 != "") {
        request.files.add(await http.MultipartFile.fromPath(
            'before_image2', beforeimage2!,
            contentType: new MediaType('application', 'x-tar')));
      }
      if (afterimage1 != "") {
        request.files.add(await http.MultipartFile.fromPath(
            'after_image1', afterimage1!,
            contentType: new MediaType('application', 'x-tar')));
      }
      if (afterimage2 != "") {
        request.files.add(await http.MultipartFile.fromPath(
            'after_image2', afterimage2!,
            contentType: new MediaType('application', 'x-tar')));
      }
      var headers = {
        // "AppKey": APIManager.api_key,
        // "Authorization": "Bearer " + token!
      };
      //  ``   request.headers.addAll(headers);
      print(request.files);
      print(request.fields);
      var response = await request.send();

      final respStr = await response.stream.bytesToString();
      var res = json.decode(respStr);
      print("response.statusCode");
      print(response.statusCode);
      print(res);
      setState(() {
  isAddActivtity=false;
});
      // Navigator.of(_keyLoader.currentContext!).pop();
      if (response.statusCode == 200) {
        widget.clientname = clientcontroller.text;
        print("PRINT");
        print(widget.clientname);
        Timer(Duration(seconds: 1), () => Navigator.pop(context));
        ShowDialogs()
            .confirmationdone(context, "Activity Created \nSuccessfully");
        Timer(
            Duration(seconds: 1),
            () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        SpecialActivity(widget.clientname))));
      } else {
        ShowDialogs.showToast(res['msg']);
      }
    } else {
      SnackBar(
        content: Text('Please check your internet connection!'),
      );
    }
  }

  _displayPickImageDialog(
      BuildContext? context, OnPickImageCallback onPick) async {
    onPick(null, null, null);
  }

  Future<void> _showSelectionDialog(BuildContext context, int imageno) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "From where do you want to take the photo?",
                    style: TextStyle(
                        color: customcolor.blue,
                        fontSize: 15,
                        fontFamily: AppFonts.didot,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                      child: Text("Gallery"),
                      onTap: () {
                        Navigator.pop(context);
                        _openFileExplorer(imageno);
                      },
                    ),
                    Padding(padding: EdgeInsets.all(8.0)),
                    GestureDetector(
                      child: Text("Camera"),
                      onTap: () async {
                        Navigator.pop(context);

                        _onImageButtonPressed(ImageSource.camera, imageno,
                            context: context);
                      },
                    ),
                  ],
                ),
              ));
        });
  }

  // void _onImageButtonPressed(ImageSource source, int imageno,
  //     {BuildContext? context}) async {
  //   try {
   
  //     final pickedFile = await ImagePicker().pickImage(
  //       source: source,
  //       maxWidth: null,
  //       maxHeight: null,
  //       imageQuality: null,
  //     );
  
  //     await _displayPickImageDialog(context,
  //         (double? maxWidth, double? maxHeight, int? quality) async {});
  //     setState(() {
  //       print(pickedFile);
  //       _imageFile = File(pickedFile!.path);
  //       print(_imageFile!.path);
  //       _fileName = _imageFile!.path.split('/').last;
  //       if (imageno == 1) {
  //         beforeimage1 = _imageFile!.path;
  //         beforeimage1controller.text = _fileName!;
  //       } else if (imageno == 2) {
  //         beforeimage2 = _imageFile!.path;
  //         beforeimage2controller.text = _fileName!;
  //       } else if (imageno == 3) {
  //         afterimage1 = _imageFile!.path;
  //         afterimage1controller.text = _fileName!;
  //       } else if (imageno == 4) {
  //         afterimage2 = _imageFile!.path;
  //         afterimage2controller.text = _fileName!;
  //       }

  //     });
  //   } catch (e) {
  //     setState(() {
  //       _pickImageError = e;
  //       print("Ruchita $e");
  //     });
  //   }
  // }
 void _onImageButtonPressed(
  ImageSource source,
  int imageno, {
  BuildContext? context,
}) async {
  try {
    // ---------------- CAMERA MODE ----------------
    if (source == ImageSource.camera) {
      bool hasPermission =
          await PermissionHelper.requestPermission(Permission.camera);

      if (!hasPermission) {
        Flushbar(
          margin: const EdgeInsets.all(8),
          borderRadius: BorderRadius.circular(8),
          backgroundColor: customcolor.blue,
          message: "Camera permission denied",
          duration: const Duration(seconds: 2),
          flushbarPosition: FlushbarPosition.TOP,
        ).show(this.context);
        return;
      }

      // Open your custom camera UI
      Navigator.push(
        context!,
        MaterialPageRoute(
          builder: (context) => CameraCaptureScreen(
            onImageCaptured: (String imagePath) {
              File captured = File(imagePath);
              String fileName = captured.path.split('/').last;

              setState(() {
                _imageFile = captured;
                _fileName = fileName;

              
                if (imageno == 1) {
                  beforeimage1 = captured.path;
                  beforeimage1controller.text = fileName;
                } else if (imageno == 2) {
                  beforeimage2 = captured.path;
                  beforeimage2controller.text = fileName;
                } else if (imageno == 3) {
                  afterimage1 = captured.path;
                  afterimage1controller.text = fileName;
                } else if (imageno == 4) {
                  afterimage2 = captured.path;
                  afterimage2controller.text = fileName;
                }
              });
            },
          ),
        ),
      );

      return; // Stop here for camera mode
    }

  } catch (e) {
    setState(() {
      _pickImageError = e;
      print("Ruchita $e");
    });
  }
}

  void _openFileExplorer(int imageno) async {
    setState(() => _loadingPath = true);
    try {
      _directoryPath = null;
      _paths = (await FilePicker.platform.pickFiles(
        type: _pickingType,
        allowMultiple: false,

        allowedExtensions: [
          'jpg',
          'jpeg',
          'png',
        ],
        // allowedExtensions: (_extension?.isNotEmpty ?? false)
        //     ? _extension?.replaceAll(' ', '')?.split(',')
        //     : null,
      ))
          ?.files;
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    } catch (ex) {
      print(ex);
    }
    if (!mounted) return;
    setState(() async {
      _loadingPath = false;
      _fileName = _paths != null
          ? _paths!.map((e) => e.name).toString()
          : 'Select Document';
      print("File name is${_fileName}");
      // if(imageno==1)
      // {
      //   beforeimage1 = _paths![0].path;
      //   beforeimage1controller.text=_fileName!;
      // }else if(imageno==2)
      // {
      //   beforeimage2 = _paths![0].path;
      //   beforeimage2controller.text=_fileName!;
      // }else if(imageno==3)
      // {
      //   afterimage1 = _paths![0].path;
      //   afterimage1controller.text=_fileName!;
      // }else if(imageno==4)
      // {
      // afterimage2 = _paths![0].path;
      //   afterimage2controller.text=_fileName!;
      // }
      if (imageno == 1) {
        // beforeimage1 = _paths![0].path; old
        beforeimage1 = await compressimagepath(_paths![0].path!);
        print("new File name is ${beforeimage1}");
        beforeimage1controller.text = _fileName!;
      } else if (imageno == 2) {
        // beforeimage2 = _paths![0].path; old
        beforeimage2 = await compressimagepath(_paths![0].path!);
        beforeimage2controller.text = _fileName!;
      } else if (imageno == 3) {
        // afterimage1 = _paths![0].path; old
        afterimage1 = await compressimagepath(_paths![0].path!);
        afterimage1controller.text = _fileName!;
      } else if (imageno == 4) {
        // afterimage2 = _paths![0].path; old
        afterimage2 = await compressimagepath(_paths![0].path!);
        afterimage2controller.text = _fileName!;
      }
    });
  }
}

extension ExtendedIterable<E> on Iterable<E> {
  /// Like Iterable<T>.map but the callback has index as second argument
  Iterable<T> mapIndexed<T>(T Function(E e, int i) f) {
    var i = 0;
    return map((e) => f(e, i++));
  }

  void forEachIndexed(void Function(E e, int i) f) {
    var i = 0;
    forEach((e) => f(e, i++));
  }
}

typedef void OnPickImageCallback(
    double? maxWidth, double? maxHeight, int? quality);
