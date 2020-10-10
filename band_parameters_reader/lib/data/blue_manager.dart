import 'package:band_parameters_reader/repositories/connected_device/connected_device_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:toast/toast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlueManager {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  List<BluetoothDevice> devices = [];

  List<BluetoothService> services = [];
  int value = 0;

  // SCAN FOR AVAILABLE DEVICES
  Future<List<BluetoothDevice>> scanForAvailableDevices() async {
    final List<BluetoothDevice> availableDevices = [];
    final connectedDevices = await flutterBlue.connectedDevices;
    availableDevices.addAll(connectedDevices);
    flutterBlue.startScan(timeout: Duration(seconds: 4));
    final scanResults = flutterBlue.scanResults;
    scanResults.listen((results) {
      for (ScanResult result in results) {
        availableDevices.add(result.device);
      }
    });
    await Future.delayed(Duration(seconds: 4));
    flutterBlue.stopScan();
    return availableDevices;
  }

  // CONNECT TO DEVICE
  Future<int> connectToDevice(
      BluetoothDevice device, BuildContext context) async {
    try {
      await device.connect();
    } catch (e) {
      print(e);
    }
    final state = await device.state.first;
    print(state);
    if (state.index == 2) {
      Toast.show("Your device is now connected", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      Navigator.pushNamed(context, '/connectedDevice');
    }

    return state.index;
  }

  // DISCOVER DEVICE SERVICES
  Future<List<BluetoothService>> discoverDeviceServices(
      BluetoothDevice device) async {
    final serv = await device.discoverServices();
    return serv;
  }

  // GET DESCRIPTOR
  Future getDesc() async {
    BluetoothDescriptor descriptor;
  }

  // PRINT CHARACTERISTICS
  Future printChar(BluetoothService service) async {
    service.characteristics.forEach((element) async {
      await Future.delayed(Duration(seconds: 1));
      element.setNotifyValue(true);
      await Future.delayed(Duration(seconds: 1));

      element.value.listen((event) {
        print("EVENT FOR ${element.uuid} IS ${event}");
      });
      await Future.delayed(Duration(seconds: 1));
    });
  }

  // READ CHARACTERISTICS
  Future readChar(BluetoothService service) async {
    print("Service UUID is : ");
    service.characteristics.forEach((element) {
      print(element.serviceUuid);
    });
    print("Characteristics..");
    var characteristics = service.characteristics;

    await characteristics.first.setNotifyValue(true);
    characteristics.first.value.listen((vue) {
      print("New value is $vue");
      value = vue[1];
    });

    print("Descriptors...");
    var descriptors = service.characteristics.first.descriptors;
    for (BluetoothDescriptor d in descriptors) {
      print("d c: ${d.characteristicUuid}");
      List<int> value = await d.read();
      print("Value of desc $value");
    }
    print(service.deviceId);
    print(service.includedServices);
    print(service.isPrimary);
    print(service.uuid);
  }

  setListener(
      BluetoothCharacteristic characteristic, BuildContext context) async {
    await characteristic.setNotifyValue(true);
    characteristic.value.listen((vue) {
      print("New value for ${characteristic.uuid} is $vue");
      if (vue.length > 0)
        context.bloc<ConnectedDeviceCubit>().updateCurrentHeartRate(vue[1]);
    });
  }

  // CLOSE DEVICE CONNECTION
  closeConnection() async {
    final conn = await flutterBlue.connectedDevices;
    conn.forEach((element) {
      element.disconnect();
    });
  }

  BluetoothService findService(
      List<BluetoothService> services, String serviceUUID) {
    final service = services
        .firstWhere((element) => element.uuid.toString().contains(serviceUUID));
    return service;
  }

  Future<int> getDeviceBatteryLevel(
      BluetoothCharacteristic characteristic, BuildContext context) async {
    print(characteristic);
    final canRead = await characteristic.properties.read;
    if (canRead) {
      final batteryValues = await characteristic.read();
      print("BATTERY VALUE ARE $batteryValues");
      return batteryValues[0];
    }
    return 0;
  }
}
