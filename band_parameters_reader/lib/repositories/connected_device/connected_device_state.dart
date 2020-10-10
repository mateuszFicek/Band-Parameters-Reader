part of 'connected_device_cubit.dart';

@immutable
class ConnectedDeviceState {
  final BluetoothDevice connectedDevice;
  final int currentHeartRate;
  final List<BluetoothService> services;
  final int batteryLevel;
  final String lastHeartRateMeasureTime;

  ConnectedDeviceState(
      {this.connectedDevice,
      this.currentHeartRate,
      this.lastHeartRateMeasureTime,
      this.services,
      this.batteryLevel});

  ConnectedDeviceState copyWith({
    BluetoothDevice connectedDevice,
    int currentHeartRate,
    List<BluetoothService> services,
    int batteryLevel,
    String lastHeartRateMeasureTime,
  }) {
    return ConnectedDeviceState(
      connectedDevice: connectedDevice ?? this.connectedDevice,
      currentHeartRate: currentHeartRate ?? this.currentHeartRate,
      services: services ?? this.services,
      batteryLevel: batteryLevel ?? this.batteryLevel,
      lastHeartRateMeasureTime:
          lastHeartRateMeasureTime ?? this.lastHeartRateMeasureTime,
    );
  }
}

class ConnectedDeviceInitial extends ConnectedDeviceState {
  ConnectedDeviceInitial()
      : super(
          connectedDevice: null,
          currentHeartRate: 0,
          services: [],
          batteryLevel: 0,
          lastHeartRateMeasureTime: '',
        );
}
