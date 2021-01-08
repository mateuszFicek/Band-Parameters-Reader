part of 'bluetooth_devices_cubit.dart';

@immutable
class BluetoothDevicesState {
  final List<BluetoothDevice> availableDevices;
  final bool isScanning;

  BluetoothDevicesState({this.availableDevices, this.isScanning});

  BluetoothDevicesState copyWith({
    List<BluetoothDevice> availableDevices,
    bool isScanning,
  }) {
    return BluetoothDevicesState(
      availableDevices: availableDevices ?? this.availableDevices,
      isScanning: isScanning ?? this.isScanning,
    );
  }
}

class AvailableDevicesInitial extends BluetoothDevicesState {
  AvailableDevicesInitial()
      : super(
          availableDevices: [],
          isScanning: true,
        );
}
