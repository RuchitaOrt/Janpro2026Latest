import 'dart:ui';


import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';

import 'package:janpro/Utitlity/APIManager.dart';
import 'package:janpro/Utitlity/GlobalLists.dart';
import 'package:janpro/Utitlity/ResponsiveFlutter.dart';
import 'package:janpro/Utitlity/SPManager.dart';
import 'package:janpro/Utitlity/ShowDialog.dart';
import 'package:janpro/Utitlity/appbar.dart';
import 'package:janpro/Utitlity/button.dart';
import 'package:janpro/Utitlity/custom_color.dart';
import 'package:janpro/Utitlity/internetConnection.dart';
import 'package:janpro/Utitlity/sizeConfig.dart';
import 'package:janpro/model/NotificationlistResponse.dart';









class NotificationPage extends StatefulWidget {
  NotificationPage();

  @override
  _NotificationState createState() => _NotificationState();
}

class _NotificationState extends State<NotificationPage>  {
  var datecontroller=new TextEditingController();
 var statuscontroller=new TextEditingController();
 String selectedValue = "Pending";
   var selectedDateTime;
 List _elements = [
  {'name': 'Ground Floor -Washroom', 'subname':'With Instabug, it’s easy for beta testers to send you detail-rich bug reports and feedback, and even easier for you to reproduce and debug issues.','group': 'Today'},
  {'name': 'Basemenr',  'subname':'With Instabug, it’s easy for beta testers to send you detail-rich bug reports and feedback, and even easier for you to reproduce and debug issues.','group': '19-07-2023'},
  {'name': 'Ground Floor -Washroom', 'subname':'With Instabug, it’s easy for beta testers to send you detail-rich bug reports and feedback, and even easier for you to reproduce and debug issues.', 'group': 'Today'},
  {'name': 'Basement',  'subname':'With Instabug, it’s easy for beta testers to send you detail-rich bug reports and feedback, and even easier for you to reproduce and debug issues.','group': '19-07-2023'},
  {'name': 'Ground Floor -Washroom', 'subname':'With Instabug, it’s easy for beta testers to send you detail-rich bug reports and feedback, and even easier for you to reproduce and debug issues.', 'group': '20-07-2023'},
  {'name': 'Cabin', 'subname':'With Instabug, it’s easy for beta testers to send you detail-rich bug reports and feedback, and even easier for you to reproduce and debug issues.', 'group': '21-07-2023'},
];
String role="1";
 getrole()
async {
   role=(await SPManager().getroleid())!;
      
   notificationlistApi();
}
  @override
  void initState() {
     super.initState();
        var  datefrom =
                                    DateFormat('dd-MM-yyyy').format(DateTime.now());
  datecontroller.text=datefrom;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: customcolor.white,
      resizeToAvoidBottomInset: false,
      
 appBar: PreferredSize(
          preferredSize: Size.fromHeight(148),
          child: Padding(
            padding: const EdgeInsets.only(top: 40,left: 15),
            child: Container(
                height: 50,
                color: customcolor.white,
                child:    Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                     
                          children: [
                              GestureDetector(
                              onTap: ()
                              {
                                Navigator.pop(context);
                              },
                              child: Icon(Icons.arrow_back)),
                            SizedBox(width: 10,),
                            Container(child: Text("NOTIFICATIONS", 
                            style: AppFonts.headerStyle(fontSize:ResponsiveFlutter.of(context).fontSize(2.3),
    color: customcolor.title,fontWeight: FontWeight.normal  ),
                        ),
                            ),
                            
                          ],
                        ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: new Container(
                                          decoration: BoxDecoration(border: Border.all(color: Colors.black12),
                                    color: Colors.white, borderRadius: BorderRadius.circular(20)),
                              width:SizeConfig.blockSizeHorizontal*32,
                              height: 30,
                              // padding: EdgeInsets.only(left: 6,bottom: 5,top:3,right: 5),
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  // new Expanded(child: new Text("Bemerkung",)),
                                  new  Expanded(
                                        child: new TextField(
                                          textAlignVertical: TextAlignVertical.center,
                                          textAlign: TextAlign.center,
                                          style: 
                                          
                                           AppFonts.headerStyle(fontSize:ResponsiveFlutter.of(context).fontSize(1.6),
                                        color: customcolor.black,fontWeight: FontWeight.w300  ),
                                       readOnly: true,
                                       onTap: ()
                                       async {
                                         DateTime? pickedDate = await showDatePicker(
                                        context: context,
                                        initialDate: selectedDateTime ?? DateTime.now(),
                                        firstDate: DateTime(1950),
                                        lastDate: DateTime(2050));
                                        
                              if (pickedDate != null) {
                              var  datefrom =
                                          DateFormat('dd-MM-yyyy').format(pickedDate);
                                      datecontroller.text =datefrom;
                                      print(datecontroller.text);
                                      setState(() => selectedDateTime = pickedDate);
                                           notificationlistApi();
                              }
                                       },
                                          controller: datecontroller,
                                        decoration: InputDecoration( border: InputBorder.none, contentPadding: EdgeInsets.zero,
                                       isDense: true,),
                                        ),
                                      ),
                                       GestureDetector(
                                        onTap: ()
                                        async {
                                              DateTime? pickedDate = await showDatePicker(
                                                
                                        context: context,
                                        initialDate: selectedDateTime ?? DateTime.now(),
                                        firstDate: DateTime(1950),
                                        lastDate: DateTime(2050));
                                        
                              if (pickedDate != null) {
                              var  datefrom =
                                          DateFormat('dd-MM-yyyy').format(pickedDate);
                                      datecontroller.text =datefrom;
                                      setState(() => selectedDateTime = pickedDate);
                                      print(datecontroller.text);
                                      notificationlistApi();
                                   
                               
                              }
                                        },
                                         child: Padding(
                                         padding:  EdgeInsets.only(bottom: 1,right: 5),
                                         child:   Image.asset('assets/images/calendar.png',width: 22,height: 22,alignment: Alignment.center,),
                                       ),
                                       ),
                                ],
                              ),
                            ),
                          )
                  ],
                ),
              ),
          ),
        ),
     
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 8,right: 8,top: 2,bottom: 20),
              child: Container(
                child: ListView(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  children: [
                 Divider(),
                    // SizedBox(height: 30,),
Container(
  width: SizeConfig.blockSizeVertical*80,
  child: complaintdetail(),
  )
                                      
                                       
                                           
                                     
                                      ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

complaintdetail()
{
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
     child: Container(
      height: SizeConfig.blockSizeVertical*85,
       child:GlobalLists.notifylist.length==0?ShowDialogs.norecordwidget(SizeConfig.blockSizeHorizontal*2,SizeConfig.blockSizeVertical*40): ListView.builder( shrinkWrap: true,
                      //  physics: ScrollPhysics(),
                          itemCount: GlobalLists.notifylist.length,
                          itemBuilder: (BuildContext context, int index) {
        return  Card(
                  elevation: 8.0,
                  margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                  child: GestureDetector(
                                      onTap: () {},
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Row(
                                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                   children: [
                                                     Text(
                                                      "${GlobalLists.notifylist[index].complaintNo}"
                                                      //"${GlobalLists.notifylist[index].masterAreaName} ${GlobalLists.notifylist[index].masterBlockName}-(${GlobalLists.notifylist[index].complainantName})"
                                                      , style:AppFonts.headerStyle(fontSize:ResponsiveFlutter.of(context).fontSize(1.9),
        color: customcolor.title,fontWeight: FontWeight.normal  ),
                      ),
                                                                 
        //                                  Text(
        //                                               "${GlobalLists.notifylist[index].date.toString()}"
        //                                               //"${GlobalLists.notifylist[index].masterAreaName} ${GlobalLists.notifylist[index].masterBlockName}-(${GlobalLists.notifylist[index].complainantName})"
        //                                               , style:AppFonts.headerStyle(fontSize:ResponsiveFlutter.of(context).fontSize(1.9),
        // color: customcolor.title,fontWeight: FontWeight.normal  ),
        //               ), 
        //                               
         
        
                                                   ],
                                                 ),
                                                 SizedBox(height: 10,),
                                            Stack(
                                              children: [
                                                Card(
                                                  color: customcolor.skybluebg,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.all(
                                                        Radius.circular(10),
                                                      ),
                                                     
                                                    ),
                                                    child: Container(
                                                      width: SizeConfig.blockSizeHorizontal*100,
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(10.0),
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                     
                                                    Text("${GlobalLists.notifylist[index].comment}",
                                                     style:AppFonts.headerStyle(fontSize:ResponsiveFlutter.of(context).fontSize(1.6),
                                                        color: customcolor.subtitle,fontWeight: FontWeight.normal  ),
                                                                                                  overflow: TextOverflow.ellipsis,
                                                                                                  maxLines: 3,),
                                                   
                                                          ],
                                                        ),
                                                      ),
                                                    )),
                                              
                                             
                                              ],
                                            ),
                                         Padding(
                                               padding: const EdgeInsets.only(left: 7,top: 9),
                                               child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                 children: [
                                                   Row(
                                                     children: [
                                                         Text(
                                                          "${GlobalLists.notifylist[index].complaintstatus}"
                                                          //"${GlobalLists.notifylist[index].masterAreaName} ${GlobalLists.notifylist[index].masterBlockName}-(${GlobalLists.notifylist[index].complainantName})"
                                                          , style:AppFonts.headerStyle(fontSize:ResponsiveFlutter.of(context).fontSize(1.9),
                                                     color: GlobalLists.notifylist[index].complaintstatus=="Pending"
                                                     ?customcolor.red:GlobalLists.notifylist[index].complaintstatus=="Dependent"?customcolor.blue:GlobalLists.notifylist[index].complaintstatus=="Resolved"?customcolor.green:
                                                     customcolor.title,fontWeight: FontWeight.normal  ),
                                                                   ),
                                                                                                ( GlobalLists.notifylist[index].turnAroundTime==null || GlobalLists.notifylist[index].turnAroundTime=="") 
                                                                                   ?Container():  Text(
                                                                                                         " - ${GlobalLists.notifylist[index].turnAroundTime}"
                                                                                                         //"${GlobalLists.notifylist[index].masterAreaName} ${GlobalLists.notifylist[index].masterBlockName}-(${GlobalLists.notifylist[index].complainantName})"
                                                                                                         , style:AppFonts.headerStyle(fontSize:14,
                                                                                                                   color:customcolor.black,fontWeight: FontWeight.normal  ),
                                                                                                                ),
                                                              
                                                     ],
                                                   ),
                                                      Text("${GlobalLists.notifylist[index].loggedAt}",
                                                                            style: AppFonts.headerStyle(fontSize:ResponsiveFlutter.of(context).fontSize(1.6),
                                                     color: customcolor.hinttext,fontWeight: FontWeight.normal  ),)
                                                 ],
                                               ),
                                             ),
                                             SizedBox(height: 3,)
        //                                     Padding(
        //                                       padding: const EdgeInsets.all(8.0),
        //                                       child: Row(
        //                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                                         children: [
                                                 
        //                     //                      GestureDetector(
        //                     //                       onTap: ()
        //                     //                       {
        //                     //                          Navigator.push(
        //                     // context,
        //                     // MaterialPageRoute(
        //                     //     builder: (BuildContext context) => Complaint()
                               
        //                     //     ));
        //                     //                       },
        //                     //                        child: Text('View Complaints',style: AppFonts.headerStyle(fontSize:ResponsiveFlutter.of(context).fontSize(1.8),
        //                     //                          color: customcolor.blue,fontWeight: FontWeight.normal  ),),
        // //                     //                      ),
        // //                                                                 Text("${GlobalLists.notifylist[index].loggedAt}",
        // //                                                                 style: AppFonts.headerStyle(fontSize:ResponsiveFlutter.of(context).fontSize(1.6),
        // // color: customcolor.hinttext,fontWeight: FontWeight.normal  ),)
        //                                       ],),
        //                                     )
                                          ],
                                        ),
                                      ),
                                    ),
                );
       }),
     ),
   );
}
notificationlistApi() async {
    var status1 = await ConnectionDetector.checkInternetConnection();
setState(() {
  GlobalLists.notifylist=[];
});
    if (status1) {
      
       
      

        var map = new Map<String, dynamic>();
  
        
var supervisorid =await SPManager().getsupervisorid();
 var clientid =await SPManager().getclientid();
print(supervisorid);
        if(role==GlobalLists.clientrole)
{
 
   map['clientid'] =clientid.toString();
    map['datefilter'] =datecontroller.text;
  
}else{
         map['supervisor'] =supervisorid ;
          map['datefilter'] =datecontroller.text;
}
  // map['site_id'] = mainlisttab[maintag].siteId.toString();
  
        APIManager().apiRequest(context, API.notificationlist, (response) async {
        
          NotificationlistResponse resp = response;
          print('called Janitor1 ${resp}');
          if (resp.status == 1) {
           
           setState(() {
        GlobalLists.notifylist=resp.data;

           });

              
           
          } else {
            //ShowDialogs.showToast(resp.message);
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
}


