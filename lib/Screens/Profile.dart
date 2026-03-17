import 'package:flutter/material.dart';
import 'package:janpro/Screens/Homepage.dart';
import 'package:janpro/Screens/Loginscreen.dart';
import 'package:janpro/Utitlity/APIManager.dart';
import 'package:janpro/Utitlity/AppDrawer.dart';
import 'package:janpro/Utitlity/FormTextFieldBorder.dart';
import 'package:janpro/Utitlity/GlobalLists.dart';
import 'package:janpro/Utitlity/ResponsiveFlutter.dart';
import 'package:janpro/Utitlity/SPManager.dart';
import 'package:janpro/Utitlity/ShowDialog.dart';
import 'package:janpro/Utitlity/appbar.dart';
import 'package:janpro/Utitlity/button.dart';
import 'package:janpro/Utitlity/customBottomNavigationBar.dart';
import 'package:janpro/Utitlity/custom_color.dart';
import 'package:janpro/Utitlity/internetConnection.dart';
import 'package:janpro/Utitlity/sizeConfig.dart';
import 'package:janpro/model/LogoutResponse.dart';
import 'package:janpro/model/ProfileResponse.dart';


import 'package:shared_preferences/shared_preferences.dart';

// import 'package:syncfusion_flutter_sliders/sliders.dart';

class Profile extends StatefulWidget {
  Profile();

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var namecontroller = new TextEditingController();
  var descriptioncontroller = new TextEditingController();
  var mobilecontroller = new TextEditingController();
  var emailcontroller = new TextEditingController();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  final GlobalKey<ScaffoldState> _scaffoldKey1 = new GlobalKey<ScaffoldState>();
  String role = "";
  @override
  void initState() {
    super.initState();
    getrole();
  }

  getrole() async {
    role = (await SPManager().getroleid())!;
    getprofiledata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: customcolor.greybg,
      resizeToAvoidBottomInset: false,

//       floatingActionButton: FloatingActionButton(
//         //Floating action button on Scaffold
//         backgroundColor: customcolor.white,
//         onPressed: () {
//          Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (BuildContext context) => HomePage()

//                             ));
//         },
//         child:  Image.asset(
//                                   "assets/images/greyhome.png",
// color: customcolor.greytext,
//                                   width: 20,
//                                   height: 20,
//                                 ), //icon inside button
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      //floating action button position to center
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(148),
        child: AppbarComman(
            setStyleStr: 'PROFILE',
            onPressedBack: () {},
            onPressedNotify: () {},
            onPressedSearch: () {},
            onPressedSort: () {},
            onPressedmenu: () {
              _scaffoldKey1.currentState!.openEndDrawer();
            }),
      ),
      endDrawer: Theme(
        data: Theme.of(context).copyWith(
            canvasColor: customcolor.blue, primaryColor: customcolor.blue),
        child: AppDrawerfilter(role),
      ),

