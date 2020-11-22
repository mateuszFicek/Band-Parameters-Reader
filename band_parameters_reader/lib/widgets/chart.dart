import 'dart:async';

import 'package:band_parameters_reader/models/measure.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Chart extends StatefulWidget {
  final List<Measure> data;

  Chart({this.data});

  @override
  _ChartState createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  ChartSeriesController _chartSeriesController;
  Timer timer;
  List<Measure> chartData;

  @override
  void initState() {
    super.initState();
  }

  void updateDataSource(Measure measure) {
    chartData.add(measure);

    if (chartData.length == 1000) {
      chartData.removeAt(0);
      _chartSeriesController.updateDataSource(
        addedDataIndexes: <int>[chartData.length - 1],
        removedDataIndexes: <int>[0],
      );
    } else {
      _chartSeriesController.updateDataSource(
        addedDataIndexes: <int>[chartData.length - 1],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
        // Initialize category axis
        primaryXAxis: CategoryAxis(),
        series: <LineSeries<Measure, DateTime>>[
          LineSeries<Measure, DateTime>(
              onRendererCreated: (ChartSeriesController controller) {
                _chartSeriesController = controller;
              },
              dataSource: widget.data,
              xValueMapper: (Measure sales, _) => sales.date,
              yValueMapper: (Measure sales, _) => sales.measure)
        ]);
  }
}
