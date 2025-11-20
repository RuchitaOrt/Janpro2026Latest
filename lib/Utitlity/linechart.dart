import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:janpro/Utitlity/GlobalLists.dart';
import 'package:janpro/Utitlity/custom_color.dart';
import 'package:janpro/model/AttendencelistResponse.dart';
import 'package:janpro/model/unitAttendanceResponse.dart' as unitatt;
import 'package:janpro/model/TrendGraphResponse.dart' as trend;
import 'package:janpro/model/unitGraphAttendanceResponse.dart' as graph;

class LineChartSample2 {
  static double barwidthvalue = 2.5;
  static double strokeradiusvalue = 2.8;
  static double strokeWidthvalue = 1.4;
  static const whitevalue = const Color(0xffFFFFFF);
  static const greenvalue = const Color(0xff78BE21);

  static List<Color> gradientColors = [
    customcolor.green,
    customcolor.white,
    customcolor.white,
  ];
  static Alignment beginvalue = Alignment.topCenter;
  static Alignment endvalue = Alignment.topCenter;
  static List<Color> insidegradientcolor = [
    // Colors.lightGreen[500]!,
    Colors.lightGreen[300]!,
    Colors.lightGreen[50]!

    // customcolor.green,
    //  customcolor.green,
    //    customcolor.green,
//          customcolor.green,

//  customcolor.green.withOpacity(0.5),
//        customcolor.green.withOpacity(0.5),
//             customcolor.green.withOpacity(0.5),
//              Color.fromARGB(255, 207, 221, 190),
//                Color.fromARGB(255, 207, 221, 190),
//                  Color.fromARGB(255, 207, 221, 190).withOpacity(0.4),
//               // Color.fromARGB(255, 207, 221, 190).withOpacity(0.4),
//       //  customcolor.white,
//      customcolor.white,
  ];

  static Widget bottomTitleWidgets(double value, TitleMeta meta) {
    TextStyle style = TextStyle(
      fontFamily: AppFonts.didot,
      fontWeight: FontWeight.normal,
      fontSize: 12,
    );
    Widget text;
    switch (value.toInt()) {
      case 2:
        text = Text(GlobalLists.graphlist[0].monthname, style: style);
        break;
      case 4:
        text = Text(GlobalLists.graphlist[1].monthname, style: style);
        break;
      case 6:
        text = Text(GlobalLists.graphlist[2].monthname, style: style);
        break;
      case 8:
        text = Text(GlobalLists.graphlist[3].monthname, style: style);
        break;
      case 10:
        text = Text(GlobalLists.graphlist[4].monthname, style: style);
        break;
      case 12:
        text = Text(GlobalLists.graphlist[5].monthname, style: style);
        break;
      default:
        text = Text('', style: style);
        break;
    }

    return SideTitleWidget(
      meta: meta,
      child: text,
    );
  }

//trend

  static Widget bottomtrendTitleWidgets(double value, TitleMeta meta) {
    TextStyle style = TextStyle(
      fontFamily: AppFonts.didot,
      fontWeight: FontWeight.normal,
      fontSize: 12,
    );
    Widget text;
    switch (value.toInt()) {
      case 2:
        text = Text(GlobalLists.trendgraphlist[0].monthname, style: style);
        break;
      case 4:
        text = Text(GlobalLists.trendgraphlist[1].monthname, style: style);
        break;
      case 6:
        text = Text(GlobalLists.trendgraphlist[2].monthname, style: style);
        break;
      case 8:
        text = Text(GlobalLists.trendgraphlist[3].monthname, style: style);
        break;
      case 10:
        text = Text(GlobalLists.trendgraphlist[4].monthname, style: style);
        break;
      case 12:
        text = Text(GlobalLists.trendgraphlist[5].monthname, style: style);
        break;
      default:
        text = Text('', style: style);
        break;
    }

    return SideTitleWidget(
      meta: meta,
      child: text,
    );
  }

  static Widget bottomTitleWidgetssupervisor(double value, TitleMeta meta) {
    TextStyle style = TextStyle(
      fontFamily: AppFonts.didot,
      fontWeight: FontWeight.normal,
      fontSize: 12,
    );
    Widget text;
    switch (value.toInt()) {
      case 2:
        text = Text(GlobalLists.superviorgraphlist[0].monthname, style: style);
        break;
      case 4:
        text = Text(GlobalLists.superviorgraphlist[1].monthname, style: style);
        break;
      case 6:
        text = Text(GlobalLists.superviorgraphlist[2].monthname, style: style);
        break;
      case 8:
        text = Text(GlobalLists.superviorgraphlist[3].monthname, style: style);
        break;
      case 10:
        text = Text(GlobalLists.superviorgraphlist[4].monthname, style: style);
        break;
      case 12:
        text = Text(GlobalLists.superviorgraphlist[5].monthname, style: style);
        break;
      default:
        text = Text('', style: style);
        break;
    }

    return SideTitleWidget(
      meta: meta,
      child: text,
    );
  }
//rating

