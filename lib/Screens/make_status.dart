import 'dart:convert';
import 'dart:developer';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:janpro/Screens/Training.dart';
import 'package:janpro/Utitlity/custom_color.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../DBHelper/db_helper.dart';
import '../Utitlity/APIManager.dart';
import '../Utitlity/AppDrawer.dart';
import '../Utitlity/ResponsiveFlutter.dart';
import '../Utitlity/SPManager.dart';
import '../Utitlity/ShowDialog.dart';
import '../Utitlity/appbar.dart';
import '../Utitlity/internetConnection.dart';
import '../Utitlity/sizeConfig.dart';
import '../const/global.dart';
import '../model/ClientwisetrainingResponse.dart';

class MarkStatusPage extends StatefulWidget {
  final List<Janitor> janitors_list;
  String clientname;

  MarkStatusPage(this.janitors_list, this.clientname, {Key? key})
    : super(key: key);

  @override
  _MarkStatusPageState createState() => _MarkStatusPageState();
}

class _MarkStatusPageState extends State<MarkStatusPage> {
  late List<Map<dynamic, dynamic>> janitorsStatusList;
  final GlobalKey<State> _marksttaus = GlobalKey<State>();
  late String? role = "";

  @override
  void initState() {
    super.initState();
    getrole();

    janitorsStatusList = widget.janitors_list.map((janitor) {
      return {
        "janitor": janitor,
        "status": janitor.status == true
            ? "Pass"
            : janitor.status == false
            ? "Fail"
            : null,
        "canEdit": false,
      };
    }).toList();
  }

  getrole() async {
    role = await SPManager().getroleid();
    log('role $role');

    setState(() {
      for (var entry in janitorsStatusList) {
        final status = entry['status'];
        entry['canEdit'] = (role == '3' || role == '4')
            ? (status == null || status == '')
            : (role == '5')
            ? (status != null && status != '')
            : false;
      }
    });
  }

  void updateStatus(int index, String newStatus) {
    setState(() {
      janitorsStatusList[index]['status'] = newStatus;
    });
  }

  void markAll(String status) {
    print('role $role  status $status');

    setState(() {
      for (var entry in janitorsStatusList) {
        final currentStatus = entry['status'];

        if (role == '3' || role == '4') {
          if (entry['canEdit'] == true) {
            entry['status'] = status.isEmpty ? null : status;
          }
        } else if (role == '5') {
          if (entry['canEdit'] == true ||
              (currentStatus != null && currentStatus != '')) {
            entry['status'] = status.isEmpty ? null : status;

            entry['canEdit'] = true;
          }
        }
      }
    });
  }

  bool isSubmitEnabled() {
    return janitorsStatusList.any((e) => e['canEdit'] == true);
  }

