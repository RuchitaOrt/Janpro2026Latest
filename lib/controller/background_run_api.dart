import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:janpro/model/Workflowoperationalmodel.dart' as newopera;
import 'package:janpro/model/OperationalWorkflowResponse.dart' as operwf;
import 'package:janpro/model/WorkflowoperationalDetailmodel.dart'
    as newoperdetail;
import '../Screens/Training.dart';
import '../Utitlity/APIManager.dart';
import '../Utitlity/GlobalLists.dart';
import '../Utitlity/SPManager.dart';
import '../Utitlity/ShowDialog.dart';
import '../Utitlity/internetConnection.dart';
import '../model/AttendencelistResponse.dart';
import '../model/JanitorslistResponse.dart';
import 'package:janpro/model/unitAttendanceResponse.dart' as unitatt;
import 'package:janpro/Utitlity/custom_color.dart';

import '../model/WorkfowstatusResponse.dart';

class backGroundRun {
  // var datecontroller = new TextEditingController();
  // List<unitatt.Datum> mainlisttab = [];

  // List<Janitorcheckbox> dropdownList = [];
  // late Data attendancedata;

//Attendance api

  janotoragendaApi(String idclient, String idsite, BuildContext context) async {
    var status1 = await ConnectionDetector.checkInternetConnection();

    log(" Enter JANITORSUPER");
    GlobalLists.dropdownList = [];

    var map = {
      'client_id': idclient,
      'site_id': idsite,
    };

    log('janitor ${map}');

    final cacheKey = 'cached_janitor_${idclient}_$idsite';

    if (status1) {
      // ✅ ONLINE mode
      APIManager().apiRequest(context, API.janitorslist, (response) async {
        JanitorslistResponse resp = response;

        if (resp.status == 1) {
          GlobalLists.dropdownList = resp.data.map((e) {
            return Janitorcheckbox(
                e.janName.toString(), e.id.toString(), false, e.contact);
          }).toList();

          log('called JANITOR LENGTH ${GlobalLists.dropdownList}');

          // ✅ Save response to local cache
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(cacheKey, json.encode(resp.toJson()));

          log('janotoragendaApi Done');
        } else {
          // ShowDialogs.showToast(resp.msg);
        }
      }, (error) {
        print('ERR msg is $error');
      }, false, "", jsonval: map);
    } else {
      // 🚫 OFFLINE mode
      final prefs = await SharedPreferences.getInstance();
      String? cachedData = prefs.getString(cacheKey);

      if (cachedData != null) {
        JanitorslistResponse cachedResp =
            JanitorslistResponse.fromJson(json.decode(cachedData));

        GlobalLists.dropdownList = cachedResp.data
            .map((e) => Janitorcheckbox(
                e.janName.toString(), e.id.toString(), false, e.contact))
            .toList();

        // ShowDialogs.showToast("Offline janitor list loaded");
      } else {
        // ShowDialogs.showToast("No internet and no cached janitor data found");
      }
    }
  }

  unitattendanceApi(BuildContext context, String? role) async {
    log(" Enter unitattendanceApi");

    var status1 = await ConnectionDetector.checkInternetConnection();
    final prefs = await SharedPreferences.getInstance();

    var clientid = await SPManager().getclientid();
    var supervisorid = await SPManager().getsupervisorid();

    final cacheKey =
        'cached_unitattendance_${GlobalLists.datecontroller.text}_${clientid ?? supervisorid}';

    Map<String, dynamic> map = {
      'date': GlobalLists.datecontroller.text,
    };

    if (role == GlobalLists.clientrole) {
      map['clientid'] = clientid;
    } else {
      map['emp_id'] = supervisorid;
    }

    if (status1) {
      // Online: Fetch from API
      APIManager().apiRequest(context, API.unitattendance, (response) async {
        try {
          final unitatt.UnitAttendanceResponse resp = response;

          if (resp.status == 1) {
            // Save response to cache
            await prefs.setString(cacheKey, json.encode(resp.toJson()));

            // Update UI

            GlobalLists.mainlisttab = resp.data;
            log('unitattendanceApi Done');
          } else {
            // ShowDialogs.showToast(resp.msg);
          }
        } catch (e) {
          print('Error parsing API response: $e');
        }
      }, (error) {
        print('API error: $error');
        // ShowDialogs.showToast("API failed. Trying offline data...");
        _loadCachedUnitAttendance(prefs, cacheKey);
      }, false, "", jsonval: map);
    } else {
      // Offline: Load from cache
      // ShowDialogs.showToast("Offline: Loading cached attendance");
      _loadCachedUnitAttendance(prefs, cacheKey);
    }
  }

