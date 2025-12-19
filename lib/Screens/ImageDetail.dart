
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:geolocator/geolocator.dart';
import 'package:janpro/Screens/Homepage.dart';
import 'package:janpro/Screens/SpecialActivity.dart';
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
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart' as permishan;



import 'dart:math' as math;

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

class ImageDetail extends StatefulWidget {
  List<ImageList> imagelist;
  int currentindex;
  String title;
  ImageDetail(this.imagelist, this.currentindex, this.title);

  @override
  _ImageDetailState createState() => _ImageDetailState();
}

class _ImageDetailState extends State<ImageDetail>
    with TickerProviderStateMixin {
  var searchcontroller = new TextEditingController();
  var namecontroller = new TextEditingController();
  var sitenamecontroller = new TextEditingController();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  List<String> gallery = [];
  List<T> map<T>(List<ImageList> list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < widget.imagelist.length; i++) {
      result.add(handler(i, widget.imagelist[i]));
      print(result.length);
    }

    print(result.length);
    return result;
  }

  var mobilecontroller = new TextEditingController();

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
  List<Widget> items = [];
  @override
  void initState() {
    super.initState();

    print("date ");
    gallery.add("value");
    gallery.add("value");
    gallery.add("value");
    getrole();
  }

  getrole() async {
    role = await SPManager().getroleid();
    print(role);
    setState(() {
      currentIndex = widget.currentindex;
      items = [
        Image.network(
          "${widget.imagelist[0].imagename}",
          fit: BoxFit.fill,
          width: SizeConfig.blockSizeHorizontal * 100,
          height: SizeConfig.safeBlockVertical * 80,
          loadingBuilder: (BuildContext context, Widget child,
              ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          },
        ),
        Image.network(
          "${widget.imagelist[1].imagename}",
          fit: BoxFit.fill,
          width: SizeConfig.blockSizeHorizontal * 100,
          height: SizeConfig.safeBlockVertical * 80,
          loadingBuilder: (BuildContext context, Widget child,
              ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          },
        ),
        Image.network(
          "${widget.imagelist[2].imagename}",
          fit: BoxFit.fill,
          width: SizeConfig.blockSizeHorizontal * 100,
          height: SizeConfig.safeBlockVertical * 80,
          loadingBuilder: (BuildContext context, Widget child,
              ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          },
        ),
        Image.network(
          "${widget.imagelist[3].imagename}",
          fit: BoxFit.fill,
          width: SizeConfig.blockSizeHorizontal * 100,
          height: SizeConfig.safeBlockVertical * 80,
        )
      ];
    });
  }

  int currentIndex = 0;

  final GlobalKey<ScaffoldState> _scaffoldKey1 = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) =>
                SpecialActivity(""),
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

        body: 
        Stack(
          children: [
            SingleChildScrollView(
                physics: ScrollPhysics(),
                child: Container(
                  height: SizeConfig.blockSizeVertical * 90,
                  child: ListView(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    children: [
                      Padding(
                        padding:
        
                            const EdgeInsets.only(left: 8, top: 15, bottom: 15),
                        child: Row(
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
                                "${widget.title}",
                                style: AppFonts.headerStyle(
                                    fontSize: ResponsiveFlutter.of(context)
                                        .fontSize(2.3),
                                    color: customcolor.black,
                                    fontWeight: FontWeight.w300),
                              ),
                            ),
                          ],
                        ),
                      ),
                      gifcontainer(context),
                    ],
                  ),
                )
                // :Container(),
                ),
          ],
        ),
      ),
    );
  }
Widget gifcontainer(BuildContext context) {
  final double screenHeight = SizeConfig.blockSizeVertical * 80;
  final double imageHeight = screenHeight * 0.9;
  final double bottomHeight = screenHeight * 0.1;

  return Column(
    children: [
      // 🖼️ Image Carousel (90%)
      SizedBox(
        height: imageHeight,
        width: SizeConfig.blockSizeHorizontal * 100,
        child: CarouselSlider.builder(
          itemCount: widget.imagelist.length,
          itemBuilder: (context, index, realIndex) {
            return Image.network(
              widget.imagelist[index].imagename ?? "",
              fit: BoxFit.contain, // handles horizontal & vertical images
              width: double.infinity,
              height: imageHeight,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey.shade200,
                alignment: Alignment.center,
                child: const Icon(Icons.broken_image,
                    size: 60, color: Colors.grey),
              ),
              loadingBuilder:
                  (BuildContext context, Widget child, ImageChunkEvent? progress) {
                if (progress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: progress.expectedTotalBytes != null
                        ? progress.cumulativeBytesLoaded /
                            progress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
            );
          },
          options: CarouselOptions(
            viewportFraction: 1,
            autoPlay: false,
            enableInfiniteScroll: false,
            enlargeCenterPage: false,
            height: imageHeight,
            onPageChanged: (index, reason) {
              setState(() {
                currentIndex = index;
              });
            },
          ),
        ),
      ),

      // 📄 Bottom Info (10%)
      SizedBox(
        height: bottomHeight,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Before/After Text
              Text(
                (currentIndex == 0 || currentIndex == 2)
                    ? "Before"
                    : "After",
                style: AppFonts.headerStyle(
                  fontSize:
                      ResponsiveFlutter.of(context).fontSize(2),
                  color: customcolor.tabblue,
                  fontWeight: FontWeight.w500,
                ),
              ),

              // Dots Indicator
              Row(
                children: map<Widget>(widget.imagelist, (index, url) {
                  return Container(
                    width: currentIndex == index ? 20.0 : 8.0,
                    height: 8.0,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 3.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: currentIndex == index
                          ? customcolor.tabblue
                          : Color.fromARGB(255, 174, 112, 112),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

//   Widget gifcontainer(BuildContext context) {
//     return Stack(
//       children: <Widget>[
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Container(
//             width: SizeConfig.blockSizeHorizontal * 100,
//             height: SizeConfig.safeBlockVertical * 78,
//             // color: customcolor.black,
//             child: CarouselSlider(
//               options: CarouselOptions(
//                 viewportFraction: 1,
//                 autoPlay: false,
//                 aspectRatio: 0.1,
//                 enlargeCenterPage: true,
//                 onPageChanged: (index, reason) {
//                   setState(() {
//                     currentIndex = index;
//                   });
//                 },
//               ),
//               items: items,
//             ),
//           ),
//         ),
//         Center(
//           child: Container(
//             width: SizeConfig.blockSizeHorizontal * 100,
//             height: SizeConfig.blockSizeVertical *80,
//             // color: Color(0xff000000).withOpacity(0.6),
//             //Colors.transparent.withOpacity(0.6),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: <Widget>[
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text(
//                         (currentIndex == 0 || currentIndex == 2)
//                             ? "Before"
//                             : "After",
//                         style: AppFonts.headerStyle(
//                             fontSize: ResponsiveFlutter.of(context).fontSize(2),
//                             color: customcolor.tabblue,
//                             fontWeight: FontWeight.normal),
//                       ),
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: map<Widget>(widget.imagelist, (index, url) {
//                         return Column(
//                           children: [
                         
//                             Container(
//                               width: currentIndex == index ? 30.0 : 8,
//                               height: 8.0,
//                               margin: EdgeInsets.symmetric(
//                                   vertical: 2.0, horizontal: 3.0),
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(10),
//                                 //  shape: BoxShape,
//                                 color: currentIndex == index
//                                     ? customcolor.tabblue
//                                     : customcolor.white,
//                               ),
//                             ),
//                           ],
//                         );
//                       }),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),

//         // ),
//       ],
//     );
//   }
 }
