// ignore_for_file: unused_element, sized_box_for_whitespace, unnecessary_string_interpolations

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:another_flushbar/flushbar.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:janpro/Utitlity/ResponsiveFlutter.dart';
import 'package:janpro/services/gallery.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'dart:ui' as ui;
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:janpro/Screens/Attendance.dart';
import 'package:janpro/Screens/Homepage.dart';
import 'package:janpro/Screens/Training.dart';
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
import 'package:janpro/Utitlity/sizeConfig.dart';
import 'package:janpro/model/GetComplaintResponse.dart' as supercomp;
import 'package:janpro/model/GetDependentResponse.dart';
import 'package:janpro/model/MasterBlockResponse.dart';
import 'package:janpro/model/MasterareaResponse.dart';
import 'package:janpro/model/TicketllistResponse.dart';
import 'package:janpro/model/UnitComplaintResponse.dart' as unitcom;
import 'package:janpro/model/ClientsiteDashboardResponse.dart' as clientdash;
import 'package:janpro/model/UnitclientMasterResponse.dart';
import 'package:janpro/model/UpdateTATResponse.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart' as date;
import '../services/permission_helper.dart' as permission_helper;
import 'dart:math' as math;

import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:workmanager/workmanager.dart';

import '../DBHelper/db_helper.dart';
import '../const/global.dart';
import '../main.dart';
import '../model/GetComplaintResponse.dart';
import '../services/camera_capture_screen.dart';
import 'local_notifications.dart';
import 'new_custom_notification.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../services/permission_helper.dart';

class Complaint extends StatefulWidget {
  bool isnotify;
  String roleid;
  String siteid;
  String clientid;
  String date;
  String initalid;
  String status;
  String clientname;
  bool opencompliaint;

  Complaint(this.isnotify, this.roleid, this.siteid, this.clientid, this.date,
      this.initalid, this.status, this.clientname, this.opencompliaint);

  @override
  _ComplaintState createState() => _ComplaintState();
}

class _ComplaintState extends State<Complaint> with TickerProviderStateMixin {
  ItemScrollController _scrollController = ItemScrollController();

//  ItemScrollController itemScrollController = ItemScrollController();
//  ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
  var statuscontroller = new TextEditingController();
  final List<double> values = [0.5, 5.0, 10.0, 15.0];
  int selectedIndex = 0;
  String selectedValue = "Pending";
  late TabController _tabController;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  var selectedDateTime;
  bool _isLoading = false;

  //bool isoptionopen=false;
  List<String> options = [
    "TAT",
    "Dependent",
    "Resolved",
  ];
  var datecontroller = new TextEditingController();
  var tat_remark = new TextEditingController();

  var datetatcontroller = new TextEditingController();
  double containerHeight = 0;
  int maintag = 0;
  String _isSelected = "";
  List _dependentelements = [];
  List _pendingelements = [];
  List _resolvedelements = [];
  bool isexpanded = false;
  bool isexpandedcomplaint = false;
  var duration = "";
  late DateTime selectedtime;
  String attendanceclientid = "";
  String attendancesiteid = "";
  String siteidconfig = "";
  String complainttype = "";
  String blockid = "";

  double _value = 5.0;
  var complainttypecontroller = new TextEditingController();
  var complaintcontroller = new TextEditingController();
  var clientcontroller = new TextEditingController();
  var imagecontroller = new TextEditingController();
  int initialindex = 0;

  List<DropdownMenuItem<String>> _dropDownItem() {
    List<String> ddl = ["NONE", "1 YEAR", "2 YEAR"];

    return ddl
        .map((value) => DropdownMenuItem(
              value: value,
              child: Text(value),
            ))
        .toList();
  }

  String? role = "1";
  List<unitcom.DatumElement> mainlisttab = [];
  ItemScrollController _supervisorcontroller = ItemScrollController();
  ItemScrollController _supervisortab2controller = ItemScrollController();
  ItemScrollController _supervisortab3controller = ItemScrollController();

  //
  ItemScrollController _clientcontroller = ItemScrollController();
  ItemScrollController _clienttab2controller = ItemScrollController();
  ItemScrollController _clienttab3controller = ItemScrollController();
  GlobalKey _listKey = GlobalKey();
  List<String> clientlist = ["Client 1", "Client 2"];
  List<String> masterarealist = ["Cleaning", "Grooming", "Salary", "Equipment"];
  List<String> masterblocklist = [
    "Basement",
    "First Floor",
    "Second Floor",
    "THird Floor"
  ];

  List<String> complaintlist = ["Lobby", "Washroom", "Cabin", "Meeting Room"];

