import 'package:band_parameters_reader/data/blue_manager.dart';
import 'package:band_parameters_reader/models/measure.dart';
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

import 'measurment_summary.dart';

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
    final batteryService = BlueManager().findService(services, BleGATTServices.BATTERY_SERVICE);
    try {
      final currentBattery = await BlueManager().getDeviceBatteryLevel(
          batteryService.characteristics.firstWhere(
              (element) => element.uuid.toString().contains(BleGATTCharacteristics.BATTERY_LEVEL),
              orElse: null),
          context);
      connectedDeviceCubit.setCurrentBattery(currentBattery);
    } catch (e) {
      print(e);
    }
  }

  void _setHeartRateListener(List<BluetoothService> services) {
    try {
      final heartRateService =
          BlueManager().findService(services, BleGATTServices.HEART_RATE_SERVICE);

      heartRateCharacteristic = heartRateService.characteristics.firstWhere(
          (element) =>
              element.uuid.toString().contains(BleGATTCharacteristics.HEART_RATE_MEASURMENT),
          orElse: null);
      connectedDeviceCubit.setListenerForCharacteristics(heartRateCharacteristic, context);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 1080, height: 2340);
    return Scaffold(
      backgroundColor: UIColors.BACKGROUND_COLOR,
      body: BlocBuilder<ConnectedDeviceCubit, ConnectedDeviceState>(
        builder: (_, state) => BlocBuilder<MeasurmentCubit, MeasurmentState>(
          builder: (_, measureState) => Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                _batteryAndHeartRateRow(),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  height: 500,
                  child: LastSessionChart(),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(children: [
                    Spacer(),
                    _pauseButton(measureState),
                  ]),
                ),
                Spacer(),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 25),
                        child: _measures(measureState))),
                SizedBox(height: 20),
                _endButton(),
              ],
            ),
          ),
        ),
      ),
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
        padding: EdgeInsets.only(left: 50.h, right: 50.h, top: 40.h + ScreenUtil.statusBarHeight),
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
        try {
          final services = connectedDeviceCubit.state.services;
          final batteryService =
              BlueManager().findService(services, BleGATTServices.BATTERY_SERVICE);
          final currentBattery = await BlueManager().getDeviceBatteryLevel(
              batteryService.characteristics.firstWhere(
                  (element) =>
                      element.uuid.toString().contains(BleGATTCharacteristics.BATTERY_LEVEL),
                  orElse: null),
              context);
          connectedDeviceCubit.setCurrentBattery(currentBattery);
        } catch (e) {
          print(e);
        }
      },
      child: Container(
        width: double.infinity,
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Poziom baterii ${state.batteryLevel}%',
              style: TextStyle(color: Colors.white70, fontSize: 40.w),
            ),
          ],
        ),
      ),
    );
  }

  Widget _endButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        width: double.infinity,
        child: Padding(
            padding: const EdgeInsets.all(15),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0),
                  side: BorderSide(color: UIColors.GRADIENT_DARK_COLOR)),
              padding: const EdgeInsets.all(8),
              color: UIColors.GRADIENT_DARK_COLOR,
              onPressed: () {
                pauseMeasure();
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => MeasurmentSummary()));
              },
              child: Text(
                'Zakończ pomiar',
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
              ),
            )),
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
            'Ostatnio odczytane tętno ${state.currentHeartRate}',
            style: TextStyle(color: Colors.white70, fontSize: 40.w),
          ),
          SizedBox(width: 20.w),
          Container(
            height: 80.h,
            alignment: Alignment.center,
            child: Text(
              state.lastHeartRateMeasureTime,
              style: TextStyle(color: UIColors.LIGHT_FONT_COLOR, fontSize: 25.h),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pauseButton(MeasurmentState state) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2,
      child: RaisedButton(
        onPressed: state.isMeasuring ? pauseMeasure : resumeMeasure,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
            side: BorderSide(color: UIColors.GRADIENT_DARK_COLOR)),
        padding: const EdgeInsets.all(8),
        color: UIColors.GRADIENT_DARK_COLOR,
        child: Text(
          state.isMeasuring ? "Zatrzymaj" : "Wznów",
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  void pauseMeasure() {
    context.bloc<MeasurmentCubit>().pauseMeasure();
  }

  void resumeMeasure() {
    context.bloc<MeasurmentCubit>().startMeasure();
  }

  Widget _measures(MeasurmentState state) {
    List<Measure> measures = List<Measure>.from(state.heartbeatMeasure);
    var valueMax = 0;
    var valueMin = 0;
    int secondsElapsed = 0;
    if (measures.isNotEmpty) {
      secondsElapsed = measures.last.date.difference(measures.first.date).inSeconds;

      measures.sort((a, b) => a.measure.compareTo(b.measure));
      valueMax = measures.last.measure;
      valueMin = measures.first.measure;
    }

    return Column(
      children: [
        _textWithValue("Maksymalny pomiar", valueMax),
        SizedBox(height: 8),
        _textWithValue("Minimalny pomiar", valueMin),
        SizedBox(height: 8),
        _textWithValue(
            "Czas od pierwszego pomiaru", _printDuration(Duration(seconds: secondsElapsed))),
      ],
    );
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  Widget _textWithValue(String text, var value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(text, style: _textStyle()),
        Text(
          value.toString(),
          style: _valueStyle(),
        )
      ],
    );
  }

  TextStyle _textStyle() {
    return TextStyle(color: UIColors.LIGHT_FONT_COLOR, fontSize: 17, fontWeight: FontWeight.w400);
  }

  TextStyle _valueStyle() {
    return TextStyle(
        color: UIColors.GRADIENT_DARK_COLOR, fontSize: 17, fontWeight: FontWeight.w700);
  }

  @override
  void dispose() {
    connectedDeviceCubit.disconnectFromDevice();
    connectedDeviceCubit.disableListenerForCharacteristics(heartRateCharacteristic);
    measurmentCubit.setInitialState();
    super.dispose();
  }
}