  void _loadCachedUnitAttendance(SharedPreferences prefs, String cacheKey) {
    final cachedData = prefs.getString(cacheKey);
    if (cachedData != null) {
      try {
        final unitatt.UnitAttendanceResponse resp =
            unitatt.UnitAttendanceResponse.fromJson(json.decode(cachedData));

        if (resp.status == 1) {
          GlobalLists.mainlisttab = resp.data;
        } else {
          // ShowDialogs.showToast("Cached data invalid.");
        }
      } catch (e) {
        print('Error loading cached data: $e');
        // ShowDialogs.showToast("Failed to load cached data.");
      }
    } else {
      // ShowDialogs.showToast("No offline data found.");
    }
  }
  // attendanceApi() async {
  //   log('api called attendanceApi');
  //   var status1 = await ConnectionDetector.checkInternetConnection();

  //   if (status1) {
  //     // GlobalLists.attendanceemployeelist = [];
  //     //29OctRUCHI
  //     setState(() {
  //       isattendanceLoadin = true;
  //     });

  //     var supervisorid = await SPManager().getsupervisorid();
  //     var map = {
  //       'supervisor': supervisorid,
  //       'today_date':
  //       //  "23-06-2026",
  //       GlobalLists.datecontroller.text,
  //     };

  //     APIManager().apiRequest(
  //       context,
  //       API.attendance,
  //       (response) async {
  //         att.AttendencelistResponse resp = response;
  //         print("RAW RESPONSE");
  //         print(jsonEncode(resp));
  //         if (resp.status == 1) {
  //           setState(() {
  //             GlobalLists.attendancedata = resp.data;
  //             GlobalLists.superviorgraphlist = resp.graphData!;

  //             log('GlobalLists.attendancedata');
  //             print(
  //               'GlobalLists.attendancedata.count ${GlobalLists.attendancedata!.attendanceDetails![0].employeeList!.length}',
  //             );

  //             GlobalLists.mainlisttab = [
  //               unitatt.Datum(
  //                 clientName: "OverAll",
  //                 clientId: 0,
  //                 siteId: 0,
  //                 attendanceDetails: [],
  //                 lowattendance: false,
  //                 attendedCount: 0,
  //                 totalNoStaff: 0,
  //                 notapplicable: 0,
  //               ),
  //               unitatt.Datum(
  //                 clientName: resp.data!.clientSiteName!,
  //                 clientId: resp.data!.clientId!,
  //                 siteId: resp.data!.siteId!,
  //                 attendanceDetails: [],
  //                 lowattendance: resp.data!.lowattendance!,
  //                 attendedCount: 0,
  //                 totalNoStaff: 0,
  //                 notapplicable: 0,
  //               ),
  //             ];
  //             print("========== RESPONSE CHECK ==========");
  //             print(response);
  //             print(response.runtimeType);
  //             print(resp.data?.attendanceDetails?.length);

  //             for (final shift in resp.data?.attendanceDetails ?? []) {
  //               print("${shift.shiftName} => ${shift.employeeList?.length}");
  //             }
  //             //24june
  //             // GlobalLists.attendanceemployeelist = resp.data!.employeeList;
  //             GlobalLists.attendanceDetails =
  //                 resp.data?.attendanceDetails ?? [];
  //             print("SHIFT COUNT ${GlobalLists.attendanceDetails.length}");

