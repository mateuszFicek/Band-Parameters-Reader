import 'package:band_parameters_reader/data/blue_manager.dart';
import 'package:band_parameters_reader/repositories/connected_device/connected_device_cubit.dart';
import 'package:band_parameters_reader/repositories/measurment/measurment_cubit.dart';
import 'package:band_parameters_reader/utils/ble_gatt_constants.dart';
import 'package:band_parameters_reader/utils/colors.dart';
import 'package:band_parameters_reader/widgets/connected_device/last_measurment_chart.dart';
import 'package:band_parameters_reader/widgets/custom_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ConnectedDevicePage extends StatefulWidget {
  const ConnectedDevicePage({Key key}) : super(key: key);

  @override
  _ConnectedDevicePageState createState() => _ConnectedDevicePageState();
}

class _ConnectedDevicePageState extends State<ConnectedDevicePage> {
  ConnectedDeviceCubit connectedDeviceCubit;
  MeasurmentCubit measurmentCubit;
  List<BluetoothService> services;
  BluetoothCharacteristic heartRateCharacteristic;
  @override
  void initState() {
    super.initState();
    connectedDeviceCubit = BlocProvider.of<ConnectedDeviceCubit>(context);
    measurmentCubit = BlocProvider.of<MeasurmentCubit>(context);
    initDevice();
  }

  void initDevice() async {
    if (connectedDeviceCubit.state.connectedDevice != null) {
      Future.delayed(Duration.zero, () async {
        connectedDeviceCubit.setDeviceServices(context);
        await Future.delayed(Duration(seconds: 2));
        services = connectedDeviceCubit.state.services;
        await _updateBattery(services);
        _setHeartRateListener(services);
      });
    } else {
      await Future.delayed(Duration(milliseconds: 500), () => initDevice());
    }
  }

  Future _updateBattery(List<BluetoothService> services) async {
    final batteryService =
        BlueManager().findService(services, BleGATTServices.BATTERY_SERVICE);
    final currentBattery = await BlueManager().getDeviceBatteryLevel(
        batteryService.characteristics.firstWhere((element) => element.uuid
            .toString()
            .contains(BleGATTCharacteristics.BATTERY_LEVEL)),
        context);
    connectedDeviceCubit.setCurrentBattery(currentBattery);
  }

  void _setHeartRateListener(List<BluetoothService> services) {
    final heartRateService =
        BlueManager().findService(services, BleGATTServices.HEART_RATE_SERVICE);
    heartRateCharacteristic = heartRateService.characteristics.firstWhere(
        (element) => element.uuid
            .toString()
            .contains(BleGATTCharacteristics.HEART_RATE_MEASURMENT));
    connectedDeviceCubit.setListenerForCharacteristics(
        heartRateCharacteristic, context);
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 1080, height: 2340);
    return Scaffold(
      backgroundColor: UIColors.BACKGROUND_COLOR,
      bottomNavigationBar: _bottomBar(),
      body: BlocBuilder<ConnectedDeviceCubit, ConnectedDeviceState>(
        builder: (context, state) => Container(
          child: Column(
            children: [
              _batteryAndHeartRateRow(),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 30),
                child: LastSessionChart(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bottomBar() {
    return CustomBottomBar(
      centerItemText: 'Home',
      color: Colors.grey,
      backgroundColor: Colors.white,
      selectedColor: UIColors.GRADIENT_DARK_COLOR,
      notchedShape: CircularNotchedRectangle(),
      onTabSelected: null,
      items: [
        CustomBottomBarItem(iconData: Icons.home, text: '1'),
        CustomBottomBarItem(iconData: Icons.search, text: '2'),
      ],
    );
  }

  Widget _deviceNameText(BluetoothDevice device) => Text(
        "${device.name == '' ? device.id : device.name}",
        style: TextStyle(
          color: Colors.white,
          fontSize: 70.h,
        ),
        textAlign: TextAlign.start,
      );

  Widget _batteryAndHeartRateRow() {
    return BlocBuilder<ConnectedDeviceCubit, ConnectedDeviceState>(
      builder: (context, state) => Container(
        width: double.infinity,
        padding: EdgeInsets.only(
            left: 50.h, right: 50.h, top: 40.h + ScreenUtil.statusBarHeight),
        height: 420.h,
        color: UIColors.GRADIENT_DARK_COLOR,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _deviceNameText(state.connectedDevice),
            _batteryBox(state),
            _heartRateBox(state),
          ],
        ),
      ),
    );
  }

  Widget _batteryBox(ConnectedDeviceState state) {
    return GestureDetector(
      onTap: () async {
        final services = connectedDeviceCubit.state.services;
        final batteryService = BlueManager()
            .findService(services, BleGATTServices.BATTERY_SERVICE);
        final currentBattery = await BlueManager().getDeviceBatteryLevel(
            batteryService.characteristics.firstWhere((element) => element.uuid
                .toString()
                .contains(BleGATTCharacteristics.BATTERY_LEVEL)),
            context);
        connectedDeviceCubit.setCurrentBattery(currentBattery);
      },
      child: Container(
        width: double.infinity,
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Battery level is ${state.batteryLevel} %',
              style: TextStyle(color: Colors.white70, fontSize: 40.w),
            ),
          ],
        ),
      ),
    );
  }

  Widget _heartRateBox(ConnectedDeviceState state) {
    return Container(
      width: double.infinity,
      height: 80.h,
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Last measured heart rate ${state.currentHeartRate} bpm',
            style: TextStyle(color: Colors.white70, fontSize: 40.w),
          ),
          SizedBox(width: 20.w),
          Container(
            height: 80.h,
            alignment: Alignment.center,
            child: Text(
              state.lastHeartRateMeasureTime,
              style:
                  TextStyle(color: UIColors.LIGHT_FONT_COLOR, fontSize: 25.h),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    connectedDeviceCubit.disconnectFromDevice();
    connectedDeviceCubit
        .disableListenerForCharacteristics(heartRateCharacteristic);
    measurmentCubit.setInitialState();
    super.dispose();
  }
}
