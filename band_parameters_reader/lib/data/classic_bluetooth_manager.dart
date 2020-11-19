import 'dart:async';

import 'package:band_parameters_reader/repositories/bluetooth_devices/bluetooth_devices_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClassicBluetoothManager {
  FlutterBluetoothSerial bluetooth = FlutterBluetoothSerial.instance;
  StreamSubscription<BluetoothDiscoveryResult> _streamSubscription;

  Future<List<BluetoothDevice>> searchForDevices(BuildContext context) async {
    try {
      bluetooth = FlutterBluetoothSerial.instance;
      _streamSubscription =
          FlutterBluetoothSerial.instance.startDiscovery().listen((event) {
        if (context != null) {
          context.bloc<BluetoothDevicesCubit>().addDevice(event.device);
        }
      });
    } catch (exception) {
      print('Cannot connect, exception occured');
    }
  }

  Future connectToDevice() {}
}
