part of 'available_devices_cubit.dart';

@immutable
class AvailableDevicesState {
  final List<BluetoothDevice> availableDevices;
  final bool isScanning;

  AvailableDevicesState({this.availableDevices, this.isScanning});

  AvailableDevicesState copyWith({
    List<BluetoothDevice> availableDevices,
    bool isScanning,
  }) {
    return AvailableDevicesState(
      availableDevices: availableDevices ?? this.availableDevices,
      isScanning: isScanning ?? this.isScanning,
    );
  }
}

class AvailableDevicesInitial extends AvailableDevicesState {
  AvailableDevicesInitial()
      : super(
          availableDevices: [],
          isScanning: true,
        );
}