  bool isexpandedmasterarea = false;
  bool isexpandedmasterblock = false;
  var masterareacontroller = new TextEditingController();
  var masterblockcontroller = new TextEditingController();
  List<String> result = [];
  File? _imageFile;
  dynamic _pickImageError;
  File? image;
  String? _fileName;
  List<PlatformFile>? _paths;
  String? _directoryPath;
  String? _extension;
  bool _loadingPath = false;
  FileType _pickingType = FileType.custom;
  String areaid = "";
  var _activeIndex = 0;

//new added
/*  @override
  void dispose() {
    _paths?.clear();
    result.clear();
    statuscontroller.dispose();
    datecontroller.dispose();
    datetatcontroller.dispose();
    complainttypecontroller.dispose();
    complaintcontroller.dispose();
    clientcontroller.dispose();
    imagecontroller.dispose();
    masterareacontroller.dispose();
    masterblockcontroller.dispose();
    // Dispose TabController
    _tabController.dispose();
    super.dispose();
  }*/
Future<void> openGallery() async {
  bool allowed = await requestGalleryPermission();

  if (!allowed) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Gallery permission denied")),
    );
    return;
  }

  // ✅ Safe to open gallery / FilePicker / ImagePicker
}

  @override
  void initState() {
    super.initState();
    // openGallery();
    setState(() {
      selectedDateTime = DateTime.now();
      datetatcontroller.text =
          DateFormat('dd-MM-yyyy').format(selectedDateTime!);
      if (widget.isnotify) {
        role = widget.roleid;
        log('role $role');

        GlobalLists.siteid = widget.siteid;
        datecontroller.text = widget.date;
        _tabController = new TabController(
            vsync: this,
            length: 3,
            initialIndex: widget.status == "Pending"
                ? 0
                : widget.status == "Dependent"
                    ? 1
                    : widget.status == "Resolved"
                        ? 2
                        : 0);
      } else {
        _tabController = new TabController(vsync: this, length: 3);

        var datefrom = DateFormat('dd-MM-yyyy').format(DateTime.now());
        datecontroller.text = datefrom;
      }
      _tabController.addListener(() {
        setState(() {
          _activeIndex = _tabController.index;
          print('_activeIndex: $_activeIndex');
        });
      });
    });

    getrole();
  }

  List<bool> isExpandedList = [];
  List<bool> isExpandedListdependent = [];
  List<bool> isExpandedListresolved = [];
  List<bool> issuperExpandedList = [];
  List<bool> issuperExpandedListdependent = [];
  List<bool> issuperExpandedListresolved = [];

  getrole() async {
    role = await SPManager().getroleid();
    if (role == GlobalLists.unitrole ||
        role == GlobalLists.headrole ||
        role == GlobalLists.reginalmanagerrole ||
        role == GlobalLists.clientrole ||
        role == GlobalLists.operationrole ||
        role == GlobalLists.operationmanagerrole) {
      setState(() {
        // mainlisttab.add(MainList("IMAX","1"));
        //  mainlisttab.add(MainList("Cinipol","1"));
        //   mainlisttab.add(MainList("Cinimax","0"));
      });
    }
    if (role == GlobalLists.unitrole ||
        role == GlobalLists.operationrole ||
        role == GlobalLists.headrole ||
        role == GlobalLists.reginalmanagerrole ||
        role == GlobalLists.clientrole ||
        role == GlobalLists.operationmanagerrole) {
      print("unit");
      print("RUCHI 31oct");
      getunitcomplaintApi();
    } else {
      getcomplaintApi();
    }
    if (role == GlobalLists.clientrole) {
      clientdashboardApi();
      clientticketmasterApi();
    }
    print(widget.opencompliaint);
    if (widget.opencompliaint) {
      addcomplaint(context);
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey1 = new GlobalKey<ScaffoldState>();
  GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  Future<void> refreshData() async {
    // Simulating an API request or data refresh
    setState(() {
      print("APICall");
      print(_activeIndex);
      //     var  datefrom =
      //                                   DateFormat('dd-MM-yyyy').format(DateTime.now());
      // datecontroller.text=datefrom;
      getrole();

      _tabController =
          new TabController(vsync: this, length: 3, initialIndex: _activeIndex);
    });
  }

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
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          //floating action button position to center
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(148),
            child: AppbarComman(
                setStyleStr: 'Complaints',
                onPressedBack: () {},
                onPressedNotify: () {},
                onPressedSearch: () {},
                onPressedSort: () {},
                onPressedmenu: () {
                  _scaffoldKey1.currentState!.openEndDrawer();
                }),
          ),
          bottomNavigationBar: CustomBottomNavigationBar(index: 2),
          body:

              // iscomplaintLoadin?
              //Center(child: Column(
              //    mainAxisAlignment: MainAxisAlignment.center,
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   children: [
              //     CircularProgressIndicator(color: customcolor.blue,),
              //    SizedBox(height: 15),
              //         Text("Loading, please wait...",
              //             style: TextStyle(
              //                 color:   Colors.black))
              //   ],
              // )):
              ValueListenableBuilder<bool>(
                  valueListenable: GlobalLists.iscomplaintLoadin,
                  builder: (context, isLoading, _) {
                    if (isLoading) {
                      return Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            color: customcolor.blue,
                          ),
                          SizedBox(height: 15),
                          Text("Loading, please wait...",
                              style: TextStyle(color: Colors.black))
                        ],
                      ));
                    }
                    return Stack(
                      children: [
                        SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 20, bottom: 20),
                            child: Container(
                                child: (role == GlobalLists.unitrole ||
                                        role == GlobalLists.headrole ||
                                        role ==
                                            GlobalLists.reginalmanagerrole ||
                                        role == GlobalLists.clientrole ||
                                        role == GlobalLists.operationrole ||
                                        role ==
                                            GlobalLists.operationmanagerrole)
                                    ? unitcomplaint()
                                    : supervisorcompliant()),
                          ),
                        ),
                        (role == GlobalLists.clientrole)
                            ? Align(
                                alignment: Alignment.bottomRight,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FloatingActionButton(
                                    backgroundColor: customcolor.blue,
                                    onPressed: () {
                                      // Add your action for the center button here
                                      clientcontroller.text = "";
                                      complaintcontroller.text = "";
                                      complainttypecontroller.text = "";
                                      masterareacontroller.text = "";
                                      masterblockcontroller.text = "";
                                      areaid = "";
                                      blockid = "";
                                      attendanceclientid = "";
                                      attendancesiteid = "";
                                      result = [];
                                      isexpanded = false;
                                      isexpandedcomplaint = false;
                                      isexpandedmasterarea = false;
                                      isexpandedmasterblock = false;
                                      imagecontroller.text = "";
                                      addcomplaint(context);
                                    },
                                    child: Icon(
                                      Icons.add,
                                      color: customcolor.white,
                                    ),
                                  ),
                                ),
                              )
                            : Container()
                      ],
                    );
                  })),
    );
  }

  Widget unitcomplaint() {
    return CustomRefreshIndicator(
      key: refreshIndicatorKey,
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
        //physics: AlwaysScrollabelScrollPhysics(),
        shrinkWrap: true,
        // physics: ScrollPhysics(),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  // GestureDetector(
                  //     onTap: () {
                  //       Navigator.push(
                  //         context,
                  //         PageRouteBuilder(
                  //           pageBuilder: (context, animation1, animation2) =>
                  //               HomePage(),
                  //         ),
                  //       );
                  //     },
                  //     child: Icon(Icons.arrow_back)),
                  // SizedBox(
                  //   width: 10,
                  // ),
                  Container(
                    child: Text(
                      "COMPLAINTS",
                      style: AppFonts.headerStyle(
                          fontSize: ResponsiveFlutter.of(context).fontSize(2.3),
                          color: customcolor.title,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                ],
              ),
              mainlisttab.length > 0 ? _buildChoicemainListForTab() : SizedBox()
            ],
          ),
          mainlisttab.length > 0
              ? Padding(
                  padding: const EdgeInsets.only(top: 14, bottom: 14),
                  child: Container(
                    height: 25,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      children: _buildChoicemainList(),
                    ),
                  ))
              : norecordwidget(),
          mainlisttab.length > 0 ? unitcomplainttabs() : Container(),
        ],
      ),
    );
  }

  Widget unitcomplainttabs() {
    // _unitscrolltoindex(init)

    return Container(
      height: SizeConfig.blockSizeVertical * 90,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: TabBar(
              onTap: (value) {
                _activeIndex = value;
              },
              isScrollable: true,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorWeight: 2,
              unselectedLabelColor: customcolor.black,
              indicatorColor: customcolor.blue,

              labelColor: customcolor.blue,
              indicatorPadding: EdgeInsets.only(top: 10, bottom: 10),
              // indicator: BoxDecoration(
              //   color: customcolor.darkorange,
              //   // borderRadius: BorderRadius.all(
              //   //   Radius.circular(1),
              //   // ),
              // ),
              tabs: [
                Tab(
                  text: "Pending",
                ),
                Tab(
                  text: "Dependent",
                ),
                Tab(
                  text: "Resolved",
                ),
              ],
              controller: _tabController,
            ),
          ),
          Expanded(
            // flex: 3,
            child: TabBarView(
                physics: ScrollPhysics(),
                controller: _tabController,
                children: [
                  unitcomplaintdetail(mainlisttab[maintag].pendingdata, "1"),
                  unitcomplainttab2detail(
                      mainlisttab[maintag].dependentdata, "2"),
                  unitcomplainttab3detail(mainlisttab[maintag].resolvedata, "3")
                ]),
          ),
        ],
      ),
    );
  }

  _buildChoicemainList() {
    List<Widget> choices = [];
    mainlisttab.forEachIndexed((item, value) {
      choices.add(Container(
        height: 25,
        child: Padding(
          padding: const EdgeInsets.only(right: 5),
          child: ChoiceChip(
            label: Padding(
              padding: const EdgeInsets.only(
                bottom: 5,
              ),
              child: Text(
                item.clientName,
                /*style: AppFonts.headerStyle(
                    fontSize: 12,
                    color: maintag == value
                        ? customcolor.white
                        : item.clientName == "1"
                            ? customcolor.red
                            : customcolor.greytext,
                    fontWeight: FontWeight.bold),*/
                style: AppFonts.headerStyle(
                    fontSize: 12,
                    color: maintag == value
                        ? customcolor.white
                        : (item.pendingdata.isNotEmpty ||
                                item.dependentdata.isNotEmpty
                            ? customcolor.red
                            : customcolor.green),
                    fontWeight: FontWeight.bold),
              ),
            ),
            side: BorderSide(
                width: 0.5,
                color: maintag == value
                    ? customcolor.white
                    : item.clientName == "1"
                        ? customcolor.red
                        : customcolor.white),
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
              });
            },
          ),
        ),
      ));
    });
    return choices;
  }

  Widget _buildChoicemainListForTab() {
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
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      constraints: BoxConstraints(maxHeight: 500),
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
                                        fontWeight: FontWeight.w500,
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
                                          : (item.pendingdata.isNotEmpty ||
                                                  item.dependentdata.isNotEmpty)
                                              ? customcolor.red
                                              : customcolor.green;

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

  Widget supervisorcompliant() {
    return CustomRefreshIndicator(
      key: refreshIndicatorKey,
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

        // physics: ScrollPhysics(),

        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: Text(
                  "COMPLAINTS",
                  style: AppFonts.headerStyle(
                      fontSize: ResponsiveFlutter.of(context).fontSize(2.3),
                      color: customcolor.title,
                      fontWeight: FontWeight.normal),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: SizeConfig.blockSizeVertical * 94,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: TabBar(
                    onTap: (value) {
                      _activeIndex = value;
                    },
                    isScrollable: true,
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorWeight: 2,
                    unselectedLabelColor: customcolor.black,
                    indicatorColor: customcolor.blue,
                    labelColor: customcolor.blue,
                    indicatorPadding: EdgeInsets.only(top: 10, bottom: 10),
                    tabs: [
                      Tab(
                        text: "Pending",
                      ),
                      Tab(
                        text: "Dependent",
                      ),
                      Tab(
                        text: "Resolved",
                      ),
                    ],
                    controller: _tabController,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: TabBarView(
                      physics: ScrollPhysics(),
                      controller: _tabController,
                      children: [
                        complaintdetail(GlobalLists.pendingcomlist, "1"),
                        complaintdetailtab2(GlobalLists.dependentcomlist, "2"),
                        complaintdetailtab3(GlobalLists.resolvedlist, "3")
                      ]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _unitscrollToIndex(int index) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Initialize the scroll controller with the list's state
      if (widget.status == "Pending") {
        _clientcontroller.jumpTo(index: index);
      } else if (widget.status == "Dependent") {
        _clienttab2controller.jumpTo(index: index);
      } else if (widget.status == "Resolved") {
        _clienttab3controller.jumpTo(index: index);
      }
    });
  }

  void _scrollToIndex(int index) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Initialize the scroll controller with the list's state
      if (widget.status == "Pending") {
        _supervisorcontroller.jumpTo(index: index);
      } else if (widget.status == "Dependent") {
        _supervisortab2controller.jumpTo(index: index);
      } else if (widget.status == "Resolved") {
        _supervisortab3controller.jumpTo(index: index);
      }
    });
  }


  complaintdetail(List<supercomp.DependentdatumElement> _elements, String tab) {
      print("UNIT Tcomplaintdetail TAB");
    // Sort elements by loggedAt (oldest first)
    _elements.sort((a, b) => a.loggedAt.compareTo(b.loggedAt));

    // Alternative grouping that preserves original loggedAt format but groups by date
    Map<String, List<supercomp.DependentdatumElement>> groupedElements = {};
    for (var element in _elements) {
      // Extract the date part from between parentheses
      String dateKey =
          element.loggedAt.split('(')[1].replaceAll(')', '').trim();
      if (!groupedElements.containsKey(dateKey)) {
        groupedElements[dateKey] = [];
      }
      groupedElements[dateKey]!.add(element);
    }

// Sort dates by converting to DateTime
    List<String> sortedDates = groupedElements.keys.toList()
      ..sort((a, b) {
        DateFormat format = DateFormat('dd MMM yyyy');
        DateTime dateA = format.parse(a);
        DateTime dateB = format.parse(b);
        return dateA.compareTo(dateB);
      });

    issuperExpandedList =
        List<bool>.generate(_elements.length, (index) => false);
    return _elements.length > 0
        ? Padding(
            padding: const EdgeInsets.only(bottom: 200),
            child: ScrollablePositionedList.builder(
              scrollDirection: Axis.vertical,
              itemScrollController: _supervisorcontroller,
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemCount: sortedDates.length,
              itemBuilder: (c, dateIndex) {
                String date = sortedDates[dateIndex];
                List<supercomp.DependentdatumElement> dateElements =
                    groupedElements[date]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          date,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ),
                    ...dateElements.map((element) {
                      int globalIndex = _elements.indexOf(element);
                      return Stack(
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: Card(
                              margin: new EdgeInsets.symmetric(
                                  horizontal: 2.0, vertical: 6.0),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                              child: GestureDetector(
                                onTap: () {},
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5, right: 5),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        if (element.image1 !=
                                                                "" ||
                                                            element.image1 !=
                                                                null) {
                                                          showimage(
                                                              context,
                                                              "Complaint Images",
                                                              element.image1,
                                                              element.image2,element.close_img1,element.close_img2);
                                                        }
                                                      },
                                                      child: Image.network(
                                                          "${element.image1}",
                                                          width: SizeConfig
                                                                  .blockSizeHorizontal *
                                                              10,
                                                          fit: BoxFit.cover,
                                                          loadingBuilder: (BuildContext context,
                                                              Widget child,
                                                              ImageChunkEvent?
                                                                  loadingProgress) {
                                                        if (loadingProgress ==
                                                            null) {
                                                          // ✅ Image loaded successfully
                                                          return child;
                                                        } else {
                                                          // ⏳ Show loader while image is loading
                                                          return SizedBox(
                                                            width: SizeConfig
                                                                    .blockSizeHorizontal *
                                                                10,
                                                            height: SizeConfig
                                                                    .safeBlockVertical *
                                                                5,
                                                            child: Center(
                                                              child:
                                                                  CircularProgressIndicator(
                                                                color:
                                                                    customcolor
                                                                        .blue,
                                                                strokeWidth:
                                                                    2.0,
                                                                valueColor:
                                                                    AlwaysStoppedAnimation<
                                                                            Color>(
                                                                        Colors
                                                                            .blueAccent),
                                                                value: loadingProgress
                                                                            .expectedTotalBytes !=
                                                                        null
                                                                    ? loadingProgress
                                                                            .cumulativeBytesLoaded /
                                                                        (loadingProgress.expectedTotalBytes ??
                                                                            1)
                                                                    : null,
                                                              ),
                                                            ),
                                                          );
                                                        }
                                                      }, errorBuilder: (BuildContext
                                                                  context,
                                                              Object exception,
                                                              StackTrace? stackTrace) {
                                                        return Icon(
                                                          Icons.error_outline,
                                                          size: SizeConfig
                                                                  .blockSizeHorizontal *
                                                              10,
                                                        );
                                                      }
                                                        
                                                          ),
                                                    ),
                                                    SizedBox(
                                                      width: SizeConfig
                                                              .blockSizeHorizontal *
                                                          2,
                                                    ),
                                                    Container(
                                                      width: SizeConfig
                                                              .blockSizeHorizontal *
                                                          38,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "${element.complainantName}",
                                                            style: AppFonts.headerStyle(
                                                                fontSize: ResponsiveFlutter.of(
                                                                        context)
                                                                    .fontSize(
                                                                        2),
                                                                color:
                                                                    customcolor
                                                                        .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          element.complainantName ==
                                                                  "Cleaning"
                                                              ? Text(
                                                                  "${element.masterAreaName}-${element.masterBlockName}",
                                                                  style: AppFonts.headerStyle(
                                                                      fontSize: ResponsiveFlutter.of(
                                                                              context)
                                                                          .fontSize(
                                                                              1.4),
                                                                      color: customcolor
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400),
                                                                )
                                                              : Container(),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Flexible(
                                                    child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15)),
                                                    backgroundColor: tab == "3"
                                                        ? customcolor.green
                                                        : tab == "2"
                                                            ? customcolor
                                                                .tabblue
                                                            : element.status ==
                                                                    "Not Acknowleged"
                                                                ? customcolor
                                                                    .yellow
                                                                : (element.status ==
                                                                            "In-Progress" ||
                                                                        element.status ==
                                                                            "In Progress")
                                                                    ? customcolor
                                                                        .darkorange
                                                                    : customcolor
                                                                        .red,
                                                    minimumSize: Size(
                                                        SizeConfig
                                                                .blockSizeHorizontal *
                                                            34,
                                                        SizeConfig
                                                                .blockSizeVertical *
                                                            3),
                                                    textStyle:
                                                        AppFonts.headerStyle(
                                                            fontSize: 15,
                                                            color: customcolor
                                                                .black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                  ),
                                                  onPressed: () {},
                                                  child: Text(
                                                    tab == "3"
                                                        ? "Resolved"
                                                        : tab == "2"
                                                            ? "Dependent"
                                                            : element.status,
                                                    style: AppFonts.headerStyle(
                                                        fontSize: 12,
                                                        color:
                                                            customcolor.white,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                )),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 1,
                                          ),
                                          Container(
                                            width:
                                                SizeConfig.blockSizeHorizontal *
                                                    100,
                                            child: Card(
                                                color: customcolor.skybluebg,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(10),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      LayoutBuilder(
                                                        builder: (context,
                                                            constraints) {
                                                          final textPainter =
                                                              TextPainter(
                                                            text: TextSpan(
                                                              text: element
                                                                  .comment,
                                                              style: TextStyle(
                                                                  fontSize: 16),
                                                            ),
                                                            textDirection: ui
                                                                .TextDirection
                                                                .ltr,
                                                          );

                                                          textPainter.layout(
                                                            minWidth: 0,
                                                            maxWidth:
                                                                constraints
                                                                    .maxWidth,
                                                          );

                                                          final numberOfLines =
                                                              textPainter
                                                                  .computeLineMetrics()
                                                                  .length;

                                                          return Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                      'Complaint : '),
                                                                  Text(
                                                                    "${element.comment}",
                                                                    style: AppFonts.headerStyle(
                                                                        fontSize:
                                                                            ResponsiveFlutter.of(context).fontSize(
                                                                                1.4),
                                                                        color: customcolor
                                                                            .black,
                                                                        fontWeight:
                                                                            FontWeight.w400),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    maxLines:
                                                                        issuperExpandedList[globalIndex]
                                                                            ? null
                                                                            : 3,
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                  height: 2),
                                                              if (numberOfLines >
                                                                  5)
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      issuperExpandedList[
                                                                              globalIndex] =
                                                                          true;
                                                                      print(issuperExpandedList[
                                                                          globalIndex]);
                                                                      ShowDialogs.showSMDialog(
                                                                          context,
                                                                          element
                                                                              .complainantName,
                                                                          element
                                                                              .comment);
                                                                    });
                                                                  },
                                                                  child: Text(
                                                                    issuperExpandedList[
                                                                            globalIndex]
                                                                        ? ''
                                                                        : 'View More',
                                                                    style: AppFonts.headerStyle(
                                                                        fontSize:
                                                                            ResponsiveFlutter.of(context).fontSize(
                                                                                1.4),
                                                                        color: customcolor
                                                                            .blue,
                                                                        fontWeight:
                                                                            FontWeight.w400),
                                                                  ),
                                                                ),
                                                            ],
                                                          );
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                )),
                                          ),
                                          SizedBox(
                                            height: 4,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5, right: 5),
                                            child: Row(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    RichText(
                                                      textAlign:
                                                          TextAlign.justify,
                                                      text: TextSpan(
                                                        children: [
                                                          TextSpan(
                                                            text: "Logged at-",
                                                            style: AppFonts.headerStyle(
                                                                fontSize: 12,
                                                                color:
                                                                    customcolor
                                                                        .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal),
                                                          ),
                                                          TextSpan(
                                                            text:
                                                                "${element.loggedAt}",
                                                            style: AppFonts.headerStyle(
                                                                fontSize: 12,
                                                                color:
                                                                    customcolor
                                                                        .tabblue,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    tab == "2"
                                                        ? Container()
                                                        : element.turnAroundTime ==
                                                                ""
                                                            ? Container()
                                                            : Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left: 5,
                                                                        right:
                                                                            3),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    RichText(
                                                                      textAlign:
                                                                          TextAlign
                                                                              .justify,
                                                                      text:
                                                                          TextSpan(
                                                                        children: [
                                                                          TextSpan(
                                                                            text:
                                                                                "TAT - ",
                                                                            style: AppFonts.headerStyle(
                                                                                fontSize: 12,
                                                                                color: customcolor.black,
                                                                                fontWeight: FontWeight.normal),
                                                                          ),
                                                                          TextSpan(
                                                                            text:
                                                                                "${element.turnAroundTime}",
                                                                            style: AppFonts.headerStyle(
                                                                                fontSize: 12,
                                                                                color: tab == "3"
                                                                                    ? customcolor.green
                                                                                    : (element.status == "In-Progress" || element.status == "In Progress")
                                                                                        ? customcolor.darkorange
                                                                                        : (element.status == "Critical")
                                                                                            ? customcolor.red
                                                                                            : customcolor.blue,
                                                                                fontWeight: FontWeight.w500),
                                                                          ),
                                                                          TextSpan(
                                                                            text:
                                                                                " (${element.tatDate.toString()})",
                                                                            style: AppFonts.headerStyle(
                                                                                fontSize: 12,
                                                                                color: tab == "3"
                                                                                    ? customcolor.green
                                                                                    : (element.status == "In-Progress" || element.status == "In Progress")
                                                                                        ? customcolor.darkorange
                                                                                        : (element.status == "Critical")
                                                                                            ? customcolor.red
                                                                                            : customcolor.blue,
                                                                                fontWeight: FontWeight.w500),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    (role == GlobalLists.headrole ||
                                            role ==
                                                GlobalLists
                                                    .reginalmanagerrole ||
                                            role == GlobalLists.operationrole ||
                                            role ==
                                                GlobalLists.supervisorrole ||
                                            role ==
                                                GlobalLists
                                                    .operationmanagerrole)
                                        ? tab == "1"
                                            ? Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Divider(),
                                                  GestureDetector(
                                                    onTap: () {},
                                                    child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 4,
                                                                bottom: 4),
                                                        child: Center(
                                                          child: element
                                                                      .status ==
                                                                  "Not Acknowleged"
                                                              ? IntrinsicHeight(
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Container(
                                                                        width: SizeConfig.blockSizeHorizontal *
                                                                            40,
                                                                        child:
                                                                            GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            addtimer(
                                                                                context,
                                                                                "add",
                                                                                element.id.toString());
                                                                          },
                                                                          child: Center(
                                                                              child: Text(
                                                                            'Add Turn Around Time',
                                                                            style: AppFonts.headerStyle(
                                                                                fontSize: ResponsiveFlutter.of(context).fontSize(1.8),
                                                                                color: customcolor.tabblue,
                                                                                fontWeight: FontWeight.normal),
                                                                          )),
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        width:
                                                                            SizeConfig.blockSizeHorizontal *
                                                                                5,
                                                                        child:
                                                                            VerticalDivider(
                                                                          color:
                                                                              customcolor.greyborder,
                                                                          thickness:
                                                                              1,
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        width: SizeConfig.blockSizeHorizontal *
                                                                            40,
                                                                        child:
                                                                            GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            getoperationdependentApi(element.id.toString());
                                                                          },
                                                                          child: Center(
                                                                              child: Text(
                                                                            'Mark as Dependent',
                                                                            style: AppFonts.headerStyle(
                                                                                fontSize: ResponsiveFlutter.of(context).fontSize(1.8),
                                                                                color: customcolor.tabblue,
                                                                                fontWeight: FontWeight.normal),
                                                                          )),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                )
                                                              : Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceEvenly,
                                                                  children: [
                                                                    (element.status == "Escalated" ||
                                                                            element.status ==
                                                                                "In-Progress" ||
                                                                            element.status ==
                                                                                "In Progress" ||
                                                                            element.status ==
                                                                                "Critical")
                                                                        ? GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              addtimer(context, "edit", element.id.toString());
                                                                            },
                                                                            child:
                                                                                Text(
                                                                              'Edit Turn Around Time',
                                                                              style: AppFonts.headerStyle(
                                                                                fontSize: ResponsiveFlutter.of(context).fontSize(1.8),
                                                                                color: customcolor.tabblue,
                                                                                fontWeight: FontWeight.normal,
                                                                              ),
                                                                            ),
                                                                          )
                                                                        : SizedBox(),
                                                                    element.TAT_remark !=
                                                                                null &&
                                                                            (element.status == "Escalated" ||
                                                                                element.status == "In-Progress" ||
                                                                                element.status == "In Progress" ||
                                                                                element.status == "Critical")
                                                                        ? Container(
                                                                            height:
                                                                                18,
                                                                            width:
                                                                                1,
                                                                            color:
                                                                                customcolor.greyborder,
                                                                          )
                                                                        : SizedBox(),
                                                                    element.TAT_remark ==
                                                                            null||element.TAT_remark.isEmpty
                                                                        ? SizedBox()
                                                                        : GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              showRemarkDialog(context, element.TAT_remark);
                                                                            },
                                                                            child:
                                                                                Text(
                                                                              'View Remark',
                                                                              style: AppFonts.headerStyle(
                                                                                fontSize: ResponsiveFlutter.of(context).fontSize(1.8),
                                                                                color: customcolor.tabblue,
                                                                                fontWeight: FontWeight.normal,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                  ],
                                                                ),
                                                        )),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      border: Border(
                                                        bottom: BorderSide(
                                                            color: customcolor
                                                                .greybg),
                                                      ),
                                                    ),
                                                  ),
                                                  element.status ==
                                                          "Not Acknowleged"
                                                      ? Container()
                                                      : Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: customcolor
                                                                .green,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              bottomLeft: Radius
                                                                  .circular(15),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          15),
                                                            ),
                                                          ),
                                                          child:
                                                              SwipeActionCell(
                                                            fullSwipeFactor:
                                                                0.1,
                                                            selectedForegroundColor:
                                                                customcolor
                                                                    .green,
                                                            backgroundColor:
                                                                customcolor
                                                                    .greybg,
                                                            key: ObjectKey(0),
                                                            leadingActions: [
                                                              SwipeAction(
                                                                icon: Icon(
                                                                  Icons.check,
                                                                  color:
                                                                      customcolor
                                                                          .green,
                                                                ),
                                                                performsFirstActionWithFullSwipe:
                                                                    true,
                                                                onTap: (CompletionHandler
                                                                    handler) async {
                                                                  setState(() {
                                                                    print(
                                                                        "Resolvef");
                                                                    getoperationalresolvedApi(
                                                                        element
                                                                            .id
                                                                            .toString());
                                                                    handler(
                                                                        true);
                                                                  });
                                                                },
                                                                color:
                                                                    customcolor
                                                                        .green,
                                                              ),
                                                            ],
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .only(
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          15),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          15),
                                                                ),
                                                              ),
                                                              height: 40,
                                                              child: Row(
                                                                children: [
                                                                  Container(
                                                                    width: SizeConfig
                                                                            .safeBlockHorizontal *
                                                                        15,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: customcolor
                                                                          .green,
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .only(
                                                                        bottomLeft:
                                                                            Radius.circular(10),
                                                                      ),
                                                                    ),
                                                                    height: 40,
                                                                    child: Icon(
                                                                      Icons
                                                                          .arrow_forward,
                                                                      color: customcolor
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: SizeConfig
                                                                            .blockSizeHorizontal *
                                                                        5,
                                                                  ),
                                                                  Center(
                                                                    child: Text(
                                                                      'Swipe if complaint is resolved >>',
                                                                      style: AppFonts.headerStyle(
                                                                          fontSize: ResponsiveFlutter.of(context).fontSize(
                                                                              2),
                                                                          color: customcolor
                                                                              .greytext,
                                                                          fontWeight:
                                                                              FontWeight.normal),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                ],
                                              )
                                            : tab == "2"
                                                ? Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      element.status ==
                                                              "Not Acknowleged"
                                                          ? Container()
                                                          : Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color:
                                                                    customcolor
                                                                        .green,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .only(
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          15),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          15),
                                                                ),
                                                              ),
                                                              child:
                                                                  SwipeActionCell(
                                                                fullSwipeFactor:
                                                                    0.1,
                                                                selectedForegroundColor:
                                                                    customcolor
                                                                        .green,
                                                                backgroundColor:
                                                                    customcolor
                                                                        .greybg,
                                                                key: ObjectKey(
                                                                    0),
                                                                leadingActions: [
                                                                  SwipeAction(
                                                                    icon: Icon(
                                                                      Icons
                                                                          .check,
                                                                      color: customcolor
                                                                          .green,
                                                                    ),
                                                                    performsFirstActionWithFullSwipe:
                                                                        true,
                                                                    onTap: (CompletionHandler
                                                                        handler) async {
                                                                      setState(
                                                                          () {
                                                                        print(
                                                                            "Resolvef");
                                                                        getoperationalresolvedApi(element
                                                                            .id
                                                                            .toString());
                                                                        handler(
                                                                            true);
                                                                      });
                                                                    },
                                                                    color: customcolor
                                                                        .green,
                                                                  ),
                                                                ],
                                                                child:
                                                                    Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .white,
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .only(
                                                                      bottomLeft:
                                                                          Radius.circular(
                                                                              15),
                                                                      bottomRight:
                                                                          Radius.circular(
                                                                              15),
                                                                    ),
                                                                  ),
                                                                  height: 40,
                                                                  child: Row(
                                                                    children: [
                                                                      Container(
                                                                        width: SizeConfig.safeBlockHorizontal *
                                                                            15,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              customcolor.green,
                                                                          borderRadius:
                                                                              BorderRadius.only(
                                                                            bottomLeft:
                                                                                Radius.circular(10),
                                                                          ),
                                                                        ),
                                                                        height:
                                                                            40,
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .arrow_forward,
                                                                          color:
                                                                              customcolor.white,
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            SizeConfig.blockSizeHorizontal *
                                                                                5,
                                                                      ),
                                                                      Center(
                                                                        child:
                                                                            Text(
                                                                          'Swipe if complaint is resolved >>',
                                                                          style: AppFonts.headerStyle(
                                                                              fontSize: ResponsiveFlutter.of(context).fontSize(2),
                                                                              color: customcolor.greytext,
                                                                              fontWeight: FontWeight.normal),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                    ],
                                                  )
                                                : Container()
                                        : SizedBox(
                                            height: 0,
                                          )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ],
                );
              },
            ),
          )
        : norecordwidget();
  }

  complaintdetailtab2(
      List<supercomp.DependentdatumElement> _elements, String tab) {
        print("UNIT complaintdetailtab2");
    issuperExpandedListdependent =
        List<bool>.generate(_elements.length, (index) => false);
   
    print("initialindexmatch");

    _supervisortab2controller = ItemScrollController();
    return _elements.length > 0
        ? Padding(
            padding: const EdgeInsets.only(bottom: 200),
            child: ScrollablePositionedList.builder(
              scrollDirection: Axis.vertical,
              //  key: _listKey,
              itemScrollController: _supervisortab2controller,
              //     itemScrollController: itemScrollController,
              // itemPositionsListener: itemPositionsListener,

              //  itemScrollController: _scrollsuperController,
              //  initialScrollIndex: 10,
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemCount: _elements.length,
              itemBuilder: (c, element) {
                return Stack(
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Card(
                        // elevation: 8.0,
                        margin: new EdgeInsets.symmetric(
                            horizontal: 2.0, vertical: 6.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: GestureDetector(
                          onTap: () {},
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5, right: 5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  if (_elements[element]
                                                              .image1 !=
                                                          "" ||
                                                      _elements[element]
                                                              .image1 !=
                                                          null) {
                                                    showimage(
                                                        context,
                                                        "Complaints",
                                                        _elements[element]
                                                            .image1,
                                                        _elements[element]
                                                            .image2, _elements[element]
                                                            .close_img1, _elements[element]
                                                            .close_img2);
                                                  }
                                                },
                                                child: Image.network(
                                                  "${_elements[element].image1}",
                                                  width: SizeConfig
                                                          .blockSizeHorizontal *
                                                      10,
                                                  fit: BoxFit.cover,
                                                  loadingBuilder:
                                                      (BuildContext context,
                                                          Widget child,
                                                          ImageChunkEvent?
                                                              loadingProgress) {
                                                    if (loadingProgress ==
                                                        null) {
                                                      // ✅ Image loaded successfully
                                                      return child;
                                                    } else {
                                                      // ⏳ Show loader while image is loading
                                                      return SizedBox(
                                                        width: SizeConfig
                                                                .blockSizeHorizontal *
                                                            10,
                                                        height: SizeConfig
                                                                .safeBlockVertical *
                                                            5,
                                                        child: Center(
                                                          child:
                                                              CircularProgressIndicator(
                                                            color: customcolor
                                                                .blue,
                                                            strokeWidth: 2.0,
                                                            valueColor:
                                                                AlwaysStoppedAnimation<
                                                                        Color>(
                                                                    Colors
                                                                        .blueAccent),
                                                            value: loadingProgress
                                                                        .expectedTotalBytes !=
                                                                    null
                                                                ? loadingProgress
                                                                        .cumulativeBytesLoaded /
                                                                    (loadingProgress
                                                                            .expectedTotalBytes ??
                                                                        1)
                                                                : null,
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                  },
                                                  errorBuilder: (BuildContext
                                                          context,
                                                      Object exception,
                                                      StackTrace? stackTrace) {
                                                    return Icon(
                                                      Icons.error_outline,
                                                      size: SizeConfig
                                                              .blockSizeHorizontal *
                                                          10,
                                                    );
                                                  },
                                                  // width: SizeConfig
                                                  //         .blockSizeHorizontal *
                                                  //     10,
                                                  // height: SizeConfig
                                                  //         .safeBlockVertical *
                                                  //     5,
                                                  // errorBuilder: (BuildContext
                                                  //         context,
                                                  //     Object exception,
                                                  //     StackTrace? stackTrace) {
                                                  //   return Icon(
                                                  //     Icons.error_outline,
                                                  //     size: SizeConfig
                                                  //             .blockSizeHorizontal *
                                                  //         10,
                                                  //   );
                                                  // },
                                                ),
                                              ),
                                              // Image.asset( 'assets/images/image1.png',width: SizeConfig.blockSizeHorizontal*10,),
                                              SizedBox(
                                                width: SizeConfig
                                                        .blockSizeHorizontal *
                                                    2,
                                              ),
                                              Container(
                                                width: SizeConfig
                                                        .blockSizeHorizontal *
                                                    38,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "${_elements[element].complainantName}",
                                                      style: AppFonts.headerStyle(
                                                          fontSize:
                                                              ResponsiveFlutter
                                                                      .of(
                                                                          context)
                                                                  .fontSize(2),
                                                          color:
                                                              customcolor.black,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    _elements[element]
                                                                .complainantName ==
                                                            "Cleaning"
                                                        ? Text(
                                                            "${_elements[element].masterAreaName}-${_elements[element].masterBlockName}",
                                                            style: AppFonts.headerStyle(
                                                                fontSize: ResponsiveFlutter.of(
                                                                        context)
                                                                    .fontSize(
                                                                        1.4),
                                                                color:
                                                                    customcolor
                                                                        .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          )
                                                        : Container(),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Flexible(
                                              child:
                                                  //18april
                                                  // _elements[element].status=="Critical"?Container():

                                                  ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                              backgroundColor: tab == "3"
                                                  ? customcolor.green
                                                  : tab == "2"
                                                      ? customcolor.tabblue
                                                      : _elements[element]
                                                                  .status ==
                                                              "Not Acknowleged"
                                                          ? customcolor.yellow
                                                          : (_elements[element]
                                                                          .status ==
                                                                      "In-Progress" ||
                                                                  _elements[element]
                                                                          .status ==
                                                                      "In Progress")
                                                              ? customcolor
                                                                  .darkorange
                                                              : customcolor.red,
                                              minimumSize: Size(
                                                  SizeConfig
                                                          .blockSizeHorizontal *
                                                      34,
                                                  SizeConfig.blockSizeVertical *
                                                      3),
                                              textStyle: AppFonts.headerStyle(
                                                  fontSize: 15,
                                                  color: customcolor.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            onPressed: () {},
                                            child: Text(
                                              tab == "3"
                                                  ? "Resolved"
                                                  : tab == "2"
                                                      ? "Dependent"
                                                      : _elements[element]
                                                          .status,
                                              //=="Pending"?"Not Acknowledge":"Escalted",
                                              style: AppFonts.headerStyle(
                                                  fontSize: 12,
                                                  color: customcolor.white,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          )),
                                          //
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 1,
                                    ),
                                    Container(
                                      width:
                                          SizeConfig.blockSizeHorizontal * 100,
                                      child: Card(
                                          color: customcolor.skybluebg,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                LayoutBuilder(
                                                  builder:
                                                      (context, constraints) {
                                                    final textPainter =
                                                        TextPainter(
                                                      text: TextSpan(
                                                        text: _elements[element]
                                                            .comment,
                                                        style: TextStyle(
                                                            fontSize: 16),
                                                      ),
                                                      textDirection:
                                                          ui.TextDirection.ltr,
                                                    );

                                                    textPainter.layout(
                                                      minWidth: 0,
                                                      maxWidth:
                                                          constraints.maxWidth,
                                                    );

                                                    final numberOfLines =
                                                        textPainter
                                                            .computeLineMetrics()
                                                            .length;

                                                    return Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text('Complaint : ',
                                                                style: AppFonts.headerStyle(
                                                                    fontSize: ResponsiveFlutter.of(
                                                                            context)
                                                                        .fontSize(
                                                                            1.4),
                                                                    color: customcolor
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400)),
                                                            Text(
                                                              "${_elements[element].comment}",
                                                              style: AppFonts.headerStyle(
                                                                  fontSize: ResponsiveFlutter.of(
                                                                          context)
                                                                      .fontSize(
                                                                          1.4),
                                                                  color:
                                                                      customcolor
                                                                          .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              maxLines:
                                                                  issuperExpandedListdependent[
                                                                          element]
                                                                      ? null
                                                                      : 3,
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 2),
                                                        // Text(numberOfLines.toString()),
                                                        if (numberOfLines > 5)
                                                          GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                issuperExpandedListdependent[
                                                                        element] =
                                                                    true;
                                                                print(issuperExpandedListdependent[
                                                                    element]);
                                                                ShowDialogs.showSMDialog(
                                                                    context,
                                                                    _elements[
                                                                            element]
                                                                        .complainantName,
                                                                    _elements[
                                                                            element]
                                                                        .comment);
                                                              });
                                                            },
                                                            child: Text(
                                                              issuperExpandedListdependent[
                                                                      element]
                                                                  ? ''
                                                                  : 'View More',
                                                              //   numberOfLines.toString(),
                                                              style: AppFonts.headerStyle(
                                                                  fontSize: ResponsiveFlutter.of(
                                                                          context)
                                                                      .fontSize(
                                                                          1.4),
                                                                  color:
                                                                      customcolor
                                                                          .blue,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                            ),
                                                          ),
                                                      ],
                                                    );
                                                  },
                                                ),
                                                //           Text("${_elements[element].comment}",
                                                //           style:
                                                //            AppFonts.headerStyle(fontSize:ResponsiveFlutter.of(context).fontSize(1.4),
                                                // color: customcolor.black,fontWeight: FontWeight.w400  ),

                                                //   overflow: TextOverflow.ellipsis,
                                                //   maxLines: 3,),
                                                // SizedBox(height: 5,),
                                              ],
                                            ),
                                          )),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5, right: 5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          RichText(
                                            textAlign: TextAlign.justify,
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: "Logged at-",
                                                  style: AppFonts.headerStyle(
                                                      fontSize: 12,
                                                      color: customcolor.black,
                                                      fontWeight:
                                                          FontWeight.normal),
                                                ),
                                                TextSpan(
                                                  text:
                                                      "${_elements[element].loggedAt}",
                                                  style: AppFonts.headerStyle(
                                                      fontSize: 12,
                                                      color:
                                                          customcolor.tabblue,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                          ),
                                          tab == "2"
                                              ? Container()
                                              : _elements[element]
                                                          .turnAroundTime ==
                                                      ""
                                                  ? Container()
                                                  : Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 5,
                                                              right: 3),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          RichText(
                                                            textAlign: TextAlign
                                                                .justify,
                                                            text: TextSpan(
                                                              children: [
                                                                TextSpan(
                                                                  text:
                                                                      "TAT - ",
                                                                  style: AppFonts.headerStyle(
                                                                      fontSize:
                                                                          12,
                                                                      color: customcolor
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal),
                                                                ),
                                                                TextSpan(
                                                                  text:
                                                                      "${_elements[element].turnAroundTime}",
                                                                  style: AppFonts.headerStyle(
                                                                      fontSize: 12,
                                                                      color: tab == "3"
                                                                          ? customcolor.green
                                                                          : (_elements[element].status == "In-Progress" || _elements[element].status == "In Progress")
                                                                              ? customcolor.darkorange
                                                                              : (_elements[element].status == "Critical")
                                                                                  ? customcolor.red
                                                                                  : customcolor.blue,
                                                                      fontWeight: FontWeight.w500),
                                                                ),
                                                                TextSpan(
                                                                  text:
                                                                      " (${_elements[element].tatDate.toString()})",
                                                                  style: AppFonts.headerStyle(
                                                                      fontSize: 12,
                                                                      color: tab == "3"
                                                                          ? customcolor.green
                                                                          : (_elements[element].status == "In-Progress" || _elements[element].status == "In Progress")
                                                                              ? customcolor.darkorange
                                                                              : (_elements[element].status == "Critical")
                                                                                  ? customcolor.red
                                                                                  : customcolor.blue,
                                                                      fontWeight: FontWeight.w500),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                        ],
                                      ),
                                    ),

//
                                  ],
                                ),
                              ),
                              (role == GlobalLists.headrole ||
                                      role == GlobalLists.reginalmanagerrole ||
                                      role == GlobalLists.operationrole ||
                                      role == GlobalLists.supervisorrole ||
                                      role == GlobalLists.operationmanagerrole)
                                  ? tab == "1"
                                      ? Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Divider(),
                                            GestureDetector(
                                              onTap: () {},
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 4, bottom: 4),
                                                child: Center(
                                                    child: _elements[element]
                                                                .status ==
                                                            "Not Acknowleged"
                                                        ? IntrinsicHeight(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Container(
                                                                  width: SizeConfig
                                                                          .blockSizeHorizontal *
                                                                      40,
                                                                  child:
                                                                      GestureDetector(
                                                                    onTap: () {
                                                                      addtimer(
                                                                          context,
                                                                          "add",
                                                                          _elements[element]
                                                                              .id
                                                                              .toString());
                                                                    },
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        'Add Turn Around Time',
                                                                        style: AppFonts.headerStyle(
                                                                            fontSize:
                                                                                ResponsiveFlutter.of(context).fontSize(1.8),
                                                                            color: customcolor.tabblue,
                                                                            fontWeight: FontWeight.normal),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  width: SizeConfig
                                                                          .blockSizeHorizontal *
                                                                      5,
                                                                  child:
                                                                      VerticalDivider(
                                                                    color: customcolor
                                                                        .greyborder,
                                                                    thickness:
                                                                        1,
                                                                  ),
                                                                ),
                                                                Container(
                                                                  width: SizeConfig
                                                                          .blockSizeHorizontal *
                                                                      40,
                                                                  child:
                                                                      GestureDetector(
                                                                    onTap: () {
                                                                      getoperationdependentApi(_elements[
                                                                              element]
                                                                          .id
                                                                          .toString());
                                                                    },
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        'Mark as Dependent',
                                                                        style: AppFonts.headerStyle(
                                                                            fontSize:
                                                                                ResponsiveFlutter.of(context).fontSize(1.8),
                                                                            color: customcolor.tabblue,
                                                                            fontWeight: FontWeight.normal),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        : Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: [
                                                              (_elements[element].status == "Escalated" ||
                                                                      _elements[element]
                                                                              .status ==
                                                                          "In-Progress" ||
                                                                      _elements[element]
                                                                              .status ==
                                                                          "In Progress" ||
                                                                      _elements[element]
                                                                              .status ==
                                                                          "Critical")
                                                                  ? GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        addtimer(
                                                                            context,
                                                                            "edit",
                                                                            _elements[element].id.toString());
                                                                      },
                                                                      child:
                                                                          Text(
                                                                        'Edit Turn Around Time',
                                                                        style: AppFonts.headerStyle(
                                                                            fontSize:
                                                                                ResponsiveFlutter.of(context).fontSize(1.8),
                                                                            color: customcolor.tabblue,
                                                                            fontWeight: FontWeight.normal),
                                                                      ),
                                                                    )
                                                                  : Container(),
                                                              _elements[element]
                                                                              .TAT_remark !=
                                                                          null &&
                                                                      (_elements[element].status == "Escalated" ||
                                                                          _elements[element].status ==
                                                                              "In-Progress" ||
                                                                          _elements[element].status ==
                                                                              "In Progress" ||
                                                                          _elements[element].status ==
                                                                              "Critical")
                                                                  ? Container(
                                                                      height:
                                                                          18,
                                                                      width: 1,
                                                                      color: customcolor
                                                                          .greyborder,
                                                                    )
                                                                  : SizedBox(),
                                                              _elements[element]
                                                                          .TAT_remark ==
                                                                      null||_elements[element].TAT_remark.isEmpty
                                                                  ? SizedBox()
                                                                  : GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        showRemarkDialog(
                                                                            context,
                                                                            _elements[element].TAT_remark);
                                                                      },
                                                                      child:
                                                                          Text(
                                                                        'View Remark',
                                                                        style: AppFonts
                                                                            .headerStyle(
                                                                          fontSize:
                                                                              ResponsiveFlutter.of(context).fontSize(1.8),
                                                                          color:
                                                                              customcolor.tabblue,
                                                                          fontWeight:
                                                                              FontWeight.normal,
                                                                        ),
                                                                      ),
                                                                    ),
                                                            ],
                                                          )),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  bottom: BorderSide(
                                                      color:
                                                          customcolor.greybg),
                                                ),
                                              ),
                                            ),
                                            _elements[element].status ==
                                                    "Not Acknowleged"
                                                ? Container()
                                                : Container(
                                                    decoration: BoxDecoration(
                                                      color: customcolor.green,
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        bottomLeft:
                                                            Radius.circular(15),
                                                        bottomRight:
                                                            Radius.circular(15),
                                                      ),
                                                    ),
                                                    // height: 40,
                                                    child: SwipeActionCell(
                                                      fullSwipeFactor: 0.1,
                                                      // firstActionWillCoverAllSpaceOnDeleting: false,
                                                      // backgroundColor:customcolor.green,
                                                      //  icon: Icon(Icons.check, color: Colors.green),
                                                      selectedForegroundColor:
                                                          customcolor.green,
                                                      backgroundColor:
                                                          customcolor.greybg,
                                                      key: ObjectKey(0),
                                                      leadingActions: [
                                                        SwipeAction(
                                                          icon: Icon(
                                                            Icons.check,
                                                            color: customcolor
                                                                .green,
                                                          ),
                                                          performsFirstActionWithFullSwipe:
                                                              true,
                                                          onTap:
                                                              (CompletionHandler
                                                                  handler) async {
                                                            // Handle swipe action
                                                            setState(() {
                                                              print("Resolvef");
                                                              getoperationalresolvedApi(
                                                                  _elements[
                                                                          element]
                                                                      .id
                                                                      .toString());
//.then((value) {
//                         if(value!=null)
//                         {
                                                              handler(true);
//        ShowDialogs().confirmationdone(context,"Complaint Resolved \nSuccessfully");

//     Timer(
//             Duration(seconds: 1),
//                 () =>  Navigator.pop(context));
//                         }
//                       });
                                                            });
                                                          },
                                                          color:
                                                              customcolor.green,
                                                        ),
                                                      ],
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    15),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    15),
                                                          ),
                                                        ),
                                                        height: 40,
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              width: SizeConfig
                                                                      .safeBlockHorizontal *
                                                                  15,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color:
                                                                    customcolor
                                                                        .green,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .only(
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          10),
                                                                ),
                                                              ),
                                                              height: 40,
                                                              child: Icon(
                                                                Icons
                                                                    .arrow_forward,
                                                                color:
                                                                    customcolor
                                                                        .white,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: SizeConfig
                                                                      .blockSizeHorizontal *
                                                                  5,
                                                            ),
                                                            Center(
                                                              child: Text(
                                                                'Swipe if complaint is resolved >>',
                                                                style: AppFonts.headerStyle(
                                                                    fontSize: ResponsiveFlutter.of(
                                                                            context)
                                                                        .fontSize(
                                                                            2),
                                                                    color: customcolor
                                                                        .greytext,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                          ],
                                        )
                                      :
                                      //22feb
                                      //dependent
                                      tab == "2"
                                          ? Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                _elements[element].status ==
                                                        "Not Acknowleged"
                                                    ? Container()
                                                    : Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              customcolor.green,
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    15),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    15),
                                                          ),
                                                        ),
                                                        // height: 40,
                                                        child: SwipeActionCell(
                                                          fullSwipeFactor: 0.1,
                                                          // firstActionWillCoverAllSpaceOnDeleting: false,
                                                          // backgroundColor:customcolor.green,
                                                          //  icon: Icon(Icons.check, color: Colors.green),
                                                          selectedForegroundColor:
                                                              customcolor.green,
                                                          backgroundColor:
                                                              customcolor
                                                                  .greybg,
                                                          key: ObjectKey(0),
                                                          leadingActions: [
                                                            SwipeAction(
                                                              icon: Icon(
                                                                Icons.check,
                                                                color:
                                                                    customcolor
                                                                        .green,
                                                              ),
                                                              performsFirstActionWithFullSwipe:
                                                                  true,
                                                              onTap: (CompletionHandler
                                                                  handler) async {
                                                                // Handle swipe action
                                                                setState(() {
                                                                  print(
                                                                      "Resolvef");
                                                                  getoperationalresolvedApi(
                                                                      _elements[
                                                                              element]
                                                                          .id
                                                                          .toString());
//.then((value) {
//                         if(value!=null)
//                         {
                                                                  handler(true);
//        ShowDialogs().confirmationdone(context,"Complaint Resolved \nSuccessfully");

//     Timer(
//             Duration(seconds: 1),
//                 () =>  Navigator.pop(context));
//                         }
//                       });
                                                                });
                                                              },
                                                              color: customcolor
                                                                  .green,
                                                            ),
                                                          ],
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .only(
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        15),
                                                                bottomRight:
                                                                    Radius
                                                                        .circular(
                                                                            15),
                                                              ),
                                                            ),
                                                            height: 40,
                                                            child: Row(
                                                              children: [
                                                                Container(
                                                                  width: SizeConfig
                                                                          .safeBlockHorizontal *
                                                                      15,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: customcolor
                                                                        .green,
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .only(
                                                                      bottomLeft:
                                                                          Radius.circular(
                                                                              10),
                                                                    ),
                                                                  ),
                                                                  height: 40,
                                                                  child: Icon(
                                                                    Icons
                                                                        .arrow_forward,
                                                                    color: customcolor
                                                                        .white,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: SizeConfig
                                                                          .blockSizeHorizontal *
                                                                      5,
                                                                ),
                                                                Center(
                                                                  child: Text(
                                                                    'Swipe if complaint is resolved >>',
                                                                    style: AppFonts.headerStyle(
                                                                        fontSize:
                                                                            ResponsiveFlutter.of(context).fontSize(
                                                                                2),
                                                                        color: customcolor
                                                                            .greytext,
                                                                        fontWeight:
                                                                            FontWeight.normal),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                              ],
                                            )
                                          : Container()
                                  : SizedBox(
                                      height: 0,
                                    )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          )
        : norecordwidget();
  }

  complaintdetailtab3(
      List<supercomp.DependentdatumElement> _elements, String tab) {
        print("Unit complaintdetailtab3");
        print("GlobalLists.resolvedlist");
        print(GlobalLists.resolvedlist);
    issuperExpandedListresolved =
        List<bool>.generate(_elements.length, (index) => false);
    
    print("initialindexmatch");

    _supervisortab3controller = ItemScrollController();
    return _elements.length > 0
        ? Padding(
            padding: const EdgeInsets.only(bottom: 200),
            child: ScrollablePositionedList.builder(
              scrollDirection: Axis.vertical,
              //  key: _listKey,
              itemScrollController: _supervisortab3controller,
              
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemCount: _elements.length,
              itemBuilder: (c, element) {
                return Stack(
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Card(
                        // elevation: 8.0,
                        margin: new EdgeInsets.symmetric(
                            horizontal: 2.0, vertical: 6.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: GestureDetector(
                          onTap: () {},
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5, right: 5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  if (_elements[element]
                                                              .image1 !=
                                                          "" ||
                                                      _elements[element]
                                                              .image1 !=
                                                          null) {
                                                            print("UNIT RUCHITA SHOW IMAAGE");
                                                            print(_elements[element]
                                                            .close_img1);
                                                    showimage(
                                                        context,
                                                        "Complaint Images",
                                                        _elements[element]
                                                            .image1,
                                                        _elements[element]
                                                            .image2, _elements[element]
                                                            .close_img1,_elements[element]
                                                            .close_img2);
                                                  }
                                                },
                                                child: Image.network(
                                                  "${_elements[element].image1}",
                                                  width: SizeConfig
                                                          .blockSizeHorizontal *
                                                      10,
                                                  fit: BoxFit.cover,
                                                  loadingBuilder:
                                                      (BuildContext context,
                                                          Widget child,
                                                          ImageChunkEvent?
                                                              loadingProgress) {
                                                    if (loadingProgress ==
                                                        null) {
                                                      // ✅ Image loaded successfully
                                                      return child;
                                                    } else {
                                                      // ⏳ Show loader while image is loading
                                                      return SizedBox(
                                                        width: SizeConfig
                                                                .blockSizeHorizontal *
                                                            10,
                                                        height: SizeConfig
                                                                .safeBlockVertical *
                                                            5,
                                                        child: Center(
                                                          child:
                                                              CircularProgressIndicator(
                                                            color: customcolor
                                                                .blue,
                                                            strokeWidth: 2.0,
                                                            valueColor:
                                                                AlwaysStoppedAnimation<
                                                                        Color>(
                                                                    Colors
                                                                        .blueAccent),
                                                            value: loadingProgress
                                                                        .expectedTotalBytes !=
                                                                    null
                                                                ? loadingProgress
                                                                        .cumulativeBytesLoaded /
                                                                    (loadingProgress
                                                                            .expectedTotalBytes ??
                                                                        1)
                                                                : null,
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                  },
                                                  errorBuilder: (BuildContext
                                                          context,
                                                      Object exception,
                                                      StackTrace? stackTrace) {
                                                    return Icon(
                                                      Icons.error_outline,
                                                      size: SizeConfig
                                                              .blockSizeHorizontal *
                                                          10,
                                                    );
                                                  },
                                                  // width: SizeConfig
                                                  //         .blockSizeHorizontal *
                                                  //     10,
                                                  // height: SizeConfig
                                                  //         .safeBlockVertical *
                                                  //     5,
                                                  // errorBuilder: (BuildContext
                                                  //         context,
                                                  //     Object exception,
                                                  //     StackTrace? stackTrace) {
                                                  //   return Icon(
                                                  //     Icons.error_outline,
                                                  //     size: SizeConfig
                                                  //             .blockSizeHorizontal *
                                                  //         10,
                                                  //   );
                                                  // },
                                                ),
                                              ),
                                              // Image.asset( 'assets/images/image1.png',width: SizeConfig.blockSizeHorizontal*10,),
                                              SizedBox(
                                                width: SizeConfig
                                                        .blockSizeHorizontal *
                                                    2,
                                              ),
                                              Container(
                                                width: SizeConfig
                                                        .blockSizeHorizontal *
                                                    38,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "${_elements[element].complainantName}",
                                                      style: AppFonts.headerStyle(
                                                          fontSize:
                                                              ResponsiveFlutter
                                                                      .of(
                                                                          context)
                                                                  .fontSize(2),
                                                          color:
                                                              customcolor.black,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    _elements[element]
                                                                .complainantName ==
                                                            "Cleaning"
                                                        ? Text(
                                                            "${_elements[element].masterAreaName}-${_elements[element].masterBlockName}",
                                                            style: AppFonts.headerStyle(
                                                                fontSize: ResponsiveFlutter.of(
                                                                        context)
                                                                    .fontSize(
                                                                        1.4),
                                                                color:
                                                                    customcolor
                                                                        .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          )
                                                        : Container(),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Flexible(
                                              child:
                                                  //18april
                                                  //  _elements[element].status=="Critical"?Container():
                                                  ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                              backgroundColor: tab == "3"
                                                  ? customcolor.green
                                                  : tab == "2"
                                                      ? customcolor.tabblue
                                                      : _elements[element]
                                                                  .status ==
                                                              "Not Acknowleged"
                                                          ? customcolor.yellow
                                                          : (_elements[element]
                                                                          .status ==
                                                                      "In-Progress" ||
                                                                  _elements[element]
                                                                          .status ==
                                                                      "In Progress")
                                                              ? customcolor
                                                                  .darkorange
                                                              : customcolor.red,
                                              minimumSize: Size(
                                                  SizeConfig
                                                          .blockSizeHorizontal *
                                                      34,
                                                  SizeConfig.blockSizeVertical *
                                                      3),
                                              textStyle: AppFonts.headerStyle(
                                                  fontSize: 15,
                                                  color: customcolor.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            onPressed: () {},
                                            child: Text(
                                              tab == "3"
                                                  ? "Resolved"
                                                  : tab == "2"
                                                      ? "Dependent"
                                                      : _elements[element]
                                                          .status,
                                              //=="Pending"?"Not Acknowledge":"Escalted",
                                              style: AppFonts.headerStyle(
                                                  fontSize: 12,
                                                  color: customcolor.white,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          )),
                                          //
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 1,
                                    ),
                                    Container(
                                      width:
                                          SizeConfig.blockSizeHorizontal * 100,
                                      child: Card(
                                          color: customcolor.skybluebg,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                LayoutBuilder(
                                                  builder:
                                                      (context, constraints) {
                                                    final textPainter =
                                                        TextPainter(
                                                      text: TextSpan(
                                                        text: _elements[element]
                                                            .comment,
                                                        style: TextStyle(
                                                            fontSize: 16),
                                                      ),
                                                      textDirection:
                                                          ui.TextDirection.ltr,
                                                    );

                                                    textPainter.layout(
                                                      minWidth: 0,
                                                      maxWidth:
                                                          constraints.maxWidth,
                                                    );

                                                    final numberOfLines =
                                                        textPainter
                                                            .computeLineMetrics()
                                                            .length;

                                                    return Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              'Complaint : ',
                                                              style: AppFonts.headerStyle(
                                                                  fontSize: ResponsiveFlutter.of(
                                                                          context)
                                                                      .fontSize(
                                                                          1.4),
                                                                  color:
                                                                      customcolor
                                                                          .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                            ),
                                                            Text(
                                                              "${_elements[element].comment}",
                                                              style: AppFonts.headerStyle(
                                                                  fontSize: ResponsiveFlutter.of(
                                                                          context)
                                                                      .fontSize(
                                                                          1.4),
                                                                  color:
                                                                      customcolor
                                                                          .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              maxLines:
                                                                  issuperExpandedListresolved[
                                                                          element]
                                                                      ? null
                                                                      : 3,
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 2),
                                                        // Text(numberOfLines.toString()),
                                                        if (numberOfLines > 5)
                                                          GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                issuperExpandedListresolved[
                                                                        element] =
                                                                    true;
                                                                print(issuperExpandedListresolved[
                                                                    element]);
                                                                ShowDialogs.showSMDialog(
                                                                    context,
                                                                    _elements[
                                                                            element]
                                                                        .complainantName,
                                                                    _elements[
                                                                            element]
                                                                        .comment);
                                                              });
                                                            },
                                                            child: Text(
                                                              issuperExpandedListresolved[
                                                                      element]
                                                                  ? ''
                                                                  : 'View More',
                                                              //   numberOfLines.toString(),
                                                              style: AppFonts.headerStyle(
                                                                  fontSize: ResponsiveFlutter.of(
                                                                          context)
                                                                      .fontSize(
                                                                          1.4),
                                                                  color:
                                                                      customcolor
                                                                          .blue,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                            ),
                                                          ),
                                                      ],
                                                    );
                                                  },
                                                ),
                                                //           Text("${_elements[element].comment}",
                                                //           style:
                                                //            AppFonts.headerStyle(fontSize:ResponsiveFlutter.of(context).fontSize(1.4),
                                                // color: customcolor.black,fontWeight: FontWeight.w400  ),

                                                //   overflow: TextOverflow.ellipsis,
                                                //   maxLines: 3,),
                                                // SizedBox(height: 5,),
                                              ],
                                            ),
                                          )),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5, right: 5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          RichText(
                                            textAlign: TextAlign.justify,
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: "Logged at-",
                                                  style: AppFonts.headerStyle(
                                                      fontSize: 12,
                                                      color: customcolor.black,
                                                      fontWeight:
                                                          FontWeight.normal),
                                                ),
                                                TextSpan(
                                                  text:
                                                      "${_elements[element].loggedAt}",
                                                  style: AppFonts.headerStyle(
                                                      fontSize: 12,
                                                      color:
                                                          customcolor.tabblue,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                          ),
                                          tab == "2"
                                              ? Container()
                                              : _elements[element]
                                                          .turnAroundTime ==
                                                      ""
                                                  ? Container()
                                                  : Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 5,
                                                              right: 3),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          RichText(
                                                            textAlign: TextAlign
                                                                .justify,
                                                            text: TextSpan(
                                                              children: [
                                                                TextSpan(
                                                                  text:
                                                                      "TAT - ",
                                                                  style: AppFonts.headerStyle(
                                                                      fontSize:
                                                                          12,
                                                                      color: customcolor
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal),
                                                                ),
                                                                TextSpan(
                                                                  text:
                                                                      "${_elements[element].turnAroundTime}",
                                                                  style: AppFonts.headerStyle(
                                                                      fontSize: 12,
                                                                      color: tab == "3"
                                                                          ? customcolor.green
                                                                          : (_elements[element].status == "In-Progress" || _elements[element].status == "In Progress")
                                                                              ? customcolor.darkorange
                                                                              : (_elements[element].status == "Critical")
                                                                                  ? customcolor.red
                                                                                  : customcolor.blue,
                                                                      fontWeight: FontWeight.w500),
                                                                ),
                                                                TextSpan(
                                                                  text:
                                                                      " (${_elements[element].tatDate.toString()})",
                                                                  style: AppFonts.headerStyle(
                                                                      fontSize: 12,
                                                                      color: tab == "3"
                                                                          ? customcolor.green
                                                                          : (_elements[element].status == "In-Progress" || _elements[element].status == "In Progress")
                                                                              ? customcolor.darkorange
                                                                              : (_elements[element].status == "Critical")
                                                                                  ? customcolor.red
                                                                                  : customcolor.blue,
                                                                      fontWeight: FontWeight.w500),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                        ],
                                      ),
                                    ),

//
                                  ],
                                ),
                              ),
                              (role == GlobalLists.headrole ||
                                      role == GlobalLists.reginalmanagerrole ||
                                      role == GlobalLists.operationrole ||
                                      role == GlobalLists.supervisorrole ||
                                      role == GlobalLists.operationmanagerrole)
                                  ? tab == "1"
                                      ? Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Divider(),
                                            GestureDetector(
                                              onTap: () {},
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 4, bottom: 4),
                                                child: Center(
                                                  child:
                                                      _elements[element]
                                                                  .status ==
                                                              "Not Acknowleged"
                                                          ? IntrinsicHeight(
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Container(
                                                                    width: SizeConfig
                                                                            .blockSizeHorizontal *
                                                                        40,
                                                                    child:
                                                                        GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        addtimer(
                                                                            context,
                                                                            "add",
                                                                            _elements[element].id.toString());
                                                                      },
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Text(
                                                                          'Add Turn Around Time',
                                                                          style: AppFonts.headerStyle(
                                                                              fontSize: ResponsiveFlutter.of(context).fontSize(1.8),
                                                                              color: customcolor.tabblue,
                                                                              fontWeight: FontWeight.normal),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    width: SizeConfig
                                                                            .blockSizeHorizontal *
                                                                        5,
                                                                    child:
                                                                        VerticalDivider(
                                                                      color: customcolor
                                                                          .greyborder,
                                                                      thickness:
                                                                          1,
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    width: SizeConfig
                                                                            .blockSizeHorizontal *
                                                                        40,
                                                                    child:
                                                                        GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        getoperationdependentApi(_elements[element]
                                                                            .id
                                                                            .toString());
                                                                      },
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Text(
                                                                          'Mark as Dependent',
                                                                          style: AppFonts.headerStyle(
                                                                              fontSize: ResponsiveFlutter.of(context).fontSize(1.8),
                                                                              color: customcolor.tabblue,
                                                                              fontWeight: FontWeight.normal),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                          : Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceEvenly,
                                                              children: [
                                                                (_elements[element].status == "Escalated" ||
                                                                        _elements[element].status ==
                                                                            "In-Progress" ||
                                                                        _elements[element].status ==
                                                                            "In Progress" ||
                                                                        _elements[element].status ==
                                                                            "Critical")
                                                                    ? GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          addtimer(
                                                                              context,
                                                                              "edit",
                                                                              _elements[element].id.toString());
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          'Edit Turn Around Time',
                                                                          style: AppFonts.headerStyle(
                                                                              fontSize: ResponsiveFlutter.of(context).fontSize(1.8),
                                                                              color: customcolor.tabblue,
                                                                              fontWeight: FontWeight.normal),
                                                                        ),
                                                                      )
                                                                    : Container(),
                                                                _elements[element].TAT_remark !=
                                                                            null &&
                                                                        (_elements[element].status == "Escalated" ||
                                                                            _elements[element].status ==
                                                                                "In-Progress" ||
                                                                            _elements[element].status ==
                                                                                "In Progress" ||
                                                                            _elements[element].status ==
                                                                                "Critical")
                                                                    ? Container(
                                                                        height:
                                                                            18,
                                                                        width:
                                                                            1,
                                                                        color: customcolor
                                                                            .greyborder,
                                                                      )
                                                                    : SizedBox(),
                                                                _elements[element]
                                                                            .TAT_remark ==
                                                                        null||_elements[element].TAT_remark.isEmpty
                                                                    ? SizedBox()
                                                                    : GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          showRemarkDialog(
                                                                              context,
                                                                              _elements[element].TAT_remark);
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          'View Remark',
                                                                          style:
                                                                              AppFonts.headerStyle(
                                                                            fontSize:
                                                                                ResponsiveFlutter.of(context).fontSize(1.8),
                                                                            color:
                                                                                customcolor.tabblue,
                                                                            fontWeight:
                                                                                FontWeight.normal,
                                                                          ),
                                                                        ),
                                                                      ),
                                                              ],
                                                            ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  bottom: BorderSide(
                                                      color:
                                                          customcolor.greybg),
                                                ),
                                              ),
                                            ),
                                            _elements[element].status ==
                                                    "Not Acknowleged"
                                                ? Container()
                                                : Container(
                                                    decoration: BoxDecoration(
                                                      color: customcolor.green,
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        bottomLeft:
                                                            Radius.circular(15),
                                                        bottomRight:
                                                            Radius.circular(15),
                                                      ),
                                                    ),
                                                    // height: 40,
                                                    child: SwipeActionCell(
                                                      fullSwipeFactor: 0.1,
                                                      // firstActionWillCoverAllSpaceOnDeleting: false,
                                                      // backgroundColor:customcolor.green,
                                                      //  icon: Icon(Icons.check, color: Colors.green),
                                                      selectedForegroundColor:
                                                          customcolor.green,
                                                      backgroundColor:
                                                          customcolor.greybg,
                                                      key: ObjectKey(0),
                                                      leadingActions: [
                                                        SwipeAction(
                                                          icon: Icon(
                                                            Icons.check,
                                                            color: customcolor
                                                                .green,
                                                          ),
                                                          performsFirstActionWithFullSwipe:
                                                              true,
                                                          onTap:
                                                              (CompletionHandler
                                                                  handler) async {
                                                            // Handle swipe action
                                                            setState(() {
                                                              print("Resolvef");
                                                              getoperationalresolvedApi(
                                                                  _elements[
                                                                          element]
                                                                      .id
                                                                      .toString());
//.then((value) {
//                         if(value!=null)
//                         {
                                                              handler(true);
//        ShowDialogs().confirmationdone(context,"Complaint Resolved \nSuccessfully");

//     Timer(
//             Duration(seconds: 1),
//                 () =>  Navigator.pop(context));
//                         }
//                       });
                                                            });
                                                          },
                                                          color:
                                                              customcolor.green,
                                                        ),
                                                      ],
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    15),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    15),
                                                          ),
                                                        ),
                                                        height: 40,
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              width: SizeConfig
                                                                      .safeBlockHorizontal *
                                                                  15,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color:
                                                                    customcolor
                                                                        .green,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .only(
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          10),
                                                                ),
                                                              ),
                                                              height: 40,
                                                              child: Icon(
                                                                Icons
                                                                    .arrow_forward,
                                                                color:
                                                                    customcolor
                                                                        .white,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: SizeConfig
                                                                      .blockSizeHorizontal *
                                                                  5,
                                                            ),
                                                            Center(
                                                              child: Text(
                                                                'Swipe if complaint is resolved >>',
                                                                style: AppFonts.headerStyle(
                                                                    fontSize: ResponsiveFlutter.of(
                                                                            context)
                                                                        .fontSize(
                                                                            2),
                                                                    color: customcolor
                                                                        .greytext,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                          ],
                                        )
                                      :
                                      //22feb
                                      //dependent
                                      tab == "2"
                                          ? Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                _elements[element].status ==
                                                        "Not Acknowleged"
                                                    ? Container()
                                                    : Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              customcolor.green,
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    15),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    15),
                                                          ),
                                                        ),
                                                        // height: 40,
                                                        child: SwipeActionCell(
                                                          fullSwipeFactor: 0.1,
                                                          // firstActionWillCoverAllSpaceOnDeleting: false,
                                                          // backgroundColor:customcolor.green,
                                                          //  icon: Icon(Icons.check, color: Colors.green),
                                                          selectedForegroundColor:
                                                              customcolor.green,
                                                          backgroundColor:
                                                              customcolor
                                                                  .greybg,
                                                          key: ObjectKey(0),
                                                          leadingActions: [
                                                            SwipeAction(
                                                              icon: Icon(
                                                                Icons.check,
                                                                color:
                                                                    customcolor
                                                                        .green,
                                                              ),
                                                              performsFirstActionWithFullSwipe:
                                                                  true,
                                                              onTap: (CompletionHandler
                                                                  handler) async {
                                                                // Handle swipe action
                                                                setState(() {
                                                                  print(
                                                                      "Resolvef");
                                                                  getoperationalresolvedApi(
                                                                      _elements[
                                                                              element]
                                                                          .id
                                                                          .toString());
//.then((value) {
//                         if(value!=null)
//                         {
                                                                  handler(true);
//        ShowDialogs().confirmationdone(context,"Complaint Resolved \nSuccessfully");

//     Timer(
//             Duration(seconds: 1),
//                 () =>  Navigator.pop(context));
//                         }
//                       });
                                                                });
                                                              },
                                                              color: customcolor
                                                                  .green,
                                                            ),
                                                          ],
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .only(
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        15),
                                                                bottomRight:
                                                                    Radius
                                                                        .circular(
                                                                            15),
                                                              ),
                                                            ),
                                                            height: 40,
                                                            child: Row(
                                                              children: [
                                                                Container(
                                                                  width: SizeConfig
                                                                          .safeBlockHorizontal *
                                                                      15,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: customcolor
                                                                        .green,
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .only(
                                                                      bottomLeft:
                                                                          Radius.circular(
                                                                              10),
                                                                    ),
                                                                  ),
                                                                  height: 40,
                                                                  child: Icon(
                                                                    Icons
                                                                        .arrow_forward,
                                                                    color: customcolor
                                                                        .white,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: SizeConfig
                                                                          .blockSizeHorizontal *
                                                                      5,
                                                                ),
                                                                Center(
                                                                  child: Text(
                                                                    'Swipe if complaint is resolved >>',
                                                                    style: AppFonts.headerStyle(
                                                                        fontSize:
                                                                            ResponsiveFlutter.of(context).fontSize(
                                                                                2),
                                                                        color: customcolor
                                                                            .greytext,
                                                                        fontWeight:
                                                                            FontWeight.normal),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                              ],
                                            )
                                          : Container()
                                  : SizedBox(
                                      height: 0,
                                    )
                            ],
                          ),
                        ),
                      ),
                    ),
