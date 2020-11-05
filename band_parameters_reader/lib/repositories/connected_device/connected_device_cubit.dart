import 'package:band_parameters_reader/data/blue_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:intl/intl.dart';

part 'connected_device_state.dart';

class ConnectedDeviceCubit extends Cubit<ConnectedDeviceState> {
  final BuildContext context;

  ConnectedDeviceCubit(this.context) : super(ConnectedDeviceInitial());

  void setConnectedDevice(
      BluetoothDevice device, BuildContext buildContext) async {
    final isConnected =
        await BlueManager().connectToDevice(device, buildContext);
    if (isConnected == 2) emit(state.copyWith(connectedDevice: device));
  }

  void updateCurrentHeartRate(int heartRate) {
    emit(state.copyWith(
        currentHeartRate: heartRate,
        lastHeartRateMeasureTime:
            DateFormat("HH:mm:ss").format(DateTime.now()).toString()));
  }

  void setDeviceServices(BuildContext context) async {
    final services =
        await BlueManager().discoverDeviceServices(state.connectedDevice);
    emit(state.copyWith(services: services));
  }

  void setListenerForCharacteristics(
      BluetoothCharacteristic characteristic, BuildContext context) async {
    BlueManager().setListener(characteristic, context);
  }

  void disableListenerForCharacteristics(
      BluetoothCharacteristic characteristic) {
    BlueManager().disableListener(characteristic);
  }

  disconnectFromDevice() {
    BlueManager().closeConnection();
    emit(ConnectedDeviceInitial());
  }

  void setCurrentBattery(int batteryLevel) {
    emit(state.copyWith(batteryLevel: batteryLevel));
  }
}
