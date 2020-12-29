part of 'measurment_cubit.dart';

@immutable
class MeasurmentState {
  final List<Measure> heartbeatMeasure;
  final bool isMeasuring;

  MeasurmentState({this.heartbeatMeasure, this.isMeasuring});

  MeasurmentState copyWith({
    List<Measure> heartbeatMeasure,
    bool isMeasuring,
  }) {
    return MeasurmentState(
        heartbeatMeasure: heartbeatMeasure ?? this.heartbeatMeasure,
        isMeasuring: isMeasuring ?? this.isMeasuring);
  }
}

class MeasurmentInitial extends MeasurmentState {
  MeasurmentInitial() : super(heartbeatMeasure: [], isMeasuring: false);
}
