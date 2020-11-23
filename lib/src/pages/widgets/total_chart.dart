import 'package:covid_19_nigeria/src/bloc/blocs/data_bloc.dart';
import 'package:covid_19_nigeria/src/models/chart_data.dart';
import 'package:covid_19_nigeria/utils/tooltip.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class TotalChart extends StatelessWidget {
  final List<ChartData> data;

  const TotalChart({@required this.data});

  @override
  Widget build(BuildContext context) {
    List<charts.Series<ChartData, String>> series = [
      charts.Series(
        id: "Overall",
        data: data,
        domainFn: (ChartData series, _) => series.day,
        measureFn: (ChartData series, _) => series.amount,
        colorFn: (ChartData series, _) => series.barColor,
      )
    ];
    var tot = data[data.length - 1].amount.toString();

    return Container(
      height: 280,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: 5, right: 5),
      child: Card(
        elevation: 0.7,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Overall Active Cases',
                style: Theme.of(context).textTheme.headline6.copyWith(fontSize: 25, fontWeight: FontWeight.w600),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(
                  tot,
                  style: Theme.of(context).textTheme.headline6.copyWith(fontSize: 28, fontWeight: FontWeight.bold)
                ),
              ),
              Expanded(
                child: charts.BarChart(
                  series,
                  animate: true,
                  primaryMeasureAxis:
                    new charts.NumericAxisSpec(
                       renderSpec: new charts.GridlineRendererSpec(
                      labelStyle: new charts.TextStyleSpec(
                          fontSize: 16,
                          color: DataBloc().darkModeOn ? charts.ColorUtil.fromDartColor(Colors.white70): charts.ColorUtil.fromDartColor(Colors.black87)),
                      lineStyle: new charts.LineStyleSpec(
                          color: DataBloc().darkModeOn ? charts.ColorUtil.fromDartColor(Colors.white.withOpacity(0.2)): charts.ColorUtil.fromDartColor(Colors.black.withOpacity(0.1)))
                      )
                    ),
                    domainAxis: new charts.OrdinalAxisSpec(
                      renderSpec: new charts.SmallTickRendererSpec(
                        labelStyle: new charts.TextStyleSpec(
                            fontSize: 16,
                            color: DataBloc().darkModeOn ? charts.ColorUtil.fromDartColor(Colors.white70): charts.ColorUtil.fromDartColor(Colors.black87)),
                        lineStyle: new charts.LineStyleSpec(
                          color: DataBloc().darkModeOn ? charts.ColorUtil.fromDartColor(Colors.white.withOpacity(0.5)): charts.ColorUtil.fromDartColor(Colors.black.withOpacity(0.5))
                        )
                      )
                    ),
                  behaviors: [
                    new charts.LinePointHighlighter(
                        symbolRenderer: CustomCircleSymbolRenderer()),
                    new charts.SelectNearest(eventTrigger: charts.SelectionTrigger.tap)
                  ],
                  selectionModels: [
                    charts.SelectionModelConfig(
                        changedListener: (charts.SelectionModel model) {
                      if (model.hasDatumSelection) {
                        tot = '${model.selectedSeries[0].measureFn(model.selectedDatum[0].datum.numb)}';
                        ToolTipMgr.setTitle({
                          'title': '${model.selectedSeries[0].measureFn(model.selectedDatum[0].datum.numb)}',
                          'subTitle': '${model.selectedSeries[0].domainFn(model.selectedDatum[0].datum.numb)}'
                        });
            //            print(${model.selectedSeries[0].measureFn(model.selectedDatum[0].datum.year)});
                      }
                    })
                  ]
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}