  final GlobalKey<ScaffoldState> _scaffoldKey1 = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final total = janitorsStatusList.length;
    final passed = janitorsStatusList
        .where((e) => e['status'] == 'Pass')
        .length;
    return Scaffold(
      key: _scaffoldKey1,
      backgroundColor: customcolor.greybg,
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
          },
        ),
      ),
      endDrawer: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: customcolor.blue,
          primaryColor: customcolor.blue,
        ),
        child: AppDrawerfilter(role),
      ),

      body: CustomRefreshIndicator(
        builder:
            (
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
                top: 20,
                bottom: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.arrow_back),
                      ),
                      SizedBox(width: 10),
                      Container(
                        child: Text(
                          "Mark Janitor Status",
                          style: AppFonts.headerStyle(
                            fontSize: ResponsiveFlutter.of(
                              context,
                            ).fontSize(2.3),
                            color: customcolor.title,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),

                  if (role == '3' || role == '4' || role == '5')
                    PopupMenuButton<String>(
                      onSelected: (value) => markAll(value),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'Pass',
                          child: Text("Mark all as pass"),
                        ),
                        PopupMenuItem(
                          value: 'Fail',
                          child: Text("Mark all as fail"),
                        ),
                        PopupMenuItem(value: '', child: Text("Clear all")),
                      ],
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Material(
                elevation: 2,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: SizeConfig.blockSizeHorizontal * 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 8,
                          right: 8,
                          top: 6,
                          bottom: 6,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(width: SizeConfig.blockSizeHorizontal * 2),
                            Container(
                              width: SizeConfig.blockSizeHorizontal * 60,
                              child: Text(
                                "Passed",
                                maxLines: 2,
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                style: AppFonts.headerStyle(
                                  fontSize: ResponsiveFlutter.of(
                                    context,
                                  ).fontSize(2.5),
                                  color: customcolor.textblue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              // color: customcolor.appbarcolor,
                              child: CircularPercentIndicator(
                                animationDuration: 500,
                                radius: 40.0,
                                lineWidth: 6.0,
                                animation: true,
                                percent: total == 0 ? 0.0 : passed / total,
                                center: Text(
                                  "$passed/$total",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: customcolor.textyellow,
                                  ),
                                ),
                                circularStrokeCap: CircularStrokeCap.round,
                                progressColor: customcolor.textblue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemCount: janitorsStatusList.length,
                separatorBuilder: (_, __) => Divider(height: 1),
                itemBuilder: (context, index) {
                  final janitor =
                      janitorsStatusList[index]['janitor'] as Janitor;
                  final status = janitorsStatusList[index]['status'];
                  final canEdit = janitorsStatusList[index]['canEdit'];

                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 12,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                // if (!canEdit)
                                //   Icon(Icons.lock, size: 16, color: Colors.grey),
                                // SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    janitor.janitorsName,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          (role == '6' || role == '7')
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.start,

                                  mainAxisSize: MainAxisSize.min,

                                  crossAxisAlignment: CrossAxisAlignment.center,

                                  children: [
                                    Text(
                                      status == null ? 'Pending' : status!,

                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                )
                              : Row(
                                  children: [
                                    Row(
                                      children: [
                                        Radio<String>(
                                          activeColor: customcolor.blue,
                                          value: 'Pass',
                                          groupValue: status,
                                          onChanged: canEdit
                                              ? (val) =>
                                                    updateStatus(index, val!)
                                              : null,
                                        ),
                                        Text('Pass'),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Radio<String>(
                                          activeColor: customcolor.red,
                                          value: 'Fail',
                                          groupValue: status,
                                          onChanged: canEdit
                                              ? (val) =>
                                                    updateStatus(index, val!)
                                              : null,
                                        ),
                                        Text('Fail'),
                                      ],
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            (role == '6' || role == '7')
                ? Container()
                : Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ElevatedButton.icon(
                      onPressed: isSubmitEnabled() ? () => markestatus() : null,
                      icon: Icon(Icons.save),
                      label: isSubmitLoader
                          ? CircularProgressIndicator(color: customcolor.white)
                          : Text("Submit"),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size.fromHeight(50),
                        backgroundColor: isSubmitEnabled()
                            ? customcolor.blue
                            : Colors.grey,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Future<void> refreshData() async {
    print("REFRESH");
    getrole();

    janitorsStatusList = widget.janitors_list.map((janitor) {
      return {
        "janitor": janitor,
        "status": janitor.status == true
            ? "Pass"
            : janitor.status == false
            ? "Fail"
            : null,
        "canEdit": false,
      };
    }).toList();
  }

  bool isSubmitLoader = false;
  markestatus() async {
    var status = await ConnectionDetector.checkInternetConnection();

    final List<Map<String, dynamic>> dynamicList = janitorsStatusList
        .where((e) => e['canEdit'] == true)
        .map((entry) {
          final janitor = entry['janitor'] as Janitor;
          final status = entry['status'];
          return {
            "id": janitor.id,
            "user_status": status == 'Pass'
                ? true
                : status == 'Fail'
                ? false
                : null,
          };
        })
        .toList();

    final payload = {"janitors_status_list": dynamicList};

    log(jsonEncode(payload));

    if (status) {
      // ShowDialogs.showLoadingDialog(context, _marksttaus);
      setState(() {
        isSubmitLoader = true;
      });
      try {
        final response = await http.post(
          Uri.parse(APIManager.markstatus),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
          },
          body: jsonEncode(payload),
        );

        // Navigator.pop(context);
        setState(() {
          isSubmitLoader = false;
        });
        if (response.statusCode == 200) {
          final res = json.decode(response.body);
          log("✅ Response: $res");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Training(widget.clientname),
            ),
          );
          ShowDialogs.showToast(res['msg'] ?? 'Marked successfully');
        } else {
          final res = json.decode(response.body);
          ShowDialogs.showToast(res['msg'] ?? 'Something went wrong');
        }
      } catch (e) {
        setState(() {
          isSubmitLoader = false;
        });
        // Navigator.pop(context);
        ShowDialogs.showToast("Error: ${e.toString()}");
      }
    } else {
      print('store in local');
      await DBHelper.insertOfflineRequest(
        '${Global.baseUrl}/api/trainingmaster/update_janitor_status',
        payload,
        isMultipart: false,
      );
      ShowDialogs.showToast("Saved offline. Will sync when connected.");
      setState(() {
        isSubmitLoader = false;
      });
      // Navigator.pop(context);
    }
  }
}
