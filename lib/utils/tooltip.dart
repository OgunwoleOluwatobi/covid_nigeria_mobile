import 'dart:math';


import 'package:charts_flutter/flutter.dart';
import 'package:charts_flutter/src/text_element.dart' as ChartText;
import 'package:charts_flutter/src/text_style.dart' as ChartStyle;

import 'package:flutter/material.dart';

String _title;

String _subTitle;

class ToolTipMgr {

  static String get title => _title;

  static String get subTitle => _subTitle;

  static setTitle(Map<String, dynamic> data) {
    if (data['title'] != null && data['title'].length > 0) {
      _title = data['title'];
    }

    if (data['subTitle'] != null && data['subTitle'].length > 0) {
      _subTitle = data['subTitle'];
    }
  }

}

class CustomCircleSymbolRenderer extends CircleSymbolRenderer {

  

  @override
  void paint(ChartCanvas canvas, Rectangle<num> bounds,
      {List<int> dashPattern,
        Color fillColor,
        FillPatternType fillPattern,
        Color strokeColor,
        double strokeWidthPx}) {

    super.paint(canvas, bounds,
        dashPattern: dashPattern,
        fillColor: fillColor,
        strokeColor: strokeColor,
        strokeWidthPx: strokeWidthPx);
    canvas.drawRect(Rectangle(bounds.left - 5, bounds.top, _title.length > 1 ? bounds.width + (_title.length)*28 : bounds.width + (_title.length)*58, bounds.height + 30), fill: Color.black, drawAreaBounds: bounds);

    ChartStyle.TextStyle textStyle = ChartStyle.TextStyle();
    ChartStyle.TextStyle textStyle1 = ChartStyle.TextStyle();

    textStyle.color = Color.white;
    textStyle.fontSize = 12;
    textStyle1.color = Color.white;
    textStyle1.fontSize = 14;

    canvas.drawText(ChartText.TextElement(('Cases: '+ToolTipMgr.title), style: textStyle),
        (bounds.left).round(), (bounds.top + 20).round());
    canvas.drawText(ChartText.TextElement(ToolTipMgr.subTitle, style: textStyle1),
        (bounds.left).round(), (bounds.top + 2).round());
  }
}