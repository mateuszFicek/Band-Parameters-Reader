part of 'connected_device_cubit.dart';

@immutable
class ConnectedDeviceState {
  final BluetoothDevice connectedDevice;

  ConnectedDeviceState({this.connectedDevice});

  ConnectedDeviceState copyWith({
    BluetoothDevice connectedDevice,
  }) {
    return ConnectedDeviceState(
      connectedDevice: connectedDevice ?? this.connectedDevice,
    );
  }
}

class ConnectedDeviceInitial extends ConnectedDeviceState {
  ConnectedDeviceInitial()
      : super(
          connectedDevice: null,
        );
}
