import 'dart:convert';
import 'dart:developer';

import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:janpro/Screens/TrainingDetail.dart';
import 'package:janpro/Utitlity/appbar.dart';
import 'package:janpro/Utitlity/custom_color.dart';
import '../Utitlity/APIManager.dart';
import '../Utitlity/AppDrawer.dart';
import '../Utitlity/GlobalLists.dart';
import '../Utitlity/ResponsiveFlutter.dart';
import '../Utitlity/SPManager.dart';
import '../Utitlity/ShowDialog.dart';
import '../Utitlity/internetConnection.dart';
import '../Utitlity/linechart.dart';
import '../Utitlity/sizeConfig.dart';
import '../model/ClientOperationResponse.dart' as visit;
import 'Homepage.dart';

import 'client_operation_visti_card.dart';

class ClientVisitView extends StatefulWidget {
  const ClientVisitView({super.key});

  @override
  State<ClientVisitView> createState() => _ClientVisitViewState();
}

class _ClientVisitViewState extends State<ClientVisitView> {
  final GlobalKey<ScaffoldState> _scaffoldKey1 = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    // _isSelected = mainlisttab[0].clientName;
    GlobalLists.clientname = '';
    // GlobalLists.traningclienttag = maintag - 1;
    // GlobalLists.visitGraphlist = mainlisttab[maintag].graphData;
    // GlobalLists.opersationvisitview = mainlisttab[maintag].visitData;
    print('mainlisttab ${mainlisttab}');

