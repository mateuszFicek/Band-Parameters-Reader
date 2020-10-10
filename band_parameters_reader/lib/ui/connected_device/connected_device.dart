import 'package:band_parameters_reader/data/blue_manager.dart';
import 'package:band_parameters_reader/repositories/connected_device/connected_device_cubit.dart';
import 'package:band_parameters_reader/utils/ble_gatt_constants.dart';
import 'package:band_parameters_reader/utils/colors.dart';
import 'package:band_parameters_reader/widgets/boxes/square_box.dart';
import 'package:band_parameters_reader/widgets/connected_device/last_measurment_chart.dart';
import 'package:band_parameters_reader/widgets/boxes/decoration_box.dart';
import 'package:band_parameters_reader/widgets/information_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ConnectedDevicePage extends StatefulWidget {
  const ConnectedDevicePage({Key key}) : super(key: key);

  @override
  _ConnectedDevicePageState createState() => _ConnectedDevicePageState();
}

class _ConnectedDevicePageState extends State<ConnectedDevicePage> {
  // TEMPORARY VARIABLES
  String steps = '0';
  String calories = '0';
  String meters = '0';

  @override
  void initState() {
    super.initState();
    initDevice();
  }

  void initDevice() async {
    if (context.bloc<ConnectedDeviceCubit>().state.connectedDevice != null) {
      Future.delayed(Duration.zero, () async {
        context.bloc<ConnectedDeviceCubit>().setDeviceServices(context);
        await Future.delayed(Duration(seconds: 2));
        final services = context.bloc<ConnectedDeviceCubit>().state.services;
        services.forEach((element) {
          print(element.uuid);
        });
        final batteryService = BlueManager()
            .findService(services, BleGATTServices.BATTERY_SERVICE);
        final currentBattery = await BlueManager().getDeviceBatteryLevel(
            batteryService.characteristics.firstWhere((element) => element.uuid
                .toString()
                .contains(BleGATTCharacteristics.BATTERY_LEVEL)),
            context);
        context.bloc<ConnectedDeviceCubit>().setCurrentBattery(currentBattery);
        final heartRateService = BlueManager()
            .findService(services, BleGATTServices.HEART_RATE_SERVICE);
        context.bloc<ConnectedDeviceCubit>().setListenerForCharacteristics(
            heartRateService.characteristics.firstWhere((element) => element
                .uuid
                .toString()
                .contains(BleGATTCharacteristics.HEART_RATE_MEASURMENT)),
            context);
      });
    } else {
      await Future.delayed(Duration(milliseconds: 500), () => initDevice());
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 1080, height: 2340);
    return Scaffold(
      backgroundColor: UIColors.BACKGROUND_COLOR,
      body: BlocBuilder<ConnectedDeviceCubit, ConnectedDeviceState>(
        builder: (context, state) => Container(
          margin: EdgeInsets.only(
              top: 250.h, left: 60.w, right: 60.w, bottom: 140.h),
          child: Column(
            children: [
              _deviceNameText(state.connectedDevice),
              LastSessionChart(),
              _batteryAndHeartRateRow(),
              _stepsRow(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _deviceNameText(BluetoothDevice device) => InformationText(
      text: "Your device \n${device.name == '' ? device.id : device.name}");

  Widget _batteryAndHeartRateRow() {
    return BlocBuilder<ConnectedDeviceCubit, ConnectedDeviceState>(
      builder: (context, state) => Container(
        height: MediaQuery.of(context).size.width / 2 - 90.w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
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
        final services = context.bloc<ConnectedDeviceCubit>().state.services;
        final batteryService = BlueManager()
            .findService(services, BleGATTServices.BATTERY_SERVICE);
        final currentBattery = await BlueManager().getDeviceBatteryLevel(
            batteryService.characteristics.firstWhere((element) => element.uuid
                .toString()
                .contains(BleGATTCharacteristics.BATTERY_LEVEL)),
            context);
        print(currentBattery);
        context.bloc<ConnectedDeviceCubit>().setCurrentBattery(currentBattery);
      },
      child: SquareBox(
        child: Container(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(
                Icons.battery_full,
                color: getBatteryIconColor(state.batteryLevel),
                size: 60.w,
              ),
              Text(
                '${state.batteryLevel} %',
                style: TextStyle(color: Colors.white, fontSize: 60.w),
              ),
            ],
          ),
        ),
        text: "Battery level",
      ),
    );
  }

  Widget _heartRateBox(ConnectedDeviceState state) {
    return GestureDetector(
      onTap: () async {
        final services = context.bloc<ConnectedDeviceCubit>().state.services;
        final miBandService = services.firstWhere((element) => element.uuid
            .toString()
            .contains(BleGATTServices.HEART_RATE_SERVICE));
        final heartMeasure = miBandService.characteristics.firstWhere(
            (element) => element.uuid
                .toString()
                .contains(BleGATTCharacteristics.HEART_RATE_MEASURMENT));
        final heartControl = miBandService.characteristics.firstWhere(
            (element) => element.uuid
                .toString()
                .contains(BleGATTCharacteristics.HEART_RATE_CONTROLL_POINT));
        final time = DateTime.now().millisecondsSinceEpoch;
        if (heartMeasure != null) {
          print(heartControl.uuid);
          print(heartControl.properties);
          print(heartMeasure.uuid);
          print(heartMeasure.properties);

          // final descr = heartMeasure.descriptors[0];
          // await descr.write([0x00, 0x01]);
          // await heartControl.write([0x15, 0x01, 0x01], withoutResponse: true);
          heartMeasure.setNotifyValue(true);
          heartMeasure.value.listen((event) {
            print("${DateTime.now()} ---- $event");
          });
          var counter = 100;
          while (counter > 0) {
            counter--;
            await Future.delayed(Duration(seconds: 16), () {
              print("PING");
              heartControl.write([0x16], withoutResponse: true);
            });
          }
        }
      },
      child: SquareBox(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(
                    Icons.favorite,
                    color: Colors.red,
                    size: 60.w,
                  ),
                  Text(
                    '${state.currentHeartRate} bpm',
                    style: TextStyle(color: Colors.white, fontSize: 60.w),
                  ),
                ],
              ),
              Container(
                width: double.infinity,
                height: 40.w,
                alignment: Alignment.centerRight,
                child: Text(
                  state.lastHeartRateMeasureTime,
                  style: TextStyle(color: Colors.grey[400], fontSize: 25.h),
                ),
              ),
            ],
          ),
        ),
        text: "Current heart rate",
      ),
    );
  }

