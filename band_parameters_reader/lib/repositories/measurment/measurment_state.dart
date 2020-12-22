part of 'measurment_cubit.dart';

@immutable
class MeasurmentState {
  final List<Measure> heartbeatMeasure;

  MeasurmentState({this.heartbeatMeasure});

  MeasurmentState copyWith({
    List<Measure> heartbeatMeasure,
  }) {
    return MeasurmentState(
        heartbeatMeasure: heartbeatMeasure ?? this.heartbeatMeasure);
  }
}

class MeasurmentInitial extends MeasurmentState {
  MeasurmentInitial() : super(heartbeatMeasure: []);
}
