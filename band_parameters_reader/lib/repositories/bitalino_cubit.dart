import 'package:band_parameters_reader/models/measure.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:meta/meta.dart';

part 'bitalino_state.dart';

class BitalinoCubit extends Cubit<BitalinoState> {
  final BuildContext context;

  BitalinoCubit(this.context) : super(BitalinoInitial());

  setDevice(BluetoothDevice device) {
    state.copyWith(device: device);
  }

  addMeasure(Measure measure) {
    List<Measure> measures = state.measure;
    measures.add(measure);
    if (measures.length == 300) measures.removeAt(0);
    emit(state.copyWith(measures: measures));
  }

  setInitial() {
    emit(BitalinoInitial());
  }
}