  static Widget bottomratingTitleWidgets(double value, TitleMeta meta) {
    TextStyle style = TextStyle(
      fontFamily: AppFonts.didot,
      fontWeight: FontWeight.normal,
      fontSize: 12,
    );
    Widget text;
    switch (value.toInt()) {
      case 2:
        text = Text(GlobalLists.ratinggraphlist[0].monthname, style: style);
        break;
      case 4:
        text = Text(GlobalLists.ratinggraphlist[1].monthname, style: style);
        break;
      case 6:
        text = Text(GlobalLists.ratinggraphlist[2].monthname, style: style);
        break;
      case 8:
        text = Text(GlobalLists.ratinggraphlist[3].monthname, style: style);
        break;
      case 10:
        text = Text(GlobalLists.ratinggraphlist[4].monthname, style: style);
        break;
      case 12:
        text = Text(GlobalLists.ratinggraphlist[5].monthname, style: style);
        break;
      default:
        text = Text('', style: style);
        break;
    }

    return SideTitleWidget(
      meta: meta,
      child: text,
    );
  }

  //

  static Widget bottomratingTitlelistWidgets(double value, TitleMeta meta) {
    print(GlobalLists.ratingclienttag);
    print(GlobalLists.ratinglistwisegraphlist[GlobalLists.ratingclienttag]
        .monthWisedata.length
        .toString());
    TextStyle style = TextStyle(
      fontFamily: AppFonts.didot,
      fontWeight: FontWeight.normal,
      fontSize: 12,
    );
    Widget text;
    switch (value.toInt()) {
      case 2:
        text = Text(
            GlobalLists.ratinglistwisegraphlist[GlobalLists.ratingclienttag]
                .monthWisedata[0].monthname,
            style: style);
        break;
      case 4:
        text = Text(
            GlobalLists.ratinglistwisegraphlist[GlobalLists.ratingclienttag]
                .monthWisedata[1].monthname,
            style: style);
        break;
      case 6:
        text = Text(
            GlobalLists.ratinglistwisegraphlist[GlobalLists.ratingclienttag]
                .monthWisedata[2].monthname,
            style: style);
        break;
      case 8:
        text = Text(
            GlobalLists.ratinglistwisegraphlist[GlobalLists.ratingclienttag]
                .monthWisedata[3].monthname,
            style: style);
        break;
      case 10:
        text = Text(
            GlobalLists.ratinglistwisegraphlist[GlobalLists.ratingclienttag]
                .monthWisedata[4].monthname,
            style: style);
        break;
      case 12:
        text = Text(
            GlobalLists.ratinglistwisegraphlist[GlobalLists.ratingclienttag]
                .monthWisedata[5].monthname,
            style: style);
        break;
      default:
        text = Text('', style: style);
        break;
    }

    return SideTitleWidget(
     meta: meta,
      child: text,
    );
  }

//
  static Widget bottomtrainingTitlelistWidgets(double value, TitleMeta meta) {
    TextStyle style = TextStyle(
      fontFamily: AppFonts.didot,
      fontWeight: FontWeight.normal,
      fontSize: 12,
    );
    Widget text;
    switch (value.toInt()) {
      case 2:
        text = Text(GlobalLists.traininggraphlist[0].monthname, style: style);
        break;
      case 4:
        text = Text(GlobalLists.traininggraphlist[1].monthname, style: style);
        break;
      case 6:
        text = Text(GlobalLists.traininggraphlist[2].monthname, style: style);
        break;
      case 8:
        text = Text(GlobalLists.traininggraphlist[3].monthname, style: style);
        break;
      case 10:
        text = Text(GlobalLists.traininggraphlist[4].monthname, style: style);
        break;
      case 12:
        text = Text(GlobalLists.traininggraphlist[5].monthname, style: style);
        break;
      default:
        text = Text('', style: style);
        break;
    }

    return SideTitleWidget(
     meta: meta,
      child: text,
    );
  }

