import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:janpro/Utitlity/custom_color.dart';
import 'package:janpro/Utitlity/sizeConfig.dart';

// ignore: must_be_immutable
class FormTextFieldButton extends StatelessWidget {
  String placeholderStr, placeholderImg;
  String hinttext;
  TextInputType textInputType;
  TextEditingController textcontroller;
  final TextInputAction inputAction;
  FocusNode? focusNode = FocusNode();
  bool validate;
  bool hintvalidate;
  // bool suffixIcon;
  bool obscuretext = false;
  String value;
  //List<TextInputFormatter> fieldInputFormatter;
  Widget? suffixWidget;
  Widget? prefixwidget;
  //Function(String) fieldValidator;
//  FocusNode focusNode;
  double fontSize;
  int maxLines;
  int? maxLength;
  bool isEnable;
  double contaninerheigth;
  double contaninerwidth;
  Function(String)? onchange;
  Function(String)? onfieldsubmitted;
  int? lengthofmobile;
  Color bgcolor;
  Color textcolor;
  double top;
   double left;
  double bottom;
  TextAlign align;

  TextEditingController defaultval = TextEditingController();
  FormTextFieldButton(
      {required this.textcontroller,
      this.suffixWidget,
      this.contaninerheigth= 50,
      this.focusNode,
      this.validate= false,
      this.hintvalidate= false,
      this.obscuretext = false,
      this.placeholderStr= "",
      this.placeholderImg= "",
      this.inputAction= TextInputAction.next,
      this.textInputType= TextInputType.text,
      this.value = "",
      this.maxLines = 1,
      this.maxLength,
      this.hinttext = "",
      this.isEnable = true,
      this.onchange,
      this.onfieldsubmitted,
      this.prefixwidget,
      this.lengthofmobile,
      this.fontSize= 12,this.bgcolor=customcolor.white,this.contaninerwidth=50,
      this.textcolor=customcolor.white,this.top=0,this.left=5,this.bottom=0,this.align=TextAlign.left});

  // ButtonCallback onSuffixClick;
  //final ReturnKeyCallback onReturnKeyPress;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: Text("$placeholderStr"),
        // ),
        Container(
             width:contaninerwidth ,
          height: contaninerheigth,

          decoration: BoxDecoration(
            color: bgcolor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(width: 1, color: customcolor.greyborder)),
          
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: TextFormField(
            textAlign:align,
            textCapitalization: TextCapitalization.sentences,
            enabled: isEnable == null ? true : isEnable,
            inputFormatters: lengthofmobile == 10
                ? [
                    LengthLimitingTextInputFormatter(10),
                  ]
                : [],
            enableSuggestions: false,
            autocorrect: false,
            maxLines: maxLines,
            maxLength: maxLength,
            onChanged: onchange,
            //  focusNode: focusNode != null ? focusNode : null,
            //initialValue: value != null ? value : null,
            textInputAction:
                inputAction == null ? TextInputAction.next : inputAction,
            obscureText: obscuretext == null ? false : obscuretext,
            controller: textcontroller,
            keyboardType:
                textInputType == null ? TextInputType.text : textInputType,
            // validator: fieldValidator == null
            //     ? ((val) => validate == false
            //         ? null
            //         : val.length == 0
            //             ? 'Enter ' + placeholderStr
            //             : null)
            //     : fieldValidator,
            style:
             AppFonts.headerStyle(fontSize:12,
                              color: textcolor,
                              fontWeight: FontWeight.w400  ),
            
            decoration: InputDecoration(
              border: InputBorder.none,
              // enabledBorder: UnderlineInputBorder(
              //   borderSide: BorderSide(color: customcolor.darkgrey),
              // ),
              // focusedBorder: UnderlineInputBorder(
              //   borderSide: BorderSide(color: customcolor.darkgrey),
              // ),
               //labelText: (validate) ? '$placeholderStr *' : '$placeholderStr',
              hintText: hintvalidate == true ? hinttext : placeholderStr,
              contentPadding: EdgeInsets.only(top: top, left: left, right: 0,bottom: bottom),
              suffixIcon: suffixWidget,
              prefixIcon: prefixwidget,
              labelStyle:
              AppFonts.headerStyle(fontSize:12,
                              color: textcolor,
                              fontWeight: FontWeight.w400  ),
              
              hintStyle: AppFonts.headerStyle(fontSize:12,
                              color: textcolor,
                              fontWeight: FontWeight.w400  ),
            ),
            //inputFormatters: fieldInputFormatter,
            onFieldSubmitted: onfieldsubmitted,
            //onChanged: onchange,
          ),
        )
      ],
    );
  }
}

typedef ButtonCallback = void Function();
typedef ReturnKeyCallback = void Function();