//   
                  ],
                );
              },
            ),
          )
        : norecordwidget();
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


  unitcomplaintdetail(
    
      List<unitcom.DependentdatumElement> _elements, String tab) {
          print("UNIT Complaint TAB");
    // First, sort the elements by loggedAt (oldest first)
    _elements.sort((a, b) => a.loggedAt.compareTo(b.loggedAt));

    // Group elements by date
    Map<String, List<unitcom.DependentdatumElement>> groupedElements = {};
    for (var element in _elements) {
      // Extract the date part from between parentheses
      String dateKey =
          element.loggedAt.split('(')[1].replaceAll(')', '').trim();
      if (!groupedElements.containsKey(dateKey)) {
        groupedElements[dateKey] = [];
      }
      groupedElements[dateKey]!.add(element);
    }

    // Sort dates in ascending order (oldest first)
    List<String> sortedDates = groupedElements.keys.toList()
      ..sort((a, b) {
        DateFormat format = DateFormat('dd MMM yyyy');
        DateTime dateA = format.parse(a);
        DateTime dateB = format.parse(b);
        return dateA.compareTo(dateB);
      });

    isExpandedList = List<bool>.generate(_elements.length, (index) => false);
    return _elements.length > 0
        ? Padding(
            padding: const EdgeInsets.only(bottom: 200),
            child: ScrollablePositionedList.builder(
              scrollDirection: Axis.vertical,
              itemScrollController: _clientcontroller,
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemCount: sortedDates.length,
              itemBuilder: (c, dateIndex) {
                String date = sortedDates[dateIndex];
                List<unitcom.DependentdatumElement> dateElements =
                    groupedElements[date]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date header
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          date,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ),
                    // List of complaints for this date
                    ...dateElements.map((element) {
                      int globalIndex = _elements.indexOf(element);
                      return Stack(
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: Card(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 2.0, vertical: 6.0),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  if (element.image1 != "" ||
                                                      element.image1 != null) {
                                                    showimage(
                                                        context,
                                                        "Complaint Images",
                                                        element.image1,
                                                        element.image2,element.closeImg1,element.closeImg2);
                                                  }
                                                },
                                                child: Image.network(
                                                  "${element.image1}",
                                                  // width: SizeConfig
                                                  //         .blockSizeHorizontal *
                                                  //     10,
                                                  // errorBuilder: (BuildContext
                                                  //         context,
                                                  //     Object exception,
                                                  //     StackTrace? stackTrace) {
                                                  //   return Icon(
                                                  //     Icons.error_outline,
                                                  //     size: SizeConfig
                                                  //             .blockSizeHorizontal *
                                                  //         10,
                                                  //   );

                                                  //},
                                                  width: SizeConfig
                                                          .blockSizeHorizontal *
                                                      10,
                                                  fit: BoxFit.cover,
                                                  loadingBuilder:
                                                      (BuildContext context,
                                                          Widget child,
                                                          ImageChunkEvent?
                                                              loadingProgress) {
                                                    if (loadingProgress ==
                                                        null) {
                                                      // ✅ Image loaded successfully
                                                      return child;
                                                    } else {
                                                      // ⏳ Show loader while image is loading
                                                      return SizedBox(
                                                        width: SizeConfig
                                                                .blockSizeHorizontal *
                                                            10,
                                                        height: SizeConfig
                                                                .safeBlockVertical *
                                                            5,
                                                        child: Center(
                                                          child:
                                                              CircularProgressIndicator(
                                                            color: customcolor
                                                                .blue,
                                                            strokeWidth: 2.0,
                                                            valueColor:
                                                                AlwaysStoppedAnimation<
                                                                        Color>(
                                                                    Colors
                                                                        .blueAccent),
                                                            value: loadingProgress
                                                                        .expectedTotalBytes !=
                                                                    null
                                                                ? loadingProgress
                                                                        .cumulativeBytesLoaded /
                                                                    (loadingProgress
                                                                            .expectedTotalBytes ??
                                                                        1)
                                                                : null,
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                  },
                                                  errorBuilder: (BuildContext
                                                          context,
                                                      Object exception,
                                                      StackTrace? stackTrace) {
                                                    return Icon(
                                                      Icons.error_outline,
                                                      size: SizeConfig
                                                              .blockSizeHorizontal *
                                                          10,
                                                    );
                                                  },
                                                ),
                                              ),
                                              SizedBox(
                                                width: SizeConfig
                                                        .blockSizeHorizontal *
                                                    2,
                                              ),
                                              Container(
                                                width: SizeConfig
                                                        .blockSizeHorizontal *
                                                    38,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "${element.complainantName}",
                                                      style: AppFonts.headerStyle(
                                                          fontSize:
                                                              ResponsiveFlutter
                                                                      .of(
                                                                          context)
                                                                  .fontSize(2),
                                                          color:
                                                              customcolor.black,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    element.complainantName ==
                                                            "Cleaning"
                                                        ? Container(
                                                            width: SizeConfig
                                                                    .blockSizeHorizontal *
                                                                40,
                                                            child: Text(
                                                              "${element.masterAreaName}-${element.masterBlockName}",
                                                              style: AppFonts.headerStyle(
                                                                  fontSize: ResponsiveFlutter.of(
                                                                          context)
                                                                      .fontSize(
                                                                          1.4),
                                                                  color:
                                                                      customcolor
                                                                          .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                            ),
                                                          )
                                                        : Container(),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Flexible(
                                              child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                              backgroundColor: tab == "3"
                                                  ? customcolor.green
                                                  : tab == "2"
                                                      ? customcolor.tabblue
                                                      : element.status ==
                                                              "Not Acknowleged"
                                                          ? customcolor.yellow
                                                          : (element.status ==
                                                                      "In-Progress" ||
                                                                  element.status ==
                                                                      "In Progress")
                                                              ? customcolor
                                                                  .darkorange
                                                              : customcolor.red,
                                              minimumSize: Size(
                                                  SizeConfig
                                                          .blockSizeHorizontal *
                                                      34,
                                                  SizeConfig.blockSizeVertical *
                                                      3),
                                              textStyle: AppFonts.headerStyle(
                                                  fontSize: 15,
                                                  color: customcolor.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            onPressed: () {},
                                            child: Text(
                                              tab == "3"
                                                  ? "Resolved"
                                                  : tab == "2"
                                                      ? "Dependent"
                                                      : element.status,
                                              style: AppFonts.headerStyle(
                                                  fontSize: 12,
                                                  color: customcolor.white,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          )),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          element.status != "Not Acknowleged"
                                              ? GestureDetector(
                                                  onTap: () {
                                                    print(
                                                        'Logged in id: ${element.id}');
                                                    final tatList =
                                                        element.tatLoggedData;

                                                    showModalBottomSheet(
                                                      context: context,
                                                      isScrollControlled: true,
                                                      isDismissible: true,
                                                      enableDrag: true,
                                                      shape:
                                                          const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.vertical(
                                                                top: Radius
                                                                    .circular(
                                                                        20)),
                                                      ),
                                                      backgroundColor: customcolor
                                                          .greybg, // Set grey background here
                                                      builder: (context) {
                                                        return Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                            bottom:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .viewInsets
                                                                    .bottom,
                                                            top: 20,
                                                            left: 16,
                                                            right: 16,
                                                          ),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Container(
                                                                height: 4,
                                                                width: 40,
                                                                margin:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        bottom:
                                                                            12),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .grey
                                                                      .shade400,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              2),
                                                                ),
                                                              ),
                                                              Text(
                                                                'Complaint Log',
                                                                style: AppFonts
                                                                    .headerStyle(
                                                                  fontSize: 20,
                                                                  color:
                                                                      customcolor
                                                                          .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  height: 16),
                                                              SizedBox(
                                                                height: 300,
                                                                child: ListView
                                                                    .builder(
                                                                  shrinkWrap:
                                                                      true,
                                                                  itemCount:
                                                                      tatList
                                                                          .length,
                                                                  itemBuilder:
                                                                      (context,
                                                                          index) {
                                                                    final item =
                                                                        tatList[
                                                                            index];
                                                                    return Container(
                                                                      margin: const EdgeInsets
                                                                              .symmetric(
                                                                          vertical:
                                                                              8),
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              14),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: Colors
                                                                            .white, // White card
                                                                        borderRadius:
                                                                            BorderRadius.circular(12),
                                                                        boxShadow: [
                                                                          BoxShadow(
                                                                            color:
                                                                                Colors.grey.withOpacity(0.1),
                                                                            spreadRadius:
                                                                                1,
                                                                            blurRadius:
                                                                                4,
                                                                            offset:
                                                                                const Offset(0, 2),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      child:
                                                                          Row(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            "${index + 1}. ",
                                                                            style:
                                                                                AppFonts.headerStyle(
                                                                              fontSize: 16,
                                                                              color: customcolor.black,
                                                                              fontWeight: FontWeight.normal,
                                                                            ),
                                                                          ),
                                                                          Expanded(
                                                                            child:
                                                                                Text(
                                                                              item.tatText.toString(),
                                                                              softWrap: true,
                                                                              style: AppFonts.headerStyle(
                                                                                fontSize: 16,
                                                                                color: customcolor.black,
                                                                                fontWeight: FontWeight.normal,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  height: 12),
                                                              ElevatedButton(
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                        context),
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  backgroundColor:
                                                                      customcolor
                                                                          .blue,
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                  ),
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          32,
                                                                      vertical:
                                                                          12),
                                                                ),
                                                                child:
                                                                    const Text(
                                                                  'Close',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  height: 20),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  },
                                                  child: const Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 6),
                                                    child: Icon(
                                                        Icons.info_outline,
                                                        size: 22,
                                                        color: Colors.grey),
                                                  ),
                                                )
                                              : Container(),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 1,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 3, right: 3),
                                      child: Stack(
                                        children: [
                                          Container(
                                            width:
                                                SizeConfig.blockSizeHorizontal *
                                                    90,
                                            child: Card(
                                                color: customcolor.skybluebg,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(10),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      LayoutBuilder(
                                                        builder: (context,
                                                            constraints) {
                                                          final textPainter =
                                                              TextPainter(
                                                            text: TextSpan(
                                                              text: element
                                                                  .comment,
                                                              style: TextStyle(
                                                                  fontSize: 16),
                                                            ),
                                                            textDirection: ui
                                                                .TextDirection
                                                                .ltr,
                                                          );

                                                          textPainter.layout(
                                                            minWidth: 0,
                                                            maxWidth:
                                                                constraints
                                                                    .maxWidth,
                                                          );

                                                          final numberOfLines =
                                                              textPainter
                                                                  .computeLineMetrics()
                                                                  .length;

                                                          return Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    "Complaint : ",
                                                                    style: AppFonts.headerStyle(
                                                                        fontSize:
                                                                            ResponsiveFlutter.of(context).fontSize(
                                                                                1.4),
                                                                        color: customcolor
                                                                            .black,
                                                                        fontWeight:
                                                                            FontWeight.w400),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    maxLines:
                                                                        isExpandedList[globalIndex]
                                                                            ? null
                                                                            : 3,
                                                                  ),
                                                                  Text(
                                                                    "${element.comment}",
                                                                    style: AppFonts.headerStyle(
                                                                        fontSize:
                                                                            ResponsiveFlutter.of(context).fontSize(
                                                                                1.4),
                                                                        color: customcolor
                                                                            .black,
                                                                        fontWeight:
                                                                            FontWeight.w400),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    maxLines:
                                                                        isExpandedList[globalIndex]
                                                                            ? null
                                                                            : 3,
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                  height: 2),
                                                              if (numberOfLines >
                                                                  5)
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      isExpandedList[
                                                                              globalIndex] =
                                                                          true;
                                                                      print(isExpandedList[
                                                                          globalIndex]);
                                                                      ShowDialogs.showSMDialog(
                                                                          context,
                                                                          element
                                                                              .complainantName,
                                                                          element
                                                                              .comment);
                                                                    });
                                                                  },
                                                                  child: Text(
                                                                    isExpandedList[
                                                                            globalIndex]
                                                                        ? ''
                                                                        : 'View More',
                                                                    style: AppFonts.headerStyle(
                                                                        fontSize:
                                                                            ResponsiveFlutter.of(context).fontSize(
                                                                                1.4),
                                                                        color: customcolor
                                                                            .blue,
                                                                        fontWeight:
                                                                            FontWeight.w400),
                                                                  ),
                                                                ),
                                                            ],
                                                          );
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                )),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 12,
                                          right: 8,
                                          bottom: 8,
                                          top: 8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              RichText(
                                                textAlign: TextAlign.justify,
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: "Logged at-",
                                                      style:
                                                          AppFonts.headerStyle(
                                                              fontSize: 12,
                                                              color: customcolor
                                                                  .black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal),
                                                    ),
                                                    TextSpan(
                                                      text:
                                                          "${element.loggedAt}",
                                                      style:
                                                          AppFonts.headerStyle(
                                                              fontSize: 12,
                                                              color: customcolor
                                                                  .tabblue,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              tab == "2"
                                                  ? Container()
                                                  : element.turnAroundTime == ""
                                                      ? Container()
                                                      : Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 0,
                                                                  right: 3,
                                                                  top: 3),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              RichText(
                                                                textAlign:
                                                                    TextAlign
                                                                        .justify,
                                                                text: TextSpan(
                                                                  children: [
                                                                    TextSpan(
                                                                      text:
                                                                          "TAT - ",
                                                                      style: AppFonts.headerStyle(
                                                                          fontSize:
                                                                              12,
                                                                          color: customcolor
                                                                              .black,
                                                                          fontWeight:
                                                                              FontWeight.normal),
                                                                    ),
                                                                    TextSpan(
                                                                      text:
                                                                          "${element.turnAroundTime}",
                                                                      style: AppFonts.headerStyle(
                                                                          fontSize: 12,
                                                                          color: tab == "3"
                                                                              ? customcolor.green
                                                                              : (element.status == "In-Progress" || element.status == "In Progress")
                                                                                  ? customcolor.darkorange
                                                                                  : (element.status == "Critical")
                                                                                      ? customcolor.red
                                                                                      : customcolor.blue,
                                                                          fontWeight: FontWeight.w500),
                                                                    ),
                                                                    TextSpan(
                                                                      text: element.tatDate ==
                                                                              null
                                                                          ? ""
                                                                          : " (${element.tatDate.toString()})",
                                                                      style: AppFonts.headerStyle(
                                                                          fontSize: 12,
                                                                          color: tab == "3"
                                                                              ? customcolor.green
                                                                              : (element.status == "In-Progress" || element.status == "In Progress")
                                                                                  ? customcolor.darkorange
                                                                                  : (element.status == "Critical")
                                                                                      ? customcolor.red
                                                                                      : customcolor.blue,
                                                                          fontWeight: FontWeight.w500),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                              // clients card

                                              (element.TAT_remark == null||element.TAT_remark=='') &&
                                                      role ==
                                                          GlobalLists.clientrole
                                                  ? const SizedBox()
                                                 : Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Divider(),
                                                        Container(
                                                          width: 330,
                                                          height: 1,
                                                          color: customcolor
                                                              .greyborder,
                                                        ),
                                                        Divider(),
                                                        // llll

                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 0),
                                                          child: Row(
                                                            // mainAxisAlignment:
                                                            //     MainAxisAlignment
                                                            //         .center,
                                                            children: [
                                                              GestureDetector(
                                                                onTap: () {
                                                                  showRemarkDialog(
                                                                      context,
                                                                      element
                                                                          .TAT_remark);
                                                                },
                                                                child: Text(
                                                                  'View Remark',
                                                                  style: AppFonts
                                                                      .headerStyle(
                                                                    fontSize: ResponsiveFlutter.of(
                                                                            context)
                                                                        .fontSize(
                                                                            1.8),
                                                                    color: customcolor
                                                                        .tabblue,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  
                                              ,SizedBox(
                                                height: 10,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    (role == GlobalLists.headrole ||
                                            role ==
                                                GlobalLists
                                                    .reginalmanagerrole ||
                                            role == GlobalLists.operationrole ||
                                            role ==
                                                GlobalLists
                                                    .operationmanagerrole)
                                        ? tab == "1"
                                            ? Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Divider(),
                                                  GestureDetector(
                                                    onTap: () {},
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 4,
                                                              bottom: 4),
                                                      child: Center(
                                                        child: element.status ==
                                                                "Not Acknowleged"
                                                            ? IntrinsicHeight(
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Container(
                                                                      width:
                                                                          SizeConfig.blockSizeHorizontal *
                                                                              40,
                                                                      child:
                                                                          GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          addtimer(
                                                                              context,
                                                                              "add",
                                                                              element.id.toString());
                                                                        },
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Text(
                                                                            'Add Turn Around Time',
                                                                            style: AppFonts.headerStyle(
                                                                                fontSize: ResponsiveFlutter.of(context).fontSize(1.8),
                                                                                color: customcolor.tabblue,
                                                                                fontWeight: FontWeight.normal),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      width:
                                                                          SizeConfig.blockSizeHorizontal *
                                                                              5,
                                                                      child:
                                                                          VerticalDivider(
                                                                        color: customcolor
                                                                            .greyborder,
                                                                        thickness:
                                                                            1,
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      width:
                                                                          SizeConfig.blockSizeHorizontal *
                                                                              40,
                                                                      child:
                                                                          GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          getoperationdependentApi(element
                                                                              .id
                                                                              .toString());
                                                                        },
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Text(
                                                                            'Mark as Dependent',
                                                                            style: AppFonts.headerStyle(
                                                                                fontSize: ResponsiveFlutter.of(context).fontSize(1.8),
                                                                                color: customcolor.tabblue,
                                                                                fontWeight: FontWeight.normal),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                            : Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: [
                                                                  (element.status == "Escalated" ||
                                                                          element.status ==
                                                                              "In-Progress" ||
                                                                          element.status ==
                                                                              "In Progress" ||
                                                                          element.status ==
                                                                              "Critical")
                                                                      ? GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            addtimer(
                                                                                context,
                                                                                "edit",
                                                                                element.id.toString());
                                                                          },
                                                                          child:
                                                                              Text(
                                                                            'Edit Turn Around Time',
                                                                            style: AppFonts.headerStyle(
                                                                                fontSize: ResponsiveFlutter.of(context).fontSize(1.8),
                                                                                color: customcolor.tabblue,
                                                                                fontWeight: FontWeight.normal),
                                                                          ),
                                                                        )
                                                                      : Container(),
                                                                 ( element.TAT_remark !=
                                                                              null||element.TAT_remark.isNotEmpty) &&
                                                                          (element.status == "Escalated" ||
                                                                              element.status == "In-Progress" ||
                                                                              element.status == "In Progress" ||
                                                                              element.status == "Critical")
                                                                      ? Container(
                                                                          height:
                                                                              18,
                                                                          width:
                                                                              1,
                                                                          color:
                                                                              customcolor.greyborder,
                                                                        )
                                                                      : SizedBox(),
                                                                  element.TAT_remark ==
                                                                          null||element.TAT_remark.isEmpty
                                                                      ? SizedBox()
                                                                      : GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            showRemarkDialog(context,
                                                                                element.TAT_remark);
                                                                          },
                                                                          child:
                                                                              Text(
                                                                            'View Remark',
                                                                            style:
                                                                                AppFonts.headerStyle(
                                                                              fontSize: ResponsiveFlutter.of(context).fontSize(1.8),
                                                                              color: customcolor.tabblue,
                                                                              fontWeight: FontWeight.normal,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                ],
                                                              ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      border: Border(
                                                        bottom: BorderSide(
                                                            color: customcolor
                                                                .greybg),
                                                      ),
                                                    ),
                                                  ),
                                                  element.status ==
                                                          "Not Acknowleged"
                                                      ? Container()
                                                      : Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: customcolor
                                                                .green,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              bottomLeft: Radius
                                                                  .circular(15),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          15),
                                                            ),
                                                          ),
                                                          child:
                                                              SwipeActionCell(
                                                            fullSwipeFactor:
                                                                0.1,
                                                            selectedForegroundColor:
                                                                customcolor
                                                                    .green,
                                                            backgroundColor:
                                                                customcolor
                                                                    .greybg,
                                                            key: ObjectKey(0),
                                                            leadingActions: [
                                                              SwipeAction(
                                                                icon: Icon(
                                                                  Icons.check,
                                                                  color:
                                                                      customcolor
                                                                          .green,
                                                                ),
                                                                performsFirstActionWithFullSwipe:
                                                                    true,
                                                                onTap: (CompletionHandler
                                                                    handler) async {
                                                                  setState(() {
                                                                   
                                                                    print(
                                                                        "Resolvef");
                                                                    handler(
                                                                        false); // prevent auto-swipe complete
                                                                    showUploadDialog(
                                                                        context,
                                                                        element
                                                                            .id
                                                                            .toString(),
                                                                        handler);

                                                                    /*getoperationalresolvedApi(element.id.toString());
                                                  handler(true);*/
                                                                  });
                                                                },
                                                                color:
                                                                    customcolor
                                                                        .green,
                                                              ),
                                                            ],
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .only(
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          15),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          15),
                                                                ),
                                                              ),
                                                              //height: 40,
                                                              child: Row(
                                                                children: [
                                                                  Container(
                                                                    width: SizeConfig
                                                                            .safeBlockHorizontal *
                                                                        15,
                                                                    height: 40,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: customcolor
                                                                          .green,
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .only(
                                                                        bottomLeft:
                                                                            Radius.circular(10),
                                                                      ),
                                                                    ),
                                                                    child: Icon(
                                                                      Icons
                                                                          .arrow_forward,
                                                                      color: customcolor
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: SizeConfig
                                                                            .blockSizeHorizontal *
                                                                        5,
                                                                  ),
                                                                  Center(
                                                                    child: Text(
                                                                      'Swipe if complaint is resolved >>',
                                                                      style: AppFonts.headerStyle(
                                                                          fontSize: ResponsiveFlutter.of(context).fontSize(
                                                                              2),
                                                                          color: customcolor
                                                                              .greytext,
                                                                          fontWeight:
                                                                              FontWeight.normal),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                ],
                                              )
                                            : tab == "2"
                                                ? Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border(
                                                            bottom: BorderSide(
                                                                color:
                                                                    customcolor
                                                                        .greybg),
                                                          ),
                                                        ),
                                                      ),
                                                      element.status ==
                                                              "Not Acknowleged"
                                                          ? Container()
                                                          : Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color:
                                                                    customcolor
                                                                        .green,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .only(
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          15),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          15),
                                                                ),
                                                              ),
                                                              child:
                                                                  SwipeActionCell(
                                                                fullSwipeFactor:
                                                                    0.1,
                                                                selectedForegroundColor:
                                                                    customcolor
                                                                        .green,
                                                                backgroundColor:
                                                                    customcolor
                                                                        .greybg,
                                                                key: ObjectKey(
                                                                    0),
                                                                leadingActions: [
                                                                  SwipeAction(
                                                                    icon: Icon(
                                                                      Icons
                                                                          .check,
                                                                      color: customcolor
                                                                          .green,
                                                                    ),
                                                                    performsFirstActionWithFullSwipe:
                                                                        true,
                                                                    onTap: (CompletionHandler
                                                                        handler) async {
                                                                      setState(
                                                                          () {
                                                                        print(
                                                                            "Resolvef");
                                                                        getoperationalresolvedApi(element
                                                                            .id
                                                                            .toString());
                                                                        handler(
                                                                            true);
                                                                      });
                                                                    },
                                                                    color: customcolor
                                                                        .green,
                                                                  ),
                                                                ],
                                                                child:
                                                                    Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .white,
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .only(
                                                                      bottomLeft:
                                                                          Radius.circular(
                                                                              15),
                                                                      bottomRight:
                                                                          Radius.circular(
                                                                              15),
                                                                    ),
                                                                  ),
                                                                  height: 40,
                                                                  child: Row(
                                                                    children: [
                                                                      Container(
                                                                        width: SizeConfig.safeBlockHorizontal *
                                                                            15,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              customcolor.green,
                                                                          borderRadius:
                                                                              BorderRadius.only(
                                                                            bottomLeft:
                                                                                Radius.circular(10),
                                                                          ),
                                                                        ),
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .arrow_forward,
                                                                          color:
                                                                              customcolor.white,
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            SizeConfig.blockSizeHorizontal *
                                                                                5,
                                                                      ),
                                                                      Center(
                                                                        child:
                                                                            Text(
                                                                          'Swipe if complaint is resolved >>',
                                                                          style: AppFonts.headerStyle(
                                                                              fontSize: ResponsiveFlutter.of(context).fontSize(2),
                                                                              color: customcolor.greytext,
                                                                              fontWeight: FontWeight.normal),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                    ],
                                                  )
                                                : Container()
                                        : SizedBox(
                                            height: 0,
                                          )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ],
                );
              },
            ),
          )
        : norecordwidget();
  }

  unitcomplainttab2detail(
      List<unitcom.DependentdatumElement> _elements, String tab) {
        print("UNIT TAB");
    isExpandedListdependent =
        List<bool>.generate(_elements.length, (index) => false);
    return _elements.length > 0
        ? Padding(
            padding: const EdgeInsets.only(bottom: 200),
            child: ScrollablePositionedList.builder(
              scrollDirection: Axis.vertical,

              itemScrollController: _clienttab2controller,
              // initialScrollIndex: 0,

              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemCount: _elements.length,
              itemBuilder: (c, element) {
                return Stack(
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Card(
                        // elevation: 8.0,
                        margin: new EdgeInsets.symmetric(
                            horizontal: 2.0, vertical: 6.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: GestureDetector(
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.all(0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          GestureDetector(
                                              onTap: () {
                                                if (_elements[element].image1 !=
                                                        "" ||
                                                    _elements[element].image1 !=
                                                        null) {
                                                  showimage(
                                                      context,
                                                      "Complaint Images",
                                                      _elements[element].image1,
                                                      _elements[element]
                                                          .image2,_elements[element]
                                                          .closeImg1,_elements[element]
                                                          .closeImg2);
                                                }
                                              },
                                              child: Image.network(
                                                "${_elements[element].image1}",
                                                width: SizeConfig
                                                        .blockSizeHorizontal *
                                                    10,
                                                fit: BoxFit.cover,
                                                loadingBuilder:
                                                    (BuildContext context,
                                                        Widget child,
                                                        ImageChunkEvent?
                                                            loadingProgress) {
                                                  if (loadingProgress == null) {
                                                    // ✅ Image loaded successfully
                                                    return child;
                                                  } else {
                                                    // ⏳ Show loader while image is loading
                                                    return SizedBox(
                                                      width: SizeConfig
                                                              .blockSizeHorizontal *
                                                          10,
                                                      height: SizeConfig
                                                              .safeBlockVertical *
                                                          5,
                                                      child: Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                          color:
                                                              customcolor.blue,
                                                          strokeWidth: 2.0,
                                                          valueColor:
                                                              AlwaysStoppedAnimation<
                                                                      Color>(
                                                                  Colors
                                                                      .blueAccent),
                                                          value: loadingProgress
                                                                      .expectedTotalBytes !=
                                                                  null
                                                              ? loadingProgress
                                                                      .cumulativeBytesLoaded /
                                                                  (loadingProgress
                                                                          .expectedTotalBytes ??
                                                                      1)
                                                              : null,
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                },
                                                errorBuilder: (BuildContext
                                                        context,
                                                    Object exception,
                                                    StackTrace? stackTrace) {
                                                  return Icon(
                                                    Icons.error_outline,
                                                    size: SizeConfig
                                                            .blockSizeHorizontal *
                                                        10,
                                                  );
                                                },
                                              )

                                              //  Image.network(
                                              //   "${_elements[element].image1}",
                                              //   width: SizeConfig
                                              //           .blockSizeHorizontal *
                                              //       10,
                                              //   errorBuilder:
                                              //       (BuildContext context,
                                              //           Object exception,
                                              //           StackTrace? stackTrace) {
                                              //     return Icon(
                                              //       Icons.error_outline,
                                              //       size: SizeConfig
                                              //               .blockSizeHorizontal *
                                              //           10,
                                              //     );
                                              //   },
                                              // ),
                                              ),
                                          // Image.asset( 'assets/images/image1.png',width: SizeConfig.blockSizeHorizontal*10,),
                                          SizedBox(
                                            width:
                                                SizeConfig.blockSizeHorizontal *
                                                    2,
                                          ),
                                          Container(
                                            width:
                                                SizeConfig.blockSizeHorizontal *
                                                    38,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "${_elements[element].complainantName}",
                                                  style: AppFonts.headerStyle(
                                                      fontSize:
                                                          ResponsiveFlutter.of(
                                                                  context)
                                                              .fontSize(2),
                                                      color: customcolor.black,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                _elements[element]
                                                            .complainantName ==
                                                        "Cleaning"
                                                    ? Container(
                                                        width: SizeConfig
                                                                .blockSizeHorizontal *
                                                            40,
                                                        child: Text(
                                                          "${_elements[element].masterAreaName}-${_elements[element].masterBlockName}",
                                                          style: AppFonts.headerStyle(
                                                              fontSize:
                                                                  ResponsiveFlutter.of(
                                                                          context)
                                                                      .fontSize(
                                                                          1.4),
                                                              color: customcolor
                                                                  .black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                        ),
                                                      )
                                                    : Container(),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Flexible(
                                          child:
                                              //18april
                                              //  _elements[element].status=="Critical"?Container():
                                              ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          backgroundColor: tab == "3"
                                              ? customcolor.green
                                              : tab == "2"
                                                  ? customcolor.tabblue
                                                  : _elements[element].status ==
                                                          "Not Acknowleged"
                                                      ? customcolor.yellow
                                                      : (_elements[element]
                                                                      .status ==
                                                                  "In-Progress" ||
                                                              _elements[element]
                                                                      .status ==
                                                                  "In Progress")
                                                          ? customcolor
                                                              .darkorange
                                                          : customcolor.red,
                                          minimumSize: Size(
                                              SizeConfig.blockSizeHorizontal *
                                                  34,
                                              SizeConfig.blockSizeVertical * 3),
                                          textStyle: AppFonts.headerStyle(
                                              fontSize: 15,
                                              color: customcolor.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        onPressed: () {},
                                        child: Text(
                                          tab == "3"
                                              ? "Resolved"
                                              : tab == "2"
                                                  ? "Dependent"
                                                  : _elements[element].status,
                                          //=="Pending"?"Not Acknowledge":"Escalted",
                                          style: AppFonts.headerStyle(
                                              fontSize: 12,
                                              color: customcolor.white,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      )),
                                      //
                                      SizedBox(width: 5),
                                      GestureDetector(
                                        onTap: () {
                                          print(
                                              'Logged in id: ${_elements[element].id}');
                                          final tatList =
                                              _elements[element].tatLoggedData;

                                          showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            isDismissible: true,
                                            enableDrag: true,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                      top: Radius.circular(20)),
                                            ),
                                            backgroundColor: customcolor
                                                .greybg, // Set grey background here
                                            builder: (context) {
                                              return Padding(
                                                padding: EdgeInsets.only(
                                                  bottom: MediaQuery.of(context)
                                                      .viewInsets
                                                      .bottom,
                                                  top: 20,
                                                  left: 16,
                                                  right: 16,
                                                ),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Container(
                                                      height: 4,
                                                      width: 40,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              bottom: 12),
                                                      decoration: BoxDecoration(
                                                        color: Colors
                                                            .grey.shade400,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(2),
                                                      ),
                                                    ),
                                                    Text(
                                                      'Complaint Log',
                                                      style:
                                                          AppFonts.headerStyle(
                                                        fontSize: 20,
                                                        color:
                                                            customcolor.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 16),
                                                    SizedBox(
                                                      height: 300,
                                                      child: ListView.builder(
                                                        shrinkWrap: true,
                                                        itemCount:
                                                            tatList.length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          final item =
                                                              tatList[index];
                                                          return Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        8),
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(14),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors
                                                                  .white, // White card
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Colors
                                                                      .grey
                                                                      .withOpacity(
                                                                          0.1),
                                                                  spreadRadius:
                                                                      1,
                                                                  blurRadius: 4,
                                                                  offset:
                                                                      const Offset(
                                                                          0, 2),
                                                                ),
                                                              ],
                                                            ),
                                                            child: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  "${index + 1}. ",
                                                                  style: AppFonts
                                                                      .headerStyle(
                                                                    fontSize:
                                                                        16,
                                                                    color: customcolor
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child: Text(
                                                                    item.tatText.toString(),
                                                                    softWrap:
                                                                        true,
                                                                    style: AppFonts
                                                                        .headerStyle(
                                                                      fontSize:
                                                                          16,
                                                                      color: customcolor
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                    const SizedBox(height: 12),
                                                    ElevatedButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            customcolor.tabblue,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 32,
                                                                vertical: 12),
                                                      ),
                                                      child: const Text(
                                                        'Close',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 20),
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 6),
                                          child: Icon(Icons.info_outline,
                                              size: 22, color: Colors.grey),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 1,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 3, right: 3),
                                  child: Stack(
                                    children: [
                                      Container(
                                        width:
                                            SizeConfig.blockSizeHorizontal * 90,
                                        child: Card(
                                            color: customcolor.skybluebg,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(10),
                                              ),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  LayoutBuilder(
                                                    builder:
                                                        (context, constraints) {
                                                      final textPainter =
                                                          TextPainter(
                                                        text: TextSpan(
                                                          text:
                                                              _elements[element]
                                                                  .comment,
                                                          style: TextStyle(
                                                              fontSize: 16),
                                                        ),
                                                        textDirection: ui
                                                            .TextDirection.ltr,
                                                      );

                                                      textPainter.layout(
                                                        minWidth: 0,
                                                        maxWidth: constraints
                                                            .maxWidth,
                                                      );

                                                      final numberOfLines =
                                                          textPainter
                                                              .computeLineMetrics()
                                                              .length;

                                                      return Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "${_elements[element].comment}",
                                                            style: AppFonts.headerStyle(
                                                                fontSize: ResponsiveFlutter.of(
                                                                        context)
                                                                    .fontSize(
                                                                        1.4),
                                                                color:
                                                                    customcolor
                                                                        .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines:
                                                                isExpandedListdependent[
                                                                        element]
                                                                    ? null
                                                                    : 3,
                                                          ),
                                                          SizedBox(height: 2),
                                                          // Text(numberOfLines.toString()),
                                                          if (numberOfLines > 5)
                                                            GestureDetector(
                                                              onTap: () {
                                                                setState(() {
                                                                  isExpandedListdependent[
                                                                          element] =
                                                                      true;
                                                                  print(isExpandedListdependent[
                                                                      element]);
                                                                  ShowDialogs.showSMDialog(
                                                                      context,
                                                                      _elements[
                                                                              element]
                                                                          .complainantName,
                                                                      _elements[
                                                                              element]
                                                                          .comment);
                                                                });
                                                              },
                                                              child: Text(
                                                                isExpandedListdependent[
                                                                        element]
                                                                    ? ''
                                                                    : 'View More',
                                                                //   numberOfLines.toString(),
                                                                style: AppFonts.headerStyle(
                                                                    fontSize: ResponsiveFlutter.of(
                                                                            context)
                                                                        .fontSize(
                                                                            1.4),
                                                                    color:
                                                                        customcolor
                                                                            .blue,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400),
                                                              ),
                                                            ),
                                                        ],
                                                      );
                                                    },
                                                  ),

                                                  //                   Text(
                                                  // "${_elements[element].comment}",
                                                  //                   style:
                                                  //                    AppFonts.headerStyle(fontSize:ResponsiveFlutter.of(context).fontSize(1.4),
                                                  // color: customcolor.black,fontWeight: FontWeight.w400  ),

                                                  //           overflow: TextOverflow.ellipsis,
                                                  //           maxLines: 3,
                                                  //           ),
                                                  // SizedBox(height: 5,),
                                                ],
                                              ),
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12, right: 8, bottom: 8, top: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                        textAlign: TextAlign.justify,
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: "Logged at-",
                                              style: AppFonts.headerStyle(
                                                  fontSize: 12,
                                                  color: customcolor.black,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                            TextSpan(
                                              text:
                                                  "${_elements[element].loggedAt}",
                                              style: AppFonts.headerStyle(
                                                  fontSize: 12,
                                                  color: customcolor.tabblue,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      ),
                                      tab == "2"
                                          ? Container()
                                          : _elements[element].turnAroundTime ==
                                                  ""
                                              ? Container()
                                              : Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 12, right: 3),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      RichText(
                                                        textAlign:
                                                            TextAlign.justify,
                                                        text: TextSpan(
                                                          children: [
                                                            TextSpan(
                                                              text: "TAT - ",
                                                              style: AppFonts.headerStyle(
                                                                  fontSize: 12,
                                                                  color:
                                                                      customcolor
                                                                          .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal),
                                                            ),
                                                            TextSpan(
                                                              text:
                                                                  "${_elements[element].turnAroundTime}",
                                                              style: AppFonts.headerStyle(
                                                                  fontSize: 12,
                                                                  color: tab == "3"
                                                                      ? customcolor.green
                                                                      : (_elements[element].status == "In-Progress" || _elements[element].status == "In Progress")
                                                                          ? customcolor.darkorange
                                                                          : (_elements[element].status == "Critical")
                                                                              ? customcolor.red
                                                                              : customcolor.blue,
                                                                  fontWeight: FontWeight.w500),
                                                            ),
                                                            TextSpan(
                                                              text: _elements[element]
                                                                          .tatDate ==
                                                                      null
                                                                  ? ""
                                                                  : " (${_elements[element].tatDate.toString()})",
                                                              style: AppFonts.headerStyle(
                                                                  fontSize: 12,
                                                                  color: tab == "3"
                                                                      ? customcolor.green
                                                                      : (_elements[element].status == "In-Progress" || _elements[element].status == "In Progress")
                                                                          ? customcolor.darkorange
                                                                          : (_elements[element].status == "Critical")
                                                                              ? customcolor.red
                                                                              : customcolor.blue,
                                                                  fontWeight: FontWeight.w500),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                      _elements[element].TAT_remark == null
                                          ? SizedBox()
                                          : RichText(
                                              textAlign: TextAlign.justify,
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: "Remark :",
                                                    style: AppFonts.headerStyle(
                                                        fontSize: 12,
                                                        color:
                                                            customcolor.black,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        "${_elements[element].TAT_remark}",
                                                    style: AppFonts.headerStyle(
                                                        fontSize: 12,
                                                        color:
                                                            customcolor.tabblue,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ],
                                              ),
                                            ),
                                    ],
                                  ),
                                ),

                                (role == GlobalLists.headrole ||
                                        role ==
                                            GlobalLists.reginalmanagerrole ||
                                        role == GlobalLists.operationrole ||
                                        role ==
                                            GlobalLists.operationmanagerrole)
                                    ? tab == "1"
                                        ? Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Divider(),
                                              GestureDetector(
                                                onTap: () {},
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 4, bottom: 4),
                                                  child: Center(
                                                    child: _elements[element]
                                                                .status ==
                                                            "Not Acknowleged"
                                                        ? IntrinsicHeight(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              children: [
                                                                Container(
                                                                  width: SizeConfig
                                                                          .blockSizeHorizontal *
                                                                      40,
                                                                  child:
                                                                      GestureDetector(
                                                                    onTap: () {
                                                                      addtimer(
                                                                          context,
                                                                          "add",
                                                                          _elements[element]
                                                                              .id
                                                                              .toString());
                                                                    },
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        'Add Turn Around Time',
                                                                        style: AppFonts.headerStyle(
                                                                            fontSize:
                                                                                ResponsiveFlutter.of(context).fontSize(1.8),
                                                                            color: customcolor.tabblue,
                                                                            fontWeight: FontWeight.normal),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  width: SizeConfig
                                                                          .blockSizeHorizontal *
                                                                      5,
                                                                  child:
                                                                      VerticalDivider(
                                                                    color: customcolor
                                                                        .greyborder,
                                                                    thickness:
                                                                        1,
                                                                  ),
                                                                ),
                                                                Container(
                                                                  width: SizeConfig
                                                                          .blockSizeHorizontal *
                                                                      40,
                                                                  child:
                                                                      GestureDetector(
                                                                    onTap: () {
                                                                      getoperationdependentApi(_elements[
                                                                              element]
                                                                          .id
                                                                          .toString());
                                                                    },
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        'Mark as Dependent',
                                                                        style: AppFonts.headerStyle(
                                                                            fontSize:
                                                                                ResponsiveFlutter.of(context).fontSize(1.8),
                                                                            color: customcolor.tabblue,
                                                                            fontWeight: FontWeight.normal),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        : Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: [
                                                              (_elements[element].status == "Escalated" ||
                                                                      _elements[element]
                                                                              .status ==
                                                                          "In-Progress" ||
                                                                      _elements[element]
                                                                              .status ==
                                                                          "In Progress" ||
                                                                      _elements[element]
                                                                              .status ==
                                                                          "Critical")
                                                                  ? GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        addtimer(
                                                                            context,
                                                                            "edit",
                                                                            _elements[element].id.toString());
                                                                      },
                                                                      child:
                                                                          Text(
                                                                        'Edit Turn Around Time',
                                                                        style: AppFonts.headerStyle(
                                                                            fontSize:
                                                                                ResponsiveFlutter.of(context).fontSize(1.8),
                                                                            color: customcolor.tabblue,
                                                                            fontWeight: FontWeight.normal),
                                                                      ),
                                                                    )
                                                                  : Container(),
                                                              _elements[element]
                                                                              .TAT_remark !=
                                                                          null &&
                                                                      (_elements[element].status == "Escalated" ||
                                                                          _elements[element].status ==
                                                                              "In-Progress" ||
                                                                          _elements[element].status ==
                                                                              "In Progress" ||
                                                                          _elements[element].status ==
                                                                              "Critical")
                                                                  ? Container(
                                                                      height:
                                                                          18,
                                                                      width: 1,
                                                                      color: customcolor
                                                                          .greyborder,
                                                                    )
                                                                  : SizedBox(),
                                                              _elements[element]
                                                                          .TAT_remark ==
                                                                      null||_elements[element].TAT_remark.isEmpty
                                                                  ? SizedBox()
                                                                  : GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        showRemarkDialog(
                                                                            context,
                                                                            _elements[element].TAT_remark);
                                                                      },
                                                                      child:
                                                                          Text(
                                                                        'View Remark',
                                                                        style: AppFonts
                                                                            .headerStyle(
                                                                          fontSize:
                                                                              ResponsiveFlutter.of(context).fontSize(1.8),
                                                                          color:
                                                                              customcolor.tabblue,
                                                                          fontWeight:
                                                                              FontWeight.normal,
                                                                        ),
                                                                      ),
                                                                    ),
                                                           
                                                            ],
                                                          ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    bottom: BorderSide(
                                                        color:
                                                            customcolor.greybg),
                                                  ),
                                                ),
                                              ),
                                              _elements[element].status ==
                                                      "Not Acknowleged"
                                                  ? Container()
                                                  : Container(
                                                      decoration: BoxDecoration(
                                                        color:
                                                            customcolor.green,
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  15),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  15),
                                                        ),
                                                      ),
                                                      // height: 40,
                                                      child: SwipeActionCell(
                                                        fullSwipeFactor: 0.1,
                                                        // firstActionWillCoverAllSpaceOnDeleting: false,
                                                        // backgroundColor:customcolor.green,
                                                        //  icon: Icon(Icons.check, color: Colors.green),
                                                        selectedForegroundColor:
                                                            customcolor.green,
                                                        backgroundColor:
                                                            customcolor.greybg,
                                                        key: ObjectKey(0),
                                                        leadingActions: [
                                                          SwipeAction(
                                                            icon: Icon(
                                                              Icons.check,
                                                              color: customcolor
                                                                  .green,
                                                            ),
                                                            performsFirstActionWithFullSwipe:
                                                                true,
                                                            onTap: (CompletionHandler
                                                                handler) async {
                                                              // Handle swipe action
                                                              setState(() {
                                                                print(
                                                                    "Resolvef");
                                                                getoperationalresolvedApi(
                                                                    _elements[
                                                                            element]
                                                                        .id
                                                                        .toString());
//.then((value) {
//                         if(value!=null)
//                         {
                                                                handler(true);
//        ShowDialogs().confirmationdone(context,"Complaint Resolved \nSuccessfully");

//     Timer(
//             Duration(seconds: 1),
//                 () =>  Navigator.pop(context));
//                         }
//                       });
                                                              });
                                                            },
                                                            color: customcolor
                                                                .green,
                                                          ),
                                                        ],
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              bottomLeft: Radius
                                                                  .circular(15),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          15),
                                                            ),
                                                          ),
                                                          height: 40,
                                                          child: Row(
                                                            children: [
                                                              Container(
                                                                width: SizeConfig
                                                                        .safeBlockHorizontal *
                                                                    15,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color:
                                                                      customcolor
                                                                          .green,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .only(
                                                                    bottomLeft:
                                                                        Radius.circular(
                                                                            10),
                                                                  ),
                                                                ),
                                                                height: 40,
                                                                child: Icon(
                                                                  Icons
                                                                      .arrow_forward,
                                                                  color:
                                                                      customcolor
                                                                          .white,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: SizeConfig
                                                                        .blockSizeHorizontal *
                                                                    5,
                                                              ),
                                                              Center(
                                                                child: Text(
                                                                  'Swipe if complaint is resolved >>',
                                                                  style: AppFonts.headerStyle(
                                                                      fontSize: ResponsiveFlutter.of(
                                                                              context)
                                                                          .fontSize(
                                                                              2),
                                                                      color: customcolor
                                                                          .greytext,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                            ],
                                          )
                                        :
                                        //change 22feb
                                        //dependenttab
                                        tab == "2"
                                            ? Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      border: Border(
                                                        bottom: BorderSide(
                                                            color: customcolor
                                                                .greybg),
                                                      ),
                                                    ),
                                                  ),
                                                  _elements[element].status ==
                                                          "Not Acknowleged"
                                                      ? Container()
                                                      : Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: customcolor
                                                                .green,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              bottomLeft: Radius
                                                                  .circular(15),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          15),
                                                            ),
                                                          ),
                                                          // height: 40,
                                                          child:
                                                              SwipeActionCell(
                                                            fullSwipeFactor:
                                                                0.1,
                                                            // firstActionWillCoverAllSpaceOnDeleting: false,
                                                            // backgroundColor:customcolor.green,
                                                            //  icon: Icon(Icons.check, color: Colors.green),
                                                            selectedForegroundColor:
                                                                customcolor
                                                                    .green,
                                                            backgroundColor:
                                                                customcolor
                                                                    .greybg,
                                                            key: ObjectKey(0),
                                                            leadingActions: [
                                                              SwipeAction(
                                                                icon: Icon(
                                                                  Icons.check,
                                                                  color:
                                                                      customcolor
                                                                          .green,
                                                                ),
                                                                performsFirstActionWithFullSwipe:
                                                                    true,
                                                                onTap: (CompletionHandler
                                                                    handler) async {
                                                                  // Handle swipe action
                                                                  setState(() {
                                                                    print(
                                                                        "Resolvef");
                                                                    getoperationalresolvedApi(
                                                                        _elements[element]
                                                                            .id
                                                                            .toString());
//.then((value) {
//                         if(value!=null)
//                         {
                                                                    handler(
                                                                        true);
//        ShowDialogs().confirmationdone(context,"Complaint Resolved \nSuccessfully");

//     Timer(
//             Duration(seconds: 1),
//                 () =>  Navigator.pop(context));
//                         }
//                       });
                                                                  });
                                                                },
                                                                color:
                                                                    customcolor
                                                                        .green,
                                                              ),
                                                            ],
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .only(
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          15),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          15),
                                                                ),
                                                              ),
                                                              height: 40,
                                                              child: Row(
                                                                children: [
                                                                  Container(
                                                                    width: SizeConfig
                                                                            .safeBlockHorizontal *
                                                                        15,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: customcolor
                                                                          .green,
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .only(
                                                                        bottomLeft:
                                                                            Radius.circular(10),
                                                                      ),
                                                                    ),
                                                                    height: 40,
                                                                    child: Icon(
                                                                      Icons
                                                                          .arrow_forward,
                                                                      color: customcolor
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: SizeConfig
                                                                            .blockSizeHorizontal *
                                                                        5,
                                                                  ),
                                                                  Center(
                                                                    child: Text(
                                                                      'Swipe if complaint is resolved >>',
                                                                      style: AppFonts.headerStyle(
                                                                          fontSize: ResponsiveFlutter.of(context).fontSize(
                                                                              2),
                                                                          color: customcolor
                                                                              .greytext,
                                                                          fontWeight:
                                                                              FontWeight.normal),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                ],
                                              )
                                            : Container()
                                    : SizedBox(
                                        height: 0,
                                      )

//
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
//                   element['isoptionopen']?
//                                             //optionsDropdown(element['id'].toString(),element)
//                                             Align(
//         alignment: Alignment.topRight,
//         child: Padding(
//           padding: const EdgeInsets.only(top:0),
//           child: Container(
//           //  padding: EdgeInsets.only(top: 5, left: 80, right: 1),
//             height: 115,
//             width: 130,
//             decoration: BoxDecoration(
//                 color: Colors.transparent, borderRadius: BorderRadius.circular(10)),
//             child: Card(
//               elevation: 5,
//               child: Padding(
//                   padding: EdgeInsets.only(top: 5, left: 10, right: 5),
//                   child: ListView.builder(
//                       itemCount: options.length,
//                       //  physics: ClampingScrollPhysics(),
//                       shrinkWrap: true,
//                       itemBuilder: (BuildContext context, int index) {
//                         return Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             GestureDetector(
//                               onTap: () {
//                                 setState(() {
//                                   element['status'] = options[index];

//                                   element['isoptionopen'] = false;
//                                   if(element['status']=="Dependent")
//                                   {
//                                     getdependentApi(element['id'].toString());
//                                   }else if(element['status']=="Resolved")
//                                   {
//                                     getresolvedApi(element['id'].toString());
//                                   }else if(element['status']=="TAT")
//                                   {

//                                     _value=(element['TAT_duration']==0.0||element['TAT_duration']==null)?5.0:double.parse(element['TAT_duration']);
//                                     print("_value");
//                                     print(_value);
//                                     confirmationtat(context,element['id'].toString());
//                                   }

//                                 });
//                               },
//                               child: Container(
//                                 color: Colors.white,
//                                 width: SizeConfig.blockSizeHorizontal * 100,
//                                 child: Text(
//                                   options[index],
//                                   textAlign: TextAlign.left,
//                                   style:

//                                     AppFonts.headerStyle(fontSize:14,
// color: customcolor.black,fontWeight: FontWeight.normal  ),

//                                 ),
//                               ),
//                             ),
//                             SizedBox(
//                               height: 5,
//                             ),
//                             Divider(
//                               color: customcolor.greytext,
//                             )
//                           ],
//                         );
//                       })),
//             ),
//           ),
//         ),
//       )
//                                             :Container()
                  ],
                );
              },
            ),
          )
        : norecordwidget();
  }

  void showImagePopup(
      BuildContext context, List<Map<String, String>> imageList) {
    print("imageList ${imageList.length}");
    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDialogHeader(context, "Complaint Images"),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: imageList
                      .where(
                          (img) => img['url'] != null && img['url']!.isNotEmpty)
                      .map((img) => Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: GestureDetector(
                              onTap: () => _showFullImageDialog(
                                context,
                                img['url']!,
                                img['label'] ?? '',
                              ),
                              child: _buildThumbnail(img['url']!, img['label']),
                            ),
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Used when displaying Before/After or two images
  void showimage(
    BuildContext context,
    String title,
    String? resultvalue,
    String? resultvalue2,
        String? resultvalue3,
    String? resultvalue4,
  ) {
    showDialog(
      context: context,
      builder: (_) {
        print("COMPLAINT IMAGE LENGTH");
          print("$resultvalue");
            print("$resultvalue2");
             print("$resultvalue3");
              print("$resultvalue4");
        return Dialog(
          insetPadding: const EdgeInsets.all(10),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDialogHeader(context, title),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      if (resultvalue != null &&
                          resultvalue.isNotEmpty &&
                          resultvalue != "null")
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: GestureDetector(
                            onTap: () =>
                                _showFullImageDialog(context, resultvalue, ""),
                            child: _buildThumbnail(resultvalue, ""),
                          ),
                        ),
                      if (resultvalue2 != null &&
                          resultvalue2.isNotEmpty &&
                          resultvalue2 != "null")
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: GestureDetector(
                            onTap: () =>
                                _showFullImageDialog(context, resultvalue2, ""),
                            child: _buildThumbnail(resultvalue2, ""),
                          ),
                          
                        ),
                        if (resultvalue3 != null &&
                          resultvalue3.isNotEmpty &&
                          resultvalue3 != "null")
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: GestureDetector(
                            onTap: () =>
                                _showFullImageDialog(context, resultvalue3, ""),
                            child: _buildThumbnail(resultvalue3, "Resolved"),
                          ),
                          
                        ),
                        if (resultvalue4 != null &&
                          resultvalue4.isNotEmpty &&
                          resultvalue4 != "null")
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: GestureDetector(
                            onTap: () =>
                                _showFullImageDialog(context, resultvalue4, ""),
                            child: _buildThumbnail(resultvalue4, "Resolved"),
                          ),
                          
                        ),
                      if ((resultvalue == null ||
                              resultvalue.isEmpty ||
                              resultvalue == "null") &&
                          (resultvalue2 == null ||
                              resultvalue2.isEmpty ||
                              resultvalue2 == "null"))
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Center(child: Text("No Image Uploaded")),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Common header for all dialogs
  Widget _buildDialogHeader(BuildContext context, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.close),
        ),
      ],
    );
  }

  /// Common thumbnail widget
  Widget _buildThumbnail(String url, String? label) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            url,
            width: 250, // Consistent size across dialogs
            height: 180,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return const Center(child: CircularProgressIndicator());
            },
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.broken_image, size: 100),
          ),
        ),
        if (label != null && label.isNotEmpty)
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.8),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
      ],
    );
  }

  void _showFullImageDialog(
      BuildContext context, String imageUrl, String label) {
          print("COMPLAINT _showFullImageDialog LENGTH");
    showDialog(
      context: context,
      builder: (_) => Dialog(
        insetPadding: const EdgeInsets.all(10),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDialogHeader(context, "Complaint Images"),
              const SizedBox(height: 12),
              FutureBuilder<Size>(
                future: _getImageSize(imageUrl),
                builder: (context, snapshot) {
                  final screenWidth = MediaQuery.of(context).size.width;
                  final screenHeight = MediaQuery.of(context).size.height;

                  double displayHeight = screenHeight * 0.6;

                  if (snapshot.hasData) {
                    final imgSize = snapshot.data!;
                    final aspectRatio = imgSize.width / imgSize.height;

                    // height = width / aspectRatio
                    displayHeight = screenWidth / aspectRatio;

                    // Limit height so dialog fits on screen
                    if (displayHeight > screenHeight * 0.85) {
                      displayHeight = screenHeight * 0.85;
                    }
                  }

                  return Container(
                    width: double.infinity, // FULL WIDTH
                    height: displayHeight,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Stack(
                        children: [
                          InteractiveViewer(
                            panEnabled: true,
                            minScale: 1,
                            maxScale: 4,
                            child: Image.network(
                              imageUrl,
                              width: double.infinity, // full width
                              height: displayHeight,
                              fit: BoxFit.cover, // fills width nicely
                              errorBuilder: (context, error, stackTrace) =>
                                  const Center(
                                child: Icon(Icons.broken_image,
                                    size: 100, color: Colors.grey),
                              ),
                            ),
                          ),
                          if (label.isNotEmpty)
                            Positioned(
                              top: 12,
                              left: 12,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  label,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Helper: get actual image size (for ratio-based height)
  Future<Size> _getImageSize(String url) async {
    final completer = Completer<Size>();
    final image = Image.network(url);
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((info, _) {
        completer.complete(Size(
          info.image.width.toDouble(),
          info.image.height.toDouble(),
        ));
      }),
    );
    return completer.future;
  }


  unitcomplainttab3detail(
      List<unitcom.DependentdatumElement> _elements, String tab) {
    isExpandedListresolved =
        List<bool>.generate(_elements.length, (index) => false);
    return _elements.length > 0
        ? Padding(
            padding: const EdgeInsets.only(bottom: 200),
            child: ScrollablePositionedList.builder(
              scrollDirection: Axis.vertical,
              // itemScrollController: itemScrollController,
              // scrollOffsetController: scrollOffsetController,
              // itemPositionsListener: itemPositionsListener,
              // scrollOffsetListener: scrollOffsetListener,
              itemScrollController: _clienttab3controller,
              // initialScrollIndex: 0,

              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemCount: _elements.length,
              itemBuilder: (c, element) {
                return Stack(
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Card(
                        // elevation: 8.0,
                        margin: new EdgeInsets.symmetric(
                            horizontal: 2.0, vertical: 6.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: GestureDetector(
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.all(0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                         
                                          GestureDetector(
                                              onTap: () {
                                                final item = _elements[element];
                                                print(
                                                    'item.closeImg1: ${item.closeImg1}');
                                                print(
                                                    'item.image1: ${item.image1}');
                                                if (item.image1 != "" ||
                                                    item.image2 != "" ||
                                                    item.closeImg1 != "" ||
                                                    item.closeImg2 != "") {
                                                  showImagePopup(
                                                    context,
                                                    [
                                                      if (item.image1 != null &&
                                                          item.image1
                                                              .isNotEmpty)
                                                        {
                                                          'url': item.image1,
                                                          'label': ''
                                                        },
                                                      if (item.image2 != null &&
                                                          item.image2
                                                              .isNotEmpty)
                                                        {
                                                          'url': item.image2,
                                                          'label': ''
                                                        },
                                                      if (item.closeImg1 !=
                                                              null &&
                                                          item.closeImg1
                                                              .isNotEmpty)
                                                        {
                                                          'url': item.closeImg1,
                                                          'label': 'Resolved'
                                                        },
                                                      if (item.closeImg2 !=
                                                              null &&
                                                          item.closeImg2
                                                              .isNotEmpty)
                                                        {
                                                          'url': item.closeImg2,
                                                          'label': 'Resolved'
                                                        },
                                                    ],
                                                  );
                                                }
                                              },
                                              child: Image.network(
                                                (_elements[element].closeImg1 !=
                                                            null &&
                                                        _elements[element]
                                                            .closeImg1!
                                                            .isNotEmpty)
                                                    ? _elements[element]
                                                        .closeImg1!
                                                    : (_elements[element]
                                                            .image1 ??
                                                        ''),
                                                width: SizeConfig
                                                        .blockSizeHorizontal *
                                                    10,
                                                fit: BoxFit.cover,
                                                loadingBuilder:
                                                    (BuildContext context,
                                                        Widget child,
                                                        ImageChunkEvent?
                                                            loadingProgress) {
                                                  if (loadingProgress == null) {
                                                    // ✅ Image loaded successfully
                                                    return child;
                                                  } else {
                                                    // ⏳ Show loader while image is loading
                                                    return SizedBox(
                                                      width: SizeConfig
                                                              .blockSizeHorizontal *
                                                          10,
                                                      height: SizeConfig
                                                              .safeBlockVertical *
                                                          5,
                                                      child: Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                          color:
                                                              customcolor.blue,
                                                          strokeWidth: 2.0,
                                                          valueColor:
                                                              AlwaysStoppedAnimation<
                                                                      Color>(
                                                                  Colors
                                                                      .blueAccent),
                                                          value: loadingProgress
                                                                      .expectedTotalBytes !=
                                                                  null
                                                              ? loadingProgress
                                                                      .cumulativeBytesLoaded /
                                                                  (loadingProgress
                                                                          .expectedTotalBytes ??
                                                                      1)
                                                              : null,
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                },
                                                errorBuilder: (BuildContext
                                                        context,
                                                    Object exception,
                                                    StackTrace? stackTrace) {
                                                  return Icon(
                                                    Icons.error_outline,
                                                    size: SizeConfig
                                                            .blockSizeHorizontal *
                                                        10,
                                                  );
                                                },
                                              )

                                              //  Image.network(
                                              //   (_elements[element].closeImg1 !=
                                              //               null &&
                                              //           _elements[element]
                                              //               .closeImg1!
                                              //               .isNotEmpty)
                                              //       ? _elements[element]
                                              //           .closeImg1!
                                              //       : (_elements[element]
                                              //               .image1 ??
                                              //           ''),
                                              //   width: SizeConfig
                                              //           .blockSizeHorizontal *
                                              //       10,
                                              //   errorBuilder:
                                              //       (BuildContext context,
                                              //           Object exception,
                                              //           StackTrace? stackTrace) {
                                              //     return Icon(
                                              //       Icons.error_outline,
                                              //       size: SizeConfig
                                              //               .blockSizeHorizontal *
                                              //           10,
                                              //     );
                                              //   },
                                              // ),
                                              ),

                                          // Image.asset( 'assets/images/image1.png',width: SizeConfig.blockSizeHorizontal*10,),
                                          SizedBox(
                                            width:
                                                SizeConfig.blockSizeHorizontal *
                                                    2,
                                          ),
                                          Container(
                                            width:
                                                SizeConfig.blockSizeHorizontal *
                                                    38,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "${_elements[element].complainantName}",
                                                  style: AppFonts.headerStyle(
                                                      fontSize:
                                                          ResponsiveFlutter.of(
                                                                  context)
                                                              .fontSize(2),
                                                      color: customcolor.black,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                _elements[element]
                                                            .complainantName ==
                                                        "Cleaning"
                                                    ? Container(
                                                        width: SizeConfig
                                                                .blockSizeHorizontal *
                                                            40,
                                                        child: Text(
                                                          "${_elements[element].masterAreaName}-${_elements[element].masterBlockName}",
                                                          style: AppFonts.headerStyle(
                                                              fontSize:
                                                                  ResponsiveFlutter.of(
                                                                          context)
                                                                      .fontSize(
                                                                          1.4),
                                                              color: customcolor
                                                                  .black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                        ),
                                                      )
                                                    : Container(),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Flexible(
                                          child:
                                              //18april
                                              //  _elements[element].status=="Critical"?Container():
                                              ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          backgroundColor: tab == "3"
                                              ? customcolor.green
                                              : tab == "2"
                                                  ? customcolor.tabblue
                                                  : _elements[element].status ==
                                                          "Not Acknowleged"
                                                      ? customcolor.yellow
                                                      : (_elements[element]
                                                                      .status ==
                                                                  "In-Progress" ||
                                                              _elements[element]
                                                                      .status ==
                                                                  "In Progress")
                                                          ? customcolor
                                                              .darkorange
                                                          : customcolor.red,
                                          minimumSize: Size(
                                              SizeConfig.blockSizeHorizontal *
                                                  34,
                                              SizeConfig.blockSizeVertical * 3),
                                          textStyle: AppFonts.headerStyle(
                                              fontSize: 15,
                                              color: customcolor.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        onPressed: () {},
                                        child: Text(
                                          tab == "3"
                                              ? "Resolved"
                                              : tab == "2"
                                                  ? "Dependent"
                                                  : _elements[element].status,
                                          //=="Pending"?"Not Acknowledge":"Escalted",
                                          style: AppFonts.headerStyle(
                                              fontSize: 12,
                                              color: customcolor.white,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      )),
                                      //
                                      SizedBox(
                                        width: 5,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          print(
                                              'Logged in id: ${_elements[element].id}');
                                          final tatList =
                                              _elements[element].tatLoggedData;

                                          showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            isDismissible: true,
                                            enableDrag: true,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                      top: Radius.circular(20)),
                                            ),
                                            backgroundColor: customcolor
                                                .greybg, // Set grey background here
                                            builder: (context) {
                                              return Padding(
                                                padding: EdgeInsets.only(
                                                  bottom: MediaQuery.of(context)
                                                      .viewInsets
                                                      .bottom,
                                                  top: 20,
                                                  left: 16,
                                                  right: 16,
                                                ),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Container(
                                                      height: 4,
                                                      width: 40,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              bottom: 12),
                                                      decoration: BoxDecoration(
                                                        color: Colors
                                                            .grey.shade400,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(2),
                                                      ),
                                                    ),
                                                    Text(
                                                      'Complaint Log',
                                                      style:
                                                          AppFonts.headerStyle(
                                                        fontSize: 20,
                                                        color:
                                                            customcolor.tabblue,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 16),
                                                    SizedBox(
                                                      height: 300,
                                                      child: ListView.builder(
                                                        shrinkWrap: true,
                                                        itemCount:
                                                            tatList.length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          final item =
                                                              tatList[index];
                                                          return Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        8),
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(14),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors
                                                                  .white, // White card
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Colors
                                                                      .grey
                                                                      .withOpacity(
                                                                          0.1),
                                                                  spreadRadius:
                                                                      1,
                                                                  blurRadius: 4,
                                                                  offset:
                                                                      const Offset(
                                                                          0, 2),
                                                                ),
                                                              ],
                                                            ),
                                                            child: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  "${index + 1}. ",
                                                                  style: AppFonts
                                                                      .headerStyle(
                                                                    fontSize:
                                                                        16,
                                                                    color: customcolor
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child: Text(
                                                                    item.tatText.toString(),
                                                                    softWrap:
                                                                        true,
                                                                    style: AppFonts
                                                                        .headerStyle(
                                                                      fontSize:
                                                                          16,
                                                                      color: customcolor
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                    const SizedBox(height: 12),
                                                    ElevatedButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            customcolor.tabblue,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 32,
                                                                vertical: 12),
                                                      ),
                                                      child: const Text(
                                                        'Close',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 20),
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 6),
                                          child: Icon(Icons.info_outline,
                                              size: 22, color: Colors.grey),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 1,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 3, right: 3),
                                  child: Stack(
                                    children: [
                                      Container(
                                        width:
                                            SizeConfig.blockSizeHorizontal * 90,
                                        child: Card(
                                            color: customcolor.skybluebg,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(10),
                                              ),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  LayoutBuilder(
                                                    builder:
                                                        (context, constraints) {
                                                      final textPainter =
                                                          TextPainter(
                                                        text: TextSpan(
                                                          text:
                                                              _elements[element]
                                                                  .comment,
                                                          style: TextStyle(
                                                              fontSize: 16),
                                                        ),
                                                        textDirection: ui
                                                            .TextDirection.ltr,
                                                      );

                                                      textPainter.layout(
                                                        minWidth: 0,
                                                        maxWidth: constraints
                                                            .maxWidth,
                                                      );

                                                      final numberOfLines =
                                                          textPainter
                                                              .computeLineMetrics()
                                                              .length;

                                                      return Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "${_elements[element].comment}",
                                                            style: AppFonts.headerStyle(
                                                                fontSize: ResponsiveFlutter.of(
                                                                        context)
                                                                    .fontSize(
                                                                        1.4),
                                                                color:
                                                                    customcolor
                                                                        .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines:
                                                                isExpandedListresolved[
                                                                        element]
                                                                    ? null
                                                                    : 3,
                                                          ),
                                                          SizedBox(height: 2),
                                                          // Text(numberOfLines.toString()),
                                                          if (numberOfLines > 5)
                                                            GestureDetector(
                                                              onTap: () {
                                                                setState(() {
                                                                  isExpandedListresolved[
                                                                          element] =
                                                                      true;
                                                                  print(isExpandedListresolved[
                                                                      element]);
                                                                  ShowDialogs.showSMDialog(
                                                                      context,
                                                                      _elements[
                                                                              element]
                                                                          .complainantName,
                                                                      _elements[
                                                                              element]
                                                                          .comment);
                                                                });
                                                              },
                                                              child: Text(
                                                                isExpandedListresolved[
                                                                        element]
                                                                    ? ''
                                                                    : 'View More',
                                                                //   numberOfLines.toString(),
                                                                style: AppFonts.headerStyle(
                                                                    fontSize: ResponsiveFlutter.of(
                                                                            context)
                                                                        .fontSize(
                                                                            1.4),
                                                                    color:
                                                                        customcolor
                                                                            .blue,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400),
                                                              ),
                                                            ),
                                                        ],
                                                      );
                                                    },
                                                  ),

                                                  //                   Text("${_elements[element].comment}",
                                                  //                   style:
                                                  //                    AppFonts.headerStyle(fontSize:ResponsiveFlutter.of(context).fontSize(1.4),
                                                  // color: customcolor.black,fontWeight: FontWeight.w400  ),

                                                  //           overflow: TextOverflow.ellipsis,
                                                  //           maxLines: 3,),
                                                  // SizedBox(height: 5,),
                                                ],
                                              ),
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                                /*Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12, right: 8, bottom: 8, top: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                        textAlign: TextAlign.justify,
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: "Logged at-",
                                              style: AppFonts.headerStyle(
                                                  fontSize: 12,
                                                  color: customcolor.black,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                            TextSpan(
                                              text:
                                                  "${_elements[element].loggedAt}",
                                              style: AppFonts.headerStyle(
                                                  fontSize: 12,
                                                  color: customcolor.tabblue,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      ),
                                      tab == "2"
                                          ? Container()
                                          : _elements[element].turnAroundTime ==
                                                  ""
                                              ? Container()
                                              : Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 12, right: 3),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      RichText(
                                                        textAlign:
                                                            TextAlign.justify,
                                                        text: TextSpan(
                                                          children: [
                                                            TextSpan(
                                                              text: "TAT - ",
                                                              style: AppFonts.headerStyle(
                                                                  fontSize: 12,
                                                                  color:
                                                                      customcolor
                                                                          .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal),
                                                            ),
                                                            TextSpan(
                                                              text:
                                                                  "${_elements[element].turnAroundTime}",
                                                              style: AppFonts.headerStyle(
                                                                  fontSize: 12,
                                                                  color: tab == "3"
                                                                      ? customcolor.green
                                                                      : (_elements[element].status == "In-Progress" || _elements[element].status == "In Progress")
                                                                          ? customcolor.darkorange
                                                                          : (_elements[element].status == "Critical")
                                                                              ? customcolor.red
                                                                              : customcolor.blue,
                                                                  fontWeight: FontWeight.w500),
                                                            ),
                                                            TextSpan(
                                                              text: _elements[element]
                                                                          .tatDate ==
                                                                      null
                                                                  ? ""
                                                                  : " (${_elements[element].tatDate.toString()})",
                                                              style: AppFonts.headerStyle(
                                                                  fontSize: 12,
                                                                  color: tab == "3"
                                                                      ? customcolor.green
                                                                      : (_elements[element].status == "In-Progress" || _elements[element].status == "In Progress")
                                                                          ? customcolor.darkorange
                                                                          : (_elements[element].status == "Critical")
                                                                              ? customcolor.red
                                                                              : customcolor.blue,
                                                                  fontWeight: FontWeight.w500),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                    ],
                                  ),
                                ),*/
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12, right: 8, bottom: 8, top: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: RichText(
                                                textAlign: TextAlign.justify,
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: "Logged at - ",
                                                      style:
                                                          AppFonts.headerStyle(
                                                        fontSize: 12,
                                                        color:
                                                            customcolor.black,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text:
                                                          "${_elements[element].loggedAt}",
                                                      style:
                                                          AppFonts.headerStyle(
                                                        fontSize: 12,
                                                        color:
                                                            customcolor.tabblue,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      /// The existing TAT section (no changes)
                                      tab == "2"
                                          ? Container()
                                          : _elements[element].turnAroundTime ==
                                                  ""
                                              ? Container()
                                              : Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 12, right: 3),
                                                  child: Row(
                                                    children: [
                                                      RichText(
                                                        textAlign:
                                                            TextAlign.justify,
                                                        text: TextSpan(
                                                          children: [
                                                            TextSpan(
                                                              text: "TAT - ",
                                                              style: AppFonts
                                                                  .headerStyle(
                                                                fontSize: 12,
                                                                color:
                                                                    customcolor
                                                                        .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                              ),
                                                            ),
                                                            TextSpan(
                                                              text:
                                                                  "${_elements[element].turnAroundTime}",
                                                              style: AppFonts
                                                                  .headerStyle(
                                                                fontSize: 12,
                                                                color: tab ==
                                                                        "3"
                                                                    ? customcolor
                                                                        .green
                                                                    : (_elements[element].status ==
                                                                                "In-Progress" ||
                                                                            _elements[element].status ==
                                                                                "In Progress")
                                                                        ? customcolor
                                                                            .darkorange
                                                                        : (_elements[element].status ==
                                                                                "Critical")
                                                                            ? customcolor.red
                                                                            : customcolor.blue,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                            TextSpan(
                                                              text: _elements[element]
                                                                          .tatDate ==
                                                                      null
                                                                  ? ""
                                                                  : " (${_elements[element].tatDate.toString()})",
                                                              style: AppFonts
                                                                  .headerStyle(
                                                                fontSize: 12,
                                                                color: tab ==
                                                                        "3"
                                                                    ? customcolor
                                                                        .green
                                                                    : (_elements[element].status ==
                                                                                "In-Progress" ||
                                                                            _elements[element].status ==
                                                                                "In Progress")
                                                                        ? customcolor
                                                                            .darkorange
                                                                        : (_elements[element].status ==
                                                                                "Critical")
                                                                            ? customcolor.red
                                                                            : customcolor.blue,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                    ],
                                  ),
                                ),

                                (role == GlobalLists.headrole ||
                                        role ==
                                            GlobalLists.reginalmanagerrole ||
                                        role == GlobalLists.operationrole ||
                                        role ==
                                            GlobalLists.operationmanagerrole)
                                    ? tab == "1"
                                        ? Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Divider(),
                                              GestureDetector(
                                                onTap: () {},
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 4, bottom: 4),
                                                  child: Center(
                                                    child: _elements[element]
                                                                .status ==
                                                            "Not Acknowleged"
                                                        ? IntrinsicHeight(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Container(
                                                                  width: SizeConfig
                                                                          .blockSizeHorizontal *
                                                                      40,
                                                                  child:
                                                                      GestureDetector(
                                                                    onTap: () {
                                                                      addtimer(
                                                                          context,
                                                                          "add",
                                                                          _elements[element]
                                                                              .id
                                                                              .toString());
                                                                    },
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        'Add Turn Around Time',
                                                                        style: AppFonts.headerStyle(
                                                                            fontSize:
                                                                                ResponsiveFlutter.of(context).fontSize(1.8),
                                                                            color: customcolor.tabblue,
                                                                            fontWeight: FontWeight.normal),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  width: SizeConfig
                                                                          .blockSizeHorizontal *
                                                                      5,
                                                                  child:
                                                                      VerticalDivider(
                                                                    color: customcolor
                                                                        .greyborder,
                                                                    thickness:
                                                                        1,
                                                                  ),
                                                                ),
                                                                Container(
                                                                  width: SizeConfig
                                                                          .blockSizeHorizontal *
                                                                      40,
                                                                  child:
                                                                      GestureDetector(
                                                                    onTap: () {
                                                                      getoperationdependentApi(_elements[
                                                                              element]
                                                                          .id
                                                                          .toString());
                                                                    },
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        'Mark as Dependent',
                                                                        style: AppFonts.headerStyle(
                                                                            fontSize:
                                                                                ResponsiveFlutter.of(context).fontSize(1.8),
                                                                            color: customcolor.tabblue,
                                                                            fontWeight: FontWeight.normal),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        : Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: [
                                                              (_elements[element].status == "Escalated" ||
                                                                      _elements[element]
                                                                              .status ==
                                                                          "In-Progress" ||
                                                                      _elements[element]
                                                                              .status ==
                                                                          "In Progress" ||
                                                                      _elements[element]
                                                                              .status ==
                                                                          "Critical")
                                                                  ? GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        addtimer(
                                                                            context,
                                                                            "edit",
                                                                            _elements[element].id.toString());
                                                                      },
                                                                      child:
                                                                          Text(
                                                                        'Edit Turn Around Time',
                                                                        style: AppFonts.headerStyle(
                                                                            fontSize:
                                                                                ResponsiveFlutter.of(context).fontSize(1.8),
                                                                            color: customcolor.tabblue,
                                                                            fontWeight: FontWeight.normal),
                                                                      ),
                                                                    )
                                                                  : Container(),
                                                              _elements[element]
                                                                              .TAT_remark !=
                                                                          null &&
                                                                      (_elements[element].status == "Escalated" ||
                                                                          _elements[element].status ==
                                                                              "In-Progress" ||
                                                                          _elements[element].status ==
                                                                              "In Progress" ||
                                                                          _elements[element].status ==
                                                                              "Critical")
                                                                  ? Container(
                                                                      height:
                                                                          18,
                                                                      width: 1,
                                                                      color: customcolor
                                                                          .greyborder,
                                                                    )
                                                                  : SizedBox(),
                                                              _elements[element]
                                                                          .TAT_remark ==
                                                                      null||_elements[element].TAT_remark.isEmpty
                                                                  ? SizedBox()
                                                                  : GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        showRemarkDialog(
                                                                            context,
                                                                            _elements[element].TAT_remark);
                                                                      },
                                                                      child:
                                                                          Text(
                                                                        'View Remark',
                                                                        style: AppFonts
                                                                            .headerStyle(
                                                                          fontSize:
                                                                              ResponsiveFlutter.of(context).fontSize(1.8),
                                                                          color:
                                                                              customcolor.tabblue,
                                                                          fontWeight:
                                                                              FontWeight.normal,
                                                                        ),
                                                                      ),
                                                                    ),
                                                            ],
                                                          ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    bottom: BorderSide(
                                                        color:
                                                            customcolor.greybg),
                                                  ),
                                                ),
                                              ),
                                              _elements[element].status ==
                                                      "Not Acknowleged"
                                                  ? Container()
                                                  : Container(
                                                      decoration: BoxDecoration(
                                                        color:
                                                            customcolor.green,
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  15),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  15),
                                                        ),
                                                      ),
                                                      // height: 40,
                                                      child: SwipeActionCell(
                                                        fullSwipeFactor: 0.1,
                                                        // firstActionWillCoverAllSpaceOnDeleting: false,
                                                        // backgroundColor:customcolor.green,
                                                        //  icon: Icon(Icons.check, color: Colors.green),
                                                        selectedForegroundColor:
                                                            customcolor.green,
                                                        backgroundColor:
                                                            customcolor.greybg,
                                                        key: ObjectKey(0),
                                                        leadingActions: [
                                                          SwipeAction(
                                                            icon: Icon(
                                                              Icons.check,
                                                              color: customcolor
                                                                  .green,
                                                            ),
                                                            performsFirstActionWithFullSwipe:
                                                                true,
                                                            onTap: (CompletionHandler
                                                                handler) async {
                                                              // Handle swipe action
                                                              setState(() {
                                                                print(
                                                                    "Resolvef");
                                                                getoperationalresolvedApi(
                                                                    _elements[
                                                                            element]
                                                                        .id
                                                                        .toString());
//.then((value) {
//                         if(value!=null)
//                         {
                                                                handler(true);
//        ShowDialogs().confirmationdone(context,"Complaint Resolved \nSuccessfully");

//     Timer(
//             Duration(seconds: 1),
//                 () =>  Navigator.pop(context));
//                         }
//                       });
                                                              });
                                                            },
                                                            color: customcolor
                                                                .green,
                                                          ),
                                                        ],
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              bottomLeft: Radius
                                                                  .circular(15),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          15),
                                                            ),
                                                          ),
                                                          height: 40,
                                                          child: Row(
                                                            children: [
                                                              Container(
                                                                width: SizeConfig
                                                                        .safeBlockHorizontal *
                                                                    15,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color:
                                                                      customcolor
                                                                          .green,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .only(
                                                                    bottomLeft:
                                                                        Radius.circular(
                                                                            10),
                                                                  ),
                                                                ),
                                                                height: 40,
                                                                child: Icon(
                                                                  Icons
                                                                      .arrow_forward,
                                                                  color:
                                                                      customcolor
                                                                          .white,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: SizeConfig
                                                                        .blockSizeHorizontal *
                                                                    5,
                                                              ),
                                                              Center(
                                                                child: Text(
                                                                  'Swipe if complaint is resolved >>',
                                                                  style: AppFonts.headerStyle(
                                                                      fontSize: ResponsiveFlutter.of(
                                                                              context)
                                                                          .fontSize(
                                                                              2),
                                                                      color: customcolor
                                                                          .greytext,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                            ],
                                          )
                                        :
                                        //change 22feb
                                        //dependenttab
                                        tab == "2"
                                            ? Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      border: Border(
                                                        bottom: BorderSide(
                                                            color: customcolor
                                                                .greybg),
                                                      ),
                                                    ),
                                                  ),
                                                  _elements[element].status ==
                                                          "Not Acknowleged"
                                                      ? Container()
                                                      : Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: customcolor
                                                                .green,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              bottomLeft: Radius
                                                                  .circular(15),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          15),
                                                            ),
                                                          ),
                                                          // height: 40,
                                                          child:
                                                              SwipeActionCell(
                                                            fullSwipeFactor:
                                                                0.1,
                                                            // firstActionWillCoverAllSpaceOnDeleting: false,
                                                            // backgroundColor:customcolor.green,
                                                            //  icon: Icon(Icons.check, color: Colors.green),
                                                            selectedForegroundColor:
                                                                customcolor
                                                                    .green,
                                                            backgroundColor:
                                                                customcolor
                                                                    .greybg,
                                                            key: ObjectKey(0),
                                                            leadingActions: [
                                                              SwipeAction(
                                                                icon: Icon(
                                                                  Icons.check,
                                                                  color:
                                                                      customcolor
                                                                          .green,
                                                                ),
                                                                performsFirstActionWithFullSwipe:
                                                                    true,
                                                                onTap: (CompletionHandler
                                                                    handler) async {
                                                                  // Handle swipe action
                                                                  setState(() {
                                                                    print(
                                                                        "Resolvef");
                                                                    getoperationalresolvedApi(
                                                                        _elements[element]
                                                                            .id
                                                                            .toString());
//.then((value) {
//                         if(value!=null)
//                         {
                                                                    handler(
                                                                        true);
//        ShowDialogs().confirmationdone(context,"Complaint Resolved \nSuccessfully");

//     Timer(
//             Duration(seconds: 1),
//                 () =>  Navigator.pop(context));
//                         }
//                       });
                                                                  });
                                                                },
                                                                color:
                                                                    customcolor
                                                                        .green,
                                                              ),
                                                            ],
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .only(
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          15),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          15),
                                                                ),
                                                              ),
                                                              height: 40,
                                                              child: Row(
                                                                children: [
                                                                  Container(
                                                                    width: SizeConfig
                                                                            .safeBlockHorizontal *
                                                                        15,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: customcolor
                                                                          .green,
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .only(
                                                                        bottomLeft:
                                                                            Radius.circular(10),
                                                                      ),
                                                                    ),
                                                                    height: 40,
                                                                    child: Icon(
                                                                      Icons
                                                                          .arrow_forward,
                                                                      color: customcolor
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: SizeConfig
                                                                            .blockSizeHorizontal *
                                                                        5,
                                                                  ),
                                                                  Center(
                                                                    child: Text(
                                                                      'Swipe if complaint is resolved >>',
                                                                      style: AppFonts.headerStyle(
                                                                          fontSize: ResponsiveFlutter.of(context).fontSize(
                                                                              2),
                                                                          color: customcolor
                                                                              .greytext,
                                                                          fontWeight:
                                                                              FontWeight.normal),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                ],
                                              )
                                            : Container()
                                    : SizedBox(
                                        height: 0,
                                      )

//
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
//
                  ],
                );
              },
            ),
          )
        : norecordwidget();
  }

  Widget timebox() {
    duration = "";
    return new TimePickerSpinner(
      is24HourMode: true,
      normalTextStyle: TextStyle(fontSize: 20, color: Colors.grey),
      highlightedTextStyle: TextStyle(fontSize: 20, color: Colors.black),
      spacing: 30,
      itemHeight: 60,
      //  minValue: DateTime.now(),
      isForce2Digits: true,
      //  isForce12Hours: false,
      //       minValue: DateTime.now(),
      //       maxValue: DateTime(DateTime.now().year, 12, 31, 23, 59),
      onTimeChange: (time) {
        setState(() {
          // _dateTime = time;
          print("time");
          print(time.hour);
          print(time.minute);
          selectedtime = time;
        });
      },
    );
  }

  addtimer(BuildContext context, String comingfrom, String id) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      elevation: 5.0,
      barrierColor: Colors.black.withOpacity(0.7),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      context: context,
      builder: (builder) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStateDialgoue) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom / 2),
              child: SingleChildScrollView(
                child: Container(
                  height: SizeConfig.blockSizeVertical * 60,
                  color: Colors.white,
                  margin:
                      EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 2),
                  padding: EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 5),
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
                      SizedBox(height: 15),
                      Text(
                        "Select Turn Around Date",
                        style: AppFonts.headerStyle(
                          fontSize: ResponsiveFlutter.of(context).fontSize(2.1),
                          color: customcolor.black,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: selectedDateTime ?? DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2050),
                          );

                          if (pickedDate != null) {
                            var datefrom =
                                DateFormat('dd-MM-yyyy').format(pickedDate);
                            datetatcontroller.text = datefrom;
                            print(datetatcontroller.text);
                            setState(() => selectedDateTime = pickedDate);
                          }
                        },
                        child: FormTextField(
                          isEnable: false,
                          textcontroller: datetatcontroller,
                          placeholderStr: "Date of TAT",
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
                      SizedBox(height: 10),
                      TextFormField(
                        controller: tat_remark,
                        maxLines: 2,
                        decoration: customInputDecoration('Remarks'),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Select Turn Around Time",
                        style: AppFonts.headerStyle(
                          fontSize: ResponsiveFlutter.of(context).fontSize(2.1),
                          color: customcolor.black,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      timebox(),
                      SizedBox(height: 5),
                      GestureDetector(
                        onTap: () {
                          var todaydate =
                              DateFormat('dd-MM-yyyy').format(DateTime.now());

                          if (datetatcontroller.text.contains(todaydate)) {
                            if (selectedtime.isAfter(DateTime.now())) {
                              setState(() {
                                duration =
                                    "${selectedtime.hour}:${selectedtime.minute}";
                              });
                            } else {
                              ShowDialogs.showToast(
                                  "Please Select Correct Time");
                            }
                          } else {
                            setState(() {
                              duration =
                                  "${selectedtime.hour}:${selectedtime.minute}";
                            });
                          }

                          if (duration != "") {
                            if (comingfrom == "add") {
                              if (datetatcontroller.text.isEmpty) {
                                ShowDialogs.showToast("Please Select Date");
                              } else if (datetatcontroller.text
                                  .contains(todaydate)) {
                                if (selectedtime.isAfter(DateTime.now())) {
                                  setState(() {
                                    duration =
                                        "${selectedtime.hour}:${selectedtime.minute}";
                                    Navigator.pop(context);
                                    gettatApi(id, duration);
                                  });
                                }
                              } else {
                                Navigator.pop(context);
                                gettatApi(id, duration);
                              }
                            } else if (comingfrom == "edit") {
                              if (datetatcontroller.text.isEmpty) {
                                ShowDialogs.showToast("Please Select Date");
                              } else if (datetatcontroller.text
                                  .contains(todaydate)) {
                                if (selectedtime.isAfter(DateTime.now())) {
                                  setState(() {
                                    duration =
                                        "${selectedtime.hour}:${selectedtime.minute}";
                                    Navigator.pop(context);
                                    operationalupdatetatApi(id, duration);
                                  });
                                }
                              } else {
                                Navigator.pop(context);
                                operationalupdatetatApi(id, duration);
                              }
                            }
                          }
                        },
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: isOperationUpadteLoaded
                              ? CircularProgressIndicator(
                                  color: customcolor.blue,
                                )
                              : Image.asset(
                                  'assets/images/next.png',
                                  width: 50,
                                  height: 50,
                                ),
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
    );
  }

  //clientwisedashboad
  clientdashboardApi() async {
    var status1 = await ConnectionDetector.checkInternetConnection();

    if (status1) {
      setState(() {
        GlobalLists.iscomplaintLoadin.value = true;
      });
      var map = new Map<String, dynamic>();

      var supervisorid = await SPManager().getsupervisorid();
      print(supervisorid);
      var clientid = await SPManager().getclientid();

      map['clientid'] = clientid;

      print("UNIT");

      APIManager().apiRequest(context, API.clientsitedependentdashboard,
          (response) async {
        clientdash.ClientsiteDashboardResponse resp = response;
        print("UNIT");
        print(resp.status.toString());
        print('called API ${resp}');
        if (resp.status == 1) {
          setState(() {
            GlobalLists.complaintclientlist = resp.data;
          });
          // Navigator.of(this.context).pop();
          setState(() {
            GlobalLists.iscomplaintLoadin.value = false;
          });
          //  ShowDialogs.showToast(resp.msg);
        } else {
          // ShowDialogs.showToast(resp.msg);
          // Navigator.of(this.context).pop();
          setState(() {
            GlobalLists.iscomplaintLoadin.value = false;
          });
        }
      }, (error) {
        print('ERR msg is $error');
        Navigator.of(this.context).pop();
      }, false, "", jsonval: map);
    } else {
      ShowDialogs.showToast("Please check internet connection");
    }
  }

  // Widget optionsDropdown(String id, dynamic element) {
  //   //building index 1, plant 2,stocks 3
  //   return Align(
  //     alignment: Alignment.topRight,
  //     child: Container(
  //       //  padding: EdgeInsets.only(top: 5, left: 80, right: 1),
  //       height: 115,
  //       width: 130,
  //       decoration: BoxDecoration(
  //           color: Colors.transparent, borderRadius: BorderRadius.circular(10)),
  //       child: Card(
  //         elevation: 5,
  //         child: Padding(
  //             padding: EdgeInsets.only(top: 5, left: 10, right: 5),
  //             child: ListView.builder(
  //                 itemCount: options.length,
  //                 //  physics: ClampingScrollPhysics(),
  //                 shrinkWrap: true,
  //                 itemBuilder: (BuildContext context, int index) {
  //                   return Column(
  //                     mainAxisAlignment: MainAxisAlignment.start,
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       GestureDetector(
  //                         onTap: () {
  //                           setState(() {
  //                             statuscontroller.text = options[index];

  //                             element['isoptionopen'] = false;
  //                             if (statuscontroller.text == "Dependent") {
  //                               getdependentApi(id);
  //                             } else if (statuscontroller.text == "Resolved") {
  //                               getresolvedApi(id);
  //                             } else if (statuscontroller.text == "TAT") {
  //                               confirmationtat(context, id);
  //                             }
  //                           });
  //                         },
  //                         child: Container(
  //                           color: Colors.white,
  //                           width: SizeConfig.blockSizeHorizontal * 100,
  //                           child: Text(
  //                             options[index],
  //                             textAlign: TextAlign.left,
  //                             style: AppFonts.headerStyle(
  //                                 fontSize: 14,
  //                                 color: customcolor.black,
  //                                 fontWeight: FontWeight.normal),
  //                           ),
  //                         ),
  //                       ),
  //                       SizedBox(
  //                         height: 5,
  //                       ),
  //                       Divider(
  //                         color: customcolor.greytext,
  //                       )
  //                     ],
  //                   );
  //                 })),
  //       ),
  //     ),
  //   );
  // }

  addcomplaint(
    BuildContext context,
  ) {
    //add Complaints
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
              height: complainttypecontroller.text == "Cleaning"
                  ? masterareacontroller.text == ""
                      ? SizeConfig.blockSizeVertical * 80 +
                          MediaQuery.of(context).viewInsets.bottom
                      : SizeConfig.blockSizeVertical * 90 +
                          MediaQuery.of(context).viewInsets.bottom
                  : (masterareacontroller.text != "" && result.length >= 1)
                      ? SizeConfig.blockSizeVertical * 98 +
                          MediaQuery.of(context).viewInsets.bottom
                      : (result.length >= 1)
                          ? SizeConfig.blockSizeVertical * 80 +
                              MediaQuery.of(context).viewInsets.bottom
                          : SizeConfig.blockSizeVertical * 56 +
                              MediaQuery.of(context).viewInsets.bottom,
              color: Colors.white,
              margin: EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 2),
              padding: EdgeInsets.all(5),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                        height: 20,
                      ),
                      Text(
                        "Add Complaints",
                        textAlign: TextAlign.left,
                        style: AppFonts.headerStyle(
                            fontSize: 22,
                            color: customcolor.black,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setStateDialgoue(() {
                                isexpanded = !isexpanded;
                                isexpandedmasterblock = false;
                                isexpandedcomplaint = false;
                                isexpandedmasterarea = false;
                              });
                            },
                            child: FormTextField(
                              isEnable: false,
                              textcontroller: clientcontroller,
                              placeholderStr: "Select Site",
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
                        ],
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
                                  setStateDialgoue(() {
                                    isexpandedcomplaint = !isexpandedcomplaint;
                                    isexpandedmasterblock = false;
                                    isexpanded = false;
                                    isexpandedmasterarea = false;
                                  });
                                },
                                child: FormTextField(
                                  isEnable: false,
                                  textcontroller: complainttypecontroller,
                                  placeholderStr: "Select Complaint Type",
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
                              Stack(
                                children: [
                                  Column(
                                    children: [
                                      complainttypecontroller.text == "Cleaning"
                                          ? Column(
                                              children: [
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    setStateDialgoue(() {
                                                      isexpandedmasterarea =
                                                          !isexpandedmasterarea;
                                                      isexpandedmasterblock =
                                                          false;
                                                      isexpandedcomplaint =
                                                          false;
                                                      isexpanded = false;
                                                    });
                                                  },
                                                  child: FormTextField(
                                                    isEnable: false,
                                                    textcontroller:
                                                        masterareacontroller,
                                                    placeholderStr:
                                                        "Master Area",
                                                    textInputType:
                                                        TextInputType.text,
                                                    onchange: (val) {},
                                                    suffixWidget: Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 20),
                                                      child: Image.asset(
                                                        "assets/images/dropdown.png",
                                                        width: 10,
                                                        height: 10,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Container(),
                                      Stack(
                                        children: [
                                          Column(
                                            children: [
                                              masterareacontroller.text != ""
                                                  ? Column(
                                                      children: [
                                                        SizedBox(
                                                          height: 20,
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {
                                                            setStateDialgoue(
                                                                () {
                                                              isexpandedmasterblock =
                                                                  !isexpandedmasterblock;
                                                              isexpanded =
                                                                  false;
                                                              isexpandedcomplaint =
                                                                  false;
                                                              isexpandedmasterarea =
                                                                  false;
                                                            });
                                                          },
                                                          child: FormTextField(
                                                            isEnable: false,
                                                            textcontroller:
                                                                masterblockcontroller,
                                                            placeholderStr:
                                                                "Master Block",
                                                            textInputType:
                                                                TextInputType
                                                                    .text,
                                                            onchange: (val) {},
                                                            suffixWidget:
                                                                Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      right:
                                                                          20),
                                                              child:
                                                                  Image.asset(
                                                                "assets/images/dropdown.png",
                                                                width: 10,
                                                                height: 10,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  : Container(),
                                              Stack(
                                                children: [
                                                  Column(
                                                    children: [
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      FormTextField(
                                                        textcontroller:
                                                            complaintcontroller,
                                                        placeholderStr:
                                                            "Write Complaint",
                                                        textInputType:
                                                            TextInputType.text,
                                                        onchange: (val) {},
                                                      ),
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          _showSelectionDialog(
                                                              context,
                                                              1,
                                                              setStateDialgoue);
                                                        },
                                                        child: FormTextField(
                                                          isEnable: false,
                                                          textcontroller:
                                                              imagecontroller,
                                                          placeholderStr:
                                                              "Add Image",
                                                          //(Upto 2 images)
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
                                                          textInputType:
                                                              TextInputType
                                                                  .text,
                                                          onchange: (val) {},
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  isexpandedmasterblock
                                                      ? masterblockDropdown(
                                                          setStateDialgoue)
                                                      : Container(),
                                                ],
                                              ),
                                            ],
                                          ),
                                          isexpandedmasterarea
                                              ? masterarerDropdown(
                                                  setStateDialgoue)
                                              : Container(),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  ),
                                  isexpandedcomplaint
                                      ? complaintDropdown(setStateDialgoue)
                                      : Container()
                                ],
                              ),

                              result.length == 0
                                  ? Container()
                                  : Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5, top: 3, bottom: 2),
                                      child: Wrap(
                                        alignment: WrapAlignment.start,
                                        runAlignment: WrapAlignment.start,
                                        crossAxisAlignment:
                                            WrapCrossAlignment.start,
                                        spacing: 6.0,
                                        children: List<Widget>.generate(
                                          result.length,
                                          (int index) {
                                            return GestureDetector(
                                              onTap: () async {
                                                print("openfile");
                                                showfileimage(
                                                    result[index]
                                                        .split('/')
                                                        .last,
                                                    result[index]);
                                                // Navigator.push(
                                                //     context,
                                                //     MaterialPageRoute(
                                                //         builder: (BuildContext context) => OpenfilePage(
                                                //               videoUrl: widget.taskupdatedlist.filelist[index].fileLink,
                                                //             )));

                                                // pdfAsset(uploadpath[index]).then((file) {
                                                //   OpenFile.open(file.path);
                                                // });
                                                // await OpenFile.open(uploadpath[index]);
                                              },
                                              child: Chip(
                                                side: BorderSide(
                                                    style: BorderStyle.solid,
                                                    color: customcolor.blue),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                4))),
                                                labelPadding:
                                                    EdgeInsets.all(2.0),
                                                // avatar: CircleAvatar(
                                                //     backgroundColor: Colors.transparent,
                                                //     child: Icon(
                                                //       Icons.contact_phone_rounded,
                                                //       size: 20,
                                                //       color: Colors.black,
                                                //     )),
                                                label: Text(
                                                  result[index].split('/').last,
                                                  style: TextStyle(
                                                      color: customcolor.blue,
                                                      fontSize: 12),
                                                ),
                                                onDeleted: () {
                                                  setStateDialgoue(() {
                                                    result.removeAt(index);
                                                    List<String> filename = [];
                                                    imagecontroller.text = "";
                                                    for (int i = 0;
                                                        i < result.length;
                                                        i++) {
                                                      filename.add(result[i]
                                                          .split('/')
                                                          .last);
                                                    }
                                                    print(filename);
                                                    String s =
                                                        filename.join(', ');
                                                    print(s);

                                                    imagecontroller.text = s;
                                                  });
                                                },
                                                deleteIcon: Icon(
                                                  Icons.close,
                                                  color: customcolor.blue,
                                                  size: 20,
                                                ),

                                                backgroundColor: customcolor
                                                    .blue
                                                    .withOpacity(0.1),
                                                // elevation: 6.0,
                                                // shadowColor: Colors.grey[60],
                                                // padding: EdgeInsets.all(6.0),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                              SizedBox(
                                height: 10,
                              ),
                              // chipvalue()
                            ],
                          ),
                          isexpanded
                              ? clientDropdown(setStateDialgoue)
                              : Container(),
                        ],
                      ),
                      ValueListenableBuilder<bool>(
                        valueListenable: GlobalLists.isAddcomplaintLoader,
                        builder: (context, loading, _) {
                          return Align(
                            alignment: Alignment.bottomRight,
                            child: loading
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        right: 20, bottom: 10),
                                    child: CircularProgressIndicator(
                                        color: customcolor.blue),
                                  )
                                : GestureDetector(
                                    onTap: () async {
                                      if (clientcontroller.text.isEmpty) {
                                        ShowDialogs.showToast(
                                            "Please Select Site");
                                      } else if (complainttypecontroller
                                          .text.isEmpty) {
                                        ShowDialogs.showToast(
                                            "Please Select Complaint Type");
                                      } else if (complaintcontroller
                                          .text.isEmpty) {
                                        ShowDialogs.showToast(
                                            "Please Enter comment");
                                      } else {
                                        if (complainttypecontroller.text ==
                                            "Cleaning") {
                                          if (masterareacontroller
                                              .text.isEmpty) {
                                            ShowDialogs.showToast(
                                                "Please Select Master Area");
                                          } else if (masterblockcontroller
                                              .text.isEmpty) {
                                            ShowDialogs.showToast(
                                                "Please Select Master Block");
                                          } else {
                                            GlobalLists.isAddcomplaintLoader
                                                .value = true;
                                            await addcomplaintApi();
                                            GlobalLists.isAddcomplaintLoader
                                                .value = false;
                                          }
                                        } else {
                                          GlobalLists.isAddcomplaintLoader
                                              .value = true;
                                          await addcomplaintApi();
                                          GlobalLists.isAddcomplaintLoader
                                              .value = false;
                                        }
                                      }
                                    },
                                    child: Image.asset(
                                      'assets/images/next.png',
                                      width: 50,
                                      height: 50,
                                    ),
                                  ),
                          );
                        },
                      ),

                      // GestureDetector(
                      //   onTap: () async {
                      //     if (clientcontroller.text.isEmpty) {
                      //       ShowDialogs.showToast("Please Select Site");
                      //     } else if (complainttypecontroller.text.isEmpty) {
                      //       ShowDialogs.showToast(
                      //           "Please Select Complaint Type");
                      //     } else if (complaintcontroller.text.isEmpty) {
                      //       ShowDialogs.showToast("Please Enter comment");
                      //     }

                      //     else {
                      //       if (complainttypecontroller.text == "Cleaning") {
                      //         if (masterareacontroller.text.isEmpty) {
                      //           ShowDialogs.showToast(
                      //               "Please Select Master Area");
                      //         } else if (masterblockcontroller.text.isEmpty) {
                      //           ShowDialogs.showToast(
                      //               "Please Select Master Block");
                      //         } else {
                      //           addcomplaintApi();
                      //           //scheduleReminderNotification();
                      //         }
                      //       } else {
                      //         addcomplaintApi();
                      //         //scheduleReminderNotification();
                      //       }
                      //     }

                      //   },
                      //   child: Align(
                      //     alignment: Alignment.bottomRight,
                      //     child:GlobalLists.isAddcomplaintLoader.value?CircularProgressIndicator(color: customcolor.blue,): Image.asset(
                      //       'assets/images/next.png',
                      //       width: 50,
                      //       height: 50,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),
            );
          });
        });
  }

  /*Future<void> scheduleReminderNotification() async {
    var androidDetails = const AndroidNotificationDetails(
      'reminder_channel_id',
      'Complaint Reminder',
      '',
      importance: Importance.max,
      priority: Priority.high,
    );

    var notificationDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Reminder',
      'Please check the status of your complaint.',
      tz.TZDateTime.now(tz.local).add(const Duration(seconds: 10)),
      notificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // ensures one-time
    );
  }*/

  _displayPickImageDialog(
      BuildContext? context, OnPickImageCallback onPick) async {
    onPick(null, null, null);
  }

  Future<void> _showSelectionDialog(
      BuildContext context, int imageno, setStateDialgoue) {
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
                        if (result.length >= 2) {
                          ShowDialogs.showToast("You have upload 2 images");
                        } else {
                          _openFileExplorer(imageno, setStateDialgoue);
                        }
                      },
                    ),
                    Padding(padding: EdgeInsets.all(8.0)),
                    GestureDetector(
                      child: Text("Camera"),
                      onTap: () async {
                        Navigator.pop(context);
                        if (result.length >= 2) {
                          ShowDialogs.showToast("You have upload 2 images");
                        } else {
                          _onImageButtonPressed(
                              ImageSource.camera, imageno, setStateDialgoue,
                              context: context);
                        }
                      },
                    ),
                  ],
                ),
              ));
        });
  }

  // void _onImageButtonPressed(
  //     ImageSource source, int imageno, StateSetter setStateDialgoue,
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
  //     setStateDialgoue(() {
  //       print(pickedFile);
  //       _imageFile = File(pickedFile!.path);
  //       print(_imageFile!.path);
  //       _fileName = _imageFile!.path.split('/').last;
  //       result.add(_imageFile!.path);
  //       List<String> filename = [];
  //       imagecontroller.text = "";
  //       for (int i = 0; i < result.length; i++) {
  //         filename.add(result[i].split('/').last);
  //       }
  //       print(filename);
  //       String s = filename.join(', ');
  //       print(s);
  //       imagecontroller.text = s;
  //     });
  //   } catch (e) {
  //     setStateDialgoue(() {
  //       _pickImageError = e;
  //       print("Ruchita $e");
  //     });
  //   }
  // }
  Future<bool> requestPermission(Permission permission) async {
    PermissionStatus status = await permission.request();
    return status.isGranted;
  }

  void _onImageButtonPressed(
    ImageSource source,
    int imageno,
    StateSetter setStateDialgoue, {
    BuildContext? context,
  }) async {
    try {
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
            flushbarPosition: FlushbarPosition.TOP, // <-- Top position
          ).show(this.context);

          return;
        }

        //  Use camera package instead of ImagePicker
        Navigator.push(
          context!,
          MaterialPageRoute(
            builder: (context) => CameraCaptureScreen(
              onImageCaptured: (String imagePath) {
                setStateDialgoue(() {
                  _imageFile = File(imagePath);
                  _fileName = _imageFile!.path.split('/').last;

                  result.add(_imageFile!.path);

                  List<String> filename = [];
                  imagecontroller.text = "";
                  for (int i = 0; i < result.length; i++) {
                    filename.add(result[i].split('/').last);
                  }
                  String s = filename.join(', ');
                  imagecontroller.text = s;
                });
              },
            ),
          ),
        );

        return; // stop here after opening camera
      }
    } catch (e) {
      setStateDialgoue(() {
        _pickImageError = e;
        print("Camera error: $e");
      });
    }
  }

Future<bool> _requestStoragePermission() async {
  if (await Permission.storage.isGranted) {
    return true;
  }

  final status = await Permission.storage.request();
  return status.isGranted;
}

  // void _openFileExplorer(int imageno, StateSetter setStateDialgoue) async {
  //   setState(() => _loadingPath = true);
  //   try {
  //     _directoryPath = null;
  //     _paths = (await FilePicker.platform.pickFiles(
  //       type: _pickingType,
  //       allowMultiple: true,

  //       allowedExtensions: [
  //         'jpg',
  //         'jpeg',
  //         'png',
  //       ],
  //       // allowedExtensions: (_extension?.isNotEmpty ?? false)
  //       //     ? _extension?.replaceAll(' ', '')?.split(',')
  //       //     : null,
  //     ))
  //         ?.files;
  //   } on PlatformException catch (e) {
  //     print("Unsupported operation" + e.toString());
  //   } catch (ex) {
  //     print(ex);
  //   }
  //   if (!mounted) return;
  //   setStateDialgoue(() {
  //     _loadingPath = false;
  //     _fileName = _paths != null
  //         ? _paths!.map((e) => e.name).toString()
  //         : 'Select Document';
  //     print("File name is${_fileName}");
      
  //     if (_paths!.length > 2) {
  //       ShowDialogs.showToast("You can upload upto 2 images");
  //     } else {
  //       for (int i = 0; i < _paths!.length; i++) {
  //         result.add(_paths![i].path!);
  //       }
  //       List<String> filename = [];
  //       imagecontroller.text = "";
  //       for (int i = 0; i < result.length; i++) {
  //         filename.add(result[i].split('/').last);
  //       }
  //       print(filename);
  //       String s = filename.join(', ');
  //       print(s);
  //       imagecontroller.text = s;
  //     }
  //   });
  // }
// void _openFileExplorer(int imageno, StateSetter setStateDialgoue) async {
//   final hasPermission = await requestGalleryPermission();

//   if (!hasPermission) {
//     ShowDialogs.showToast("Gallery permission denied");
//     openAppSettings(); // optional
//     return;
//   }

//   try {
//     final result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowMultiple: true,
//       allowedExtensions: ['jpg', 'jpeg', 'png'],
//     );

//     if (result == null || result.files.isEmpty) return;

//     setStateDialgoue(() {
//       if (result.files.length > 2) {
//         ShowDialogs.showToast("You can upload upto 2 images");
//         return;
//       }

//       imagecontroller.text =
//           result.files.map((e) => e.name).join(', ');
//     });

//   } on PlatformException catch (e) {
//     debugPrint("FilePicker error: $e");
//   }
// }
// void _openFileExplorer(int imageno, StateSetter setStateDialgoue) async {
//   final hasPermission = await requestGalleryPermission();

//   if (!hasPermission) {
//     ShowDialogs.showToast("Please allow gallery permission");
//     openAppSettings();
//     return;
//   }

//   try {
//     final result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowMultiple: true,
//       allowedExtensions: ['jpg', 'jpeg', 'png'],
//     );

//     if (result == null || result.files.isEmpty) return;

//     setStateDialgoue(() {
//       if (result.files.length > 2) {
//         ShowDialogs.showToast("You can upload upto 2 images");
//         return;
//       }

//       imagecontroller.text =
//           result.files.map((e) => e.name).join(', ');
//     });

//   } on PlatformException catch (e) {
//     debugPrint("FilePicker error: $e");
//   }
// }
void _openFileExplorer(int imageno, StateSetter setStateDialgoue) async {
  final ImagePicker picker = ImagePicker();

  try {
    final List<XFile> images = await picker.pickMultiImage();

    // User cancelled
    if (images.isEmpty) return;

    if (images.length > 2) {
      ShowDialogs.showToast("You can upload upto 2 images");
      return;
    }

    setStateDialgoue(() {
      // Clear previous selection
      result.clear();

      for (final image in images) {
        result.add(image.path);
      }

      imagecontroller.text =
          images.map((e) => e.name).join(', ');
    });

  } catch (e) {
    debugPrint("ImagePicker error: $e");
  }
}

Future<bool> requestGalleryPermission() async {
  if (!Platform.isAndroid) return true;

  final androidInfo = await DeviceInfoPlugin().androidInfo;

  if (androidInfo.version.sdkInt! >= 33) {
    // Android 13+
    final photos = await Permission.photos.request();
    return photos.isGranted;
  } else {
    // Android 12 and below
    final storage = await Permission.storage.request();
    return storage.isGranted;
  }
}



//add complaint Api In Offline
// bool GlobalLists.isAddcomplaintLoader.value=false;
  addcomplaintApi() async {
    var status = await ConnectionDetector.checkInternetConnection();
    var currenttime = DateFormat('hh:mm').format(DateTime.now());

    // Create the payload map
    final payload = {
      'complainant_name': complainttypecontroller.text,
      'complaint_type': complainttype,
      'status': 'Pending',
      'client': attendanceclientid,
      'site': attendancesiteid,
      'comment': complaintcontroller.text,
      'TAT_duration': currenttime,
      'master_area': areaid,
      'master_block': blockid,
    };

    if (status) {
      // ShowDialogs.showLoadingDialog(context, _keyLoader);
      setState(() {
        GlobalLists.isAddcomplaintLoader.value = true;
      });
      var request = http.MultipartRequest(
        "POST",
        Uri.parse(APIManager.clientaddcomplaint),
      );

      request.fields.addAll(payload);

      if (result.isNotEmpty) {
        for (int i = 0; i < result.length; i++) {
          request.files.add(await http.MultipartFile.fromPath(
            'image${i + 1}',
            result[i],
            contentType: MediaType('application', 'x-tar'),
          ));
        }
      }

      var response = await request.send();
      final respStr = await response.stream.bytesToString();
      var res = json.decode(respStr);

      // Navigator.of(_keyLoader.currentContext!).pop();
      setState(() {
        GlobalLists.isAddcomplaintLoader.value = false;
      });
      if (response.statusCode == 200) {
        Timer(Duration(seconds: 1), () => Navigator.pop(context));
        ShowDialogs()
            .confirmationdone(context, "Complaint Added \nSuccessfully");
        Timer(
          Duration(seconds: 1),
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) =>
                  Complaint(false, "", "", "", "", "", "", "", false),
            ),
          ),
        );
      } else {
        ShowDialogs.showToast(res['msg']);
      }
    } else {
      /// ✅ OFFLINE: Save payload + image paths
      await DBHelper.insertOfflineRequest(
        '${Global.baseUrl}/api/ticketmanagement/Add_TicketManagement',
        payload,
        imagePaths: result.cast<String>(),
        isMultipart: true,
      );

      ShowDialogs.showToast("Saved offline. Will sync when connected.");
    }
  }

  Widget clientDropdown(StateSetter setStateDialgoue) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Card(
        elevation: 5,
        child: Padding(
            padding: EdgeInsets.only(left: 10, right: 10, top: 10),
            child: ListView.builder(
                itemCount: GlobalLists.complaintclientlist.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setStateDialgoue(() {
                            clientcontroller.text = GlobalLists
                                .complaintclientlist[index].clientName;

                            isexpanded = false;

                            attendanceclientid = GlobalLists
                                .complaintclientlist[index].clientId
                                .toString();
                            attendancesiteid = GlobalLists
                                .complaintclientlist[index].siteId
                                .toString();

                            //20feb
                            siteidconfig = GlobalLists
                                .complaintclientlist[index].id
                                .toString();
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 3, bottom: 2),
                          child: Container(
                            color: Colors.white,
                            width: SizeConfig.blockSizeHorizontal * 100,
                            child: Text(
                              GlobalLists.complaintclientlist[index].clientName,
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

  //master area
  Widget masterarerDropdown(StateSetter setStateDialgoue) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Card(
        elevation: 5,
        child: Padding(
            padding: EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
            child: ListView.builder(
                itemCount: GlobalLists.masterarealist.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setStateDialgoue(() {
                            masterareacontroller.text =
                                GlobalLists.masterarealist[index].areaName;
                            areaid = GlobalLists.masterarealist[index].areaId
                                .toString();
                            isexpandedmasterarea = false;
                            masterblockcontroller.text = "";
                            blockid = "";
                            masterblockareaApi();
                            // isexpandedcomplaint=true;
                          });
                        },
                        child: Container(
                          color: Colors.white,
                          width: SizeConfig.blockSizeHorizontal * 100,
                          child: Text(
                            GlobalLists.masterarealist[index].areaName,
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

//master blcok
  Widget masterblockDropdown(StateSetter setStateDialgoue) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Card(
        elevation: 5,
        child: Padding(
            padding: EdgeInsets.only(left: 10, right: 10, bottom: 20, top: 10),
            child: ListView.builder(
                itemCount: GlobalLists.masterblocklist.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setStateDialgoue(() {
                            masterblockcontroller.text =
                                GlobalLists.masterblocklist[index].blockName;
                            blockid = GlobalLists
                                .masterblocklist[index].blockObj
                                .toString();
                            isexpandedmasterblock = false;
                          });
                        },
                        child: Container(
                          color: Colors.white,
                          width: SizeConfig.blockSizeHorizontal * 100,
                          child: Text(
                            GlobalLists.masterblocklist[index].blockName,
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

  Widget complaintDropdown(StateSetter setStateDialgoue) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Card(
        elevation: 5,
        child: Padding(
            padding: EdgeInsets.only(left: 10, right: 10, bottom: 20, top: 10),
            child: Scrollbar(
              thumbVisibility: true,
              child: ListView.builder(
                  itemCount: GlobalLists.clientticketlist.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setStateDialgoue(() {
                              complainttypecontroller.text =
                                  GlobalLists.clientticketlist[index].name;

                              //20feb
                              //here there was siteconfig
                              complainttype = GlobalLists
                                  .clientticketlist[index].id
                                  .toString();
                              isexpandedcomplaint = false;
                              masterareacontroller.text = "";
                              masterblockcontroller.text = "";
                              areaid = "";
                              blockid = "";

                              if (complainttypecontroller.text == "Cleaning") {
                                masterareaApi();
                              }
                            });
                          },
                          child: Container(
                            color: Colors.white,
                            width: SizeConfig.blockSizeHorizontal * 100,
                            child: Text(
                              GlobalLists.clientticketlist[index].name,
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
                  }),
            )),
      ),
    );
  }

  attendancelist() {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemCount: 8,
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
                  child: Text(
                    "IMax",
                    style: AppFonts.headerStyle(
                        fontSize: ResponsiveFlutter.of(context).fontSize(2),
                        color: customcolor.black,
                        fontWeight: FontWeight.w500),
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
                                "Mobile",
                                style: AppFonts.headerStyle(
                                    fontSize: ResponsiveFlutter.of(context)
                                        .fontSize(1.5),
                                    color: customcolor.greytext,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                "9029393922",
                                style: AppFonts.headerStyle(
                                    fontSize: ResponsiveFlutter.of(context)
                                        .fontSize(1.8),
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
                                "Login Timing",
                                style: AppFonts.headerStyle(
                                    fontSize: ResponsiveFlutter.of(context)
                                        .fontSize(1.5),
                                    color: customcolor.greytext,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                "11.00 - 2.00",
                                style: AppFonts.headerStyle(
                                    fontSize: ResponsiveFlutter.of(context)
                                        .fontSize(1.8),
                                    color: customcolor.black,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                          Container(
                            // color: customcolor.appbarcolor,
                            child: CircularPercentIndicator(
                              radius: 25.0,
                              lineWidth: 5.0,
                              animation: true,
                              percent: 0.7,
                              center: new Text(
                                "70.0%",
                                style: AppFonts.headerStyle(
                                    fontSize: 10,
                                    color: customcolor.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              circularStrokeCap: CircularStrokeCap.round,
                              progressColor: customcolor.blue,
                            ),
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

  showfileimage(String title, String resultvalue) {
    return showDialog(
      context: context,
      builder: (_) {
        print("showimaf");
        print(resultvalue);
        return AlertDialog(
          scrollable: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${title}"),
              GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.close))
            ],
          ),
          content: SingleChildScrollView(
            //MUST TO ADDED

            physics: NeverScrollableScrollPhysics(),
            child: Container(
              height: SizeConfig.blockSizeVertical * 30,
              width: double.maxFinite,
              child: ListView(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                // mainAxisSize: MainAxisSize.min,
                children: [
                  // (resultvalue=="null"||resultvalue==null ||resultvalue=="")?  Container():
                  (resultvalue == null ||
                          resultvalue == "" ||
                          resultvalue == "null")
                      ? Center(
                          child: Padding(
                          padding: EdgeInsets.only(
                              top: SizeConfig.blockSizeVertical * 10),
                          child: Text("No Image Uploaded"),
                        ))
                      : Image.file(
                          File(resultvalue),
                          //width: SizeConfig.blockSizeHorizontal*100,
                          height: SizeConfig.blockSizeVertical * 28,
                          fit: BoxFit.cover,

                          errorBuilder: (BuildContext context, Object exception,
                              StackTrace? stackTrace) {
                            return Icon(
                              Icons.error_outline,
                              size: SizeConfig.blockSizeHorizontal * 10,
                            );
                          },
                        ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  getcomplaintApi() async {
    var status1 = await ConnectionDetector.checkInternetConnection();

    if (status1) {
      setState(() {
        GlobalLists.iscomplaintLoadin.value = true;
      });
      setState(() {
        GlobalLists.resolvedlist = [];
        GlobalLists.pendingcomlist = [];
        GlobalLists.dependentcomlist = [];
      });
      var map = new Map<String, dynamic>();

      var supervisorid = await SPManager().getsupervisorid();
      print(supervisorid);
      // map['supervisor'] ="25ec3932-1b2a-47c0-b3f1-06b47030e913";//supervisorid ;
      //  map['Site_id'] ="1";//GlobalLists.siteid ;
      map['supervisor'] = supervisorid;
      map['Site_id'] = GlobalLists.siteid;
      map['today_date'] = datecontroller.text;
      APIManager().apiRequest(context, API.getcomplaint, (response) async {
        supercomp.GetComplaintResponse resp = response;
        print('called API ${resp}');
        if (resp.status == 1) {
          // Navigator.of(this.context).pop();
          setState(() {
            GlobalLists.iscomplaintLoadin.value = false;
          });
          setState(() {
            GlobalLists.resolvedlist = resp.data[0].resolvedata;
            GlobalLists.pendingcomlist = resp.data[0].pendingdata;
            GlobalLists.dependentcomlist = resp.data[0].dependentdata;
            print("GlobalLists.resolvedlist RUCHTA");

            if (widget.isnotify) {
              if (widget.status == "Pending") {
                for (int i = 0; i < GlobalLists.pendingcomlist.length; i++) {
                  if (GlobalLists.pendingcomlist[i].id.toString() ==
                      widget.initalid) {
                    setState(() {
                      print("supervisor");
                      print(widget.initalid);
                      initialindex = i;
                      print(initialindex);
                    });
                  }
                }
                _scrollToIndex(initialindex);
              } else if (widget.status == "Dependent") {
                for (int i = 0; i < GlobalLists.dependentcomlist.length; i++) {
                  if (GlobalLists.dependentcomlist[i].id.toString() ==
                      widget.initalid) {
                    setState(() {
                      initialindex = i;
                    });
                  }
                }
                _scrollToIndex(initialindex);
              } else if (widget.status == "Resolved") {
                for (int i = 0; i < GlobalLists.resolvedlist.length; i++) {
                  if (GlobalLists.resolvedlist[i].id.toString() ==
                      widget.initalid) {
                    setState(() {
                      print("supervisor");
                      print(widget.initalid);
                      initialindex = i;
                      print(initialindex);
                    });
                  }
                }
                _scrollToIndex(initialindex);
              }
            }

//  resp.pendingdata.forEach((iElement) {

            //   _pendingelements.add({
            //        "id": iElement.id,
            //   "createdAt":iElement.createdAt,
            //   "updatedAt": iElement.updatedAt,
            //   "createdBy": iElement.createdBy,
            //   "updatedBy": iElement.updatedBy,
            //   "isActive": iElement.isActive,
            //   "complainant_name": iElement.complainantName,
            //   "complaint_type": iElement.complaintType,
            //   "subject": iElement.subject,
            //   "client": iElement.client,
            //   "site": iElement.site,
            //   "status": iElement.status,
            //   "date": iElement.date,
            //   "isoptionopen":false,
            //   "TAT_duration":iElement.tatDuration
            //     });

            // });
            //      resp.dependentdata.forEach((iElement) {

            //   _dependentelements.add({
            //        "id": iElement.id,
            //   "createdAt":iElement.createdAt,
            //   "updatedAt": iElement.updatedAt,
            //   "createdBy": iElement.createdBy,
            //   "updatedBy": iElement.updatedBy,
            //   "isActive": iElement.isActive,
            //   "complainant_name": iElement.complainantName,
            //   "complaint_type": iElement.complaintType,
            //   "subject": iElement.subject,
            //   "client": iElement.client,
            //   "site": iElement.site,
            //   "status": iElement.status,
            //   "date": iElement.date,
            //    "isoptionopen":false,
            //    "TAT_duration":iElement.tatDuration
            //     });

            // });

            //  resp.resolvedata.forEach((iElement) {

            //   _resolvedelements.add({
            //        "id": iElement.id,
            //   "createdAt":iElement.createdAt,
            //   "updatedAt": iElement.updatedAt,
            //   "createdBy": iElement.createdBy,
            //   "updatedBy": iElement.updatedBy,
            //   "isActive": iElement.isActive,
            //   "complainant_name": iElement.complainantName,
            //   "complaint_type": iElement.complaintType,
            //   "subject": iElement.subject,
            //   "client": iElement.client,
            //   "site": iElement.site,
            //   "status": iElement.status,
            //   "date": iElement.date,
            //    "isoptionopen":false,
            //    "TAT_duration":iElement.tatDuration
            //     });

            // });
          });
        } else {
          setState(() {
            GlobalLists.iscomplaintLoadin.value = false;
          });
          // Navigator.of(this.context).pop();
        }
      }, (error) {
        print('ERR msg is $error');
        Navigator.of(this.context).pop();
      }, false, "", jsonval: map);
    } else {
      ShowDialogs.showToast("Please check internet connection");
    }
  }

// bool iscomplaintLoadin=false;
  getunitcomplaintApi() async {
    print("RUCHII 31oct");
    var status1 = await ConnectionDetector.checkInternetConnection();

    if (status1) {
      setState(() {
        mainlisttab = [];
      });
      //29OctRUCHI

      setState(() {
        GlobalLists.iscomplaintLoadin.value = true;
      });
      var map = new Map<String, dynamic>();
      var clientid = await SPManager().getclientid();
      print(clientid);
      var supervisorid = await SPManager().getsupervisorid();
      print(supervisorid);
      if (role == GlobalLists.clientrole) {
        map['clientid'] = clientid;
        map['date'] = datecontroller.text;
        //removed at 20march
//  map['supervisor'] =superviFile;
      } else {
        map['supervisor'] =
            supervisorid; //"96305101-e856-40eb-8c9a-cba1a0c0f4cc";//supervisorid ;
        map['date'] = datecontroller.text;
      }

      APIManager().apiRequest(context, API.unitcomplaint, (response) async {
        unitcom.UnitComplaintResponse resp = response;
        print('called API ${resp}');
        if (resp.status == 1) {
          //29OctRUCHI
          // Navigator.of(this.context).pop();
          setState(() {
            GlobalLists.iscomplaintLoadin.value = false;
          });
          setState(() {
            print(resp.data[0].clientName);
            // for (int i = 0; i < resp.data.length; i++) {
            //   mainlisttab.add(resp.data[i]);
            // }
            List<unitcom.DatumElement> blankmainlisttab = [];
            blankmainlisttab.clear();
            for (int i = 0; i < resp.data.length; i++) {
              if (resp.data[i].pendingdata.isNotEmpty ||
                  resp.data[i].dependentdata.isNotEmpty) {
                mainlisttab.add(resp.data[i]);
              } else {
                blankmainlisttab.add(resp.data[i]);
              }
            }
            mainlisttab.addAll(blankmainlisttab);

            if (widget.isnotify) {
              for (int i = 0; i < mainlisttab.length; i++) {
                print(widget.clientname);
                if (mainlisttab[i].clientName == widget.clientname) {
                  print(mainlisttab[i].clientName);
                  print("mainlisttab[i].clientName");
                  print(widget.clientname);
                  //  int selectindex = resp.data.indexWhere((item) => item.clientName == "RMALL - Mulund");
                  setState(() {
                    maintag = i;
                    print(" maintag.toString()");
                    print(maintag.toString());
                  });
                }
              }
              if (widget.status == "Pending") {
                for (int i = 0;
                    i < mainlisttab[maintag].pendingdata.length;
                    i++) {
                  if (mainlisttab[maintag].pendingdata[i].id.toString() ==
                      widget.initalid) {
                    setState(() {
                      print("supervisor");
                      print(widget.initalid);
                      initialindex = i;
                      print(initialindex);
                    });
                  }
                }
                _unitscrollToIndex(initialindex);
              } else if (widget.status == "Dependent") {
                for (int i = 0;
                    i < mainlisttab[maintag].dependentdata.length;
                    i++) {
                  if (mainlisttab[maintag].dependentdata[i].id.toString() ==
                      widget.initalid) {
                    setState(() {
                      print("supervisor");
                      print(widget.initalid);
                      initialindex = i;
                      print(initialindex);
                    });
                  }
                }
                _unitscrollToIndex(initialindex);
              } else if (widget.status == "Resolved") {
                for (int i = 0;
                    i < mainlisttab[maintag].resolvedata.length;
                    i++) {
                  if (mainlisttab[maintag].resolvedata[i].id.toString() ==
                      widget.initalid) {
                    setState(() {
                      print("supervisor");
                      print(widget.initalid);
                      initialindex = i;
                      print(initialindex);
                    });
                  }
                }
                _unitscrollToIndex(initialindex);
              }
            }
          });
        } else {
          print("Coin");
          //29OctRUCHI
          setState(() {
            GlobalLists.iscomplaintLoadin.value = false;
          });
          // Navigator.of(this.context).pop();
        }
      }, (error) {
        print('ERR msg is $error');
        setState(() {
          GlobalLists.iscomplaintLoadin.value = false;
        });
        // Navigator.of(this.context).pop();
      }, false, "", jsonval: map);
    } else {
      ShowDialogs.showToast("Please check internet connection");
    }
  }

  // getdependentApi(String id) async {
  //   var status1 = await ConnectionDetector.checkInternetConnection();

  //   if (status1) {
  //     ShowDialogs.showLoadingDialog(context, _keyLoader);

  //     var map = new Map<String, dynamic>();

  //     var supervisorid = await SPManager().getsupervisorid();
  //     print(supervisorid);
  //     map['id'] = id;
  //     map['supervisor'] = supervisorid;

  //     APIManager().apiRequest(context, API.getdependantcomplaint,
  //         (response) async {
  //       GetDependentResponse resp = response;
  //       print('called API ${resp}');
  //       if (resp.status == 1) {
  //         Navigator.of(this.context).pop();
  //         print("noreco12");
  //         ShowDialogs.showToast(resp.msg);
  //         setState(() {
  //           getcomplaintApi();
  //         });
  //       } else {
  //         print("noreco13");
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

//operation
  getoperationdependentApi(String id) async {
    var status = await ConnectionDetector.checkInternetConnection();
    var supervisorid = await SPManager().getsupervisorid();

    final payload = {
      'id': id,
      'supervisor': supervisorid,
    };

    if (status) {
      APIManager().apiRequest(
        context,
        API.getdependantcomplaint,
        (response) async {
          GetDependentResponse resp = response;
          print('called API $resp');
          if (resp.status == 1) {
            setState(() {
              ShowDialogs().confirmationdone(
                  context, "Complaint marked as dependent\nSuccessfully");

              Timer(Duration(seconds: 1), () => Navigator.pop(context));

              if ([
                GlobalLists.unitrole,
                GlobalLists.operationrole,
                GlobalLists.headrole,
                GlobalLists.reginalmanagerrole,
                GlobalLists.clientrole,
                GlobalLists.operationmanagerrole,
              ].contains(role)) {
                getunitcomplaintApi();
              } else {
                getcomplaintApi();
              }
            });
          } else {
            ShowDialogs.showToast(resp.msg);
          }
        },
        (error) {
          print('ERR msg is $error');
        },
        false,
        "",
        jsonval: payload,
      );
    } else {
      /// 📴 Save offline for later sync
      await DBHelper.insertOfflineRequest(
          '${Global.baseUrl}/api/ticketmanagement/DependentComplaint', payload);

      ShowDialogs.showToast("Saved offline. Will sync when connected.");
      Timer(Duration(seconds: 1), () => Navigator.pop(context));
    }
  }

  // getresolvedApi(String id) async {
  //   var status1 = await ConnectionDetector.checkInternetConnection();

  //   if (status1) {
  //     ShowDialogs.showLoadingDialog(context, _keyLoader);

  //     var map = new Map<String, dynamic>();

  //     var supervisorid = await SPManager().getsupervisorid();
  //     print(supervisorid);
  //     map['id'] = id;
  //     map['supervisor'] = supervisorid;

  //     APIManager().apiRequest(context, API.getresolvedcomplaint,
  //         (response) async {
  //       GetDependentResponse resp = response;
  //       print('called API ${resp}');
  //       if (resp.status == 1) {
  //         Navigator.of(this.context).pop();
  //         print("noreco16");
  //         ShowDialogs.showToast(resp.msg);
  //         setState(() {
  //           getcomplaintApi();
  //         });
  //       } else {
  //         print("noreco17");
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

  Future<bool> _checkAndRequestPhotoPermission() async {
    if (await Permission.photos.status.isDenied) {
      final status = await Permission.photos.request();
      return status.isGranted;
    }
    return true;
  }

  void showUploadDialog(
      BuildContext context, String id, CompletionHandler handler) {
    final screenWidth = MediaQuery.of(context).size.width;
    final responsiveFont = (double base) => screenWidth < 360 ? base - 2 : base;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          titlePadding: EdgeInsets.only(top: 20, left: 20, right: 20),
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          title: Text(
            "Upload Images (Optional)",
            style: AppFonts.headerStyle(
              fontSize: responsiveFont(16),
              color: customcolor.blue,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setStateDialog) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "You can upload up to 2 images before resolving the issue.",
                      style: TextStyle(
                        fontSize: responsiveFont(13),
                        color: customcolor.subtitle,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: result.map((path) {
                        return GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                backgroundColor: Colors.transparent,
                                child: GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                    ),
                                    padding: EdgeInsets.all(10),
                                    child: Image.file(
                                      File(path),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  File(path),
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    setStateDialog(() {
                                      result.remove(path);
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    padding: EdgeInsets.all(4),
                                    child: Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 15),
                    ElevatedButton.icon(
                      onPressed: () {
                        if (result.length >= 2) {
                          ShowDialogs.showToast("You have uploaded 2 images");
                        } else {
                          _showSelectionDialog(
                              context, result.length + 1, setStateDialog);
                        }
                      },
                      icon: Icon(Icons.add_a_photo),
                      label: Text("Add Image",
                          style: TextStyle(fontSize: responsiveFont(14))),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: customcolor.tabblue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            if (result.isNotEmpty) {
                              Navigator.pop(context);
                              File? image1 =
                                  result.length > 0 ? File(result[0]) : null;
                              File? image2 =
                                  result.length > 1 ? File(result[1]) : null;

                              ShowDialogs.showToast("Images uploaded");
                              getoperationalresolvedApi(id,
                                  image1: image1, image2: image2);
                              result.clear();
                              handler(true);
                            } else {
                              ShowDialogs.showToast(
                                  "Please upload at least 1 image");
                            }
                          },
                          child: Text(
                            "Submit with Images",
                            style: TextStyle(fontSize: responsiveFont(14)),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: customcolor.green,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            ShowDialogs.showToast(
                                "Resolved without uploading images");
                            getoperationalresolvedApi(id);
                            handler(true);
                          },
                          child: Text(
                            "Skip and Resolve",
                            style: TextStyle(
                              color: customcolor.red,
                              fontWeight: FontWeight.w600,
                              fontSize: responsiveFont(14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future getoperationalresolvedApi(String id,
      {File? image1, File? image2}) async {
    var status = await ConnectionDetector.checkInternetConnection();
    final supervisorId = await SPManager().getsupervisorid();

    final payload = {
      'id': id,
      'supervisor': supervisorId ?? '',
    };
    print("payload");
    print(payload);

    /// Collect image paths if passed
    final List<String> imagePaths = [];
    if (image1 != null) imagePaths.add(image1.path);
    if (image2 != null) imagePaths.add(image2.path);

    if (status) {
      // ShowDialogs.showLoadingDialog(context, _keyLoader);
      setState(() {
        GlobalLists.iscomplaintLoadin.value = true;
      });
      var request = http.MultipartRequest(
        "POST",
        Uri.parse(APIManager.getresolvedcomplaint2),
      );
      print(APIManager.getresolvedcomplaint2);
      request.fields.addAll(payload);

      if (image1 != null) {
        request.files
            .add(await http.MultipartFile.fromPath('close_img1', image1.path));
      }
      if (image2 != null) {
        request.files
            .add(await http.MultipartFile.fromPath('close_img2', image2.path));
      }

      try {
        var response = await request.send();
        // Navigator.of(_keyLoader.currentContext!).pop();
        setState(() {
          GlobalLists.iscomplaintLoadin.value = false;
        });
        final respStr = await response.stream.bytesToString();
        print("📥 Status Code: ${response.statusCode}");
        print("📥 Raw Response Body: $respStr");

        var res = json.decode(respStr);

        if (response.statusCode == 200 && res['status'] == 1) {
          ShowDialogs().confirmationdone(
              context, "Complaint marked as Resolved Successfully");
          Timer(Duration(seconds: 1), () => Navigator.pop(context));
          setState(() {
            if ([
              GlobalLists.unitrole,
              GlobalLists.operationrole,
              GlobalLists.headrole,
              GlobalLists.reginalmanagerrole,
              GlobalLists.clientrole,
              GlobalLists.operationmanagerrole,
            ].contains(role)) {
              getunitcomplaintApi();
            } else {
              getcomplaintApi();
            }
          });
        } else {
          ShowDialogs.showToast(res['msg'] ?? "Something went wrong.");
        }
      } catch (e) {
        setState(() {
          GlobalLists.iscomplaintLoadin.value = false;
        });
        // Navigator.of(_keyLoader.currentContext!).pop();
        print("❌ Error occurred: $e");
        ShowDialogs.showToast("Error: $e");
      }
    } else {
      /// 📴 Save offline for later sync
      await DBHelper.insertOfflineRequest(
        '${Global.baseUrl}/api/ticketmanagement/ResolvedComplaint',
        payload,
        imagePaths: imagePaths,
        isMultipart: true,
      );

      ShowDialogs.showToast("Saved offline. Will sync when connected.");
      Timer(Duration(seconds: 1), () => Navigator.pop(context));
    }
  }

  gettatApi(String id, String duration) async {
    print('gettatApi');
    var status1 = await ConnectionDetector.checkInternetConnection();
    var supervisorid = await SPManager().getsupervisorid();

    final payload = {
      'id': id,
      'supervisor': supervisorid,
      'TAT_duration': duration,
      'TAT_time': duration,
      'TAT_date': datetatcontroller.text,
      'TAT_remark': tat_remark.text,
    };

    if (status1) {
      // ShowDialogs.showLoadingDialog(context, _keyLoader);
      setState(() {
        isOperationUpadteLoaded = true;
      });
      APIManager().apiRequest(
        context,
        API.gettatcomplaint,
        (response) async {
          GetDependentResponse resp = response;
          print('called API $resp');

          if (resp.status == 1) {
            tat_remark.clear();
            // Navigator.of(context).pop();
            setState(() {
              isOperationUpadteLoaded = false;
            });
            setState(() {
              ShowDialogs().confirmationtatdone(
                context,
                "TAT Selected",
                duration,
              );
              Timer(Duration(seconds: 1), () => Navigator.pop(context));

              if (role == GlobalLists.unitrole ||
                  role == GlobalLists.operationrole ||
                  role == GlobalLists.headrole ||
                  role == GlobalLists.reginalmanagerrole ||
                  role == GlobalLists.clientrole ||
                  role == GlobalLists.operationmanagerrole) {
                print("unit");
                getunitcomplaintApi();
              } else {
                getcomplaintApi();
              }
            });
          } else {
            print("noreco19");
            ShowDialogs.showToast(resp.msg);
            setState(() {
              isOperationUpadteLoaded = false;
            });
            // Navigator.of(context).pop();
          }
        },
        (error) {
          print('ERR msg is $error');
        },
        false,
        "",
        jsonval: payload,
      );
    } else {
      /// Save offline (non-multipart request)
      await DBHelper.insertOfflineRequest(
        '${Global.baseUrl}/api/ticketmanagement/TATComplaint',
        payload,
        // isMultipart: false,
      );
      // Navigator.pop(context);
      setState(() {
        isOperationUpadteLoaded = false;
      });
      ShowDialogs.showToast("Saved offline. Will sync when connected.");
    }
  }

  //opertionaltat
  bool isOperationUpadteLoaded = false;

  ///add offline
  operationalupdatetatApi(String id, String duration) async {
    log('operationalupdatetatApi');
    var isConnected = await ConnectionDetector.checkInternetConnection();
    var clientid = await SPManager().getclientid();
    var supervisorid = await SPManager().getsupervisorid();

    print('clientid: $clientid');
    print('supervisorid: $supervisorid');

    final payload = {
      'id': id,
      'TAT_duration': duration,
      'TAT_date': datetatcontroller.text,
      'TAT_time': duration,
      'emp_id': clientid,
      'TAT_remark': tat_remark.text,
    };

    log('payload ${payload}');

    if (isConnected) {
      // ShowDialogs.showLoadingDialog(context, _keyLoader);
      setState(() {
        isOperationUpadteLoaded = true;
      });
      APIManager().apiRequest(
        context,
        API.operationalupdatetat,
        (response) async {
          UpdateTatResponse resp = response;
          print('called API $resp');

          if (resp.status == 1) {
            setState(() {
              isOperationUpadteLoaded = false;
            });
            // Navigator.of(context).pop();
            tat_remark.clear();

            setState(() {
              ShowDialogs().confirmationdone(
                  context, "Complaint Updated \nSuccessfully");
              Timer(Duration(seconds: 1), () => Navigator.pop(context));

              if (role == GlobalLists.unitrole ||
                  role == GlobalLists.operationrole ||
                  role == GlobalLists.headrole ||
                  role == GlobalLists.reginalmanagerrole ||
                  role == GlobalLists.clientrole ||
                  role == GlobalLists.operationmanagerrole) {
                getunitcomplaintApi();
              } else {
                getcomplaintApi();
              }
            });
          } else {
            print("noreco21");
            ShowDialogs.showToast(resp.message);
            setState(() {
              isOperationUpadteLoaded = false;
            });
            // Navigator.of(context).pop();
          }
        },
        (error) {
          print('ERR msg is $error');
          setState(() {
            isOperationUpadteLoaded = false;
          });
          // Navigator.of(context).pop();
        },
        false,
        "",
        jsonval: payload,
      );
    } else {
      await DBHelper.insertOfflineRequest(
          '${Global.baseUrl}/api/ticketmanagement/Update_TAT', payload);
      // Navigator.pop(context);
      setState(() {
        isOperationUpadteLoaded = false;
      });
      ShowDialogs.showToast("Saved offline. Will sync when connected.");
    }
  }

  clientticketmasterApi() async {
    var status1 = await ConnectionDetector.checkInternetConnection();
    setState(() {
      GlobalLists.clientticketlist = [];
    });
    if (status1) {
      var map = new Map<String, dynamic>();

      APIManager().apiRequest(context, API.tickettypelist, (response) async {
        print("Ruchita");

        TicketllistResponse resp = response;
        print('called API ${resp}');
        if (resp.status == 1) {
          setState(() {
            GlobalLists.clientticketlist = resp.data;
          });
        } else {
          // ShowDialogs.showToast(resp.message);
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

  masterareaApi() async {
    var status1 = await ConnectionDetector.checkInternetConnection();
    setState(() {
      GlobalLists.masterarealist = [];
    });
    if (status1) {
      var map = new Map<String, dynamic>();
      map['site_config_id'] = siteidconfig;

      APIManager().apiRequest(context, API.masterclientarea, (response) async {
        print("Ruchita");

        MasterareaResponse resp = response;
        print('called API ${resp}');
        if (resp.status == 1) {
          setState(() {
            GlobalLists.masterarealist = resp.data;
          });
        } else {
          print("noreco22");
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

  masterblockareaApi() async {
    var status1 = await ConnectionDetector.checkInternetConnection();
    setState(() {
      GlobalLists.masterblocklist = [];
    });
    if (status1) {
      var map = new Map<String, dynamic>();
      map['site_config_id'] = siteidconfig;
      map['Master_Area'] = areaid;

      APIManager().apiRequest(context, API.masterclientblockarea,
          (response) async {
        print("Ruchita");

        MasterBlockResponse resp = response;
        print('called API ${resp}');
        if (resp.status == 1) {
          setState(() {
            GlobalLists.masterblocklist = resp.data;
          });
        } else {
          print("noreco23");
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

  void showRemarkDialog(BuildContext context, String? remarkText) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          // title: Text(
          //   "Remark",
          //   style: AppFonts.headerStyle(
          //     fontSize: ResponsiveFlutter.of(context).fontSize(2),
          //     color: customcolor.tabblue,
          //     fontWeight: FontWeight.bold,
          //   ),
          // ),
          content: SingleChildScrollView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Remark : ",
                          style: AppFonts.headerStyle(
                            fontSize: 12,
                            color: customcolor.black,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        TextSpan(
                          text: remarkText?.isNotEmpty == true
                              ? remarkText!
                              : "No remark found",
                          style: AppFonts.headerStyle(
                            fontSize: 14,
                            color: customcolor.tabblue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // close dialog
              },
              child: Text(
                "Close",
                style: AppFonts.headerStyle(
                  fontSize: 12,
                  color: customcolor.tabblue,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  confirmationtat(BuildContext context, String id) {
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
              height: SizeConfig.blockSizeVertical * 29 +
                  MediaQuery.of(context).viewInsets.bottom,
              color: Colors.white,
              margin: EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 2),
              padding: EdgeInsets.all(5),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Select TAT",
                        style: AppFonts.headerStyle(
                            fontSize:
                                ResponsiveFlutter.of(context).fontSize(2.6),
                            color: customcolor.black,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      new Container(
                        //padding: EdgeInsets.only(left: ((MediaQuery.of(context).size.width-20)/5)/2,right: ((MediaQuery.of(context).size.width-20)/5)/2),
                        width: MediaQuery.of(context).size.width,
//               child:Slider(
//                 activeColor: customcolor.darkorange,
//                 inactiveColor: customcolor.greybg,
//    value: selectedIndex.toDouble(),
//    min: 0,
//    max: values.length - 1,
//    divisions: values.length - 1,
//    label: values[selectedIndex].toString(),
//    onChanged: (double value) {
//    setStateDialgoue(() {
//         selectedIndex = value.toInt();
//       });
//    },
// ),
                        child: SfSliderTheme(
                          data: SfSliderThemeData(
                              trackCornerRadius: 7.5,
                              activeTrackHeight: 10,
                              inactiveTrackHeight: 10,
                              overlayRadius: 0.0),
                          child: SfSlider(
                            labelFormatterCallback:
                                (dynamic actualValue, String formattedText) {
                              switch (actualValue) {
                                // print(actualValue);
                                //            case 5:
                                // return ' 5\nmin';
                                //           case 25:
                                // return ' 10\nmin';
                                //           case 45:
                                // return ' 15\nmin';
                                //           case 65:
                                // return ' 20\nmin';
                                //           case 85:
                                //return 'actualValue';
                              }
                              return
                                  // values[selectedIndex].toString();
                                  '${actualValue.toString()} \nmin';
                            },
                            //   divisions: values.length - 1,
                            //label: values[selectedIndex].toString(),
                            activeColor: customcolor.darkorange,
                            inactiveColor: customcolor.greybg,
                            labelPlacement: LabelPlacement.onTicks,
                            stepSize: 10,
                            thumbIcon: Container(
                              decoration: BoxDecoration(
                                color: customcolor.white,
                                border: Border.all(
                                  color: customcolor.darkorange,
                                  width: 0.4,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Image.asset(
                                  'assets/images/broom.png',
                                  width: 30,
                                  height: 30,
                                ),
                              ),
                            ),
                            //                   value: selectedIndex.toDouble(),
                            //  min: 0,
                            //  max: values.length - 1,

                            //  onChanged: (dynamic value) {
                            //  setStateDialgoue(() {
                            //       selectedIndex = value.toInt();
                            //     });
                            //  },
                            min: 5.0,
                            max: 65.0,
                            value: _value,
                            interval: 10,
                            showTicks: true,
                            showLabels: true,
                            enableTooltip: true,

                            minorTicksPerInterval: 0,
                            onChanged: (dynamic value) {
                              setStateDialgoue(() {
                                _value = value;
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          gettatApi(id, _value.toString());
                        },
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: isOperationUpadteLoaded
                              ? CircularProgressIndicator(
                                  color: customcolor.blue,
                                )
                              : Image.asset(
                                  'assets/images/next.png',
                                  width: 50,
                                  height: 50,
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
}
