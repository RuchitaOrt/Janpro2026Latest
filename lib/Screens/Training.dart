import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:another_flushbar/flushbar.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';

import 'package:file_picker/file_picker.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:janpro/Screens/Homepage.dart';
import 'package:janpro/Screens/TrainingDetail.dart';
import 'package:janpro/Screens/TrainingList.dart';
import 'package:janpro/Utitlity/APIManager.dart';
import 'package:janpro/Utitlity/AppDrawer.dart';
import 'package:janpro/Utitlity/FormTextField.dart';
import 'package:janpro/Utitlity/FormTextFieldButton.dart';
import 'package:janpro/Utitlity/GlobalLists.dart';
import 'package:janpro/Utitlity/ResponsiveFlutter.dart';
import 'package:janpro/Utitlity/SPManager.dart';
import 'package:janpro/Utitlity/ShowDialog.dart';
import 'package:janpro/Utitlity/appbar.dart';
import 'package:janpro/Utitlity/button.dart';
import 'package:janpro/Utitlity/customBottomNavigationBar.dart';
import 'package:janpro/Utitlity/custom_color.dart';
import 'package:janpro/Utitlity/internetConnection.dart';
import 'package:janpro/Utitlity/linechart.dart';
import 'package:janpro/Utitlity/sizeConfig.dart';

import 'package:janpro/model/AttendencelistResponse.dart';
import 'package:janpro/model/ClientwisetrainingResponse.dart' as training;
import 'package:janpro/model/JanitorslistResponse.dart';
import 'package:janpro/model/MobilelisttrainingResponse.dart' as agen;
import 'package:permission_handler/permission_handler.dart' as permishan;
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:image/image.dart' as img;
import '../DBHelper/db_helper.dart';
import '../const/global.dart';
import '../services/camera_capture_screen.dart';
import '../services/permission_helper.dart';

class Ratingclass {
  final String name;

  final String value;

  Ratingclass(this.name, this.value);
}

class MainListtrianing {
  final String name;
  final String priority;

  MainListtrianing(this.name, this.priority);
}

class Agendacheckbox {
  final String name;
  final String id;
  bool isselected;

  Agendacheckbox(this.name, this.id, this.isselected);
}

class Janitorcheckbox {
  final String name;
  final String id;
  final String contact;
  bool isselected;

  Janitorcheckbox(this.name, this.id, this.isselected, this.contact);
}

class Training extends StatefulWidget {
  String clientname;

  Training(this.clientname);

  @override
  _TrainingState createState() => _TrainingState();
}

class _TrainingState extends State<Training> with TickerProviderStateMixin {
  var searchcontroller = new TextEditingController();
  var namecontroller = new TextEditingController();
  var sitenamecontroller = new TextEditingController();
  var datecontroller = new TextEditingController();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  var uploadcontroller = new TextEditingController();

  List<EmployeeList> unitemployeelist = [];
  String selectedValue = "Pending";

  String? lat;
  String? long;
  List<String> listtab = [];
  List<String>? formValue1;

  int tag = 0;
  int maintag = 0;

  String _isSelected = "";
  List<training.Datum> mainlisttab = [];
  List<Agendacheckbox> agendalist = [];
  String janitorname = "";
  List<String> janitorid = [];
  List<String> agendaid = [];
  var selectedDateTime;
  List<Ratingclass> ratinglist = [];
  late Data attendancedata;
  bool isdataloaded = false;
  List<EmployeeList> searchUserList = [];
  String? role = "1";
  late TabController _tabControllermain;
  final List<Tab> tabsmain = <Tab>[];
  int selectedindex = 0;
  bool showAvg = false;
  late TabController _tabController;

  bool isexpanded = false;
  bool isexpandedjanitor = false;
  List<Janitorcheckbox> dropdownList = [];
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

  //   'Christine Schneider',
  //   'Philip Grand',

  // ];
  @override
  void initState() {
    super.initState();

    print("date ");
    // requestStoragePermission();

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
    traininglistApi();
    trainingagendaApi();
    print("TRAIN");
    //  janotoragendaApi();
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

        //floating action button position to center
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(148),
          child: AppbarComman(
              setStyleStr: 'TRAINING',
              onPressedBack: () {},
              onPressedNotify: () {},
              onPressedSearch: () {},
              onPressedSort: () {},
              onPressedmenu: () {
                _scaffoldKey1.currentState!.openEndDrawer();
              }),
        ),

