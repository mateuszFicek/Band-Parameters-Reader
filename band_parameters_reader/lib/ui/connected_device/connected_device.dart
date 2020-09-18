import 'package:band_parameters_reader/repositories/connected_device/connected_device_cubit.dart';
import 'package:band_parameters_reader/utils/colors.dart';
import 'package:band_parameters_reader/widgets/boxes/square_box.dart';
import 'package:band_parameters_reader/widgets/connected_device/last_measurment_chart.dart';
import 'package:band_parameters_reader/widgets/boxes/decoration_box.dart';
import 'package:band_parameters_reader/widgets/information_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ConnectedDevicePage extends StatelessWidget {
  const ConnectedDevicePage({Key key}) : super(key: key);

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
              _newSessionAndHeartRateRow(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _deviceNameText(BluetoothDevice device) => InformationText(
      text: "Your device \n${device.name == '' ? device.id : device.name}");

  Widget _newSessionAndHeartRateRow() {
    return BlocBuilder<ConnectedDeviceCubit, ConnectedDeviceState>(
      builder: (context, state) => Container(
        height: MediaQuery.of(context).size.width / 2 - 90.w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SquareBox(
                child: Container(
                  child: Icon(
                    Icons.add,
                    size: 200.w,
                    color: Colors.white,
                  ),
                ),
                text: "Begin new session"),
            SquareBox(
              child: Container(
                child: Row(
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
              ),
              text: "Current heart rate",
            )
          ],
        ),
      ),
    );
  }
}
