import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:janpro/Screens/Training.dart';
import 'package:janpro/Screens/TrainingDetail.dart';
import 'package:janpro/Utitlity/AppDrawer.dart';
import 'package:janpro/Utitlity/FormTextField.dart';
import 'package:janpro/Utitlity/GlobalLists.dart';
import 'package:janpro/Utitlity/ResponsiveFlutter.dart';
import 'package:janpro/Utitlity/SPManager.dart';
import 'package:janpro/Utitlity/ShowDialog.dart';
import 'package:janpro/Utitlity/appbar.dart';
import 'package:janpro/Utitlity/custom_color.dart';
import 'package:janpro/Utitlity/sizeConfig.dart';
import 'package:janpro/model/AttendencelistResponse.dart';
import 'package:janpro/model/ClientwisetrainingResponse.dart';
import 'make_status.dart';

class Ratingclass {
  final String name;

  final String value;

  Ratingclass(this.name, this.value);
}

class MainList {
  final String name;
  final String priority;

  MainList(this.name, this.priority);
}

class TrainingList extends StatefulWidget {
  List<TrainingDatum> mainlisttab;
  String clientname;
  TrainingList(this.mainlisttab, this.clientname);

  @override
  _TrainingListState createState() => _TrainingListState();
}

class _TrainingListState extends State<TrainingList>
    with TickerProviderStateMixin {
  var searchcontroller = new TextEditingController();
  var namecontroller = new TextEditingController();
  var sitenamecontroller = new TextEditingController();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  var mobilecontroller = new TextEditingController();

  List<EmployeeList> unitemployeelist = [];

  String selectedValue = "Pending";
  String? lat;
  String? long;
  List<String> listtab = [];
  List<String>? formValue1;
  int tag = 0;
  int maintag = 0;

  String _isSelected = "";
  List<TrainingDatum> mainlisttab = [];
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
  @override
  void initState() {
    super.initState();

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
    setState(() {
      print("mainlisttab ${widget.mainlisttab}");
      mainlisttab = widget.mainlisttab;
      print("mainlisttabbbbb ${mainlisttab}");

      //  print("mainlisttab");
      //  print(mainlisttab.length);
    });
    if (role == GlobalLists.unitrole ||
        role == GlobalLists.headrole ||
        role == GlobalLists.reginalmanagerrole ||
        role == GlobalLists.clientrole ||
        role == GlobalLists.operationrole ||
        role == GlobalLists.operationmanagerrole) {
      _tabController = new TabController(vsync: this, length: 3);
      setState(() {
        listtab.add("3.30 - 4.00 pm");
        listtab.add("3.50 - 4.00 pm");
        listtab.add("4.30 - 5.00 pm");

        //  mainlisttab.add(MainList("Training #2","29 Aug 2023"));
        //  mainlisttab.add(MainList("Training #1","28 Aug 2023"));
      });

      ratinglist.add(Ratingclass("Washroom", "5"));
      ratinglist.add(Ratingclass("Cleaning", "3"));
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

  final GlobalKey<ScaffoldState> _scaffoldKey1 = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => Training(""),
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
              setStyleStr: 'Training',
              onPressedBack: () {},
              onPressedNotify: () {},
              onPressedSearch: () {},
              onPressedSort: () {},
              onPressedmenu: () {
                _scaffoldKey1.currentState!.openEndDrawer();
              }),
        ),

        body: Stack(
          children: [
            SingleChildScrollView(
              physics: ScrollPhysics(),
              child: (role == GlobalLists.headrole ||
                      role == GlobalLists.reginalmanagerrole ||
                      role == GlobalLists.clientrole ||
                      role == GlobalLists.operationrole ||
                      role == GlobalLists.operationmanagerrole)
                  ? Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 20, bottom: 5),
                      child: Container(
                        // height: SizeConfig.blockSizeHorizontal*100,
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
                            children: [
                              ListView(
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
                                                        Training(""),
                                                  ),
                                                );
                                              },
                                              child: Icon(Icons.arrow_back)),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Container(
                                            child: Text(
                                              "Training",
                                              style: AppFonts.headerStyle(
                                                  fontSize:
                                                      ResponsiveFlutter.of(
                                                              context)
                                                          .fontSize(2.3),
                                                  color: customcolor.black,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),

                                  //workflow
                                  SizedBox(
                                    height: 10,
                                  ),
                                  headmodule()
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Container(),
            ),
          ],
        ),
      ),
    );
  }

  Widget headmodule() {
    return maintab(maintag);
  }

  Widget maintab(int maintag) {
    return mainlisttab.length == 0
        ? ShowDialogs.norecordwidget(SizeConfig.blockSizeHorizontal * 30,
            SizeConfig.blockSizeVertical * 36)
        : Container(
            height: SizeConfig.blockSizeVertical * 80,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: mainlisttab.length,
                  itemBuilder: (context, index) {
                    //Traning
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: trainingbox(
                          mainlisttab[index].traningName,
                          mainlisttab[index].image,
                          mainlisttab[index].trainingDatumDateOfTraining,
                          index,
                          mainlisttab[index].janitorsNameList,
                          context),
                    );
                  }),
            ),
          );
  }

  Widget trainingbox(String name, String image, String value, int index,
      List<Janitor> janitors_list, BuildContext context) {
    return Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(10),
      color: customcolor.white,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Tappable Left Section (image + text)
            GestureDetector(
              onTap: () {
                print("tex");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        TrainingDetail(mainlisttab, index),
                  ),
                );
              },
              child: Row(
                children: [
                  image == null
                      ? Icon(Icons.error_outline, size: 50)
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            image,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Icon(Icons.error_outline, size: 50),
                          ),
                        ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: AppFonts.headerStyle(
                          fontSize: ResponsiveFlutter.of(context).fontSize(2),
                          color: customcolor.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        value,
                        style: AppFonts.headerStyle(
                          fontSize: ResponsiveFlutter.of(context).fontSize(1.5),
                          color: customcolor.black,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Spacer(),
            // Trailing 3-dot menu
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        MarkStatusPage(janitors_list, widget.clientname),
                  ),
                );
              },
              child: Text(
                'status',
                style: TextStyle(color: Colors.blue),
              ),
            )
          ],
        ),
      ),
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

  addaddtendance(
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
              height: (role == GlobalLists.unitrole ||
                      role == GlobalLists.headrole ||
                      role == GlobalLists.reginalmanagerrole ||
                      role == GlobalLists.clientrole ||
                      role == GlobalLists.operationrole ||
                      role == GlobalLists.operationmanagerrole)
                  ? SizeConfig.blockSizeVertical * 50 +
                      MediaQuery.of(context).viewInsets.bottom
                  : SizeConfig.blockSizeVertical * 40 +
                      MediaQuery.of(context).viewInsets.bottom,
              color: Colors.white,
              margin: EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 2),
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
                        height: 30,
                      ),
                      Text(
                        "Mark Attendance",
                        textAlign: TextAlign.left,
                        style: AppFonts.headerStyle(
                            fontSize: 22,
                            color: customcolor.black,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      (role == GlobalLists.unitrole ||
                              role == GlobalLists.headrole ||
                              role == GlobalLists.reginalmanagerrole ||
                              role == GlobalLists.clientrole ||
                              role == GlobalLists.operationrole ||
                              role == GlobalLists.operationmanagerrole)
                          ? Column(
                              children: [
                                FormTextField(
                                  textcontroller: sitenamecontroller,
                                  placeholderStr: "Site Name",
                                  suffixWidget: Padding(
                                    padding: EdgeInsets.only(right: 10),
                                    child: Image.asset(
                                      "assets/images/dropdown.png",
                                      width: 20,
                                      height: 20,
                                    ),
                                  ),
                                  textInputType: TextInputType.text,
                                  onchange: (val) {},
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            )
                          : Container(),
                      FormTextField(
                        textcontroller: namecontroller,
                        placeholderStr: "Name",
                        textInputType: TextInputType.text,
                        onchange: (val) {},
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      FormTextField(
                        textcontroller: mobilecontroller,
                        placeholderStr: "Mobile Number",
                        lengthofmobile: 10,
                        //   maxLength: 10,
                        textInputType: TextInputType.phone,
                        onchange: (val) {},
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Image.asset(
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

}