        body:isTrainingLoaded?Center(child: Column(
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
              child: (role == GlobalLists.headrole ||
                      role == GlobalLists.reginalmanagerrole ||
                      role == GlobalLists.clientrole ||
                      role == GlobalLists.operationrole ||
                      role == GlobalLists.operationmanagerrole)
                  ? mainlisttab.length > 0
                      ? Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, top: 20, bottom: 5),
                          child: Container(
                            child: ListView(
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                            "TRAINING",
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
                                    mainlisttab.length > 0
                                        ? _buildChoicemainListForTab()
                                        : SizedBox()
                                    //add here
                                  ],
                                ),

                                //workflow
                                SizedBox(
                                  height: 10,
                                ),
                                headmodule()
                              ],
                            ),
                          ),
                        )
                      : ShowDialogs.norecordwidget(
                          SizeConfig.blockSizeHorizontal * 35,
                          SizeConfig.blockSizeVertical * 42)
                  : Container(),
            ),
            mainlisttab.length > 0
                ?
                //  mainlisttab[maintag].totalNumberOfTraning.toString() == "0"
                //     ? Container()
                // :
                Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: EdgeInsets.only(
                          right: SizeConfig.blockSizeHorizontal * 10,
                          bottom: 20,
                          left: SizeConfig.blockSizeHorizontal * 10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: customcolor.blue,
                          minimumSize: Size(SizeConfig.blockSizeHorizontal * 80,
                              SizeConfig.blockSizeVertical * 5),
                          textStyle: AppFonts.headerStyle(
                              fontSize: 15,
                              color: customcolor.black,
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          mainlisttab.length > 0
                              ? mainlisttab[maintag]
                                      .totalNumberOfTraning
                                      .toString() ==
                                  "0"
                              : mainlisttab[maintag].trainingData;
                          // print(mainlisttab[maintag].trainingData[0].trainingDatumDateOfTraining);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      TrainingList(
                                          mainlisttab[maintag].trainingData,
                                          widget.clientname)));
                        },
                        child: Text(
                          'View Training',
                          style: AppFonts.headerStyle(
                              fontSize: 14,
                              color: customcolor.white,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                  )
                : Container(),
            (role == GlobalLists.operationrole ||
                    role == GlobalLists.operationmanagerrole ||
                    role ==
                        GlobalLists
                            .headrole /*||
                    role == GlobalLists.reginalmanagerrole*/
                )
                ? mainlisttab.length > 0
                    ? Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: EdgeInsets.only(
                              bottom: mainlisttab[maintag]
                                          .totalNumberOfTraning
                                          .toString() ==
                                      "0"
                                  ? SizeConfig.blockSizeVertical * 4
                                  : SizeConfig.blockSizeVertical * 10,
                              right: 15),
                          child: FloatingActionButton(
                            backgroundColor: customcolor.blue,
                            onPressed: () {
                              // Add your action for the center button here
                              datecontroller.text = "";
                              janitorname = "";
                              janitorid = [];
                              agendaid = [];
                              result = [];
                              sitenamecontroller.text = "";
                              namecontroller.text = "";
                              uploadcontroller.text = "";
                              isexpandedjanitor = false;
                              isexpanded = false;

                              for (int i = 0; i < dropdownList.length; i++) {
                                dropdownList[i].isselected = false;
                              }
                              for (int i = 0; i < agendalist.length; i++) {
                                agendalist[i].isselected = false;
                              }
                              addtraing(context);
                            },
                            child: Icon(
                              Icons.add,
                              color: customcolor.white,
                            ),
                          ),
                        ),
                      )
                    : Container()
                : Container()
          ],
        ),
      ),
    );
  }

  Widget siteDropdown(StateSetter setStateDialgoue) {
    return Container(
      height: agendalist.length <= 1
          ? 120
          : agendalist.length <= 2
              ? 180
              : 250,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Card(
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Column(
            children: [
              // Scrollable checkbox list
              Expanded(
                child: Scrollbar(
                  thumbVisibility: agendalist.length > 2,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: agendalist.length,
                    itemBuilder: (BuildContext context, int index) {
                      return CheckboxListTile(
                        activeColor: customcolor.green,
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        title: Text(
                          agendalist[index].name,
                          style: AppFonts.headerStyle(
                            fontSize: 12,
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        value: agendalist[index].isselected,
                        onChanged: (value) {
                          setStateDialgoue(() {
                            agendalist[index].isselected = value!;
                            List<String> agelist = [];
                            List<String> agendais = [];
                            for (int i = 0; i < agendalist.length; i++) {
                              if (agendalist[i].isselected) {
                                agelist.add(agendalist[i].name.toString());
                                agendais.add(agendalist[i].id.toString());
                              }
                            }
                            sitenamecontroller.text = agelist.join(', ');
                            agendaid = agendais;
                          });
                        },
                      );
                    },
                  ),
                ),
              ),

              Divider(height: 12),

              // Sticky Submit button
              Center(
                child: GestureDetector(
                  onTap: () {
                    setStateDialgoue(() {
                      isexpanded = false;
                    });
                  },
                  child: Text(
                    "Submit",
                    style: AppFonts.headerStyle(
                      fontSize: 12,
                      color: customcolor.blue,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  //janitors

  Widget janitorsDropdown(StateSetter setStateDialgoue) {
    return Container(
      height: dropdownList.length <= 1
          ? 120
          : dropdownList.length <= 2
              ? 180
              : 250,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Card(
        elevation: 5,
        child:dropdownList.length==0? Container(
          width: SizeConfig.blockSizeHorizontal*90,
          child: Center(child: Text("No Record Found")),): Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Column(
            children: [
              // Scrollable Checkbox List
              Expanded(
                child: Scrollbar(
                  thumbVisibility: dropdownList.length > 2,
                  child: ListView.builder(
                    itemCount: dropdownList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return CheckboxListTile(
                        activeColor: customcolor.green,
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        title: Text(
                          dropdownList[index].name,
                          style: AppFonts.headerStyle(
                            fontSize: 12,
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        value: dropdownList[index].isselected,
                        onChanged: (value) {
                          setStateDialgoue(() {
                            dropdownList[index].isselected = value!;
                            List<String> agelist = [];
                            List<String> agendais = [];

                            for (int i = 0; i < dropdownList.length; i++) {
                              if (dropdownList[i].isselected) {
                                agelist.add(dropdownList[i].name.toString());
                                agendais.add(dropdownList[i].id.toString());
                              }
                            }

                            namecontroller.text = agelist.join(', ');
                            janitorname = agelist.toString();
                            janitorid = agendais;
                          });
                        },
                      );
                    },
                  ),
                ),
              ),

              Divider(height: 10),

              // Sticky Submit Button
             dropdownList.length==0?Container():    Center(
                child: GestureDetector(
                  onTap: () {
                    setStateDialgoue(() {
                      isexpandedjanitor = false;
                    });
                  },
                  child: Text(
                    "Submit",
                    style: AppFonts.headerStyle(
                      fontSize: 12,
                      color: customcolor.blue,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  addtraing(
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
              height: (isexpanded == true || isexpandedjanitor == true)
                  ? SizeConfig.blockSizeVertical * 70 +
                      MediaQuery.of(context).viewInsets.bottom
                  : (result.length >= 1)
                      ? SizeConfig.blockSizeVertical * 70 +
                          MediaQuery.of(context).viewInsets.bottom
                      : SizeConfig.blockSizeVertical * 56 +
                          MediaQuery.of(context).viewInsets.bottom,
              color: Colors.white,
              margin: EdgeInsets.only(left: 20, right: 20, bottom: 5, top: 2),
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
                        "Create Training",
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
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate:
                                      selectedDateTime ?? DateTime.now(),
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
                              placeholderStr: "Date of Training",
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
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          setStateDialgoue(() {
                            isexpanded = !isexpanded;
                            isexpandedjanitor = false;
                          });
                        },
                        child: FormTextField(
                          isEnable: false,
                          textcontroller: sitenamecontroller,
                          placeholderStr: "Training Agenda",
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
                              SizedBox(
                                height: 20,
                              ),
                              GestureDetector(
                                onTap: () {
                                  setStateDialgoue(() {
                                    isexpandedjanitor = !isexpandedjanitor;
                                    isexpanded = false;
                                  });
                                },
                                child: FormTextField(
                                  isEnable: false,
                                  textcontroller: namecontroller,
                                  placeholderStr: "Name of Janitor Trained",
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
                                      Stack(
                                        children: [
                                          Column(
                                            children: [
                                              SizedBox(
                                                height: 20,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  _showSelectionDialog(context,
                                                      1, setStateDialgoue);
                                                },
                                                child: FormTextField(
                                                  isEnable: false,
                                                  textcontroller:
                                                      uploadcontroller,
                                                  placeholderStr:
                                                      "Upload Image (2 Images)",

                                                  //   maxLength: 10,
                                                  textInputType:
                                                      TextInputType.text,
                                                  onchange: (val) {},
                                                  suffixWidget: Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 20),
                                                    child: Image.asset(
                                                      "assets/images/addimage.png",
                                                      width: 20,
                                                      height: 20,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              result.length == 0
                                                  ? Container()
                                                  : Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 5,
                                                              top: 3,
                                                              bottom: 2),
                                                      child: Wrap(
                                                        alignment:
                                                            WrapAlignment.start,
                                                        runAlignment:
                                                            WrapAlignment.start,
                                                        crossAxisAlignment:
                                                            WrapCrossAlignment
                                                                .start,
                                                        spacing: 6.0,
                                                        children: List<
                                                            Widget>.generate(
                                                          result.length,
                                                          (int index) {
                                                            return GestureDetector(
                                                              onTap: () async {
                                                                print(
                                                                    "openfile");
                                                                showfileimage(
                                                                    result[index]
                                                                        .split(
                                                                            '/')
                                                                        .last,
                                                                    result[
                                                                        index]);
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
                                                                    style: BorderStyle
                                                                        .solid,
                                                                    color: customcolor
                                                                        .blue),
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(4))),
                                                                labelPadding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            2.0),
                                                                // avatar: CircleAvatar(
                                                                //     backgroundColor: Colors.transparent,
                                                                //     child: Icon(
                                                                //       Icons.contact_phone_rounded,
                                                                //       size: 20,
                                                                //       color: Colors.black,
                                                                //     )),
                                                                label: Text(
                                                                  result[index]
                                                                      .split(
                                                                          '/')
                                                                      .last,
                                                                  style: TextStyle(
                                                                      color: customcolor
                                                                          .blue,
                                                                      fontSize:
                                                                          12),
                                                                ),
                                                                onDeleted: () {
                                                                  setStateDialgoue(
                                                                      () {
                                                                    result.removeAt(
                                                                        index);
                                                                    List<String>
                                                                        filename =
                                                                        [];
                                                                    uploadcontroller
                                                                        .text = "";
                                                                    for (int i =
                                                                            0;
                                                                        i < result.length;
                                                                        i++) {
                                                                      filename.add(result[
                                                                              i]
                                                                          .split(
                                                                              '/')
                                                                          .last);
                                                                    }
                                                                    print(
                                                                        filename);
                                                                    String s =
                                                                        filename
                                                                            .join(', ');
                                                                    print(s);

                                                                    uploadcontroller
                                                                        .text = s;
                                                                  });
                                                                },
                                                                deleteIcon:
                                                                    Icon(
                                                                  Icons.close,
                                                                  color:
                                                                      customcolor
                                                                          .blue,
                                                                  size: 20,
                                                                ),

                                                                backgroundColor:
                                                                    customcolor
                                                                        .blue
                                                                        .withOpacity(
                                                                            0.1),
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
                                                height: 30,
                                              ),
                                              Center(
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor: customcolor.blue,
                                                    minimumSize: Size(
                                                        SizeConfig
                                                                .blockSizeHorizontal *
                                                            80,
                                                        SizeConfig
                                                                .blockSizeVertical *
                                                            6),
                                                    textStyle:
                                                        AppFonts.headerStyle(
                                                            fontSize: 15,
                                                            color: customcolor
                                                                .black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                  ),
                                                  onPressed: () {
                                                    if (datecontroller
                                                        .text.isEmpty) {
                                                      ShowDialogs.showToast(
                                                          "Please Select Training Date");
                                                    } else if (sitenamecontroller
                                                        .text.isEmpty) {
                                                      ShowDialogs.showToast(
                                                          "Please Select Training Agenda");
                                                    } else if (janitorname ==
                                                        "") {
                                                      ShowDialogs.showToast(
                                                          "Please Select Trained Janitor");
                                                    } else if (result.length ==
                                                        0) {
                                                      ShowDialogs.showToast(
                                                          "Please upload Image");
                                                    } else {
                                                      operationaladdtrainingApi();
                                                    }
                                                  },
                                                  child:isAddTrainingLoaded?CircularProgressIndicator(color: customcolor.white,): Text(
                                                    'Create',
                                                    style: AppFonts.headerStyle(
                                                        fontSize: 14,
                                                        color:
                                                            customcolor.white,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          isexpandedjanitor
                                              ? janitorsDropdown(
                                                  setStateDialgoue)
                                              : Container()
                                        ],
                                      ),
                                    ],
                                  ),
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
                ],
              ),
            );
          });
        });
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

  Widget headmodule() {
    return CustomRefreshIndicator(
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
        //    physics: ScrollPhysics(),
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
          Container(
            height: SizeConfig.blockSizeVertical * 60,
            decoration: BoxDecoration(
              //color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: customcolor.greyborder,
                width: 0.4,
              ),
            ),
            child: ListView(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              // mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [maintab(maintag)],
            ),
          ),
        ],
      ),
    );
  }

  Widget maintab(int maintag) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        // mainAxisAlignment: MainAxisAlignment.start,
        shrinkWrap: true,
        physics: ScrollPhysics(),
        children: [
          trainingbox("Total number of trainings done",
              mainlisttab[maintag].totalNumberOfTraning.toString()),
          SizedBox(
            height: 5,
          ),
          trainingbox(
              "Training done this month", mainlisttab[maintag].trainingDone),
          SizedBox(
            height: 5,
          ),
          Material(
            elevation: 0,
            borderRadius: BorderRadius.circular(10),
            color: customcolor.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15, top: 8, bottom: 8),
                  child: Text(
                    "Percentage Janitors Certified",
                    maxLines: 2,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    style: AppFonts.headerStyle(
                        fontSize: ResponsiveFlutter.of(context).fontSize(2),
                        color: customcolor.title,
                        fontWeight: FontWeight.normal),
                  ),
                ),
                overallgraph(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget trainingbox(String name, String value) {
    return Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(10),
      color: customcolor.white,
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 19, top: 8, bottom: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5, bottom: 0),
              child: Text(
                name,
                style: AppFonts.headerStyle(
                    fontSize: ResponsiveFlutter.of(context).fontSize(2),
                    color: customcolor.black,
                    fontWeight: FontWeight.normal),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5, bottom: 0),
              child: Text(
                value,
                style: AppFonts.headerStyle(
                    fontSize: ResponsiveFlutter.of(context).fontSize(2.6),
                    color: customcolor.textyellow,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget overallgraph() {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.15,
          child: Padding(
            padding: const EdgeInsets.only(
              right: 18,
              left: 12,
              top: 24,
              bottom: 4,
            ),
            child: LineChart(
              LineChartSample2.mainDatatraing(),
            ),
          ),
        ),
      ],
    );
  }

  Widget ratingbox(int index) {
    return Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(10),
      color: customcolor.white,
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 16, bottom: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5, bottom: 5),
              child: Text(
                ratinglist[index].name,
                style: AppFonts.headerStyle(
                    fontSize: ResponsiveFlutter.of(context).fontSize(2),
                    color: customcolor.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
            RatingBar.builder(
              initialRating: 3,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: int.parse(ratinglist[index].value),
              itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                print(rating);
              },
            ),
          ],
        ),
      ),
    );
  }

  _buildChoiceList() {
    List<Widget> choices = [];
    listtab.forEachIndexed((item, value) {
      choices.add(Container(
        child: ChoiceChip(
          label: Text(
            item,
            style: AppFonts.headerStyle(
                fontSize: 12,
                color: customcolor.black,
                fontWeight: FontWeight.bold),
          ),
          // shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20))),
          labelStyle: AppFonts.headerStyle(
              fontSize: 12,
              color: tag == value ? customcolor.blue : customcolor.greytext,
              fontWeight: FontWeight.bold),

          selectedColor: customcolor.blue.withOpacity(0.2),
          backgroundColor: customcolor.white,
          selected: tag == value,
          onSelected: (selected) {
            setState(() {
              _isSelected = item;
              tag = value;
            });
          },
        ),
      ));
    });
    return choices;
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
                        : item.status == 0
                            ? customcolor.red
                            : customcolor.green,
                    fontWeight: FontWeight.bold),
              ),
            ),
            side: BorderSide(
                width: 0.5,
                color: maintag == value
                    ? customcolor.white
                    : item.status == 0
                        ? customcolor.red
                        : customcolor.green),
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
                janotoragendaApi();
                widget.clientname = item.clientName;
                GlobalLists.traningclienttag = maintag - 1;
                GlobalLists.traininggraphlist = mainlisttab[maintag].graphData;
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
                                          : item.status == 0
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

                                            // Perform same logic as original chip tap
                                            janotoragendaApi();
                                            widget.clientname = item.clientName;
                                            GlobalLists.traningclienttag =
                                                maintag - 1;
                                            GlobalLists.traininggraphlist =
                                                mainlisttab[maintag].graphData;
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

  attendancelist(List<EmployeeList> employeelist) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemCount: employeelist.length,
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
                    employeelist[index].name,
                    style: AppFonts.headerStyle(
                        fontSize: ResponsiveFlutter.of(context).fontSize(2.3),
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
                                employeelist[index].contact,
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
                                "${employeelist[index].loginTime}",
                                style: AppFonts.headerStyle(
                                    fontSize: ResponsiveFlutter.of(context)
                                        .fontSize(1.8),
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

  bool isTrainingLoaded = false;
  traininglistApi() async {
    var status1 = await ConnectionDetector.checkInternetConnection();
    setState(() {
      mainlisttab = [];
    });
    if (status1) {
      
      setState(() {
        isTrainingLoaded = true;
      });
      var map = new Map<String, dynamic>();

      var clientid = await SPManager().getclientid();
      var supervisorid = await SPManager().getsupervisorid();

      print("$clientid");
      if (role == GlobalLists.clientrole) {
        map['clientid'] = clientid;
      } else {
        map['emp_id'] = supervisorid;
      }
      print("map");
      print(map);
      APIManager().apiRequest(context, API.clientwisetraininglist,
          (response) async {
        training.ClientwisetrainingResponse resp = response;
        print('called API ${resp}');
        if (resp.status == 1) {
          setState(() {
            isTrainingLoaded = false;
          });
          // Navigator.of(this.context).pop();
          //   ShowDialogs.showToast(resp.msg);
          setState(() {
            isdataloaded = true;
            // GlobalLists.ratinggraphlist=resp.;

            for (int i = 0; i < resp.data.length; i++) {
              log("resp.data :${resp.data[i]}");
              mainlisttab.add(resp.data[i]);
              print("TRAI");
              print(widget.clientname);
              print(resp.data[i].clientName);
              if (resp.data[i].clientName == widget.clientname) {
                //  int selectindex = resp.data.indexWhere((item) => item.clientName == "RMALL - Mulund");
                setState(() {
                  maintag = i;
                  print(maintag.toString());
                });
              }
            }
            janotoragendaApi();
            GlobalLists.traininggraphlist = mainlisttab[maintag].graphData;

            print(resp.data);
          });
        } else {
          //  ShowDialogs.showToast(resp.msg);
          // Navigator.of(this.context).pop();
          setState(() {
            isTrainingLoaded = false;
          });
        }
      }, (error) {
        print('ERR msg is $error');
        ShowDialogs.showToast("Server Not Responding");
        setState(() {
          isTrainingLoaded = false;
        });
        // Navigator.of(this.context).pop();
      }, false, "", jsonval: map);
    } else {
      ShowDialogs.showToast("Please check internet connection");
    }
  }

  trainingagendaApi() async {
    var status1 = await ConnectionDetector.checkInternetConnection();

    setState(() {
      agendalist = [];
    });

    var map = <String, dynamic>{};

    if (status1) {
      // ✅ Online: Fetch from API
      APIManager().apiRequest(context, API.mobilelisttrainingmaster,
          (response) async {
        agen.MobilelisttrainingResponse resp = response;
        print('called API $resp');

        if (resp.status == 1) {
          setState(() {
            agendalist = resp.data
                .map((e) => Agendacheckbox(e.name, e.id.toString(), false))
                .toList();
          });

          // ✅ Save to cache
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(
              'cached_training_agenda', json.encode(resp.toJson()));
        } else {
          ShowDialogs.showToast(resp.msg);
        }
      }, (error) {
        print('ERR msg is $error');
      }, false, "", jsonval: map);
    } else {
      // 🚫 Offline: Load from cache
      final prefs = await SharedPreferences.getInstance();
      String? cachedData = prefs.getString('cached_training_agenda');

      if (cachedData != null) {
        agen.MobilelisttrainingResponse cachedResp =
            agen.MobilelisttrainingResponse.fromJson(json.decode(cachedData));

        setState(() {
          agendalist = cachedResp.data
              .map((e) => Agendacheckbox(e.name, e.id.toString(), false))
              .toList();
        });

        ShowDialogs.showToast("Offline agenda loaded");
      } else {
        ShowDialogs.showToast("No internet and no offline data available");
      }
    }
  }

  janotoragendaApi() async {
    var status1 = await ConnectionDetector.checkInternetConnection();

    setState(() {
      dropdownList = [];
    });

    var map = {
      'client_id': mainlisttab[maintag].clientId.toString(),
      'site_id': mainlisttab[maintag].siteId.toString(),
    };

    if (status1) {
      // ✅ Online
      APIManager().apiRequest(context, API.janitorslist, (response) async {
        JanitorslistResponse resp = response;
        print('called Janitor1 $resp');

        if (resp.status == 1) {
          setState(() {
            dropdownList = resp.data
                .map((e) => Janitorcheckbox(
                    e.janName.toString(), e.id.toString(), false, e.contact))
                .toList();
          });

          // ✅ Save to local storage
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(
            'cached_janitor_agenda',
            json.encode(resp.toJson()),
          );
        } else {
          ShowDialogs.showToast(resp.msg);
        }
      }, (error) {
        print('ERR msg is $error');
      }, false, "", jsonval: map);
    } else {
      // 🚫 Offline
      final prefs = await SharedPreferences.getInstance();
      String? cachedData = prefs.getString('cached_janitor_agenda');

      if (cachedData != null) {
        JanitorslistResponse cachedResp =
            JanitorslistResponse.fromJson(json.decode(cachedData));

        setState(() {
          dropdownList = cachedResp.data
              .map((e) => Janitorcheckbox(
                  e.janName.toString(), e.id.toString(), false, e.contact))
              .toList();
        });

        ShowDialogs.showToast("Offline janitor agenda loaded");
      } else {
        ShowDialogs.showToast("No internet and no offline data available");
      }
    }
  }
bool isAddTrainingLoaded=false;
  //offline add
  operationaladdtrainingApi() async {
    var status = await ConnectionDetector.checkInternetConnection();
    String train_agenda = agendaid.join(', ');
    String train_janitor = janitorid.join(', ');

    /// ✅ Create payload
    final payload = {
      'Date_of_Training': datecontroller.text,
      'Training_Agenda': train_agenda,
      'janitors_list': train_janitor,
      'Client_Name': mainlisttab[maintag].clientId.toString(),
      'Site': mainlisttab[maintag].siteId.toString(),
    };

    log(payload.toString());

    if (status) {
      // ShowDialogs.showLoadingDialog(context, _keyLoader);
setState(() {
  isAddTrainingLoaded=true;
});
      var request = http.MultipartRequest(
        "POST",
        Uri.parse(APIManager.operationaladdtraining),
      );

      request.fields.addAll(Map<String, String>.from(payload));

      if (result.isNotEmpty) {
        for (int i = 0; i < result.length; i++) {
          request.files.add(await http.MultipartFile.fromPath(
            'image$i',
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
  isAddTrainingLoaded=false;
});
      if (response.statusCode == 200) {
        Timer(Duration(seconds: 1), () => Navigator.pop(context));
        ShowDialogs()
            .confirmationdone(context, "Training Created \nSuccessfully");
        Timer(
          Duration(seconds: 1),
          () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => Training(widget.clientname),
            ),
          ),
        );
      } else {
        ShowDialogs.showToast(res['msg']);
      }
    } else {
      /// 📴 Offline save
      print('store in local');
      await DBHelper.insertOfflineRequest(
        '${Global.baseUrl}/api/trainingmaster/mobile_add_training_master',
        payload,
        imagePaths: result.cast<String>(),
        isMultipart: true,
      );

      ShowDialogs.showToast("Saved offline. Will sync when connected.");
      setState(() {
  isAddTrainingLoaded=false;
});
      // Navigator.pop(context);
    }
  }

  _displayPickImageDialog(
      BuildContext? context, OnPickImageCallback onPick) async {
    onPick(null, null, null);
  }

  Future<void> _showSelectionDialog(
      BuildContext context, int imageno, StateSetter setStateDialgoue) {
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
  //       imageQuality: 50,
  //     );

  //     await _displayPickImageDialog(context,
  //         (double? maxWidth, double? maxHeight, int? quality) async {});
  //     setStateDialgoue(() async {
  //       print(pickedFile);
  //       _imageFile = File(pickedFile!.path);
  //       print(_imageFile!.path);
  //       _fileName = _imageFile!.path.split('/').last;

  //       result.add(_imageFile!.path);
  //       // uploadcontroller.text=_fileName!;

  //       List<String> filename = [];
  //       uploadcontroller.text = "";
  //       for (int i = 0; i < result.length; i++) {
  //         filename.add(result[i].split('/').last);
  //       }
  //       print(filename);
  //       String s = filename.join(', ');
  //       print(s);
  //       uploadcontroller.text = s;
  //       setStateDialgoue(() {});
  //     });
  //   } catch (e) {
  //     setState(() {
  //       _pickImageError = e;
  //     });
  //   }
  // }

void _onImageButtonPressed(
  ImageSource source,
  int imageno,
  StateSetter setStateDialgoue, {
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

      // Open custom camera screen
      Navigator.push(
        context!,
        MaterialPageRoute(
          builder: (_) => CameraCaptureScreen(
            onImageCaptured: (String imagePath) {
              File captured = File(imagePath);
              String fileName = captured.path.split('/').last;

              setStateDialgoue(() {
                _imageFile = captured;
                _fileName = fileName;

                result.add(captured.path);

                List<String> filename = [];
                uploadcontroller.text = "";
                for (int i = 0; i < result.length; i++) {
                  filename.add(result[i].split('/').last);
                }

                uploadcontroller.text = filename.join(', ');
              });
            },
          ),
        ),
      );

      return; // Important: stop further execution
    }

    
  } catch (e) {
    setState(() {
      _pickImageError = e;
    });
  }
}



  Future<int> getFileSize(String filePath) async {
    File file = File(filePath);
    int size = await file.length();
    return size;
  }
void _openFileExplorer(int imageno, StateSetter setStateDialgoue) async {
  setState(() => _loadingPath = true);

  try {
    final ImagePicker picker = ImagePicker();

    final List<XFile> images = await picker.pickMultiImage();

    if (images.isEmpty) {
      setState(() => _loadingPath = false);
      return;
    }

    if (images.length > 2) {
      setState(() => _loadingPath = false);
      ShowDialogs.showToast("You can upload upto 2 images");
      return;
    }

    result.clear();
    List<String> fileNames = [];

    //  Compress OUTSIDE UI update
    for (XFile xfile in images) {
      File file = File(xfile.path);

      if (file.existsSync()) {
        final dir = await path_provider.getTemporaryDirectory();
        final targetPath =
            '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

        final compressedFile =
            await FlutterImageCompress.compressAndGetFile(
          file.path,
          targetPath,
          minHeight: 1080,
          minWidth: 1080,
          quality: 50,
        );

        if (compressedFile != null) {
          result.add(compressedFile.path);
          fileNames.add(compressedFile.path.split('/').last);
        }
      }
    }

    if (!mounted) return;

    // ✅ UI update ONLY
    setStateDialgoue(() {
      _loadingPath = false;
      uploadcontroller.text = fileNames.join(', ');
    });

  } catch (e) {
    setState(() => _loadingPath = false);
    debugPrint("ImagePicker error: $e");
  }
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
  //   setStateDialgoue(() async {
  //     _loadingPath = false;
  //     _fileName = _paths != null
  //         ? _paths!.map((e) => e.name).toString()
  //         : 'Select Document';
  //     print("File name is${_fileName}");
  //     if (_paths!.length > 2) {
  //       ShowDialogs.showToast("You can upload upto 2 images");
  //     } else {
  //       // changes by vishu
  //       for (int i = 0; i < _paths!.length; i++) {
  //         File file = File(_paths![i].path!);
  //         if (file.existsSync()) {
  //           final dir = await path_provider.getTemporaryDirectory();
  //           final targetPath =
  //               '${dir.absolute.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
  //           // converting original image to compress it
  //           final finalresult = await FlutterImageCompress.compressAndGetFile(
  //             file.path,
  //             targetPath,
  //             minHeight: 1080, //you can play with this to reduce siz
  //             minWidth: 1080,
  //             quality:
  //                 50, // keep this high to get the original quality of image
  //           );
  //           File newImage = File(finalresult!.path);
  //           print(
  //               'File: ${file} without Compress File Size: ${await getFileSize(file.path)}');
  //           int count = await getFileSize(newImage.path);
  //           print('File: ${newImage} with Compress File Size: ${count}');
  //           result.add(newImage.path);
  //         } else {
  //           print('File does not exist: ${file.path}');
  //           // Handle file not found errors
  //         }
  //       }
  //       List<String> filename = [];
  //       uploadcontroller.text = "";
  //       for (int i = 0; i < result.length; i++) {
  //         filename.add(result[i].split('/').last);
  //       }
  //       print(filename);
  //       String s = filename.join(', ');
  //       print(s);
  //       uploadcontroller.text = s;
  //       //uploadcontroller.text=_fileName!;
  //     }
  //     setStateDialgoue(() {});
  //   });
  // }

  Future<void> requestStoragePermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      if (await Permission.storage.request().isGranted) {
        // Permission granted, proceed with your logic.
      }
    } else {
      // Permission already granted, proceed with your logic.
    }
  }


Future<Placemark> getLocation() async {


  // Get current position
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);


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
}}


typedef void OnPickImageCallback(
    double? maxWidth, double? maxHeight, int? quality);
