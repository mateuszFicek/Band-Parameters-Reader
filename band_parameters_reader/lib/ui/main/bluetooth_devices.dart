import 'package:band_parameters_reader/repositories/bluetooth_devices/bluetooth_devices_cubit.dart';
import 'package:band_parameters_reader/ui/bitalino/bitalino_measurment.dart';
import 'package:band_parameters_reader/utils/colors.dart';
import 'package:band_parameters_reader/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BluetoothDevices extends StatefulWidget {
  BluetoothDevices({Key key}) : super(key: key);

  @override
  _BluetoothDevicesState createState() => _BluetoothDevicesState();
}

class _BluetoothDevicesState extends State<BluetoothDevices>
    with AutomaticKeepAliveClientMixin<BluetoothDevices> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 1080, height: 2340);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _availableBluetoothListView,
        SizedBox(height: 32),
        _classicButton,
      ],
    );
  }

  Widget get _availableBluetoothListView => Expanded(
        child: BlocBuilder<BluetoothDevicesCubit, BluetoothDevicesState>(builder: (context, state) {
          return ListView.builder(
              itemBuilder: (context, index) =>
                  _availableDeviceContainer(state.availableDevices[index]),
              itemCount: state.availableDevices.length);
        }),
      );

  Widget get _classicButton => CustomButton(
        onPressed: () {
          context.bloc<BluetoothDevicesCubit>().getAvailableDevices(context);
        },
        text: "Odśwież",
      );

  Widget _availableDeviceContainer(BluetoothDevice device) {
    if (device.type.stringValue != 'classic') return Container();
    return device.isConnected
        ? _connectedDeviceContainer(device)
        : _disconnectedDeviceContainer(device);
  }

  Widget _connectedDeviceContainer(BluetoothDevice device) {
    return GestureDetector(
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
              device.name == '' ? "Brak nazwy" : device.name,
              style: TextStyle(fontSize: 40.w, color: Colors.white),
              textAlign: TextAlign.left,
            ),
            Text(
              device.address.toString(),
              style: TextStyle(fontSize: 30.w, color: Colors.black45),
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ),
    );
  }

  Widget _disconnectedDeviceContainer(BluetoothDevice device) {
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
                device.name == null ? "Brak nazwy" : device.name,
                style: informationTextStyle.copyWith(fontSize: 40.w),
                textAlign: TextAlign.left,
              ),
              Text(
                device.address,
                style: TextStyle(color: Colors.black, fontSize: 30.w),
                textAlign: TextAlign.left,
              ),
            ],
          ),
          FlatButton(
            color: Colors.black12,
            textColor: Colors.black,
            child: Text("Połącz"),
            onPressed: () async {
              try {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BitalinoMeasurment(address: device.address)));
              } catch (exception) {
                print('Cannot connect, exception occured');
              }
            },
          )
        ]));
  }

  TextStyle get informationTextStyle => TextStyle(color: UIColors.LIGHT_FONT_COLOR, fontSize: 50.w);

  @override
  bool get wantKeepAlive => true;
}
