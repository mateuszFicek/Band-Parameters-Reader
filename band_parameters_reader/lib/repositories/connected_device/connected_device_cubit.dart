import 'package:band_parameters_reader/data/blue_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue/flutter_blue.dart';

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
}
