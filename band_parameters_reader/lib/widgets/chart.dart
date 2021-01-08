import 'package:band_parameters_reader/models/measure.dart';
import 'package:band_parameters_reader/utils/colors.dart';
import 'package:flutter/material.dart';
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
    return SfCartesianChart(
        zoomPanBehavior: widget.canZoom
            ? ZoomPanBehavior(enablePanning: true, enablePinching: true)
            : null,
        primaryXAxis: CategoryAxis(),
        series: <LineSeries<Measure, int>>[
          LineSeries<Measure, int>(
              onRendererCreated: (ChartSeriesController controller) {
                _chartSeriesController = controller;
              },
              color: UIColors.GRADIENT_DARK_COLOR,
              dataSource: widget.data,
              xValueMapper: (Measure measure, _) => measure.id,
              yValueMapper: (Measure measure, _) => measure.measure)
        ]);
  }
}