      key: _scaffoldKey1,
      //  bottomNavigationBar:
      // bottomNavigationBar: CustomBottomNavigationBar(index: 3),
      body: SafeArea(
        child: isprofileLoading?Center(child: Column(
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
            Column(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 20, bottom: 20),
                    child: Container(
                      child: ListView(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        children: [
                          Container(
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
                                Text(
                                  "PROFILE",
                                  style: AppFonts.headerStyle(
                                      fontSize: ResponsiveFlutter.of(context)
                                          .fontSize(2.3),
                                      color: customcolor.black,
                                      fontWeight: FontWeight.w300),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Card(
                              color: customcolor.skybluebg,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    FormTextFieldBorder(
                                      isEnable: false,
                                      textcontroller: namecontroller,
                                      placeholderStr: "Name",
                                      lengthofmobile: 10,
                                      //   maxLength: 10,
                                      textInputType: TextInputType.text,
                                      onchange: (val) {},
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    FormTextFieldBorder(
                                      isEnable: false,

                                      textcontroller: descriptioncontroller,
                                      placeholderStr: "Designation",
                                      lengthofmobile: 10,
                                      //   maxLength: 10,
                                      textInputType: TextInputType.text,
                                      onchange: (val) {},
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    FormTextFieldBorder(
                                      isEnable: false,
                                      textcontroller: mobilecontroller,
                                      placeholderStr: "Mobile No",
                                      lengthofmobile: 10,
                                      //   maxLength: 10,
                                      textInputType: TextInputType.text,
                                      onchange: (val) {},
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    FormTextFieldBorder(
                                      isEnable: false,
                                      textcontroller: emailcontroller,
                                      placeholderStr: "Email",
                                      lengthofmobile: 10,
                                      //   maxLength: 10,
                                      textInputType: TextInputType.text,
                                      onchange: (val) {},
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Center(
                                      child: MyElevatedButton(
                                        setStyleStr: 'home',
                                        width:
                                            SizeConfig.blockSizeHorizontal * 80,
                                        height:
                                            SizeConfig.blockSizeVertical * 6,
                                        onPressed: () {
                                          dologoutApi();
                                        },
                                        borderRadius: BorderRadius.circular(5),
                                        colorvalue: customcolor.blue,
                                        child:doLogoutLoader?CircularProgressIndicator(color: customcolor.white,): Text('Logout'),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                  ],
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  height: 30, child: Center(child: Text("Version 2.0.0"))),
            ),
          ],
        ),
      ),
    );
  }
bool doLogoutLoader=false;
  dologoutApi() async {
    var status1 = await ConnectionDetector.checkInternetConnection();

    if (status1) {
      // ShowDialogs.showLoadingDialog(context, _keyLoader);
setState(() {
  doLogoutLoader=true;
});
      var map = new Map<String, dynamic>();

      var token = await SPManager().getAuthToken();
      print(token);
      map['token'] = token;

      APIManager().apiRequest(context, API.logout, (response) async {
        LogoutResponse resp = response;
        print('called API ${resp}');
        print("TOKEN ON SPLASH is calling");
        if (resp.status == 1) {
          setState(() {
  doLogoutLoader=false;
});
          // Navigator.of(this.context).pop();
          ShowDialogs.showToast(resp.msg);
          SPManager().setAuthToken("");
           final prefs = await SharedPreferences.getInstance();
           await prefs.remove('unit_dashboard_cache'); // remove cached dashboard
  await prefs.remove('clientdashboardApi');
  await prefs.remove("dashboardApi");
          print("TOKEN ON SPLASH is emplaty");
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) => LoginScreen(),
            ),
          );
        } else {
          ShowDialogs.showToast(resp.msg);
            setState(() {
  doLogoutLoader=false;
});
          // Navigator.of(this.context).pop();
        }
      }, (error) {
        print('ERR msg is $error');
          setState(() {
  doLogoutLoader=false;
});
        // Navigator.of(this.context).pop();
      }, false, "", jsonval: map);
    } else {
      ShowDialogs.showToast("Please check internet connection");
    }
  }
 bool isprofileLoading=false;
  getprofiledata() async {
    var status1 = await ConnectionDetector.checkInternetConnection();

    if (status1) {
      String? token = await SPManager().getsupervisorid();
      String params = "?id=$token";
     
setState(() {
  isprofileLoading=true;
});
      try {
        APIManager().apiRequest(context, API.SingleView_Employee,
            (response) async {
              setState(() {
  isprofileLoading=false;
});
          // Navigator.of(_keyLoader.currentContext!).pop();
          if (response.status == 1) {
            ProfileResponse resp = response;
            setState(() {
              if (role == GlobalLists.clientrole) {
                namecontroller.text = resp.data.empName;
                descriptioncontroller.text = resp.data.empTypeStr;
                mobilecontroller.text = resp.data.contact;
                emailcontroller.text = resp.data.empEmailId;
              } else {
                namecontroller.text = resp.data.empName;
                descriptioncontroller.text = resp.data.empTypeStr;
                mobilecontroller.text = resp.data.contact;
                emailcontroller.text = resp.data.empEmailId;
              }
            });
          } else {
            ShowDialogs.showToast(response.msg);
          }
        }, (error) {
          print('ERR msg is $error');
        }, false, "", path: params);
      } catch (error) {
        print(error);
      }
    } else {
      ShowDialogs.showToast("Please check internet connection");
    }
  }
}
