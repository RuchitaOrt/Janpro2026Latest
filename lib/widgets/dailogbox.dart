import 'package:flutter/material.dart';
import 'package:janpro/Utitlity/custom_color.dart';

class Dailogbox{

    showLegendDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Attendance Legend',
            style: TextStyle(fontFamily: AppFonts.semibold, fontSize: 18),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                _legendDot( Color(0xFF22C55E), "Present"),
                _legendDot(  Color(0xFFEF4444), "Absent"),
                _legendDot(  Color(0xFF7DD3FC), "Holiday"),
                _legendDot(  Color(0xFF2563EB), "Working Holiday"),
                _legendDot(  Color(0xFF4ADE80), "Halfday"),
                _legendDot(  Color(0xFF8B5CF6), "OT Hrs"),





                _legendDot(customcolor.pink, "Client Reason"),
                _legendDot(customcolor.red, "OM/OE rejected"),
                _legendDot(customcolor.lightgreen, "Present/Absent"),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Close',
                style: TextStyle(
                  fontFamily: AppFonts.semibold,
                  color: customcolor.blue,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _legendDot(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 11,
            color: Colors.black87,
            fontFamily: AppFonts.regular,
          ),
        ),
      ],
    );
  }
  // int count

}