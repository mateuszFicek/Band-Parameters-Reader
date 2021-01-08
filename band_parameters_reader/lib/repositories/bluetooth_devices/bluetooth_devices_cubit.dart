import 'package:band_parameters_reader/data/classic_bluetooth_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

part 'bluetooth_devices_state.dart';

class BluetoothDevicesCubit extends Cubit<BluetoothDevicesState> {
  final BuildContext context;

  BluetoothDevicesCubit(this.context) : super(AvailableDevicesInitial());

  void toggleIsScanning() async {
    emit(state.copyWith(isScanning: true));
  }

  void addDevice(BluetoothDevice device) {
    List<BluetoothDevice> devices = state.availableDevices;
    devices.add(device);
    emit(state.copyWith(availableDevices: devices));
  }

  void getAvailableDevices(BuildContext context) async {
    ClassicBluetoothManager().searchForDevices(context);
    emit(state.copyWith(availableDevices: []));
  }
}