  //             for (var shift in GlobalLists.attendanceDetails) {
  //               print("${shift.shiftName} => ${shift.employeeList?.length}");
  //             }

  //             selectedShiftIndex = 0;
  //             isdataloaded = true;

  //             if (resp.data!.clientSiteName == widget.clientname) {
  //               maintag = 1;
  //             }
  //           });

  //           final prefs = await SharedPreferences.getInstance();
  //           await prefs.setString(
  //             'cached_attendance_data',
  //             att.attendencelistResponseToJson(resp),
  //           );

  //           setState(() {
  //             isattendanceLoadin = false;
  //           });
  //           // Navigator.of(this.context).pop();
  //         } else {
  //           setState(() {
  //             GlobalLists.mainlisttab.clear();

  //             GlobalLists.superviorgraphlist.clear();
  //             isattendanceLoadin = false;
  //           });
  //           // Navigator.of(this.context).pop();
  //         }
  //       },
  //       (error) {
  //         //  Navigator.of(this.context).pop();
  //         setState(() {
  //           GlobalLists.mainlisttab.clear();
  //           GlobalLists.superviorgraphlist.clear();

  //           isattendanceLoadin = false;
  //         });
  //         log('ERR msg is $error');
  //       },
  //       false,
  //       "",
  //       jsonval: map,
  //     );
  //   } else {
  //     //  Offline Mode: Load from SharedPreferences
  //     final prefs = await SharedPreferences.getInstance();
  //     String? cachedData = prefs.getString('cached_attendance_data');

  //     if (cachedData != null) {
  //       try {
  //         att.AttendencelistResponse resp = att.attendencelistResponseFromJson(
  //           cachedData,
  //         );

  //         setState(() {
  //           GlobalLists.attendancedata = resp.data;
  //           GlobalLists.superviorgraphlist = resp.graphData!;
  //           GlobalLists.mainlisttab = [
  //             unitatt.Datum(
  //               clientName: "OverAll",
  //               clientId: 0,
  //               siteId: 0,
  //               attendanceDetails: [],
  //               lowattendance: false,
  //               attendedCount: 0,
  //               totalNoStaff: 0,
  //               notapplicable: 0,
  //             ),
  //             unitatt.Datum(
  //               clientName: resp.data!.clientSiteName!,
  //               clientId: resp.data!.clientId!,
  //               siteId: resp.data!.siteId!,
  //               attendanceDetails: [],
  //               lowattendance: resp.data!.lowattendance!,
  //               attendedCount: 0,
  //               totalNoStaff: 0,
  //               notapplicable: 0,
  //             ),
  //           ];
  //           GlobalLists.attendanceDetails = resp.data?.attendanceDetails ?? [];
  //           //24june
  //           // GlobalLists.attendanceemployeelist = resp.data.employeeList;
  //           isdataloaded = true;

  //           if (resp.data!.clientSiteName == widget.clientname) {
  //             maintag = 1;
  //           }
  //         });

  //         ShowDialogs.showToast("Offline attendance data loaded");
  //       } catch (e) {
  //         ShowDialogs.showToast("Failed to load offline data");
  //       }
  //     } else {
  //       ShowDialogs.showToast("No internet and no cached data available");
  //     }
  //   }
  // }

