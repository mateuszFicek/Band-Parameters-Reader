import 'package:band_parameters_reader/data/blue_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue/flutter_blue.dart';

part 'available_devices_state.dart';

class AvailableDevicesCubit extends Cubit<AvailableDevicesState> {
  final BuildContext context;

  AvailableDevicesCubit(this.context) : super(AvailableDevicesInitial());

  void toggleIsScanning() async {
    emit(state.copyWith(isScanning: true));
  }

  void getAvailableDevices() async {
    final availableDevices = await BlueManager().scanForAvailableDevices();

    emit(state.copyWith(
        availableDevices: availableDevices.toSet().toList(),
        isScanning: false));
  }
}
