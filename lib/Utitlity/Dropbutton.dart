import 'package:flutter/material.dart';
import 'package:janpro/Screens/Workflowstatus.dart';
import 'package:janpro/Utitlity/button.dart';
import 'package:janpro/Utitlity/sizeConfig.dart';
import 'package:janpro/model/WorkfowstatusResponse.dart';
import 'package:janpro/Utitlity/custom_color.dart';


class DropButton extends StatefulWidget {
  
 final int indexvalue;
 final String title;
 final List<MasterAreaWiseList> checkboxeslist;
 final List multipleSelectedlist;
 final bool isExpanded;
  DropButton(this.indexvalue, this.title, this.checkboxeslist, this.multipleSelectedlist, this.isExpanded);

  @override
  _DropButton createState() => _DropButton();
}

class _DropButton extends State<DropButton> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Container(
      
      color: customcolor.white,
      margin: EdgeInsets.symmetric(vertical: 5.0),
      child: Column(
        children: <Widget>[

            widget.isExpanded?      Padding(
              padding: const EdgeInsets.only(top: 10,left: 20,right: 20),
              child: Divider(),
            ):Container(),
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: [
                    // Image.network(img, width: 25, height: 25, errorBuilder:
                    //     (BuildContext context, Object exception,
                    //         StackTrace? stackTrace) {
                    //   return Container();
                    // }),
                    // SizedBox(
                    //   width: 15,
                    // ),
                    Text(
                      'title',
                      style: TextStyle(
                          color: customcolor.black,
                          fontSize: 16,
                          fontFamily: AppFonts.medium,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                Icon(
                  widget.isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.black,
                  size: 30.0,
                ),
              ],
            ),
          ),
           
          ExpandableContainer(
            expanded: widget.isExpanded,
            expandedHeight: 180,

            child: ListView(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              children: [
            
                 Padding(
              padding: const EdgeInsets.only(left: 5,right:5),
              child: Divider(color: customcolor.greytext,thickness: 0.5,),
            ),
              
                SizedBox(height: 15,),
                                        MyElevatedButton(
                                                                    setStyleStr:
                                                                        'home',
                                                                    width: 120,
                                                                    height: SizeConfig
                                                                            .blockSizeVertical *
                                                                        6,
                                                                    onPressed:
                                                                        () {
                                                                      print("multipleSelectedlist");
                         
                                                                    },
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                5),
                                                                    colorvalue: customcolor.blue,
                                                                    child: Text(
                                                                        'Update'),
                                                                  ),
                                                                  SizedBox(height: 10,),   
              ],
            ),

          )
        ],
      ),
    );
  }
}

class ExpandableContainer extends StatelessWidget {
  final bool expanded;
  final double collapsedHeight;
  final double expandedHeight;
  final Widget child;

  ExpandableContainer({
    required this.child,
    this.collapsedHeight = 0.0,
    this.expandedHeight = 300.0,
    this.expanded = true,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      width: screenWidth,
      height: expanded ? expandedHeight : collapsedHeight,
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 20),
        // child: Divider(
        //   color: customcolor.greyborder,
        // ),
        child: Container(
          //  color: Colors.black,
          child: child,
          // decoration: BoxDecoration(
          //     border: Border.all(width: 0.2, color: customcolor.greyborder)),
        ),
      ),
    );
  }
}