    super.initState();
    getrole();
  }

  Future<void> refreshData() async {
    setState(() {
      getrole();
    });

    // await traininglistApi();
  }

  String? role = "1";
  getrole() async {
    setState(() {});

    role = await SPManager().getroleid();
    await visitgraphApi();
    // await traininglistApi();
  }

  var client_id;
  var site_id;

  int tag = 0;
  int maintag = 0;
  final GlobalKey<State> _keyLoader1 = new GlobalKey<State>();

  String _isSelected = "";
  List<visit.Datum> mainlisttab = [];

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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(148),
        child: AppbarComman(
            setStyleStr: 'VISIT',
            onPressedBack: () {},
            onPressedNotify: () {},
            onPressedSearch: () {},
            onPressedSort: () {},
            onPressedmenu: () {
              _scaffoldKey1.currentState!.openEndDrawer();
            }),
      ),
      body:isOperationVisit?Center(child: Column(
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Column(
                children: [
                  Container(
                      child: mainlisttab.length > 0
                          ? Padding(
                              padding: const EdgeInsets.only(
                                  left: 5, right: 5, top: 10, bottom: 0),
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
                                                "SITE VISIT",
                                                style: AppFonts.headerStyle(
                                                    fontSize:
                                                        ResponsiveFlutter.of(
                                                                context)
                                                            .fontSize(2.3),
                                                    color: customcolor.black,
                                                    fontWeight:
                                                        FontWeight.w300),
                                              ),
                                            ),
                                          ],
                                        ),
                                        mainlisttab.length > 1
                                            ? _buildChoicemainListForTab()
                                            : SizedBox()
                                        //add here
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    headmodule()
                                  ],
                                ),
                              ),
                            )
                          : ShowDialogs.norecordwidget(
                              SizeConfig.blockSizeHorizontal * 35,
                              SizeConfig.blockSizeVertical * 42))
                ],
              ),
            ),
          ),
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
                  setState(() {
                    GlobalLists.visitClintId =
                        GlobalLists.visitgraphlist[maintag].clientId;
                    GlobalLists.visitSiteId =
                        GlobalLists.visitgraphlist[maintag].siteId.toString();
                    GlobalLists.clienname = GlobalLists
                        .visitgraphlist[maintag].clientName
                        .toString();
                    print(
                        'GlobalLists.clienname ${GlobalLists.clienname} GlobalLists.visitClintId ${GlobalLists.visitClintId}GlobalLists.visitSiteId${GlobalLists.visitSiteId}');
                  });
                  // print(mainlisttab[maintag].trainingData[0].trainingDatumDateOfTraining);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              ClientOperationVisitCard(
                                client_id: GlobalLists
                                    .visitgraphlist[maintag].clientId,
                                site_id:
                                    GlobalLists.visitgraphlist[maintag].siteId,
                              )));
                },
                child: Text(
                  'View visit details',
                  style: AppFonts.headerStyle(
                      fontSize: 14,
                      color: customcolor.white,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget overallgraph() {
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: GlobalLists.maxVisitCount <= 10 ? 1.15 : 0.82,
          child: Padding(
            padding: const EdgeInsets.only(
              right: 18,
              left: 12,
              top: 24,
              bottom: 4,
            ),
            child: LineChart(
              LineChartSample2.mainDavistes(),
            ),
          ),
        ),
      ],
    );
  }

  Widget viewOperation(String name, String value) {
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

  Widget maintab(int maintag) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        // mainAxisAlignment: MainAxisAlignment.start,
        shrinkWrap: true,
        physics: ScrollPhysics(),
        children: [
          viewOperation("Total number of visits done",
              '${GlobalLists.visitgraphlist[maintag].totalNumberOfVisit}'),
          SizedBox(
            height: 5,
          ),
          viewOperation("Visit done this month",
              "${GlobalLists.visitgraphlist[maintag].visitDone}"),
          SizedBox(
            height: 15,
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
                    "Visit count",
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
          ),
        ],
      ),
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
              )),
          Container(
            height: SizeConfig.blockSizeVertical * 65,
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
                client_id = item.clientId;
                site_id = item.siteId;
                GlobalLists.visitClintId = item.clientId;
                GlobalLists.visitSiteId = item.siteId;

                GlobalLists.clientname = item.clientName;
                GlobalLists.traningclienttag = maintag - 1;
                GlobalLists.visitGraphlist = mainlisttab[maintag].graphData;
                GlobalLists.opersationvisitview =
                    mainlisttab[maintag].visitData;

                int maxVisitCount = 0;

                for (var data in GlobalLists.visitGraphlist) {
                  int totalVisit =
                      int.tryParse(data.percentage.toString()) ?? 0;
                  if (totalVisit > maxVisitCount) {
                    maxVisitCount = totalVisit;
                  }
                }

                // ✅ Store globally
                GlobalLists.maxVisitCount = maxVisitCount;
                print(" Max Total Number of Visit: $maxVisitCount");

                // Store it globally or use it directly
                GlobalLists.maxVisitCount = maxVisitCount;

                print(" Max Total Number of Visit: $maxVisitCount");
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
                                            client_id = item.clientId;
                                            site_id = item.siteId;
                                            GlobalLists.visitClintId =
                                                item.clientId;
                                            GlobalLists.visitSiteId =
                                                item.siteId;

                                            GlobalLists.clientname =
                                                item.clientName;
                                            GlobalLists.traningclienttag =
                                                maintag - 1;
                                            GlobalLists.visitGraphlist =
                                                mainlisttab[maintag].graphData;
                                            GlobalLists.opersationvisitview =
                                                mainlisttab[maintag].visitData;

                                            int maxVisitCount = 0;
                                            for (var item
                                                in GlobalLists.visitGraphlist) {
                                              int totalVisit = int.tryParse(item
                                                      .percentage
                                                      .toString()) ??
                                                  0;
                                              if (totalVisit > maxVisitCount) {
                                                maxVisitCount = totalVisit;
                                              }
                                            }

                                            // Store it globally or use it directly
                                            GlobalLists.maxVisitCount =
                                                maxVisitCount;

                                            print(
                                                " Max Total Number of Visit: $maxVisitCount");
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
bool isOperationVisit=false;
  visitgraphApi() async {
    var status1 = await ConnectionDetector.checkInternetConnection();
    setState(() {
      mainlisttab = [];
    });

    if (status1) {
     
setState(() {
  isOperationVisit=true;
});
      var map = new Map<String, dynamic>();

      var clientid = await SPManager().getclientid();

      var roles = await SPManager().getsupervisorid();

      if (role == GlobalLists.clientrole) {
        map['client_id'] = clientid;
      } else {
        map['emp_id'] = roles;
      }

      APIManager().apiRequest(context, API.visitwiseList, (response) async {
        visit.ClientOperationResponse resp = response;

        if (resp.status == 1) {
          GlobalLists.visitgraphlist = resp.data;
          setState(() {
  isOperationVisit=false;
});
          // Navigator.of(this.context).pop();
          //   ShowDialogs.showToast(resp.msg);
          setState(() {
            // isdataloaded = true;
            // GlobalLists.ratinggraphlist=resp.;

            for (int i = 0; i < resp.data.length; i++) {
              mainlisttab.add(resp.data[i]);

              if (resp.data[i].clientName == GlobalLists.clientname) {
                //  int selectindex = resp.data.indexWhere((item) => item.clientName == "RMALL - Mulund");
                setState(() {
                  maintag = i;
                  print(maintag.toString());
                });
              }
            }
            GlobalLists.opersationvisitview = mainlisttab[maintag].visitData;
            GlobalLists.visitGraphlist = mainlisttab[maintag].graphData;

            int maxVisitCount = 0;
            for (var item in GlobalLists.visitGraphlist) {
              int totalVisit = int.tryParse(item.percentage.toString()) ?? 0;
              if (totalVisit > maxVisitCount) {
                maxVisitCount = totalVisit;
              }
            }

            // Store it globally or use it directly
            GlobalLists.maxVisitCount = maxVisitCount;

            print(" Max Total Number of Visit: $maxVisitCount");
          });
        } else {
          log("resp.status.toString()");
           setState(() {
  isOperationVisit=false;
});
          //  ShowDialogs.showToast(resp.msg);
          // Navigator.of(this.context).pop();
        }
      }, (error) {
        log('ERR msg is $error');
        ShowDialogs.showToast("Server Not Responding");
         setState(() {
  isOperationVisit=false;
});
        // Navigator.of(this.context).pop();
      }, false, "", jsonval: map);
    } else {
      ShowDialogs.showToast("Please check internet connection");
    }
  }
}
