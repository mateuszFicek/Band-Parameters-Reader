import 'package:band_parameters_reader/data/blue_manager.dart';
import 'package:band_parameters_reader/repositories/available_devices/available_devices_cubit.dart';
import 'package:band_parameters_reader/repositories/bluetooth_devices/bluetooth_devices_cubit.dart';
import 'package:band_parameters_reader/repositories/connected_device/connected_device_cubit.dart';
import 'package:band_parameters_reader/ui/bitalino/bitalino_screen.dart';
import 'package:band_parameters_reader/utils/colors.dart';
import 'package:band_parameters_reader/utils/constants.dart';
import 'package:band_parameters_reader/widgets/information_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BandParametersReaderHomePage extends StatefulWidget {
  const BandParametersReaderHomePage({Key key}) : super(key: key);

  @override
  _BandParametersReaderHomePageState createState() =>
      _BandParametersReaderHomePageState();
}

class _BandParametersReaderHomePageState
    extends State<BandParametersReaderHomePage> {
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
    return Scaffold(
      backgroundColor: UIColors.BACKGROUND_COLOR,
      body: Container(
        margin:
            EdgeInsets.only(top: 250.h, left: 60.w, right: 60.w, bottom: 140.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _welcomeText,
            _listOfDevicesText,
            _compatibleDevicesListView,
            _availableDevicesText,
            isSearchingForBLE
                ? _availableDevicesListView
                : _availableBluetoothListView,
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [_bleButton, _classicButton]),
            FlatButton(
              child: Text("Bitalino"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BitalinoScreen()),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Widget get _welcomeText => Container(
        alignment: Alignment.centerLeft,
        child: Text(
          "Welcome to \nParameters Reader",
          style: TextStyle(color: Colors.black, fontSize: 80.w),
          textAlign: TextAlign.left,
        ),
      );

  Widget get _listOfDevicesText =>
      InformationText(text: 'List of compatible devices:');

  Widget get _compatibleDevicesListView => Container(
        height: 70.h * Constants.COMPATIBLE_DEVICES.length,
        child: ListView.builder(
            padding: EdgeInsets.all(20.w),
            itemCount: Constants.COMPATIBLE_DEVICES.length,
            itemBuilder: (context, index) => Container(
                  margin: EdgeInsets.only(bottom: 10.h),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    Constants.COMPATIBLE_DEVICES[index],
                    style: TextStyle(color: Colors.black, fontSize: 30.w),
                  ),
                )),
      );

  Widget get _availableDevicesText => InformationText(
        text: 'Choose your device from available:',
      );

  Widget get _availableDevicesListView => Expanded(
        child: BlocBuilder<AvailableDevicesCubit, AvailableDevicesState>(
          builder: (context, state) => ListView.builder(
              itemBuilder: (context, index) => _availableDeviceContainer(
                  state.availableDevices.elementAt(index)),
              itemCount: state.availableDevices.length),
        ),
      );

  Widget get _availableBluetoothListView => Expanded(
        child: BlocBuilder<BluetoothDevicesCubit, BluetoothDevicesState>(
            builder: (context, state) {
          print(state.availableDevices.length);
          return ListView.builder(
              itemBuilder: (context, index) => Container(
                    width: 200,
                    height: 100,
                    child: Text(
                        "${state.availableDevices[index].address} --- ${state.availableDevices[index].name}"),
                  ),
              itemCount: state.availableDevices.length);
        }),
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
            color: UIColors.GRADIENT_DARK_COLOR,
            borderRadius: BorderRadius.circular(40.w)),
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
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.black, fontSize: 30.w)),
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

  TextStyle get informationTextStyle =>
      TextStyle(color: UIColors.LIGHT_FONT_COLOR, fontSize: 50.w);

  Widget get _bleButton => _buttonWrapper(() {
        context.bloc<AvailableDevicesCubit>().toggleIsScanning();
        context.bloc<AvailableDevicesCubit>().getAvailableDevices();
        setState(() {
          isSearchingForBLE = true;
        });
      }, 'Load BLE Devices');

  Widget get _classicButton => _buttonWrapper(() {
        context.bloc<BluetoothDevicesCubit>().getAvailableDevices(context);
        setState(() {
          isSearchingForBLE = false;
        });
      }, "Load classic");

  Widget _buttonWrapper(Function onTap, String buttonText) {
    return BlocBuilder<AvailableDevicesCubit, AvailableDevicesState>(
      builder: (context, state) => AbsorbPointer(
        absorbing: state.isScanning,
        child: Container(
          margin: EdgeInsets.only(top: 80.h),
          alignment: Alignment.center,
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40.w),
            child: InkWell(
              splashColor: UIColors.BACKGROUND_COLOR.withOpacity(0.2),
              onTap: onTap,
              borderRadius: BorderRadius.circular(40.w),
              child: Container(
                width: 350.w,
                height: 140.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40.w),
                    border: Border.all(
                      color: UIColors.LIGHT_FONT_COLOR,
                      width: 1.0,
                    )),
                child: Text(
                  buttonText,
                  textAlign: TextAlign.center,
                  style: _buttonTextStyle,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextStyle get _buttonTextStyle =>
      TextStyle(color: Colors.black, fontSize: 40.w);
}
