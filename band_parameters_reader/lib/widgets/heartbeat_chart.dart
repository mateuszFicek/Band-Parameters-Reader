import 'package:band_parameters_reader/models/heart_beat_measure.dart';
import 'package:flutter/material.dart';

class HeartbeatChart extends StatelessWidget {
  final List<HeartBeatMeasure> data;
  final bool animate;

  HeartbeatChart(this.data, {this.animate});

  @override
  Widget build(BuildContext context) {
    return Container();
//    return charts.TimeSeriesChart(
//      _createSeriesData(data),
//      animate: animate,
//      dateTimeFactory: const charts.LocalDateTimeFactory(),
//    );
  }

//  static List<charts.Series<HeartBeatMeasure, DateTime>> _createSeriesData(
//      List<HeartBeatMeasure> data) {
//    return [
//      new charts.Series<HeartBeatMeasure, DateTime>(
//        id: 'HB',
//        colorFn: (_, __) => charts.Color(r: 138, g: 128, b: 248),
//        domainFn: (HeartBeatMeasure sales, _) => sales.date,
//        measureFn: (HeartBeatMeasure sales, _) => sales.heartBeat,
//        data: data,
//      )
//    ];
//  }
}
