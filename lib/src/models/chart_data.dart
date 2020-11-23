import 'package:charts_flutter/flutter.dart' as charts;
import 'package:covid_19_nigeria/styles/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ChartData {
  final String day;
  final int amount;
  charts.Color barColor = charts.ColorUtil.fromDartColor(paleGreenOp);
  int numb;
  
  ChartData({
    @required this.day,
    @required this.amount,
    this.barColor,
    this.numb
  });
}