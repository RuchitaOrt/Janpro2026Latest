import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:janpro/Screens/Homepage.dart';
import 'package:janpro/Screens/RatingDetails.dart';
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
import 'package:janpro/model/AddAttendanceResponse.dart' as addattten;
import 'package:janpro/model/AttendencelistResponse.dart';
import 'package:janpro/model/OperationalRatinggraphwiseResponse.dart';
import 'package:page_transition/page_transition.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart' as permishan;


import 'dart:math' as math;

// class MainList{
// final String name;
// final String priority;

//   MainList(this.name, this.priority);
// }

class Rating extends StatefulWidget {
  final String id;

  Rating(this.id);

  @override
  _RatingState createState() => _RatingState();
}

class _RatingState extends State<Rating> with TickerProviderStateMixin {
  var searchcontroller = new TextEditingController();
  var namecontroller = new TextEditingController();
  var sitenamecontroller = new TextEditingController();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  var mobilecontroller = new TextEditingController();
  var datecontroller = new TextEditingController();
  List<EmployeeList> unitemployeelist = [];
  String selectedValue = "Pending";
  String? lat;
  String? long;
  List<String> listtab = [];
  List<String>? formValue1;
  int tag = 0;
  int maintag = 0;

  String _isSelected = "";
  List<DatumElement> mainlisttab = [];
  late Data attendancedata;
  bool isdataloaded = false;
  List<EmployeeList> searchUserList = [];
  String? role = "1";
  late TabController _tabControllermain;
  final List<Tab> tabsmain = <Tab>[];
  int selectedindex = 0;
  bool showAvg = false;
  int refreshmaintag = 0;
  bool isloading = false;

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
      isloading = true;
      //  maintag=0;
      //     var  datefrom =
      //                                   DateFormat('dd-MM-yyyy').format(DateTime.now());
      // datecontroller.text=datefrom;
      // maintag=0;
      getrole();
    });
  }

  getrole() async {
    role = await SPManager().getroleid();
    opertionalgraphwiseapi();
    if (role == GlobalLists.unitrole ||
        role == GlobalLists.headrole ||
        role == GlobalLists.reginalmanagerrole ||
        role == GlobalLists.clientrole ||
        role == GlobalLists.operationrole ||
        role == GlobalLists.operationmanagerrole) {
      setState(() {
        listtab.add("First Floor");
        listtab.add("Ground Floor");
        listtab.add("Second Floor");

        //  mainlisttab.add(MainList("OverAll","0"));
        //   mainlisttab.add(MainList("IMAX","1"));
        //    mainlisttab.add(MainList("Cinipol","1"));
        //     mainlisttab.add(MainList("Cinimax","0"));
      });
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        //floating action button position to center
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(148),
          child: AppbarComman(
              setStyleStr: 'Rating',
              onPressedBack: () {},
              onPressedNotify: () {},
              onPressedSearch: () {},
              onPressedSort: () {},
              onPressedmenu: () {
                _scaffoldKey1.currentState!.openEndDrawer();
              }),
        ),
        bottomNavigationBar: CustomBottomNavigationBar(index: 3),
        body: SafeArea(
          child:isRatingLoading?Center(child: Column(
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
                    ? Padding(
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
                              // physics: ScrollPhysics(),
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: Text(
                                        "RATING",
                                        style: AppFonts.headerStyle(
                                            fontSize:
                                                ResponsiveFlutter.of(context)
                                                    .fontSize(2.3),
                                            color: customcolor.black,
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ),
                                    //                   (role==GlobalLists.unitrole||role==GlobalLists.headrole||role==GlobalLists.clientrole||role==GlobalLists.operationrole)?
                                    //                     new Container(
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
                                    //                                 GestureDetector(
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
                                        ? _buildChoicemainListForTab()
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
                      )
                    : Container(),
              ),
              (role == GlobalLists.operationrole ||
                      role == GlobalLists.headrole ||
                      role == GlobalLists.reginalmanagerrole ||
                      role == GlobalLists.clientrole ||
                      role == GlobalLists.operationmanagerrole)
                  ? Container()
                  : Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FloatingActionButton(
                          backgroundColor: customcolor.blue,
                          onPressed: () {
                            // addaddtendance(context);
                            // Add your action for the center button here
                          },
                          child: Icon(
                            Icons.add,
                            color: customcolor.white,
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget unitmodule() {
    return isloading
        ? Container()
        : ListView(
            shrinkWrap: true,
            physics: ScrollPhysics(),
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
                height: maintag == 0
                    ? SizeConfig.blockSizeVertical * 62
                    : SizeConfig.blockSizeVertical * 55,
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
                  children: [isloading ? Container() : maintab(maintag)],
                ),
              ),
              maintag == 0
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.only(
                          right: 60, left: 50, bottom: 30, top: 10),
                      /*child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: customcolor.blue,
                          minimumSize: Size(SizeConfig.blockSizeHorizontal * 40,
                              SizeConfig.blockSizeVertical * 6),
                          textStyle: AppFonts.headerStyle(
                              fontSize: 15,
                              color: customcolor.black,
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          print("RATE $mainlisttab[maintag].clientName");
                          Navigator.push(  context,  MaterialPageRoute(
                                  builder: (BuildContext context) => RatingDetails( mainlisttab[maintag].clientName, mainlisttab[maintag].overallRating ==
                                                  0
                                              ? false
                                              : true)));
                        },
                        child: Text(
                          mainlisttab[maintag].overallRating == 0
                              ? 'Add Rating'
                              : "View Rating",
                          style: AppFonts.headerStyle(
                              fontSize: 14,
                              color: customcolor.white,
                              fontWeight: FontWeight.w400),
                        ),
                      ),*/
                      child: role == GlobalLists.reginalmanagerrole ||
                              role == GlobalLists.clientrole
                          ? ElevatedButton(
                              //Add Rating
                              style: ElevatedButton.styleFrom(
                                backgroundColor: customcolor.blue,
                                minimumSize: Size(
                                    SizeConfig.blockSizeHorizontal * 40,
                                    SizeConfig.blockSizeVertical * 6),
                                textStyle: AppFonts.headerStyle(
                                    fontSize: 15,
                                    color: customcolor.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                print("RATE $mainlisttab[maintag].clientName");
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            RatingDetails(
                                                mainlisttab[maintag].clientName,
                                                mainlisttab[maintag]
                                                            .overallRating ==
                                                        0
                                                    ? false
                                                    : true)));
                              },
                              child: Text(
                                mainlisttab[maintag].overallRating == 0
                                    ? 'Add Rating'
                                    : "View Rating",
                                style: AppFonts.headerStyle(
                                    fontSize: 14,
                                    color: customcolor.white,
                                    fontWeight: FontWeight.w400),
                              ),
                            )
                          : (mainlisttab[maintag].overallRating != 0)
                              ? ElevatedButton(
                                  // View Rating
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: customcolor.blue,
                                    minimumSize: Size(
                                        SizeConfig.blockSizeHorizontal * 40,
                                        SizeConfig.blockSizeVertical * 6),
                                    textStyle: AppFonts.headerStyle(
                                        fontSize: 15,
                                        color: customcolor.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () {
                                    print(
                                        "RATE $mainlisttab[maintag].clientName");
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                RatingDetails(
                                                    mainlisttab[maintag]
                                                        .clientName,
                                                    /*mainlisttab[maintag].overallRating ==  0 ? false :*/ true)));
                                  },
                                  child: Text(
                                    // mainlisttab[maintag].overallRating == 0
                                    //     ? 'Add Rating'
                                    //     : "View Rating",
                                    "View Rating",
                                    style: AppFonts.headerStyle(
                                        fontSize: 14,
                                        color: customcolor.white,
                                        fontWeight: FontWeight.w400),
                                  ),
                                )
                              : Container(),
                    ),
            ],
          );
  }

  Widget maintab(int maintag) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
          elevation: 0,
          borderRadius: BorderRadius.circular(10),
          color: customcolor.white,
          child: ListView(
            // mainAxisAlignment: MainAxisAlignment.start,
            shrinkWrap: true,
            physics: ScrollPhysics(),
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8, top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      maintag == 0
                          ? "Overall Rating History"
                          : "Overall Rating",
                      maxLines: 2,
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      style: AppFonts.headerStyle(
                          fontSize: ResponsiveFlutter.of(context).fontSize(2),
                          color: customcolor.title,
                          fontWeight: FontWeight.normal),
                    ),
                    maintag == 0
                        ? Container()
                        : mainlisttab[maintag].review == ""
                            ? Container()
                            : GestureDetector(
                                onTap: () {
                                  namecontroller.text =
                                      mainlisttab[maintag].review;
                                  ratingsheet(context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Image.asset(
                                    'assets/images/review.png',
                                    width: 30,
                                    height: 30,
                                  ),
                                ),
                              ),
                  ],
                ),
              ),
              GlobalLists.ratinggraphlist.length > 0
                  ? maintag == 0
                      ? overallgraph()
                      : overallgraphlist()
                  : Container(),
            ],
          )),
    );
  }

  ratingsheet(BuildContext context) {
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
              height: SizeConfig.blockSizeVertical * 30 +
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
                        "Any key issue to be addressed before next inspection ?",
                        textAlign: TextAlign.center,
                        style: AppFonts.headerStyle(
                            fontSize: 14,
                            color: customcolor.black,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      FormTextField(
                        isEnable: false,
                        textboxcolor: customcolor.skybluebg,
                        textcontroller: namecontroller,
                        placeholderStr: "Write your Review",
                        maxLines: 3,
                        contaninerheigth: 80,
                        textInputType: TextInputType.text,
                        onchange: (val) {},
                      ),
                      SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ],
              ),
            );
          });
        });
  }

  Widget overallgraphlist() {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: maintag == 0 ? 0.8 : 0.9,
          child: Padding(
            padding: const EdgeInsets.only(
              right: 18,
              left: 12,
              top: 15,
              bottom: 4,
            ),
            child: LineChart(
              LineChartSample2.mainDataratinglist(),
            ),
          ),
        ),
      ],
    );
  }

  Widget overallgraph() {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: maintag == 0 ? 0.8 : 0.9,
          child: Padding(
            padding: const EdgeInsets.only(
              right: 18,
              left: 12,
              top: 15,
              bottom: 4,
            ),
            child: LineChart(
              LineChartSample2.mainDatarating(),
            ),
          ),
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
                        : item.status == 0
                            ? customcolor.red
                            : (item.clientName.contains('OverAll')
                                ? customcolor.tabblue
                                : customcolor.green),
                    //:
                    // customcolor.green,
                    fontWeight: FontWeight.bold),
              ),
            ),
            side: BorderSide(
              width: 0.5,
              color: maintag == value
                  ? customcolor.white
                  : item.status == 0
                      ? customcolor.red
                      : (item.clientName.contains('OverAll')
                          ? customcolor.tabblue
                          : customcolor.green),
            ),
            //  :
            // customcolor.green),

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
                if (maintag > 0) {
                  GlobalLists.ratingclienttag = maintag - 1;
                }
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
                                              : item.clientName
                                                      .contains('OverAll')
                                                  ? customcolor.tabblue
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
                                            if (maintag > 0) {
                                              GlobalLists.ratingclienttag =
                                                  maintag - 1;
                                            }
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
bool isRatingLoading=false;
  opertionalgraphwiseapi() async {
    var status1 = await ConnectionDetector.checkInternetConnection();

    if (status1) {
      setState(() {
        mainlisttab = [];
        isloading = true;
        GlobalLists.ratinggraphlist = [];
      });
      
setState(() {
  isRatingLoading=true;
});
      var map = new Map<String, dynamic>();

      var clientid = await SPManager().getclientid();
      var supervisorid = await SPManager().getsupervisorid();
      print(clientid);
      if (role == GlobalLists.clientrole) {
        map['clientid'] = clientid;
      } else {
        map['emp_id'] = supervisorid;
      }
      APIManager().apiRequest(context, API.operationalratinggraphwise,
          (response) async {
        OperationalRatinggraphwiseResponse resp = response;
        print('called API ${resp}');
        if (resp.status == 1) {
          setState(() {
            isloading = false;
            GlobalLists.ratinggraphlist = resp.graphData;
            GlobalLists.ratinglistwisegraphlist = resp.data;
            mainlisttab.add(DatumElement(
                clientName: "OverAll",
                clientId: 0,
                siteId: 0,
                monthWisedata: [],
                overallRating: 0,
                status: 1,
                review: ""));
            for (int i = 0; i < resp.data.length; i++) {
              mainlisttab.add(resp.data[i]);

              if (resp.data[i].clientName == widget.id) {
                //  int selectindex = resp.data.indexWhere((item) => item.clientName == "RMALL - Mulund");
                setState(() {
                  maintag = i + 1;
                  refreshmaintag = i + 1;
                });
              }

              // if(resp.data[i].id)
            }
          });
          setState(() {
  isRatingLoading=false;
});
          // Navigator.of(this.context).pop();
          //  ShowDialogs.showToast(resp.msg);
        } else {
          isloading = false;
          ShowDialogs.showToast(resp.msg);
          setState(() {
  isRatingLoading=false;
});
          // Navigator.of(this.context).pop();
        }
      }, (error) {
        print('ERR msg is $error');
        isloading = false;
        //  Navigator.of(this.context).pop();
      }, false, "", jsonval: map);
    } else {
      ShowDialogs.showToast("Please check internet connection");
    }
  }
}