  attendanceApi(BuildContext context) async {

    // 24june
    // log(" Enter attendanceApi");
    var status1 = await ConnectionDetector.checkInternetConnection();

    if (status1) {
      GlobalLists.attendanceemployeelist = [];

      GlobalLists.mainlisttab = [];
      GlobalLists.attendanceemployeelist = [];

      var supervisorid = await SPManager().getsupervisorid();
      var map = {
        'supervisor': supervisorid,
        'today_date': GlobalLists.datecontroller.text,
      };

      log(map.toString());

      APIManager().apiRequest(context, API.attendance, (response) async {
        AttendencelistResponse resp = response;

        if (resp.status == 1) {
          GlobalLists.attendancedata = resp.data;
          GlobalLists.superviorgraphlist = resp.graphData!;
          GlobalLists.mainlisttab = [
            unitatt.Datum(
              clientName: "OverAll",
              clientId: 0,
              siteId: 0,
              attendanceDetails: [],
              lowattendance: false,
              attendedCount: 0,
              totalNoStaff: 0,
              notapplicable: 0,
            ),
            unitatt.Datum(
              clientName: resp.data!.clientSiteName!,
              clientId: resp.data!.clientId!,
              siteId: resp.data!.siteId!,
              attendanceDetails: [],
              lowattendance: resp.data!.lowattendance!,
              attendedCount: 0,
              totalNoStaff: 0,
              notapplicable: 0,
            ),
          ];
          GlobalLists.attendanceemployeelist = GlobalLists.attendanceDetails[0]!.employeeList!;
          // resp.data.employeeList;
          log('attendanceApi DOne');

          // if (resp.data.clientSiteName == widget.clientname) {
          //   maintag = 1;
          // }

          // ✅ Save JSON to SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(
              'cached_attendance_data', attendencelistResponseToJson(resp));
        } else {}
      }, (error) {
        print('ERR msg is $error');
      }, false, "", jsonval: map);
    } else {
      // 🚫 Offline Mode: Load from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      String? cachedData = prefs.getString('cached_attendance_data');

      if (cachedData != null) {
        try {
          AttendencelistResponse resp =
              attendencelistResponseFromJson(cachedData);

          GlobalLists.attendancedata = resp.data;
          GlobalLists.superviorgraphlist = resp.graphData!;
          GlobalLists.mainlisttab = [
            unitatt.Datum(
              clientName: "OverAll",
              clientId: 0,
              siteId: 0,
              attendanceDetails: [],
              lowattendance: false,
              attendedCount: 0,
              totalNoStaff: 0,
              notapplicable: 0,
            ),
            unitatt.Datum(
              clientName: resp.data!.clientSiteName!,
              clientId: resp.data!.clientId!,
              siteId: resp.data!.siteId!,
              attendanceDetails: [],
              lowattendance: resp.data!.lowattendance!,
              attendedCount: 0,
              totalNoStaff: 0,
              notapplicable: 0,
            ),
          ];
          GlobalLists.attendanceemployeelist = GlobalLists.attendanceDetails[0]!.employeeList!;
          // resp.data.employeeList;

          // if (resp.data.clientSiteName == widget.clientname) {
          //   maintag = 1;
          // }

          // ShowDialogs.showToast("Offline attendance data loaded");
        } catch (e) {
          print("❌ Error parsing cached attendance: $e");
          // ShowDialogs.showToast("Failed to load offline data");
        }
      } else {
        // ShowDialogs.showToast("No internet and no cached data available");
      }
    }
  }

