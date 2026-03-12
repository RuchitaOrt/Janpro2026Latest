import 'dart:ui';


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:janpro/Screens/ImageDetail.dart';
import 'package:janpro/Screens/SpecialActivity.dart';
import 'package:janpro/Screens/TrainingDetail.dart';
import 'package:janpro/Utitlity/AppDrawer.dart';
import 'package:janpro/Utitlity/GlobalLists.dart';
import 'package:janpro/Utitlity/ResponsiveFlutter.dart';
import 'package:janpro/Utitlity/SPManager.dart';
import 'package:janpro/Utitlity/appbar.dart';
import 'package:janpro/Utitlity/custom_color.dart';
import 'package:janpro/Utitlity/sizeConfig.dart';
import 'package:janpro/model/AttendencelistResponse.dart';



// class ImageList{
// final String title;

// final List<String> imagename;


//   ImageList(this.name,  this.value);
// }
class MainList{
final String name;
final String priority;

  MainList(this.name, this.priority);
}


class SpecialActivityImage extends StatefulWidget  {
    List<ImageList> imagelist;

  SpecialActivityImage(this.imagelist);

  @override
  _SpecialActivityImageState createState() => _SpecialActivityImageState();
}

class _SpecialActivityImageState extends State<SpecialActivityImage>  with TickerProviderStateMixin {
 var searchcontroller=new TextEditingController();
 var namecontroller=new TextEditingController();
 var sitenamecontroller=new TextEditingController();
 final GlobalKey<State> _keyLoader = new GlobalKey<State>();

var mobilecontroller=new TextEditingController();

List<EmployeeList> unitemployeelist=[];
 String selectedValue = "Pending";
 String? lat;
  String? long;
List<String> listtab = [];
   List<String>? formValue1;
  int tag = 0;
  int maintag=0;

  String _isSelected = "";
  List<MainList> mainlisttab = [];
  // List<Ratingclass> ratinglist= [];
  late Data attendancedata;
  bool isdataloaded=false;
  List<EmployeeList> searchUserList=[];
   String? role="1";
   late TabController _tabControllermain;
 final List<Tab> tabsmain = <Tab>[];
 int selectedindex=0;
  bool showAvg = false;
    late TabController _tabController;
  @override
  void initState() {
     super.initState();

  final items = [
    Image.asset('assets/images/clean1.png',fit: BoxFit.fill,  width: SizeConfig.blockSizeHorizontal * 100,height: SizeConfig.safeBlockVertical*60,),
    Image.asset('assets/images/clean2.png',fit: BoxFit.fill, width: SizeConfig.blockSizeHorizontal * 100,height: SizeConfig.safeBlockVertical*60,),
      Image.asset('assets/images/clean1.png',fit: BoxFit.fill, width: SizeConfig.blockSizeHorizontal * 100,height: SizeConfig.safeBlockVertical*60,),
        Image.asset('assets/images/clean2.png',fit: BoxFit.fill, width: SizeConfig.blockSizeHorizontal * 100,height: SizeConfig.safeBlockVertical*60,)
  ];

  print("date ");
getrole();
    
  


  }
  getrole()
async {
   role=await SPManager().getroleid();
   if(role==GlobalLists.unitrole||role==GlobalLists.headrole||role==GlobalLists.reginalmanagerrole||role==GlobalLists.clientrole||role==GlobalLists.operationrole ||role==GlobalLists.operationmanagerrole)
   {
  

  _tabController = new TabController(vsync: this, length: 3);
          setState(() {
            listtab.add("3.30 - 4.00 pm");
           listtab.add("3.50 - 4.00 pm");
            listtab.add("4.30 - 5.00 pm");
           
             mainlisttab.add(MainList("OverAll","0"));
              mainlisttab.add(MainList("IMAX","0"));
               mainlisttab.add(MainList("Cinipol","0"));
                mainlisttab.add(MainList("Cinimax","0"));
           
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
                pageBuilder: (context, animation1, animation2) => SpecialActivity(""),
              ),
            );
        return await false;
      },
      child: Scaffold(
         key: _scaffoldKey1,
         endDrawer: Theme(
            data: Theme.of(context)
                .copyWith(canvasColor: customcolor.blue, primaryColor: customcolor.blue),
            child: AppDrawerfilter(
             role
            ),
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
             onPressedmenu:()
            {
              _scaffoldKey1.currentState!.openEndDrawer();
              
            }
          ),
        ),
        
        body: Stack(
          children: [
            SingleChildScrollView(
              physics: ScrollPhysics(),
              child: (role==GlobalLists.headrole||role==GlobalLists.reginalmanagerrole||role==GlobalLists.clientrole||role==GlobalLists.operationrole ||role==GlobalLists.operationmanagerrole)?
              Padding(
                padding: const EdgeInsets.only(left: 10,right: 10,top: 20,bottom: 5),
                child: Container(
                  child: ListView(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    children: [Row(
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
                            Container(child: Text(widget.imagelist[0].name, style:
                              AppFonts.headerStyle(fontSize:ResponsiveFlutter.of(context).fontSize(2.3),
                                    color: customcolor.black,
                                    fontWeight: FontWeight.w300  ),
                             ),
                            ),
                          ],
                        ),
                    
                      ],
                    ),
                      
    
                                        //workflow
                                          SizedBox(height: 10,),
                                    headmodule()
                                        ],
                  ),
                ),
              )
              :Container(),
            ),
            
          ],
        ),
      ),
    );
  }

Widget headmodule()
{
   
  return ListView(
                                          shrinkWrap: true,
                                          physics: ScrollPhysics(),
                                           children: [
                                          
                                             Container(
                                              height: SizeConfig.blockSizeVertical*100,
                                               decoration: BoxDecoration(
                                //color: Colors.white,
                                shape: BoxShape.rectangle,
                                borderRadius:  BorderRadius.circular(10),
                                border: Border.all(
                                  color: customcolor.greyborder,
                                  width: 0.4,
                                ),
                              ),

                                              
                                               child: maintab(maintag)
                                             ),
                             
                                           ],
                                         );
}
Widget maintab(int maintag)
{
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:  GridView.count(  
                crossAxisCount: 2,  
                crossAxisSpacing: 4.0,  
                mainAxisSpacing: 8.0,  
                childAspectRatio: 0.8,
                children: List.generate(widget.imagelist.length, (index) {  
                  return GestureDetector(
                    onTap: ()
                    {
                           Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => ImageDetail(widget.imagelist,index,widget.imagelist[0].name)
                           
                            )); 
                      
                    },
                    child: Center(  
                      child:  Stack(
                        children: [
                      widget.imagelist[index].imagename==""?Container():    Image.network(
                        widget.imagelist[index].imagename,fit: BoxFit.fill, 
                         width: SizeConfig.blockSizeHorizontal * 100,height: SizeConfig.safeBlockVertical*60,
                         
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
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                            child: Container(
                                       decoration: BoxDecoration(
                                         color: customcolor.blue,
                                //color: Colors.white,
                                shape: BoxShape.rectangle,
                                borderRadius:  BorderRadius.circular(20),
                                // border: Border.all(
                                //   color: customcolor.greyborder,
                                //   width: 0.4,
                                // ),
                              ),
                                          
                             
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
                                child: Text(
                                 widget.imagelist[index].imagevalue,style:  AppFonts.headerStyle(fontSize:ResponsiveFlutter.of(context).fontSize(2),
                              color: customcolor.white,fontWeight: FontWeight.normal  ),),
                              ),
                            ),
                          )),
                  
                        ],
                      ),  
                    ),
                  );  
                }  
                )  
            )  
        )  
     ;
                  }



}


