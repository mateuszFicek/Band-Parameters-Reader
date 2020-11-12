part of 'measurment_cubit.dart';

@immutable
class MeasurmentState {
  final List<HeartBeatMeasure> heartbeatMeasure;

  MeasurmentState({this.heartbeatMeasure});

  MeasurmentState copyWith({
    List<HeartBeatMeasure> heartbeatMeasure,
  }) {
    return MeasurmentState(
        heartbeatMeasure: heartbeatMeasure ?? this.heartbeatMeasure);
  }
}

class MeasurmentInitial extends MeasurmentState {
  MeasurmentInitial() : super(heartbeatMeasure: []);
}
