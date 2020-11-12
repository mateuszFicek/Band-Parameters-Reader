import 'package:band_parameters_reader/models/heart_beat_measure.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'measurment_state.dart';

class MeasurmentCubit extends Cubit<MeasurmentState> {
  final BuildContext context;

  MeasurmentCubit(this.context) : super(MeasurmentInitial());

  addHeartbeatMeasurment(HeartBeatMeasure measure) {
    final List<HeartBeatMeasure> measures = state.heartbeatMeasure;
    measures.add(measure);
    state.copyWith(heartbeatMeasure: measures);
  }

  setInitialState() {
    emit(MeasurmentInitial());
  }
}
