import 'dart:async';

import 'package:band_parameters_reader/models/measure.dart';
import 'package:band_parameters_reader/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Chart extends StatefulWidget {
  final List<Measure> data;
  bool canZoom;

  Chart({this.data, this.canZoom = false});

  @override
  _ChartState createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  ChartSeriesController _chartSeriesController;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final f = new DateFormat('mm:ss:SS');
    return SfCartesianChart(
        zoomPanBehavior: widget.canZoom
            ? ZoomPanBehavior(enablePanning: true, enablePinching: true)
            : null,
        primaryXAxis: CategoryAxis(),
        series: <LineSeries<Measure, String>>[
          LineSeries<Measure, String>(
              onRendererCreated: (ChartSeriesController controller) {
                _chartSeriesController = controller;
              },
              color: UIColors.GRADIENT_DARK_COLOR,
              dataSource: widget.data,
              xValueMapper: (Measure sales, _) => f.format(sales.date),
              yValueMapper: (Measure sales, _) => sales.measure)
        ]);
  }
}