//for workflow

  operationlManagerworkflowstatusApi(BuildContext context) async {
    var status1 = await ConnectionDetector.checkInternetConnection();

    var supervisorid = await SPManager().getsupervisorid();
    var map = {
      'supervisor': supervisorid,
      'date_today': GlobalLists.datecontroller.text,
    };

    if (status1) {
      APIManager().apiRequest(
        context,
        API.workflowoperational,
        (response) async {
          newopera.Workflowoperationalmodel resp = response;
          print('Anand API ${resp.data}');

          if (resp.status == 1) {
            GlobalLists.operationalmainlisttab = resp.data;
            GlobalLists.maintag = 0;
            GlobalLists.selectedindex = 0;

            operationlManagerdetailworkflowstatusApi(
                resp.data[0].clientId.toString(),
                resp.data[0].siteId.toString(),
                context);

            final prefs = await SharedPreferences.getInstance();
            await prefs.setString(
              'workflowOperationalCache',
              jsonEncode(resp.toJson()),
            );

            // Navigator.of(context).pop();
          } else {
            // setState(() {
            //   isdataloaded = false;
            // });
            // Navigator.of(context).pop();
          }
        },
        (error) {
          log('ERR msg is $error');
          // Navigator.of(context).pop();
          // ShowDialogs.showToast("Server Not Responding");
        },
        false,
        "",
        jsonval: map,
      );
    } else {
      final prefs = await SharedPreferences.getInstance();
      String? cachedData = prefs.getString('workflowOperationalCache');

      if (cachedData != null) {
        final decoded = jsonDecode(cachedData);
        newopera.Workflowoperationalmodel cachedResponse =
            newopera.Workflowoperationalmodel.fromJson(decoded);

        GlobalLists.operationalmainlisttab = cachedResponse.data ?? [];
        GlobalLists.maintag = 0;
        GlobalLists.selectedindex = 0;

        if (cachedResponse.data != null && cachedResponse.data!.isNotEmpty) {
          operationlManagerdetailworkflowstatusApi(
              cachedResponse.data[0].clientId.toString(),
              cachedResponse.data[0].siteId.toString(),
              context);
        }

        // ShowDialogs.showToast("Loaded offline data");
      } else {
        // ShowDialogs.showToast("No internet and no cached data available");
      }
    }
  }

  operationlManagerdetailworkflowstatusApi(
    String client_id,
    String site_id,
    BuildContext context,
  ) async {
    try {
      var status1 = await ConnectionDetector.checkInternetConnection();
      var map = {
        'clientid': client_id,
        'siteid': site_id,
        'today_date': GlobalLists.datecontroller.text,
      };

      if (status1) {
      
        // setState(() {
        GlobalLists.detailopeermainlisttab = [];
        // });

        APIManager().apiRequest(
          context,
          API.workflowoperationaldetail,
          (response) async {
            try {
              newoperdetail.WorkflowoperationalDetailmodel resp = response;

              if (resp.status == 1) {
                GlobalLists.detailopeermainlisttab = resp.data;
                GlobalLists.tabsmain = [];
                GlobalLists.selectedindex = 0;

                updateTabData(resp);
                // isdataloaded = true;
                // Navigator.of(this.context).pop();

                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString("workflow_response", jsonEncode(resp.toJson()));

                /// ✅ FIX: Store the entire response, not just `data`
                String clientIdKey = client_id;
                if (!GlobalLists.clientDetailsMap.containsKey(clientIdKey)) {
                  GlobalLists.clientDetailsMap[clientIdKey] = [];
                }
                GlobalLists.clientDetailsMap[clientIdKey]!
                    .addAll(resp.data); // ✅ Correct
// 👈 FIXED LINE
              } else {
                // setState(() {
                //   isdataloaded = true;
                // });
                // Navigator.of(this.context).pop();
              }
            } catch (e) {
              print("Parsing Error: $e");
              // Navigator.of(this.context).pop();
              // ShowDialogs.showToast("Something went wrong");
            }
          },
          (error) {
            log('ERR msg is $error');
            // Navigator.of(this.context).pop();
            // ShowDialogs.showToast("Server Not Responding");
          },
          false,
          "",
          jsonval: map,
        );
      } else {
        /// 👉 Offline Mode
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? cached = prefs.getString("workflow_response");

        if (cached != null) {
          try {
            var decoded = jsonDecode(cached);
            newoperdetail.WorkflowoperationalDetailmodel resp =
                newoperdetail.WorkflowoperationalDetailmodel.fromJson(decoded);

            // setState(() {
            GlobalLists.detailopeermainlisttab = resp.data;
            GlobalLists.tabsmain = [];
            GlobalLists.selectedindex = 0;
            updateTabData(resp);
            // isdataloaded = true;
            // });

            /// ✅ FIX: Add full response object, not just `data`
            String clientIdKey = client_id;
            if (!GlobalLists.clientDetailsMap.containsKey(clientIdKey)) {
              GlobalLists.clientDetailsMap[clientIdKey] = [];
            }
            GlobalLists.clientDetailsMap[clientIdKey]!
                .addAll(resp.data); // ✅ Correct
            // 👈 FIXED LINE
          } catch (e) {
            log("Error reading offline data: $e");
            // ShowDialogs.showToast("Failed to load offline data");
          }
        } else {
          // ShowDialogs.showToast("No offline data available");
        }
      }
    } catch (e) {
      print("API Exception: $e");
    }
  }

  void updateTabData(newoperdetail.WorkflowoperationalDetailmodel resp) {
    GlobalLists.card_startcurrentdatevalue =
        resp.data[0].details[GlobalLists.selectedindex].startTimeStr.toString();
    GlobalLists.card_endcurrentdatevalue =
        resp.data[0].details[GlobalLists.selectedindex].endTimeStr.toString();
    GlobalLists.card_superviorfirtvalue =
        resp.data[0].superviourName.toString();
    GlobalLists.card_percentvalue = resp.data[0].totalPercentage.toString();

    for (int i = 0; i < resp.data[0].details.length; i++) {
      GlobalLists.tabsmain.add(
        Tab(
          child: Text(
            "${resp.data[0].details[i].startTimeStr} - ${resp.data[0].details[i].endTimeStr}",
            style: TextStyle(
              color: resp.data[0].details[i].status == "Pending"
                  ? customcolor.red
                  : resp.data[0].details[i].status == "Completed"
                      ? customcolor.green
                      : customcolor.blue,
            ),
          ),
        ),
      );
    }

    for (int i = 0; i < resp.data[0].details.length; i++) {
      if (resp.data[0].details[i].currentTime == true) {
        GlobalLists.selectedindex = i;
        GlobalLists.card_startcurrentdatevalue =
            resp.data[0].details[i].startTimeStr.toString();
        GlobalLists.card_endcurrentdatevalue =
            resp.data[0].details[i].endTimeStr.toString();
        GlobalLists.card_superviorfirtvalue =
            resp.data[0].details[i].supervisorName.toString();
        GlobalLists.card_percentvalue = resp.data[0].totalPercentage.toString();
        break;
      }
    }
  }

  operationlworkflowstatusApi(BuildContext context, String? role) async {
    log('enter operationlworkflowstatusApi');
    var status1 = await ConnectionDetector.checkInternetConnection();

    var clientid = await SPManager().getclientid();
    var map = {
      'today_date': GlobalLists.datecontroller.text,
    };
    if (role == GlobalLists.clientrole) {
      map['clientid'] = clientid.toString();
    }

    if (status1) {
      APIManager().apiRequest(context, API.operationalworkflow,
          (response) async {
        operwf.OperationalWorkflowResponse resp = response;

        if (resp.status == 1) {
          GlobalLists.mainlisttabs = resp.data;
          GlobalLists.operationalworkflowstatuslist = resp.data;
          GlobalLists.selectedindex = 0;
          GlobalLists.tabsmain = <Tab>[];

          for (int i = 0; i < resp.data.length; i++) {
            // if (resp.data[i].clientName == widget.clientname) {
            //   GlobalLists.maintag = i;
            // }
          }

          _updateCardValues();
          _generateTabs();

          //  GlobalLists.tabControllermain = TabController(
          //   vsync: this,
          //   length: GlobalLists.mainlisttabs[GlobalLists.maintag].details.length,
          //   initialIndex: GlobalLists.selectedindex,
          // );

          // ✅ Cache response locally
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(
            'cached_operationalworkflow',
            jsonEncode(resp.toJson()),
          );
        } else {}
      }, (error) {
        log('ERR msg is $error');
        // Navigator.of(context).pop();
        // ShowDialogs.showToast("Server Not Responding");
      }, false, "", jsonval: map);
    } else {
      // 🚫 No internet – Load from cache
      final prefs = await SharedPreferences.getInstance();
      String? cachedData = prefs.getString('cached_operationalworkflow');

      if (cachedData != null) {
        final decoded = jsonDecode(cachedData);
        operwf.OperationalWorkflowResponse cachedResponse =
            operwf.OperationalWorkflowResponse.fromJson(decoded);

        GlobalLists.mainlisttabs = cachedResponse.data;
        GlobalLists.operationalworkflowstatuslist = cachedResponse.data;
        GlobalLists.selectedindex = 0;
        GlobalLists.tabsmain = <Tab>[];

        for (int i = 0; i < cachedResponse.data.length; i++) {
          // if (cachedResponse.data[i].clientName == widget.clientname) {
          //   GlobalLists.maintag = i;
          // }
        }

        _updateCardValues();
        _generateTabs();

        //  GlobalLists.tabControllermain = TabController(
        //   vsync: this,
        //   length: GlobalLists.mainlisttabs[GlobalLists.maintag].details.length,
        //   initialIndex: GlobalLists.selectedindex,
        // );

        ShowDialogs.showToast("Loaded offline data");
      } else {
        ShowDialogs.showToast("No internet and no cached data available");
      }
    }
  }

  void _updateCardValues() {
    var details = GlobalLists.mainlisttabs[GlobalLists.maintag].details;
    for (int i = 0; i < details.length; i++) {
      if (details[i].currentTime == true && details[i].priority_status == 1) {
        GlobalLists.selectedindex = i;
        break;
      } else if (details[i].currentTime == true) {
        GlobalLists.selectedindex = i;
        break;
      }
    }

    GlobalLists.card_startcurrentdatevalue =
        details[GlobalLists.selectedindex].startTimeStr.toString();
    GlobalLists.card_endcurrentdatevalue =
        details[GlobalLists.selectedindex].endTimeStr.toString();
    GlobalLists.card_superviorfirtvalue =
        details[GlobalLists.selectedindex].supervisorName.toString();
    GlobalLists.card_percentvalue = GlobalLists
        .mainlisttabs[GlobalLists.maintag].totalPercentage
        .toString();
  }

  void _generateTabs() {
    var details = GlobalLists.mainlisttabs[GlobalLists.maintag].details;
    GlobalLists.tabsmain.clear();
    for (int i = 0; i < details.length; i++) {
      GlobalLists.tabsmain.add(
        Tab(
          child: Text(
            "${details[i].startTimeStr}-${details[i].endTimeStr}",
            style: TextStyle(
              color: details[i].status == "Pending"
                  ? customcolor.red
                  : details[i].status == "Completed"
                      ? customcolor.green
                      : customcolor.blue,
            ),
          ),
        ),
      );
    }
  }

  workflowstatusApi(String shiftId, BuildContext context) async {
    log('workflowstatusApi');
    // Check Internet Connection
    if (!await ConnectionDetector.checkInternetConnection()) {
      // Try loading offline data
      final prefs = await SharedPreferences.getInstance();
      String? cachedData = prefs.getString('workflowstatusApi');

      if (cachedData != null) {
        final WorkfowstatusResponse resp =
            WorkfowstatusResponse.fromJson(jsonDecode(cachedData));

        // setState(() {
        GlobalLists.workflowstatuslist = resp.data;
        GlobalLists.shiftavaialble = resp.shiftActive.toString();
        GlobalLists.multidays = resp.multidays;
        GlobalLists.start_time = resp.start_time;
        GlobalLists.end_time = resp.end_time;
        GlobalLists.total_supervisorercentage =
            resp.total_percentage.toString();

        GlobalLists.selectedindex = 0;
        for (int i = 0; i < GlobalLists.workflowstatuslist.length; i++) {
          final item = GlobalLists.workflowstatuslist[i];
          if (item.currentTime == true) {
            GlobalLists.selectedindex = i;
            if (item.priority_status == 1) break;
          }
        }

        final selectedItem =
            GlobalLists.workflowstatuslist[GlobalLists.selectedindex];
        GlobalLists.card_startcurrentdatevalue = selectedItem.startTime;
        GlobalLists.card_endcurrentdatevalue = selectedItem.endTime;
        GlobalLists.card_superviorfirtvalue =
            "${selectedItem.clientName} - ${selectedItem.siteName}";
        GlobalLists.card_percentvalue = GlobalLists.total_supervisorercentage;

        GlobalLists.tabsmain = List.generate(
          GlobalLists.workflowstatuslist.length,
          (i) => Tab(
            child: Text(
              "${GlobalLists.workflowstatuslist[i].startTime} - ${GlobalLists.workflowstatuslist[i].endTime}",
              style: TextStyle(
                color:
                    _getStatusColor(GlobalLists.workflowstatuslist[i].status),
              ),
            ),
          ),
        );

        // GlobalLists.tabControllermain = TabController(
        //   vsync: this,
        //   length: GlobalLists.workflowstatuslist.length,
        //   initialIndex: GlobalLists.selectedindex,
        // );

        // _tabController = TabController(vsync: this, length: 5);
        // isdataloaded = true;
        // });

        // ShowDialogs.showToast("Offline data loaded");
      } else {
        // ShowDialogs.showToast("Please check internet connection");
      }

      return;
    }

    // Online case
   

    // setState(() {
    GlobalLists.workflowstatuslist = [];
    // });

    final map = {
      'shift_id': shiftId,
      'client_id': GlobalLists.clientid,
      'site_id': GlobalLists.siteid,
      'today_date': GlobalLists.datecontroller.text,
    };

    APIManager().apiRequest(
      context,
      API.workflowstatus,
      (response) async {
        final WorkfowstatusResponse resp = response;
        log(map.toString());

        // if (resp.status != 1) {
        //   setState(() => isdataloaded = false);
        //   Navigator.of(context).pop();
        //   return;
        // }

        // setState(() {
        GlobalLists.workflowstatuslist = resp.data;
        log(GlobalLists.workflowstatuslist.toString(), name: 'check');
        GlobalLists.shiftavaialble = resp.shiftActive.toString();
        GlobalLists.multidays = resp.multidays;
        GlobalLists.start_time = resp.start_time;
        GlobalLists.end_time = resp.end_time;
        GlobalLists.total_supervisorercentage =
            resp.total_percentage.toString();

        GlobalLists.selectedindex = 0;

        for (int i = 0; i < GlobalLists.workflowstatuslist.length; i++) {
          final item = GlobalLists.workflowstatuslist[i];
          if (item.currentTime == true) {
            GlobalLists.selectedindex = i;
            if (item.priority_status == 1) break;
          }
        }

        final selectedItem =
            GlobalLists.workflowstatuslist[GlobalLists.selectedindex];
        GlobalLists.card_startcurrentdatevalue = selectedItem.startTime;
        GlobalLists.card_endcurrentdatevalue = selectedItem.endTime;
        GlobalLists.card_superviorfirtvalue =
            "${selectedItem.clientName} - ${selectedItem.siteName}";
        GlobalLists.card_percentvalue = GlobalLists.total_supervisorercentage;

        // GlobalLists.tabsmain = List.generate(
        //   GlobalLists.workflowstatuslist.length,
        //   (i) => Tab(
        //     child: Text(
        //       "${GlobalLists.workflowstatuslist[i].startTime} - ${GlobalLists.workflowstatuslist[i].endTime}",
        //       style: TextStyle(
        //         color:
        //             _getStatusColor(GlobalLists.workflowstatuslist[i].status),
        //       ),
        //     ),
        //   ),
        // );

        // GlobalLists.tabControllermain = TabController(
        //   vsync: this,
        //   length: GlobalLists.workflowstatuslist.length,
        //   initialIndex: GlobalLists.selectedindex,
        // );

        // _tabController = TabController(vsync: this, length: 5);
        // isdataloaded = true;
        // });

        // Save response to offline
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
          'workflowstatusApi',
          jsonEncode(resp.toJson()),
        );

        // Navigator.of(context).pop();
      },
      (error) {
        log('error $error');
        // Navigator.of(context).pop();
        // ShowDialogs.showToast("Server Not Responding");
      },
      false,
      "",
      jsonval: map,
    );
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case "Pending":
        return customcolor.red;
      case "Completed":
        return customcolor.green;
      default:
        return customcolor.blue;
    }
  }
}
