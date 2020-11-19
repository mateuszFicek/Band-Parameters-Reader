import 'package:band_parameters_reader/repositories/available_devices/available_devices_cubit.dart';
import 'package:band_parameters_reader/repositories/bluetooth_devices/bluetooth_devices_cubit.dart';
import 'package:band_parameters_reader/repositories/connected_device/connected_device_cubit.dart';
import 'package:band_parameters_reader/utils/colors.dart';
import 'package:band_parameters_reader/widgets/custom_button.dart';
import 'package:band_parameters_reader/widgets/information_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BluetoothLEDevices extends StatefulWidget {
  BluetoothLEDevices({Key key}) : super(key: key);

  @override
  _BluetoothLEDevicesState createState() => _BluetoothLEDevicesState();
}

class _BluetoothLEDevicesState extends State<BluetoothLEDevices>
    with AutomaticKeepAliveClientMixin<BluetoothLEDevices> {
  bool isSearchingForBLE = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      context.bloc<AvailableDevicesCubit>().toggleIsScanning();
      context.bloc<AvailableDevicesCubit>().getAvailableDevices();
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 1080, height: 2340);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _infoText,
        _availableDevicesText,
        _availableDevicesListView,
        SizedBox(height: 32),
        _bleButton,
      ],
    );
  }

  Widget get _infoText => Text(
        "Application was developed for devices with BLE connectivity. Notice that some devices may not work.",
        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
      );

  Widget get _availableDevicesText => InformationText(
        text: 'Choose your device from available:',
      );

  Widget get _availableDevicesListView => Expanded(
        child: BlocBuilder<AvailableDevicesCubit, AvailableDevicesState>(
          builder: (context, state) => ListView.builder(
              itemBuilder: (context, index) =>
                  _availableDeviceContainer(state.availableDevices.elementAt(index)),
              itemCount: state.availableDevices.length),
        ),
      );


  Widget _availableDeviceContainer(BluetoothDevice device) {
    return StreamBuilder<BluetoothDeviceState>(
      stream: device.state.asBroadcastStream(),
      initialData: BluetoothDeviceState.disconnected,
      builder: (c, snapshot) => snapshot.data.index == 2
          ? _connectedDeviceContainer(device, snapshot.data.index)
          : _disconnectedDeviceContainer(device, snapshot.data.index),
    );
  }

  Widget _connectedDeviceContainer(BluetoothDevice device, int stateIndex) {
    return GestureDetector(
      onTap: () => connectToDevice(device, context),
      child: Container(
        height: 200.h,
        margin: EdgeInsets.symmetric(vertical: 10.h),
        padding: EdgeInsets.symmetric(vertical: 20.w, horizontal: 40.w),
        decoration: BoxDecoration(
            color: UIColors.GRADIENT_DARK_COLOR, borderRadius: BorderRadius.circular(40.w)),
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              device.name == '' ? "Unknown name" : device.name,
              style: TextStyle(fontSize: 40.w, color: Colors.white),
              textAlign: TextAlign.left,
            ),
            Text(
              _getConnectionState(stateIndex),
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 30.w, color: Colors.black45),
            ),
            Text(
              device.id.toString(),
              style: TextStyle(fontSize: 30.w, color: Colors.black45),
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ),
    );
  }

  void connectToDevice(BluetoothDevice device, BuildContext context) {
    context.bloc<ConnectedDeviceCubit>().setConnectedDevice(device, context);
  }

  Widget _disconnectedDeviceContainer(BluetoothDevice device, int stateIndex) {
    return Container(
        height: 200.h,
        margin: EdgeInsets.symmetric(vertical: 10.h),
        padding: EdgeInsets.symmetric(vertical: 20.w, horizontal: 40.w),
        decoration: BoxDecoration(
            border: Border.all(
              color: UIColors.GRADIENT_DARK_COLOR,
            ),
            borderRadius: BorderRadius.circular(40.w)),
        alignment: Alignment.centerLeft,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                device.name == '' ? "Unknown name" : device.name,
                style: informationTextStyle.copyWith(fontSize: 40.w),
                textAlign: TextAlign.left,
              ),
              Text(_getConnectionState(stateIndex),
                  textAlign: TextAlign.left, style: TextStyle(color: Colors.black, fontSize: 30.w)),
              Text(
                device.id.toString(),
                style: TextStyle(color: Colors.black, fontSize: 30.w),
                textAlign: TextAlign.left,
              ),
            ],
          ),
          FlatButton(
            color: Colors.black12,
            textColor: Colors.black,
            child: Text("Connect"),
            onPressed: () {
              try {
                device.connect();
              } catch (e) {
                print(e);
              }
            },
          )
        ]));
  }

  String _getConnectionState(int index) {
    switch (index) {
      case 0:
        return 'Disconneted';
        break;
      case 1:
        return 'Connecting';
        break;
      case 2:
        return 'Connected';
        break;
      case 3:
        return 'Disconnecting';
        break;
      default:
    }
  }

  TextStyle get informationTextStyle => TextStyle(color: UIColors.LIGHT_FONT_COLOR, fontSize: 50.w);

  Widget get _bleButton => CustomButton(
        onPressed: () {
          context.bloc<AvailableDevicesCubit>().toggleIsScanning();
          context.bloc<AvailableDevicesCubit>().getAvailableDevices();
          setState(() {
            isSearchingForBLE = true;
          });
        },
        text: "Reload devices",
      );

  @override
  bool get wantKeepAlive => true;
}
