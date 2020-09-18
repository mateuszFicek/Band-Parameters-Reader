part of 'available_devices_cubit.dart';

@immutable
class AvailableDevicesState {
  final List<BluetoothDevice> availableDevices;

  AvailableDevicesState({this.availableDevices});

  AvailableDevicesState copyWith({
    List<BluetoothDevice> availableDevices,
  }) {
    return AvailableDevicesState(
      availableDevices: availableDevices ?? this.availableDevices,
    );
  }
}

class AvailableDevicesInitial extends AvailableDevicesState {
  AvailableDevicesInitial()
      : super(
          availableDevices: [],
        );
}