  Color getBatteryIconColor(int batteryLevel) {
    if (batteryLevel > 75)
      return Colors.green;
    else if (batteryLevel > 50)
      return Colors.yellow;
    else if (batteryLevel > 25)
      return Colors.orange;
    else
      return Colors.red;
  }

  Widget _stepsRow() {
    return BlocBuilder<ConnectedDeviceCubit, ConnectedDeviceState>(
      builder: (context, state) => Container(
        height: MediaQuery.of(context).size.width / 2 - 90.w,
        margin: EdgeInsets.symmetric(vertical: 60.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _stepsBox(state),
            _sensorBox(state),
          ],
        ),
      ),
    );
  }

  Widget _stepsBox(ConnectedDeviceState state) {
    return GestureDetector(
      onTap: () async {
        final services = context.bloc<ConnectedDeviceCubit>().state.services;
        final miBandService = services.firstWhere((element) =>
            element.uuid.toString().contains(BleGATTServices.MI_BAND_SERVICE));
        final characteristics = miBandService.characteristics.firstWhere(
            (element) =>
                element.uuid.toString().contains(BleGATTCharacteristics.STEPS));
        if (characteristics != null) {
          final stepsValue = await characteristics.read();
          print(stepsValue);
          final fetchedSteps = convertValue(stepsValue[3].toRadixString(16)) +
              convertValue(stepsValue[2].toRadixString(16)) +
              convertValue(stepsValue[1].toRadixString(16));

          final fetchedMeters = convertValue(stepsValue[7].toRadixString(16)) +
              convertValue(stepsValue[6].toRadixString(16)) +
              convertValue(stepsValue[5].toRadixString(16));

          final fetchedCalories =
              convertValue(stepsValue[10].toRadixString(16)) +
                  convertValue(stepsValue[9].toRadixString(16));
          setState(() {
            calories = int.parse(fetchedCalories, radix: 16).toString();
            meters = int.parse(fetchedMeters, radix: 16).toString();
            steps = int.parse(fetchedSteps, radix: 16).toString();
          });
        }
      },
      child: SquareBox(
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'Steps: $steps',
                style: TextStyle(color: Colors.white, fontSize: 40.w),
              ),
              Text(
                'Meters: $meters',
                style: TextStyle(color: Colors.white, fontSize: 40.w),
              ),
              Text(
                'Calories: $calories',
                style: TextStyle(color: Colors.white, fontSize: 40.w),
              ),
            ],
          ),
        ),
        text: "Steps",
      ),
    );
  }

  String convertValue(String value) {
    if (value.length == 1) {
      return "0${value}";
    }
    return value;
  }

  Widget _sensorBox(ConnectedDeviceState state) {
    return GestureDetector(
      onTap: () async {
        final services = context.bloc<ConnectedDeviceCubit>().state.services;
        final miBandService = services.firstWhere((element) =>
            element.uuid.toString().contains(BleGATTServices.MI_BAND_SERVICE));
        final characteristics = miBandService.characteristics.firstWhere(
            (element) => element.uuid
                .toString()
                .contains(BleGATTCharacteristics.SENSORS));
        final sensorData = miBandService.characteristics.firstWhere((element) =>
            element.uuid
                .toString()
                .contains(BleGATTCharacteristics.SENSORS_DATA));
        print(characteristics.properties);
        if (characteristics != null) {
          await characteristics
              .write([0x01, 0x03, 0x19], withoutResponse: true);
          await Future.delayed(Duration(seconds: 1), () async {
            await characteristics.write([0x02], withoutResponse: true);
            await Future.delayed(Duration(seconds: 4), () async {
              if (sensorData != null) {
                characteristics.setNotifyValue(true);
                characteristics.value.listen((event) {
                  print("EVENT FOR ${sensorData.uuid} IS ${event}");
                });
              }
            });
          });
        }
      },
      child: SquareBox(
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'Steps: $steps',
                style: TextStyle(color: Colors.white, fontSize: 40.w),
              ),
              Text(
                'Meters: $meters',
                style: TextStyle(color: Colors.white, fontSize: 40.w),
              ),
              Text(
                'Calories: $calories',
                style: TextStyle(color: Colors.white, fontSize: 40.w),
              ),
            ],
          ),
        ),
        text: "Sensors",
      ),
    );
  }

  @override
  void dispose() {
    BlueManager().closeConnection();
    super.dispose();
  }
}