  static Widget bottomvisitTitlelistWidgets(double value, TitleMeta meta) {
    TextStyle style = TextStyle(
      fontFamily: AppFonts.didot,
      fontWeight: FontWeight.normal,
      fontSize: 12,
    );
    Widget text;
    switch (value.toInt()) {
      case 2:
        text = Text(GlobalLists.visitGraphlist[0].monthname, style: style);
        break;
      case 4:
        text = Text(GlobalLists.visitGraphlist[1].monthname, style: style);
        break;
      case 6:
        text = Text(GlobalLists.visitGraphlist[2].monthname, style: style);
        break;
      case 8:
        text = Text(GlobalLists.visitGraphlist[3].monthname, style: style);
        break;
      case 10:
        text = Text(GlobalLists.visitGraphlist[4].monthname, style: style);
        break;
      case 12:
        text = Text(GlobalLists.visitGraphlist[5].monthname, style: style);
        break;
      default:
        text = Text('', style: style);
        break;
    }

    return SideTitleWidget(
      meta: meta,
      child: text,
    );
  }

  static Widget leftTitleWidgets(double value, TitleMeta meta) {
    TextStyle style = TextStyle(
      fontFamily: AppFonts.didot,
      fontWeight: FontWeight.normal,
      fontSize: 12,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '10%';
        break;
      case 2:
        text = '20%';
        break;
      case 3:
        text = '30%';
        break;
      case 4:
        text = '40%';
        break;
      case 5:
        text = '50%';
        break;
      case 6:
        text = '60%';
        break;
      case 7:
        text = '70%';
        break;
      case 8:
        text = '80%';
        break;
      case 9:
        text = '90%';
        break;
      case 10:
        text = '100%';
        break;

      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  static Widget leftTitleWidgetsattendancetrend(double value, TitleMeta meta) {
    TextStyle style = TextStyle(
      fontFamily: AppFonts.didot,
      fontWeight: FontWeight.normal,
      fontSize: 12,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '10%';
        break;
      case 2:
        text = '20%';
        break;
      case 3:
        text = '30%';
        break;
      case 4:
        text = '40%';
        break;
      case 5:
        text = '50%';
        break;
      case 6:
        text = '60%';
        break;
      case 7:
        text = '70%';
        break;
      case 8:
        text = '80%';
        break;
      case 9:
        text = '90%';
        break;
      case 10:
        text = '100%';
        break;

      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }
  //training

  static Widget leftTitleWidgetstraining(double value, TitleMeta meta) {
    TextStyle style = TextStyle(
      fontFamily: AppFonts.didot,
      fontWeight: FontWeight.normal,
      fontSize: 12,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '10%';
        break;
      case 2:
        text = '20%';
        break;
      case 3:
        text = '30%';
        break;
      case 4:
        text = '40%';
        break;
      case 5:
        text = '50%';
        break;
      case 6:
        text = '60%';
        break;
      case 7:
        text = '70%';
        break;
      case 8:
        text = '80%';
        break;
      case 9:
        text = '90%';
        break;
      case 10:
        text = '100%';
        break;

      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }
//rating

  static Widget leftTitleWidgetsvisit(double value, TitleMeta meta) {
    TextStyle style = TextStyle(
      fontFamily: AppFonts.didot,
      fontWeight: FontWeight.normal,
      fontSize: 12,
    );
    String text;
    switch (value.toInt()) {
      case 2:
        text = '2';
        break;
      case 4:
        text = '4';
        break;
      case 6:
        text = '6';
        break;
      case 8:
        text = '8';
        break;
      case 10:
        text = '10';
        break;
      case 12:
        text = '12';
        break;
      case 14:
        text = '14';
        break;
      case 16:
        text = '16';
        break;
      case 18:
        text = '18';
        break;
      case 20:
        text = '20';
        break;
      case 22:
        text = '22';
        break;
      case 24:
        text = '24';
        break;
      case 26:
        text = '26';
        break;

      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }
//rating

  static Widget leftTitleWidgetsrating(double value, TitleMeta meta) {
    TextStyle style = TextStyle(
      fontFamily: AppFonts.didot,
      fontWeight: FontWeight.normal,
      fontSize: 12,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '1';
        break;
      case 2:
        text = '2';
        break;
      case 3:
        text = '3';
        break;
      case 4:
        text = '4';
        break;
      case 5:
        text = '5';
        break;
      case 6:
        text = '6';
        break;
      case 7:
        text = '7';
        break;
      case 8:
        text = '8';
        break;
      case 9:
        text = '9';
        break;
      case 10:
        text = '10';
        break;

      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  static LineChartData mainData(List<graph.GraphDatum> graph) {
    print("GRAPH");
    return LineChartData(
      borderData: FlBorderData(show: false),

      gridData: FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        // show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      // borderData: FlBorderData(
      //   show: true,
      //   border: Border.all(color: const Color(0xff37434d)),
      // ),
      minX: 2,
      maxX: 12,
      minY: 0,
      maxY: 10,
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          // tooltipBgColor: customcolor.green,
          // tooltipBgColor: customcolor.green,
           getTooltipColor: (touchedSpot) => customcolor.green,
      

           
          getTooltipItems: (List<LineBarSpot> touchedSpots) {
            return touchedSpots.map((LineBarSpot touchedSpot) {
              final percentage = touchedSpot.y * 10;
              //   (touchedSpot.y / spots.map((s) => s.y).reduce((a, b) => a + b)) * 100;
              return LineTooltipItem(
                '${percentage.toStringAsFixed(0)}%',
                TextStyle(color: Colors.white),
              );
            }).toList();
          },
          
        ),
      ),
      
      lineBarsData: [
        LineChartBarData(
          preventCurveOverShooting: true,
          preventCurveOvershootingThreshold: 10.0,
          spots: [
            //xaxis
            //2,4,6,8,10,12

            //yaxis
            //1,3,5,7,9,11,13,15,17
            //  FlSpot(0, 0),
            FlSpot(2,
                double.parse(GlobalLists.graphlist[0].percentage.toString())),
            FlSpot(4,
                double.parse(GlobalLists.graphlist[1].percentage.toString())),
            FlSpot(6,
                double.parse(GlobalLists.graphlist[2].percentage.toString())),

            // FlSpot(8, 1.3),
            // FlSpot(10, 4.5),
            // FlSpot(12, 10),
            FlSpot(8,
                double.parse(GlobalLists.graphlist[3].percentage.toString())),
            FlSpot(10,
                double.parse(GlobalLists.graphlist[4].percentage.toString())),
            FlSpot(12,
                double.parse(GlobalLists.graphlist[5].percentage.toString())),
            // FlSpot(2, 3),
            // FlSpot(4, 9),
            // FlSpot(6, 1),

            // FlSpot(8, 11),
            // FlSpot(10, 7),
            // FlSpot(12, 15),
            //           FlSpot(11, 4),
            //              FlSpot(13, 2),
            //                    FlSpot(15, 3),
            // FlSpot(17, 3),

//             FlSpot(0, 3),
//             FlSpot(2.6, 2),
//             FlSpot(4.9, 8),

//             FlSpot(6.8, 3.1),
//             FlSpot(8, 4),
//             FlSpot(9.5, 3),
//             FlSpot(11, 4),
//                FlSpot(13, 2),
//                      FlSpot(15, 3),
//  FlSpot(17, 6),
//           FlSpot(18, 8),
          ],
          isCurved: true,
          // gradient: LinearGradient(
          //   colors: gradientColors,
          // ),
          barWidth: barwidthvalue,
          color: customcolor.green,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                  radius: strokeradiusvalue,
                  color: whitevalue,
                  strokeWidth: strokeWidthvalue,
                  strokeColor: greenvalue);
            },
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: beginvalue,
              end: endvalue,
              colors: insidegradientcolor,
              stops: [0.0, 1.0],
              tileMode: TileMode.mirror,
            ),
            // gradient: LinearGradient(
            //   // colors: gradientColors
            //   colors: gradientColors
            //       .map((color) => color.withOpacity(0.9))
            //       .toList(),
            // ),
          ),
        ),
      ],
    );
  }
//trend attendance

  static LineChartData trendmainData(List<trend.GraphDatum> graph) {
    print("Grafp");
    print(GlobalLists.trendgraphlist[4].percentage.toString());
    print(GlobalLists.trendgraphlist[5].percentage.toString());
    return LineChartData(
      borderData: FlBorderData(show: false),

      gridData: FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        // show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomtrendTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgetsattendancetrend,
            reservedSize: 42,
          ),
        ),
      ),
      // borderData: FlBorderData(
      //   show: true,
      //   border: Border.all(color: const Color(0xff37434d)),
      // ),
      minX: 2,
      maxX: 12,
      minY: 0,
      maxY: 10,
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          // tooltipBgColor: customcolor.green,
           getTooltipColor: (touchedSpot) => customcolor.green,
          getTooltipItems: (List<LineBarSpot> touchedSpots) {
            return touchedSpots.map((LineBarSpot touchedSpot) {
              final percentage = touchedSpot.y * 10;
              //   (touchedSpot.y / spots.map((s) => s.y).reduce((a, b) => a + b)) * 100;
              return LineTooltipItem(
                '${percentage.toStringAsFixed(0)}%',
                TextStyle(color: Colors.white),
              );
            }).toList();
          },
        ),
      ),
      lineBarsData: [
        LineChartBarData(
          preventCurveOverShooting: true,
          preventCurveOvershootingThreshold: 10.0,
          spots: [
            //xaxis
            //2,4,6,8,10,12

            //yaxis
            //1,3,5,7,9,11,13,15,17
            //  FlSpot(0, 0),
            FlSpot(
                2,
                double.parse(
                    GlobalLists.trendgraphlist[0].percentage.toString())),
            FlSpot(
                4,
                double.parse(
                    GlobalLists.trendgraphlist[1].percentage.toString())),
            FlSpot(
                6,
                double.parse(
                    GlobalLists.trendgraphlist[2].percentage.toString())),
            //      FlSpot(8, 1.3),
            // FlSpot(10, 4.5),
            // FlSpot(12, 10),

            FlSpot(
                8,
                double.parse(
                    GlobalLists.trendgraphlist[3].percentage.toString())),
            FlSpot(
                10,
                double.parse(
                    GlobalLists.trendgraphlist[4].percentage.toString())),
            FlSpot(
                12,
                double.parse(
                    GlobalLists.trendgraphlist[5].percentage.toString())),
            // FlSpot(2, 3),
            // FlSpot(4, 9),
            // FlSpot(6, 1),

            // FlSpot(8, 11),
            // FlSpot(10, 7),
            // FlSpot(12, 15),
            //           FlSpot(11, 4),
            //              FlSpot(13, 2),
            //                    FlSpot(15, 3),
            // FlSpot(17, 3),

//             FlSpot(0, 3),
//             FlSpot(2.6, 2),
//             FlSpot(4.9, 8),

//             FlSpot(6.8, 3.1),
//             FlSpot(8, 4),
//             FlSpot(9.5, 3),
//             FlSpot(11, 4),
//                FlSpot(13, 2),
//                      FlSpot(15, 3),
//  FlSpot(17, 6),
//           FlSpot(18, 8),
          ],
          isCurved: true,
          // gradient: LinearGradient(
          //   colors: gradientColors,
          // ),
          barWidth: barwidthvalue,
          color: customcolor.green,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                  radius: strokeradiusvalue,
                  color: whitevalue,
                  strokeWidth: strokeWidthvalue,
                  strokeColor: greenvalue);
            },
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: beginvalue,
              end: endvalue,
              colors: insidegradientcolor,
              stops: [0.0, 1.0],
              tileMode: TileMode.mirror,
            ),
            // gradient: LinearGradient(
            //   // colors: gradientColors
            //   colors: gradientColors
            //       .map((color) => color.withOpacity(0.9))
            //       .toList(),
            // ),
          ),
        ),
      ],
    );
  }

  static LineChartData supervisormainData(List<GraphDatum> graph) {
    return LineChartData(
      borderData: FlBorderData(show: false),

      gridData: FlGridData(
        show: false,
        // drawVerticalLine: true,
        // horizontalInterval: 1,
        // verticalInterval: 1,
        // getDrawingHorizontalLine: (value) {
        //   return  FlLine(
        //     color: customcolor.appbarcolor,
        //     strokeWidth: 1,
        //   );
        // },
        // getDrawingVerticalLine: (value) {
        //   return  FlLine(
        //     color: customcolor.appbarcolor,
        //     strokeWidth: 1,
        //   );
        //},
      ),
      titlesData: FlTitlesData(
        // show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgetssupervisor,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      // borderData: FlBorderData(
      //   show: true,
      //   border: Border.all(color: const Color(0xff37434d)),
      // ),
      minX: 2,
      maxX: 12,
      minY: 0,
      maxY: 10,
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          // tooltipBgColor: customcolor.green,
           getTooltipColor: (touchedSpot) => customcolor.green,
          getTooltipItems: (List<LineBarSpot> touchedSpots) {
            return touchedSpots.map((LineBarSpot touchedSpot) {
              final percentage = touchedSpot.y * 10;
              //   (touchedSpot.y / spots.map((s) => s.y).reduce((a, b) => a + b)) * 100;
              return LineTooltipItem(
                '${percentage.toStringAsFixed(0)}%',
                TextStyle(color: Colors.white),
              );
            }).toList();
          },
        ),
      ),
      lineBarsData: [
        LineChartBarData(
          // curveSmoothness: 0.01,
          preventCurveOverShooting: true,
          preventCurveOvershootingThreshold: 10.0,
          spots: [
            //xaxis
            //2,4,6,8,10,12

            //yaxis
            //1,3,5,7,9,11,13,15,17
            //  FlSpot(0, 0),
            FlSpot(
                2,
                double.parse(
                    GlobalLists.superviorgraphlist[0].percentage.toString())),
            FlSpot(
                4,
                double.parse(
                    GlobalLists.superviorgraphlist[1].percentage.toString())),
            FlSpot(
                6,
                double.parse(
                    GlobalLists.superviorgraphlist[2].percentage.toString())),

            FlSpot(
                8,
                double.parse(
                    GlobalLists.superviorgraphlist[3].percentage.toString())),
            FlSpot(
                10,
                double.parse(
                    GlobalLists.superviorgraphlist[4].percentage.toString())),
            FlSpot(
                12,
                double.parse(
                    GlobalLists.superviorgraphlist[5].percentage.toString())),
            // FlSpot(8, 3),
            // FlSpot(10, 9),
            // FlSpot(12, 1),

            // FlSpot(8, 0),
            // FlSpot(10, 7),
            // FlSpot(12, 15),
            //           FlSpot(11, 4),
            //              FlSpot(13, 2),
            //                    FlSpot(15, 3),
            // FlSpot(17, 3),

//             FlSpot(0, 3),
//             FlSpot(2.6, 2),
//             FlSpot(4.9, 8),

//             FlSpot(6.8, 3.1),
//             FlSpot(8, 4),
//             FlSpot(9.5, 3),
//             FlSpot(11, 4),
//                FlSpot(13, 2),
//                      FlSpot(15, 3),
//  FlSpot(17, 6),
//           FlSpot(18, 8),
          ],
          isCurved: true,
          // gradient: LinearGradient(
          //   colors: gradientColors,
          // ),
          barWidth: barwidthvalue,
          color: customcolor.green,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                  radius: strokeradiusvalue,
                  color: whitevalue,
                  strokeWidth: strokeWidthvalue,
                  strokeColor: greenvalue);
            },
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: beginvalue,
              end: endvalue,
              colors: insidegradientcolor,
              stops: [0.0, 1.0],
              tileMode: TileMode.mirror,
            ),
            // gradient: LinearGradient(
            //   // colors: gradientColors
            //   colors: gradientColors
            //       .map((color) => color.withOpacity(0.9))
            //       .toList(),
            // ),
          ),
        ),
      ],
    );
  }

  static LineChartData mainDatarating() {
    return LineChartData(
      borderData: FlBorderData(show: false),
      gridData: FlGridData(
        show: false,
        // drawVerticalLine: true,
        // horizontalInterval: 1,
        // verticalInterval: 1,
        // getDrawingHorizontalLine: (value) {
        //   return  FlLine(
        //     color: customcolor.appbarcolor,
        //     strokeWidth: 1,
        //   );
        // },
        // getDrawingVerticalLine: (value) {
        //   return  FlLine(
        //     color: customcolor.appbarcolor,
        //     strokeWidth: 1,
        //   );
        //},
      ),
      titlesData: FlTitlesData(
        // show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomratingTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgetsrating,
            reservedSize: 42,
          ),
        ),
      ),
      // borderData: FlBorderData(
      //   show: true,
      //   border: Border.all(color: const Color(0xff37434d)),
      // ),
      minX: 2,
      maxX: 12,
      minY: 0,
      maxY: 10,
      lineBarsData: [
        LineChartBarData(
          preventCurveOverShooting: true,
          preventCurveOvershootingThreshold: 10.0,
          spots: [
            // FlSpot(0,0),
            FlSpot(
                2,
                double.parse(
                    GlobalLists.ratinggraphlist[0].percentage.toString())),
            FlSpot(
                4,
                double.parse(
                    GlobalLists.ratinggraphlist[1].percentage.toString())),
            FlSpot(
                6,
                double.parse(
                    GlobalLists.ratinggraphlist[2].percentage.toString())),

            FlSpot(
                8,
                double.parse(
                    GlobalLists.ratinggraphlist[3].percentage.toString())),
            FlSpot(
                10,
                double.parse(
                    GlobalLists.ratinggraphlist[4].percentage.toString())),
            FlSpot(
                12,
                double.parse(
                    GlobalLists.ratinggraphlist[5].percentage.toString())),

            //           FlSpot(0, 3),
            //           FlSpot(2.6, 2),
            //           FlSpot(4.9, 8),

            //           FlSpot(6.8, 3.1),
            //           FlSpot(8, 4),
            //           FlSpot(9.5, 3),
            //           FlSpot(11, 4),
            //              FlSpot(13, 2),
            //                    FlSpot(15, 3),
            // FlSpot(17, 3),
          ],
          isCurved: true,
          color: customcolor.green,
          // gradient: LinearGradient(
          //  colors: gradientColors,

          // ),
          barWidth: barwidthvalue,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                  radius: strokeradiusvalue,
                  color: whitevalue,
                  strokeWidth: strokeWidthvalue,
                  strokeColor: greenvalue);
            },
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: beginvalue,
              end: endvalue,
              colors: insidegradientcolor,
              stops: [0.0, 1.0],
              tileMode: TileMode.mirror,
            ),
            // gradient: LinearGradient(
            //   colors: gradientColors
            //       .map((color) => color.withOpacity(0.3))
            //       .toList(),
            // ),
          ),
        ),
      ],
    );
  }

  static LineChartData mainDatatraing() {
    return LineChartData(
      borderData: FlBorderData(show: false),
      gridData: FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        // show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomtrainingTitlelistWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgetstraining,
            reservedSize: 42,
          ),
        ),
      ),
      minX: 2,
      maxX: 12,
      minY: 0,
      maxY: 10,
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          // tooltipBgColor: customcolor.green,
           getTooltipColor: (touchedSpot) => customcolor.green,

          getTooltipItems: (List<LineBarSpot> touchedSpots) {
            return touchedSpots.map((LineBarSpot touchedSpot) {
              final percentage = touchedSpot.y * 10;

              return LineTooltipItem(
                '${percentage.toStringAsFixed(0)}%',
                TextStyle(color: Colors.white),
              );
            }).toList();
          },
        ),
      ),
      lineBarsData: [
        LineChartBarData(
          preventCurveOverShooting: true,
          preventCurveOvershootingThreshold: 10.0,
          spots: [
            // FlSpot(0,0),
            FlSpot(
                2,
                double.parse(
                    GlobalLists.traininggraphlist[0].percentage.toString())),
            FlSpot(
                4,
                double.parse(
                    GlobalLists.traininggraphlist[1].percentage.toString())),
            FlSpot(
                6,
                double.parse(
                    GlobalLists.traininggraphlist[2].percentage.toString())),

            FlSpot(
                8,
                double.parse(
                    GlobalLists.traininggraphlist[3].percentage.toString())),
            FlSpot(
                10,
                double.parse(
                    GlobalLists.traininggraphlist[4].percentage.toString())),
            FlSpot(
                12,
                double.parse(
                    GlobalLists.traininggraphlist[5].percentage.toString())),
          ],
          isCurved: true,
          color: customcolor.green,
          barWidth: barwidthvalue,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                  radius: strokeradiusvalue,
                  color: whitevalue,
                  strokeWidth: strokeWidthvalue,
                  strokeColor: greenvalue);
            },
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: beginvalue,
              end: endvalue,
              colors: insidegradientcolor,
              stops: [0.0, 1.0],
              tileMode: TileMode.mirror,
            ),
          ),
        ),
      ],
    );
  }

  static LineChartData mainDavistes() {
    return LineChartData(
      borderData: FlBorderData(show: false),
      gridData: FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        // show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomvisitTitlelistWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgetsvisit,
            reservedSize: 42,
          ),
        ),
      ),
      minX: 2,
      maxX: 12,
      minY: 0,
      maxY: GlobalLists.maxVisitCount <= 10 ? 10 : 26,
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          // tooltipBgColor: customcolor.green,
           getTooltipColor: (touchedSpot) => customcolor.green,
          getTooltipItems: (List<LineBarSpot> touchedSpots) {
            return touchedSpots.map((LineBarSpot touchedSpot) {
              final percentage = touchedSpot.y;

              return LineTooltipItem(
                '${percentage.toStringAsFixed(0)}',
                TextStyle(color: Colors.white),
              );
            }).toList();
          },
        ),
      ),
      lineBarsData: [
        LineChartBarData(
          preventCurveOverShooting: true,
          preventCurveOvershootingThreshold: 10.0,
          spots: [
            // FlSpot(0,0),
            FlSpot(
                2,
                double.parse(
                    GlobalLists.visitGraphlist[0].percentage.toString())),
            FlSpot(
                4,
                double.parse(
                    GlobalLists.visitGraphlist[1].percentage.toString())),
            FlSpot(
                6,
                double.parse(
                    GlobalLists.visitGraphlist[2].percentage.toString())),

            FlSpot(
                8,
                double.parse(
                    GlobalLists.visitGraphlist[3].percentage.toString())),
            FlSpot(
                10,
                double.parse(
                    GlobalLists.visitGraphlist[4].percentage.toString())),
            FlSpot(
                12,
                double.parse(
                    GlobalLists.visitGraphlist[5].percentage.toString())),
          ],
          isCurved: true,
          color: customcolor.green,
          barWidth: barwidthvalue,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                  radius: strokeradiusvalue,
                  color: whitevalue,
                  strokeWidth: strokeWidthvalue,
                  strokeColor: greenvalue);
            },
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: beginvalue,
              end: endvalue,
              colors: insidegradientcolor,
              stops: [0.0, 1.0],
              tileMode: TileMode.mirror,
            ),
          ),
        ),
      ],
    );
  }

  static LineChartData mainDataratinglist() {
    print(GlobalLists.ratingclienttag.toString());
    print("GRAPH");

    ///    print( GlobalLists.ratinglistwisegraphlist[GlobalLists.ratingclienttag].monthWisedata[5].percentage.toString());
    return LineChartData(
      borderData: FlBorderData(show: false),

      gridData: FlGridData(
        show: false,
        // drawVerticalLine: true,
        // horizontalInterval: 1,
        // verticalInterval: 1,
        // getDrawingHorizontalLine: (value) {
        //   return  FlLine(
        //     color: customcolor.appbarcolor,
        //     strokeWidth: 1,
        //   );
        // },
        // getDrawingVerticalLine: (value) {
        //   return  FlLine(
        //     color: customcolor.appbarcolor,
        //     strokeWidth: 1,
        //   );
        //},
      ),
      titlesData: FlTitlesData(
        // show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomratingTitlelistWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgetsrating,
            reservedSize: 42,
          ),
        ),
      ),
      // borderData: FlBorderData(
      //   show: true,
      //   border: Border.all(color: const Color(0xff37434d)),
      // ),
      minX: 2,
      maxX: 12,
      minY: 0,
      maxY: 10,
      lineBarsData: [
        LineChartBarData(
          preventCurveOverShooting: true,
          preventCurveOvershootingThreshold: 10.0,
          spots: [
            // FlSpot(0,0),
            FlSpot(
                2,
                double.parse(GlobalLists
                    .ratinglistwisegraphlist[GlobalLists.ratingclienttag]
                    .monthWisedata[0]
                    .percentage
                    .toString())),
            FlSpot(
                4,
                double.parse(GlobalLists
                    .ratinglistwisegraphlist[GlobalLists.ratingclienttag]
                    .monthWisedata[1]
                    .percentage
                    .toString())),
            FlSpot(
                6,
                double.parse(GlobalLists
                    .ratinglistwisegraphlist[GlobalLists.ratingclienttag]
                    .monthWisedata[2]
                    .percentage
                    .toString())),

            FlSpot(
                8,
                double.parse(GlobalLists
                    .ratinglistwisegraphlist[GlobalLists.ratingclienttag]
                    .monthWisedata[3]
                    .percentage
                    .toString())),
            FlSpot(
                10,
                double.parse(GlobalLists
                    .ratinglistwisegraphlist[GlobalLists.ratingclienttag]
                    .monthWisedata[4]
                    .percentage
                    .toString())),
            FlSpot(
                12,
                double.parse(GlobalLists
                    .ratinglistwisegraphlist[GlobalLists.ratingclienttag]
                    .monthWisedata[5]
                    .percentage
                    .toString())),

            //           FlSpot(0, 3),
            //           FlSpot(2.6, 2),
            //           FlSpot(4.9, 8),

            //           FlSpot(6.8, 3.1),
            //           FlSpot(8, 4),
            //           FlSpot(9.5, 3),
            //           FlSpot(11, 4),
            //              FlSpot(13, 2),
            //                    FlSpot(15, 3),
            // FlSpot(17, 3),
          ],
          isCurved: true,
          color: customcolor.green,
          // gradient: LinearGradient(
          //    colors: gradientColors,

          // ),
          barWidth: barwidthvalue,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                  radius: strokeradiusvalue,
                  color: whitevalue,
                  strokeWidth: strokeWidthvalue,
                  strokeColor: greenvalue);
            },
          ),
          belowBarData: BarAreaData(
            show: true,
            // color: customcolor.green.withOpacity(0.4)
            gradient: LinearGradient(
              begin: beginvalue,
              end: endvalue,
              colors: insidegradientcolor,
              stops: [0.0, 1.0],
              tileMode: TileMode.mirror,
            ),
          ),
        ),
      ],
    );
  }
}

class CustomDotPainter extends FlDotPainter {
  final Color dotColor;
  final double dotSize;

  CustomDotPainter({required this.dotColor, required this.dotSize});

  @override
  void drawDot(Canvas canvas, Offset offset, {required bool isAbove}) {
    final Paint paint = Paint()..color = dotColor;
    canvas.drawCircle(offset, dotSize, paint);
  }

  @override
  void draw(Canvas canvas, FlSpot spot, Offset offsetInCanvas) {
    // TODO: implement draw
  }

  @override
  Size getSize(FlSpot spot) {
    // TODO: implement getSize
    throw UnimplementedError();
  }

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
  
  @override
  FlDotPainter lerp(FlDotPainter a, FlDotPainter b, double t) {
    // TODO: implement lerp
    throw UnimplementedError();
  }
  
  @override
  // TODO: implement mainColor
  Color get mainColor => throw UnimplementedError();
}
