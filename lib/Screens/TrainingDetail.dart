

import 'package:carousel_slider/carousel_slider.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:janpro/Utitlity/AppDrawer.dart';
import 'package:janpro/Utitlity/FormTextField.dart';
import 'package:janpro/Utitlity/GlobalLists.dart';
import 'package:janpro/Utitlity/ResponsiveFlutter.dart';
import 'package:janpro/Utitlity/SPManager.dart';
import 'package:janpro/Utitlity/appbar.dart';

import 'package:janpro/Utitlity/custom_color.dart';

import 'package:janpro/Utitlity/sizeConfig.dart';

import 'package:janpro/model/AttendencelistResponse.dart';
import 'package:janpro/model/ClientwisetrainingResponse.dart';




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

class TrainingDetail extends StatefulWidget {
  List<TrainingDatum> trainingData;
  int index;
  TrainingDetail(this.trainingData, this.index);

  @override
  _TrainingDetailState createState() => _TrainingDetailState();
}

class _TrainingDetailState extends State<TrainingDetail>
    with TickerProviderStateMixin {
  var searchcontroller = new TextEditingController();
  var namecontroller = new TextEditingController();
  var sitenamecontroller = new TextEditingController();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  List<String> gallery = [];
  List<T> map<T>(List<String> list, Function handler) {
    List<T> result = [];
    for (var i = 0;
        i < widget.trainingData[widget.index].imageList.length;
        i++) {
      result.add(handler(i, gallery[i]));
      print(result.length);
    }

    print(result.length);
    return result;
  }

  var mobilecontroller = new TextEditingController();
  bool isExpanded = false;

  List<EmployeeList> unitemployeelist = [];
  String selectedValue = "Pending";
  int _current = 0;
  String? lat;
  String? long;
  List<String> listtab = [];
  List<String>? formValue1;
  int tag = 0;
  int maintag = 0;

  String _isSelected = "";
  List<MainList> mainlisttab = [];
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
    gallery.add("value");
    gallery.add("value");
    gallery.add("value");
    getrole();
  }

  Future<void> refreshData() async {
    // Simulating an API request or data refresh
    setState(() {
    
      //     var  datefrom =
      //                                   DateFormat('dd-MM-yyyy').format(DateTime.now());
      // datecontroller.text=datefrom;
      getrole();
    });
  }

  List<Widget> items = [];
  getrole() async {
    role = await SPManager().getroleid();

    for (int i = 0;
        i < widget.trainingData[widget.index].imageList.length;
        i++) {
      items.add(
        Image.network(widget.trainingData[widget.index].imageList[i],
            fit: BoxFit.fill,
            width: SizeConfig.blockSizeHorizontal * 100,
            height: SizeConfig.safeBlockVertical * 60, errorBuilder:
                (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
          return Icon(
            Icons.error_outline,
            size: SizeConfig.blockSizeHorizontal * 10,
          );
        }),
      );
    }
    // [

    //   Image.asset('assets/images/clean2.png',fit: BoxFit.fill, width: SizeConfig.blockSizeHorizontal * 100,height: SizeConfig.safeBlockVertical*60,),
    //     Image.asset('assets/images/clean1.png',fit: BoxFit.fill, width: SizeConfig.blockSizeHorizontal * 100,height: SizeConfig.safeBlockVertical*60,)
    // ];
    if (role == GlobalLists.unitrole ||
        role == GlobalLists.headrole ||
        role == GlobalLists.reginalmanagerrole ||
        role == GlobalLists.clientrole ||
        role == GlobalLists.operationrole ||
        role == GlobalLists.operationmanagerrole) {
      _tabController = new TabController(vsync: this, length: 3);
      setState(() {
        listtab.add("Mathew Reynods");
        listtab.add("Sushma vargas");
        listtab.add("Zeel Ryon");
        listtab.add("Mathew Reynods");
        listtab.add("Ruchita vargas");
        listtab.add("Akshay Rai");
        listtab.add("Mathew Reynods");
        listtab.add("Sushma vargas");
        listtab.add("Zeel Ryon");

        mainlisttab.add(MainList("OverAll", "0"));
        mainlisttab.add(MainList("IMAX", "0"));
        mainlisttab.add(MainList("Cinipol", "0"));
        mainlisttab.add(MainList("Cinimax", "0"));
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

  int currentIndex = 0;

  final GlobalKey<ScaffoldState> _scaffoldKey1 = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            setStyleStr: 'TRAINING AGENDA',
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
                ? Container(
                    //  height: SizeConfig.blockSizeVertical*90,
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
                      child: Container(
                        height: SizeConfig.blockSizeVertical * 90,
                        child: ListView(
                          shrinkWrap: true,
                          //    physics: ScrollPhysics(),
                          children: [
                            gifcontainer(context),
                            // DotsIndicator(
                            //   dotsCount: items.length,
                            //   position: currentIndex.toDouble(),
                            // )
                            // Container(
                            //     //color: Colors.amber,
                            //     width: SizeConfig.blockSizeHorizontal * 100,
                            //     child: Container(
                            //       width: MediaQuery.of(context).size.width,
                            //       // //  margin: EdgeInsets.symmetric(horizontal: 5.0),
                            //       // padding: EdgeInsets.only(
                            //       //   left: 18,
                            //       //   right: 18,
                            //       //   bottom: 40,
                            //       //   top: SizeConfig.blockSizeVertical * 18,
                            //       // ),
                            //       decoration: BoxDecoration(
                            //         image: DecorationImage(
                            //             image: AssetImage( 'assets/images/image1.png'),
                            //             fit: BoxFit.fill),
                            //       ),
                            //       child: gifcontainer(context),
                            //     ),),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          GestureDetector(
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                              child: Icon(Icons.arrow_back)),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Container(
                                            child: Text(
                                              "${widget.trainingData[widget.index].traningName}",
                                              style: AppFonts.headerStyle(
                                                  fontSize:
                                                      ResponsiveFlutter.of(
                                                              context)
                                                          .fontSize(2.3),
                                                  color: customcolor.black,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, top: 10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        widget.trainingData[widget.index]
                                                    .trainingDatumDateOfTraining ==
                                                null
                                            ? Text("")
                                            : Text(
                                                "${widget.trainingData[widget.index].trainingDatumDateOfTraining}",
                                                style: AppFonts.headerStyle(
                                                    fontSize:
                                                        ResponsiveFlutter.of(
                                                                context)
                                                            .fontSize(1.8),
                                                    color: customcolor.black,
                                                    fontWeight:
                                                        FontWeight.w300),
                                              ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Text(
                                          "TRAINING AGENDA",
                                          style: AppFonts.headerStyle(
                                              fontSize:
                                                  ResponsiveFlutter.of(context)
                                                      .fontSize(1.8),
                                              color: customcolor.black,
                                              fontWeight: FontWeight.w300),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        // var string = list.join(',');
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              widget.trainingData[widget.index]
                                                  .traningAgendaName
                                                  .join('|'),
                                              maxLines: isExpanded ? null : 2,
                                              overflow: isExpanded
                                                  ? TextOverflow.visible
                                                  : TextOverflow.ellipsis,
                                              style: AppFonts.headerStyle(
                                                fontSize: ResponsiveFlutter.of(
                                                        context)
                                                    .fontSize(2),
                                                color: customcolor.black,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),

                                            // Show the toggle only if there's more than 1 agenda item
                                            if (widget
                                                    .trainingData[widget.index]
                                                    .traningAgendaName
                                                    .length >
                                                3)
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    isExpanded = !isExpanded;
                                                  });
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 5),
                                                  child: Text(
                                                    isExpanded
                                                        ? 'Show less'
                                                        : 'Show more',
                                                    style: TextStyle(
                                                      color: customcolor.blue,
                                                      fontSize:
                                                          ResponsiveFlutter.of(
                                                                  context)
                                                              .fontSize(1.6),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "Names of janitors trained",
                                          //"Number of Janitors Trained",
                                          style: AppFonts.headerStyle(
                                              fontSize:
                                                  ResponsiveFlutter.of(context)
                                                      .fontSize(2),
                                              color: customcolor.black,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),

                                  //workflow
                                  SizedBox(
                                    height: 10,
                                  ),
                                  headmodule(),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                : Container(),
          ),
        ],
      ),
    );
  }

  Widget gifcontainer(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: SizeConfig.blockSizeHorizontal * 100,
          height: SizeConfig.safeBlockVertical * 60,
          // color: customcolor.black,
          child: CarouselSlider(
            options: CarouselOptions(
              viewportFraction: 1,
              autoPlay: false,
              aspectRatio: 0.1,
              enlargeCenterPage: true,
              onPageChanged: (index, reason) {
                setState(() {
                  currentIndex = index;
                });
              },
            ),
            items: items,
          ),
        ),
        Center(
          child: Container(
            width: SizeConfig.blockSizeHorizontal * 100,
            height: SizeConfig.blockSizeVertical * 55,
            // color: Color(0xff000000).withOpacity(0.6),
            //Colors.transparent.withOpacity(0.6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children:
                      map<Widget>(widget.trainingData[widget.index].imageList,
                          (index, url) {
                    return Container(
                      width: currentIndex == index ? 30.0 : 8,
                      height: 8.0,
                      margin:
                          EdgeInsets.symmetric(vertical: 2.0, horizontal: 3.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        //  shape: BoxShape,
                        color: currentIndex == index
                            ? customcolor.white
                            : customcolor.white,
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),

        // ),
      ],
    );
  }

  Widget headmodule() {
    return ListView(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      children: [
        Container(
          // height: SizeConfig.blockSizeVertical*100,
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
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 0, bottom: 10),
                child: Wrap(
                  spacing: 5.0,
                  runSpacing: 1.0,
                  children: _buildChoiceList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  _buildChoiceList() {
    List<Widget> choices = [];
    widget.trainingData[widget.index].janitorsNameList
        .forEachIndexed((item, value) {
      choices.add(Container(
        child: ChoiceChip(
          label: Text(
            item.janitorsName,
            style: AppFonts.headerStyle(
                fontSize: 12,
                color:
                    item.status == false ? customcolor.red : customcolor.blue,
                fontWeight: FontWeight.normal),
          ),
          // shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20))),
          labelStyle: AppFonts.headerStyle(
              fontSize: 12,
              color: tag == value ? customcolor.blue : customcolor.tabblue,
              fontWeight: FontWeight.normal),

          selectedColor: item.status == false
              ? customcolor.red.withOpacity(0.2)
              : customcolor.blue.withOpacity(0.2),
          backgroundColor: item.status == false
              ? customcolor.red.withOpacity(0.2)
              : customcolor.blue.withOpacity(0.2),
          selected: tag == value,
          onSelected: (selected) {
            setState(() {
              _isSelected = item.janitorsName;
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
