import 'package:band_parameters_reader/repositories/available_devices/available_devices_cubit.dart';
import 'package:band_parameters_reader/utils/colors.dart';
import 'package:band_parameters_reader/utils/constants.dart';
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
  String dropdownValue = 'Bitalino';

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
            _availableDevicesListView,
            _reloadButton,
          ],
        ),
      ),
    );
  }

  Widget _informationTextWrapper(String text) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(top: 60.h),
      child: Text(
        text,
        style: informationTextStyle,
      ),
    );
  }

  Widget get _welcomeText => Container(
        alignment: Alignment.centerLeft,
        child: Text(
          "Welcome to \nParameters Reader",
          style: TextStyle(color: Colors.white, fontSize: 80.w),
          textAlign: TextAlign.left,
        ),
      );

  Widget get _listOfDevicesText =>
      _informationTextWrapper('List of compatible devices:');

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
                    style: TextStyle(color: Colors.white, fontSize: 30.w),
                  ),
                )),
      );

  Widget get _availableDevicesText => _informationTextWrapper(
        'Choose your device from available:',
      );

  Widget get _availableDevicesListView => Expanded(
        child: BlocBuilder<AvailableDevicesCubit, AvailableDevicesState>(
          builder: (context, state) => ListView.builder(
              itemBuilder: (context, index) => _availableDeviceContainer(
                  state.availableDevices.elementAt(index)),
              itemCount: state.availableDevices.length),
        ),
      );

  Widget _availableDeviceContainer(BluetoothDevice device) {
    return GestureDetector(
      child: StreamBuilder<BluetoothDeviceState>(
          stream: device.state.asBroadcastStream(),
          initialData: BluetoothDeviceState.disconnected,
          builder: (c, snapshot) => snapshot.data.index == 2
              ? _connectedDeviceContainer(device, snapshot.data.index)
              : _disconnectedDeviceContainer(device, snapshot.data.index)),
    );
  }

  Widget _connectedDeviceContainer(BluetoothDevice device, int stateIndex) {
    return Container(
      height: 170.h,
      padding: EdgeInsets.symmetric(vertical: 20.w, horizontal: 40.w),
      decoration: BoxDecoration(
          color: UIColors.LIGHT_FONT_COLOR,
          borderRadius: BorderRadius.circular(40.w)),
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            device.name == '' ? "Unknown name" : device.name,
            style: TextStyle(fontSize: 40.w, color: Colors.black),
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
    );
  }

  Widget _disconnectedDeviceContainer(BluetoothDevice device, int stateIndex) {
    return Container(
      height: 170.h,
      padding: EdgeInsets.symmetric(vertical: 20.w, horizontal: 40.w),
      alignment: Alignment.centerLeft,
      child: Column(
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
              style: TextStyle(color: Colors.white, fontSize: 30.w)),
          Text(
            device.id.toString(),
            style: TextStyle(color: Colors.white, fontSize: 30.w),
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
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

  Widget get _reloadButton => _buttonWrapper(
      () => context.bloc<AvailableDevicesCubit>().getAvailableDevices(),
      'Reload Devices');

  Widget _buttonWrapper(Function onTap, String buttonText) {
    return Container(
      margin: EdgeInsets.only(top: 80.h),
      alignment: Alignment.center,
      child: Material(
        color: UIColors.LIGHT_FONT_COLOR,
        borderRadius: BorderRadius.circular(40.w),
        child: InkWell(
          splashColor: UIColors.BACKGROUND_COLOR.withOpacity(0.2),
          onTap: onTap,
          borderRadius: BorderRadius.circular(40.w),
          child: Container(
            width: 500.w,
            height: 140.h,
            alignment: Alignment.center,
            decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(40.w)),
            child: Text(
              buttonText,
              textAlign: TextAlign.center,
              style: _buttonTextStyle,
            ),
          ),
        ),
      ),
    );
  }

  TextStyle get _buttonTextStyle =>
      TextStyle(color: Colors.black, fontSize: 50.w);
}
