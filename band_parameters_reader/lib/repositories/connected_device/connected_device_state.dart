part of 'connected_device_cubit.dart';

@immutable
class ConnectedDeviceState {
  final BluetoothDevice connectedDevice;
  final int currentHeartRate;

  ConnectedDeviceState({this.connectedDevice, this.currentHeartRate});

  ConnectedDeviceState copyWith({
    BluetoothDevice connectedDevice,
    int currentHeartRate,
  }) {
    return ConnectedDeviceState(
      connectedDevice: connectedDevice ?? this.connectedDevice,
      currentHeartRate: currentHeartRate ?? this.currentHeartRate,
    );
  }
}

class ConnectedDeviceInitial extends ConnectedDeviceState {
  ConnectedDeviceInitial()
      : super(
          connectedDevice: null,
          currentHeartRate: 0,
        );
}
